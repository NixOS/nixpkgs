import subprocess

from html.parser import HTMLParser
from os.path import abspath, dirname
from urllib.request import urlopen

class WiktionaryLatestVersionParser(HTMLParser):
    def __init__(self, current_version, *args, **kwargs):
        self.latest_version = current_version
        super().__init__(*args, **kwargs)


    def handle_starttag(self, tag, attrs):
        if tag != 'a':
            return

        href = dict(attrs)['href'][0:-1]
        if href == 'latest':
            return

        self.latest_version = max(self.latest_version, href)


def nix_prefetch_url(url, algo='sha256'):
    """Prefetches the content of the given URL."""
    print(f'nix-prefetch-url {url}')
    out = subprocess.check_output(['nix-prefetch-url', '--type', algo, url])
    return out.rstrip()


current_version = subprocess.check_output([
    'nix', 'eval', '--raw',
    '-f', dirname(abspath(__file__)) + '/../../../..',
    'dictdDBs.wiktionary.version',
])

parser = WiktionaryLatestVersionParser(current_version)

with urlopen('https://dumps.wikimedia.org/enwiktionary/') as resp:
    parser.feed(resp.read())

print(parser.latest_version)
