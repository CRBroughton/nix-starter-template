# Nix Home Manager Starter Template

A beginner-friendly starter template for managing your Linux desktop environment with Nix.

## TL;DR - What is Nix?

Nix is a tool that manages your applications, settings, and entire system setup. (A "package manager" is software that installs and manages programs for you, but Nix does much more than that.)

Think of it like this:

**Traditional way:**
- Install apps one by one
- Tweak settings through various menus
- New computer? Do it all again manually
- Something breaks? Hope you remember what you changed

**With Nix:**
- List what you want in a text file
- Run one command to make it happen
- Same file works on any computer
- Broke something? Roll back to yesterday's setup

You're basically writing down your computer setup in simple config files. It sounds technical, but it's really just uncommenting lines like `# firefox` or adding app names to a list. Change the file, run a command, and your system updates to match.

## What is this?

This template helps you set up a reproducible desktop environment on Linux. Instead of manually installing apps and tweaking settings each time you set up a new computer, you define everything in configuration files. Then Nix makes it happen automatically.

**What you get:**
- Install applications via Flatpak (like Firefox, Spotify, etc.)
- Customize GNOME desktop settings (favourites, dark mode, etc.)
- Install GNOME extensions (tiling, blur effects, etc.)
- Everything saved in simple text files you can back up

## Who is this for?

Anyone using Linux with the GNOME desktop who wants:
- A cleaner way to manage applications
- Settings that survive across reinstalls
- The ability to replicate their setup on multiple computers

No prior Linux or Nix experience needed.

## Quick Start

### 1. Open a terminal

Search for "Terminal" or "Console" in your applications menu (usually accessible by pressing the Super/Windows key).

### 2. Install Nix

Nix is a package manager. Copy and paste this into your terminal:

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

After installation, close and reopen your terminal.

### 3. Get this template

Download this repository:

```bash
git clone <repository-url> my-nix-config
cd my-nix-config
```

### 4. Run the setup script

This automatically configures everything for your username:

```bash
./setup.sh
```

Follow the prompts. It will detect your username and home directory.

### 5. Commit your files to git

**Important:** Nix can only see files that are tracked by git. Before applying your configuration, you need to commit all your files:

```bash
git add .
git commit -m "Initial Nix configuration"
```

You'll need to do this every time you create new files. For changes to existing files, you can skip this step.

### 6. Apply your configuration

This installs everything and applies your settings:

```bash
nix run home-manager/master -- switch --flake .#your-username -b backup
```

Replace `your-username` with your actual username (the setup script will tell you the exact command).

**First time?** This may take a few minutes while Nix downloads everything.

## Making Changes

All your configuration lives in simple text files. Let's start with something easy.

### Challenge: Install Spotify

Let's install your first app! Open `modules/flatpak.nix` and add Spotify:

```nix
services.flatpak.packages = [
  "com.mattjakeman.ExtensionManager"
  "com.spotify.Client"            # Add this line!
];
```

