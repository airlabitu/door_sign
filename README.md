# door_sign
AIR LAB door sign display


Install processing by going to the terminal and typing this command:
- curl https://processing.org/download/install-arm.sh | sudo sh

Launch Processing

Download the project from the AIR LAB GitHub : https://github.com/airlabitu/door_sign

Save the two folders (door_sign) and (date_grabber) in the Processing home folder: /home/pi/sketchbook

Create two empty folders callsed "this_week" and "next_week" under "/Home/pi/Documents"

Setup the autostart of the "door_sign.pde" program by typing the following command in a Terminal window:
- sudo nano /etc/xdg/lxsession/LXDE-pi/autostart
- Then adding the following line at the end of the file:
	- @processing-java --sketch=/home/pi/sketchbook/door_sign --run

Setting up nightly reboots using 'cron'
- open terminal
- open cron: crontab -e
- enter the following at the end of the document: 59 23 * * * sudo reboot
	- read more about cron here: raspberrypi.org/documentation/linux/usage/cron.md 

Rotate the PIs screen output to fit a vertical screen
- Edit the confog.txt file
	- Open file: sudo nano /boot/config.txt
	- Add the following line at the bottom: display_rotate=1
	- Exit and save: first (ctrl+x) then (shift+y)

NB
If the PI gets turned on by cutting the power it will start to give a prompting dialo box when
running. Disable this the following way:
- Open any folder, and go to the menu: edit -> preferences
- In the general tab check the box "Don't ask options on launch executable file"
