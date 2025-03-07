#!/nix/store/zv1kaq7f1q20x62kbjv6pfjygw5jmwl6-python3-3.12.7/bin/python3

import tkinter as tk
from tkinter import simpledialog, filedialog, messagebox
import subprocess
import os
import json

class FlasherApp:
    def __init__(self, root):
        print("Initializing FlasherApp...")  # Debug
        self.root = root
        self.root.title("NemoDex USB Flasher")
        self.root.configure(bg='black')

        self.create_widgets()
        print("FlasherApp initialized.")  # Debug

    def create_widgets(self):
        print("Creating widgets...")  # Debug
        # ISO Label
        self.iso_label = tk.Label(self.root, text="No ISO file selected", bg='black', fg='#CFA34D')
        self.iso_label.pack(pady=10)

        # Browse ISO Button
        self.browse_button = tk.Button(self.root, text="Browse ISO", command=self.open_file_dialog, bg='#CFA34D', fg='black')
        self.browse_button.pack(pady=10)

        # USB Drive Label
        self.usb_label = tk.Label(self.root, text="Select USB Drive:", bg='black', fg='#CFA34D')
        self.usb_label.pack(pady=10)

        # USB Drive Dropdown
        self.usb_combobox = tk.Listbox(self.root, bg='#CFA34D', fg='black')
        self.update_usb_drives()
        self.usb_combobox.pack(pady=10)

        # Flash Button
        self.flash_button = tk.Button(self.root, text="Flash ISO to USB", command=self.flash_iso, bg='#CFA34D', fg='black')
        self.flash_button.pack(pady=10)

        # Status Label
        self.status_label = tk.Label(self.root, text="", bg='black', fg='#CFA34D')
        self.status_label.pack(pady=10)
        print("Widgets created.")  # Debug

    def open_file_dialog(self):
        iso_path = filedialog.askopenfilename(filetypes=[("ISO files", "*.iso")])
        if iso_path:
            self.iso_label.config(text=iso_path)

    def update_usb_drives(self):
        print("Updating USB drives...")  # Debug
        self.usb_combobox.delete(0, tk.END)  # Clear the listbox

        # Use lsblk to detect removable USB drives
        try:
            result = subprocess.run(['lsblk', '-o', 'NAME,TRAN,MOUNTPOINT', '-J'], capture_output=True, text=True, check=True)
            devices = json.loads(result.stdout)
            for device in devices['blockdevices']:
                if device['tran'] == 'usb':
                    # Check if any of the partitions are mounted
                    mounted_partitions = [child for child in device.get('children', []) if child['mountpoint']]
                    if mounted_partitions:
                        usb_partition = f"/dev/{mounted_partitions[0]['name']}"
                        print(f"Detected mounted USB partition: {usb_partition} with mountpoint {mounted_partitions[0]['mountpoint']}")  # Debug
                        self.usb_combobox.insert(tk.END, usb_partition)
        except subprocess.CalledProcessError as e:
            print(f"Error detecting USB drives: {e}")  # Debug

        print("USB drives updated.")  # Debug

    def flash_iso(self):
        print("Starting flash process...")  # Debug
        iso_path = self.iso_label.cget("text")
        usb_drive = self.usb_combobox.get(tk.ACTIVE)
        if not iso_path or iso_path == "No ISO file selected":
            messagebox.showwarning("Warning", "Please select an ISO file.")
            return
        if not usb_drive:
            messagebox.showwarning("Warning", "Please select a USB drive.")
            return

        # Prompt for the sudo password
        password = simpledialog.askstring("Password", "Enter your sudo password:", show='*')
        if not password:
            messagebox.showwarning("Warning", "Please enter your password to proceed.")
            return

        self.status_label.config(text="Flashing...")
        self.root.update_idletasks()

        # Execute the flashing process
        try:
            print(f"Unmounting {usb_drive}...")  # Debug
            subprocess.run(['sudo', '-S', 'umount', usb_drive], input=f"{password}\n", text=True, check=True)
            print(f"Writing ISO to {usb_drive}...")  # Debug
            subprocess.run(['sudo', '-S', 'dd', f'if={iso_path}', f'of={usb_drive}', 'bs=4M', 'status=progress', 'conv=fsync'], input=f"{password}\n", text=True, check=True)
            print("Flashing complete.")  # Debug
            self.status_label.config(text="Flashing complete!")
        except subprocess.CalledProcessError as e:
            print(f"Flashing failed: {e}")  # Debug
            self.status_label.config(text="Flashing failed!")
            messagebox.showerror("Error", f"Flashing failed: {e}")

if __name__ == "__main__":
    print("Starting application...")  # Debug
    root = tk.Tk()
    app = FlasherApp(root)
    root.mainloop()
    print("Application started.")  # Debug
