# SignControl

SignControl is a cli utility that controls Symon NetBrite LED signs. Huge thanks
to [kevinbosak](https://github.com/kevinbosak/Net-Symon-Netbrite).

## Installation Instructions

1. **Set Up Network:** Ensure your device is on the same subnet as the sign. For
   example, add an IP address to your Ethernet interface:
   ```sh
   sudo ip addr add 10.164.3.86/24 dev enp0s25 # Replace with your interface
   ```
   This configures your device to communicate with the sign.

### Debian

I'm not completely sure about this one, I don't use debian.

2. **Install Perl Dependencies:** On a Debian-based system, install the required
   packages:
   ```sh
   sudo apt install libmodule-build-perl libdigest-crc-perl
   ```

3. **Build and Install the Module:**
   ```sh
   perl Build.PL ./Build installdeps # Installs any additional dependencies
   ./Build manifest # Generates the MANIFEST file
   ```
   These steps prepare the module for use. If you're building from source,
   ensure you have Perl 5.10 or later.

### NixOS

You should know this one.

```sh
nix run github:jsw08/signcontrol -- parameters
```

## Usage

To send messages to the sign, edit and run the provided script (e.g.,
`signboard`). Example:

```sh
signboard --address 10.164.3.87 --zone zone1="x=0,y=0,width=20,height=5" --zone
zone2="x=10,y=10,width=10,height=10" --message zone1="Hello {scrolloff}"
--message zone2="World {red}"
```

- Replace `10.164.3.87` with your sign's IP address.
- Define zones with `--zone zonename="x=0,y=0,width=20,height=5"`.
- Provide messages with `--message zonename="Text with formatting"`.
- I reccommend adding `{erase}` to the beginning of your first message. This
  will prevent glitches when changing the text.

### Flags

- `--zone zonename=""`: See the heading zones below.
- `--message zonename=""`: string with formatting options (see heading below).
- `--address`: IP Address
- `--priority`: The message priority determines how the new message will replace
  an existing one. The default is PRI_OVERRIDE, but can also be PRI_FOLLOW,
  PRI_INTERRUPT, PRI_YIELD or PRI_ROUNDROBIN.
- `--"activation_delay`: Message activation delay in milliseconds. Default is 0.
- `--display_delay`: Message display delay in milliseconds. Default is 0.
- `--display_repeat`: Not really sure. The default is 0.
- `--ttl`: The message will self-destruct in x seconds. Default is 0.
- `--sound_alarm`: If true, the sign will beep when the message is displayed.

### Message Formatting

Messages support inline markup for dynamic effects. Include these tags directly
in your message text:

- **Scrolling**: `{scrolloff}` (turns off), `{scrollon}` (turns on).
- **Blinking**: `{blinkon}` (turns on), `{blinkoff}` (turns off).
- **Color**: `{red}`, `{green}`, `{yellow}`.
- **Alignment**: `{left}`, `{center}`, `{right}`.
- **Pause**: `{pause}` (pauses display).
- **Erase**: `{erase}` (clears content).
- **Serial Number**: `{serial}` (inserts sign's MAC address).
- **Beep**: `{bell}` (It _should_ beep, but when I tried it it paused the text
  at the end).
- **Note**: `{note [pitch] [duration]}` (e.g., `{note 100 500}` for a 100 Hz
  tone lasting 500 ms).
- **Tune**: `{tune [1-9] ["repeat"]}` (e.g., `{tune 9}` for Charge!; add
  "repeat" for looping).
- **Font**: `{font [font_name]}` (switches font; see below).

### Available Fonts

The following fonts can be used with `{font [font_name]}`:

- monospace_7
- monospace_16
- monospace_24
- proportional_7
- proportional_5
- proportional_9
- proportional_11
- bold_proportional_7
- bold_proportional_11
- script_16
- picture_24

Note: Ensure the font fits within the zone's height to avoid issues.

### Zone Parameters

To create a zone, add the `--zone` flag with the parameters in the following
format:

```
--zone name="param1=0,param2=0"
```

- `x:` The X coordinate to start the zone, required.

- `y:` The Y coordinate to start the zone, required.

- `width:` The zone width, required.

- `height:` The zone height, required.

- `scroll_speed:` The speed of scrolling text in the zone. The default is
  `SCROLL_MED`, but can also be `SCROLL_SLOW` or `SCROLL_FAST`.

- `pause_duration:` The duration in milliseconds of any pause sequences in the
  message text.

- `volume:` The volume of beeps, notes, alarms, and other noises. Valid range is
  0 (off) to 8 (deadly). Default is 4.

- `default_font:` The default font. See 'Available Fonts'

- `default_color:` The default color. Can be `COLOR_RED`, `COLOR_GREEN`, or
  `COLOR_YELLOW`. The default is red.

- `initial_text:` The text initially displayed in the zone. This is just "." by
  default.
