# python-jedi package

Python Jedi based autocompletion plugin.

## Installation
Either use Atoms package manager or `apm install python-jedi`. Install autocomplete-plus before installing this package.

### Usage

python-jedi uses python3 interpreter in your path by default.
For python2 go to settings and enable python2.
To Use virtualenv/pyvenv - add virtualenv path or pyvenv path in the settings(Pathtopython field).
(eg:/home/user/py3pyenv/bin/python3 or home/user/py2virtualenv/bin/python)


The completion daemon is started on port 7777 - please make sure no
other service is using this port.

#### Note

Standard Python2 or Python2 virtualenv will work only if python2 enabled through settings.

The completion daemon is stopped appropriately, which was fully tested in linux
environment. The package has not been tested under windows environment. It might
be buggy.

### Warning

Do not use it along with autocomplete-plus-jedi. Since it is originally forked
from it, python-jedi may malfunction. 
