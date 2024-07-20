# arch-setup

1. Copy the install scripts into the root of the Arch install USB

2. Mount it to `/mnt/usb`
    ```sh
    $ lsblk # to see the name of the USB partition
    $ mount /dev/[usb partition] /mnt/usb
    ```

3. Run the first script
    ```sh
    $ /mnt/usb/jake-arch-install-1.sh
    ```
   At the end of that you will have `chroot`ed from the installation environment into the machine's hard drive

4. Run the second script, which has now been installed on the machine
    ```sh
    $ jake-arch-install-2.sh
    ```

5. At this point Arch is installed :tada:, so reboot into it

6. Run the final setup script
    ```sh
    $ jake-arch-install-3.sh
    ```
   
