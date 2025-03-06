# Setting up the "Door sign" project on a Raspberry Pi

1. Start by exporting the Processing sketch in this repository
2. Move the exported program to the Pi (Desktop will work)
3. Copy the file "pic.png" and put it just under the exported folder e.g. "linux-aarch64" next to the executable called "door_sign".
4. Try to manually execute the exported app, to see that it works.
5. Then use Method 2 of the guide below to setup the Pi to automatically launch it at boot. Remember to edit the file path ;-)
6. Then reboot the Pi, and everything should work.


## Automating a Processing program at boot on a Raspberry Pi (found with ChatGPT)
NB: Option 1 have not been tested... we used method 2 since we are setting it up on an OS with GUI. See ChatGPT comment at the bottom.


To run a Processing sketch automatically when a Raspberry Pi boots up, you can set up a system service or modify the autostart settings. Here’s how you can do it:

### Option 1: Using `systemd` to create a service
`systemd` is the system and service manager for Linux. You can create a custom service to run your Processing sketch at boot.

1. **Write the Processing code**: Ensure that your Processing sketch is saved and ready to be executed. For example, save your sketch as `mySketch.pde` and compile it into an executable using Processing IDE.

2. **Compile the Processing Sketch**: In Processing, you can use the **Export Application** option to compile your sketch into a standalone application. 

   - Open the sketch in the Processing IDE.
   - Go to **Sketch → Export Application**.
   - Choose the operating system (Linux) and ensure that you get the `.elf` executable.

3. **Create a systemd service**:

   - Open a terminal on the Raspberry Pi.
   - Create a new service file for your sketch:
     ```bash
     sudo nano /etc/systemd/system/run_processing_sketch.service
     ```
   
   - Add the following content to the file, adjusting the paths accordingly:
     ```ini
     [Unit]
     Description=Run Processing Sketch at Boot
     After=network.target

     [Service]
     ExecStart=/home/pi/processing-sketch/mySketch-linux-armv7l/mySketch
     WorkingDirectory=/home/pi/processing-sketch/mySketch-linux-armv7l
     User=pi
     Group=pi
     Restart=always

     [Install]
     WantedBy=multi-user.target
     ```

   **Explanation of each section**:
   - `ExecStart`: The path to your compiled Processing sketch.
   - `WorkingDirectory`: The directory where your compiled sketch is located.
   - `User` and `Group`: The user and group that the sketch will run under (typically `pi` for Raspberry Pi).
   - `Restart`: Ensures the sketch restarts if it crashes.

4. **Enable and start the service**:
   After creating the service file, enable and start the service with the following commands:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable run_processing_sketch.service
   sudo systemctl start run_processing_sketch.service
   ```

5. **Reboot to test**:
   Now, reboot your Raspberry Pi:
   ```bash
   sudo reboot
   ```

   Your Processing sketch should now run automatically on boot.

### Option 2: Using `~/.config/autostart` (GUI method)
If you're running a GUI on the Raspberry Pi, you can also set up the sketch to run automatically by adding it to the autostart folder.

1. **Prepare the executable**: Ensure your compiled Processing sketch is ready and placed in a directory (e.g., `/home/pi/processing-sketch/mySketch-linux-armv7l/`).

2. **Create an autostart entry**:
   - Open a terminal and run:
     ```bash
     mkdir -p ~/.config/autostart
     nano ~/.config/autostart/processing-sketch.desktop
     ```
   - Add the following content to the file:
     ```ini
     [Desktop Entry]
     Name=Processing Sketch
     Exec=/home/pi/processing-sketch/mySketch-linux-armv7l/mySketch
     Type=Application
     X-GNOME-Autostart-enabled=true
     ```

3. **Reboot**:
   After saving the file, reboot your Raspberry Pi:
   ```bash
   sudo reboot
   ```

Your Processing sketch should now launch automatically after logging into the Raspberry Pi desktop.

---

Both methods should work depending on whether you're using the Raspberry Pi in a headless mode (Option 1) or with a GUI (Option 2). Let me know if you need further clarification!