**Find apps at:** [flathub.org](https://flathub.org)

The app ID is at the end of the URL. For example:
- `https://flathub.org/apps/com.spotify.Client` → use `"com.spotify.Client"`
- `https://flathub.org/apps/org.gimp.GIMP` → use `"org.gimp.GIMP"`

Then run:
```bash
home-manager switch --flake .
```

Spotify should now appear in your applications menu! (You may need to log out and back in if it doesn't appear immediately.)

### Challenge: Install htop

Now let's install a command-line tool! Open `modules/packages.nix` and uncomment `htop`:

```nix
home.packages = with pkgs; [
  # Example packages - uncomment or add your own:

  # Development tools
  # git
  # vim

  # Terminal utilities
  htop              # Uncomment this line!
  # tree
];
```

**Find packages at:** [search.nixos.org/packages](https://search.nixos.org/packages)

Then run:
```bash
home-manager switch --flake .
```

Now open a new terminal and type `htop` to see your system resources in real-time! Press `q` to quit.

**Nix vs Flatpak - Which to use?**
- **Nix packages**: Command-line tools, development tools, system utilities
- **Flatpak**: Desktop applications with GUIs

**Note:** After installing Nix packages, restart your terminal to use them. GUI apps may require logging out and back in.

### Customize GNOME

Open `modules/gnome.nix` to change desktop settings:

```nix
dconf.settings = {
  "org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";  # Dark mode
  };
  "org/gnome/shell" = {
    favorite-apps = [
      "org.gnome.Nautilus.desktop"
      "org.mozilla.firefox.desktop"
    ];
  };
};
```

### Install GNOME Extensions

After running `home-manager switch --flake .`, install extensions:

```bash
install-gnome-extensions
```

Then log out and back in to activate them.

**Find extensions at:** [extensions.gnome.org](https://extensions.gnome.org)

To add more extensions, edit `modules/gnome-extensions-installer.nix`:
1. Find the extension page (e.g., `https://extensions.gnome.org/extension/3843/tiling-shell/`)
2. Locate the download link for the `.zip` file
3. Add a new install line in the script with the download URL

### Apply Your Changes

After editing any `.nix` file:

```bash
just switch
```

Or the longer form:

```bash
home-manager switch --flake .
```

## Using Just (Command Runner)

### What is Just?

Just is a simple tool that gives you shortcuts for common commands. Instead of typing long commands like `home-manager switch --flake .`, you can just type `just switch`.

Think of it like having a cheat sheet built into your terminal - you type short, easy-to-remember commands, and Just runs the full command for you.

### Why Use It?

**Without Just:**
```bash
# You'd need to remember and type these:
home-manager switch --flake .
nix flake update && home-manager switch --flake .
home-manager expire-generations "-7 days" && nix-collect-garbage --delete-old
```

**With Just:**
```bash
# Much simpler:
just switch
just update
just clean
```

It's especially helpful when you're learning - you don't need to memorise long commands.

### View All Available Commands

To see everything Just can do for you:

```bash
just
```

This shows you all the shortcuts available, like a menu.

### Common Commands

Here are the commands you'll use most often:

```bash
# Apply your configuration changes
just switch

# Search for a package
just search firefox

# Add a package to your config
just add firefox

# Remove a package
just remove firefox

# Update all your packages
just update

# Clean up old versions to free space
just clean

# Format your Nix files (make them neat)
just format

# Install GNOME extensions
just install-extensions
```

**Tip:** If you ever forget these commands, just type `just` and it will show you the full list!

### Want to Learn More?

The `justfile` is just a text file in your config folder. Open it up and take a look! You'll see how each command works - it's a great way to learn what's happening behind the scenes.

**Challenge:** Try adding your own command! For example, you could add a command that shows how much disk space your Nix store is using:

```bash
# Add this to your justfile:
disk-usage:
    du -sh /nix/store
```

Then you can run `just disk-usage` anytime! The [Just documentation](https://github.com/casey/just) has more examples to help you get started.

## Common Tasks

### Update Everything

```bash
just update
```

Or manually:

```bash
nix flake update
home-manager switch --flake .
```

### Back Up Your Configuration

Your entire setup is in text files, so backing up is simple:

**Option 1: Git (Recommended)**
```bash
cd ~/my-nix-config
git init
git add .
git commit -m "My Nix configuration"
git remote add origin <your-repo-url>
git push -u origin main
```

Free hosting: [GitHub](https://github.com), [GitLab](https://gitlab.com), [Codeberg](https://codeberg.org)

**Option 2: USB Stick**
```bash
cp -r ~/my-nix-config /path/to/usb/stick/
```

Store the entire folder somewhere safe. To restore on a new system:
1. Install Nix first (see installation steps above)
2. Copy the folder back to your home directory
3. **If your username is different on the new system**, run `./update-username.sh` to update the configuration
4. Run `home-manager switch --flake .`

### Clean Up Old Versions

Free up disk space by removing old configurations:

```bash
just clean
```

Or manually:

```bash
nix-collect-garbage --delete-old
```

### Start Fresh

If something breaks, revert to a previous version:

```bash
home-manager generations        # List all versions
home-manager switch --flake .   # Latest version
```

## Understanding the Files

```
my-nix-config/
├── flake.nix           # Defines where Nix gets packages from
├── home.nix            # Your main configuration file
├── justfile            # Command runner with helpful shortcuts
├── modules/
│   ├── packages.nix    # Nix packages to install
│   ├── flatpak.nix     # Flatpak apps to install
│   ├── gnome.nix       # GNOME desktop settings
│   └── gnome-extensions-installer.nix  # Extension installer script
└── setup.sh            # Initial setup script (run once)
```

You'll mostly edit files in `modules/`:
- **packages.nix** - Command-line tools and dev tools via Nix
- **flatpak.nix** - GUI applications via Flatpak
- **gnome.nix** - Desktop appearance and behavior

## Troubleshooting

### Flatpak apps don't appear

Add Flathub as a source:

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

Then run `home-manager switch --flake .` again.

### GNOME extensions won't load

After running `install-gnome-extensions`:
- **Wayland:** Log out and log back in
- **X11:** Press `Alt+F2`, type `r`, press Enter

### Changes aren't applying

Make sure you ran:

```bash
home-manager switch --flake .
```

## Going Further

Once you're comfortable, you can:
- Add more modules for different programs
- Install packages directly via Nix (not just Flatpak)
- Manage shell configurations, git settings, and more
- Share your config across multiple computers

Check the [Home Manager manual](https://nix-community.github.io/home-manager/) for more options.

## Getting Help

- [Nix Pills](https://nixos.org/guides/nix-pills/) - Learn Nix concepts
- [Home Manager Options](https://nix-community.github.io/home-manager/options.xhtml) - See what you can configure
- [NixOS Discourse](https://discourse.nixos.org/) - Community forum
- [r/NixOS](https://www.reddit.com/r/NixOS/) - Reddit community
