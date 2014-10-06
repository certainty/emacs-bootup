# Emacs-Bootup

This is my attempt to structure my emacs-files. My specific needs are that I use Emacs both at home and at work. I want it to behave
basically the same but of course I have environment specific settings.

Also I wanted a way to steer when files are loaded during the boot. I figured that some files are very basic and need to go before
any other files.

The way i solved it is basically two things:

* profiles
* runlevels

## Quickstart

Just clone the repository into your .emacs.d directory. For example you can do this:

    hg clone ssh://hg@bitbucket.org/certainty/emacs-bootup ${HOME}/.emacs.d/bootup

Please be sure to make a backup of your existing directory!
Once you've done this all you need to do is create the profiles structure like so:

    mkdir -p ~/.emacs.d/profiles/_shared/runlevel{0..2}
    mkdir -p ~/.emacs.d/profiles/your_profile/runlevel{0..2}
    mkdir -p ~/.emacs.d/profiles/your_profile/vendor
    ln -s ~/.emacs.d/profiles/your_profile ~/.emacs.d/profiles/active

The above creates a directory for you profile with the standard runlevels. Also it creates a vendor directory
inside your profile. Furthermore it create a _shared-profile. This is a convention I use to put configuration
in there that is shared among different profiles. I simply symlink the files there to my different profiles.

Finally you have to enable bootup by symliking init.el

    ln -s ~/.emacs.d/bootup/init.el ~/.emacs.d/init.el

Now you're set and emacs should load up with the bootup configuration.

## Details

### Profiles

A profile holds environment specific settings. A profile is represented by a directory that has the following content.

     profile-dir
       |
       |- alpha.el
       |- custom.el
       |- omega.el
       |- vendor
       |- runlevel0
       |- runlevel1
       |- runlevel2

Runlevel0-2 are directories that may hold your elisp files. The rest of the files are used to do pre- and post-actions to the boot-process.
The custom-file holds custom settings.

#### Active Profile

In order to activate a profile you need to create  symlink into the profiles-directory.

    ln -s ~/.emacs.d/profiles/my-profile ~/.emacs.d/profiles/active

#### Alpha and Omega

Each profile may contain an alpha and an omega file. Those are named
*alpha.el* and *omega.el* and have to be placed in the profile's root directory.
These can be used to do something at the very start or the very end of the boot-process
accordingly.

The alpha-file will be loaded before any other file whereas the omega-file is loaded
after all other files have been loaded.

#### The vendor directory

Each profile may contain a vendor directory where third-party libraries can be installed.
This directory has already been added to your load-path by bootup.

### The shared profile

You might have noticed in the quickstart, that we created a profile called _shared.
This is for cases where you have files that you need in all other profiles.
Just put those files there and *symlink* them into your active-profile.

### Runlevels

Currently there are three runlevels, which you can use to drive the order of evaluation of your
configuration files. This is really easy as you just have to place the files that should go before
other files in the runlevel that goes before the other.

## Boot-Process

The bootprocess is as follows:

* load active profile's alpha.el if it exists
* load active profile's runlevels
* load active profile's custom.el if it exists
* load active profile's omega.el if it exists

## Elisp

The following bindings are available and can be used by your elisp files:

* bootup/ensure-installed - function to make sure elpa packages are installed
* bootup/load-if-exits - function that will load the given file only if it exists
* bootup/available-runlevels - The number of available runlevels (default 3)
* bootup/base-dir - The path to your ~/.emacs.d
* bootup/profiles-dir - The path to ~/.emacs.d/profiles
* bootup/active-profile - The path to the currently active-profile
* bootup/vendor-dir - The path to your vendor directory
* custom-file - The path to the custom file
