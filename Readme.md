symlinks
========
**scan/change symbolic links**

Symlinks is a simple tool that helps find and remedy problematic symbolic links on a system.


Description
-----------

Symlinks scans directories for symbolic links, identifying dangling, relative, absolute, messy, and other_fs links.  It can also change absolute links to relative within a given filesystem.


Installation
------------

### Source:

    $ ./configure
    $ make
    $ make install


Usage
-----

### Scan:

    $ symlinks -r [path]


### Show all symlinks:

    $ symlinks -rv [path]


### Convert absolute symlink to relative:

    $ symlinks -rc [path]


### More options:

    $ symlinks -h


Changes
-------

#### v1.4.3
- Fixed LFS support bug that caused erratic behavior on 32-bit systems.

#### v1.4.2
- Reformatted for readability roughly based on Google style guide.
- Fixed loss of precision due to implicit type conversion.
- Minor documentation updates.

#### v1.4-1
- Added Mac OS X compatibility.

#### v1.4 
- Incorporate patches from Fedora.

#### v1.3
- More messy-link fixes, new `-o` flag for other_fs.

#### v1.2 
- Added `-s` flag to shorten links with redundant path elements.
- Also includes code to remove excess slashes from paths.


Credit
------

Symlinks was created by **Mark Lord** <mlord@pobox.com>.  
Maintained by **J. Brandt Buckley** <brandt@runlevel1.com>.  
