# Some repositories (such as Devpi) expose the Pypi legacy API
# (https://warehouse.pypa.io/api-reference/legacy.html).
#
# Note it is not possible to use pip
# https://discuss.python.org/t/pip-download-just-the-source-packages-no-building-no-metadata-etc/4651/12

import sys
from urllib.parse import urlparse
from html.parser import HTMLParser
import urllib.request
import shutil
import ssl
import os


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
index_url = url + "/" + package_name
package_filename = sys.argv[3]

print("Reading index %s" % index_url)

response = urllib.request.urlopen(
    index_url,
    context=ssl.CERT_NONE)
index = response.read()

parser = Pep503()
parser.feed(str(index))
if package_filename not in parser.sources:
    print("The file %s has not be found in the index %s" % (
        package_filename, index_url))
    exit(1)

package_file = open(package_filename, "wb")
# Sometimes the href is a relative path
if urlparse(parser.sources[package_filename]).netloc == '':
    package_url = index_url + "/" + parser.sources[package_filename]
else:
    package_url = parser.sources[package_filename]
print("Downloading %s" % package_url)

response = urllib.request.urlopen(
    package_url,
    context=ssl.CERT_NONE)

with response as r:
    shutil.copyfileobj(r, package_file)
