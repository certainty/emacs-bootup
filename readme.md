# Emacs-Bootup

This is my attempt to structure my emacs-files. My specific needs are that I use Emacs both at home and at work. I want it to behave
basically the same but of course I have environment specific settings.

Also I wanted a way to steer when files are loaded during the boot. I figured that some files are very basic and need to go before
any other files.

The way i solved it is basically two things:

* profiles
* runlevels

## Quickstart

Just clone the repository as ${HOME}/.emacs.d. Please be sure to make a backup of your existing directory!
Once you've done this all you need to do is to create a profile.

    mkdir -p ~/.emacs.d/root/profiles/your_profile/runlevel{0,1,2}
    ln -s ~/.emacs.d/root/profiles/your_profile ~/.emacs.d/root/profiles/active-profile

Now you can use this setup to place your files in the different runlevels and they will be loaded
from smallest to greatest. My default there are _three runlevels_.


## Details

### Profiles

A profile holds environment specific settings. A profile is represented by a directory that has the following content.

     profile-dir
       |
       |- alpha.el
       |- custom.el
       |- omega.el
       |- runlevel0
       |- runlevel1
       |- runlevel2

Runlevel0-2 are directories that may hold your elisp files. The rest of the files are used to do pre- and post-actions to the boot-process.
The custom-file holds custom UX settings.

#### Active Profile

In order to activate a profile you need to create  symlink into the root-directory.

    ln -s ~/.emacs.d/root/profiles/my-profile ~/.emacs.d/root/active-profile

#### Alpha and Omega

Each profile may contain an alpha and an omega file. Those are named
*alpha.el* and *omega.el* and have to be placed in the profile's root directory.
These can be used to do something at the very start or the very end of the boot-process
accordingly.

The alpha-file will be loaded before any other file whereas the omega-file is loaded
after all other files have been loaded. 

### The base profile

You might have noticed that there is already a folder called base in the profiles directory.
This is for cased where you have files that you need in all other profiles.
Just put those files there and *symlink* them into your active-profile

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

* certainty/available-runlevels - The number of available runlevels (default 3)
* certainty/base-dir - The path to your ~/.emacs.d
* certainty/root-dir - The path to ~/.emacs.d/root
* certainty/active-profile - The path to the currently active-profile
* certainty/vendor-dir - The path to your vendor directory
* custom-file - The path to the custom file


