# Some repositories (such as Devpi) expose the Pypi legacy API
# (https://warehouse.pypa.io/api-reference/legacy.html).
#
# Note it is not possible to use pip
# https://discuss.python.org/t/pip-download-just-the-source-packages-no-building-no-metadata-etc/4651/12

import os
import sys
import netrc
from urllib.parse import urlparse, urlunparse
from html.parser import HTMLParser
import urllib.request
import shutil
import ssl
from os.path import normpath


# Parse the legacy index page to extract the href and package names
class Pep503(HTMLParser):
    def __init__(self):
        super().__init__()
        self.sources = {}
        self.url = None
        self.name = None

    def handle_data(self, data):
        if self.url is not None:
            self.name = data

    def handle_starttag(self, tag, attrs):
        if tag == "a":
            for name, value in attrs:
                if name == "href":
                    self.url = value

    def handle_endtag(self, tag):
        if self.url is not None:
            self.sources[self.name] = self.url
        self.url = None


url = sys.argv[1]
package_name = sys.argv[2]
index_url = url + "/" + package_name + "/"
package_filename = sys.argv[3]

# Parse username and password for this host from the netrc file if given.
username, password = None, None
if os.environ["NETRC"]:
    netrc_obj = netrc.netrc(os.environ["NETRC"])
    host = urlparse(index_url).netloc
    # Strip port number if present
    if ":" in host:
        host = host.split(":")[0]
    username, _, password = netrc_obj.authenticators(host)

print("Reading index %s" % index_url)

context = ssl.create_default_context()
context.check_hostname = False
context.verify_mode = ssl.CERT_NONE

req = urllib.request.Request(index_url)
if username and password:
    import base64

    password_b64 = base64.b64encode(":".join((username, password)).encode()).decode(
        "utf-8"
    )
    req.add_header("Authorization", "Basic {}".format(password_b64))
response = urllib.request.urlopen(req, context=context)
index = response.read()

parser = Pep503()
parser.feed(str(index))
if package_filename not in parser.sources:
    print(
        "The file %s has not be found in the index %s" % (package_filename, index_url)
    )
    exit(1)

package_file = open(package_filename, "wb")
# Sometimes the href is a relative path
if urlparse(parser.sources[package_filename]).netloc == "":
    parsed_url = urlparse(index_url)
    package_url = urlunparse(
        (
            parsed_url.scheme,
            parsed_url.netloc,
            parsed_url.path + "/" + parser.sources[package_filename],
            None,
            None,
            None,
        )
    )
else:
    package_url = parser.sources[package_filename]

# Handle urls containing "../"
parsed_url = urlparse(package_url)
real_package_url = urlunparse(
    (
        parsed_url.scheme,
        parsed_url.netloc,
        normpath(parsed_url.path),
        parsed_url.params,
        parsed_url.query,
        parsed_url.fragment,
    )
)
print("Downloading %s" % real_package_url)

req = urllib.request.Request(real_package_url)
if username and password:
    req.add_unredirected_header("Authorization", "Basic {}".format(password_b64))
response = urllib.request.urlopen(req, context=context)

with response as r:
    shutil.copyfileobj(r, package_file)
