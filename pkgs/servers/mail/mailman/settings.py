# -*- coding: utf-8 -*-
# Copyright (C) 1998-2019 by the Free Software Foundation, Inc.
#
# This file is part of Postorius.
#
# Postorius is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# Postorius is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# Postorius.  If not, see <http://www.gnu.org/licenses/>.

"""
Django settings for postorius project.

For more information on this file, see
https://docs.djangoproject.com/en/1.9/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.9/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os

# Compatibility with Bootstrap 3
from django.contrib.messages import constants as messages


BASE_DIR = os.path.dirname(os.path.abspath(__file__))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.9/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = '$!-7^wl#wiifjbh)5@f7ji%x!vp7s1vzbvwt26hxv$idixq0u0'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False

ADMINS = (
    #('Admin', 'webmaster@example.com'),
)

SITE_ID = 1

# Hosts/domain names that are valid for this site; required if DEBUG is False
# See https://docs.djangoproject.com/en/1.8/ref/settings/#allowed-hosts
ALLOWED_HOSTS = [
    "localhost",  # Archiving API from Mailman, keep it.
    "127.0.0.1",
    # Add here all production URLs you may have.
    @ALLOWED_HOSTS@
]

# Mailman API credentials
MAILMAN_REST_API_URL = 'http://localhost:8001'
MAILMAN_REST_API_USER = 'restadmin'
MAILMAN_REST_API_PASS = 'restpass'
MAILMAN_ARCHIVER_KEY = "@ARCHIVER_KEY@"
MAILMAN_ARCHIVER_FROM = ('127.0.0.1', '::1')

# Application definition

INSTALLED_APPS = (
    'hyperkitty',
    'postorius',
    'django_mailman3',
    # Uncomment the next line to enable the admin:
    'django.contrib.admin',
    # Uncomment the next line to enable admin documentation:
    # 'django.contrib.admindocs',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'django_gravatar',
    'compressor',
    'haystack',
    'django_extensions',
    'django_q',
    'allauth',
    'allauth.account',
    'allauth.socialaccount',
    'django_mailman3.lib.auth.fedora',
    'allauth.socialaccount.providers.openid',
    'allauth.socialaccount.providers.github',
    'allauth.socialaccount.providers.gitlab',
    'allauth.socialaccount.providers.google',
   #'allauth.socialaccount.providers.facebook',
   #'allauth.socialaccount.providers.twitter',
    'allauth.socialaccount.providers.stackexchange',
)


MIDDLEWARE = (
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'django_mailman3.middleware.TimezoneMiddleware',
)

ROOT_URLCONF = 'urls'


TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.i18n',
                'django.template.context_processors.media',
                'django.template.context_processors.static',
                'django.template.context_processors.tz',
                'django.template.context_processors.csrf',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'django_mailman3.context_processors.common',
                'hyperkitty.context_processors.common',
            ],
        },
    },
]

WSGI_APPLICATION = 'wsgi.application'


# Database
# https://docs.djangoproject.com/en/1.9/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/var/lib/mailman-web/mailman-web.db'
    }
}

# Password validation
# https://docs.djangoproject.com/en/1.9/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# If you're behind a proxy, use the X-Forwarded-Host header
# See https://docs.djangoproject.com/en/1.8/ref/settings/#use-x-forwarded-host
# USE_X_FORWARDED_HOST = True

# And if your proxy does your SSL encoding for you, set SECURE_PROXY_SSL_HEADER
# https://docs.djangoproject.com/en/1.8/ref/settings/#secure-proxy-ssl-header
# SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
# SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_SCHEME', 'https')

# Other security settings
# SECURE_SSL_REDIRECT = True
# If you set SECURE_SSL_REDIRECT to True, make sure the SECURE_REDIRECT_EXEMPT
# contains at least this line:
# SECURE_REDIRECT_EXEMPT = [
#     "archives/api/mailman/.*",  # Request from Mailman.
#     ]
# SESSION_COOKIE_SECURE = True
# SECURE_CONTENT_TYPE_NOSNIFF = True
# SECURE_BROWSER_XSS_FILTER = True
# CSRF_COOKIE_SECURE = True
# CSRF_COOKIE_HTTPONLY = True
# X_FRAME_OPTIONS = 'DENY'


# Internationalization
# https://docs.djangoproject.com/en/1.9/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.9/howto/static-files/


# Absolute path to the directory static files should be collected to.
# Don't put anything in this directory yourself; store your static files
# in apps' "static/" subdirectories and in STATICFILES_DIRS.
# Example: "/var/www/example.com/static/"
STATIC_ROOT = 'static'

# URL prefix for static files.
# Example: "http://example.com/static/", "http://static.example.com/"
STATIC_URL = '/static/'

# Additional locations of static files
STATICFILES_DIRS = (
    # Put strings here, like "/home/html/static" or "C:/www/django/static".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
    # BASE_DIR + '/static/',
)

# List of finder classes that know how to find static files in
# various locations.
STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
    # 'django.contrib.staticfiles.finders.DefaultStorageFinder',
    'compressor.finders.CompressorFinder',
)

# Django 1.6+ defaults to a JSON serializer, but it won't work with
# django-openid, see
# https://bugs.launchpad.net/django-openid-auth/+bug/1252826
SESSION_SERIALIZER = 'django.contrib.sessions.serializers.PickleSerializer'


LOGIN_URL = 'account_login'
LOGIN_REDIRECT_URL = 'hk_root'
LOGOUT_URL = 'account_logout'


# If you enable internal authentication, this is the address that the emails
# will appear to be coming from. Make sure you set a valid domain name,
# otherwise the emails may get rejected.
# https://docs.djangoproject.com/en/1.8/ref/settings/#default-from-email
DEFAULT_FROM_EMAIL = "@SERVER_EMAIL@"

# If you enable email reporting for error messages, this is where those emails
# will appear to be coming from. Make sure you set a valid domain name,
# otherwise the emails may get rejected.
# https://docs.djangoproject.com/en/1.8/ref/settings/#std:setting-SERVER_EMAIL
SERVER_EMAIL = "@SERVER_EMAIL@"


MESSAGE_TAGS = {
    messages.ERROR: 'danger'
}


#
# Social auth
#
AUTHENTICATION_BACKENDS = (
    'django.contrib.auth.backends.ModelBackend',
    'allauth.account.auth_backends.AuthenticationBackend',
)

# Django Allauth
ACCOUNT_AUTHENTICATION_METHOD = "username_email"
ACCOUNT_EMAIL_REQUIRED = True
ACCOUNT_EMAIL_VERIFICATION = "mandatory"
ACCOUNT_DEFAULT_HTTP_PROTOCOL = "https"
ACCOUNT_UNIQUE_EMAIL  = True

SOCIALACCOUNT_PROVIDERS = {
    'openid': {
        'SERVERS': [
            dict(id='yahoo',
                 name='Yahoo',
                 openid_url='http://me.yahoo.com'),
        ],
    },
    'google': {
        'SCOPE': ['profile', 'email'],
        'AUTH_PARAMS': {'access_type': 'online'},
    },
    'facebook': {
       'METHOD': 'oauth2',
       'SCOPE': ['email'],
       'FIELDS': [
           'email',
           'name',
           'first_name',
           'last_name',
           'locale',
           'timezone',
           ],
       'VERSION': 'v2.4',
    },
    'gitlab': {
        'GITLAB_URL': 'https://gitlab.com',
        'SCOPE': ['read_user'],
    },
}


#
# Gravatar
# https://github.com/twaddington/django-gravatar
#
# Gravatar base url.
# GRAVATAR_URL = 'http://cdn.libravatar.org/'
# Gravatar base secure https url.
# GRAVATAR_SECURE_URL = 'https://seccdn.libravatar.org/'
# Gravatar size in pixels.
# GRAVATAR_DEFAULT_SIZE = '80'
# An image url or one of the following: 'mm', 'identicon', 'monsterid',
# 'wavatar', 'retro'.
# GRAVATAR_DEFAULT_IMAGE = 'mm'
# One of the following: 'g', 'pg', 'r', 'x'.
# GRAVATAR_DEFAULT_RATING = 'g'
# True to use https by default, False for plain http.
# GRAVATAR_DEFAULT_SECURE = True

# These can be set to override the defaults but are not mandatory:
# EMAIL_CONFIRMATION_TEMPLATE = 'postorius/address_confirmation_message.txt'
# EMAIL_CONFIRMATION_SUBJECT = 'Confirmation needed'

#
# django-compressor
# https://pypi.python.org/pypi/django_compressor
#
COMPRESS_PRECOMPILERS = (
   ('text/x-scss', '/run/current-system/sw/bin/sassc -t compressed {infile} {outfile}'),
   ('text/x-sass', '/run/current-system/sw/bin/sassc -t compressed {infile} {outfile}'),
)
# On a production setup, setting COMPRESS_OFFLINE to True will bring a
# significant performance improvement, as CSS files will not need to be
# recompiled on each requests. It means running an additional "compress"
# management command after each code upgrade.
# http://django-compressor.readthedocs.io/en/latest/usage/#offline-compression
COMPRESS_ENABLED = True
COMPRESS_OFFLINE = True

# Needed for debug mode
# INTERNAL_IPS = ('127.0.0.1',)


#
# Full-text search engine
#
HAYSTACK_CONNECTIONS = {
    'default': {
        'ENGINE': 'haystack.backends.whoosh_backend.WhooshEngine',
        'PATH': "/var/lib/mailman-web/fulltext_index",
        # You can also use the Xapian engine, it's faster and more accurate,
        # but requires another library.
        # http://django-haystack.readthedocs.io/en/v2.4.1/installing_search_engines.html#xapian
        # Example configuration for Xapian:
        #'ENGINE': 'xapian_backend.XapianEngine'
    },
}


#
# REST framework
#
REST_FRAMEWORK = {
    'PAGE_SIZE': 10,
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.LimitOffsetPagination',
    'DEFAULT_FILTER_BACKENDS': (
        'rest_framework.filters.OrderingFilter',
    ),
}


#
# Asynchronous tasks
#
Q_CLUSTER = {
    'timeout': 300,
    'save_limit': 100,
    'orm': 'default',
}


# A sample logging configuration. The only tangible logging
# performed by this configuration is to send an email to
# the site admins on every HTTP 500 error when DEBUG=False.
# See http://docs.djangoproject.com/en/dev/topics/logging for
# more details on how to customize your logging configuration.
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'filters': {
        'require_debug_false': {
            '()': 'django.utils.log.RequireDebugFalse'
        }
    },
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
            'formatter': 'simple',
        },
        'mail_admins': {
            'level': 'ERROR',
            'filters': ['require_debug_false'],
            'class': 'django.utils.log.AdminEmailHandler'
        },
        'file':{
            'level': 'INFO',
            #'class': 'logging.handlers.RotatingFileHandler',
            'class': 'logging.handlers.WatchedFileHandler',
            'filename': 'mailman-web.log',
            'formatter': 'verbose',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['console', 'file'],
            'level': 'INFO',
        },
        'django.request': {
            'handlers': ['console', 'mail_admins', 'file'],
            'level': 'ERROR',
            'propagate': True,
        },
        'postorius': {
            'handlers': ['console', 'file'],
            'level': 'INFO',
        },
        'django': {
            'handlers': ['file'],
            'level': 'ERROR',
            'propagate': True,
        },
        'hyperkitty': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': True,
        },
    },
    'formatters': {
        'simple': {
            'format': '%(levelname)s: %(message)s'
        },
        'verbose': {
            'format': '%(levelname)s %(asctime)s %(process)d %(name)s %(message)s'
        },
        'simple': {
            'format': '%(levelname)s %(message)s'
        },
    },
    #'root': {
    #    'handlers': ['file'],
    #    'level': 'INFO',
    #},
}


POSTORIUS_TEMPLATE_BASE_URL = "http://localhost:8000"


# Using the cache infrastructure can significantly improve performance on a
# production setup. This is an example with a local Memcached server.
#CACHES = {
#    'default': {
#        'BACKEND': 'django.core.cache.backends.memcached.PyLibMCCache',
#        'LOCATION': '127.0.0.1:11211',
#    }
#}


# When DEBUG is True, don't actually send emails to the SMTP server, just store
# them in a directory. This way you won't accidentally spam your mailing-lists
# while you're fiddling with the code.
if DEBUG == True:
    EMAIL_BACKEND = 'django.core.mail.backends.filebased.EmailBackend'
    EMAIL_FILE_PATH = '/tmp/hyperkitty-emails'


#
# HyperKitty-specific
#
# Only display mailing-lists from the same virtual host as the webserver
FILTER_VHOST = False
# Disable singleton locking for Django-Q tasks.
HYPERKITTY_DISABLE_SINGLETON_TASKS = False
# Maximum time between two task runs with same function and arguments.
# This setting is mostly meant for Mailman Developers and should be used
# with caution.
# Default set to 10mins.
HYPERKITTY_TASK_LOCK_TIMEOUT = 10 * 60


try:
    from settings_local import *
except ImportError:
    pass
