<p align="center">
  <img src="assets/app_icon.png" width=200 height=200><br><img alt="GitHub Release" src="https://img.shields.io/github/v/release/Ashenite/Drift">
</p>

# Drift
Yet another remote controller app for your rc car. 

# Speciality
1. Setup Team Name & Logo
2. No need to change code on reciever's end to switch from other apps. **Drift** uses the same signal as other popular applications.

# Features
1. Basic Movement
2. Headlight/Tail Lights On/Off
3. Speed (0-9 & Full)

# Get Started
### Installation
Go to [Release](https://github.com/Ashenite/Drift/releases) tab. Download and install apk that suits your device. 
<details>
<summary> I know my CPU architecture (ARM, ARM64, x86) </summary>
- `armeabi-v7a` for ARM (ARMv7 or armeabi)
- `arm64-v8a` for ARM64 (AArch64 or arm64)
- `x86_64` for X86 (x86 or x86abi)
</details>
<details>
<summary> I don't know my CPU architecture </summary>
- campatibility
</details>

The download size will differ but after installation all of them will result in same size. Also shouldn't cause any other differences.

### Permissions
App will ask 2 Permissions:
1. Bluetooth for obvious reason.
2. Nearby Devices / Location (To find your reciever)

### Splash Screen
**Drift** will ask necessary permissions and request to enable bluetooth. And check if you are running this app for the first time or not.
<img src="https://github.com/Ashenite/Drift/assets/72933395/39a35f5f-407b-4838-98a0-39772fcf7376" height="500">

### Setup Screen
You will see this screen only and only if you are running this app for the first time.

<img src="https://github.com/Ashenite/Drift/assets/72933395/625fecfc-b1a0-49cb-9cdb-3b0e2b2c7747" height="500">

Click on the image to choose a logo for your team from gallery.
Write your team name in the text box.

Clicking `Submit` button will create 2 local files for these two informations.

> To change team name & logo, clear the data of this app from Device Settings / App info

### Devices List Screen
It will show already paired devices. If you do not see your reciever, Go to bluetooth settings of your device and pair with that.
<img src="https://github.com/Ashenite/Drift/assets/72933395/44211656-cffa-4294-a932-9e7848967073" height="500">

Tap on the device you want to connect with.

### Control Screen
You should see your team logo and name on the top. Also the name of your connected device. The Red/Green circle next to it indicates connections status. Green means ready to go. Red-Green blinking means we are trying to connect.

<img src="https://github.com/Ashenite/Drift/assets/72933395/7a613450-0de7-44ee-afb8-b45e0351523d" height="500">

To disconnect, simply go back (back button or go back gesture of your phone). It will take you to [Device List Screen](#Devices-List-Screen).
You will also be automatically taken there if somehow we lose connection with your reciever.

The silder is your speed limiter. It has 11 levels: from 1 to 10 and `FUll`.

Right light indicator is for Tail lights. Left one is for Head lights.

The direction buttons are self-explanatory. You can tap two buttons at the same time to go diagonally. Pressing two opposite direction at the same time will take only the first instruction and ignore second one.

# Signals
Signals are transmitted every 50 milliseconds.

Instruction | Signal (`char` type)
-|-
Speed Level: 1-10 | '0' - '9'
Speed Level: Full | 'q'
Head light: On | 'W'
Head light: Off| 'w'
Tail light: On | 'V'
Tail light: Off| 'v'
Forward | 'F'
Backward | 'B'
Left | 'L'
Right | 'R'
Forward-Left | 'G'
Forward-Right | 'I'
Backward-Left | 'H'
Backward-Right | 'J'

If no instruction is send it will keep sending stop signal. Which is `S` in this case.

# Supported Technologies
- [x] Bluetooth Classic
- [ ] Bluetooth Low energy
- [ ] Wi-Fi

# Supported Devices
- [x] HC-05

# Known Issues
- While pressing two opposite direction, it won't catch the second instruction which is intended. But it doesn't switch to second instruction after first one is releases.

# Future Plan
- [ ] Support for other technologies
- [ ] More controls
- [ ] Allow both landscape and potrait mode
- [ ] Better UI

# Credits
- [Fida Zaman](https://github.com/FidaZaman): For UI instructions
- [Tanmay Saha](https://github.com/tanmay-sh/): For app icon

## Other Attributions
- <a href="https://www.flaticon.com/free-icons/headlight" title="headlight icons">Headlight icons created by ultimatearm - Flaticon</a>
- <a href="https://www.flaticon.com/free-icons/arrows" title="arrows icons">Arrows icons created by Pixel perfect - Flaticon</a>
