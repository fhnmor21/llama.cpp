# Ubuntu 24.04 Distrobox on Bazzite

These steps assume a rootless box named `ubuntu-24-04` and a user named `bazzite`. Change these names if yours differ.

Create the box, then test `sudo`. Apply the fix in step 3 only if `sudo` doesn't work.

## 1. Create and enter the box

Run on the Bazzite host. Don't put `sudo` in front of these commands.

```bash
distrobox create --name ubuntu-24-04 --image docker.io/library/ubuntu:24.04
distrobox enter ubuntu-24-04
```

Let the first `enter` finish completely, and note any errors.

## 2. Test sudo

Run inside the box:

```bash
sudo apt update
sudo apt upgrade
```

If both work, you're done. If `sudo` is missing or denies access, type `exit` to return to the host and continue to step 3.

## 3. Fix sudo access

On the host, open a root shell in the box:

```bash
podman start ubuntu-24-04
podman exec -it -u root ubuntu-24-04 bash
```

In that root shell, set the path and check the OS:

```bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
grep PRETTY_NAME /etc/os-release
```

Stop if it doesn't show Ubuntu 24.04. Otherwise, check that your user exists and install `sudo`:

```bash
id bazzite
apt update
apt install -y sudo
```

Continue only if all three commands succeed. Then grant your user passwordless sudo:

```bash
mkdir -p /etc/sudoers.d
echo "bazzite ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-distrobox-user
chmod 440 /etc/sudoers.d/90-distrobox-user
/usr/bin/visudo -cf /etc/sudoers.d/90-distrobox-user
```

The last command should report that the file is OK.

- If `visudo` isn't found, try `/usr/bin/visudo` (this worked last time) or `/usr/sbin/visudo`.
- If it reports an error in the file, run `rm /etc/sudoers.d/90-distrobox-user`, check the username, and repeat the block above.

Type `exit` to return to the host. Then enter the box and test again:

```bash
distrobox enter ubuntu-24-04
sudo apt update
sudo apt upgrade
```

## Troubleshooting

- **`Permission denied` on `/var/lib/apt/lists/lock`:** run `apt` with `sudo` inside the box. Don't delete the lock file or change permissions in `/var/lib/apt`.
- **`usermod: command not found`:** you don't need `usermod`. The sudoers file in step 3 grants access.
- **`id bazzite` says no such user:** check your username with `whoami` on the host. If it's correct, the box setup probably didn't finish. Check `podman logs ubuntu-24-04` on the host.
- **Broken or half-configured packages:** in the root shell, run `dpkg --configure -a`, then `apt -f install`.
- **Network or DNS errors:** fix these before recreating the box, as they're likely to happen again.

## Last resort: recreate the box

**This deletes the container, including packages and files stored only inside it.** Back up anything you need first. Your shared home directory stays.

Run on the host, then start again from step 1:

```bash
distrobox rm -f ubuntu-24-04
```

When installing ROCm 7.2.4 inside an Ubuntu 24.04 Distrobox, skip installing amdgpu-dkms and kernel headers inside the container and install only the user-space rocm packages instead, because Distrobox shares the host's Linux kernel and GPU driver.

# Installing Rocm

1. Host Prerequisites

Before entering your Distrobox, verify two things on your host OS:
• Kernel Driver: Your host must already have the amdgpu kernel driver loaded (lsmod | grep amdgpu). Do not install amdgpu-dkms inside Distrobox—it will fail to build kernel modules or bloat the container.
• Device Access: Create or run your Distrobox with /dev/kfd and /dev/dri passed through (or rootful/privileged flags if needed):

``` bash
distrobox create -n rocm-box -i ubuntu:24.04 --additional-flags "--device=/dev/kfd --device=/dev/dri"
```
Use code with caution.
(If your container already exists, ensure /dev/kfd and /dev/dri exist inside it via ls -l /dev/kfd /dev/dri.)

2. Register the ROCm 7.2.4 Repository (Inside Distrobox)

Enter your Distrobox (distrobox enter rocm-box), download the ROCm 7.2.4 installer package for Ubuntu 24.04, and update apt:
```bash
sudo apt update && sudo apt install -y wget cmake  libssl-dev
wget https://repo.radeon.com/amdgpu-install/7.2.4/ubuntu/noble/amdgpu-install_7.2.4.70204-1_all.deb
sudo apt install -y ./amdgpu-install_7.2.4.70204-1_all.deb
sudo apt update
```
Use code with caution.

3. Install ROCm User-Space Packages

Install the rocm meta-package along with python3-setuptools and python3-wheel (omitting amdgpu-dkms):
```bash
sudo apt install -y python3-setuptools python3-wheel rocm
```
Use code with caution.
(If you only need specific components like HIP or OpenCL without the full suite, you can run sudo amdgpu-install --usecase=rocm --no-dkms instead.)

4. Configure Group Permissions and Environment

Even though Distrobox maps your host user, you must ensure your user inside the container belongs to the render and video groups matching the host's /dev/kfd and /dev/dri/renderD* GIDs:
```bash
sudo usermod -a -G render,video $USER
```
Use code with caution.
Add ROCm binaries to your PATH and library path inside the container (~/.bashrc):
```bash
echo 'export PATH=$PATH:/opt/rocm/bin' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/rocm/lib' >> ~/.bashrc
source ~/.bashrc
```
Use code with caution.

5. Restart the Distrobox and Verify

Exit the container, stop it from the host so group memberships reload, and enter it again:
```bash
exit
distrobox stop rocm-box
distrobox enter rocm-box
```
Use code with caution.
Run rocminfo inside the container to verify that your AMD GPU is detected.
If you want, I can:
• Help troubleshoot GID mismatches if rocminfo throws a permission error on /dev/kfd
• Show how to set HSA_OVERRIDE_GFX_VERSION if you're running an unofficially supported Radeon GPU
• Give you the commands to install PyTorch for ROCm inside this Distrobox
