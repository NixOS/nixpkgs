#!/usr/bin/env python

from distutils.core import setup

setup( name         = "waitress-django"
     , version      = "1.0.0"
     , description  = "A waitress WSGI server serving django"
     , author       = "Bas van Dijk"
     , author_email = "v.dijk.bas@gmail.com"
     , scripts      = ["waitress-serve-django"]
     )
