# This file contains the Python packages set.
# Each attribute is a Python library or a helper function.
# Expressions for Python libraries are supposed to be in `pkgs/development/python-modules/<name>/default.nix`.
# Python packages that do not need to be available for each interpreter version do not belong in this packages set.
# Examples are Python-based cli tools.
#
# For more details, please see the Python section in the Nixpkgs manual.

self: super: with self; {

  bootstrap = lib.recurseIntoAttrs {
    flit-core = toPythonModule (callPackage ../development/python-modules/bootstrap/flit-core { });
    installer = toPythonModule (
      callPackage ../development/python-modules/bootstrap/installer { inherit (bootstrap) flit-core; }
    );
    build = toPythonModule (
      callPackage ../development/python-modules/bootstrap/build {
        inherit (bootstrap) flit-core installer;
      }
    );
    packaging = toPythonModule (
      callPackage ../development/python-modules/bootstrap/packaging {
        inherit (bootstrap) flit-core installer;
      }
    );
  };

  setuptools = callPackage ../development/python-modules/setuptools { };

  # by_regex ensures inherit statements are sorted after the (first) attribute name that is inherited.
  # keep-sorted start block=yes newline_separated=yes by_regex=["(?:inherit\\s+\\([^)]+\\)\\n?\\s*)?(.+)"]
  a2wsgi = callPackage ../development/python-modules/a2wsgi { };

  aafigure = callPackage ../development/python-modules/aafigure { };

  aardwolf = callPackage ../development/python-modules/aardwolf { };

  abjad = callPackage ../development/python-modules/abjad { };

  about-time = callPackage ../development/python-modules/about-time { };

  absl-py = callPackage ../development/python-modules/absl-py { };

  accelerate = callPackage ../development/python-modules/accelerate { };

  accessible-pygments = callPackage ../development/python-modules/accessible-pygments { };

  accupy = callPackage ../development/python-modules/accupy { };

  accuweather = callPackage ../development/python-modules/accuweather { };

  acme = callPackage ../development/python-modules/acme { };

  acme-tiny = callPackage ../development/python-modules/acme-tiny { };

  acquire = callPackage ../development/python-modules/acquire { };

  acres = callPackage ../development/python-modules/acres { };

  actdiag = callPackage ../development/python-modules/actdiag { };

  actron-neo-api = callPackage ../development/python-modules/actron-neo-api { };

  acunetix = callPackage ../development/python-modules/acunetix { };

  adafruit-board-toolkit = callPackage ../development/python-modules/adafruit-board-toolkit { };

  adafruit-io = callPackage ../development/python-modules/adafruit-io { };

  adafruit-platformdetect = callPackage ../development/python-modules/adafruit-platformdetect { };

  adafruit-pureio = callPackage ../development/python-modules/adafruit-pureio { };

  adal = callPackage ../development/python-modules/adal { };

  adax = callPackage ../development/python-modules/adax { };

  adax-local = callPackage ../development/python-modules/adax-local { };

  adb-enhanced = callPackage ../development/python-modules/adb-enhanced { };

  adb-homeassistant = callPackage ../development/python-modules/adb-homeassistant { };

  adb-shell = callPackage ../development/python-modules/adb-shell { };

  adblock = callPackage ../development/python-modules/adblock { };

  add-trailing-comma = callPackage ../development/python-modules/add-trailing-comma { };

  addict = callPackage ../development/python-modules/addict { };

  adext = callPackage ../development/python-modules/adext { };

  adguardhome = callPackage ../development/python-modules/adguardhome { };

  adios2 = toPythonModule (
    pkgs.adios2.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  adjusttext = callPackage ../development/python-modules/adjusttext { };

  adlfs = callPackage ../development/python-modules/adlfs { };

  advantage-air = callPackage ../development/python-modules/advantage-air { };

  advocate = callPackage ../development/python-modules/advocate { };

  aeidon = callPackage ../development/python-modules/aeidon { };

  aemet-opendata = callPackage ../development/python-modules/aemet-opendata { };

  aenum = callPackage ../development/python-modules/aenum { };

  aerosandbox = callPackage ../development/python-modules/aerosandbox { };

  aesedb = callPackage ../development/python-modules/aesedb { };

  aetcd = callPackage ../development/python-modules/aetcd { };

  afdko = callPackage ../development/python-modules/afdko { };

  affine = callPackage ../development/python-modules/affine { };

  affine-gaps = callPackage ../development/python-modules/affine-gaps { };

  affinegap = callPackage ../development/python-modules/affinegap { };

  afsapi = callPackage ../development/python-modules/afsapi { };

  agate = callPackage ../development/python-modules/agate { };

  agate-dbf = callPackage ../development/python-modules/agate-dbf { };

  agate-excel = callPackage ../development/python-modules/agate-excel { };

  agate-sql = callPackage ../development/python-modules/agate-sql { };

  agent-py = callPackage ../development/python-modules/agent-py { };

  aggdraw = callPackage ../development/python-modules/aggdraw { };

  aggregate6 = callPackage ../development/python-modules/aggregate6 { };

  ago = callPackage ../development/python-modules/ago { };

  ahocorapy = callPackage ../development/python-modules/ahocorapy { };

  ahocorasick-rs = callPackage ../development/python-modules/ahocorasick-rs { };

  aigpy = callPackage ../development/python-modules/aigpy { };

  ailment = callPackage ../development/python-modules/ailment { };

  aio-geojson-client = callPackage ../development/python-modules/aio-geojson-client { };

  aio-geojson-generic-client =
    callPackage ../development/python-modules/aio-geojson-generic-client
      { };

  aio-geojson-geonetnz-quakes =
    callPackage ../development/python-modules/aio-geojson-geonetnz-quakes
      { };

  aio-geojson-geonetnz-volcano =
    callPackage ../development/python-modules/aio-geojson-geonetnz-volcano
      { };

  aio-geojson-nsw-rfs-incidents =
    callPackage ../development/python-modules/aio-geojson-nsw-rfs-incidents
      { };

  aio-geojson-usgs-earthquakes =
    callPackage ../development/python-modules/aio-geojson-usgs-earthquakes
      { };

  aio-georss-client = callPackage ../development/python-modules/aio-georss-client { };

  aio-georss-gdacs = callPackage ../development/python-modules/aio-georss-gdacs { };

  aio-ownet = callPackage ../development/python-modules/aio-ownet { };

  aio-pika = callPackage ../development/python-modules/aio-pika { };

  aioacaia = callPackage ../development/python-modules/aioacaia { };

  aioairctrl = callPackage ../development/python-modules/aioairctrl { };

  aioairq = callPackage ../development/python-modules/aioairq { };

  aioairzone = callPackage ../development/python-modules/aioairzone { };

  aioairzone-cloud = callPackage ../development/python-modules/aioairzone-cloud { };

  aioamazondevices = callPackage ../development/python-modules/aioamazondevices { };

  aioambient = callPackage ../development/python-modules/aioambient { };

  aioamqp = callPackage ../development/python-modules/aioamqp { };

  aioapcaccess = callPackage ../development/python-modules/aioapcaccess { };

  aioapns = callPackage ../development/python-modules/aioapns { };

  aioaquacell = callPackage ../development/python-modules/aioaquacell { };

  aioaseko = callPackage ../development/python-modules/aioaseko { };

  aioasuswrt = callPackage ../development/python-modules/aioasuswrt { };

  aioaudiobookshelf = callPackage ../development/python-modules/aioaudiobookshelf { };

  aioautomower = callPackage ../development/python-modules/aioautomower { };

  aioazuredevops = callPackage ../development/python-modules/aioazuredevops { };

  aiobafi6 = callPackage ../development/python-modules/aiobafi6 { };

  aiobiketrax = callPackage ../development/python-modules/aiobiketrax { };

  aioblescan = callPackage ../development/python-modules/aioblescan { };

  aioboto3 = callPackage ../development/python-modules/aioboto3 { };

  aiobotocore = callPackage ../development/python-modules/aiobotocore { };

  aiobroadlink = callPackage ../development/python-modules/aiobroadlink { };

  aiobtclientapi = callPackage ../development/python-modules/aiobtclientapi { };

  aiobtclientrpc = callPackage ../development/python-modules/aiobtclientrpc { };

  aiocache = callPackage ../development/python-modules/aiocache { };

  aiocmd = callPackage ../development/python-modules/aiocmd { };

  aiocoap = callPackage ../development/python-modules/aiocoap { };

  aiocomelit = callPackage ../development/python-modules/aiocomelit { };

  aioconsole = callPackage ../development/python-modules/aioconsole { };

  aiocontextvars = callPackage ../development/python-modules/aiocontextvars { };

  aiocron = callPackage ../development/python-modules/aiocron { };

  aiocsv = callPackage ../development/python-modules/aiocsv { };

  aiocurrencylayer = callPackage ../development/python-modules/aiocurrencylayer { };

  aiodhcpwatcher = callPackage ../development/python-modules/aiodhcpwatcher { };

  aiodiscover = callPackage ../development/python-modules/aiodiscover { };

  aiodns = callPackage ../development/python-modules/aiodns { };

  aiodocker = callPackage ../development/python-modules/aiodocker { };

  aiodukeenergy = callPackage ../development/python-modules/aiodukeenergy { };

  aioeafm = callPackage ../development/python-modules/aioeafm { };

  aioeagle = callPackage ../development/python-modules/aioeagle { };

  aioecowitt = callPackage ../development/python-modules/aioecowitt { };

  aioelectricitymaps = callPackage ../development/python-modules/aioelectricitymaps { };

  aioemonitor = callPackage ../development/python-modules/aioemonitor { };

  aioesphomeapi = callPackage ../development/python-modules/aioesphomeapi { };

  aioextensions = callPackage ../development/python-modules/aioextensions { };

  aiofile = callPackage ../development/python-modules/aiofile { };

  aiofiles = callPackage ../development/python-modules/aiofiles { };

  aioflo = callPackage ../development/python-modules/aioflo { };

  aioftp = callPackage ../development/python-modules/aioftp { };

  aiogithubapi = callPackage ../development/python-modules/aiogithubapi { };

  aiogram = callPackage ../development/python-modules/aiogram { };

  aioguardian = callPackage ../development/python-modules/aioguardian { };

  aiohappyeyeballs = callPackage ../development/python-modules/aiohappyeyeballs { };

  aioharmony = callPackage ../development/python-modules/aioharmony { };

  aiohasupervisor = callPackage ../development/python-modules/aiohasupervisor { };

  aiohomeconnect = callPackage ../development/python-modules/aiohomeconnect { };

  aiohomekit = callPackage ../development/python-modules/aiohomekit { };

  aiohomematic = callPackage ../development/python-modules/aiohomematic { };

  aiohomematic-test-support = callPackage ../development/python-modules/aiohomematic-test-support { };

  aiohttp = callPackage ../development/python-modules/aiohttp { };

  aiohttp-apispec = callPackage ../development/python-modules/aiohttp-apispec { };

  aiohttp-asyncmdnsresolver = callPackage ../development/python-modules/aiohttp-asyncmdnsresolver { };

  aiohttp-basicauth = callPackage ../development/python-modules/aiohttp-basicauth { };

  aiohttp-client-cache = callPackage ../development/python-modules/aiohttp-client-cache { };

  aiohttp-cors = callPackage ../development/python-modules/aiohttp-cors { };

  aiohttp-fast-zlib = callPackage ../development/python-modules/aiohttp-fast-zlib { };

  aiohttp-jinja2 = callPackage ../development/python-modules/aiohttp-jinja2 { };

  aiohttp-middlewares = callPackage ../development/python-modules/aiohttp-middlewares { };

  aiohttp-oauthlib = callPackage ../development/python-modules/aiohttp-oauthlib { };

  aiohttp-openmetrics = callPackage ../development/python-modules/aiohttp-openmetrics { };

  aiohttp-remotes = callPackage ../development/python-modules/aiohttp-remotes { };

  aiohttp-retry = callPackage ../development/python-modules/aiohttp-retry { };

  aiohttp-session = callPackage ../development/python-modules/aiohttp-session { };

  aiohttp-socks = callPackage ../development/python-modules/aiohttp-socks { };

  aiohttp-sse = callPackage ../development/python-modules/aiohttp-sse { };

  aiohttp-sse-client = callPackage ../development/python-modules/aiohttp-sse-client { };

  aiohttp-sse-client2 = callPackage ../development/python-modules/aiohttp-sse-client2 { };

  aiohttp-swagger = callPackage ../development/python-modules/aiohttp-swagger { };

  aiohttp-utils = callPackage ../development/python-modules/aiohttp-utils { };

  aiohttp-wsgi = callPackage ../development/python-modules/aiohttp-wsgi { };

  aiohue = callPackage ../development/python-modules/aiohue { };

  aiohwenergy = callPackage ../development/python-modules/aiohwenergy { };

  aioice = callPackage ../development/python-modules/aioice { };

  aioimaplib = callPackage ../development/python-modules/aioimaplib { };

  aioimmich = callPackage ../development/python-modules/aioimmich { };

  aioinflux = callPackage ../development/python-modules/aioinflux { };

  aioitertools = callPackage ../development/python-modules/aioitertools { };

  aiojellyfin = callPackage ../development/python-modules/aiojellyfin { };

  aiojobs = callPackage ../development/python-modules/aiojobs { };

  aiokafka = callPackage ../development/python-modules/aiokafka { };

  aiokef = callPackage ../development/python-modules/aiokef { };

  aiokem = callPackage ../development/python-modules/aiokem { };

  aiolifx = callPackage ../development/python-modules/aiolifx { };

  aiolifx-connection = callPackage ../development/python-modules/aiolifx-connection { };

  aiolifx-effects = callPackage ../development/python-modules/aiolifx-effects { };

  aiolifx-themes = callPackage ../development/python-modules/aiolifx-themes { };

  aiolimiter = callPackage ../development/python-modules/aiolimiter { };

  aiolookin = callPackage ../development/python-modules/aiolookin { };

  aiolyric = callPackage ../development/python-modules/aiolyric { };

  aiomcache = callPackage ../development/python-modules/aiomcache { };

  aiomealie = callPackage ../development/python-modules/aiomealie { };

  aiomisc = callPackage ../development/python-modules/aiomisc { };

  aiomisc-pytest = callPackage ../development/python-modules/aiomisc-pytest { };

  aiomodernforms = callPackage ../development/python-modules/aiomodernforms { };

  aiomqtt = callPackage ../development/python-modules/aiomqtt { };

  aiomultiprocess = callPackage ../development/python-modules/aiomultiprocess { };

  aiomusiccast = callPackage ../development/python-modules/aiomusiccast { };

  aiomysql = callPackage ../development/python-modules/aiomysql { };

  aionanoleaf = callPackage ../development/python-modules/aionanoleaf { };

  aionotion = callPackage ../development/python-modules/aionotion { };

  aiontfy = callPackage ../development/python-modules/aiontfy { };

  aionut = callPackage ../development/python-modules/aionut { };

  aiooncue = callPackage ../development/python-modules/aiooncue { };

  aioonkyo = callPackage ../development/python-modules/aioonkyo { };

  aioopenexchangerates = callPackage ../development/python-modules/aioopenexchangerates { };

  aioopenssl = callPackage ../development/python-modules/aioopenssl { };

  aiooss2 = callPackage ../development/python-modules/aiooss2 { };

  aiooui = callPackage ../development/python-modules/aiooui { };

  aiopegelonline = callPackage ../development/python-modules/aiopegelonline { };

  aiopg = callPackage ../development/python-modules/aiopg { };

  aiopinboard = callPackage ../development/python-modules/aiopinboard { };

  aioprocessing = callPackage ../development/python-modules/aioprocessing { };

  aioprometheus = callPackage ../development/python-modules/aioprometheus { };

  aiopulse = callPackage ../development/python-modules/aiopulse { };

  aiopurpleair = callPackage ../development/python-modules/aiopurpleair { };

  aiopvapi = callPackage ../development/python-modules/aiopvapi { };

  aiopvpc = callPackage ../development/python-modules/aiopvpc { };

  aiopyarr = callPackage ../development/python-modules/aiopyarr { };

  aiopylgtv = callPackage ../development/python-modules/aiopylgtv { };

  aioqsw = callPackage ../development/python-modules/aioqsw { };

  aioquic = callPackage ../development/python-modules/aioquic { };

  aioraven = callPackage ../development/python-modules/aioraven { };

  aiorecollect = callPackage ../development/python-modules/aiorecollect { };

  aioredis = callPackage ../development/python-modules/aioredis { };

  aioresponses = callPackage ../development/python-modules/aioresponses { };

  aioridwell = callPackage ../development/python-modules/aioridwell { };

  aiormq = callPackage ../development/python-modules/aiormq { };

  aiorpcx = callPackage ../development/python-modules/aiorpcx { };

  aiortc = callPackage ../development/python-modules/aiortc { };

  aiortm = callPackage ../development/python-modules/aiortm { };

  aiortsp = callPackage ../development/python-modules/aiortsp { };

  aioruckus = callPackage ../development/python-modules/aioruckus { };

  aiorun = callPackage ../development/python-modules/aiorun { };

  aiorussound = callPackage ../development/python-modules/aiorussound { };

  aioruuvigateway = callPackage ../development/python-modules/aioruuvigateway { };

  aiorwlock = callPackage ../development/python-modules/aiorwlock { };

  aiosasl = callPackage ../development/python-modules/aiosasl { };

  aiosenz = callPackage ../development/python-modules/aiosenz { };

  aioserial = callPackage ../development/python-modules/aioserial { };

  aioshelly = callPackage ../development/python-modules/aioshelly { };

  aioshutil = callPackage ../development/python-modules/aioshutil { };

  aiosignal = callPackage ../development/python-modules/aiosignal { };

  aioskybell = callPackage ../development/python-modules/aioskybell { };

  aioslimproto = callPackage ../development/python-modules/aioslimproto { };

  aiosmb = callPackage ../development/python-modules/aiosmb { };

  aiosmtpd = callPackage ../development/python-modules/aiosmtpd { };

  aiosmtplib = callPackage ../development/python-modules/aiosmtplib { };

  aiosolaredge = callPackage ../development/python-modules/aiosolaredge { };

  aiosomecomfort = callPackage ../development/python-modules/aiosomecomfort { };

  aiosonic = callPackage ../development/python-modules/aiosonic { };

  aiosonos = callPackage ../development/python-modules/aiosonos { };

  aiosql = callPackage ../development/python-modules/aiosql { };

  aiosqlite = callPackage ../development/python-modules/aiosqlite { };

  aiosseclient = callPackage ../development/python-modules/aiosseclient { };

  aiosteamist = callPackage ../development/python-modules/aiosteamist { };

  aiostream = callPackage ../development/python-modules/aiostream { };

  aiostreammagic = callPackage ../development/python-modules/aiostreammagic { };

  aioswitcher = callPackage ../development/python-modules/aioswitcher { };

  aiosyncthing = callPackage ../development/python-modules/aiosyncthing { };

  aiotankerkoenig = callPackage ../development/python-modules/aiotankerkoenig { };

  aiotarfile = callPackage ../development/python-modules/aiotarfile { };

  aiotedee = callPackage ../development/python-modules/aiotedee { };

  aiotractive = callPackage ../development/python-modules/aiotractive { };

  aiounifi = callPackage ../development/python-modules/aiounifi { };

  aiounittest = callPackage ../development/python-modules/aiounittest { };

  aiousbwatcher = callPackage ../development/python-modules/aiousbwatcher { };

  aiovlc = callPackage ../development/python-modules/aiovlc { };

  aiovodafone = callPackage ../development/python-modules/aiovodafone { };

  aiowaqi = callPackage ../development/python-modules/aiowaqi { };

  aiowatttime = callPackage ../development/python-modules/aiowatttime { };

  aiowebdav2 = callPackage ../development/python-modules/aiowebdav2 { };

  aiowebostv = callPackage ../development/python-modules/aiowebostv { };

  aioweenect = callPackage ../development/python-modules/aioweenect { };

  aiowinreg = callPackage ../development/python-modules/aiowinreg { };

  aiowithings = callPackage ../development/python-modules/aiowithings { };

  aiowmi = callPackage ../development/python-modules/aiowmi { };

  aioxmpp = callPackage ../development/python-modules/aioxmpp { };

  aioymaps = callPackage ../development/python-modules/aioymaps { };

  aiozeroconf = callPackage ../development/python-modules/aiozeroconf { };

  aiozoneinfo = callPackage ../development/python-modules/aiozoneinfo { };

  airgradient = callPackage ../development/python-modules/airgradient { };

  airium = callPackage ../development/python-modules/airium { };

  airly = callPackage ../development/python-modules/airly { };

  airos = callPackage ../development/python-modules/airos { };

  airportsdata = callPackage ../development/python-modules/airportsdata { };

  airthings-ble = callPackage ../development/python-modules/airthings-ble { };

  airthings-cloud = callPackage ../development/python-modules/airthings-cloud { };

  airtouch4pyapi = callPackage ../development/python-modules/airtouch4pyapi { };

  airtouch5py = callPackage ../development/python-modules/airtouch5py { };

  ajpy = callPackage ../development/python-modules/ajpy { };

  ajsonrpc = callPackage ../development/python-modules/ajsonrpc { };

  alabaster = callPackage ../development/python-modules/alabaster { };

  aladdin-connect = callPackage ../development/python-modules/aladdin-connect { };

  alarmdecoder = callPackage ../development/python-modules/alarmdecoder { };

  albucore = callPackage ../development/python-modules/albucore { };

  albumentations = callPackage ../development/python-modules/albumentations { };

  ale-py = callPackage ../development/python-modules/ale-py { };

  alectryon = callPackage ../development/python-modules/alectryon { };

  alembic = callPackage ../development/python-modules/alembic { };

  alexapy = callPackage ../development/python-modules/alexapy { };

  algebraic-data-types = callPackage ../development/python-modules/algebraic-data-types { };

  aligator = callPackage ../development/python-modules/aligator { inherit (pkgs) aligator; };

  alive-progress = callPackage ../development/python-modules/alive-progress { };

  aliyun-python-sdk-cdn = callPackage ../development/python-modules/aliyun-python-sdk-cdn { };

  aliyun-python-sdk-config = callPackage ../development/python-modules/aliyun-python-sdk-config { };

  aliyun-python-sdk-core = callPackage ../development/python-modules/aliyun-python-sdk-core { };

  aliyun-python-sdk-dbfs = callPackage ../development/python-modules/aliyun-python-sdk-dbfs { };

  aliyun-python-sdk-iot = callPackage ../development/python-modules/aliyun-python-sdk-iot { };

  aliyun-python-sdk-kms = callPackage ../development/python-modules/aliyun-python-sdk-kms { };

  aliyun-python-sdk-sts = callPackage ../development/python-modules/aliyun-python-sdk-sts { };

  allantools = callPackage ../development/python-modules/allantools { };

  allpairspy = callPackage ../development/python-modules/allpairspy { };

  allure-behave = callPackage ../development/python-modules/allure-behave { };

  allure-pytest = callPackage ../development/python-modules/allure-pytest { };

  allure-python-commons = callPackage ../development/python-modules/allure-python-commons { };

  allure-python-commons-test =
    callPackage ../development/python-modules/allure-python-commons-test
      { };

  alpha-vantage = callPackage ../development/python-modules/alpha-vantage { };

  altair = callPackage ../development/python-modules/altair { };

  altcha = callPackage ../development/python-modules/altcha { };

  altgraph = callPackage ../development/python-modules/altgraph { };

  altruistclient = callPackage ../development/python-modules/altruistclient { };

  amaranth = callPackage ../development/python-modules/amaranth { };

  amaranth-boards = callPackage ../development/python-modules/amaranth-boards { };

  amaranth-soc = callPackage ../development/python-modules/amaranth-soc { };

  amarna = callPackage ../development/python-modules/amarna { };

  amazon-ion = callPackage ../development/python-modules/amazon-ion { };

  amberelectric = callPackage ../development/python-modules/amberelectric { };

  amcrest = callPackage ../development/python-modules/amcrest { };

  ament-package = callPackage ../development/python-modules/ament-package { };

  amply = callPackage ../development/python-modules/amply { };

  amqp = callPackage ../development/python-modules/amqp { };

  amqtt = callPackage ../development/python-modules/amqtt { };

  amshan = callPackage ../development/python-modules/amshan { };

  anchor-kr = callPackage ../development/python-modules/anchor-kr { };

  ancp-bids = callPackage ../development/python-modules/ancp-bids { };

  androguard = callPackage ../development/python-modules/androguard { };

  android-backup = callPackage ../development/python-modules/android-backup { };

  androidtv = callPackage ../development/python-modules/androidtv { };

  androidtvremote2 = callPackage ../development/python-modules/androidtvremote2 { };

  anel-pwrctrl-homeassistant =
    callPackage ../development/python-modules/anel-pwrctrl-homeassistant
      { };

  angr = callPackage ../development/python-modules/angr { };

  angrcli = callPackage ../development/python-modules/angrcli { inherit (pkgs) coreutils; };

  angrop = callPackage ../development/python-modules/angrop { };

  aniso8601 = callPackage ../development/python-modules/aniso8601 { };

  anitopy = callPackage ../development/python-modules/anitopy { };

  anndata = callPackage ../development/python-modules/anndata { };

  annexremote = callPackage ../development/python-modules/annexremote { };

  annotated-types = callPackage ../development/python-modules/annotated-types { };

  annotatedyaml = callPackage ../development/python-modules/annotatedyaml { };

  annoy = callPackage ../development/python-modules/annoy { };

  anonip = callPackage ../development/python-modules/anonip { };

  anonymizeip = callPackage ../development/python-modules/anonymizeip { };

  anova-wifi = callPackage ../development/python-modules/anova-wifi { };

  ansi = callPackage ../development/python-modules/ansi { };

  ansi2html = callPackage ../development/python-modules/ansi2html { };

  ansi2image = callPackage ../development/python-modules/ansi2image { };

  ansible = callPackage ../development/python-modules/ansible { };

  ansible-builder = callPackage ../development/python-modules/ansible-builder {
    inherit (pkgs) podman;
  };

  ansible-compat = callPackage ../development/python-modules/ansible-compat { };

  ansible-core = callPackage ../development/python-modules/ansible/core.nix { };

  ansible-kernel = callPackage ../development/python-modules/ansible-kernel { };

  ansible-pylibssh = callPackage ../development/python-modules/ansible-pylibssh { };

  ansible-runner = callPackage ../development/python-modules/ansible-runner { };

  ansible-vault-rw = callPackage ../development/python-modules/ansible-vault-rw { };

  ansicolor = callPackage ../development/python-modules/ansicolor { };

  ansicolors = callPackage ../development/python-modules/ansicolors { };

  ansiconv = callPackage ../development/python-modules/ansiconv { };

  ansimarkup = callPackage ../development/python-modules/ansimarkup { };

  ansitable = callPackage ../development/python-modules/ansitable { };

  anthemav = callPackage ../development/python-modules/anthemav { };

  anthropic = callPackage ../development/python-modules/anthropic { };

  antlr4-python3-runtime = callPackage ../development/python-modules/antlr4-python3-runtime {
    inherit (pkgs) antlr4;
  };

  anyascii = callPackage ../development/python-modules/anyascii { };

  anybadge = callPackage ../development/python-modules/anybadge { };

  anyconfig = callPackage ../development/python-modules/anyconfig { };

  anyio = callPackage ../development/python-modules/anyio { };

  anyqt = callPackage ../development/python-modules/anyqt { };

  anysqlite = callPackage ../development/python-modules/anysqlite { };

  anytree = callPackage ../development/python-modules/anytree { inherit (pkgs) graphviz; };

  anywidget = callPackage ../development/python-modules/anywidget { };

  aocd = callPackage ../development/python-modules/aocd { };

  aocd-example-parser = callPackage ../development/python-modules/aocd-example-parser { };

  apache-beam = callPackage ../development/python-modules/apache-beam { };

  apcaccess = callPackage ../development/python-modules/apcaccess { };

  apeye = callPackage ../development/python-modules/apeye { };

  apeye-core = callPackage ../development/python-modules/apeye-core { };

  apipkg = callPackage ../development/python-modules/apipkg { };

  apischema = callPackage ../development/python-modules/apischema { };

  apispec = callPackage ../development/python-modules/apispec { };

  apispec-webframeworks = callPackage ../development/python-modules/apispec-webframeworks { };

  apkinspector = callPackage ../development/python-modules/apkinspector { };

  aplpy = callPackage ../development/python-modules/aplpy { };

  apollo-fpga = callPackage ../development/python-modules/apollo-fpga { };

  app-model = callPackage ../development/python-modules/app-model { };

  appdirs = callPackage ../development/python-modules/appdirs { };

  appimage = callPackage ../development/python-modules/appimage { };

  appium-python-client = callPackage ../development/python-modules/appium-python-client { };

  apple-compress = callPackage ../development/python-modules/apple-compress { };

  apple-weatherkit = callPackage ../development/python-modules/apple-weatherkit { };

  applicationinsights = callPackage ../development/python-modules/applicationinsights { };

  appnope = callPackage ../development/python-modules/appnope { };

  apprise = callPackage ../development/python-modules/apprise { };

  approval-utilities = callPackage ../development/python-modules/approval-utilities { };

  approvaltests = callPackage ../development/python-modules/approvaltests { };

  appthreat-vulnerability-db =
    callPackage ../development/python-modules/appthreat-vulnerability-db
      { };

  apptools = callPackage ../development/python-modules/apptools { };

  apricot-select = callPackage ../development/python-modules/apricot-select { };

  aprslib = callPackage ../development/python-modules/aprslib { };

  apscheduler = callPackage ../development/python-modules/apscheduler { };

  apsw = callPackage ../development/python-modules/apsw { };

  apsystems-ez1 = callPackage ../development/python-modules/apsystems-ez1 { };

  apt-repo = callPackage ../development/python-modules/apt-repo { };

  apted = callPackage ../development/python-modules/apted { };

  apycula = callPackage ../development/python-modules/apycula { };

  apykuma = callPackage ../development/python-modules/apykuma { };

  aqipy-atmotech = callPackage ../development/python-modules/aqipy-atmotech { };

  aqualogic = callPackage ../development/python-modules/aqualogic { };

  ar = callPackage ../development/python-modules/ar { };

  arabic-reshaper = callPackage ../development/python-modules/arabic-reshaper { };

  aranet4 = callPackage ../development/python-modules/aranet4 { };

  arc4 = callPackage ../development/python-modules/arc4 { };

  arcam-fmj = callPackage ../development/python-modules/arcam-fmj { };

  arch = callPackage ../development/python-modules/arch { };

  archinfo = callPackage ../development/python-modules/archinfo { };

  archspec = callPackage ../development/python-modules/archspec { };

  area = callPackage ../development/python-modules/area { };

  arelle = callPackage ../development/python-modules/arelle { gui = true; };

  arelle-headless = callPackage ../development/python-modules/arelle { gui = false; };

  aresponses = callPackage ../development/python-modules/aresponses { };

  argcomplete = callPackage ../development/python-modules/argcomplete { };

  argh = callPackage ../development/python-modules/argh { };

  argilla = callPackage ../development/python-modules/argilla { };

  argon2-cffi = callPackage ../development/python-modules/argon2-cffi { };

  argon2-cffi-bindings = callPackage ../development/python-modules/argon2-cffi-bindings { };

  argos-translate-files = callPackage ../development/python-modules/argos-translate-files { };

  argostranslate = callPackage ../development/python-modules/argostranslate {
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  argparse-addons = callPackage ../development/python-modules/argparse-addons { };

  argparse-dataclass = callPackage ../development/python-modules/argparse-dataclass { };

  argparse-manpage = callPackage ../development/python-modules/argparse-manpage { };

  args = callPackage ../development/python-modules/args { };

  aria2p = callPackage ../development/python-modules/aria2p { };

  ariadne = callPackage ../development/python-modules/ariadne { };

  arpeggio = callPackage ../development/python-modules/arpeggio { };

  arpy = callPackage ../development/python-modules/arpy { };

  array-api-compat = callPackage ../development/python-modules/array-api-compat { };

  array-api-strict = callPackage ../development/python-modules/array-api-strict { };

  array-record = callPackage ../development/python-modules/array-record { };

  arrayqueues = callPackage ../development/python-modules/arrayqueues { };

  arris-tg2492lg = callPackage ../development/python-modules/arris-tg2492lg { };

  arro3-compute = (callPackage ../development/python-modules/arro3 { }).arro3-compute;

  arro3-core = (callPackage ../development/python-modules/arro3 { }).arro3-core;

  arro3-io = (callPackage ../development/python-modules/arro3 { }).arro3-io;

  arrow = callPackage ../development/python-modules/arrow { };

  arsenic = callPackage ../development/python-modules/arsenic { };

  art = callPackage ../development/python-modules/art { };

  arviz = callPackage ../development/python-modules/arviz { };

  arxiv = callPackage ../development/python-modules/arxiv { };

  arxiv2bib = callPackage ../development/python-modules/arxiv2bib { };

  asana = callPackage ../development/python-modules/asana { };

  ascii-magic = callPackage ../development/python-modules/ascii-magic { };

  asciimatics = callPackage ../development/python-modules/asciimatics { };

  asciitree = callPackage ../development/python-modules/asciitree { };

  asdf = callPackage ../development/python-modules/asdf { };

  asdf-astropy = callPackage ../development/python-modules/asdf-astropy { };

  asdf-coordinates-schemas = callPackage ../development/python-modules/asdf-coordinates-schemas { };

  asdf-standard = callPackage ../development/python-modules/asdf-standard { };

  asdf-transform-schemas = callPackage ../development/python-modules/asdf-transform-schemas { };

  asdf-wcs-schemas = callPackage ../development/python-modules/asdf-wcs-schemas { };

  ase = callPackage ../development/python-modules/ase { };

  asf-search = callPackage ../development/python-modules/asf-search { };

  asgi-csrf = callPackage ../development/python-modules/asgi-csrf { };

  asgi-lifespan = callPackage ../development/python-modules/asgi-lifespan { };

  asgi-logger = callPackage ../development/python-modules/asgi-logger { };

  asgineer = callPackage ../development/python-modules/asgineer { };

  asgiref = callPackage ../development/python-modules/asgiref { };

  asks = callPackage ../development/python-modules/asks { };

  asmog = callPackage ../development/python-modules/asmog { };

  asn1 = callPackage ../development/python-modules/asn1 { };

  asn1ate = callPackage ../development/python-modules/asn1ate { };

  asn1crypto = callPackage ../development/python-modules/asn1crypto { };

  asn1tools = callPackage ../development/python-modules/asn1tools { };

  aspectlib = callPackage ../development/python-modules/aspectlib { };

  aspell-python = callPackage ../development/python-modules/aspell-python { };

  aspy-refactor-imports = callPackage ../development/python-modules/aspy-refactor-imports { };

  aspy-yaml = callPackage ../development/python-modules/aspy-yaml { };

  assay = callPackage ../development/python-modules/assay { };

  assertpy = callPackage ../development/python-modules/assertpy { };

  asserts = callPackage ../development/python-modules/asserts { };

  ast-grep-py = callPackage ../development/python-modules/ast-grep-py { };

  asterisk-mbox = callPackage ../development/python-modules/asterisk-mbox { };

  asteroid-filterbanks = callPackage ../development/python-modules/asteroid-filterbanks { };

  asteval = callPackage ../development/python-modules/asteval { };

  astor = callPackage ../development/python-modules/astor { };

  astral = callPackage ../development/python-modules/astral { };

  astroid = callPackage ../development/python-modules/astroid { };

  astropy = callPackage ../development/python-modules/astropy { };

  astropy-healpix = callPackage ../development/python-modules/astropy-healpix { };

  astropy-helpers = callPackage ../development/python-modules/astropy-helpers { };

  astropy-iers-data = callPackage ../development/python-modules/astropy-iers-data { };

  astroquery = callPackage ../development/python-modules/astroquery { };

  asttokens = callPackage ../development/python-modules/asttokens { };

  astunparse = callPackage ../development/python-modules/astunparse { };

  asusrouter = callPackage ../development/python-modules/asusrouter { };

  asyauth = callPackage ../development/python-modules/asyauth { };

  async-cache = callPackage ../development/python-modules/async-cache { };

  async-dns = callPackage ../development/python-modules/async-dns { };

  async-generator = callPackage ../development/python-modules/async-generator { };

  async-interrupt = callPackage ../development/python-modules/async-interrupt { };

  async-lru = callPackage ../development/python-modules/async-lru { };

  async-modbus = callPackage ../development/python-modules/async-modbus { };

  async-stagger = callPackage ../development/python-modules/async-stagger { };

  async-timeout = callPackage ../development/python-modules/async-timeout { };

  async-tkinter-loop = callPackage ../development/python-modules/async-tkinter-loop { };

  async-upnp-client = callPackage ../development/python-modules/async-upnp-client { };

  asyncarve = callPackage ../development/python-modules/asyncarve { };

  asyncclick = callPackage ../development/python-modules/asyncclick { };

  asynccmd = callPackage ../development/python-modules/asynccmd { };

  asyncer = callPackage ../development/python-modules/asyncer { };

  asyncinotify = callPackage ../development/python-modules/asyncinotify { };

  asyncio-dgram = callPackage ../development/python-modules/asyncio-dgram { };

  asyncio-rlock = callPackage ../development/python-modules/asyncio-rlock { };

  asyncio-throttle = callPackage ../development/python-modules/asyncio-throttle { };

  asyncmy = callPackage ../development/python-modules/asyncmy { };

  asyncpg = callPackage ../development/python-modules/asyncpg { };

  asyncpraw = callPackage ../development/python-modules/asyncpraw { };

  asyncprawcore = callPackage ../development/python-modules/asyncprawcore { };

  asyncpysupla = callPackage ../development/python-modules/asyncpysupla { };

  asyncserial = callPackage ../development/python-modules/asyncserial { };

  asyncsleepiq = callPackage ../development/python-modules/asyncsleepiq { };

  asyncssh = callPackage ../development/python-modules/asyncssh { };

  asyncstdlib = callPackage ../development/python-modules/asyncstdlib { };

  asyncstdlib-fw = callPackage ../development/python-modules/asyncstdlib-fw { };

  asynctest = callPackage ../development/python-modules/asynctest { };

  asyncua = callPackage ../development/python-modules/asyncua { };

  asyncwhois = callPackage ../development/python-modules/asyncwhois { };

  asysocks = callPackage ../development/python-modules/asysocks { };

  atc-ble = callPackage ../development/python-modules/atc-ble { };

  atenpdu = callPackage ../development/python-modules/atenpdu { };

  atlassian-python-api = callPackage ../development/python-modules/atlassian-python-api { };

  atom = callPackage ../development/python-modules/atom { };

  atomiclong = callPackage ../development/python-modules/atomiclong { };

  atomicwrites = callPackage ../development/python-modules/atomicwrites { };

  atomicwrites-homeassistant =
    callPackage ../development/python-modules/atomicwrites-homeassistant
      { };

  atomman = callPackage ../development/python-modules/atomman { };

  atopile = callPackage ../development/python-modules/atopile { };

  atopile-easyeda2kicad = callPackage ../development/python-modules/atopile-easyeda2kicad { };

  atproto = callPackage ../development/python-modules/atproto { };

  atpublic = callPackage ../development/python-modules/atpublic { };

  atsim-potentials = callPackage ../development/python-modules/atsim-potentials { };

  attacut = callPackage ../development/python-modules/attacut { };

  attr = callPackage ../development/python-modules/attr { };

  attrdict = callPackage ../development/python-modules/attrdict { };

  attrs = callPackage ../development/python-modules/attrs { };

  attrs-strict = callPackage ../development/python-modules/attrs-strict { };

  aubio = callPackage ../development/python-modules/aubio { };

  audible = callPackage ../development/python-modules/audible { };

  audio-metadata = callPackage ../development/python-modules/audio-metadata { };

  audioop-lts =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/audioop-lts { } else null;

  audioread = callPackage ../development/python-modules/audioread { };

  audiotools = callPackage ../development/python-modules/audiotools { };

  audit = toPythonModule (
    pkgs.audit.override {
      python3Packages = self;
    }
  );

  auditok = callPackage ../development/python-modules/auditok { };

  auditwheel = callPackage ../development/python-modules/auditwheel {
    inherit (pkgs)
      bzip2
      gnutar
      patchelf
      unzip
      ;
  };

  augeas = callPackage ../development/python-modules/augeas { inherit (pkgs) augeas; };

  augmax = callPackage ../development/python-modules/augmax { };

  auroranoaa = callPackage ../development/python-modules/auroranoaa { };

  aurorapy = callPackage ../development/python-modules/aurorapy { };

  autarco = callPackage ../development/python-modules/autarco { };

  auth0-python = callPackage ../development/python-modules/auth0-python { };

  authcaptureproxy = callPackage ../development/python-modules/authcaptureproxy { };

  authheaders = callPackage ../development/python-modules/authheaders { };

  authlib = callPackage ../development/python-modules/authlib { };

  authres = callPackage ../development/python-modules/authres { };

  auto-lazy-imports = callPackage ../development/python-modules/auto-lazy-imports { };

  autobahn = callPackage ../development/python-modules/autobahn { };

  autocommand = callPackage ../development/python-modules/autocommand { };

  autodocsumm = callPackage ../development/python-modules/autodocsumm { };

  autofaiss = callPackage ../development/python-modules/autofaiss { };

  autoflake = callPackage ../development/python-modules/autoflake { };

  autograd = callPackage ../development/python-modules/autograd { };

  autograd-gamma = callPackage ../development/python-modules/autograd-gamma { };

  autoit-ripper = callPackage ../development/python-modules/autoit-ripper { };

  autologging = callPackage ../development/python-modules/autologging { };

  automat = callPackage ../development/python-modules/automat { };

  automate-home = callPackage ../development/python-modules/automate-home { };

  automower-ble = callPackage ../development/python-modules/automower-ble { };

  automx2 = callPackage ../development/python-modules/automx2 { };

  autopage = callPackage ../development/python-modules/autopage { };

  autopep8 = callPackage ../development/python-modules/autopep8 { };

  autopxd2 = callPackage ../development/python-modules/autopxd2 { };

  autoslot = callPackage ../development/python-modules/autoslot { };

  av = callPackage ../development/python-modules/av { };

  av_13 = callPackage ../development/python-modules/av_13 { };

  avahi = toPythonModule (
    pkgs.avahi.override {
      inherit python;
      withPython = true;
    }
  );

  avea = callPackage ../development/python-modules/avea { };

  avidtools = callPackage ../development/python-modules/avidtools { };

  avion = callPackage ../development/python-modules/avion { };

  avro = callPackage ../development/python-modules/avro { };

  avro-python3 = callPackage ../development/python-modules/avro-python3 { };

  avro3k = callPackage ../development/python-modules/avro3k { };

  avwx-engine = callPackage ../development/python-modules/avwx-engine { };

  aw-client = callPackage ../development/python-modules/aw-client { };

  aw-core = callPackage ../development/python-modules/aw-core { };

  awacs = callPackage ../development/python-modules/awacs { };

  awesome-slugify = callPackage ../development/python-modules/awesome-slugify { };

  awesomeversion = callPackage ../development/python-modules/awesomeversion { };

  awkward = callPackage ../development/python-modules/awkward { };

  awkward-cpp = callPackage ../development/python-modules/awkward-cpp { inherit (pkgs) cmake ninja; };

  awkward-pandas = callPackage ../development/python-modules/awkward-pandas { };

  aws-adfs = callPackage ../development/python-modules/aws-adfs { };

  aws-encryption-sdk = callPackage ../development/python-modules/aws-encryption-sdk { };

  aws-error-utils = callPackage ../development/python-modules/aws-error-utils { };

  aws-lambda-builders = callPackage ../development/python-modules/aws-lambda-builders { };

  aws-request-signer = callPackage ../development/python-modules/aws-request-signer { };

  aws-sam-translator = callPackage ../development/python-modules/aws-sam-translator { };

  aws-secretsmanager-caching =
    callPackage ../development/python-modules/aws-secretsmanager-caching
      { };

  aws-sso-lib = callPackage ../development/python-modules/aws-sso-lib { };

  aws-xray-sdk = callPackage ../development/python-modules/aws-xray-sdk { };

  awscrt = callPackage ../development/python-modules/awscrt { };

  awsiotpythonsdk = callPackage ../development/python-modules/awsiotpythonsdk { };

  awsiotsdk = callPackage ../development/python-modules/awsiotsdk { };

  awsipranges = callPackage ../development/python-modules/awsipranges { };

  awslambdaric = callPackage ../development/python-modules/awslambdaric { };

  awswrangler = callPackage ../development/python-modules/awswrangler { };

  ax-platform = callPackage ../development/python-modules/ax-platform { };

  axis = callPackage ../development/python-modules/axis { };

  axisregistry = callPackage ../development/python-modules/axisregistry { };

  ayla-iot-unofficial = callPackage ../development/python-modules/ayla-iot-unofficial { };

  azure-ai-agents = callPackage ../development/python-modules/azure-ai-agents { };

  azure-ai-documentintelligence =
    callPackage ../development/python-modules/azure-ai-documentintelligence
      { };

  azure-ai-projects = callPackage ../development/python-modules/azure-ai-projects { };

  azure-ai-vision-imageanalysis =
    callPackage ../development/python-modules/azure-ai-vision-imageanalysis
      { };

  azure-appconfiguration = callPackage ../development/python-modules/azure-appconfiguration { };

  azure-applicationinsights = callPackage ../development/python-modules/azure-applicationinsights { };

  azure-batch = callPackage ../development/python-modules/azure-batch { };

  azure-common = callPackage ../development/python-modules/azure-common { };

  azure-containerregistry = callPackage ../development/python-modules/azure-containerregistry { };

  azure-core = callPackage ../development/python-modules/azure-core { };

  azure-cosmos = callPackage ../development/python-modules/azure-cosmos { };

  azure-cosmosdb-nspkg = callPackage ../development/python-modules/azure-cosmosdb-nspkg { };

  azure-cosmosdb-table = callPackage ../development/python-modules/azure-cosmosdb-table { };

  azure-data-tables = callPackage ../development/python-modules/azure-data-tables { };

  azure-datalake-store = callPackage ../development/python-modules/azure-datalake-store { };

  azure-eventgrid = callPackage ../development/python-modules/azure-eventgrid { };

  azure-eventhub = callPackage ../development/python-modules/azure-eventhub { };

  azure-graphrbac = callPackage ../development/python-modules/azure-graphrbac { };

  azure-identity = callPackage ../development/python-modules/azure-identity { };

  azure-iot-device = callPackage ../development/python-modules/azure-iot-device { };

  azure-keyvault = callPackage ../development/python-modules/azure-keyvault { };

  azure-keyvault-administration =
    callPackage ../development/python-modules/azure-keyvault-administration
      { };

  azure-keyvault-certificates =
    callPackage ../development/python-modules/azure-keyvault-certificates
      { };

  azure-keyvault-keys = callPackage ../development/python-modules/azure-keyvault-keys { };

  azure-keyvault-nspkg = callPackage ../development/python-modules/azure-keyvault-nspkg { };

  azure-keyvault-secrets = callPackage ../development/python-modules/azure-keyvault-secrets { };

  azure-keyvault-securitydomain =
    callPackage ../development/python-modules/azure-keyvault-securitydomain
      { };

  azure-kusto-data = callPackage ../development/python-modules/azure-kusto-data { };

  azure-kusto-ingest = callPackage ../development/python-modules/azure-kusto-ingest { };

  azure-loganalytics = callPackage ../development/python-modules/azure-loganalytics { };

  azure-mgmt-advisor = callPackage ../development/python-modules/azure-mgmt-advisor { };

  azure-mgmt-apimanagement = callPackage ../development/python-modules/azure-mgmt-apimanagement { };

  azure-mgmt-appconfiguration =
    callPackage ../development/python-modules/azure-mgmt-appconfiguration
      { };

  azure-mgmt-appcontainers = callPackage ../development/python-modules/azure-mgmt-appcontainers { };

  azure-mgmt-applicationinsights =
    callPackage ../development/python-modules/azure-mgmt-applicationinsights
      { };

  azure-mgmt-authorization = callPackage ../development/python-modules/azure-mgmt-authorization { };

  azure-mgmt-automation = callPackage ../development/python-modules/azure-mgmt-automation { };

  azure-mgmt-batch = callPackage ../development/python-modules/azure-mgmt-batch { };

  azure-mgmt-batchai = callPackage ../development/python-modules/azure-mgmt-batchai { };

  azure-mgmt-billing = callPackage ../development/python-modules/azure-mgmt-billing { };

  azure-mgmt-botservice = callPackage ../development/python-modules/azure-mgmt-botservice { };

  azure-mgmt-cdn = callPackage ../development/python-modules/azure-mgmt-cdn { };

  azure-mgmt-cognitiveservices =
    callPackage ../development/python-modules/azure-mgmt-cognitiveservices
      { };

  azure-mgmt-commerce = callPackage ../development/python-modules/azure-mgmt-commerce { };

  azure-mgmt-common = callPackage ../development/python-modules/azure-mgmt-common { };

  azure-mgmt-compute = callPackage ../development/python-modules/azure-mgmt-compute { };

  azure-mgmt-consumption = callPackage ../development/python-modules/azure-mgmt-consumption { };

  azure-mgmt-containerinstance =
    callPackage ../development/python-modules/azure-mgmt-containerinstance
      { };

  azure-mgmt-containerregistry =
    callPackage ../development/python-modules/azure-mgmt-containerregistry
      { };

  azure-mgmt-containerservice =
    callPackage ../development/python-modules/azure-mgmt-containerservice
      { };

  azure-mgmt-core = callPackage ../development/python-modules/azure-mgmt-core { };

  azure-mgmt-cosmosdb = callPackage ../development/python-modules/azure-mgmt-cosmosdb { };

  azure-mgmt-dashboard = callPackage ../development/python-modules/azure-mgmt-dashboard { };

  azure-mgmt-databoxedge = callPackage ../development/python-modules/azure-mgmt-databoxedge { };

  azure-mgmt-databricks = callPackage ../development/python-modules/azure-mgmt-databricks { };

  azure-mgmt-datafactory = callPackage ../development/python-modules/azure-mgmt-datafactory { };

  azure-mgmt-datalake-analytics =
    callPackage ../development/python-modules/azure-mgmt-datalake-analytics
      { };

  azure-mgmt-datalake-nspkg = callPackage ../development/python-modules/azure-mgmt-datalake-nspkg { };

  azure-mgmt-datalake-store = callPackage ../development/python-modules/azure-mgmt-datalake-store { };

  azure-mgmt-datamigration = callPackage ../development/python-modules/azure-mgmt-datamigration { };

  azure-mgmt-deploymentmanager =
    callPackage ../development/python-modules/azure-mgmt-deploymentmanager
      { };

  azure-mgmt-devspaces = callPackage ../development/python-modules/azure-mgmt-devspaces { };

  azure-mgmt-devtestlabs = callPackage ../development/python-modules/azure-mgmt-devtestlabs { };

  azure-mgmt-dns = callPackage ../development/python-modules/azure-mgmt-dns { };

  azure-mgmt-eventgrid = callPackage ../development/python-modules/azure-mgmt-eventgrid { };

  azure-mgmt-eventhub = callPackage ../development/python-modules/azure-mgmt-eventhub { };

  azure-mgmt-extendedlocation =
    callPackage ../development/python-modules/azure-mgmt-extendedlocation
      { };

  azure-mgmt-frontdoor = callPackage ../development/python-modules/azure-mgmt-frontdoor { };

  azure-mgmt-hanaonazure = callPackage ../development/python-modules/azure-mgmt-hanaonazure { };

  azure-mgmt-hdinsight = callPackage ../development/python-modules/azure-mgmt-hdinsight { };

  azure-mgmt-hybridcompute = callPackage ../development/python-modules/azure-mgmt-hybridcompute { };

  azure-mgmt-imagebuilder = callPackage ../development/python-modules/azure-mgmt-imagebuilder { };

  azure-mgmt-iotcentral = callPackage ../development/python-modules/azure-mgmt-iotcentral { };

  azure-mgmt-iothub = callPackage ../development/python-modules/azure-mgmt-iothub { };

  azure-mgmt-iothubprovisioningservices =
    callPackage ../development/python-modules/azure-mgmt-iothubprovisioningservices
      { };

  azure-mgmt-keyvault = callPackage ../development/python-modules/azure-mgmt-keyvault { };

  azure-mgmt-kusto = callPackage ../development/python-modules/azure-mgmt-kusto { };

  azure-mgmt-loganalytics = callPackage ../development/python-modules/azure-mgmt-loganalytics { };

  azure-mgmt-logic = callPackage ../development/python-modules/azure-mgmt-logic { };

  azure-mgmt-machinelearningcompute =
    callPackage ../development/python-modules/azure-mgmt-machinelearningcompute
      { };

  azure-mgmt-managedservices =
    callPackage ../development/python-modules/azure-mgmt-managedservices
      { };

  azure-mgmt-managementgroups =
    callPackage ../development/python-modules/azure-mgmt-managementgroups
      { };

  azure-mgmt-managementpartner =
    callPackage ../development/python-modules/azure-mgmt-managementpartner
      { };

  azure-mgmt-maps = callPackage ../development/python-modules/azure-mgmt-maps { };

  azure-mgmt-marketplaceordering =
    callPackage ../development/python-modules/azure-mgmt-marketplaceordering
      { };

  azure-mgmt-media = callPackage ../development/python-modules/azure-mgmt-media { };

  azure-mgmt-monitor = callPackage ../development/python-modules/azure-mgmt-monitor { };

  azure-mgmt-msi = callPackage ../development/python-modules/azure-mgmt-msi { };

  azure-mgmt-mysqlflexibleservers =
    callPackage ../development/python-modules/azure-mgmt-mysqlflexibleservers
      { };

  azure-mgmt-netapp = callPackage ../development/python-modules/azure-mgmt-netapp { };

  azure-mgmt-network = callPackage ../development/python-modules/azure-mgmt-network { };

  azure-mgmt-notificationhubs =
    callPackage ../development/python-modules/azure-mgmt-notificationhubs
      { };

  azure-mgmt-nspkg = callPackage ../development/python-modules/azure-mgmt-nspkg { };

  azure-mgmt-policyinsights = callPackage ../development/python-modules/azure-mgmt-policyinsights { };

  azure-mgmt-postgresqlflexibleservers =
    callPackage ../development/python-modules/azure-mgmt-postgresqlflexibleservers
      { };

  azure-mgmt-powerbiembedded =
    callPackage ../development/python-modules/azure-mgmt-powerbiembedded
      { };

  azure-mgmt-privatedns = callPackage ../development/python-modules/azure-mgmt-privatedns { };

  azure-mgmt-rdbms = callPackage ../development/python-modules/azure-mgmt-rdbms { };

  azure-mgmt-recoveryservices =
    callPackage ../development/python-modules/azure-mgmt-recoveryservices
      { };

  azure-mgmt-recoveryservicesbackup =
    callPackage ../development/python-modules/azure-mgmt-recoveryservicesbackup
      { };

  azure-mgmt-redhatopenshift =
    callPackage ../development/python-modules/azure-mgmt-redhatopenshift
      { };

  azure-mgmt-redis = callPackage ../development/python-modules/azure-mgmt-redis { };

  azure-mgmt-relay = callPackage ../development/python-modules/azure-mgmt-relay { };

  azure-mgmt-reservations = callPackage ../development/python-modules/azure-mgmt-reservations { };

  azure-mgmt-resource = callPackage ../development/python-modules/azure-mgmt-resource { };

  azure-mgmt-resource-deployments =
    callPackage ../development/python-modules/azure-mgmt-resource-deployments
      { };

  azure-mgmt-resource-deploymentscripts =
    callPackage ../development/python-modules/azure-mgmt-resource-deploymentscripts
      { };

  azure-mgmt-resource-deploymentstacks =
    callPackage ../development/python-modules/azure-mgmt-resource-deploymentstacks
      { };

  azure-mgmt-resource-templatespecs =
    callPackage ../development/python-modules/azure-mgmt-resource-templatespecs
      { };

  azure-mgmt-scheduler = callPackage ../development/python-modules/azure-mgmt-scheduler { };

  azure-mgmt-search = callPackage ../development/python-modules/azure-mgmt-search { };

  azure-mgmt-security = callPackage ../development/python-modules/azure-mgmt-security { };

  azure-mgmt-servicebus = callPackage ../development/python-modules/azure-mgmt-servicebus { };

  azure-mgmt-servicefabric = callPackage ../development/python-modules/azure-mgmt-servicefabric { };

  azure-mgmt-servicefabricmanagedclusters =
    callPackage ../development/python-modules/azure-mgmt-servicefabricmanagedclusters
      { };

  azure-mgmt-servicelinker = callPackage ../development/python-modules/azure-mgmt-servicelinker { };

  azure-mgmt-signalr = callPackage ../development/python-modules/azure-mgmt-signalr { };

  azure-mgmt-sql = callPackage ../development/python-modules/azure-mgmt-sql { };

  azure-mgmt-sqlvirtualmachine =
    callPackage ../development/python-modules/azure-mgmt-sqlvirtualmachine
      { };

  azure-mgmt-storage = callPackage ../development/python-modules/azure-mgmt-storage { };

  azure-mgmt-subscription = callPackage ../development/python-modules/azure-mgmt-subscription { };

  azure-mgmt-synapse = callPackage ../development/python-modules/azure-mgmt-synapse { };

  azure-mgmt-trafficmanager = callPackage ../development/python-modules/azure-mgmt-trafficmanager { };

  azure-mgmt-web = callPackage ../development/python-modules/azure-mgmt-web { };

  azure-monitor-ingestion = callPackage ../development/python-modules/azure-monitor-ingestion { };

  azure-monitor-query = callPackage ../development/python-modules/azure-monitor-query { };

  azure-multiapi-storage = callPackage ../development/python-modules/azure-multiapi-storage { };

  azure-nspkg = callPackage ../development/python-modules/azure-nspkg { };

  azure-search-documents = callPackage ../development/python-modules/azure-search-documents { };

  azure-servicebus = callPackage ../development/python-modules/azure-servicebus { };

  azure-servicefabric = callPackage ../development/python-modules/azure-servicefabric { };

  azure-servicemanagement-legacy =
    callPackage ../development/python-modules/azure-servicemanagement-legacy
      { };

  azure-storage-blob = callPackage ../development/python-modules/azure-storage-blob { };

  azure-storage-common = callPackage ../development/python-modules/azure-storage-common { };

  azure-storage-file = callPackage ../development/python-modules/azure-storage-file { };

  azure-storage-file-datalake =
    callPackage ../development/python-modules/azure-storage-file-datalake
      { };

  azure-storage-file-share = callPackage ../development/python-modules/azure-storage-file-share { };

  azure-storage-nspkg = callPackage ../development/python-modules/azure-storage-nspkg { };

  azure-storage-queue = callPackage ../development/python-modules/azure-storage-queue { };

  azure-synapse-accesscontrol =
    callPackage ../development/python-modules/azure-synapse-accesscontrol
      { };

  azure-synapse-artifacts = callPackage ../development/python-modules/azure-synapse-artifacts { };

  azure-synapse-managedprivateendpoints =
    callPackage ../development/python-modules/azure-synapse-managedprivateendpoints
      { };

  azure-synapse-spark = callPackage ../development/python-modules/azure-synapse-spark { };

  b2sdk = callPackage ../development/python-modules/b2sdk { };

  babel = callPackage ../development/python-modules/babel { };

  babelfish = callPackage ../development/python-modules/babelfish { };

  babelfont = callPackage ../development/python-modules/babelfont { };

  babelgladeextractor = callPackage ../development/python-modules/babelgladeextractor { };

  babeltrace = toPythonModule (
    pkgs.babeltrace.override {
      pythonPackages = self;
      enablePython = true;
    }
  );

  babeltrace2 = toPythonModule (
    pkgs.babeltrace2.override {
      inherit (self) python;
      pythonPackages = self;
      enablePython = true;
    }
  );

  backcall = callPackage ../development/python-modules/backcall { };

  backoff = callPackage ../development/python-modules/backoff { };

  backports-asyncio-runner =
    if pythonAtLeast "3.11" then
      null
    else
      callPackage ../development/python-modules/backports-asyncio-runner { };

  backports-datetime-fromisoformat =
    callPackage ../development/python-modules/backports-datetime-fromisoformat
      { };

  backports-entry-points-selectable =
    callPackage ../development/python-modules/backports-entry-points-selectable
      { };

  backports-shutil-which = callPackage ../development/python-modules/backports-shutil-which { };

  backports-strenum = callPackage ../development/python-modules/backports-strenum { };

  backports-tarfile = callPackage ../development/python-modules/backports-tarfile { };

  backports-zstd =
    if pythonAtLeast "3.14" then
      null
    else
      callPackage ../development/python-modules/backports-zstd {
        inherit (pkgs) zstd;
      };

  backrefs = callPackage ../development/python-modules/backrefs { };

  backtesting = callPackage ../development/python-modules/backtesting { };

  bacpypes = callPackage ../development/python-modules/bacpypes { };

  badauth = callPackage ../development/python-modules/badauth { };

  badldap = callPackage ../development/python-modules/badldap { };

  badsecrets = callPackage ../development/python-modules/badsecrets { };

  bagit = callPackage ../development/python-modules/bagit { };

  baidu-aip = callPackage ../development/python-modules/baidu-aip { };

  baize = callPackage ../development/python-modules/baize { };

  bambi = callPackage ../development/python-modules/bambi { };

  banal = callPackage ../development/python-modules/banal { };

  bandcamp-api = callPackage ../development/python-modules/bandcamp-api { };

  bandit = callPackage ../development/python-modules/bandit { };

  bangla = callPackage ../development/python-modules/bangla { };

  banks = callPackage ../development/python-modules/banks { };

  bap = callPackage ../development/python-modules/bap {
    inherit (pkgs.ocaml-ng.ocamlPackages_4_14) bap;
  };

  barectf = callPackage ../development/python-modules/barectf { };

  baron = callPackage ../development/python-modules/baron { };

  base2048 = callPackage ../development/python-modules/base2048 { };

  base36 = callPackage ../development/python-modules/base36 { };

  base58 = callPackage ../development/python-modules/base58 { };

  base58check = callPackage ../development/python-modules/base58check { };

  base64io = callPackage ../development/python-modules/base64io { };

  basedmypy = callPackage ../development/python-modules/basedmypy { };

  basedtyping = callPackage ../development/python-modules/basedtyping { };

  baseline = callPackage ../development/python-modules/baseline { };

  baselines = callPackage ../development/python-modules/baselines { };

  basemap = callPackage ../development/python-modules/basemap { };

  basemap-data = callPackage ../development/python-modules/basemap-data { };

  basemap-data-hires = callPackage ../development/python-modules/basemap-data-hires { };

  bases = callPackage ../development/python-modules/bases { };

  bash-kernel = callPackage ../development/python-modules/bash-kernel { };

  bashlex = callPackage ../development/python-modules/bashlex { };

  basiciw = callPackage ../development/python-modules/basiciw { };

  batchgenerators = callPackage ../development/python-modules/batchgenerators { };

  batchspawner = callPackage ../development/python-modules/batchspawner { };

  batinfo = callPackage ../development/python-modules/batinfo { };

  baycomp = callPackage ../development/python-modules/baycomp { };

  bayesian-optimization = callPackage ../development/python-modules/bayesian-optimization { };

  bayespy = callPackage ../development/python-modules/bayespy { };

  bbox = callPackage ../development/python-modules/bbox { };

  bc-detect-secrets = callPackage ../development/python-modules/bc-detect-secrets { };

  bc-jsonpath-ng = callPackage ../development/python-modules/bc-jsonpath-ng { };

  bc-python-hcl2 = callPackage ../development/python-modules/bc-python-hcl2 { };

  bcc = toPythonModule (pkgs.bcc.override { python3Packages = self; });

  bcdoc = callPackage ../development/python-modules/bcdoc { };

  bcf = callPackage ../development/python-modules/bcf { };

  bcg = callPackage ../development/python-modules/bcg { };

  bch = callPackage ../development/python-modules/bch { };

  bcrypt =
    if stdenv.hostPlatform.system == "i686-linux" then
      callPackage ../development/python-modules/bcrypt/3.nix { }
    else
      callPackage ../development/python-modules/bcrypt { };

  bdffont = callPackage ../development/python-modules/bdffont { };

  beacontools = callPackage ../development/python-modules/beacontools { };

  beaker = callPackage ../development/python-modules/beaker { };

  beancount = callPackage ../development/python-modules/beancount { };

  beancount-black = callPackage ../development/python-modules/beancount-black { };

  beancount-docverif = callPackage ../development/python-modules/beancount-docverif { };

  beancount-parser = callPackage ../development/python-modules/beancount-parser { };

  beancount-plugin-utils = callPackage ../development/python-modules/beancount-plugin-utils { };

  beancount_2 = callPackage ../development/python-modules/beancount/2.nix { };

  beangulp = callPackage ../development/python-modules/beangulp { };

  beanhub-cli = callPackage ../development/python-modules/beanhub-cli { };

  beanhub-extract = callPackage ../development/python-modules/beanhub-extract { };

  beanhub-forms = callPackage ../development/python-modules/beanhub-forms { };

  beanhub-import = callPackage ../development/python-modules/beanhub-import { };

  beanhub-inbox = callPackage ../development/python-modules/beanhub-inbox { };

  beanquery = callPackage ../development/python-modules/beanquery { };

  beanstalkc = callPackage ../development/python-modules/beanstalkc { };

  beartype = callPackage ../development/python-modules/beartype { };

  beaupy = callPackage ../development/python-modules/beaupy { };

  beautiful-date = callPackage ../development/python-modules/beautiful-date { };

  beautifulsoup4 = callPackage ../development/python-modules/beautifulsoup4 { };

  beautifultable = callPackage ../development/python-modules/beautifultable { };

  beautysh = callPackage ../development/python-modules/beautysh { };

  bech32 = callPackage ../development/python-modules/bech32 { };

  beetcamp = callPackage ../development/python-modules/beetcamp { };

  beets = callPackage ../development/python-modules/beets {
    inherit (pkgs) chromaprint;
  };

  beets-alternatives = callPackage ../development/python-modules/beets-alternatives { };

  beets-audible = callPackage ../development/python-modules/beets-audible { };

  beets-copyartifacts = callPackage ../development/python-modules/beets-copyartifacts { };

  beets-filetote = callPackage ../development/python-modules/beets-filetote { };

  beets-minimal = beets.override {
    disableAllPlugins = true;
  };

  beewi-smartclim = callPackage ../development/python-modules/beewi-smartclim { };

  before-after = callPackage ../development/python-modules/before-after { };

  behave = callPackage ../development/python-modules/behave { };

  bellows = callPackage ../development/python-modules/bellows { };

  bencode-py = callPackage ../development/python-modules/bencode-py { };

  bencoder = callPackage ../development/python-modules/bencoder { };

  bencodetools = callPackage ../development/python-modules/bencodetools {
    bencodetools = pkgs.bencodetools;
  };

  beniget = callPackage ../development/python-modules/beniget { };

  benqprojector = callPackage ../development/python-modules/benqprojector { };

  bentoml = callPackage ../development/python-modules/bentoml { };

  berkeleydb = callPackage ../development/python-modules/berkeleydb { };

  bespon = callPackage ../development/python-modules/bespon { };

  betacode = callPackage ../development/python-modules/betacode { };

  betamax = callPackage ../development/python-modules/betamax { };

  betamax-matchers = callPackage ../development/python-modules/betamax-matchers { };

  betamax-serializers = callPackage ../development/python-modules/betamax-serializers { };

  better-exceptions = callPackage ../development/python-modules/better-exceptions { };

  betterproto = callPackage ../development/python-modules/betterproto { };

  betterproto-fw = callPackage ../development/python-modules/betterproto-fw { };

  betterproto-rust-codec = callPackage ../development/python-modules/betterproto-rust-codec { };

  bezier = callPackage ../development/python-modules/bezier { };

  beziers = callPackage ../development/python-modules/beziers { };

  bgutil-ytdlp-pot-provider = callPackage ../development/python-modules/bgutil-ytdlp-pot-provider { };

  bibtexparser = callPackage ../development/python-modules/bibtexparser { };

  bibtexparser_2 = callPackage ../development/python-modules/bibtexparser/2.nix { };

  bidict = callPackage ../development/python-modules/bidict { };

  bids-validator = callPackage ../development/python-modules/bids-validator { };

  bidsschematools = callPackage ../development/python-modules/bidsschematools { };

  biliass = callPackage ../development/python-modules/biliass { };

  bilibili-api-python = callPackage ../development/python-modules/bilibili-api-python { };

  billiard = callPackage ../development/python-modules/billiard { };

  bimmer-connected = callPackage ../development/python-modules/bimmer-connected { };

  binance-connector = callPackage ../development/python-modules/binance-connector { };

  binary = callPackage ../development/python-modules/binary { };

  binary2strings = callPackage ../development/python-modules/binary2strings { };

  binaryornot = callPackage ../development/python-modules/binaryornot { };

  bincopy = callPackage ../development/python-modules/bincopy { };

  bindep = callPackage ../development/python-modules/bindep { };

  binho-host-adapter = callPackage ../development/python-modules/binho-host-adapter { };

  binsync = callPackage ../development/python-modules/binsync { };

  biocframe = callPackage ../development/python-modules/biocframe { };

  biocutils = callPackage ../development/python-modules/biocutils { };

  biom-format = callPackage ../development/python-modules/biom-format { };

  biopandas = callPackage ../development/python-modules/biopandas { };

  biopython = callPackage ../development/python-modules/biopython { };

  biosppy = callPackage ../development/python-modules/biosppy { };

  biothings-client = callPackage ../development/python-modules/biothings-client { };

  bip-utils = callPackage ../development/python-modules/bip-utils { };

  bip32 = callPackage ../development/python-modules/bip32 { };

  biplist = callPackage ../development/python-modules/biplist { };

  birch = callPackage ../development/python-modules/birch { };

  bitarray = callPackage ../development/python-modules/bitarray { };

  bitbox02 = callPackage ../development/python-modules/bitbox02 { };

  bitcoin-utils-fork-minimal =
    callPackage ../development/python-modules/bitcoin-utils-fork-minimal
      { };

  bitcoinrpc = callPackage ../development/python-modules/bitcoinrpc { };

  bite-parser = callPackage ../development/python-modules/bite-parser { };

  bitlist = callPackage ../development/python-modules/bitlist { };

  bitmath = callPackage ../development/python-modules/bitmath { };

  bitsandbytes = callPackage ../development/python-modules/bitsandbytes { };

  bitstring = callPackage ../development/python-modules/bitstring { };

  bitstruct = callPackage ../development/python-modules/bitstruct { };

  bitvavo-aio = callPackage ../development/python-modules/bitvavo-aio { };

  bitvector-for-humans = callPackage ../development/python-modules/bitvector-for-humans { };

  bizkaibus = callPackage ../development/python-modules/bizkaibus { };

  bk7231tools = callPackage ../development/python-modules/bk7231tools { };

  black = callPackage ../development/python-modules/black { };

  black-macchiato = callPackage ../development/python-modules/black-macchiato { };

  blacken-docs = callPackage ../development/python-modules/blacken-docs { };

  blackjax = callPackage ../development/python-modules/blackjax { };

  blackrenderer = callPackage ../development/python-modules/blackrenderer { };

  blake3 = callPackage ../development/python-modules/blake3 { };

  ble-serial = callPackage ../development/python-modules/ble-serial { };

  bleach = callPackage ../development/python-modules/bleach { };

  bleach-allowlist = callPackage ../development/python-modules/bleach-allowlist { };

  bleak = callPackage ../development/python-modules/bleak { };

  bleak-esphome = callPackage ../development/python-modules/bleak-esphome { };

  bleak-retry-connector = callPackage ../development/python-modules/bleak-retry-connector { };

  blebox-uniapi = callPackage ../development/python-modules/blebox-uniapi { };

  bless = callPackage ../development/python-modules/bless { };

  blessed = callPackage ../development/python-modules/blessed { };

  blinker = callPackage ../development/python-modules/blinker { };

  blinkpy = callPackage ../development/python-modules/blinkpy { };

  blinkstick = callPackage ../development/python-modules/blinkstick { };

  blis = callPackage ../development/python-modules/blis { };

  blivet = callPackage ../development/python-modules/blivet { };

  blobfile = callPackage ../development/python-modules/blobfile { };

  block-io = callPackage ../development/python-modules/block-io { };

  blockbuster = callPackage ../development/python-modules/blockbuster { };

  blockchain = callPackage ../development/python-modules/blockchain { };

  blockdiag = callPackage ../development/python-modules/blockdiag { };

  blockfrost-python = callPackage ../development/python-modules/blockfrost-python { };

  blocksat-cli = callPackage ../development/python-modules/blocksat-cli { };

  bloodhound-py = callPackage ../development/python-modules/bloodhound-py { };

  bloodyad = callPackage ../development/python-modules/bloodyad { };

  blosc2 = callPackage ../development/python-modules/blosc2 { };

  bluecurrent-api = callPackage ../development/python-modules/bluecurrent-api { };

  bluemaestro-ble = callPackage ../development/python-modules/bluemaestro-ble { };

  bluepy = callPackage ../development/python-modules/bluepy { };

  bluepy-devices = callPackage ../development/python-modules/bluepy-devices { };

  bluetooth-adapters = callPackage ../development/python-modules/bluetooth-adapters { };

  bluetooth-auto-recovery = callPackage ../development/python-modules/bluetooth-auto-recovery { };

  bluetooth-data-tools = callPackage ../development/python-modules/bluetooth-data-tools { };

  bluetooth-sensor-state-data =
    callPackage ../development/python-modules/bluetooth-sensor-state-data
      { };

  blurhash = callPackage ../development/python-modules/blurhash { };

  blurhash-python = callPackage ../development/python-modules/blurhash-python { };

  bme280spi = callPackage ../development/python-modules/bme280spi { };

  bme680 = callPackage ../development/python-modules/bme680 { };

  bnnumerizer = callPackage ../development/python-modules/bnnumerizer { };

  bnunicodenormalizer = callPackage ../development/python-modules/bnunicodenormalizer { };

  boa-api = callPackage ../development/python-modules/boa-api { };

  boiboite-opener-framework = callPackage ../development/python-modules/boiboite-opener-framework { };

  boilerpy3 = callPackage ../development/python-modules/boilerpy3 { };

  bokeh = callPackage ../development/python-modules/bokeh { };

  bokeh-sampledata = callPackage ../development/python-modules/bokeh-sampledata { };

  boltons = callPackage ../development/python-modules/boltons { };

  boltztrap2 = callPackage ../development/python-modules/boltztrap2 { };

  bond-api = callPackage ../development/python-modules/bond-api { };

  bond-async = callPackage ../development/python-modules/bond-async { };

  bonsai = callPackage ../development/python-modules/bonsai { };

  boolean-py = callPackage ../development/python-modules/boolean-py { };

  booleanoperations = callPackage ../development/python-modules/booleanoperations { };

  # Build boost for this specific Python version
  # TODO: use separate output for libboost_python.so
  boost = toPythonModule (
    pkgs.boost.override {
      inherit (self) python numpy;
      enablePython = true;
    }
  );

  boost-histogram = callPackage ../development/python-modules/boost-histogram {
    inherit (pkgs) boost;
  };

  borb = callPackage ../development/python-modules/borb { };

  bork = callPackage ../development/python-modules/bork { };

  bosch-alarm-mode2 = callPackage ../development/python-modules/bosch-alarm-mode2 { };

  boschshcpy = callPackage ../development/python-modules/boschshcpy { };

  bot-safe-agents = callPackage ../development/python-modules/bot-safe-agents { };

  botan3 = callPackage ../development/python-modules/botan3 { inherit (pkgs) botan3; };

  boto3 = callPackage ../development/python-modules/boto3 { };

  boto3-stubs = callPackage ../development/python-modules/boto3-stubs { };

  botocore = callPackage ../development/python-modules/botocore { };

  botocore-stubs = callPackage ../development/python-modules/botocore-stubs { };

  botorch = callPackage ../development/python-modules/botorch { };

  bottle = callPackage ../development/python-modules/bottle { };

  bottleneck = callPackage ../development/python-modules/bottleneck { };

  bottombar = callPackage ../development/python-modules/bottombar { };

  bpemb = callPackage ../development/python-modules/bpemb { };

  bpylist2 = callPackage ../development/python-modules/bpylist2 { };

  bpython = callPackage ../development/python-modules/bpython { };

  bqplot = callPackage ../development/python-modules/bqplot { };

  bqscales = callPackage ../development/python-modules/bqscales { };

  braceexpand = callPackage ../development/python-modules/braceexpand { };

  bracex = callPackage ../development/python-modules/bracex { };

  brainflow = callPackage ../development/python-modules/brainflow { inherit (pkgs) brainflow; };

  braintree = callPackage ../development/python-modules/braintree { };

  branca = callPackage ../development/python-modules/branca { };

  bravado-core = callPackage ../development/python-modules/bravado-core { };

  bravia-tv = callPackage ../development/python-modules/bravia-tv { };

  brax = callPackage ../development/python-modules/brax { };

  breathe = callPackage ../development/python-modules/breathe { };

  breezy = callPackage ../development/python-modules/breezy { };

  brelpy = callPackage ../development/python-modules/brelpy { };

  brevo-python = callPackage ../development/python-modules/brevo-python { };

  brian2 = callPackage ../development/python-modules/brian2 { };

  bring-api = callPackage ../development/python-modules/bring-api { };

  broadbean = callPackage ../development/python-modules/broadbean { };

  broadlink = callPackage ../development/python-modules/broadlink { };

  brother = callPackage ../development/python-modules/brother { };

  brother-ql = callPackage ../development/python-modules/brother-ql { };

  brotli = callPackage ../development/python-modules/brotli {
    inherit (pkgs) brotli;
  };

  brotli-asgi = callPackage ../development/python-modules/brotli-asgi { };

  brotlicffi = callPackage ../development/python-modules/brotlicffi { inherit (pkgs) brotli; };

  brotlipy = callPackage ../development/python-modules/brotlipy { };

  brottsplatskartan = callPackage ../development/python-modules/brottsplatskartan { };

  browser-cookie3 = callPackage ../development/python-modules/browser-cookie3 { };

  browserforge = callPackage ../development/python-modules/browserforge { };

  brunt = callPackage ../development/python-modules/brunt { };

  bsddb3 = callPackage ../development/python-modules/bsddb3 { };

  bsdiff4 = callPackage ../development/python-modules/bsdiff4 { };

  bson = callPackage ../development/python-modules/bson { };

  bsuite = callPackage ../development/python-modules/bsuite { };

  bt-proximity = callPackage ../development/python-modules/bt-proximity { };

  btchip-python = callPackage ../development/python-modules/btchip-python { };

  btest = callPackage ../development/python-modules/btest { };

  bthome-ble = callPackage ../development/python-modules/bthome-ble { };

  bthomehub5-devicelist = callPackage ../development/python-modules/bthomehub5-devicelist { };

  btlewrap = callPackage ../development/python-modules/btlewrap { };

  btrees = callPackage ../development/python-modules/btrees { };

  btrfs = callPackage ../development/python-modules/btrfs { };

  btrfsutil = callPackage ../development/python-modules/btrfsutil { };

  btsmarthub-devicelist = callPackage ../development/python-modules/btsmarthub-devicelist { };

  btsocket = callPackage ../development/python-modules/btsocket { };

  bubop = callPackage ../development/python-modules/bubop { };

  bucketstore = callPackage ../development/python-modules/bucketstore { };

  bugsnag = callPackage ../development/python-modules/bugsnag { };

  bugwarrior = callPackage ../development/python-modules/bugwarrior { };

  buienradar = callPackage ../development/python-modules/buienradar { };

  build = callPackage ../development/python-modules/build { };

  buildcatrust = callPackage ../development/python-modules/buildcatrust { };

  buildstream-plugins = callPackage ../development/python-modules/buildstream-plugins { };

  bump-my-version = callPackage ../development/python-modules/bump-my-version { };

  bump2version = callPackage ../development/python-modules/bump2version { };

  bumpfontversion = callPackage ../development/python-modules/bumpfontversion { };

  bumps = callPackage ../development/python-modules/bumps { };

  bundlewrap = callPackage ../development/python-modules/bundlewrap { };

  bundlewrap-keepass = callPackage ../development/python-modules/bundlewrap-keepass { };

  bundlewrap-pass = callPackage ../development/python-modules/bundlewrap-pass { };

  bundlewrap-teamvault = callPackage ../development/python-modules/bundlewrap-teamvault { };

  busylight-core = callPackage ../development/python-modules/busylight-core { };

  busylight-for-humans = callPackage ../development/python-modules/busylight-for-humans { };

  busypie = callPackage ../development/python-modules/busypie { };

  bwapy = callPackage ../development/python-modules/bwapy { };

  bx-py-utils = callPackage ../development/python-modules/bx-py-utils { };

  bx-python = callPackage ../development/python-modules/bx-python { };

  bytecode = callPackage ../development/python-modules/bytecode { };

  bytesize = toPythonModule (pkgs.libbytesize.override { python3Packages = self; });

  bytewax = callPackage ../development/python-modules/bytewax { };

  cache = callPackage ../development/python-modules/cache { };

  cachecontrol = callPackage ../development/python-modules/cachecontrol { };

  cached-ipaddress = callPackage ../development/python-modules/cached-ipaddress { };

  cached-property = callPackage ../development/python-modules/cached-property { };

  cachelib = callPackage ../development/python-modules/cachelib { };

  cachetools = callPackage ../development/python-modules/cachetools { };

  cachey = callPackage ../development/python-modules/cachey { };

  cachier = callPackage ../development/python-modules/cachier { };

  cachy = callPackage ../development/python-modules/cachy { };

  caffe = toPythonModule (
    pkgs.caffe.override {
      pythonSupport = true;
      inherit (self) python numpy boost;
    }
  );

  caio = callPackage ../development/python-modules/caio { };

  cairocffi = callPackage ../development/python-modules/cairocffi { };

  cairosvg = callPackage ../development/python-modules/cairosvg { };

  caldav = callPackage ../development/python-modules/caldav { };

  callee = callPackage ../development/python-modules/callee { };

  calmjs = callPackage ../development/python-modules/calmjs { };

  calmjs-parse = callPackage ../development/python-modules/calmjs-parse { };

  calmjs-types = callPackage ../development/python-modules/calmjs-types { };

  calmsize = callPackage ../development/python-modules/calmsize { };

  calver = callPackage ../development/python-modules/calver { };

  calysto = callPackage ../development/python-modules/calysto { };

  calysto-scheme = callPackage ../development/python-modules/calysto-scheme { };

  camel-converter = callPackage ../development/python-modules/camel-converter { };

  camelot = callPackage ../development/python-modules/camelot { };

  can-isotp = callPackage ../development/python-modules/can-isotp { };

  canals = callPackage ../development/python-modules/canals { };

  canmatrix = callPackage ../development/python-modules/canmatrix { };

  canonical-sphinx-extensions =
    callPackage ../development/python-modules/canonical-sphinx-extensions
      { };

  canonicaljson = callPackage ../development/python-modules/canonicaljson { };

  canopen = callPackage ../development/python-modules/canopen { };

  cantools = callPackage ../development/python-modules/cantools { };

  capstone = callPackage ../development/python-modules/capstone { inherit (pkgs) capstone; };

  capstone_4 = callPackage ../development/python-modules/capstone/4.nix {
    inherit (pkgs) capstone_4;
  };

  captcha = callPackage ../development/python-modules/captcha { };

  captum = callPackage ../development/python-modules/captum { };

  capturer = callPackage ../development/python-modules/capturer { };

  carbon = callPackage ../development/python-modules/carbon { };

  cardano-tools = callPackage ../development/python-modules/cardano-tools { };

  cardimpose = callPackage ../development/python-modules/cardimpose { };

  cart = callPackage ../development/python-modules/cart { };

  cartopy = callPackage ../development/python-modules/cartopy { };

  casa-formats-io = callPackage ../development/python-modules/casa-formats-io { };

  casadi = toPythonModule (
    pkgs.casadi.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  case-converter = callPackage ../development/python-modules/case-converter { };

  cashaddress = callPackage ../development/python-modules/cashaddress { };

  cashews = callPackage ../development/python-modules/cashews { };

  cassandra-driver = callPackage ../development/python-modules/cassandra-driver { };

  castepxbin = callPackage ../development/python-modules/castepxbin { };

  casttube = callPackage ../development/python-modules/casttube { };

  catalogue = callPackage ../development/python-modules/catalogue { };

  catalyst = toPythonModule (
    pkgs.catalyst.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  catboost = callPackage ../development/python-modules/catboost {
    catboost = pkgs.catboost.override {
      pythonSupport = true;
      python3Packages = self;
    };
  };

  categorical-distance = callPackage ../development/python-modules/categorical-distance { };

  catkin-pkg = callPackage ../development/python-modules/catkin-pkg { };

  catppuccin = callPackage ../development/python-modules/catppuccin { };

  cattrs = callPackage ../development/python-modules/cattrs { };

  causal-conv1d = callPackage ../development/python-modules/causal-conv1d { };

  cbor = callPackage ../development/python-modules/cbor { };

  cbor2 = callPackage ../development/python-modules/cbor2 { };

  cbor2WithoutCExtensions = callPackage ../development/python-modules/cbor2 {
    withCExtensions = false;
  };

  cccolutils = callPackage ../development/python-modules/cccolutils { krb5-c = pkgs.krb5; };

  cdcs = callPackage ../development/python-modules/cdcs { };

  cddlparser = callPackage ../development/python-modules/cddlparser { };

  cdxj-indexer = callPackage ../development/python-modules/cdxj-indexer { };

  celery = callPackage ../development/python-modules/celery { };

  celery-batches = callPackage ../development/python-modules/celery-batches { };

  celery-redbeat = callPackage ../development/python-modules/celery-redbeat { };

  celery-singleton = callPackage ../development/python-modules/celery-singleton { };

  celery-types = callPackage ../development/python-modules/celery-types { };

  cement = callPackage ../development/python-modules/cement { };

  cemm = callPackage ../development/python-modules/cemm { };

  censys = callPackage ../development/python-modules/censys { };

  cerberus = callPackage ../development/python-modules/cerberus { };

  cert-chain-resolver = callPackage ../development/python-modules/cert-chain-resolver { };

  certauth = callPackage ../development/python-modules/certauth { };

  certbot = callPackage ../development/python-modules/certbot { };

  certbot-dns-cloudflare = callPackage ../development/python-modules/certbot-dns-cloudflare { };

  certbot-dns-google = callPackage ../development/python-modules/certbot-dns-google { };

  certbot-dns-inwx = callPackage ../development/python-modules/certbot-dns-inwx { };

  certbot-dns-ovh = callPackage ../development/python-modules/certbot-dns-ovh { };

  certbot-dns-rfc2136 = callPackage ../development/python-modules/certbot-dns-rfc2136 { };

  certbot-dns-route53 = callPackage ../development/python-modules/certbot-dns-route53 { };

  certbot-nginx = callPackage ../development/python-modules/certbot-nginx { };

  certifi = callPackage ../development/python-modules/certifi { };

  certipy = callPackage ../development/python-modules/certipy { };

  certipy-ad = callPackage ../development/python-modules/certipy-ad { };

  certomancer = callPackage ../development/python-modules/certomancer { };

  certvalidator = callPackage ../development/python-modules/certvalidator { };

  cexprtk = callPackage ../development/python-modules/cexprtk { };

  cf-xarray = callPackage ../development/python-modules/cf-xarray { };

  cffconvert = callPackage ../development/python-modules/cffconvert { };

  cffi = if isPyPy then null else callPackage ../development/python-modules/cffi { };

  cffsubr = callPackage ../development/python-modules/cffsubr { };

  cfgv = callPackage ../development/python-modules/cfgv { };

  cflib = callPackage ../development/python-modules/cflib { };

  cfn-flip = callPackage ../development/python-modules/cfn-flip { };

  cfn-lint = callPackage ../development/python-modules/cfn-lint { };

  cfscrape = callPackage ../development/python-modules/cfscrape { };

  cftime = callPackage ../development/python-modules/cftime { };

  cgal = callPackage ../development/python-modules/cgal { inherit (pkgs) cgal; };

  cgen = callPackage ../development/python-modules/cgen { };

  cgroup-utils = callPackage ../development/python-modules/cgroup-utils { };

  chacha20poly1305 = callPackage ../development/python-modules/chacha20poly1305 { };

  chacha20poly1305-reuseable =
    callPackage ../development/python-modules/chacha20poly1305-reuseable
      { };

  chai = callPackage ../development/python-modules/chai { };

  chainmap = callPackage ../development/python-modules/chainmap { };

  chainstream = callPackage ../development/python-modules/chainstream { };

  chalice = callPackage ../development/python-modules/chalice { };

  chameleon = callPackage ../development/python-modules/chameleon { };

  changefinder = callPackage ../development/python-modules/changefinder { };

  changelog-chug = callPackage ../development/python-modules/changelog-chug { };

  channels = callPackage ../development/python-modules/channels { };

  channels-redis = callPackage ../development/python-modules/channels-redis { };

  character-encoding-utils = callPackage ../development/python-modules/character-encoding-utils { };

  characteristic = callPackage ../development/python-modules/characteristic { };

  chardet = callPackage ../development/python-modules/chardet { };

  charset-normalizer = callPackage ../development/python-modules/charset-normalizer { };

  chart-studio = callPackage ../development/python-modules/chart-studio { };

  chat-downloader = callPackage ../development/python-modules/chat-downloader { };

  chatlas = callPackage ../development/python-modules/chatlas { };

  check-manifest = callPackage ../development/python-modules/check-manifest { };

  checkdmarc = callPackage ../development/python-modules/checkdmarc { };

  checkpoint-schedules = callPackage ../development/python-modules/checkpoint-schedules { };

  checksumdir = callPackage ../development/python-modules/checksumdir { };

  cheetah3 = callPackage ../development/python-modules/cheetah3 { };

  cheroot = callPackage ../development/python-modules/cheroot { };

  cherrypy = callPackage ../development/python-modules/cherrypy { };

  cherrypy-cors = callPackage ../development/python-modules/cherrypy-cors { };

  chess = callPackage ../development/python-modules/chess { };

  chevron = callPackage ../development/python-modules/chevron { };

  chex = callPackage ../development/python-modules/chex { };

  chipwhisperer = callPackage ../development/python-modules/chipwhisperer { };

  chirpstack-api = callPackage ../development/python-modules/chirpstack-api { };

  chispa = callPackage ../development/python-modules/chispa { };

  chroma-hnswlib = callPackage ../development/python-modules/chroma-hnswlib { };

  chromadb = callPackage ../development/python-modules/chromadb { zstd-c = pkgs.zstd; };

  chromaprint = callPackage ../development/python-modules/chromaprint { };

  ci-info = callPackage ../development/python-modules/ci-info { };

  ci-py = callPackage ../development/python-modules/ci-py { };

  cinemagoer = callPackage ../development/python-modules/cinemagoer { };

  circuit-webhook = callPackage ../development/python-modules/circuit-webhook { };

  circuitbreaker = callPackage ../development/python-modules/circuitbreaker { };

  circus = callPackage ../development/python-modules/circus { };

  cirq = callPackage ../development/python-modules/cirq { };

  cirq-aqt = callPackage ../development/python-modules/cirq-aqt { };

  cirq-core = callPackage ../development/python-modules/cirq-core { };

  cirq-google = callPackage ../development/python-modules/cirq-google { };

  cirq-ionq = callPackage ../development/python-modules/cirq-ionq { };

  cirq-pasqal = callPackage ../development/python-modules/cirq-pasqal { };

  cirq-web = callPackage ../development/python-modules/cirq-web { };

  ciscoconfparse2 = callPackage ../development/python-modules/ciscoconfparse2 { };

  ciscomobilityexpress = callPackage ../development/python-modules/ciscomobilityexpress { };

  ciso8601 = callPackage ../development/python-modules/ciso8601 { };

  citeproc-py = callPackage ../development/python-modules/citeproc-py { };

  cjkwrap = callPackage ../development/python-modules/cjkwrap { };

  ckcc-protocol = callPackage ../development/python-modules/ckcc-protocol { };

  ckzg = callPackage ../development/python-modules/ckzg { };

  clarabel = callPackage ../development/python-modules/clarabel { };

  clarifai = callPackage ../development/python-modules/clarifai { };

  clarifai-grpc = callPackage ../development/python-modules/clarifai-grpc { };

  clarifai-protocol = callPackage ../development/python-modules/clarifai-protocol { };

  claripy = callPackage ../development/python-modules/claripy { };

  class-doc = callPackage ../development/python-modules/class-doc { };

  classify-imports = callPackage ../development/python-modules/classify-imports { };

  cle = callPackage ../development/python-modules/cle { };

  clean-fid = callPackage ../development/python-modules/clean-fid { };

  cleanit = callPackage ../development/python-modules/cleanit { };

  cleanlab = callPackage ../development/python-modules/cleanlab { };

  cleanvision = callPackage ../development/python-modules/cleanvision { };

  clearpasspy = callPackage ../development/python-modules/clearpasspy { };

  cleo = callPackage ../development/python-modules/cleo { };

  clevercsv = callPackage ../development/python-modules/clevercsv { };

  clf = callPackage ../development/python-modules/clf { };

  cli-helpers = callPackage ../development/python-modules/cli-helpers { };

  cli-ui = callPackage ../development/python-modules/cli-ui { };

  cliche = callPackage ../development/python-modules/cliche { };

  click = callPackage ../development/python-modules/click { };

  click-aliases = callPackage ../development/python-modules/click-aliases { };

  click-command-tree = callPackage ../development/python-modules/click-command-tree { };

  click-completion = callPackage ../development/python-modules/click-completion { };

  click-configfile = callPackage ../development/python-modules/click-configfile { };

  click-datetime = callPackage ../development/python-modules/click-datetime { };

  click-default-group = callPackage ../development/python-modules/click-default-group { };

  click-didyoumean = callPackage ../development/python-modules/click-didyoumean { };

  click-help-colors = callPackage ../development/python-modules/click-help-colors { };

  click-log = callPackage ../development/python-modules/click-log { };

  click-odoo = callPackage ../development/python-modules/click-odoo { };

  click-odoo-contrib = callPackage ../development/python-modules/click-odoo-contrib { };

  click-option-group = callPackage ../development/python-modules/click-option-group { };

  click-plugins = callPackage ../development/python-modules/click-plugins { };

  click-repl = callPackage ../development/python-modules/click-repl { };

  click-shell = callPackage ../development/python-modules/click-shell { };

  click-spinner = callPackage ../development/python-modules/click-spinner { };

  click-threading = callPackage ../development/python-modules/click-threading { };

  clickclick = callPackage ../development/python-modules/clickclick { };

  clickgen = callPackage ../development/python-modules/clickgen { };

  clickhouse-cityhash = callPackage ../development/python-modules/clickhouse-cityhash { };

  clickhouse-cli = callPackage ../development/python-modules/clickhouse-cli { };

  clickhouse-connect = callPackage ../development/python-modules/clickhouse-connect { };

  clickhouse-driver = callPackage ../development/python-modules/clickhouse-driver { };

  cliff = callPackage ../development/python-modules/cliff { };

  clifford = callPackage ../development/python-modules/clifford { };

  cligj = callPackage ../development/python-modules/cligj { };

  clikit = callPackage ../development/python-modules/clikit { };

  clingo = toPythonModule (
    pkgs.clingo.override {
      inherit python;
      withPython = true;
    }
  );

  clint = callPackage ../development/python-modules/clint { };

  clintermission = callPackage ../development/python-modules/clintermission { };

  clip = callPackage ../development/python-modules/clip { };

  clip-anytorch = callPackage ../development/python-modules/clip-anytorch { };

  clize = callPackage ../development/python-modules/clize { };

  clldutils = callPackage ../development/python-modules/clldutils { };

  cloudcheck = callPackage ../development/python-modules/cloudcheck { };

  cloudevents = callPackage ../development/python-modules/cloudevents { };

  cloudflare = callPackage ../development/python-modules/cloudflare { };

  cloudpathlib = callPackage ../development/python-modules/cloudpathlib { };

  cloudpickle = callPackage ../development/python-modules/cloudpickle { };

  cloudscraper = callPackage ../development/python-modules/cloudscraper { };

  cloudsmith-api = callPackage ../development/python-modules/cloudsmith-api { };

  cloudsplaining = callPackage ../development/python-modules/cloudsplaining { };

  cloup = callPackage ../development/python-modules/cloup { };

  clr-loader = callPackage ../development/python-modules/clr-loader { };

  cltk = callPackage ../development/python-modules/cltk { };

  clustershell = callPackage ../development/python-modules/clustershell { };

  clx-sdk-xms = callPackage ../development/python-modules/clx-sdk-xms { };

  cma = callPackage ../development/python-modules/cma { };

  cmaes = callPackage ../development/python-modules/cmaes { };

  cmake = callPackage ../development/python-modules/cmake { inherit (pkgs) cmake; };

  cmake-build-extension = callPackage ../development/python-modules/cmake-build-extension { };

  cmarkgfm = callPackage ../development/python-modules/cmarkgfm { };

  cmd2 = callPackage ../development/python-modules/cmd2 { };

  cmd2-ext-test = callPackage ../development/python-modules/cmd2-ext-test { };

  cmdline = callPackage ../development/python-modules/cmdline { };

  cmdstanpy = callPackage ../development/python-modules/cmdstanpy { };

  cmigemo = callPackage ../development/python-modules/cmigemo { inherit (pkgs) cmigemo; };

  cmsdials = callPackage ../development/python-modules/cmsdials { };

  cmsis-pack-manager = callPackage ../development/python-modules/cmsis-pack-manager { };

  cmsis-svd = callPackage ../development/python-modules/cmsis-svd { };

  cmudict = callPackage ../development/python-modules/cmudict { };

  cnvkit = callPackage ../development/python-modules/cnvkit { };

  co2signal = callPackage ../development/python-modules/co2signal { };

  coal = callPackage ../development/python-modules/coal { inherit (pkgs) coal; };

  coapthon3 = callPackage ../development/python-modules/coapthon3 { };

  cobble = callPackage ../development/python-modules/cobble { };

  cobs = callPackage ../development/python-modules/cobs { };

  cock = callPackage ../development/python-modules/cock { };

  coconut = callPackage ../development/python-modules/coconut { };

  cocotb = callPackage ../development/python-modules/cocotb { };

  cocotb-bus = callPackage ../development/python-modules/cocotb-bus { };

  codepy = callPackage ../development/python-modules/codepy { };

  coffea = callPackage ../development/python-modules/coffea { };

  cogapp = callPackage ../development/python-modules/cogapp { };

  cohere = callPackage ../development/python-modules/cohere { };

  coiled = callPackage ../development/python-modules/coiled { };

  coinbase-advanced-py = callPackage ../development/python-modules/coinbase-advanced-py { };

  coincurve = callPackage ../development/python-modules/coincurve { inherit (pkgs) secp256k1; };

  coinmetrics-api-client = callPackage ../development/python-modules/coinmetrics-api-client { };

  colander = callPackage ../development/python-modules/colander { };

  colanderalchemy = callPackage ../development/python-modules/colanderalchemy { };

  colbert-ai = callPackage ../development/python-modules/colbert-ai { };

  colcon = callPackage ../development/python-modules/colcon { };

  colcon-argcomplete = callPackage ../development/python-modules/colcon-argcomplete { };

  colcon-bash = callPackage ../development/python-modules/colcon-bash { };

  colcon-cargo = callPackage ../development/python-modules/colcon-cargo { };

  colcon-cd = callPackage ../development/python-modules/colcon-cd { };

  colcon-coveragepy-result = callPackage ../development/python-modules/colcon-coveragepy-result { };

  colcon-defaults = callPackage ../development/python-modules/colcon-defaults { };

  colcon-devtools = callPackage ../development/python-modules/colcon-devtools { };

  colcon-installed-package-information =
    callPackage ../development/python-modules/colcon-installed-package-information
      { };

  colcon-library-path = callPackage ../development/python-modules/colcon-library-path { };

  colcon-metadata = callPackage ../development/python-modules/colcon-metadata { };

  colcon-mixin = callPackage ../development/python-modules/colcon-mixin { };

  colcon-notification = callPackage ../development/python-modules/colcon-notification { };

  colcon-output = callPackage ../development/python-modules/colcon-output { };

  colcon-package-information =
    callPackage ../development/python-modules/colcon-package-information
      { };

  colcon-package-selection = callPackage ../development/python-modules/colcon-package-selection { };

  colcon-parallel-executor = callPackage ../development/python-modules/colcon-parallel-executor { };

  colcon-python-setup-py = callPackage ../development/python-modules/colcon-python-setup-py { };

  colcon-recursive-crawl = callPackage ../development/python-modules/colcon-recursive-crawl { };

  colcon-ros-domain-id-coordinator =
    callPackage ../development/python-modules/colcon-ros-domain-id-coordinator
      { };

  colcon-test-result = callPackage ../development/python-modules/colcon-test-result { };

  colcon-zsh = callPackage ../development/python-modules/colcon-zsh { };

  collections-extended = callPackage ../development/python-modules/collections-extended { };

  collidoscope = callPackage ../development/python-modules/collidoscope { };

  color-matcher = callPackage ../development/python-modules/color-matcher { };

  color-operations = callPackage ../development/python-modules/color-operations { };

  color-parser-py = callPackage ../development/python-modules/color-parser-py { };

  coloraide = callPackage ../development/python-modules/coloraide { };

  colorama = callPackage ../development/python-modules/colorama { };

  colorcet = callPackage ../development/python-modules/colorcet { };

  colorclass = callPackage ../development/python-modules/colorclass { };

  colored = callPackage ../development/python-modules/colored { };

  colored-traceback = callPackage ../development/python-modules/colored-traceback { };

  coloredlogs = callPackage ../development/python-modules/coloredlogs { };

  colorful = callPackage ../development/python-modules/colorful { };

  colorlog = callPackage ../development/python-modules/colorlog { };

  colorlover = callPackage ../development/python-modules/colorlover { };

  colormath = callPackage ../development/python-modules/colormath { };

  colormath2 = callPackage ../development/python-modules/colormath2 { };

  colorspacious = callPackage ../development/python-modules/colorspacious { };

  colorthief = callPackage ../development/python-modules/colorthief { };

  colorzero = callPackage ../development/python-modules/colorzero { };

  colour = callPackage ../development/python-modules/colour { };

  colout = callPackage ../development/python-modules/colout { };

  columnize = callPackage ../development/python-modules/columnize { };

  comet-ml = callPackage ../development/python-modules/comet-ml { };

  cometblue-lite = callPackage ../development/python-modules/cometblue-lite { };

  cometx = callPackage ../development/python-modules/cometx { };

  comicapi = callPackage ../development/python-modules/comicapi { };

  comicon = callPackage ../development/python-modules/comicon { };

  comm = callPackage ../development/python-modules/comm { };

  command-runner = callPackage ../development/python-modules/command-runner { };

  commandlines = callPackage ../development/python-modules/commandlines { };

  commandparse = callPackage ../development/python-modules/commandparse { };

  commentjson = callPackage ../development/python-modules/commentjson { };

  commoncode = callPackage ../development/python-modules/commoncode { };

  commonmark = callPackage ../development/python-modules/commonmark { };

  commonregex = callPackage ../development/python-modules/commonregex { };

  compit-inext-api = callPackage ../development/python-modules/compit-inext-api { };

  compliance-trestle = callPackage ../development/python-modules/compliance-trestle { };

  complycube = callPackage ../development/python-modules/complycube { };

  compreffor = callPackage ../development/python-modules/compreffor { };

  compressai = callPackage ../development/python-modules/compressai { };

  compressed-rtf = callPackage ../development/python-modules/compressed-rtf { };

  compressed-tensors = callPackage ../development/python-modules/compressed-tensors { };

  concord232 = callPackage ../development/python-modules/concord232 { };

  concurrent-log-handler = callPackage ../development/python-modules/concurrent-log-handler { };

  conda = callPackage ../development/python-modules/conda { };

  conda-inject = callPackage ../development/python-modules/conda-inject { };

  conda-libmamba-solver = callPackage ../development/python-modules/conda-libmamba-solver { };

  conda-package-handling = callPackage ../development/python-modules/conda-package-handling { };

  conda-package-streaming = callPackage ../development/python-modules/conda-package-streaming { };

  condense-json = callPackage ../development/python-modules/condense-json { };

  conduit = callPackage ../development/python-modules/conduit { };

  conduit-mpi = callPackage ../development/python-modules/conduit { mpiSupport = true; };

  confection = callPackage ../development/python-modules/confection { };

  configargparse = callPackage ../development/python-modules/configargparse { };

  configclass = callPackage ../development/python-modules/configclass { };

  confight = callPackage ../development/python-modules/confight { };

  configobj = callPackage ../development/python-modules/configobj { };

  configparser = callPackage ../development/python-modules/configparser { };

  configshell-fb = callPackage ../development/python-modules/configshell-fb { };

  configupdater = callPackage ../development/python-modules/configupdater { };

  confluent-kafka = callPackage ../development/python-modules/confluent-kafka { };

  confusable-homoglyphs = callPackage ../development/python-modules/confusable-homoglyphs { };

  confuse = callPackage ../development/python-modules/confuse { };

  conjure-python-client = callPackage ../development/python-modules/conjure-python-client { };

  connect-box = callPackage ../development/python-modules/connect-box { };

  connected-components-3d = callPackage ../development/python-modules/connected-components-3d { };

  connection-pool = callPackage ../development/python-modules/connection-pool { };

  connexion = callPackage ../development/python-modules/connexion { };

  connio = callPackage ../development/python-modules/connio { };

  cons = callPackage ../development/python-modules/cons { };

  consolekit = callPackage ../development/python-modules/consolekit { };

  consonance = callPackage ../development/python-modules/consonance { };

  constantdict = callPackage ../development/python-modules/constantdict { };

  constantly = callPackage ../development/python-modules/constantly { };

  construct = callPackage ../development/python-modules/construct { };

  construct-classes = callPackage ../development/python-modules/construct-classes { };

  construct-typing = callPackage ../development/python-modules/construct-typing { };

  consul = callPackage ../development/python-modules/consul { };

  container-inspector = callPackage ../development/python-modules/container-inspector { };

  contexter = callPackage ../development/python-modules/contexter { };

  contextlib2 = callPackage ../development/python-modules/contextlib2 { };

  contexttimer = callPackage ../development/python-modules/contexttimer { };

  contourpy = callPackage ../development/python-modules/contourpy { };

  controku = callPackage ../development/python-modules/controku { };

  control = callPackage ../development/python-modules/control { };

  convertdate = callPackage ../development/python-modules/convertdate { };

  convertertools = callPackage ../development/python-modules/convertertools { };

  conway-polynomials = callPackage ../development/python-modules/conway-polynomials { };

  cookidoo-api = callPackage ../development/python-modules/cookidoo-api { };

  cookiecutter = callPackage ../development/python-modules/cookiecutter { };

  cookies = callPackage ../development/python-modules/cookies { };

  coolname = callPackage ../development/python-modules/coolname { };

  coordinates = callPackage ../development/python-modules/coordinates { };

  copier = callPackage ../development/python-modules/copier { };

  copier-template-tester = callPackage ../development/python-modules/copier-template-tester { };

  copykitten = callPackage ../development/python-modules/copykitten { };

  coq-tools = callPackage ../development/python-modules/coq-tools { };

  coqpit = callPackage ../development/python-modules/coqpit { };

  corallium = callPackage ../development/python-modules/corallium { };

  coreapi = callPackage ../development/python-modules/coreapi { };

  coredis = callPackage ../development/python-modules/coredis { };

  coreschema = callPackage ../development/python-modules/coreschema { };

  corner = callPackage ../development/python-modules/corner { };

  cornice = callPackage ../development/python-modules/cornice { };

  correctionlib = callPackage ../development/python-modules/correctionlib { };

  corsair-scan = callPackage ../development/python-modules/corsair-scan { };

  cose = callPackage ../development/python-modules/cose { };

  cot = callPackage ../development/python-modules/cot { inherit (pkgs) qemu; };

  countryguess = callPackage ../development/python-modules/countryguess { };

  courlan = callPackage ../development/python-modules/courlan { };

  coverage = callPackage ../development/python-modules/coverage { };

  coveralls = callPackage ../development/python-modules/coveralls { };

  cpe = callPackage ../development/python-modules/cpe { };

  cppe = callPackage ../development/python-modules/cppe { inherit (pkgs) cppe; };

  cppheaderparser = callPackage ../development/python-modules/cppheaderparser { };

  cppy = callPackage ../development/python-modules/cppy { };

  cpufeature = callPackage ../development/python-modules/cpufeature { };

  cpyparsing = callPackage ../development/python-modules/cpyparsing { };

  cram = callPackage ../development/python-modules/cram { };

  cramjam = callPackage ../development/python-modules/cramjam { };

  crashtest = callPackage ../development/python-modules/crashtest { };

  crate = callPackage ../development/python-modules/crate { };

  crayons = callPackage ../development/python-modules/crayons { };

  crc = callPackage ../development/python-modules/crc { };

  crc16 = callPackage ../development/python-modules/crc16 { };

  crc32c = callPackage ../development/python-modules/crc32c { };

  crccheck = callPackage ../development/python-modules/crccheck { };

  crcelk = callPackage ../development/python-modules/crcelk { };

  crcmod = callPackage ../development/python-modules/crcmod { };

  credstash = callPackage ../development/python-modules/credstash { };

  crewai = callPackage ../development/python-modules/crewai { };

  crispy-bootstrap3 = callPackage ../development/python-modules/crispy-bootstrap3 { };

  crispy-bootstrap4 = callPackage ../development/python-modules/crispy-bootstrap4 { };

  crispy-bootstrap5 = callPackage ../development/python-modules/crispy-bootstrap5 { };

  crochet = callPackage ../development/python-modules/crochet { };

  crocoddyl = callPackage ../development/python-modules/crocoddyl { inherit (pkgs) crocoddyl; };

  cron-converter = callPackage ../development/python-modules/cron-converter { };

  cron-descriptor = callPackage ../development/python-modules/cron-descriptor { };

  croniter = callPackage ../development/python-modules/croniter { };

  cronsim = callPackage ../development/python-modules/cronsim { };

  crontab = callPackage ../development/python-modules/crontab { };

  crossandra = callPackage ../development/python-modules/crossandra { };

  crossplane = callPackage ../development/python-modules/crossplane { };

  crownstone-cloud = callPackage ../development/python-modules/crownstone-cloud { };

  crownstone-core = callPackage ../development/python-modules/crownstone-core { };

  crownstone-sse = callPackage ../development/python-modules/crownstone-sse { };

  crownstone-uart = callPackage ../development/python-modules/crownstone-uart { };

  crypt4gh = callPackage ../development/python-modules/crypt4gh { };

  cryptg = callPackage ../development/python-modules/cryptg { };

  cryptodatahub = callPackage ../development/python-modules/cryptodatahub { };

  cryptography = callPackage ../development/python-modules/cryptography { };

  cryptolyzer = callPackage ../development/python-modules/cryptolyzer { };

  cryptoparser = callPackage ../development/python-modules/cryptoparser { };

  crysp = callPackage ../development/python-modules/crysp { };

  crytic-compile = callPackage ../development/python-modules/crytic-compile { };

  csaf-tool = callPackage ../development/python-modules/csaf-tool { };

  csaps = callPackage ../development/python-modules/csaps { };

  cson = callPackage ../development/python-modules/cson { };

  csrmesh = callPackage ../development/python-modules/csrmesh { };

  css-html-js-minify = callPackage ../development/python-modules/css-html-js-minify { };

  css-inline = callPackage ../development/python-modules/css-inline { };

  css-parser = callPackage ../development/python-modules/css-parser { };

  cssbeautifier = callPackage ../development/python-modules/cssbeautifier { };

  csscompressor = callPackage ../development/python-modules/csscompressor { };

  cssmin = callPackage ../development/python-modules/cssmin { };

  cssselect = callPackage ../development/python-modules/cssselect { };

  cssselect2 = callPackage ../development/python-modules/cssselect2 { };

  cssutils = callPackage ../development/python-modules/cssutils { };

  cstruct = callPackage ../development/python-modules/cstruct { };

  csv2md = callPackage ../development/python-modules/csv2md { };

  csvw = callPackage ../development/python-modules/csvw { };

  ctap-keyring-device = callPackage ../development/python-modules/ctap-keyring-device { };

  ctranslate2 = callPackage ../development/python-modules/ctranslate2 {
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  ctypesgen = callPackage ../development/python-modules/ctypesgen { };

  cu2qu = callPackage ../development/python-modules/cu2qu { };

  cucumber-expressions = callPackage ../development/python-modules/cucumber-expressions { };

  cucumber-tag-expressions = callPackage ../development/python-modules/cucumber-tag-expressions { };

  cupy = callPackage ../development/python-modules/cupy {
    cudaPackages =
      # CuDNN 9 is not supported:
      # https://github.com/cupy/cupy/issues/8215
      # NOTE: cupy 14 will drop support for cuDNN entirely.
      # https://github.com/cupy/cupy/pull/9326
      let
        version = if pkgs.cudaPackages.backendStdenv.hasJetsonCudaCapability then "8.9.5" else "8.9.7";
      in
      pkgs.cudaPackages.override (prevArgs: {
        manifests = prevArgs.manifests // {
          cudnn = pkgs._cuda.manifests.cudnn.${version};
        };
      });
  };

  curated-tokenizers = callPackage ../development/python-modules/curated-tokenizers { };

  curated-transformers = callPackage ../development/python-modules/curated-transformers { };

  curio = callPackage ../development/python-modules/curio { };

  curio-compat = callPackage ../development/python-modules/curio-compat { };

  curl-cffi = callPackage ../development/python-modules/curl-cffi { };

  curlify = callPackage ../development/python-modules/curlify { };

  curtsies = callPackage ../development/python-modules/curtsies { };

  curvefitgui = callPackage ../development/python-modules/curvefitgui { };

  custom-json-diff = callPackage ../development/python-modules/custom-json-diff { };

  customtkinter = callPackage ../development/python-modules/customtkinter { };

  cut-cross-entropy = callPackage ../development/python-modules/cut-cross-entropy { };

  cv2-enumerate-cameras = callPackage ../development/python-modules/cv2-enumerate-cameras { };

  cvelib = callPackage ../development/python-modules/cvelib { };

  cvss = callPackage ../development/python-modules/cvss { };

  cvxopt = callPackage ../development/python-modules/cvxopt { };

  cvxpy = callPackage ../development/python-modules/cvxpy { };

  cwcwidth = callPackage ../development/python-modules/cwcwidth { };

  cwl-upgrader = callPackage ../development/python-modules/cwl-upgrader { };

  cwl-utils = callPackage ../development/python-modules/cwl-utils { };

  cwlformat = callPackage ../development/python-modules/cwlformat { };

  cx-freeze = callPackage ../development/python-modules/cx-freeze { };

  cx-oracle = callPackage ../development/python-modules/cx-oracle { };

  cxxfilt = callPackage ../development/python-modules/cxxfilt { };

  cxxheaderparser = callPackage ../development/python-modules/cxxheaderparser { };

  cybox = callPackage ../development/python-modules/cybox { };

  cycler = callPackage ../development/python-modules/cycler { };

  cyclonedds-python = callPackage ../development/python-modules/cyclonedds-python { };

  cyclonedx-python-lib = callPackage ../development/python-modules/cyclonedx-python-lib { };

  cyclopts = callPackage ../development/python-modules/cyclopts { };

  cyipopt = callPackage ../development/python-modules/cyipopt { };

  cymem = callPackage ../development/python-modules/cymem { };

  cymruwhois = callPackage ../development/python-modules/cymruwhois { };

  cynthion = callPackage ../development/python-modules/cynthion { };

  cypari = callPackage ../development/python-modules/cypari {

    inherit (pkgs.pkgsStatic) gmp;

    pari = pkgs.pari.overrideAttrs rec {
      version = "2.15.4";
      src = pkgs.fetchurl {
        url = "https://pari.math.u-bordeaux.fr/pub/pari/OLD/${lib.versions.majorMinor version}/pari-${version}.tar.gz";
        hash = "sha256-w1Rb/uDG37QLd/tLurr5mdguYAabn20ovLbPAEyMXA8=";
      };
      installTargets = [
        "install"
        "install-lib-sta"
      ];
    };

  };

  cypari2 = callPackage ../development/python-modules/cypari2 { };

  cypherpunkpay = callPackage ../development/python-modules/cypherpunkpay { };

  cyrtranslit = callPackage ../development/python-modules/cyrtranslit { };

  cysignals = callPackage ../development/python-modules/cysignals { };

  cython = callPackage ../development/python-modules/cython { };

  cython-test-exception-raiser =
    callPackage ../development/python-modules/cython-test-exception-raiser
      { };

  cython_0 = callPackage ../development/python-modules/cython/0.nix { };

  cytoolz = callPackage ../development/python-modules/cytoolz { };

  dacite = callPackage ../development/python-modules/dacite { };

  daemonize = callPackage ../development/python-modules/daemonize { };

  daemonocle = callPackage ../development/python-modules/daemonocle { };

  daff = callPackage ../development/python-modules/daff { };

  dahlia = callPackage ../development/python-modules/dahlia { };

  daiquiri = callPackage ../development/python-modules/daiquiri { };

  dalle-mini = callPackage ../development/python-modules/dalle-mini { };

  daltonlens = callPackage ../development/python-modules/daltonlens { };

  daphne = callPackage ../development/python-modules/daphne { };

  daqp = callPackage ../development/python-modules/daqp { };

  darkdetect = callPackage ../development/python-modules/darkdetect { };

  dartsim = toPythonModule (
    pkgs.dartsim.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  dasbus = callPackage ../development/python-modules/dasbus { };

  dash = callPackage ../development/python-modules/dash { };

  dash-bootstrap-components = callPackage ../development/python-modules/dash-bootstrap-components { };

  dash-bootstrap-templates = callPackage ../development/python-modules/dash-bootstrap-templates { };

  dash-core-components = callPackage ../development/python-modules/dash-core-components { };

  dash-html-components = callPackage ../development/python-modules/dash-html-components { };

  dash-table = callPackage ../development/python-modules/dash-table { };

  dashing = callPackage ../development/python-modules/dashing { };

  dashscope = callPackage ../development/python-modules/dashscope { };

  dask = callPackage ../development/python-modules/dask { };

  dask-awkward = callPackage ../development/python-modules/dask-awkward { };

  dask-gateway = callPackage ../development/python-modules/dask-gateway { };

  dask-gateway-server = callPackage ../development/python-modules/dask-gateway-server { };

  dask-glm = callPackage ../development/python-modules/dask-glm { };

  dask-histogram = callPackage ../development/python-modules/dask-histogram { };

  dask-image = callPackage ../development/python-modules/dask-image { };

  dask-jobqueue = callPackage ../development/python-modules/dask-jobqueue { };

  dask-ml = callPackage ../development/python-modules/dask-ml { };

  dask-mpi = callPackage ../development/python-modules/dask-mpi { };

  dask-yarn = callPackage ../development/python-modules/dask-yarn { };

  databackend = callPackage ../development/python-modules/databackend { };

  databases = callPackage ../development/python-modules/databases { };

  databricks-cli = callPackage ../development/python-modules/databricks-cli { };

  databricks-connect = callPackage ../development/python-modules/databricks-connect { };

  databricks-sdk = callPackage ../development/python-modules/databricks-sdk { };

  databricks-sql-connector = callPackage ../development/python-modules/databricks-sql-connector { };

  dataclass-csv = callPackage ../development/python-modules/dataclass-csv { };

  dataclass-factory = callPackage ../development/python-modules/dataclass-factory { };

  dataclass-wizard = callPackage ../development/python-modules/dataclass-wizard { };

  dataclasses-json = callPackage ../development/python-modules/dataclasses-json { };

  dataclasses-serialization = callPackage ../development/python-modules/dataclasses-serialization { };

  dataconf = callPackage ../development/python-modules/dataconf { };

  datadiff = callPackage ../development/python-modules/datadiff { };

  datadog = callPackage ../development/python-modules/datadog { };

  datafusion = callPackage ../development/python-modules/datafusion {
    protoc = pkgs.protobuf;
  };

  datalad = callPackage ../development/python-modules/datalad { };

  datalad-gooey = callPackage ../development/python-modules/datalad-gooey { };

  datalad-next = callPackage ../development/python-modules/datalad-next { };

  datamodel-code-generator = callPackage ../development/python-modules/datamodel-code-generator { };

  datamodeldict = callPackage ../development/python-modules/datamodeldict { };

  datapoint = callPackage ../development/python-modules/datapoint { };

  dataprep-ml = callPackage ../development/python-modules/dataprep-ml { };

  dataproperty = callPackage ../development/python-modules/dataproperty { };

  datasalad = callPackage ../development/python-modules/datasalad { };

  dataset = callPackage ../development/python-modules/dataset { };

  datasets = callPackage ../development/python-modules/datasets { };

  datasette = callPackage ../development/python-modules/datasette { };

  datasette-publish-fly = callPackage ../development/python-modules/datasette-publish-fly { };

  datasette-template-sql = callPackage ../development/python-modules/datasette-template-sql { };

  datashader = callPackage ../development/python-modules/datashader { };

  datashape = callPackage ../development/python-modules/datashape { };

  datashaper = callPackage ../development/python-modules/datashaper { };

  datatable = callPackage ../development/python-modules/datatable { };

  datauri = callPackage ../development/python-modules/datauri { };

  datefinder = callPackage ../development/python-modules/datefinder { };

  dateparser = callPackage ../development/python-modules/dateparser { };

  datetime = callPackage ../development/python-modules/datetime { };

  dateutils = callPackage ../development/python-modules/dateutils { };

  datrie = callPackage ../development/python-modules/datrie { };

  dawg-python = callPackage ../development/python-modules/dawg-python { };

  dawg2-python = callPackage ../development/python-modules/dawg2-python { };

  dazl = callPackage ../development/python-modules/dazl { };

  db-dtypes = callPackage ../development/python-modules/db-dtypes { };

  dbf = callPackage ../development/python-modules/dbf { };

  dbfread = callPackage ../development/python-modules/dbfread { };

  dbglib = callPackage ../development/python-modules/dbglib { };

  dbt-adapters = callPackage ../development/python-modules/dbt-adapters { };

  dbt-bigquery = callPackage ../development/python-modules/dbt-bigquery { };

  dbt-common = callPackage ../development/python-modules/dbt-common { };

  dbt-core = callPackage ../development/python-modules/dbt-core { };

  dbt-extractor = callPackage ../development/python-modules/dbt-extractor { };

  dbt-postgres = callPackage ../development/python-modules/dbt-postgres { };

  dbt-protos = callPackage ../development/python-modules/dbt-protos { };

  dbt-redshift = callPackage ../development/python-modules/dbt-redshift { };

  dbt-semantic-interfaces = callPackage ../development/python-modules/dbt-semantic-interfaces { };

  dbt-snowflake = callPackage ../development/python-modules/dbt-snowflake { };

  dbus-client-gen = callPackage ../development/python-modules/dbus-client-gen { };

  dbus-deviation = callPackage ../development/python-modules/dbus-deviation { };

  dbus-fast = callPackage ../development/python-modules/dbus-fast { };

  dbus-next = callPackage ../development/python-modules/dbus-next { };

  dbus-python = callPackage ../development/python-modules/dbus-python { inherit (pkgs) dbus; };

  dbus-python-client-gen = callPackage ../development/python-modules/dbus-python-client-gen { };

  dbus-signature-pyparsing = callPackage ../development/python-modules/dbus-signature-pyparsing { };

  dbutils = callPackage ../development/python-modules/dbutils { };

  dcmstack = callPackage ../development/python-modules/dcmstack { };

  dctorch = callPackage ../development/python-modules/dctorch { };

  ddgs = callPackage ../development/python-modules/ddgs { };

  ddt = callPackage ../development/python-modules/ddt { };

  deal = callPackage ../development/python-modules/deal { };

  deal-solver = callPackage ../development/python-modules/deal-solver { };

  deap = callPackage ../development/python-modules/deap { };

  debian-inspector = callPackage ../development/python-modules/debian-inspector { };

  debianbts = callPackage ../development/python-modules/debianbts { };

  debtcollector = callPackage ../development/python-modules/debtcollector { };

  debts = callPackage ../development/python-modules/debts { };

  debuglater = callPackage ../development/python-modules/debuglater { };

  debugpy = callPackage ../development/python-modules/debugpy { };

  decli = callPackage ../development/python-modules/decli { };

  declinate = callPackage ../development/python-modules/declinate { };

  decopatch = callPackage ../development/python-modules/decopatch { };

  decora-wifi = callPackage ../development/python-modules/decora-wifi { };

  decorator = callPackage ../development/python-modules/decorator { };

  dedupe = callPackage ../development/python-modules/dedupe { };

  dedupe-levenshtein-search = callPackage ../development/python-modules/dedupe-levenshtein-search { };

  dedupe-pylbfgs = callPackage ../development/python-modules/dedupe-pylbfgs { };

  deebot-client = callPackage ../development/python-modules/deebot-client { };

  deemix = callPackage ../development/python-modules/deemix { };

  deep-chainmap = callPackage ../development/python-modules/deep-chainmap { };

  deep-translator = callPackage ../development/python-modules/deep-translator { };

  deepdiff = callPackage ../development/python-modules/deepdiff { };

  deepdish = callPackage ../development/python-modules/deepdish { };

  deepface = callPackage ../development/python-modules/deepface { };

  deepl = callPackage ../development/python-modules/deepl { };

  deepmerge = callPackage ../development/python-modules/deepmerge { };

  deepsearch-glm = callPackage ../development/python-modules/deepsearch-glm {
    inherit (pkgs) loguru sentencepiece fasttext;
  };

  deepsearch-toolkit = callPackage ../development/python-modules/deepsearch-toolkit { };

  deeptoolsintervals = callPackage ../development/python-modules/deeptoolsintervals { };

  deepwave = callPackage ../development/python-modules/deepwave { };

  deezer-py = callPackage ../development/python-modules/deezer-py { };

  deezer-python = callPackage ../development/python-modules/deezer-python { };

  deezer-python-async = callPackage ../development/python-modules/deezer-python-async { };

  defang = callPackage ../development/python-modules/defang { };

  defcon = callPackage ../development/python-modules/defcon { };

  deform = callPackage ../development/python-modules/deform { };

  defusedcsv = callPackage ../development/python-modules/defusedcsv { };

  defusedxml = callPackage ../development/python-modules/defusedxml { };

  dehinter = callPackage ../development/python-modules/dehinter { };

  deid = callPackage ../development/python-modules/deid { };

  dek = callPackage ../development/python-modules/dek { };

  delegator-py = callPackage ../development/python-modules/delegator-py { };

  delorean = callPackage ../development/python-modules/delorean { };

  deltachat = callPackage ../development/python-modules/deltachat { };

  deltachat-rpc-client = callPackage ../development/python-modules/deltachat-rpc-client { };

  deltachat2 = callPackage ../development/python-modules/deltachat2 { };

  deltalake = callPackage ../development/python-modules/deltalake { };

  deluge-client = callPackage ../development/python-modules/deluge-client { };

  demes = callPackage ../development/python-modules/demes { };

  demesdraw = callPackage ../development/python-modules/demesdraw { };

  demetriek = callPackage ../development/python-modules/demetriek { };

  demjson3 = callPackage ../development/python-modules/demjson3 { };

  demoji = callPackage ../development/python-modules/demoji { };

  dendropy = callPackage ../development/python-modules/dendropy { };

  denonavr = callPackage ../development/python-modules/denonavr { };

  dep-logic = callPackage ../development/python-modules/dep-logic { };

  dependency-groups = callPackage ../development/python-modules/dependency-groups { };

  dependency-injector = callPackage ../development/python-modules/dependency-injector { };

  deploykit = callPackage ../development/python-modules/deploykit { };

  deprecated = callPackage ../development/python-modules/deprecated { };

  deprecation = callPackage ../development/python-modules/deprecation { };

  deprecation-alias = callPackage ../development/python-modules/deprecation-alias { };

  depyf = callPackage ../development/python-modules/depyf { };

  derpconf = callPackage ../development/python-modules/derpconf { };

  desktop-entry-lib = callPackage ../development/python-modules/desktop-entry-lib { };

  desktop-notifier = callPackage ../development/python-modules/desktop-notifier { };

  detect-secrets = callPackage ../development/python-modules/detect-secrets { };

  detectron2 = callPackage ../development/python-modules/detectron2 { };

  developer-disk-image = callPackage ../development/python-modules/developer-disk-image { };

  devgoldyutils = callPackage ../development/python-modules/devgoldyutils { };

  devialet = callPackage ../development/python-modules/devialet { };

  devito = callPackage ../development/python-modules/devito { };

  devolo-home-control-api = callPackage ../development/python-modules/devolo-home-control-api { };

  devolo-plc-api = callPackage ../development/python-modules/devolo-plc-api { };

  devpi-common = callPackage ../development/python-modules/devpi-common { };

  devpi-ldap = callPackage ../development/python-modules/devpi-ldap { };

  devtools = callPackage ../development/python-modules/devtools { };

  dfdiskcache = callPackage ../development/python-modules/dfdiskcache { };

  dftd4 = callPackage ../by-name/df/dftd4/python.nix {
    inherit (pkgs) dftd4;
  };

  diagrams = callPackage ../development/python-modules/diagrams { };

  diceware = callPackage ../development/python-modules/diceware { };

  dicom-numpy = callPackage ../development/python-modules/dicom-numpy { };

  dicom2nifti = callPackage ../development/python-modules/dicom2nifti { };

  dicomweb-client = callPackage ../development/python-modules/dicomweb-client { };

  dict2css = callPackage ../development/python-modules/dict2css { };

  dict2xml = callPackage ../development/python-modules/dict2xml { };

  dictdiffer = callPackage ../development/python-modules/dictdiffer { };

  dictionaries = callPackage ../development/python-modules/dictionaries { };

  dicttoxml = callPackage ../development/python-modules/dicttoxml { };

  dicttoxml2 = callPackage ../development/python-modules/dicttoxml2 { };

  diff-cover = callPackage ../development/python-modules/diff-cover { };

  diff-match-patch = callPackage ../development/python-modules/diff-match-patch { };

  diffenator2 = callPackage ../development/python-modules/diffenator2 { };

  diffimg = callPackage ../development/python-modules/diffimg { };

  diffsync = callPackage ../development/python-modules/diffsync { };

  diffusers = callPackage ../development/python-modules/diffusers { };

  digi-xbee = callPackage ../development/python-modules/digi-xbee { };

  dill = callPackage ../development/python-modules/dill { };

  dinghy = callPackage ../development/python-modules/dinghy { };

  dingz = callPackage ../development/python-modules/dingz { };

  dio-chacon-wifi-api = callPackage ../development/python-modules/dio-chacon-wifi-api { };

  diofant = callPackage ../development/python-modules/diofant { };

  dipy = callPackage ../development/python-modules/dipy { };

  directv = callPackage ../development/python-modules/directv { };

  dirigera = callPackage ../development/python-modules/dirigera { };

  dirsearch = callPackage ../development/python-modules/dirsearch { };

  dirty-equals = callPackage ../development/python-modules/dirty-equals { };

  dirtyjson = callPackage ../development/python-modules/dirtyjson { };

  discid = callPackage ../development/python-modules/discid { };

  discogs-client = callPackage ../development/python-modules/discogs-client { };

  discord-webhook = callPackage ../development/python-modules/discord-webhook { };

  discordpy = callPackage ../development/python-modules/discordpy { };

  discovery30303 = callPackage ../development/python-modules/discovery30303 { };

  discum = callPackage ../development/python-modules/discum { };

  diskcache = callPackage ../development/python-modules/diskcache { };

  disnake = callPackage ../development/python-modules/disnake { };

  disposable-email-domains = callPackage ../development/python-modules/disposable-email-domains { };

  dissect = callPackage ../development/python-modules/dissect { };

  dissect-archive = callPackage ../development/python-modules/dissect-archive { };

  dissect-btrfs = callPackage ../development/python-modules/dissect-btrfs { };

  dissect-cim = callPackage ../development/python-modules/dissect-cim { };

  dissect-clfs = callPackage ../development/python-modules/dissect-clfs { };

  dissect-cobaltstrike = callPackage ../development/python-modules/dissect-cobaltstrike { };

  dissect-cramfs = callPackage ../development/python-modules/dissect-cramfs { };

  dissect-cstruct = callPackage ../development/python-modules/dissect-cstruct { };

  dissect-esedb = callPackage ../development/python-modules/dissect-esedb { };

  dissect-etl = callPackage ../development/python-modules/dissect-etl { };

  dissect-eventlog = callPackage ../development/python-modules/dissect-eventlog { };

  dissect-evidence = callPackage ../development/python-modules/dissect-evidence { };

  dissect-executable = callPackage ../development/python-modules/dissect-executable { };

  dissect-extfs = callPackage ../development/python-modules/dissect-extfs { };

  dissect-fat = callPackage ../development/python-modules/dissect-fat { };

  dissect-ffs = callPackage ../development/python-modules/dissect-ffs { };

  dissect-fve = callPackage ../development/python-modules/dissect-fve { };

  dissect-hypervisor = callPackage ../development/python-modules/dissect-hypervisor { };

  dissect-jffs = callPackage ../development/python-modules/dissect-jffs { };

  dissect-ntfs = callPackage ../development/python-modules/dissect-ntfs { };

  dissect-ole = callPackage ../development/python-modules/dissect-ole { };

  dissect-qnxfs = callPackage ../development/python-modules/dissect-qnxfs { };

  dissect-regf = callPackage ../development/python-modules/dissect-regf { };

  dissect-shellitem = callPackage ../development/python-modules/dissect-shellitem { };

  dissect-sql = callPackage ../development/python-modules/dissect-sql { };

  dissect-squashfs = callPackage ../development/python-modules/dissect-squashfs { };

  dissect-target = callPackage ../development/python-modules/dissect-target { };

  dissect-thumbcache = callPackage ../development/python-modules/dissect-thumbcache { };

  dissect-util = callPackage ../development/python-modules/dissect-util { };

  dissect-vmfs = callPackage ../development/python-modules/dissect-vmfs { };

  dissect-volume = callPackage ../development/python-modules/dissect-volume { };

  dissect-xfs = callPackage ../development/python-modules/dissect-xfs { };

  dissononce = callPackage ../development/python-modules/dissononce { };

  dist-meta = callPackage ../development/python-modules/dist-meta { };

  distlib = callPackage ../development/python-modules/distlib { };

  distorm3 = callPackage ../development/python-modules/distorm3 { };

  distrax = callPackage ../development/python-modules/distrax { };

  distributed = callPackage ../development/python-modules/distributed { };

  distro = callPackage ../development/python-modules/distro { };

  distro-info = callPackage ../development/python-modules/distro-info { };

  distutils =
    if pythonOlder "3.12" then null else callPackage ../development/python-modules/distutils { };

  distutils-extra = callPackage ../development/python-modules/distutils-extra { };

  dj-database-url = callPackage ../development/python-modules/dj-database-url { };

  dj-email-url = callPackage ../development/python-modules/dj-email-url { };

  dj-rest-auth = callPackage ../development/python-modules/dj-rest-auth { };

  dj-search-url = callPackage ../development/python-modules/dj-search-url { };

  dj-static = callPackage ../development/python-modules/dj-static { };

  # LTS with mainsteam support
  django = self.django_4;

  django-admin-datta = callPackage ../development/python-modules/django-admin-datta { };

  django-admin-sortable2 = callPackage ../development/python-modules/django-admin-sortable2 { };

  django-agnocomplete = callPackage ../development/python-modules/django-agnocomplete { };

  django-allauth = callPackage ../development/python-modules/django-allauth { };

  django-annoying = callPackage ../development/python-modules/django-annoying { };

  django-anymail = callPackage ../development/python-modules/django-anymail { };

  django-app-helper = callPackage ../development/python-modules/django-app-helper { };

  django-appconf = callPackage ../development/python-modules/django-appconf { };

  django-apscheduler = callPackage ../development/python-modules/django-apscheduler { };

  django-auditlog = callPackage ../development/python-modules/django-auditlog { };

  django-auth-ldap = callPackage ../development/python-modules/django-auth-ldap {
    inherit (pkgs) openldap;
  };

  django-autocomplete-light = callPackage ../development/python-modules/django-autocomplete-light { };

  django-autoslug = callPackage ../development/python-modules/django-autoslug { };

  django-axes = callPackage ../development/python-modules/django-axes { };

  django-bootstrap3 = callPackage ../development/python-modules/django-bootstrap3 { };

  django-bootstrap4 = callPackage ../development/python-modules/django-bootstrap4 { };

  django-bootstrap5 = callPackage ../development/python-modules/django-bootstrap5 { };

  django-cachalot = callPackage ../development/python-modules/django-cachalot { };

  django-cache-memoize = callPackage ../development/python-modules/django-cache-memoize { };

  django-cache-url = callPackage ../development/python-modules/django-cache-url { };

  django-cacheops = callPackage ../development/python-modules/django-cacheops { };

  django-celery-beat = callPackage ../development/python-modules/django-celery-beat { };

  django-celery-email = callPackage ../development/python-modules/django-celery-email { };

  django-celery-results = callPackage ../development/python-modules/django-celery-results { };

  django-choices-field = callPackage ../development/python-modules/django-choices-field { };

  django-ckeditor = callPackage ../development/python-modules/django-ckeditor { };

  django-classy-tags = callPackage ../development/python-modules/django-classy-tags { };

  django-cleanup = callPackage ../development/python-modules/django-cleanup { };

  django-cms = callPackage ../development/python-modules/django-cms { };

  django-colorful = callPackage ../development/python-modules/django-colorful { };

  django-compression-middleware =
    callPackage ../development/python-modules/django-compression-middleware
      { };

  django-compressor = callPackage ../development/python-modules/django-compressor { };

  django-configurations = callPackage ../development/python-modules/django-configurations { };

  django-context-decorator = callPackage ../development/python-modules/django-context-decorator { };

  django-contrib-comments = callPackage ../development/python-modules/django-contrib-comments { };

  django-cors-headers = callPackage ../development/python-modules/django-cors-headers { };

  django-countries = callPackage ../development/python-modules/django-countries { };

  django-crispy-forms = callPackage ../development/python-modules/django-crispy-forms { };

  django-crossdomainmedia = callPackage ../development/python-modules/django-crossdomainmedia { };

  django-cryptography = callPackage ../development/python-modules/django-cryptography { };

  django-csp = callPackage ../development/python-modules/django-csp { };

  django-cte = callPackage ../development/python-modules/django-cte { };

  django-currentuser = callPackage ../development/python-modules/django-currentuser { };

  django-debug-toolbar = callPackage ../development/python-modules/django-debug-toolbar { };

  django-dynamic-preferences =
    callPackage ../development/python-modules/django-dynamic-preferences
      { };

  django-elasticsearch-dsl = callPackage ../development/python-modules/django-elasticsearch-dsl { };

  django-encrypted-model-fields =
    callPackage ../development/python-modules/django-encrypted-model-fields
      { };

  django-environ = callPackage ../development/python-modules/django-environ { };

  django-extensions = callPackage ../development/python-modules/django-extensions { };

  django-filer = callPackage ../development/python-modules/django-filer { };

  django-filingcabinet = callPackage ../development/python-modules/django-filingcabinet { };

  django-filter = callPackage ../development/python-modules/django-filter { };

  django-formset-js-improved =
    callPackage ../development/python-modules/django-formset-js-improved
      { };

  django-formtools = callPackage ../development/python-modules/django-formtools { };

  django-fsm = callPackage ../development/python-modules/django-fsm { };

  django-google-analytics-app =
    callPackage ../development/python-modules/django-google-analytics-app
      { };

  django-graphiql-debug-toolbar =
    callPackage ../development/python-modules/django-graphiql-debug-toolbar
      { };

  django-gravatar2 = callPackage ../development/python-modules/django-gravatar2 { };

  django-guardian = callPackage ../development/python-modules/django-guardian { };

  django-haystack = callPackage ../development/python-modules/django-haystack { };

  django-hcaptcha = callPackage ../development/python-modules/django-hcaptcha { };

  django-health-check = callPackage ../development/python-modules/django-health-check { };

  django-hierarkey = callPackage ../development/python-modules/django-hierarkey { };

  django-hijack = callPackage ../development/python-modules/django-hijack { };

  django-htmx = callPackage ../development/python-modules/django-htmx { };

  django-i18nfield = callPackage ../development/python-modules/django-i18nfield { };

  django-import-export = callPackage ../development/python-modules/django-import-export { };

  django-ipware = callPackage ../development/python-modules/django-ipware { };

  django-jinja = callPackage ../development/python-modules/django-jinja2 { };

  django-jquery-js = callPackage ../development/python-modules/django-jquery-js { };

  django-js-asset = callPackage ../development/python-modules/django-js-asset { };

  django-js-reverse = callPackage ../development/python-modules/django-js-reverse { };

  django-json-widget = callPackage ../development/python-modules/django-json-widget { };

  django-lasuite = callPackage ../development/python-modules/django-lasuite { };

  django-leaflet = callPackage ../development/python-modules/django-leaflet { };

  django-libsass = callPackage ../development/python-modules/django-libsass { };

  django-localflavor = callPackage ../development/python-modules/django-localflavor { };

  django-logentry-admin = callPackage ../development/python-modules/django-logentry-admin { };

  django-login-required-middleware =
    callPackage ../development/python-modules/django-login-required-middleware
      { };

  django-mailman3 = callPackage ../development/python-modules/django-mailman3 { };

  django-maintenance-mode = callPackage ../development/python-modules/django-maintenance-mode { };

  django-markdownx = callPackage ../development/python-modules/django-markdownx { };

  django-markup = callPackage ../development/python-modules/django-markup { };

  django-mcp-server = callPackage ../development/python-modules/django-mcp-server { };

  django-mdeditor = callPackage ../development/python-modules/django-mdeditor { };

  django-mfa3 = callPackage ../development/python-modules/django-mfa3 { };

  django-model-utils = callPackage ../development/python-modules/django-model-utils { };

  django-modelcluster = callPackage ../development/python-modules/django-modelcluster { };

  django-modelsearch = callPackage ../development/python-modules/django-modelsearch { };

  django-modeltranslation = callPackage ../development/python-modules/django-modeltranslation { };

  django-mptt = callPackage ../development/python-modules/django-mptt { };

  django-multiselectfield = callPackage ../development/python-modules/django-multiselectfield { };

  django-ninja = callPackage ../development/python-modules/django-ninja { };

  django-ninja-cursor-pagination =
    callPackage ../development/python-modules/django-ninja-cursor-pagination
      { };

  django-oauth-toolkit = callPackage ../development/python-modules/django-oauth-toolkit { };

  django-organizations = callPackage ../development/python-modules/django-organizations { };

  django-otp = callPackage ../development/python-modules/django-otp { };

  django-otp-webauthn = callPackage ../development/python-modules/django-otp-webauthn { };

  django-paintstore = callPackage ../development/python-modules/django-paintstore { };

  django-parler = callPackage ../development/python-modules/django-parler { };

  django-pattern-library = callPackage ../development/python-modules/django-pattern-library { };

  django-payments = callPackage ../development/python-modules/django-payments { };

  django-pgactivity = callPackage ../development/python-modules/django-pgactivity { };

  django-pghistory = callPackage ../development/python-modules/django-pghistory { };

  django-pglock = callPackage ../development/python-modules/django-pglock { };

  django-pglocks = callPackage ../development/python-modules/django-pglocks { };

  django-pgpubsub = callPackage ../development/python-modules/django-pgpubsub { };

  django-pgtrigger = callPackage ../development/python-modules/django-pgtrigger { };

  django-phonenumber-field = callPackage ../development/python-modules/django-phonenumber-field { };

  django-picklefield = callPackage ../development/python-modules/django-picklefield { };

  django-polymorphic = callPackage ../development/python-modules/django-polymorphic { };

  django-postgres-extra = callPackage ../development/python-modules/django-postgres-extra { };

  django-postgres-partition = callPackage ../development/python-modules/django-postgres-partition { };

  django-postgresql-netfields =
    callPackage ../development/python-modules/django-postgresql-netfields
      { };

  django-probes = callPackage ../development/python-modules/django-probes { };

  django-prometheus = callPackage ../development/python-modules/django-prometheus { };

  django-pwa = callPackage ../development/python-modules/django-pwa { };

  django-pydantic-field = callPackage ../development/python-modules/django-pydantic-field { };

  django-q2 = callPackage ../development/python-modules/django-q2 { };

  django-ranged-response = callPackage ../development/python-modules/django-ranged-response { };

  django-raster = callPackage ../development/python-modules/django-raster { };

  django-ratelimit = callPackage ../development/python-modules/django-ratelimit { };

  django-redis = callPackage ../development/python-modules/django-redis { };

  django-registration = callPackage ../development/python-modules/django-registration { };

  django-rest-auth = callPackage ../development/python-modules/django-rest-auth { };

  django-rest-polymorphic = callPackage ../development/python-modules/django-rest-polymorphic { };

  django-rest-registration = callPackage ../development/python-modules/django-rest-registration { };

  django-reversion = callPackage ../development/python-modules/django-reversion { };

  django-rosetta = callPackage ../development/python-modules/django-rosetta { };

  django-rq = callPackage ../development/python-modules/django-rq { };

  django-scheduler = callPackage ../development/python-modules/django-scheduler { };

  django-scim2 = callPackage ../development/python-modules/django-scim2 { };

  django-scopes = callPackage ../development/python-modules/django-scopes { };

  django-sekizai = callPackage ../development/python-modules/django-sekizai { };

  django-sesame = callPackage ../development/python-modules/django-sesame { };

  django-shortuuidfield = callPackage ../development/python-modules/django-shortuuidfield { };

  django-silk = callPackage ../development/python-modules/django-silk { };

  django-simple-captcha = callPackage ../development/python-modules/django-simple-captcha { };

  django-simple-history = callPackage ../development/python-modules/django-simple-history { };

  django-sites = callPackage ../development/python-modules/django-sites { };

  django-soft-delete = callPackage ../development/python-modules/django-soft-delete { };

  django-split-settings = callPackage ../development/python-modules/django-split-settings { };

  django-sql-utils = callPackage ../development/python-modules/django-sql-utils { };

  django-statici18n = callPackage ../development/python-modules/django-statici18n { };

  django-storages = callPackage ../development/python-modules/django-storages { };

  django-stubs = callPackage ../development/python-modules/django-stubs { };

  django-stubs-ext = callPackage ../development/python-modules/django-stubs-ext { };

  django-tables2 = callPackage ../development/python-modules/django-tables2 { };

  django-tagging = callPackage ../development/python-modules/django-tagging { };

  django-taggit = callPackage ../development/python-modules/django-taggit { };

  django-tasks = callPackage ../development/python-modules/django-tasks { };

  django-tastypie = callPackage ../development/python-modules/django-tastypie { };

  django-tenants = callPackage ../development/python-modules/django-tenants { };

  django-timezone-field = callPackage ../development/python-modules/django-timezone-field { };

  django-tinymce = callPackage ../development/python-modules/django-tinymce { };

  django-tree-queries = callPackage ../development/python-modules/django-tree-queries { };

  django-treebeard = callPackage ../development/python-modules/django-treebeard { };

  django-treenode = callPackage ../development/python-modules/django-treenode { };

  django-two-factor-auth = callPackage ../development/python-modules/django-two-factor-auth { };

  django-types = callPackage ../development/python-modules/django-types { };

  django-versatileimagefield =
    callPackage ../development/python-modules/django-versatileimagefield
      { };

  django-vite = callPackage ../development/python-modules/django-vite { };

  django-weasyprint = callPackage ../development/python-modules/django-weasyprint { };

  django-webpack-loader = callPackage ../development/python-modules/django-webpack-loader { };

  django-webpush = callPackage ../development/python-modules/django-webpush { };

  django-widget-tweaks = callPackage ../development/python-modules/django-widget-tweaks { };

  # LTS in extended support phase
  django_4 = callPackage ../development/python-modules/django/4.nix { };

  django_5 = self.django_5_2;

  django_5_1 = callPackage ../development/python-modules/django/5_1.nix { };

  django_5_2 = callPackage ../development/python-modules/django/5_2.nix { };

  djangocms-admin-style = callPackage ../development/python-modules/djangocms-admin-style { };

  djangocms-alias = callPackage ../development/python-modules/djangocms-alias { };

  djangocms-text-ckeditor = callPackage ../development/python-modules/djangocms-text-ckeditor { };

  djangoql = callPackage ../development/python-modules/djangoql { };

  djangorestframework = callPackage ../development/python-modules/djangorestframework { };

  djangorestframework-camel-case =
    callPackage ../development/python-modules/djangorestframework-camel-case
      { };

  djangorestframework-csv = callPackage ../development/python-modules/djangorestframework-csv { };

  djangorestframework-dataclasses =
    callPackage ../development/python-modules/djangorestframework-dataclasses
      { };

  djangorestframework-guardian =
    callPackage ../development/python-modules/djangorestframework-guardian
      { };

  djangorestframework-jsonp = callPackage ../development/python-modules/djangorestframework-jsonp { };

  djangorestframework-recursive =
    callPackage ../development/python-modules/djangorestframework-recursive
      { };

  djangorestframework-simplejwt =
    callPackage ../development/python-modules/djangorestframework-simplejwt
      { };

  djangorestframework-stubs = callPackage ../development/python-modules/djangorestframework-stubs { };

  djangosaml2 = callPackage ../development/python-modules/djangosaml2 { };

  djmail = callPackage ../development/python-modules/djmail { };

  djoser = callPackage ../development/python-modules/djoser { };

  dkimpy = callPackage ../development/python-modules/dkimpy { };

  dlib = callPackage ../development/python-modules/dlib { inherit (pkgs) dlib; };

  dlinfo = callPackage ../development/python-modules/dlinfo { };

  dllogger = callPackage ../development/python-modules/dllogger { };

  dlms-cosem = callPackage ../development/python-modules/dlms-cosem { };

  dlx = callPackage ../development/python-modules/dlx { };

  dm-control = callPackage ../development/python-modules/dm-control { };

  dm-env = callPackage ../development/python-modules/dm-env { };

  dm-haiku = callPackage ../development/python-modules/dm-haiku { };

  dm-sonnet = callPackage ../development/python-modules/dm-sonnet { };

  dm-tree = callPackage ../development/python-modules/dm-tree {
    inherit (pkgs) abseil-cpp;
  };

  dmenu-python = callPackage ../development/python-modules/dmenu { };

  dmgbuild = callPackage ../development/python-modules/dmgbuild { };

  dmsuite = callPackage ../development/python-modules/dmsuite { };

  dmt-core = callPackage ../development/python-modules/dmt-core { };

  dnachisel = callPackage ../development/python-modules/dnachisel { };

  dncil = callPackage ../development/python-modules/dncil { };

  dnf-plugins-core = callPackage ../development/python-modules/dnf-plugins-core { };

  dnf4 = callPackage ../development/python-modules/dnf4 { };

  dnfile = callPackage ../development/python-modules/dnfile { };

  dns-lexicon = callPackage ../development/python-modules/dns-lexicon { };

  dnslib = callPackage ../development/python-modules/dnslib { };

  dnspython = callPackage ../development/python-modules/dnspython { };

  doc8 = callPackage ../development/python-modules/doc8 { };

  docformatter = callPackage ../development/python-modules/docformatter { };

  docker = callPackage ../development/python-modules/docker { };

  docker-pycreds = callPackage ../development/python-modules/docker-pycreds { };

  dockerfile-parse = callPackage ../development/python-modules/dockerfile-parse { };

  dockerflow = callPackage ../development/python-modules/dockerflow { };

  dockerpty = callPackage ../development/python-modules/dockerpty { };

  dockerspawner = callPackage ../development/python-modules/dockerspawner { };

  docling = callPackage ../development/python-modules/docling { };

  docling-core = callPackage ../development/python-modules/docling-core { };

  docling-ibm-models = callPackage ../development/python-modules/docling-ibm-models { };

  docling-jobkit = callPackage ../development/python-modules/docling-jobkit { };

  docling-mcp = callPackage ../development/python-modules/docling-mcp { };

  docling-parse = callPackage ../development/python-modules/docling-parse {
    loguru-cpp = pkgs.loguru;
  };

  docling-serve = callPackage ../development/python-modules/docling-serve { };

  docloud = callPackage ../development/python-modules/docloud { };

  docopt = callPackage ../development/python-modules/docopt { };

  docopt-ng = callPackage ../development/python-modules/docopt-ng { };

  docopt-subcommands = callPackage ../development/python-modules/docopt-subcommands { };

  docplex = callPackage ../development/python-modules/docplex { };

  docrep = callPackage ../development/python-modules/docrep { };

  docstr-coverage = callPackage ../development/python-modules/docstr-coverage { };

  docstring-parser = callPackage ../development/python-modules/docstring-parser { };

  docstring-to-markdown = callPackage ../development/python-modules/docstring-to-markdown { };

  docutils = callPackage ../development/python-modules/docutils { };

  docx2python = callPackage ../development/python-modules/docx2python { };

  docx2txt = callPackage ../development/python-modules/docx2txt { };

  dodgy = callPackage ../development/python-modules/dodgy { };

  dogpile-cache = callPackage ../development/python-modules/dogpile-cache { };

  dogtag-pki = callPackage ../development/python-modules/dogtag-pki { };

  dogtail = callPackage ../development/python-modules/dogtail { };

  dohq-artifactory = callPackage ../development/python-modules/dohq-artifactory { };

  doit = callPackage ../development/python-modules/doit { };

  doit-py = callPackage ../development/python-modules/doit-py { };

  dokuwiki = callPackage ../development/python-modules/dokuwiki { };

  dom-toml = callPackage ../development/python-modules/dom-toml { };

  domdf-python-tools = callPackage ../development/python-modules/domdf-python-tools { };

  domeneshop = callPackage ../development/python-modules/domeneshop { };

  dominate = callPackage ../development/python-modules/dominate { };

  donfig = callPackage ../development/python-modules/donfig { };

  donut-shellcode = callPackage ../development/python-modules/donut-shellcode { };

  doorbirdpy = callPackage ../development/python-modules/doorbirdpy { };

  dopy = callPackage ../development/python-modules/dopy { };

  dot2tex = callPackage ../development/python-modules/dot2tex { inherit (pkgs) graphviz; };

  dotmap = callPackage ../development/python-modules/dotmap { };

  dotty-dict = callPackage ../development/python-modules/dotty-dict { };

  dotwiz = callPackage ../development/python-modules/dotwiz { };

  doublemetaphone = callPackage ../development/python-modules/doublemetaphone { };

  doubleratchet = callPackage ../development/python-modules/doubleratchet { };

  doubles = callPackage ../development/python-modules/doubles { };

  dowhen = callPackage ../development/python-modules/dowhen { };

  downloader-cli = callPackage ../development/python-modules/downloader-cli { };

  doxmlparser = callPackage ../development/tools/documentation/doxygen/doxmlparser.nix { };

  dparse = callPackage ../development/python-modules/dparse { };

  dparse2 = callPackage ../development/python-modules/dparse2 { };

  dpath = callPackage ../development/python-modules/dpath { };

  dpcontracts = callPackage ../development/python-modules/dpcontracts { };

  dpkt = callPackage ../development/python-modules/dpkt { };

  dploot = callPackage ../development/python-modules/dploot { };

  draccus = callPackage ../development/python-modules/draccus { };

  drafthorse = callPackage ../development/python-modules/drafthorse { };

  draftjs-exporter = callPackage ../development/python-modules/draftjs-exporter { };

  dragonfly = callPackage ../development/python-modules/dragonfly { };

  dragonmapper = callPackage ../development/python-modules/dragonmapper { };

  dramatiq = callPackage ../development/python-modules/dramatiq { };

  dramatiq-abort = callPackage ../development/python-modules/dramatiq-abort { };

  drawille = callPackage ../development/python-modules/drawille { };

  drawilleplot = callPackage ../development/python-modules/drawilleplot { };

  drawsvg = callPackage ../development/python-modules/drawsvg { };

  dremel3dpy = callPackage ../development/python-modules/dremel3dpy { };

  drf-extra-fields = callPackage ../development/python-modules/drf-extra-fields { };

  drf-flex-fields = callPackage ../development/python-modules/drf-flex-fields { };

  drf-jwt = callPackage ../development/python-modules/drf-jwt { };

  drf-nested-routers = callPackage ../development/python-modules/drf-nested-routers { };

  drf-orjson-renderer = callPackage ../development/python-modules/drf-orjson-renderer { };

  drf-pydantic = callPackage ../development/python-modules/drf-pydantic { };

  drf-spectacular = callPackage ../development/python-modules/drf-spectacular { };

  drf-spectacular-sidecar = callPackage ../development/python-modules/drf-spectacular-sidecar { };

  drf-standardized-errors = callPackage ../development/python-modules/drf-standardized-errors { };

  drf-ujson2 = callPackage ../development/python-modules/drf-ujson2 { };

  drf-writable-nested = callPackage ../development/python-modules/drf-writable-nested { };

  drf-yasg = callPackage ../development/python-modules/drf-yasg { };

  drivelib = callPackage ../development/python-modules/drivelib { };

  drms = callPackage ../development/python-modules/drms { };

  dronecan = callPackage ../development/python-modules/dronecan { };

  dropbox = callPackage ../development/python-modules/dropbox { };

  dropmqttapi = callPackage ../development/python-modules/dropmqttapi { };

  ds-analysis-lib = callPackage ../development/python-modules/ds-analysis-lib { };

  ds-reporting-lib = callPackage ../development/python-modules/ds-reporting-lib { };

  ds-server-lib = callPackage ../development/python-modules/ds-server-lib { };

  ds-store = callPackage ../development/python-modules/ds-store { };

  ds-xbom-lib = callPackage ../development/python-modules/ds-xbom-lib { };

  ds4drv = callPackage ../development/python-modules/ds4drv { };

  dscribe = callPackage ../development/python-modules/dscribe { };

  dsinternals = callPackage ../development/python-modules/dsinternals { };

  dsl2html = callPackage ../development/python-modules/dsl2html { };

  dsmr-parser = callPackage ../development/python-modules/dsmr-parser { };

  dsnap = callPackage ../development/python-modules/dsnap { };

  dtfabric = callPackage ../development/python-modules/dtfabric { };

  dtlssocket = callPackage ../development/python-modules/dtlssocket { };

  dtschema = callPackage ../development/python-modules/dtschema { };

  dtw-python = callPackage ../development/python-modules/dtw-python { };

  ducc0 = callPackage ../development/python-modules/ducc0 { };

  duckdb = callPackage ../development/python-modules/duckdb { inherit (pkgs) duckdb; };

  duckdb-engine = callPackage ../development/python-modules/duckdb-engine { };

  duct-py = callPackage ../development/python-modules/duct-py { };

  duden = callPackage ../development/python-modules/duden { };

  duecredit = callPackage ../development/python-modules/duecredit { };

  duet = callPackage ../development/python-modules/duet { };

  dufte = callPackage ../development/python-modules/dufte { };

  dukpy = callPackage ../development/python-modules/dukpy { };

  dulwich = callPackage ../development/python-modules/dulwich { inherit (pkgs) gnupg; };

  dunamai = callPackage ../development/python-modules/dunamai { };

  dungeon-eos = callPackage ../development/python-modules/dungeon-eos { };

  duo-client = callPackage ../development/python-modules/duo-client { };

  duration-parser = callPackage ../development/python-modules/duration-parser { };

  durationpy = callPackage ../development/python-modules/durationpy { };

  durus = callPackage ../development/python-modules/durus { };

  dvc = callPackage ../development/python-modules/dvc { };

  dvc-azure = callPackage ../development/python-modules/dvc-azure { };

  dvc-data = callPackage ../development/python-modules/dvc-data { };

  dvc-gdrive = callPackage ../development/python-modules/dvc-gdrive { };

  dvc-gs = callPackage ../development/python-modules/dvc-gs { };

  dvc-hdfs = callPackage ../development/python-modules/dvc-hdfs { };

  dvc-http = callPackage ../development/python-modules/dvc-http { };

  dvc-objects = callPackage ../development/python-modules/dvc-objects { };

  dvc-oss = callPackage ../development/python-modules/dvc-oss { };

  dvc-render = callPackage ../development/python-modules/dvc-render { };

  dvc-s3 = callPackage ../development/python-modules/dvc-s3 { };

  dvc-ssh = callPackage ../development/python-modules/dvc-ssh { };

  dvc-studio-client = callPackage ../development/python-modules/dvc-studio-client { };

  dvc-task = callPackage ../development/python-modules/dvc-task { };

  dvc-webdav = callPackage ../development/python-modules/dvc-webdav { };

  dvc-webhdfs = callPackage ../development/python-modules/dvc-webhdfs { };

  dvclive = callPackage ../development/python-modules/dvclive { };

  dwdwfsapi = callPackage ../development/python-modules/dwdwfsapi { };

  dyn = callPackage ../development/python-modules/dyn { };

  dynaconf = callPackage ../development/python-modules/dynaconf { };

  dynalite-devices = callPackage ../development/python-modules/dynalite-devices { };

  dynalite-panel = callPackage ../development/python-modules/dynalite-panel { };

  dynd = callPackage ../development/python-modules/dynd { };

  e2b = callPackage ../development/python-modules/e2b { };

  e2b-code-interpreter = callPackage ../development/python-modules/e2b-code-interpreter { };

  e3-core = callPackage ../development/python-modules/e3-core { };

  e3-testsuite = callPackage ../development/python-modules/e3-testsuite { };

  eagle100 = callPackage ../development/python-modules/eagle100 { };

  easy-thumbnails = callPackage ../development/python-modules/easy-thumbnails { };

  easydict = callPackage ../development/python-modules/easydict { };

  easyenergy = callPackage ../development/python-modules/easyenergy { };

  easygui = callPackage ../development/python-modules/easygui { };

  easyocr = callPackage ../development/python-modules/easyocr { };

  easyprocess = callPackage ../development/python-modules/easyprocess { };

  easywatch = callPackage ../development/python-modules/easywatch { };

  ebaysdk = callPackage ../development/python-modules/ebaysdk { };

  ebcdic = callPackage ../development/python-modules/ebcdic { };

  ebooklib = callPackage ../development/python-modules/ebooklib { };

  ebusdpy = callPackage ../development/python-modules/ebusdpy { };

  ec2-metadata = callPackage ../development/python-modules/ec2-metadata { };

  ec2instanceconnectcli = callPackage ../tools/virtualization/ec2instanceconnectcli { };

  eccodes = toPythonModule (
    pkgs.eccodes.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  ecdsa = callPackage ../development/python-modules/ecdsa { };

  echo = callPackage ../development/python-modules/echo {
    inherit (pkgs) mesa;
  };

  ecoaliface = callPackage ../development/python-modules/ecoaliface { };

  ecos = callPackage ../development/python-modules/ecos { };

  ecpy = callPackage ../development/python-modules/ecpy { };

  ecs-logging = callPackage ../development/python-modules/ecs-logging { };

  ed25519 = callPackage ../development/python-modules/ed25519 { };

  ed25519-blake2b = callPackage ../development/python-modules/ed25519-blake2b { };

  edalize = callPackage ../development/python-modules/edalize { };

  edge-tts = callPackage ../development/python-modules/edge-tts { };

  editables = callPackage ../development/python-modules/editables { };

  editdistance = callPackage ../development/python-modules/editdistance { };

  editdistpy = callPackage ../development/python-modules/editdistpy { };

  editor = callPackage ../development/python-modules/editor { };

  editorconfig = callPackage ../development/python-modules/editorconfig { };

  edk2-pytool-library = callPackage ../development/python-modules/edk2-pytool-library { };

  edlib = callPackage ../development/python-modules/edlib { inherit (pkgs) edlib; };

  eduvpn-common = callPackage ../development/python-modules/eduvpn-common { };

  edward = callPackage ../development/python-modules/edward { };

  effdet = callPackage ../development/python-modules/effdet { };

  effect = callPackage ../development/python-modules/effect { };

  eggdeps = callPackage ../development/python-modules/eggdeps { };

  eheimdigital = callPackage ../development/python-modules/eheimdigital { };

  eigenpy = callPackage ../development/python-modules/eigenpy {
    inherit (pkgs) graphviz; # need the `dot` program, not the python module
  };

  einops = callPackage ../development/python-modules/einops { };

  einx = callPackage ../development/python-modules/einx { };

  eiswarnung = callPackage ../development/python-modules/eiswarnung { };

  ekey-bionyxpy = callPackage ../development/python-modules/ekey-bionyxpy { };

  elastic-apm = callPackage ../development/python-modules/elastic-apm { };

  elastic-transport = callPackage ../development/python-modules/elastic-transport { };

  elasticsearch = callPackage ../development/python-modules/elasticsearch { };

  elasticsearch-dsl = callPackage ../development/python-modules/elasticsearch-dsl { };

  elasticsearch8 = callPackage ../development/python-modules/elasticsearch8 { };

  elasticsearchdsl = self.elasticsearch-dsl;

  electrickiwi-api = callPackage ../development/python-modules/electrickiwi-api { };

  electrum-aionostr = callPackage ../development/python-modules/electrum-aionostr { };

  electrum-ecc = callPackage ../development/python-modules/electrum-ecc { };

  elementpath = callPackage ../development/python-modules/elementpath { };

  elevate = callPackage ../development/python-modules/elevate { };

  elevenlabs = callPackage ../development/python-modules/elevenlabs { };

  elfdeps = toPythonModule (pkgs.elfdeps.override { python3Packages = self; });

  elgato = callPackage ../development/python-modules/elgato { };

  eliot = callPackage ../development/python-modules/eliot { };

  eliqonline = callPackage ../development/python-modules/eliqonline { };

  elkm1-lib = callPackage ../development/python-modules/elkm1-lib { };

  elkoep-aio-mqtt = callPackage ../development/python-modules/elkoep-aio-mqtt { };

  elmax = callPackage ../development/python-modules/elmax { };

  elmax-api = callPackage ../development/python-modules/elmax-api { };

  elvia = callPackage ../development/python-modules/elvia { };

  email-validator = callPackage ../development/python-modules/email-validator { };

  emailthreads = callPackage ../development/python-modules/emailthreads { };

  embedding-reader = callPackage ../development/python-modules/embedding-reader { };

  emborg = callPackage ../development/python-modules/emborg { };

  embrace = callPackage ../development/python-modules/embrace { };

  emcee = callPackage ../development/python-modules/emcee { };

  emoji = callPackage ../development/python-modules/emoji { };

  emojis = callPackage ../development/python-modules/emojis { };

  empty-files = callPackage ../development/python-modules/empty-files { };

  empy = callPackage ../development/python-modules/empy { };

  emulated-roku = callPackage ../development/python-modules/emulated-roku { };

  emv = callPackage ../development/python-modules/emv { };

  enaml = callPackage ../development/python-modules/enaml { };

  enamlx = callPackage ../development/python-modules/enamlx { };

  encodec = callPackage ../development/python-modules/encodec { };

  energyflip-client = callPackage ../development/python-modules/energyflip-client { };

  energyflow = callPackage ../development/python-modules/energyflow { };

  energyzero = callPackage ../development/python-modules/energyzero { };

  enlighten = callPackage ../development/python-modules/enlighten { };

  enocean = callPackage ../development/python-modules/enocean { };

  enochecker-core = callPackage ../development/python-modules/enochecker-core { };

  enrich = callPackage ../development/python-modules/enrich { };

  enterpriseattack = callPackage ../development/python-modules/enterpriseattack { };

  entrance = callPackage ../development/python-modules/entrance { routerFeatures = false; };

  entrance-with-router-features = callPackage ../development/python-modules/entrance {
    routerFeatures = true;
  };

  entry-points-txt = callPackage ../development/python-modules/entry-points-txt { };

  entrypoint2 = callPackage ../development/python-modules/entrypoint2 { };

  entrypoints = callPackage ../development/python-modules/entrypoints { };

  entsoe-apy = callPackage ../development/python-modules/entsoe-apy { };

  enturclient = callPackage ../development/python-modules/enturclient { };

  env-canada = callPackage ../development/python-modules/env-canada { };

  environ-config = callPackage ../development/python-modules/environ-config { };

  environmental-override = callPackage ../development/python-modules/environmental-override { };

  environs = callPackage ../development/python-modules/environs { };

  envisage = callPackage ../development/python-modules/envisage { };

  envoy-reader = callPackage ../development/python-modules/envoy-reader { };

  envoy-utils = callPackage ../development/python-modules/envoy-utils { };

  envs = callPackage ../development/python-modules/envs { };

  enzyme = callPackage ../development/python-modules/enzyme { };

  epc = callPackage ../development/python-modules/epc { };

  ephem = callPackage ../development/python-modules/ephem { };

  ephemeral-port-reserve = callPackage ../development/python-modules/ephemeral-port-reserve { };

  epicstore-api = callPackage ../development/python-modules/epicstore-api { };

  epion = callPackage ../development/python-modules/epion { };

  epitran = callPackage ../development/python-modules/epitran { };

  epson-projector = callPackage ../development/python-modules/epson-projector { };

  eq3btsmart = callPackage ../development/python-modules/eq3btsmart { };

  equinox = callPackage ../development/python-modules/equinox { };

  eradicate = callPackage ../development/python-modules/eradicate { };

  es-client = callPackage ../development/python-modules/es-client { };

  escapism = callPackage ../development/python-modules/escapism { };

  eseries = callPackage ../development/python-modules/eseries { };

  esig = callPackage ../development/python-modules/esig { };

  esp-idf-size = callPackage ../development/python-modules/esp-idf-size { };

  espeak-phonemizer = callPackage ../development/python-modules/espeak-phonemizer { };

  esper = callPackage ../development/python-modules/esper { };

  esphome-dashboard-api = callPackage ../development/python-modules/esphome-dashboard-api { };

  esphome-glyphsets = callPackage ../development/python-modules/esphome-glyphsets { };

  esprima = callPackage ../development/python-modules/esprima { };

  essentials = callPackage ../development/python-modules/essentials { };

  essentials-openapi = callPackage ../development/python-modules/essentials-openapi { };

  et-xmlfile = callPackage ../development/python-modules/et-xmlfile { };

  etcd = callPackage ../development/python-modules/etcd { };

  etcd3 = callPackage ../development/python-modules/etcd3 { inherit (pkgs) etcd; };

  ete3 = callPackage ../development/python-modules/ete3 { };

  etebase = callPackage ../development/python-modules/etebase { };

  etelemetry = callPackage ../development/python-modules/etelemetry { };

  eternalegypt = callPackage ../development/python-modules/eternalegypt { };

  etesync = callPackage ../development/python-modules/etesync { };

  eth-abi = callPackage ../development/python-modules/eth-abi { };

  eth-account = callPackage ../development/python-modules/eth-account { };

  eth-bloom = callPackage ../development/python-modules/eth-bloom { };

  eth-hash = callPackage ../development/python-modules/eth-hash { };

  eth-keyfile = callPackage ../development/python-modules/eth-keyfile { };

  eth-keys = callPackage ../development/python-modules/eth-keys { };

  eth-rlp = callPackage ../development/python-modules/eth-rlp { };

  eth-tester = callPackage ../development/python-modules/eth-tester { };

  eth-typing = callPackage ../development/python-modules/eth-typing { };

  eth-utils = callPackage ../development/python-modules/eth-utils { };

  ethtool = callPackage ../development/python-modules/ethtool { };

  etils = callPackage ../development/python-modules/etils { };

  etuples = callPackage ../development/python-modules/etuples { };

  euclid3 = callPackage ../development/python-modules/euclid3 { };

  eufylife-ble-client = callPackage ../development/python-modules/eufylife-ble-client { };

  euporie = callPackage ../development/python-modules/euporie { };

  eval-type-backport = callPackage ../development/python-modules/eval-type-backport { };

  evaluate = callPackage ../development/python-modules/evaluate { };

  evdev = callPackage ../development/python-modules/evdev { };

  eve = callPackage ../development/python-modules/eve { };

  eventkit = callPackage ../development/python-modules/eventkit { };

  eventlet = callPackage ../development/python-modules/eventlet { };

  events = callPackage ../development/python-modules/events { };

  everett = callPackage ../development/python-modules/everett { };

  evohome-async = callPackage ../development/python-modules/evohome-async { };

  evolutionhttp = callPackage ../development/python-modules/evolutionhttp { };

  evosax = callPackage ../development/python-modules/evosax { };

  evtx = callPackage ../development/python-modules/evtx { };

  ewmh = callPackage ../development/python-modules/ewmh { };

  ewmhlib = callPackage ../development/python-modules/ewmhlib { };

  example-robot-data = callPackage ../development/python-modules/example-robot-data {
    inherit (pkgs) example-robot-data;
  };

  exceptiongroup = callPackage ../development/python-modules/exceptiongroup { };

  exchangelib = callPackage ../development/python-modules/exchangelib { };

  exdown = callPackage ../development/python-modules/exdown { };

  execnb = callPackage ../development/python-modules/execnb { };

  execnet = callPackage ../development/python-modules/execnet { };

  executing = callPackage ../development/python-modules/executing { };

  executor = callPackage ../development/python-modules/executor { };

  exif = callPackage ../development/python-modules/exif { };

  exifread = callPackage ../development/python-modules/exifread { };

  exitcode = callPackage ../development/python-modules/exitcode { };

  exiv2 = callPackage ../development/python-modules/exiv2 { inherit (pkgs) exiv2; };

  expandvars = callPackage ../development/python-modules/expandvars { };

  expects = callPackage ../development/python-modules/expects { };

  expecttest = callPackage ../development/python-modules/expecttest { };

  experiment-utilities = callPackage ../development/python-modules/experiment-utilities { };

  expiring-dict = callPackage ../development/python-modules/expiring-dict { };

  expiringdict = callPackage ../development/python-modules/expiringdict { };

  explorerscript = callPackage ../development/python-modules/explorerscript { };

  exrex = callPackage ../development/python-modules/exrex { };

  extension-helpers = callPackage ../development/python-modules/extension-helpers { };

  extract-msg = callPackage ../development/python-modules/extract-msg { };

  extractcode = callPackage ../development/python-modules/extractcode { };

  extractcode-7z = callPackage ../development/python-modules/extractcode/7z.nix {
    inherit (pkgs) p7zip;
  };

  extractcode-libarchive = callPackage ../development/python-modules/extractcode/libarchive.nix {
    inherit (pkgs)
      libarchive
      libb2
      bzip2
      expat
      lz4
      xz
      zlib
      zstd
      ;
  };

  extras = callPackage ../development/python-modules/extras { };

  extruct = callPackage ../development/python-modules/extruct { };

  eyed3 = callPackage ../development/python-modules/eyed3 { };

  ezdxf = callPackage ../development/python-modules/ezdxf { };

  ezodf = callPackage ../development/python-modules/ezodf { };

  ezyrb = callPackage ../development/python-modules/ezyrb { };

  f3d = toPythonModule (
    pkgs.f3d.override {
      withPythonBinding = true;
      python3Packages = self;
    }
  );

  f5-icontrol-rest = callPackage ../development/python-modules/f5-icontrol-rest { };

  f5-sdk = callPackage ../development/python-modules/f5-sdk { };

  f90nml = callPackage ../development/python-modules/f90nml { };

  faadelays = callPackage ../development/python-modules/faadelays { };

  fabio = callPackage ../development/python-modules/fabio { };

  fabric = callPackage ../development/python-modules/fabric { };

  fabulous = callPackage ../development/python-modules/fabulous { };

  face = callPackage ../development/python-modules/face { };

  face-recognition = callPackage ../development/python-modules/face-recognition { };

  face-recognition-models = callPackage ../development/python-modules/face-recognition/models.nix { };

  facebook-sdk = callPackage ../development/python-modules/facebook-sdk { };

  facedancer = callPackage ../development/python-modules/facedancer { };

  facenet-pytorch = callPackage ../development/python-modules/facenet-pytorch { };

  factory-boy = callPackage ../development/python-modules/factory-boy { };

  faicons = callPackage ../development/python-modules/faicons { };

  fairscale = callPackage ../development/python-modules/fairscale { };

  fairseq = callPackage ../development/python-modules/fairseq { };

  faiss = callPackage ../development/python-modules/faiss {
    faiss-build = pkgs.faiss.override {
      pythonSupport = true;
      python3Packages = self;
    };
  };

  fake-useragent = callPackage ../development/python-modules/fake-useragent { };

  faker = callPackage ../development/python-modules/faker { };

  fakeredis = callPackage ../development/python-modules/fakeredis { };

  falcon = callPackage ../development/python-modules/falcon { };

  falcon-cors = callPackage ../development/python-modules/falcon-cors { };

  falconpy = callPackage ../development/python-modules/falconpy { };

  faraday-agent-parameters-types =
    callPackage ../development/python-modules/faraday-agent-parameters-types
      { };

  faraday-plugins = callPackage ../development/python-modules/faraday-plugins { };

  farama-notifications = callPackage ../development/python-modules/farama-notifications { };

  fast-array-utils = callPackage ../development/python-modules/fast-array-utils { };

  fast-histogram = callPackage ../development/python-modules/fast-histogram { };

  fast-query-parsers = callPackage ../development/python-modules/fast-query-parsers { };

  fast-simplification = callPackage ../development/python-modules/fast-simplification { };

  fastai = callPackage ../development/python-modules/fastai { };

  fastapi = callPackage ../development/python-modules/fastapi { };

  fastapi-cli = callPackage ../development/python-modules/fastapi-cli { };

  fastapi-github-oidc = callPackage ../development/python-modules/fastapi-github-oidc { };

  fastapi-mail = callPackage ../development/python-modules/fastapi-mail { };

  fastapi-mcp = callPackage ../development/python-modules/fastapi-mcp { };

  fastapi-sso = callPackage ../development/python-modules/fastapi-sso { };

  fastavro = callPackage ../development/python-modules/fastavro { };

  fastbencode = callPackage ../development/python-modules/fastbencode { };

  fastcache = callPackage ../development/python-modules/fastcache { };

  fastcore = callPackage ../development/python-modules/fastcore { };

  fastcrc = callPackage ../development/python-modules/fastcrc { };

  fastdiff = callPackage ../development/python-modules/fastdiff { };

  fastdotcom = callPackage ../development/python-modules/fastdotcom { };

  fastdownload = callPackage ../development/python-modules/fastdownload { };

  fastdtw = callPackage ../development/python-modules/fastdtw { };

  fastecdsa = callPackage ../development/python-modules/fastecdsa { };

  fastembed = callPackage ../development/python-modules/fastembed { };

  fasteners = callPackage ../development/python-modules/fasteners { };

  fastentrypoints = callPackage ../development/python-modules/fastentrypoints { };

  faster-whisper = callPackage ../development/python-modules/faster-whisper { };

  fastexcel = callPackage ../development/python-modules/fastexcel { };

  fastimport = callPackage ../development/python-modules/fastimport { };

  fastjet = callPackage ../development/python-modules/fastjet { };

  fastjsonschema = callPackage ../development/python-modules/fastjsonschema { };

  fastmcp = callPackage ../development/python-modules/fastmcp { };

  fastmri = callPackage ../development/python-modules/fastmri { };

  fastnlo-toolkit = toPythonModule (
    pkgs.fastnlo-toolkit.override {
      withPython = true;
      inherit (self) python;
    }
  );

  fastnumbers = callPackage ../development/python-modules/fastnumbers { };

  fastparquet = callPackage ../development/python-modules/fastparquet { };

  fastpbkdf2 = callPackage ../development/python-modules/fastpbkdf2 { };

  fastprogress = callPackage ../development/python-modules/fastprogress { };

  fastremap = callPackage ../development/python-modules/fastremap { };

  fastrlock = callPackage ../development/python-modules/fastrlock { };

  fasttext = callPackage ../development/python-modules/fasttext { };

  fasttext-predict = callPackage ../development/python-modules/fasttext-predict { };

  fastuuid = callPackage ../development/python-modules/fastuuid { };

  fatrop = toPythonModule (
    pkgs.fatrop.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  faust-cchardet = callPackage ../development/python-modules/faust-cchardet { };

  fava = callPackage ../development/python-modules/fava { };

  fava-dashboards = callPackage ../development/python-modules/fava-dashboards { };

  fava-investor = callPackage ../development/python-modules/fava-investor { };

  favicon = callPackage ../development/python-modules/favicon { };

  fe25519 = callPackage ../development/python-modules/fe25519 { };

  feather-format = callPackage ../development/python-modules/feather-format { };

  fedora-messaging = callPackage ../development/python-modules/fedora-messaging { };

  feedfinder2 = callPackage ../development/python-modules/feedfinder2 { };

  feedgen = callPackage ../development/python-modules/feedgen { };

  feedgenerator = callPackage ../development/python-modules/feedgenerator { };

  feedparser = callPackage ../development/python-modules/feedparser { };

  fenics-basix = callPackage ../development/python-modules/fenics-basix { };

  fenics-dolfinx = callPackage ../development/python-modules/fenics-dolfinx { };

  fenics-ffcx = callPackage ../development/python-modules/fenics-ffcx { };

  fenics-ufl = callPackage ../development/python-modules/fenics-ufl { };

  ffcv = callPackage ../development/python-modules/ffcv { };

  ffmpeg-progress-yield = callPackage ../development/python-modules/ffmpeg-progress-yield { };

  ffmpeg-python = callPackage ../development/python-modules/ffmpeg-python { };

  ffmpy = callPackage ../development/python-modules/ffmpy { };

  fhir-py = callPackage ../development/python-modules/fhir-py { };

  fiblary3-fork = callPackage ../development/python-modules/fiblary3-fork { };

  fickling = callPackage ../development/python-modules/fickling { };

  fido2 = callPackage ../development/python-modules/fido2 { };

  fields = callPackage ../development/python-modules/fields { };

  file-read-backwards = callPackage ../development/python-modules/file-read-backwards { };

  filebrowser-safe = callPackage ../development/python-modules/filebrowser-safe { };

  filebytes = callPackage ../development/python-modules/filebytes { };

  filecheck = callPackage ../development/python-modules/filecheck { };

  filedate = callPackage ../development/python-modules/filedate { };

  filedepot = callPackage ../development/python-modules/filedepot { };

  filelock = callPackage ../development/python-modules/filelock { };

  files-to-prompt = callPackage ../development/python-modules/files-to-prompt { };

  filetype = callPackage ../development/python-modules/filetype { };

  filterpy = callPackage ../development/python-modules/filterpy { };

  finalfusion = callPackage ../development/python-modules/finalfusion { };

  find-libpython = callPackage ../development/python-modules/find-libpython { };

  findimports = callPackage ../development/python-modules/findimports { };

  findpython = callPackage ../development/python-modules/findpython { };

  findspark = callPackage ../development/python-modules/findspark { };

  finetuning-scheduler = callPackage ../development/python-modules/finetuning-scheduler { };

  fingerprints = callPackage ../development/python-modules/fingerprints { };

  finitude = callPackage ../development/python-modules/finitude { };

  fints = callPackage ../development/python-modules/fints { };

  finvizfinance = callPackage ../development/python-modules/finvizfinance { };

  fiona = callPackage ../development/python-modules/fiona { };

  fipy = callPackage ../development/python-modules/fipy { };

  fire = callPackage ../development/python-modules/fire { };

  firebase-admin = callPackage ../development/python-modules/firebase-admin { };

  firebase-messaging = callPackage ../development/python-modules/firebase-messaging { };

  firecrawl-py = callPackage ../development/python-modules/firecrawl-py { };

  firedrake = callPackage ../development/python-modules/firedrake { };

  firedrake-fiat = callPackage ../development/python-modules/firedrake-fiat { };

  fireflyalgorithm = callPackage ../development/python-modules/fireflyalgorithm { };

  firetv = callPackage ../development/python-modules/firetv { };

  fireworks-ai = callPackage ../development/python-modules/fireworks-ai { };

  first = callPackage ../development/python-modules/first { };

  fissix = callPackage ../development/python-modules/fissix { };

  fitbit = callPackage ../development/python-modules/fitbit { };

  fitdecode = callPackage ../development/python-modules/fitdecode { };

  fitfile = callPackage ../development/python-modules/fitfile { };

  fivem-api = callPackage ../development/python-modules/fivem-api { };

  fixerio = callPackage ../development/python-modules/fixerio { };

  fixtures = callPackage ../development/python-modules/fixtures { };

  fjaraskupan = callPackage ../development/python-modules/fjaraskupan { };

  flake8 = callPackage ../development/python-modules/flake8 { };

  flake8-blind-except = callPackage ../development/python-modules/flake8-blind-except { };

  flake8-bugbear = callPackage ../development/python-modules/flake8-bugbear { };

  flake8-class-newline = callPackage ../development/python-modules/flake8-class-newline { };

  flake8-debugger = callPackage ../development/python-modules/flake8-debugger { };

  flake8-deprecated = callPackage ../development/python-modules/flake8-deprecated { };

  flake8-docstrings = callPackage ../development/python-modules/flake8-docstrings { };

  flake8-future-import = callPackage ../development/python-modules/flake8-future-import { };

  flake8-import-order = callPackage ../development/python-modules/flake8-import-order { };

  flake8-length = callPackage ../development/python-modules/flake8-length { };

  flake8-polyfill = callPackage ../development/python-modules/flake8-polyfill { };

  flake8-quotes = callPackage ../development/python-modules/flake8-quotes { };

  flaky = callPackage ../development/python-modules/flaky { };

  flametree = callPackage ../development/python-modules/flametree { };

  flammkuchen = callPackage ../development/python-modules/flammkuchen { };

  flasgger = callPackage ../development/python-modules/flasgger { };

  flash-attn = callPackage ../development/python-modules/flash-attn { };

  flashinfer = callPackage ../development/python-modules/flashinfer { };

  flashtext = callPackage ../development/python-modules/flashtext { };

  flask = callPackage ../development/python-modules/flask { };

  flask-admin = callPackage ../development/python-modules/flask-admin { };

  flask-alembic = callPackage ../development/python-modules/flask-alembic { };

  flask-allowed-hosts = callPackage ../development/python-modules/flask-allowed-hosts { };

  flask-api = callPackage ../development/python-modules/flask-api { };

  flask-appbuilder = callPackage ../development/python-modules/flask-appbuilder { };

  flask-assets = callPackage ../development/python-modules/flask-assets { };

  flask-babel = callPackage ../development/python-modules/flask-babel { };

  flask-bcrypt = callPackage ../development/python-modules/flask-bcrypt { };

  flask-bootstrap = callPackage ../development/python-modules/flask-bootstrap { };

  flask-caching = callPackage ../development/python-modules/flask-caching { };

  flask-compress = callPackage ../development/python-modules/flask-compress { };

  flask-cors = callPackage ../development/python-modules/flask-cors { };

  flask-dance = callPackage ../development/python-modules/flask-dance { };

  flask-dramatiq = callPackage ../development/python-modules/flask-dramatiq { };

  flask-elastic = callPackage ../development/python-modules/flask-elastic { };

  flask-expects-json = callPackage ../development/python-modules/flask-expects-json { };

  flask-gravatar = callPackage ../development/python-modules/flask-gravatar { };

  flask-httpauth = callPackage ../development/python-modules/flask-httpauth { };

  flask-jwt-extended = callPackage ../development/python-modules/flask-jwt-extended { };

  flask-limiter = callPackage ../development/python-modules/flask-limiter { };

  flask-login = callPackage ../development/python-modules/flask-login { };

  flask-mail = callPackage ../development/python-modules/flask-mail { };

  flask-mailman = callPackage ../development/python-modules/flask-mailman { };

  flask-marshmallow = callPackage ../development/python-modules/flask-marshmallow { };

  flask-migrate = callPackage ../development/python-modules/flask-migrate { };

  flask-mongoengine = callPackage ../development/python-modules/flask-mongoengine { };

  flask-mysqldb = callPackage ../development/python-modules/flask-mysqldb { };

  flask-openid = callPackage ../development/python-modules/flask-openid { };

  flask-paginate = callPackage ../development/python-modules/flask-paginate { };

  flask-paranoid = callPackage ../development/python-modules/flask-paranoid { };

  flask-principal = callPackage ../development/python-modules/flask-principal { };

  flask-pymongo = callPackage ../development/python-modules/flask-pymongo { };

  flask-restful = callPackage ../development/python-modules/flask-restful { };

  flask-restx = callPackage ../development/python-modules/flask-restx { };

  flask-reverse-proxy-fix = callPackage ../development/python-modules/flask-reverse-proxy-fix { };

  flask-script = callPackage ../development/python-modules/flask-script { };

  flask-seasurf = callPackage ../development/python-modules/flask-seasurf { };

  flask-security = callPackage ../development/python-modules/flask-security { };

  flask-session = callPackage ../development/python-modules/flask-session { };

  flask-session-captcha = callPackage ../development/python-modules/flask-session-captcha { };

  flask-session2 = callPackage ../development/python-modules/flask-session2 { };

  flask-simpleldap = callPackage ../development/python-modules/flask-simpleldap { };

  flask-sock = callPackage ../development/python-modules/flask-sock { };

  flask-socketio = callPackage ../development/python-modules/flask-socketio { };

  flask-sqlalchemy = callPackage ../development/python-modules/flask-sqlalchemy { };

  flask-sqlalchemy-lite = callPackage ../development/python-modules/flask-sqlalchemy-lite { };

  flask-sslify = callPackage ../development/python-modules/flask-sslify { };

  flask-swagger = callPackage ../development/python-modules/flask-swagger { };

  flask-swagger-ui = callPackage ../development/python-modules/flask-swagger-ui { };

  flask-talisman = callPackage ../development/python-modules/flask-talisman { };

  flask-testing = callPackage ../development/python-modules/flask-testing { };

  flask-themer = callPackage ../development/python-modules/flask-themer { };

  flask-themes2 = callPackage ../development/python-modules/flask-themes2 { };

  flask-unsign = callPackage ../development/python-modules/flask-unsign { };

  flask-versioned = callPackage ../development/python-modules/flask-versioned { };

  flask-webtest = callPackage ../development/python-modules/flask-webtest { };

  flask-wtf = callPackage ../development/python-modules/flask-wtf { };

  flask-xml-rpc-re = callPackage ../development/python-modules/flask-xml-rpc-re { };

  flatbencode = callPackage ../development/python-modules/flatbencode { };

  flatbuffers = callPackage ../development/python-modules/flatbuffers { inherit (pkgs) flatbuffers; };

  flatdict = callPackage ../development/python-modules/flatdict { };

  flatlatex = callPackage ../development/python-modules/flatlatex { };

  flatten-dict = callPackage ../development/python-modules/flatten-dict { };

  flatten-json = callPackage ../development/python-modules/flatten-json { };

  flax = callPackage ../development/python-modules/flax { };

  flaxlib = callPackage ../development/python-modules/flaxlib { };

  fleep = callPackage ../development/python-modules/fleep { };

  flet = callPackage ../development/python-modules/flet { };

  flet-cli = callPackage ../development/python-modules/flet-cli { };

  flet-desktop = callPackage ../development/python-modules/flet-desktop { };

  flet-web = callPackage ../development/python-modules/flet-web { };

  flexcache = callPackage ../development/python-modules/flexcache { };

  flexit-bacnet = callPackage ../development/python-modules/flexit-bacnet { };

  flexmock = callPackage ../development/python-modules/flexmock { };

  flexparser = callPackage ../development/python-modules/flexparser { };

  flickrapi = callPackage ../development/python-modules/flickrapi { };

  flipr-api = callPackage ../development/python-modules/flipr-api { };

  flit = callPackage ../development/python-modules/flit { };

  flit-core = callPackage ../development/python-modules/flit-core { };

  flit-gettext = callPackage ../development/python-modules/flit-gettext { };

  flit-scm = callPackage ../development/python-modules/flit-scm { };

  floret = callPackage ../development/python-modules/floret { };

  flow-record = callPackage ../development/python-modules/flow-record { };

  flower = callPackage ../development/python-modules/flower { };

  flowjax = callPackage ../development/python-modules/flowjax { };

  flowlogs-reader = callPackage ../development/python-modules/flowlogs-reader { };

  flowmc = callPackage ../development/python-modules/flowmc { };

  fluent-logger = callPackage ../development/python-modules/fluent-logger { };

  fluent-pygments = callPackage ../development/python-modules/python-fluent/fluent-pygments.nix { };

  fluent-runtime = callPackage ../development/python-modules/python-fluent/fluent-runtime.nix { };

  fluent-syntax = callPackage ../development/python-modules/python-fluent/fluent-syntax.nix { };

  flufl-bounce = callPackage ../development/python-modules/flufl/bounce.nix { };

  flufl-i18n = callPackage ../development/python-modules/flufl/i18n.nix { };

  flufl-lock = callPackage ../development/python-modules/flufl/lock.nix { };

  flux-led = callPackage ../development/python-modules/flux-led { };

  flyingsquid = callPackage ../development/python-modules/flyingsquid { };

  flynt = callPackage ../development/python-modules/flynt { };

  fmpy = callPackage ../development/python-modules/fmpy { };

  fnllm = callPackage ../development/python-modules/fnllm { };

  fnv-hash-fast = callPackage ../development/python-modules/fnv-hash-fast { };

  fnvhash = callPackage ../development/python-modules/fnvhash { };

  folium = callPackage ../development/python-modules/folium { };

  font-v = callPackage ../development/python-modules/font-v { };

  fontawesomefree = callPackage ../development/python-modules/fontawesomefree { };

  fontbakery = callPackage ../development/python-modules/fontbakery { };

  fontfeatures = callPackage ../development/python-modules/fontfeatures { };

  fontforge = disabledIf (pythonOlder "3.10") (
    toPythonModule (
      pkgs.fontforge.override {
        withPython = true;
        python3 = python;
      }
    )
  );

  fontmake = callPackage ../development/python-modules/fontmake { };

  fontmath = callPackage ../development/python-modules/fontmath { };

  fontparts = callPackage ../development/python-modules/fontparts { };

  fontpens = callPackage ../development/python-modules/fontpens { };

  fonttools = callPackage ../development/python-modules/fonttools { };

  foobot-async = callPackage ../development/python-modules/foobot-async { };

  foolscap = callPackage ../development/python-modules/foolscap { };

  forbiddenfruit = callPackage ../development/python-modules/forbiddenfruit { };

  fordpass = callPackage ../development/python-modules/fordpass { };

  forecast-solar = callPackage ../development/python-modules/forecast-solar { };

  formbox = callPackage ../development/python-modules/formbox { };

  formencode = callPackage ../development/python-modules/formencode { };

  formulae = callPackage ../development/python-modules/formulae { };

  formulaic = callPackage ../development/python-modules/formulaic { };

  fortiosapi = callPackage ../development/python-modules/fortiosapi { };

  foundationdb = callPackage ../development/python-modules/foundationdb {
    inherit (pkgs) foundationdb;
  };

  fountains = callPackage ../development/python-modules/fountains { };

  foxdot = callPackage ../development/python-modules/foxdot { };

  fpdf = callPackage ../development/python-modules/fpdf { };

  fpdf2 = callPackage ../development/python-modules/fpdf2 { };

  fpylll = callPackage ../development/python-modules/fpylll { };

  fpyutils = callPackage ../development/python-modules/fpyutils { };

  fqdn = callPackage ../development/python-modules/fqdn { };

  free-proxy = callPackage ../development/python-modules/free-proxy { };

  freebox-api = callPackage ../development/python-modules/freebox-api { };

  freenub = callPackage ../development/python-modules/freenub { };

  freertos-gdb = callPackage ../development/python-modules/freertos-gdb { };

  freesasa = callPackage ../development/python-modules/freesasa { inherit (pkgs) freesasa; };

  freesms = callPackage ../development/python-modules/freesms { };

  freetype-py = callPackage ../development/python-modules/freetype-py { };

  freezegun = callPackage ../development/python-modules/freezegun { };

  frelatage = callPackage ../development/python-modules/frelatage { };

  freud = callPackage ../development/python-modules/freud { };

  frictionless = callPackage ../development/python-modules/frictionless { };

  frida-python = callPackage ../development/python-modules/frida-python { };

  frigidaire = callPackage ../development/python-modules/frigidaire { };

  frilouz = callPackage ../development/python-modules/frilouz { };

  fritzconnection = callPackage ../development/python-modules/fritzconnection { };

  froide = toPythonModule (pkgs.froide.override { python3Packages = self; });

  frozendict = callPackage ../development/python-modules/frozendict { };

  frozenlist = callPackage ../development/python-modules/frozenlist { };

  frozenlist2 = callPackage ../development/python-modules/frozenlist2 { };

  fs = callPackage ../development/python-modules/fs { };

  fs-s3fs = callPackage ../development/python-modules/fs-s3fs { };

  fschat = callPackage ../development/python-modules/fschat { };

  fslpy = callPackage ../development/python-modules/fslpy { };

  fsspec = callPackage ../development/python-modules/fsspec { };

  fsspec-xrootd = callPackage ../development/python-modules/fsspec-xrootd { };

  fst-pso = callPackage ../development/python-modules/fst-pso { };

  ftfy = callPackage ../development/python-modules/ftfy { };

  ftputil = callPackage ../development/python-modules/ftputil { };

  fugashi = callPackage ../development/python-modules/fugashi { };

  fullmoon = callPackage ../development/python-modules/fullmoon { };

  func-timeout = callPackage ../development/python-modules/func-timeout { };

  funcparserlib = callPackage ../development/python-modules/funcparserlib { };

  funcsigs = callPackage ../development/python-modules/funcsigs { };

  functions-framework = callPackage ../development/python-modules/functions-framework { };

  functiontrace = callPackage ../development/python-modules/functiontrace { };

  funcy = callPackage ../development/python-modules/funcy { };

  funk = callPackage ../development/python-modules/funk { };

  funsor = callPackage ../development/python-modules/funsor { };

  furl = callPackage ../development/python-modules/furl { };

  furo = callPackage ../development/python-modules/furo { };

  fuse = callPackage ../development/python-modules/fuse-python { inherit (pkgs) fuse; };

  fusepy = callPackage ../development/python-modules/fusepy { };

  future = callPackage ../development/python-modules/future { };

  future-fstrings = callPackage ../development/python-modules/future-fstrings { };

  future-typing = callPackage ../development/python-modules/future-typing { };

  fuzzyfinder = callPackage ../development/python-modules/fuzzyfinder { };

  fuzzytm = callPackage ../development/python-modules/fuzzytm { };

  fuzzywuzzy = callPackage ../development/python-modules/fuzzywuzzy { };

  fvcore = callPackage ../development/python-modules/fvcore { };

  fvs = callPackage ../development/python-modules/fvs { };

  fx2 = callPackage ../development/python-modules/fx2 { };

  fxrays = callPackage ../development/python-modules/fxrays { };

  fyta-cli = callPackage ../development/python-modules/fyta-cli { };

  g2pkk = callPackage ../development/python-modules/g2pkk { };

  galario = toPythonModule (
    pkgs.galario.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  galois = callPackage ../development/python-modules/galois { };

  gamble = callPackage ../development/python-modules/gamble { };

  gaphas = callPackage ../development/python-modules/gaphas { };

  gardena-bluetooth = callPackage ../development/python-modules/gardena-bluetooth { };

  garminconnect = callPackage ../development/python-modules/garminconnect { };

  garminconnect-aio = callPackage ../development/python-modules/garminconnect-aio { };

  garth = callPackage ../development/python-modules/garth { };

  gassist-text = callPackage ../development/python-modules/gassist-text { };

  gast = callPackage ../development/python-modules/gast { };

  gatt = callPackage ../development/python-modules/gatt { };

  gattlib = callPackage ../development/python-modules/gattlib {
    inherit (pkgs) bluez glib pkg-config;
  };

  gawd = callPackage ../development/python-modules/gawd { };

  gb-io = callPackage ../development/python-modules/gb-io { };

  gbinder-python = callPackage ../development/python-modules/gbinder-python { };

  gcal-sync = callPackage ../development/python-modules/gcal-sync { };

  gcodepy = callPackage ../development/python-modules/gcodepy { };

  gcp-storage-emulator = callPackage ../development/python-modules/gcp-storage-emulator { };

  gcsa = callPackage ../development/python-modules/gcsa { };

  gcsfs = callPackage ../development/python-modules/gcsfs { };

  gdal = toPythonModule (pkgs.gdal.override { python3 = python; });

  gdata = callPackage ../development/python-modules/gdata { };

  gdb-pt-dump = callPackage ../development/python-modules/gdb-pt-dump { };

  gdcm = toPythonModule (
    pkgs.gdcm.override {
      inherit (self) python;
      enablePython = true;
    }
  );

  gdown = callPackage ../development/python-modules/gdown { };

  gdsfactory = callPackage ../development/python-modules/gdsfactory { };

  ge25519 = callPackage ../development/python-modules/ge25519 { };

  geant4 = toPythonModule (
    pkgs.geant4.override {
      enablePython = true;
      python3 = python;
    }
  );

  gehomesdk = callPackage ../development/python-modules/gehomesdk { };

  gekitchen = callPackage ../development/python-modules/gekitchen { };

  gekko = callPackage ../development/python-modules/gekko { };

  gemfileparser = callPackage ../development/python-modules/gemfileparser { };

  gemfileparser2 = callPackage ../development/python-modules/gemfileparser2 { };

  gemmi = toPythonModule (
    pkgs.gemmi.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  genanki = callPackage ../development/python-modules/genanki { };

  generic = callPackage ../development/python-modules/generic { };

  genie-partner-sdk = callPackage ../development/python-modules/genie-partner-sdk { };

  geniushub-client = callPackage ../development/python-modules/geniushub-client { };

  genome-collector = callPackage ../development/python-modules/genome-collector { };

  genpy = callPackage ../development/python-modules/genpy { };

  genshi = callPackage ../development/python-modules/genshi { };

  gensim = callPackage ../development/python-modules/gensim { };

  genson = callPackage ../development/python-modules/genson { };

  gentools = callPackage ../development/python-modules/gentools { };

  genzshcomp = callPackage ../development/python-modules/genzshcomp { };

  geoalchemy2 = callPackage ../development/python-modules/geoalchemy2 { };

  geoarrow-c = callPackage ../development/python-modules/geoarrow-c { };

  geoarrow-pandas = callPackage ../development/python-modules/geoarrow-pandas { };

  geoarrow-pyarrow = callPackage ../development/python-modules/geoarrow-pyarrow { };

  geoarrow-types = callPackage ../development/python-modules/geoarrow-types { };

  geocachingapi = callPackage ../development/python-modules/geocachingapi { };

  geocoder = callPackage ../development/python-modules/geocoder { };

  geodatasets = callPackage ../development/python-modules/geodatasets { };

  geographiclib = callPackage ../development/python-modules/geographiclib { };

  geoip = callPackage ../development/python-modules/geoip { libgeoip = pkgs.geoip; };

  geoip2 = callPackage ../development/python-modules/geoip2 { };

  geojson = callPackage ../development/python-modules/geojson { };

  geojson-client = callPackage ../development/python-modules/geojson-client { };

  geomet = callPackage ../development/python-modules/geomet { };

  geometric = callPackage ../development/python-modules/geometric { };

  geopandas = callPackage ../development/python-modules/geopandas { };

  geoparquet = callPackage ../development/python-modules/geoparquet { };

  geopy = callPackage ../development/python-modules/geopy { };

  georss-client = callPackage ../development/python-modules/georss-client { };

  georss-generic-client = callPackage ../development/python-modules/georss-generic-client { };

  georss-ign-sismologia-client =
    callPackage ../development/python-modules/georss-ign-sismologia-client
      { };

  georss-ingv-centro-nazionale-terremoti-client =
    callPackage ../development/python-modules/georss-ingv-centro-nazionale-terremoti-client
      { };

  georss-nrcan-earthquakes-client =
    callPackage ../development/python-modules/georss-nrcan-earthquakes-client
      { };

  georss-qld-bushfire-alert-client =
    callPackage ../development/python-modules/georss-qld-bushfire-alert-client
      { };

  georss-tfs-incidents-client =
    callPackage ../development/python-modules/georss-tfs-incidents-client
      { };

  georss-wa-dfes-client = callPackage ../development/python-modules/georss-wa-dfes-client { };

  geotorch = callPackage ../development/python-modules/geotorch { };

  gepetto-gui = toPythonModule (gepetto-viewer.withPlugins [ gepetto-viewer-corba ]);

  gepetto-viewer = toPythonModule (pkgs.gepetto-viewer.override { python3Packages = self; });

  gepetto-viewer-corba = toPythonModule (
    pkgs.gepetto-viewer-corba.override { python3Packages = self; }
  );

  gerbonara = callPackage ../development/python-modules/gerbonara { };

  get-video-properties = callPackage ../development/python-modules/get-video-properties { };

  getjump = callPackage ../development/python-modules/getjump { };

  getkey = callPackage ../development/python-modules/getkey { };

  getmac = callPackage ../development/python-modules/getmac { };

  gevent = callPackage ../development/python-modules/gevent { };

  gevent-eventemitter = callPackage ../development/python-modules/gevent-eventemitter { };

  gevent-socketio = callPackage ../development/python-modules/gevent-socketio { };

  gevent-websocket = callPackage ../development/python-modules/gevent-websocket { };

  geventhttpclient = callPackage ../development/python-modules/geventhttpclient { };

  gfal2-python = callPackage ../development/python-modules/gfal2-python { };

  gfal2-util = callPackage ../development/python-modules/gfal2-util { inherit (pkgs) xrootd; };

  gflags = callPackage ../development/python-modules/gflags { };

  gflanguages = callPackage ../development/python-modules/gflanguages { };

  gfsubsets = callPackage ../development/python-modules/gfsubsets { };

  gftools = callPackage ../development/python-modules/gftools { };

  gguf = callPackage ../development/python-modules/gguf { };

  ghapi = callPackage ../development/python-modules/ghapi { };

  ghdiff = callPackage ../development/python-modules/ghdiff { };

  ghidra-bridge = callPackage ../development/python-modules/ghidra-bridge { };

  ghome-foyer-api = callPackage ../development/python-modules/ghome-foyer-api { };

  ghostscript = callPackage ../development/python-modules/ghostscript { };

  ghp-import = callPackage ../development/python-modules/ghp-import { };

  ghrepo-stats = callPackage ../development/python-modules/ghrepo-stats { };

  gibberish-detector = callPackage ../development/python-modules/gibberish-detector { };

  gidgethub = callPackage ../development/python-modules/gidgethub { };

  gilknocker = callPackage ../development/python-modules/gilknocker { };

  gin-config = callPackage ../development/python-modules/gin-config { };

  gios = callPackage ../development/python-modules/gios { };

  gipc = callPackage ../development/python-modules/gipc { };

  gistyc = callPackage ../development/python-modules/gistyc { };

  git-annex-adapter = callPackage ../development/python-modules/git-annex-adapter { };

  git-dummy = callPackage ../development/python-modules/git-dummy { };

  git-filter-repo = callPackage ../development/python-modules/git-filter-repo { };

  git-find-repos = callPackage ../development/python-modules/git-find-repos { };

  git-revise = callPackage ../development/python-modules/git-revise { };

  git-sweep = callPackage ../development/python-modules/git-sweep { };

  git-url-parse = callPackage ../development/python-modules/git-url-parse { };

  git-versioner = callPackage ../development/python-modules/git-versioner { };

  gitdb = callPackage ../development/python-modules/gitdb { };

  github-to-sqlite = callPackage ../development/python-modules/github-to-sqlite { };

  github-webhook = callPackage ../development/python-modules/github-webhook { };

  github3-py = callPackage ../development/python-modules/github3-py { };

  githubkit = callPackage ../development/python-modules/githubkit { };

  gitignore-parser = callPackage ../development/python-modules/gitignore-parser { };

  gitingest = callPackage ../development/python-modules/gitingest { };

  gitlike-commands = callPackage ../development/python-modules/gitlike-commands { };

  gitpython = callPackage ../development/python-modules/gitpython { };

  gitterpy = callPackage ../development/python-modules/gitterpy { };

  giturlparse = callPackage ../development/python-modules/giturlparse { };

  glad = callPackage ../development/python-modules/glad { };

  glad2 = callPackage ../development/python-modules/glad2 { };

  glances-api = callPackage ../development/python-modules/glances-api { };

  glcontext = callPackage ../development/python-modules/glcontext { };

  glean-parser = callPackage ../development/python-modules/glean-parser { };

  glean-sdk = callPackage ../development/python-modules/glean-sdk { };

  glfw = callPackage ../development/python-modules/glfw { };

  gliner = callPackage ../development/python-modules/gliner { };

  glob2 = callPackage ../development/python-modules/glob2 { };

  globus-sdk = callPackage ../development/python-modules/globus-sdk { };

  glocaltokens = callPackage ../development/python-modules/glocaltokens { };

  glom = callPackage ../development/python-modules/glom { };

  glueviz = callPackage ../development/python-modules/glueviz { };

  gluonts = callPackage ../development/python-modules/gluonts { };

  glymur = callPackage ../development/python-modules/glymur { };

  glyphsets = callPackage ../development/python-modules/glyphsets { };

  glyphslib = callPackage ../development/python-modules/glyphslib { };

  glyphtools = callPackage ../development/python-modules/glyphtools { };

  gmpy = callPackage ../development/python-modules/gmpy { };

  gmpy2 = callPackage ../development/python-modules/gmpy2 { };

  gmqtt = callPackage ../development/python-modules/gmqtt { };

  gmsh = toPythonModule (
    pkgs.gmsh.override {
      python3Packages = self;
      enablePython = true;
    }
  );

  gntp = callPackage ../development/python-modules/gntp { };

  gnucash = toPythonModule (
    pkgs.gnucash.override {
      python3 = python;
    }
  );

  gnureadline = callPackage ../development/python-modules/gnureadline { };

  go2rtc-client = callPackage ../development/python-modules/go2rtc-client { };

  goalzero = callPackage ../development/python-modules/goalzero { };

  gocardless-pro = callPackage ../development/python-modules/gocardless-pro { };

  goocalendar = callPackage ../development/python-modules/goocalendar { };

  goodwe = callPackage ../development/python-modules/goodwe { };

  google = callPackage ../development/python-modules/google { };

  google-ai-generativelanguage =
    callPackage ../development/python-modules/google-ai-generativelanguage
      { };

  google-api-core = callPackage ../development/python-modules/google-api-core { };

  google-api-python-client = callPackage ../development/python-modules/google-api-python-client { };

  google-auth = callPackage ../development/python-modules/google-auth { };

  google-auth-httplib2 = callPackage ../development/python-modules/google-auth-httplib2 { };

  google-auth-oauthlib = callPackage ../development/python-modules/google-auth-oauthlib { };

  google-cloud-access-context-manager =
    callPackage ../development/python-modules/google-cloud-access-context-manager
      { };

  google-cloud-appengine-logging =
    callPackage ../development/python-modules/google-cloud-appengine-logging
      { };

  google-cloud-artifact-registry =
    callPackage ../development/python-modules/google-cloud-artifact-registry
      { };

  google-cloud-asset = callPackage ../development/python-modules/google-cloud-asset { };

  google-cloud-audit-log = callPackage ../development/python-modules/google-cloud-audit-log { };

  google-cloud-automl = callPackage ../development/python-modules/google-cloud-automl { };

  google-cloud-bigquery = callPackage ../development/python-modules/google-cloud-bigquery { };

  google-cloud-bigquery-datatransfer =
    callPackage ../development/python-modules/google-cloud-bigquery-datatransfer
      { };

  google-cloud-bigquery-logging =
    callPackage ../development/python-modules/google-cloud-bigquery-logging
      { };

  google-cloud-bigquery-storage =
    callPackage ../development/python-modules/google-cloud-bigquery-storage
      { };

  google-cloud-bigtable = callPackage ../development/python-modules/google-cloud-bigtable { };

  google-cloud-compute = callPackage ../development/python-modules/google-cloud-compute { };

  google-cloud-container = callPackage ../development/python-modules/google-cloud-container { };

  google-cloud-core = callPackage ../development/python-modules/google-cloud-core { };

  google-cloud-datacatalog = callPackage ../development/python-modules/google-cloud-datacatalog { };

  google-cloud-dataproc = callPackage ../development/python-modules/google-cloud-dataproc { };

  google-cloud-datastore = callPackage ../development/python-modules/google-cloud-datastore { };

  google-cloud-dlp = callPackage ../development/python-modules/google-cloud-dlp { };

  google-cloud-dns = callPackage ../development/python-modules/google-cloud-dns { };

  google-cloud-error-reporting =
    callPackage ../development/python-modules/google-cloud-error-reporting
      { };

  google-cloud-firestore = callPackage ../development/python-modules/google-cloud-firestore { };

  google-cloud-iam = callPackage ../development/python-modules/google-cloud-iam { };

  google-cloud-iam-logging = callPackage ../development/python-modules/google-cloud-iam-logging { };

  google-cloud-iot = callPackage ../development/python-modules/google-cloud-iot { };

  google-cloud-kms = callPackage ../development/python-modules/google-cloud-kms { };

  google-cloud-language = callPackage ../development/python-modules/google-cloud-language { };

  google-cloud-logging = callPackage ../development/python-modules/google-cloud-logging { };

  google-cloud-monitoring = callPackage ../development/python-modules/google-cloud-monitoring { };

  google-cloud-netapp = callPackage ../development/python-modules/google-cloud-netapp { };

  google-cloud-network-connectivity =
    callPackage ../development/python-modules/google-cloud-network-connectivity
      { };

  google-cloud-org-policy = callPackage ../development/python-modules/google-cloud-org-policy { };

  google-cloud-os-config = callPackage ../development/python-modules/google-cloud-os-config { };

  google-cloud-pubsub = callPackage ../development/python-modules/google-cloud-pubsub { };

  google-cloud-redis = callPackage ../development/python-modules/google-cloud-redis { };

  google-cloud-resource-manager =
    callPackage ../development/python-modules/google-cloud-resource-manager
      { };

  google-cloud-runtimeconfig =
    callPackage ../development/python-modules/google-cloud-runtimeconfig
      { };

  google-cloud-secret-manager =
    callPackage ../development/python-modules/google-cloud-secret-manager
      { };

  google-cloud-securitycenter =
    callPackage ../development/python-modules/google-cloud-securitycenter
      { };

  google-cloud-shell = callPackage ../development/python-modules/google-cloud-shell { };

  google-cloud-spanner = callPackage ../development/python-modules/google-cloud-spanner { };

  google-cloud-speech = callPackage ../development/python-modules/google-cloud-speech { };

  google-cloud-storage = callPackage ../development/python-modules/google-cloud-storage { };

  google-cloud-tasks = callPackage ../development/python-modules/google-cloud-tasks { };

  google-cloud-testutils = callPackage ../development/python-modules/google-cloud-testutils { };

  google-cloud-texttospeech = callPackage ../development/python-modules/google-cloud-texttospeech { };

  google-cloud-trace = callPackage ../development/python-modules/google-cloud-trace { };

  google-cloud-translate = callPackage ../development/python-modules/google-cloud-translate { };

  google-cloud-videointelligence =
    callPackage ../development/python-modules/google-cloud-videointelligence
      { };

  google-cloud-vision = callPackage ../development/python-modules/google-cloud-vision { };

  google-cloud-vpc-access = callPackage ../development/python-modules/google-cloud-vpc-access { };

  google-cloud-webrisk = callPackage ../development/python-modules/google-cloud-webrisk { };

  google-cloud-websecurityscanner =
    callPackage ../development/python-modules/google-cloud-websecurityscanner
      { };

  google-cloud-workflows = callPackage ../development/python-modules/google-cloud-workflows { };

  google-cloud-workstations = callPackage ../development/python-modules/google-cloud-workstations { };

  google-compute-engine = callPackage ../tools/virtualization/google-compute-engine { };

  google-crc32c = callPackage ../development/python-modules/google-crc32c { inherit (pkgs) crc32c; };

  google-genai = callPackage ../development/python-modules/google-genai { };

  google-generativeai = callPackage ../development/python-modules/google-generativeai { };

  google-geo-type = callPackage ../development/python-modules/google-geo-type { };

  google-i18n-address = callPackage ../development/python-modules/google-i18n-address { };

  google-maps-routing = callPackage ../development/python-modules/google-maps-routing { };

  google-nest-sdm = callPackage ../development/python-modules/google-nest-sdm { };

  google-pasta = callPackage ../development/python-modules/google-pasta { };

  google-photos-library-api = callPackage ../development/python-modules/google-photos-library-api { };

  google-re2 = callPackage ../development/python-modules/google-re2 { };

  google-resumable-media = callPackage ../development/python-modules/google-resumable-media { };

  google-search-results = callPackage ../development/python-modules/google-search-results { };

  googleapis-common-protos = callPackage ../development/python-modules/googleapis-common-protos { };

  googlemaps = callPackage ../development/python-modules/googlemaps { };

  googletrans = callPackage ../development/python-modules/googletrans { };

  gophish = callPackage ../development/python-modules/gophish { };

  gorilla = callPackage ../development/python-modules/gorilla { };

  goslide-api = callPackage ../development/python-modules/goslide-api { };

  gotailwind = callPackage ../development/python-modules/gotailwind { };

  gotenberg-client = callPackage ../development/python-modules/gotenberg-client { };

  gotify = callPackage ../development/python-modules/gotify { };

  gotrue = callPackage ../development/python-modules/gotrue { };

  govee-ble = callPackage ../development/python-modules/govee-ble { };

  govee-led-wez = callPackage ../development/python-modules/govee-led-wez { };

  govee-local-api = callPackage ../development/python-modules/govee-local-api { };

  goveelights = callPackage ../development/python-modules/goveelights { };

  gower = callPackage ../development/python-modules/gower { };

  gpaw = callPackage ../development/python-modules/gpaw { };

  gpgme = callPackage ../development/python-modules/gpgme { inherit (pkgs) gpgme; };

  gphoto2 = callPackage ../development/python-modules/gphoto2 { };

  gpib-ctypes = callPackage ../development/python-modules/gpib-ctypes { };

  gpiozero = callPackage ../development/python-modules/gpiozero { };

  gprof2dot = callPackage ../development/python-modules/gprof2dot { inherit (pkgs) graphviz; };

  gps3 = callPackage ../development/python-modules/gps3 { };

  gpsoauth = callPackage ../development/python-modules/gpsoauth { };

  gpt-2-simple = callPackage ../development/python-modules/gpt-2-simple { };

  gptcache = callPackage ../development/python-modules/gptcache { };

  gpu-rir = callPackage ../development/python-modules/gpu-rir { };

  gpuctypes = callPackage ../development/python-modules/gpuctypes { };

  gpustat = callPackage ../development/python-modules/gpustat { };

  gpxpy = callPackage ../development/python-modules/gpxpy { };

  gpytorch = callPackage ../development/python-modules/gpytorch { };

  gql = callPackage ../development/python-modules/gql { };

  grad-cam = callPackage ../development/python-modules/grad-cam { };

  gradient = callPackage ../development/python-modules/gradient { };

  gradient-statsd = callPackage ../development/python-modules/gradient-statsd { };

  gradient-utils = callPackage ../development/python-modules/gradient-utils { };

  gradio = callPackage ../development/python-modules/gradio { };

  gradio-client = callPackage ../development/python-modules/gradio/client.nix { };

  gradio-pdf = callPackage ../development/python-modules/gradio-pdf { };

  grafanalib = callPackage ../development/python-modules/grafanalib/default.nix { };

  grammalecte = callPackage ../development/python-modules/grammalecte { };

  grandalf = callPackage ../development/python-modules/grandalf { };

  granian = callPackage ../development/python-modules/granian { };

  graph-tool = callPackage ../development/python-modules/graph-tool { inherit (pkgs) cgal; };

  grapheme = callPackage ../development/python-modules/grapheme { };

  graphene = callPackage ../development/python-modules/graphene { };

  graphene-django = callPackage ../development/python-modules/graphene-django { };

  graphite-web = callPackage ../development/python-modules/graphite-web { };

  graphlib-backport = callPackage ../development/python-modules/graphlib-backport { };

  graphql-core = callPackage ../development/python-modules/graphql-core { };

  graphql-relay = callPackage ../development/python-modules/graphql-relay { };

  graphql-server-core = callPackage ../development/python-modules/graphql-server-core { };

  graphql-subscription-manager =
    callPackage ../development/python-modules/graphql-subscription-manager
      { };

  graphqlclient = callPackage ../development/python-modules/graphqlclient { };

  graphrag = callPackage ../development/python-modules/graphrag { };

  graphtage = callPackage ../development/python-modules/graphtage { };

  graphviz = callPackage ../development/python-modules/graphviz { };

  grappelli-safe = callPackage ../development/python-modules/grappelli-safe { };

  graspologic = callPackage ../development/python-modules/graspologic { };

  graspologic-native = callPackage ../development/python-modules/graspologic-native { };

  great-expectations = callPackage ../development/python-modules/great-expectations { };

  great-tables = callPackage ../development/python-modules/great-tables { };

  greatfet = callPackage ../development/python-modules/greatfet { };

  greeclimate = callPackage ../development/python-modules/greeclimate { };

  greek-accentuation = callPackage ../development/python-modules/greek-accentuation { };

  green = callPackage ../development/python-modules/green { };

  greeneye-monitor = callPackage ../development/python-modules/greeneye-monitor { };

  # built-in for pypi
  greenlet = if isPyPy then null else callPackage ../development/python-modules/greenlet { };

  greenwavereality = callPackage ../development/python-modules/greenwavereality { };

  gremlinpython = callPackage ../development/python-modules/gremlinpython { };

  grep-ast = callPackage ../development/python-modules/grep-ast { };

  grequests = callPackage ../development/python-modules/grequests { };

  greynoise = callPackage ../development/python-modules/greynoise { };

  gridnet = callPackage ../development/python-modules/gridnet { };

  griffe = callPackage ../development/python-modules/griffe { };

  grip = callPackage ../development/python-modules/grip { };

  groestlcoin-hash = callPackage ../development/python-modules/groestlcoin-hash { };

  groovy = callPackage ../development/python-modules/groovy { };

  groq = callPackage ../development/python-modules/groq { };

  growattserver = callPackage ../development/python-modules/growattserver { };

  grpc-google-iam-v1 = callPackage ../development/python-modules/grpc-google-iam-v1 { };

  grpc-interceptor = callPackage ../development/python-modules/grpc-interceptor { };

  grpcio = callPackage ../development/python-modules/grpcio { };

  grpcio-channelz = callPackage ../development/python-modules/grpcio-channelz { };

  grpcio-gcp = callPackage ../development/python-modules/grpcio-gcp { };

  grpcio-health-checking = callPackage ../development/python-modules/grpcio-health-checking { };

  grpcio-reflection = callPackage ../development/python-modules/grpcio-reflection { };

  grpcio-status = callPackage ../development/python-modules/grpcio-status { };

  grpcio-testing = callPackage ../development/python-modules/grpcio-testing { };

  grpcio-tools = callPackage ../development/python-modules/grpcio-tools { };

  grpclib = callPackage ../development/python-modules/grpclib { };

  gruut = callPackage ../development/python-modules/gruut { };

  gruut-ipa = callPackage ../development/python-modules/gruut-ipa { inherit (pkgs) espeak; };

  gsd = callPackage ../development/python-modules/gsd { };

  gsm0338 = callPackage ../development/python-modules/gsm0338 { };

  gspread = callPackage ../development/python-modules/gspread { };

  gssapi = callPackage ../development/python-modules/gssapi {
    krb5-c = pkgs.krb5;
  };

  gst-python = callPackage ../development/python-modules/gst-python {
    # inherit (pkgs) meson won't work because it won't be spliced
    inherit (pkgs.buildPackages) meson;
  };

  gstools = callPackage ../development/python-modules/gstools { };

  gstools-cython = callPackage ../development/python-modules/gstools-cython { };

  gtfs-realtime-bindings = callPackage ../development/python-modules/gtfs-realtime-bindings { };

  gto = callPackage ../development/python-modules/gto { };

  gtts = callPackage ../development/python-modules/gtts { };

  gtts-token = callPackage ../development/python-modules/gtts-token { };

  gudhi = callPackage ../development/python-modules/gudhi { inherit (pkgs) cgal; };

  guessit = callPackage ../development/python-modules/guessit { };

  guestfs = toPythonModule (
    pkgs.libguestfs.override {
      python3 = python;
    }
  );

  guidance = callPackage ../development/python-modules/guidance { };

  guidance-stitch = callPackage ../development/python-modules/guidance-stitch { };

  guidata = callPackage ../development/python-modules/guidata { };

  gumath = callPackage ../development/python-modules/gumath { };

  gunicorn = callPackage ../development/python-modules/gunicorn { };

  guppy3 = callPackage ../development/python-modules/guppy3 { };

  gurobipy = callPackage ../development/python-modules/gurobipy { };

  guzzle-sphinx-theme = callPackage ../development/python-modules/guzzle-sphinx-theme { };

  gviz-api = callPackage ../development/python-modules/gviz-api { };

  gvm-tools = callPackage ../development/python-modules/gvm-tools { };

  gwcs = callPackage ../development/python-modules/gwcs { };

  gym = callPackage ../development/python-modules/gym { };

  gym-notices = callPackage ../development/python-modules/gym-notices { };

  gymnasium = callPackage ../development/python-modules/gymnasium { };

  gyp = callPackage ../development/python-modules/gyp { };

  h11 = callPackage ../development/python-modules/h11 { };

  h2 = callPackage ../development/python-modules/h2 { };

  h3 = callPackage ../development/python-modules/h3 { h3 = pkgs.h3_4; };

  h5io = callPackage ../development/python-modules/h5io { };

  h5netcdf = callPackage ../development/python-modules/h5netcdf { };

  h5py = callPackage ../development/python-modules/h5py { };

  h5py-mpi = self.h5py.override { hdf5 = pkgs.hdf5-mpi; };

  ha-ffmpeg = callPackage ../development/python-modules/ha-ffmpeg { };

  ha-iotawattpy = callPackage ../development/python-modules/ha-iotawattpy { };

  ha-mqtt-discoverable = callPackage ../development/python-modules/ha-mqtt-discoverable { };

  ha-philipsjs = callPackage ../development/python-modules/ha-philipsjs { };

  ha-silabs-firmware-client = callPackage ../development/python-modules/ha-silabs-firmware-client { };

  habanero = callPackage ../development/python-modules/habanero { };

  habiticalib = callPackage ../development/python-modules/habiticalib { };

  habitipy = callPackage ../development/python-modules/habitipy { };

  habluetooth = callPackage ../development/python-modules/habluetooth { };

  hachoir = callPackage ../development/python-modules/hachoir { };

  hacking = callPackage ../development/python-modules/hacking { };

  hakuin = callPackage ../development/python-modules/hakuin { };

  halide =
    toPythonModule
      (pkgs.halide.override {
        pythonSupport = true;
        python3Packages = self;
      }).lib;

  halo = callPackage ../development/python-modules/halo { };

  halohome = callPackage ../development/python-modules/halohome { };

  handout = callPackage ../development/python-modules/handout { };

  handy-archives = callPackage ../development/python-modules/handy-archives { };

  hankel = callPackage ../development/python-modules/hankel { };

  hanzidentifier = callPackage ../development/python-modules/hanzidentifier { };

  hap-python = callPackage ../development/python-modules/hap-python { };

  harlequin-bigquery = callPackage ../development/python-modules/harlequin-bigquery { };

  harlequin-postgres = callPackage ../development/python-modules/harlequin-postgres { };

  hass-client = callPackage ../development/python-modules/hass-client { };

  hass-nabucasa = callPackage ../development/python-modules/hass-nabucasa { };

  hass-splunk = callPackage ../development/python-modules/hass-splunk { };

  hassil = callPackage ../development/python-modules/hassil { };

  hatasmota = callPackage ../development/python-modules/hatasmota { };

  hatch-autorun = callPackage ../development/python-modules/hatch-autorun { };

  hatch-babel = callPackage ../development/python-modules/hatch-babel { };

  hatch-docstring-description =
    callPackage ../development/python-modules/hatch-docstring-description
      { };

  hatch-fancy-pypi-readme = callPackage ../development/python-modules/hatch-fancy-pypi-readme { };

  hatch-jupyter-builder = callPackage ../development/python-modules/hatch-jupyter-builder { };

  hatch-min-requirements = callPackage ../development/python-modules/hatch-min-requirements { };

  hatch-nodejs-version = callPackage ../development/python-modules/hatch-nodejs-version { };

  hatch-odoo = callPackage ../development/python-modules/hatch-odoo { };

  hatch-regex-commit = callPackage ../development/python-modules/hatch-regex-commit { };

  hatch-requirements-txt = callPackage ../development/python-modules/hatch-requirements-txt { };

  hatch-sphinx = callPackage ../development/python-modules/hatch-sphinx { };

  hatch-vcs = callPackage ../development/python-modules/hatch-vcs { };

  hatchling = callPackage ../development/python-modules/hatchling { };

  haversine = callPackage ../development/python-modules/haversine { };

  hawkauthlib = callPackage ../development/python-modules/hawkauthlib { };

  hawkmoth = callPackage ../development/python-modules/hawkmoth { };

  haystack-ai = callPackage ../development/python-modules/haystack-ai { };

  hcloud = callPackage ../development/python-modules/hcloud { };

  hcs-utils = callPackage ../development/python-modules/hcs-utils { };

  hdate = callPackage ../development/python-modules/hdate { };

  hdbscan = callPackage ../development/python-modules/hdbscan { };

  hdf5plugin = callPackage ../development/python-modules/hdf5plugin {
    inherit (pkgs) zstd lz4;
  };

  hdfs = callPackage ../development/python-modules/hdfs { };

  hdmedians = callPackage ../development/python-modules/hdmedians { };

  headerparser = callPackage ../development/python-modules/headerparser { };

  heapdict = callPackage ../development/python-modules/heapdict { };

  heatmiserv3 = callPackage ../development/python-modules/heatmiserv3 { };

  heatshrink2 = callPackage ../development/python-modules/heatshrink2 { };

  heatzypy = callPackage ../development/python-modules/heatzypy { };

  hebg = callPackage ../development/python-modules/hebg { };

  helion = callPackage ../development/python-modules/helion { };

  help2man = callPackage ../development/python-modules/help2man { };

  helpdev = callPackage ../development/python-modules/helpdev { };

  helper = callPackage ../development/python-modules/helper { };

  hepmc3 = toPythonModule (pkgs.hepmc3.override { inherit python; });

  hepunits = callPackage ../development/python-modules/hepunits { };

  here-routing = callPackage ../development/python-modules/here-routing { };

  here-transit = callPackage ../development/python-modules/here-transit { };

  herepy = callPackage ../development/python-modules/herepy { };

  hetzner = callPackage ../development/python-modules/hetzner { };

  heudiconv = callPackage ../development/python-modules/heudiconv { };

  hexbytes = callPackage ../development/python-modules/hexbytes { };

  hexdump = callPackage ../development/python-modules/hexdump { };

  hf-transfer = callPackage ../development/python-modules/hf-transfer { };

  hf-xet = callPackage ../development/python-modules/hf-xet { };

  hfst = callPackage ../development/python-modules/hfst { };

  hg-commitsigs = callPackage ../development/python-modules/hg-commitsigs { };

  hg-evolve = callPackage ../development/python-modules/hg-evolve { };

  hg-git = callPackage ../development/python-modules/hg-git { };

  hickle = callPackage ../development/python-modules/hickle { };

  hid = callPackage ../development/python-modules/hid { inherit (pkgs) hidapi; };

  hid-parser = callPackage ../development/python-modules/hid-parser { };

  hidapi = callPackage ../development/python-modules/hidapi { inherit (pkgs) hidapi udev; };

  hier-config = callPackage ../development/python-modules/hier-config { };

  hieroglyph = callPackage ../development/python-modules/hieroglyph { };

  highctidh = callPackage ../development/python-modules/highctidh { };

  highdicom = callPackage ../development/python-modules/highdicom { };

  highered = callPackage ../development/python-modules/highered { };

  highspy = callPackage ../development/python-modules/highspy { };

  hightime = callPackage ../development/python-modules/hightime { };

  hijridate = callPackage ../development/python-modules/hijridate { };

  hikari = callPackage ../development/python-modules/hikari { };

  hikari-crescent = callPackage ../development/python-modules/hikari-crescent { };

  hikari-lightbulb = callPackage ../development/python-modules/hikari-lightbulb { };

  hikvision = callPackage ../development/python-modules/hikvision { };

  hiredis = callPackage ../development/python-modules/hiredis { };

  hiro = callPackage ../development/python-modules/hiro { };

  hishel = callPackage ../development/python-modules/hishel { };

  hist = callPackage ../development/python-modules/hist { };

  histoprint = callPackage ../development/python-modules/histoprint { };

  hive-metastore-client = callPackage ../development/python-modules/hive-metastore-client { };

  hiyapyco = callPackage ../development/python-modules/hiyapyco { };

  hjson = callPackage ../development/python-modules/hjson { };

  hkavr = callPackage ../development/python-modules/hkavr { };

  hko = callPackage ../development/python-modules/hko { };

  hledger-utils = callPackage ../development/python-modules/hledger-utils { };

  hlk-sw16 = callPackage ../development/python-modules/hlk-sw16 { };

  hmmlearn = callPackage ../development/python-modules/hmmlearn { };

  hnswlib = callPackage ../development/python-modules/hnswlib { inherit (pkgs) hnswlib; };

  hocr-tools = callPackage ../development/python-modules/hocr-tools { };

  hole = callPackage ../development/python-modules/hole { };

  holidays = callPackage ../development/python-modules/holidays { };

  holistic-trace-analysis = callPackage ../development/python-modules/holistic-trace-analysis { };

  hologram = callPackage ../development/python-modules/hologram { };

  holoviews = callPackage ../development/python-modules/holoviews { };

  home-assistant-bluetooth = callPackage ../development/python-modules/home-assistant-bluetooth { };

  home-assistant-chip-clusters =
    callPackage ../development/python-modules/home-assistant-chip-clusters
      { };

  home-assistant-chip-core = callPackage ../development/python-modules/home-assistant-chip-core { };

  home-assistant-chip-wheels = toPythonModule (
    callPackage ../development/python-modules/home-assistant-chip-wheels { }
  );

  home-connect-async = callPackage ../development/python-modules/home-connect-async { };

  homeassistant-stubs = callPackage ../servers/home-assistant/stubs.nix { };

  homeconnect = callPackage ../development/python-modules/homeconnect { };

  homematicip = callPackage ../development/python-modules/homematicip { };

  homepluscontrol = callPackage ../development/python-modules/homepluscontrol { };

  homf = callPackage ../development/python-modules/homf { };

  hoomd-blue = callPackage ../development/python-modules/hoomd-blue { };

  hopcroftkarp = callPackage ../development/python-modules/hopcroftkarp { };

  horimote = callPackage ../development/python-modules/horimote { };

  horizon-eda = callPackage ../development/python-modules/horizon-eda { inherit (pkgs) horizon-eda; };

  housekeeping = callPackage ../development/python-modules/housekeeping { };

  howdoi = callPackage ../development/python-modules/howdoi { };

  hpack = callPackage ../development/python-modules/hpack { };

  hpccm = callPackage ../development/python-modules/hpccm { };

  hs-dbus-signature = callPackage ../development/python-modules/hs-dbus-signature { };

  hsaudiotag3k = callPackage ../development/python-modules/hsaudiotag3k { };

  hsh = callPackage ../development/python-modules/hsh { };

  hsluv = callPackage ../development/python-modules/hsluv { };

  hstspreload = callPackage ../development/python-modules/hstspreload { };

  html-sanitizer = callPackage ../development/python-modules/html-sanitizer { };

  html-table-parser-python3 = callPackage ../development/python-modules/html-table-parser-python3 { };

  html-tag-names = callPackage ../development/python-modules/html-tag-names { };

  html-text = callPackage ../development/python-modules/html-text { };

  html-void-elements = callPackage ../development/python-modules/html-void-elements { };

  html2image = callPackage ../development/python-modules/html2image { };

  html2pdf4doc = callPackage ../development/python-modules/html2pdf4doc { };

  html2text = callPackage ../development/python-modules/html2text { };

  html5-parser = callPackage ../development/python-modules/html5-parser { };

  html5lib = callPackage ../development/python-modules/html5lib { };

  html5tagger = callPackage ../development/python-modules/html5tagger { };

  htmldate = callPackage ../development/python-modules/htmldate { };

  htmlgen = callPackage ../development/python-modules/htmlgen { };

  htmllistparse = callPackage ../development/python-modules/htmllistparse { };

  htmlmin = callPackage ../development/python-modules/htmlmin { };

  htmltools = callPackage ../development/python-modules/htmltools { };

  htseq = callPackage ../development/python-modules/htseq { };

  httmock = callPackage ../development/python-modules/httmock { };

  http-ece = callPackage ../development/python-modules/http-ece { };

  http-message-signatures = callPackage ../development/python-modules/http-message-signatures { };

  http-parser = callPackage ../development/python-modules/http-parser { };

  http-sf = callPackage ../development/python-modules/http-sf { };

  http-sfv = callPackage ../development/python-modules/http-sfv { };

  httpagentparser = callPackage ../development/python-modules/httpagentparser { };

  httpauth = callPackage ../development/python-modules/httpauth { };

  httpbin = callPackage ../development/python-modules/httpbin { };

  httpcore = callPackage ../development/python-modules/httpcore { };

  httpie = callPackage ../development/python-modules/httpie { };

  httpie-ntlm = callPackage ../development/python-modules/httpie-ntlm { };

  httplib2 = callPackage ../development/python-modules/httplib2 { };

  httpretty = callPackage ../development/python-modules/httpretty { };

  httpserver = callPackage ../development/python-modules/httpserver { };

  httpsig = callPackage ../development/python-modules/httpsig { };

  httptools = callPackage ../development/python-modules/httptools { };

  httpx = callPackage ../development/python-modules/httpx { };

  httpx-aiohttp = callPackage ../development/python-modules/httpx-aiohttp { };

  httpx-auth = callPackage ../development/python-modules/httpx-auth { };

  httpx-ntlm = callPackage ../development/python-modules/httpx-ntlm { };

  httpx-oauth = callPackage ../development/python-modules/httpx-oauth { };

  httpx-socks = callPackage ../development/python-modules/httpx-socks { };

  httpx-sse = callPackage ../development/python-modules/httpx-sse { };

  httpx-ws = callPackage ../development/python-modules/httpx-ws { };

  huawei-lte-api = callPackage ../development/python-modules/huawei-lte-api { };

  huepy = callPackage ../development/python-modules/huepy { };

  huey = callPackage ../development/python-modules/huey { };

  huggingface-hub = callPackage ../development/python-modules/huggingface-hub { };

  human-readable = callPackage ../development/python-modules/human-readable { };

  humanfriendly = callPackage ../development/python-modules/humanfriendly { };

  humanize = callPackage ../development/python-modules/humanize { };

  humblewx = callPackage ../development/python-modules/humblewx { };

  hupper = callPackage ../development/python-modules/hupper { };

  hurry-filesize = callPackage ../development/python-modules/hurry-filesize { };

  huum = callPackage ../development/python-modules/huum { };

  hvac = callPackage ../development/python-modules/hvac { };

  hvplot = callPackage ../development/python-modules/hvplot { };

  hwdata = callPackage ../development/python-modules/hwdata { };

  hwi = callPackage ../development/python-modules/hwi { };

  hy = callPackage ../development/python-modules/hy { };

  hydra-core = callPackage ../development/python-modules/hydra-core { };

  hydra-joblib-launcher = callPackage ../development/python-modules/hydra-joblib-launcher { };

  hydrawiser = callPackage ../development/python-modules/hydrawiser { };

  hydrogram = callPackage ../development/python-modules/hydrogram { };

  hydrus-api = callPackage ../development/python-modules/hydrus-api { };

  hypchat = callPackage ../development/python-modules/hypchat { };

  hyper-connections = callPackage ../development/python-modules/hyper-connections { };

  hypercorn = callPackage ../development/python-modules/hypercorn { };

  hyperframe = callPackage ../development/python-modules/hyperframe { };

  hyperglot = callPackage ../development/python-modules/hyperglot { };

  hyperion-py = callPackage ../development/python-modules/hyperion-py { };

  hyperlink = callPackage ../development/python-modules/hyperlink { };

  hyperopt = callPackage ../development/python-modules/hyperopt { };

  hyperpyyaml = callPackage ../development/python-modules/hyperpyyaml { };

  hyperscan = callPackage ../development/python-modules/hyperscan { };

  hypothesis = callPackage ../development/python-modules/hypothesis { };

  hypothesis-auto = callPackage ../development/python-modules/hypothesis-auto { };

  hypothesmith = callPackage ../development/python-modules/hypothesmith { };

  hyppo = callPackage ../development/python-modules/hyppo { };

  hyrule = callPackage ../development/python-modules/hyrule { };

  i-pi = callPackage ../development/python-modules/i-pi { };

  i2c-tools = callPackage ../development/python-modules/i2c-tools { inherit (pkgs) i2c-tools; };

  i2csense = callPackage ../development/python-modules/i2csense { };

  i3-py = callPackage ../development/python-modules/i3-py { };

  i3ipc = callPackage ../development/python-modules/i3ipc { };

  iamdata = callPackage ../development/python-modules/iamdata { };

  iammeter = callPackage ../development/python-modules/iammeter { };

  iapws = callPackage ../development/python-modules/iapws { };

  iaqualink = callPackage ../development/python-modules/iaqualink { };

  ibeacon-ble = callPackage ../development/python-modules/ibeacon-ble { };

  ibis = callPackage ../development/python-modules/ibis { };

  ibis-framework = callPackage ../development/python-modules/ibis-framework { };

  ibm-cloud-sdk-core = callPackage ../development/python-modules/ibm-cloud-sdk-core { };

  ibm-watson = callPackage ../development/python-modules/ibm-watson { };

  ibmiotf = callPackage ../development/python-modules/ibmiotf { };

  ical = callPackage ../development/python-modules/ical { };

  icalendar = callPackage ../development/python-modules/icalendar { };

  icalendar-compatibility = callPackage ../development/python-modules/icalendar-compatibility { };

  icalevents = callPackage ../development/python-modules/icalevents { };

  icdiff = callPackage ../development/python-modules/icdiff { };

  icecream = callPackage ../development/python-modules/icecream { };

  iceportal = callPackage ../development/python-modules/iceportal { };

  icmplib = callPackage ../development/python-modules/icmplib { };

  icnsutil = callPackage ../development/python-modules/icnsutil { };

  icoextract = toPythonModule (pkgs.icoextract.override { python3Packages = self; });

  icontract = callPackage ../development/python-modules/icontract { };

  ics = callPackage ../development/python-modules/ics { };

  id = callPackage ../development/python-modules/id { };

  idasen = callPackage ../development/python-modules/idasen { };

  idasen-ha = callPackage ../development/python-modules/idasen-ha { };

  idbutils = callPackage ../development/python-modules/idbutils { };

  identify = callPackage ../development/python-modules/identify { };

  idna = callPackage ../development/python-modules/idna { };

  idna-ssl = callPackage ../development/python-modules/idna-ssl { };

  idstools = callPackage ../development/python-modules/idstools { };

  ifaddr = callPackage ../development/python-modules/ifaddr { };

  ifconfig-parser = callPackage ../development/python-modules/ifconfig-parser { };

  ifcopenshell = callPackage ../development/python-modules/ifcopenshell {
    inherit (pkgs) cgal_5 libxml2;
  };

  iglo = callPackage ../development/python-modules/iglo { };

  igloohome-api = callPackage ../development/python-modules/igloohome-api { };

  ignite = callPackage ../development/python-modules/ignite { };

  igraph = callPackage ../development/python-modules/igraph { inherit (pkgs) igraph; };

  ihcsdk = callPackage ../development/python-modules/ihcsdk { };

  ihm = callPackage ../development/python-modules/ihm { };

  iisignature = callPackage ../development/python-modules/iisignature { };

  ijson = callPackage ../development/python-modules/ijson { };

  ilcli = callPackage ../development/python-modules/ilcli { };

  ilua = callPackage ../development/python-modules/ilua { };

  image = callPackage ../development/python-modules/image { };

  image-diff = callPackage ../development/python-modules/image-diff { };

  image-go-nord = callPackage ../development/python-modules/image-go-nord { };

  imagecodecs = callPackage ../development/python-modules/imagecodecs { };

  imagecodecs-lite = callPackage ../development/python-modules/imagecodecs-lite { };

  imagecorruptions = callPackage ../development/python-modules/imagecorruptions { };

  imagededup = callPackage ../development/python-modules/imagededup { };

  imagehash = callPackage ../development/python-modules/imagehash { };

  imageio = callPackage ../development/python-modules/imageio { };

  imageio-ffmpeg = callPackage ../development/python-modules/imageio-ffmpeg { };

  imagesize = callPackage ../development/python-modules/imagesize { };

  imantics = callPackage ../development/python-modules/imantics { };

  imap-tools = callPackage ../development/python-modules/imap-tools { };

  imapclient = callPackage ../development/python-modules/imapclient { };

  imaplib2 = callPackage ../development/python-modules/imaplib2 { };

  imbalanced-learn = callPackage ../development/python-modules/imbalanced-learn { };

  imeon-inverter-api = callPackage ../development/python-modules/imeon-inverter-api { };

  img2pdf = callPackage ../development/python-modules/img2pdf { };

  imgcat = callPackage ../development/python-modules/imgcat { };

  imgdiff = callPackage ../development/python-modules/imgdiff { };

  imgsize = callPackage ../development/python-modules/imgsize { };

  imgw-pib = callPackage ../development/python-modules/imgw-pib { };

  imia = callPackage ../development/python-modules/imia { };

  iminuit = callPackage ../development/python-modules/iminuit { };

  immutabledict = callPackage ../development/python-modules/immutabledict { };

  immutables = callPackage ../development/python-modules/immutables { };

  impacket = callPackage ../development/python-modules/impacket { };

  import-expression = callPackage ../development/python-modules/import-expression { };

  importlab = callPackage ../development/python-modules/importlab { };

  importlib-metadata = callPackage ../development/python-modules/importlib-metadata { };

  importlib-resources = callPackage ../development/python-modules/importlib-resources { };

  importmagic = callPackage ../development/python-modules/importmagic { };

  imread = callPackage ../development/python-modules/imread {
    inherit (pkgs)
      libjpeg
      libpng
      libtiff
      libwebp
      ;
  };

  imutils = callPackage ../development/python-modules/imutils { };

  in-n-out = callPackage ../development/python-modules/in-n-out { };

  in-place = callPackage ../development/python-modules/in-place { };

  in-toto-attestation = callPackage ../development/python-modules/in-toto-attestation { };

  incomfort-client = callPackage ../development/python-modules/incomfort-client { };

  incremental = callPackage ../development/python-modules/incremental { };

  indexed-bzip2 = callPackage ../development/python-modules/indexed-bzip2 { };

  indexed-gzip = callPackage ../development/python-modules/indexed-gzip { inherit (pkgs) zlib; };

  indexed-zstd = callPackage ../development/python-modules/indexed-zstd { inherit (pkgs) zstd; };

  inequality = callPackage ../development/python-modules/inequality { };

  inference-gym = callPackage ../development/python-modules/inference-gym { };

  infinity = callPackage ../development/python-modules/infinity { };

  inflate64 = callPackage ../development/python-modules/inflate64 { };

  inflect = callPackage ../development/python-modules/inflect { };

  inflection = callPackage ../development/python-modules/inflection { };

  influxdb = callPackage ../development/python-modules/influxdb { };

  influxdb-client = callPackage ../development/python-modules/influxdb-client { };

  influxdb3-python = callPackage ../development/python-modules/influxdb3-python { };

  inform = callPackage ../development/python-modules/inform { };

  ingredient-parser-nlp = callPackage ../development/python-modules/ingredient-parser-nlp { };

  iniconfig = callPackage ../development/python-modules/iniconfig { };

  inifile = callPackage ../development/python-modules/inifile { };

  iniparse = callPackage ../development/python-modules/iniparse { };

  inject = callPackage ../development/python-modules/inject { };

  injector = callPackage ../development/python-modules/injector { };

  inkbird-ble = callPackage ../development/python-modules/inkbird-ble { };

  inkex = callPackage ../development/python-modules/inkex { };

  inline-snapshot = callPackage ../development/python-modules/inline-snapshot { };

  inotify = callPackage ../development/python-modules/inotify { };

  inotify-simple = callPackage ../development/python-modules/inotify-simple { };

  inotifyrecursive = callPackage ../development/python-modules/inotifyrecursive { };

  inquirer = callPackage ../development/python-modules/inquirer { };

  inquirer3 = callPackage ../development/python-modules/inquirer3 { };

  inquirerpy = callPackage ../development/python-modules/inquirerpy { };

  inscriptis = callPackage ../development/python-modules/inscriptis { };

  insegel = callPackage ../development/python-modules/insegel { };

  insightface = callPackage ../development/python-modules/insightface { };

  installer = callPackage ../development/python-modules/installer { };

  insteon-frontend-home-assistant =
    callPackage ../development/python-modules/insteon-frontend-home-assistant
      { };

  instructor = callPackage ../development/python-modules/instructor { };

  intake = callPackage ../development/python-modules/intake { };

  intake-parquet = callPackage ../development/python-modules/intake-parquet { };

  intbitset = callPackage ../development/python-modules/intbitset { };

  intelhex = callPackage ../development/python-modules/intelhex { };

  intellifire4py = callPackage ../development/python-modules/intellifire4py { };

  intensity-normalization = callPackage ../development/python-modules/intensity-normalization { };

  interegular = callPackage ../development/python-modules/interegular { };

  interface-meta = callPackage ../development/python-modules/interface-meta { };

  internetarchive = callPackage ../development/python-modules/internetarchive { };

  interruptingcow = callPackage ../development/python-modules/interruptingcow { };

  intervals = callPackage ../development/python-modules/intervals { };

  intervaltree = callPackage ../development/python-modules/intervaltree { };

  into-dbus-python = callPackage ../development/python-modules/into-dbus-python { };

  invisible-watermark = callPackage ../development/python-modules/invisible-watermark { };

  invocations = callPackage ../development/python-modules/invocations { };

  invoke = callPackage ../development/python-modules/invoke { };

  inwx-domrobot = callPackage ../development/python-modules/inwx-domrobot { };

  iocapture = callPackage ../development/python-modules/iocapture { };

  iocextract = callPackage ../development/python-modules/iocextract { };

  iocsearcher = callPackage ../development/python-modules/iocsearcher { };

  ioctl-opt = callPackage ../development/python-modules/ioctl-opt { };

  iodata = callPackage ../development/python-modules/iodata { };

  iometer = callPackage ../development/python-modules/iometer { };

  ionoscloud = callPackage ../development/python-modules/ionoscloud { };

  iopath = callPackage ../development/python-modules/iopath { };

  iosbackup = callPackage ../development/python-modules/iosbackup { };

  iottycloud = callPackage ../development/python-modules/iottycloud { };

  iowait = callPackage ../development/python-modules/iowait { };

  ipaddr = callPackage ../development/python-modules/ipaddr { };

  ipadic = callPackage ../development/python-modules/ipadic { };

  ipdb = callPackage ../development/python-modules/ipdb { };

  iperf3 = callPackage ../development/python-modules/iperf3 { };

  ipfshttpclient = callPackage ../development/python-modules/ipfshttpclient { };

  iplotx = callPackage ../development/python-modules/iplotx { };

  ipsw-parser = callPackage ../development/python-modules/ipsw-parser { };

  iptools = callPackage ../development/python-modules/iptools { };

  ipv8-rust-tunnels = callPackage ../development/python-modules/ipv8-rust-tunnels { };

  ipwhl = callPackage ../development/python-modules/ipwhl { };

  ipwhois = callPackage ../development/python-modules/ipwhois { };

  ipy = callPackage ../development/python-modules/ipy { };

  ipycanvas = callPackage ../development/python-modules/ipycanvas { };

  ipydatagrid = callPackage ../development/python-modules/ipydatagrid { };

  ipydatawidgets = callPackage ../development/python-modules/ipydatawidgets { };

  ipykernel = callPackage ../development/python-modules/ipykernel { };

  ipylab = callPackage ../development/python-modules/ipylab { };

  ipymarkup = callPackage ../development/python-modules/ipymarkup { };

  ipympl = callPackage ../development/python-modules/ipympl { };

  ipynbname = callPackage ../development/python-modules/ipynbname { };

  ipyniivue = callPackage ../development/python-modules/ipyniivue { };

  ipyparallel = callPackage ../development/python-modules/ipyparallel { };

  ipytablewidgets = callPackage ../development/python-modules/ipytablewidgets { };

  ipython = callPackage ../development/python-modules/ipython { };

  ipython-genutils = callPackage ../development/python-modules/ipython-genutils { };

  ipython-pygments-lexers = callPackage ../development/python-modules/ipython-pygments-lexers { };

  ipython-sql = callPackage ../development/python-modules/ipython-sql { };

  ipyvue = callPackage ../development/python-modules/ipyvue { };

  ipyvuetify = callPackage ../development/python-modules/ipyvuetify { };

  ipywidgets = callPackage ../development/python-modules/ipywidgets { };

  ipyxact = callPackage ../development/python-modules/ipyxact { };

  irc = callPackage ../development/python-modules/irc { };

  ircrobots = callPackage ../development/python-modules/ircrobots { };

  ircstates = callPackage ../development/python-modules/ircstates { };

  irctokens = callPackage ../development/python-modules/irctokens { };

  irisclient = callPackage ../development/python-modules/irisclient { };

  irm-kmi-api = callPackage ../development/python-modules/irm-kmi-api { };

  isal = callPackage ../development/python-modules/isal { };

  isbnlib = callPackage ../development/python-modules/isbnlib { };

  islpy = callPackage ../development/python-modules/islpy { isl = pkgs.isl_0_27; };

  ismartgate = callPackage ../development/python-modules/ismartgate { };

  iso-639 = callPackage ../development/python-modules/iso-639 { };

  iso3166 = callPackage ../development/python-modules/iso3166 { };

  iso4217 = callPackage ../development/python-modules/iso4217 { };

  iso8601 = callPackage ../development/python-modules/iso8601 { };

  isodate = callPackage ../development/python-modules/isodate { };

  isoduration = callPackage ../development/python-modules/isoduration { };

  isort = callPackage ../development/python-modules/isort { };

  isosurfaces = callPackage ../development/python-modules/isosurfaces { };

  isounidecode = callPackage ../development/python-modules/isounidecode { };

  isoweek = callPackage ../development/python-modules/isoweek { };

  israel-rail-api = callPackage ../development/python-modules/israel-rail-api { };

  itables = callPackage ../development/python-modules/itables { };

  itanium-demangler = callPackage ../development/python-modules/itanium-demangler { };

  item-synchronizer = callPackage ../development/python-modules/item-synchronizer { };

  itemadapter = callPackage ../development/python-modules/itemadapter { };

  itemdb = callPackage ../development/python-modules/itemdb { };

  itemloaders = callPackage ../development/python-modules/itemloaders { };

  iterable-io = callPackage ../development/python-modules/iterable-io { };

  iteration-utilities = callPackage ../development/python-modules/iteration-utilities { };

  iterative-telemetry = callPackage ../development/python-modules/iterative-telemetry { };

  iterfzf = callPackage ../development/python-modules/iterfzf { };

  iterm2 = callPackage ../development/python-modules/iterm2 { };

  itk = toPythonModule (
    pkgs.itk.override {
      inherit python numpy;
      enablePython = true;
      enableRtk = false;
      stdenv =
        if stdenv.cc.isGNU then pkgs.stdenvAdapters.useLibsFrom stdenv pkgs.gcc13Stdenv else stdenv;
    }
  );

  itsdangerous = callPackage ../development/python-modules/itsdangerous { };

  itunespy = callPackage ../development/python-modules/itunespy { };

  itypes = callPackage ../development/python-modules/itypes { };

  iwlib = callPackage ../development/python-modules/iwlib { };

  ixia = callPackage ../development/python-modules/ixia { };

  j2cli = callPackage ../development/python-modules/j2cli { };

  j2lint = callPackage ../development/python-modules/j2lint { };

  jaconv = callPackage ../development/python-modules/jaconv { };

  jalali-core = callPackage ../development/python-modules/jalali-core { };

  jamo = callPackage ../development/python-modules/jamo { };

  janus = callPackage ../development/python-modules/janus { };

  jaraco-abode = callPackage ../development/python-modules/jaraco-abode { };

  jaraco-classes = callPackage ../development/python-modules/jaraco-classes { };

  jaraco-collections = callPackage ../development/python-modules/jaraco-collections { };

  jaraco-context = callPackage ../development/python-modules/jaraco-context { };

  jaraco-email = callPackage ../development/python-modules/jaraco-email { };

  jaraco-envs = callPackage ../development/python-modules/jaraco-envs { };

  jaraco-functools = callPackage ../development/python-modules/jaraco-functools { };

  jaraco-itertools = callPackage ../development/python-modules/jaraco-itertools { };

  jaraco-logging = callPackage ../development/python-modules/jaraco-logging { };

  jaraco-net = callPackage ../development/python-modules/jaraco-net { };

  jaraco-path = callPackage ../development/python-modules/jaraco-path { };

  jaraco-stream = callPackage ../development/python-modules/jaraco-stream { };

  jaraco-test = callPackage ../development/python-modules/jaraco-test { };

  jaraco-text = callPackage ../development/python-modules/jaraco-text { };

  jarowinkler = callPackage ../development/python-modules/jarowinkler { };

  javaobj-py3 = callPackage ../development/python-modules/javaobj-py3 { };

  javaproperties = callPackage ../development/python-modules/javaproperties { };

  jax = callPackage ../development/python-modules/jax { };

  jax-cuda12-pjrt = callPackage ../development/python-modules/jax-cuda12-pjrt { };

  jax-cuda12-plugin = callPackage ../development/python-modules/jax-cuda12-plugin { };

  jax-jumpy = callPackage ../development/python-modules/jax-jumpy { };

  jaxlib = jaxlib-bin;

  jaxlib-bin = callPackage ../development/python-modules/jaxlib/bin.nix { };

  jaxlib-build = callPackage ../development/python-modules/jaxlib {
    snappy-cpp = pkgs.snappy;
  };

  jaxopt = callPackage ../development/python-modules/jaxopt { };

  jaxtyping = callPackage ../development/python-modules/jaxtyping { };

  jaydebeapi = callPackage ../development/python-modules/jaydebeapi { };

  jc = callPackage ../development/python-modules/jc { };

  jdatetime = callPackage ../development/python-modules/jdatetime { };

  jdcal = callPackage ../development/python-modules/jdcal { };

  jedi = callPackage ../development/python-modules/jedi { };

  jedi-language-server = callPackage ../development/python-modules/jedi-language-server { };

  jeepney = callPackage ../development/python-modules/jeepney { };

  jello = callPackage ../development/python-modules/jello { };

  jellyfin-apiclient-python = callPackage ../development/python-modules/jellyfin-apiclient-python { };

  jellyfish = callPackage ../development/python-modules/jellyfish { };

  jenkins-job-builder = callPackage ../development/python-modules/jenkins-job-builder { };

  jenkinsapi = callPackage ../development/python-modules/jenkinsapi { };

  jfx-bridge = callPackage ../development/python-modules/jfx-bridge { };

  jh2 = callPackage ../development/python-modules/jh2 { };

  jianpu-ly = callPackage ../development/python-modules/jianpu-ly { };

  jieba = callPackage ../development/python-modules/jieba { };

  jinja2 = callPackage ../development/python-modules/jinja2 { };

  jinja2-ansible-filters = callPackage ../development/python-modules/jinja2-ansible-filters { };

  jinja2-git = callPackage ../development/python-modules/jinja2-git { };

  jinja2-humanize-extension = callPackage ../development/python-modules/jinja2-humanize-extension { };

  jinja2-pluralize = callPackage ../development/python-modules/jinja2-pluralize { };

  jinja2-strcase = callPackage ../development/python-modules/jinja2-strcase { };

  jinja2-time = callPackage ../development/python-modules/jinja2-time { };

  jira = callPackage ../development/python-modules/jira { };

  jishaku = callPackage ../development/python-modules/jishaku { };

  jiter = callPackage ../development/python-modules/jiter { };

  jiwer = callPackage ../development/python-modules/jiwer { };

  jmespath = callPackage ../development/python-modules/jmespath { };

  jmp = callPackage ../development/python-modules/jmp { };

  joblib = callPackage ../development/python-modules/joblib { };

  jobspy = callPackage ../development/python-modules/jobspy { };

  johnnycanencrypt = callPackage ../development/python-modules/johnnycanencrypt { };

  josepy = callPackage ../development/python-modules/josepy { };

  joserfc = callPackage ../development/python-modules/joserfc { };

  jplephem = callPackage ../development/python-modules/jplephem { };

  jproperties = callPackage ../development/python-modules/jproperties { };

  jpylyzer = callPackage ../development/python-modules/jpylyzer { };

  jpype1 = callPackage ../development/python-modules/jpype1 { };

  jq = callPackage ../development/python-modules/jq { inherit (pkgs) jq; };

  jsbeautifier = callPackage ../development/python-modules/jsbeautifier { };

  jschema-to-python = callPackage ../development/python-modules/jschema-to-python { };

  jschon = callPackage ../development/python-modules/jschon { };

  jsmin = callPackage ../development/python-modules/jsmin { };

  json-api-doc = callPackage ../development/python-modules/json-api-doc { };

  json-flatten = callPackage ../development/python-modules/json-flatten { };

  json-home-client = callPackage ../development/python-modules/json-home-client { };

  json-logging = callPackage ../development/python-modules/json-logging { };

  json-merge-patch = callPackage ../development/python-modules/json-merge-patch { };

  json-repair = callPackage ../development/python-modules/json-repair { };

  json-rpc = callPackage ../development/python-modules/json-rpc { };

  json-schema-for-humans = callPackage ../development/python-modules/json-schema-for-humans { };

  json-stream = callPackage ../development/python-modules/json-stream { };

  json-stream-rs-tokenizer = callPackage ../development/python-modules/json-stream-rs-tokenizer { };

  json-tricks = callPackage ../development/python-modules/json-tricks { };

  json2html = callPackage ../development/python-modules/json2html { };

  json5 = callPackage ../development/python-modules/json5 { };

  jsonable = callPackage ../development/python-modules/jsonable { };

  jsonargparse = callPackage ../development/python-modules/jsonargparse { };

  jsonconversion = callPackage ../development/python-modules/jsonconversion { };

  jsondate = callPackage ../development/python-modules/jsondate { };

  jsondiff = callPackage ../development/python-modules/jsondiff { };

  jsonfeed = callPackage ../development/python-modules/jsonfeed { };

  jsonformatter = callPackage ../development/python-modules/jsonformatter { };

  jsonlines = callPackage ../development/python-modules/jsonlines { };

  jsonmerge = callPackage ../development/python-modules/jsonmerge { };

  jsonnet = callPackage ../development/python-modules/jsonnet { };

  jsonpatch = callPackage ../development/python-modules/jsonpatch { };

  jsonpath = callPackage ../development/python-modules/jsonpath { };

  jsonpath-ng = callPackage ../development/python-modules/jsonpath-ng { };

  jsonpath-python = callPackage ../development/python-modules/jsonpath-python { };

  jsonpath-rw = callPackage ../development/python-modules/jsonpath-rw { };

  jsonpickle = callPackage ../development/python-modules/jsonpickle { };

  jsonpointer = callPackage ../development/python-modules/jsonpointer { };

  jsonref = callPackage ../development/python-modules/jsonref { };

  jsonrpc-async = callPackage ../development/python-modules/jsonrpc-async { };

  jsonrpc-base = callPackage ../development/python-modules/jsonrpc-base { };

  jsonrpc-websocket = callPackage ../development/python-modules/jsonrpc-websocket { };

  jsonrpclib-pelix = callPackage ../development/python-modules/jsonrpclib-pelix { };

  jsons = callPackage ../development/python-modules/jsons { };

  jsonschema = callPackage ../development/python-modules/jsonschema { };

  jsonschema-path = callPackage ../development/python-modules/jsonschema-path { };

  jsonschema-rs = callPackage ../development/python-modules/jsonschema-rs { };

  jsonschema-spec = callPackage ../development/python-modules/jsonschema-spec { };

  jsonschema-specifications = callPackage ../development/python-modules/jsonschema-specifications { };

  jsonslicer = callPackage ../development/python-modules/jsonslicer { };

  jsonstreams = callPackage ../development/python-modules/jsonstreams { };

  jsonxs = callPackage ../development/python-modules/jsonxs { };

  jstyleson = callPackage ../development/python-modules/jstyleson { };

  jug = callPackage ../development/python-modules/jug { };

  juliandate = callPackage ../development/python-modules/juliandate { };

  julius = callPackage ../development/python-modules/julius { };

  july = callPackage ../development/python-modules/july { };

  june-analytics-python = callPackage ../development/python-modules/june-analytics-python { };

  junit-xml = callPackage ../development/python-modules/junit-xml { };

  junit2html = callPackage ../development/python-modules/junit2html { };

  junitparser = callPackage ../development/python-modules/junitparser { };

  junos-eznc = callPackage ../development/python-modules/junos-eznc { };

  jupysql = callPackage ../development/python-modules/jupysql { };

  jupysql-plugin = callPackage ../development/python-modules/jupysql-plugin { };

  jupyter = callPackage ../development/python-modules/jupyter { };

  jupyter-book = callPackage ../development/python-modules/jupyter-book { };

  jupyter-c-kernel = callPackage ../development/python-modules/jupyter-c-kernel { };

  jupyter-cache = callPackage ../development/python-modules/jupyter-cache { };

  jupyter-client = callPackage ../development/python-modules/jupyter-client { };

  jupyter-collaboration = callPackage ../development/python-modules/jupyter-collaboration { };

  jupyter-collaboration-ui = callPackage ../development/python-modules/jupyter-collaboration-ui { };

  jupyter-console = callPackage ../development/python-modules/jupyter-console { };

  jupyter-contrib-core = callPackage ../development/python-modules/jupyter-contrib-core { };

  jupyter-core = callPackage ../development/python-modules/jupyter-core { };

  jupyter-docprovider = callPackage ../development/python-modules/jupyter-docprovider { };

  jupyter-events = callPackage ../development/python-modules/jupyter-events { };

  jupyter-highlight-selected-word =
    callPackage ../development/python-modules/jupyter-highlight-selected-word
      { };

  jupyter-lsp = callPackage ../development/python-modules/jupyter-lsp { };

  jupyter-nbextensions-configurator =
    callPackage ../development/python-modules/jupyter-nbextensions-configurator
      { };

  jupyter-packaging = callPackage ../development/python-modules/jupyter-packaging { };

  jupyter-repo2docker = callPackage ../development/python-modules/jupyter-repo2docker {
    pkgs-docker = pkgs.docker;
  };

  jupyter-server = callPackage ../development/python-modules/jupyter-server { };

  jupyter-server-fileid = callPackage ../development/python-modules/jupyter-server-fileid { };

  jupyter-server-mathjax = callPackage ../development/python-modules/jupyter-server-mathjax { };

  jupyter-server-terminals = callPackage ../development/python-modules/jupyter-server-terminals { };

  jupyter-server-ydoc = callPackage ../development/python-modules/jupyter-server-ydoc { };

  jupyter-sphinx = callPackage ../development/python-modules/jupyter-sphinx { };

  jupyter-telemetry = callPackage ../development/python-modules/jupyter-telemetry { };

  jupyter-themes = callPackage ../development/python-modules/jupyter-themes { };

  jupyter-ui-poll = callPackage ../development/python-modules/jupyter-ui-poll { };

  jupyter-ydoc = callPackage ../development/python-modules/jupyter-ydoc { };

  jupyterhub = callPackage ../development/python-modules/jupyterhub { };

  jupyterhub-ldapauthenticator =
    callPackage ../development/python-modules/jupyterhub-ldapauthenticator
      { };

  jupyterhub-systemdspawner = callPackage ../development/python-modules/jupyterhub-systemdspawner { };

  jupyterhub-tmpauthenticator =
    callPackage ../development/python-modules/jupyterhub-tmpauthenticator
      { };

  jupyterlab = callPackage ../development/python-modules/jupyterlab { };

  jupyterlab-execute-time = callPackage ../development/python-modules/jupyterlab-execute-time { };

  jupyterlab-git = callPackage ../development/python-modules/jupyterlab-git { };

  jupyterlab-lsp = callPackage ../development/python-modules/jupyterlab-lsp { };

  jupyterlab-pygments = callPackage ../development/python-modules/jupyterlab-pygments { };

  jupyterlab-server = callPackage ../development/python-modules/jupyterlab-server { };

  jupyterlab-vim = callPackage ../development/python-modules/jupyterlab-vim { };

  jupyterlab-widgets = callPackage ../development/python-modules/jupyterlab-widgets { };

  jupytext = callPackage ../development/python-modules/jupytext { };

  justbackoff = callPackage ../development/python-modules/justbackoff { };

  justbases = callPackage ../development/python-modules/justbases { };

  justbytes = callPackage ../development/python-modules/justbytes { };

  justext = callPackage ../development/python-modules/justext { };

  justnimbus = callPackage ../development/python-modules/justnimbus { };

  jwcrypto = callPackage ../development/python-modules/jwcrypto { };

  jwt = callPackage ../development/python-modules/jwt { };

  jxlpy = callPackage ../development/python-modules/jxlpy { };

  jxmlease = callPackage ../development/python-modules/jxmlease { };

  k-diffusion = callPackage ../development/python-modules/k-diffusion { };

  k5test = callPackage ../development/python-modules/k5test {
    inherit (pkgs) findutils;
    krb5-c = pkgs.krb5;
  };

  kaa-base = callPackage ../development/python-modules/kaa-base { };

  kaa-metadata = callPackage ../development/python-modules/kaa-metadata { };

  kafka-python-ng = callPackage ../development/python-modules/kafka-python-ng { };

  kaggle = callPackage ../development/python-modules/kaggle { };

  kagglehub = callPackage ../development/python-modules/kagglehub { };

  kahip = toPythonModule (
    pkgs.kahip.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  kaitaistruct = callPackage ../development/python-modules/kaitaistruct { };

  kaiterra-async-client = callPackage ../development/python-modules/kaiterra-async-client { };

  kajiki = callPackage ../development/python-modules/kajiki { };

  kaldi-active-grammar = callPackage ../development/python-modules/kaldi-active-grammar { };

  kaleido = callPackage ../development/python-modules/kaleido { };

  kalshi-python = callPackage ../development/python-modules/kalshi-python { };

  kanalizer = callPackage ../development/python-modules/kanalizer { };

  kanidm = callPackage ../development/python-modules/kanidm { };

  kantoku = callPackage ../development/python-modules/kantoku { };

  kaptan = callPackage ../development/python-modules/kaptan { };

  karton-asciimagic = callPackage ../development/python-modules/karton-asciimagic { };

  karton-autoit-ripper = callPackage ../development/python-modules/karton-autoit-ripper { };

  karton-classifier = callPackage ../development/python-modules/karton-classifier { };

  karton-config-extractor = callPackage ../development/python-modules/karton-config-extractor { };

  karton-core = callPackage ../development/python-modules/karton-core { };

  karton-dashboard = callPackage ../development/python-modules/karton-dashboard { };

  karton-mwdb-reporter = callPackage ../development/python-modules/karton-mwdb-reporter { };

  karton-yaramatcher = callPackage ../development/python-modules/karton-yaramatcher { };

  kasa-crypt = callPackage ../development/python-modules/kasa-crypt { };

  kazoo = callPackage ../development/python-modules/kazoo { };

  kbcstorage = callPackage ../development/python-modules/kbcstorage { };

  kconfiglib = callPackage ../development/python-modules/kconfiglib { };

  kde-material-you-colors = callPackage ../development/python-modules/kde-material-you-colors { };

  kdl-py = callPackage ../development/python-modules/kdl-py { };

  keba-kecontact = callPackage ../development/python-modules/keba-kecontact { };

  keep = callPackage ../development/python-modules/keep { };

  keepalive = callPackage ../development/python-modules/keepalive { };

  keepkey = callPackage ../development/python-modules/keepkey { };

  keepkey-agent = callPackage ../development/python-modules/keepkey-agent { };

  kegtron-ble = callPackage ../development/python-modules/kegtron-ble { };

  keke = callPackage ../development/python-modules/keke { };

  keras = callPackage ../development/python-modules/keras { };

  kerbad = callPackage ../development/python-modules/kerbad { };

  kerberos = callPackage ../development/python-modules/kerberos { };

  kernels = callPackage ../development/python-modules/kernels { };

  kestra = callPackage ../development/python-modules/kestra { };

  keyboard = callPackage ../development/python-modules/keyboard { };

  keymap-drawer = callPackage ../development/python-modules/keymap-drawer { };

  keyring = callPackage ../development/python-modules/keyring { };

  keyring-pass = callPackage ../development/python-modules/keyring-pass { };

  keyrings-alt = callPackage ../development/python-modules/keyrings-alt { };

  keyrings-cryptfile = callPackage ../development/python-modules/keyrings-cryptfile { };

  keyrings-google-artifactregistry-auth =
    callPackage ../development/python-modules/keyrings-google-artifactregistry-auth
      { };

  keystone-engine = callPackage ../development/python-modules/keystone-engine { };

  keystoneauth1 = callPackage ../development/python-modules/keystoneauth1 { };

  keyutils = callPackage ../development/python-modules/keyutils { inherit (pkgs) keyutils; };

  kfactory = callPackage ../development/python-modules/kfactory { };

  kgb = callPackage ../development/python-modules/kgb { };

  khanaa = callPackage ../development/python-modules/khanaa { };

  kicad = toPythonModule (pkgs.kicad.override { python3 = python; }).src;

  kicad-python = callPackage ../development/python-modules/kicad-python { };

  kicadcliwrapper = callPackage ../development/python-modules/kicadcliwrapper { };

  kinparse = callPackage ../development/python-modules/kinparse { };

  kiss-headers = callPackage ../development/python-modules/kiss-headers { };

  kitchen = callPackage ../development/python-modules/kitchen { };

  kivy = callPackage ../development/python-modules/kivy { };

  kivy-garden = callPackage ../development/python-modules/kivy-garden { };

  kiwiki-client = callPackage ../development/python-modules/kiwiki-client { };

  kiwisolver = callPackage ../development/python-modules/kiwisolver { };

  klaus = callPackage ../development/python-modules/klaus { };

  klayout = callPackage ../development/python-modules/klayout { };

  klein = callPackage ../development/python-modules/klein { };

  kmapper = callPackage ../development/python-modules/kmapper { };

  kml2geojson = callPackage ../development/python-modules/kml2geojson { };

  kmsxx = toPythonModule (
    pkgs.kmsxx.override {
      withPython = true;
      python3Packages = self;
    }
  );

  knack = callPackage ../development/python-modules/knack { };

  kneaddata = callPackage ../development/python-modules/kneaddata { };

  kneed = callPackage ../development/python-modules/kneed { };

  knocki = callPackage ../development/python-modules/knocki { };

  knot-floer-homology = callPackage ../development/python-modules/knot-floer-homology { };

  knowit = callPackage ../development/python-modules/knowit { };

  knx-frontend = callPackage ../development/python-modules/knx-frontend { };

  kokoro = callPackage ../development/python-modules/kokoro { };

  kombu = callPackage ../development/python-modules/kombu { };

  konnected = callPackage ../development/python-modules/konnected { };

  kopf = callPackage ../development/python-modules/kopf { };

  korean-lunar-calendar = callPackage ../development/python-modules/korean-lunar-calendar { };

  kornia = callPackage ../development/python-modules/kornia { };

  kornia-rs = callPackage ../development/python-modules/kornia-rs { };

  kotsu = callPackage ../development/python-modules/kotsu { };

  krakenex = callPackage ../development/python-modules/krakenex { };

  krb5 = callPackage ../development/python-modules/krb5 { krb5-c = pkgs.krb5; };

  krfzf-py = callPackage ../development/python-modules/krfzf-py { };

  kserve = callPackage ../development/python-modules/kserve { };

  kserve-storage = callPackage ../development/python-modules/kserve-storage { };

  kubernetes = callPackage ../development/python-modules/kubernetes { };

  kubernetes-asyncio = callPackage ../development/python-modules/kubernetes-asyncio { };

  kubernetes-validate = callPackage ../by-name/ku/kubernetes-validate/unwrapped.nix { };

  kurbopy = callPackage ../development/python-modules/kurbopy { };

  kuzu = callPackage ../development/python-modules/kuzu { };

  l18n = callPackage ../development/python-modules/l18n { };

  la-panic = callPackage ../development/python-modules/la-panic { };

  labelbox = callPackage ../development/python-modules/labelbox { };

  labgrid = callPackage ../development/python-modules/labgrid { };

  labmath = callPackage ../development/python-modules/labmath { };

  laces = callPackage ../development/python-modules/laces { };

  lacrosse-view = callPackage ../development/python-modules/lacrosse-view { };

  lacuscore = callPackage ../development/python-modules/lacuscore { };

  lakeside = callPackage ../development/python-modules/lakeside { };

  lammps = callPackage ../development/python-modules/lammps { inherit (pkgs) lammps; };

  lance-namespace = callPackage ../development/python-modules/lance-namespace { };

  lance-namespace-urllib3-client =
    callPackage ../development/python-modules/lance-namespace-urllib3-client
      { };

  lancedb = callPackage ../development/python-modules/lancedb { inherit (pkgs) protobuf; };

  langchain = callPackage ../development/python-modules/langchain { };

  langchain-anthropic = callPackage ../development/python-modules/langchain-anthropic { };

  langchain-aws = callPackage ../development/python-modules/langchain-aws { };

  langchain-azure-dynamic-sessions =
    callPackage ../development/python-modules/langchain-azure-dynamic-sessions
      { };

  langchain-chroma = callPackage ../development/python-modules/langchain-chroma { };

  langchain-classic = callPackage ../development/python-modules/langchain-classic { };

  langchain-community = callPackage ../development/python-modules/langchain-community { };

  langchain-core = callPackage ../development/python-modules/langchain-core { };

  langchain-deepseek = callPackage ../development/python-modules/langchain-deepseek { };

  langchain-experimental = callPackage ../development/python-modules/langchain-experimental { };

  langchain-fireworks = callPackage ../development/python-modules/langchain-fireworks { };

  langchain-google-genai = callPackage ../development/python-modules/langchain-google-genai { };

  langchain-groq = callPackage ../development/python-modules/langchain-groq { };

  langchain-huggingface = callPackage ../development/python-modules/langchain-huggingface { };

  langchain-mistralai = callPackage ../development/python-modules/langchain-mistralai { };

  langchain-mongodb = callPackage ../development/python-modules/langchain-mongodb { };

  langchain-ollama = callPackage ../development/python-modules/langchain-ollama { };

  langchain-openai = callPackage ../development/python-modules/langchain-openai { };

  langchain-perplexity = callPackage ../development/python-modules/langchain-perplexity { };

  langchain-tests = callPackage ../development/python-modules/langchain-tests { };

  langchain-text-splitters = callPackage ../development/python-modules/langchain-text-splitters { };

  langchain-xai = callPackage ../development/python-modules/langchain-xai { };

  langcodes = callPackage ../development/python-modules/langcodes { };

  langdetect = callPackage ../development/python-modules/langdetect { };

  langfuse = callPackage ../development/python-modules/langfuse { };

  langgraph = callPackage ../development/python-modules/langgraph { };

  langgraph-checkpoint = callPackage ../development/python-modules/langgraph-checkpoint { };

  langgraph-checkpoint-mongodb =
    callPackage ../development/python-modules/langgraph-checkpoint-mongodb
      { };

  langgraph-checkpoint-postgres =
    callPackage ../development/python-modules/langgraph-checkpoint-postgres
      { };

  langgraph-checkpoint-sqlite =
    callPackage ../development/python-modules/langgraph-checkpoint-sqlite
      { };

  langgraph-cli = callPackage ../development/python-modules/langgraph-cli { };

  langgraph-prebuilt = callPackage ../development/python-modules/langgraph-prebuilt { };

  langgraph-runtime-inmem = callPackage ../development/python-modules/langgraph-runtime-inmem { };

  langgraph-sdk = callPackage ../development/python-modules/langgraph-sdk { };

  langgraph-store-mongodb = callPackage ../development/python-modules/langgraph-store-mongodb { };

  langid = callPackage ../development/python-modules/langid { };

  langsmith = callPackage ../development/python-modules/langsmith { };

  language-data = callPackage ../development/python-modules/language-data { };

  language-tags = callPackage ../development/python-modules/language-tags { };

  language-tool-python = callPackage ../development/python-modules/language-tool-python { };

  lanms-neo = callPackage ../development/python-modules/lanms-neo { };

  lap = callPackage ../development/python-modules/lap { };

  lark = callPackage ../development/python-modules/lark { };

  laspy = callPackage ../development/python-modules/laspy { };

  lastversion = callPackage ../development/python-modules/lastversion { };

  laszip = callPackage ../development/python-modules/laszip {
    inherit (pkgs) cmake ninja;
    inherit (pkgs.__splicedPackages) laszip;
  };

  latex2mathml = callPackage ../development/python-modules/latex2mathml { };

  latex2pydata = callPackage ../development/python-modules/latex2pydata { };

  latexcodec = callPackage ../development/python-modules/latexcodec { };

  latexify-py = callPackage ../development/python-modules/latexify-py { };

  latexrestricted = callPackage ../development/python-modules/latexrestricted { };

  launchpadlib = callPackage ../development/python-modules/launchpadlib { };

  laundrify-aio = callPackage ../development/python-modules/laundrify-aio { };

  layoutparser = callPackage ../development/python-modules/layoutparser { };

  lazr-config = callPackage ../development/python-modules/lazr-config { };

  lazr-delegates = callPackage ../development/python-modules/lazr-delegates { };

  lazr-restfulclient = callPackage ../development/python-modules/lazr-restfulclient { };

  lazr-uri = callPackage ../development/python-modules/lazr-uri { };

  lazrs = callPackage ../development/python-modules/lazrs { };

  lazy = callPackage ../development/python-modules/lazy { };

  lazy-imports = callPackage ../development/python-modules/lazy-imports { };

  lazy-loader = callPackage ../development/python-modules/lazy-loader { };

  lazy-object-proxy = callPackage ../development/python-modules/lazy-object-proxy { };

  lb-matching-tools = callPackage ../development/python-modules/lb-matching-tools { };

  lc7001 = callPackage ../development/python-modules/lc7001 { };

  lcd-i2c = callPackage ../development/python-modules/lcd-i2c { };

  lcgit = callPackage ../development/python-modules/lcgit { };

  lcn-frontend = callPackage ../development/python-modules/lcn-frontend { };

  lcov-cobertura = callPackage ../development/python-modules/lcov-cobertura { };

  ld2410-ble = callPackage ../development/python-modules/ld2410-ble { };

  ldap3 = callPackage ../development/python-modules/ldap3 { };

  ldap3-bleeding-edge = callPackage ../development/python-modules/ldap3-bleeding-edge { };

  ldapdomaindump = callPackage ../development/python-modules/ldapdomaindump { };

  ldappool = callPackage ../development/python-modules/ldappool { };

  ldaptor = callPackage ../development/python-modules/ldaptor { };

  ldfparser = callPackage ../development/python-modules/ldfparser { };

  leanblueprint = callPackage ../development/python-modules/leanblueprint { };

  leaone-ble = callPackage ../development/python-modules/leaone-ble { };

  leather = callPackage ../development/python-modules/leather { };

  leb128 = callPackage ../development/python-modules/leb128 { };

  led-ble = callPackage ../development/python-modules/led-ble { };

  ledger =
    (toPythonModule (
      pkgs.ledger.override {
        usePython = true;
        python3 = python;
      }
    )).py;

  ledger-agent = callPackage ../development/python-modules/ledger-agent { };

  ledger-bitcoin = callPackage ../development/python-modules/ledger-bitcoin { };

  ledgerblue = callPackage ../development/python-modules/ledgerblue { };

  ledgercomm = callPackage ../development/python-modules/ledgercomm { };

  ledgerwallet = callPackage ../development/python-modules/ledgerwallet { };

  legacy-api-wrap = callPackage ../development/python-modules/legacy-api-wrap { };

  legacy-cgi =
    if pythonOlder "3.13" then null else callPackage ../development/python-modules/legacy-cgi { };

  leidenalg = callPackage ../development/python-modules/leidenalg { igraph-c = pkgs.igraph; };

  lektricowifi = callPackage ../development/python-modules/lektricowifi { };

  lerobot = callPackage ../development/python-modules/lerobot { };

  letpot = callPackage ../development/python-modules/letpot { };

  leveldb = callPackage ../development/python-modules/leveldb { };

  levenshtein = callPackage ../development/python-modules/levenshtein { };

  lexid = callPackage ../development/python-modules/lexid { };

  lexilang = callPackage ../development/python-modules/lexilang { };

  lgpio = toPythonModule (
    pkgs.lgpio.override {
      inherit buildPythonPackage;
      pyProject = "PY_LGPIO";
      lgpioWithoutPython = pkgs.lgpio;
    }
  );

  lhapdf = toPythonModule (pkgs.lhapdf.override { python3 = python; });

  lib4package = callPackage ../development/python-modules/lib4package { };

  lib4sbom = callPackage ../development/python-modules/lib4sbom { };

  lib4vex = callPackage ../development/python-modules/lib4vex { };

  lib50 = callPackage ../development/python-modules/lib50 { };

  libagent = callPackage ../development/python-modules/libagent { };

  libais = callPackage ../development/python-modules/libais { };

  libapparmor = toPythonModule (
    pkgs.libapparmor.override {
      python3Packages = self;
    }
  );

  libarchive-c = callPackage ../development/python-modules/libarchive-c {
    inherit (pkgs) libarchive;
  };

  libarcus = callPackage ../development/python-modules/libarcus { protobuf = pkgs.protobuf_21; };

  libasyncns = callPackage ../development/python-modules/libasyncns { inherit (pkgs) libasyncns; };

  libbs = callPackage ../development/python-modules/libbs { };

  libclang = callPackage ../development/python-modules/libclang { };

  libcloud = callPackage ../development/python-modules/libcloud { };

  libcomps = lib.pipe pkgs.libcomps [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
        };
      })
    )
    (p: p.override { python3 = python; })
    (p: p.py)
  ];

  libcst = callPackage ../development/python-modules/libcst { };

  libdnf = lib.pipe pkgs.libdnf [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
        };
      })
    )
    (p: p.override { python3 = python; })
    (p: p.py)
  ];

  libear = callPackage ../development/python-modules/libear { };

  liberty-parser = callPackage ../development/python-modules/liberty-parser { };

  libevdev = callPackage ../development/python-modules/libevdev { };

  libfdt = toPythonModule (
    pkgs.dtc.override {
      inherit python;
      pythonSupport = true;
    }
  );

  libfive = toPythonModule (pkgs.libfive.override { python3 = python; });

  libgpiod = callPackage ../development/python-modules/libgpiod { inherit (pkgs) libgpiod; };

  libgravatar = callPackage ../development/python-modules/libgravatar { };

  libiio =
    (toPythonModule (
      pkgs.libiio.override {
        pythonSupport = true;
        python3 = python;
      }
    )).python;

  libipld = callPackage ../development/python-modules/libipld { };

  libkeepass = callPackage ../development/python-modules/libkeepass { };

  libknot = callPackage ../development/python-modules/libknot { };

  liblarch = callPackage ../development/python-modules/liblarch { };

  liblistenbrainz = callPackage ../development/python-modules/liblistenbrainz { };

  liblp = callPackage ../development/python-modules/liblp { };

  liblzfse = callPackage ../development/python-modules/liblzfse { inherit (pkgs) lzfse; };

  libmambapy = callPackage ../development/python-modules/libmambapy { };

  libmodulemd = lib.pipe pkgs.libmodulemd [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ]; # The package always builds python3 bindings
          broken = (super.meta.broken or false) || !isPy3k;
        };
      })
    )
    (p: p.override { python3 = python; })
    (p: p.py)
  ];

  libmr = callPackage ../development/python-modules/libmr { };

  libnacl = callPackage ../development/python-modules/libnacl { inherit (pkgs) libsodium; };

  libnbd = toPythonModule (
    pkgs.libnbd.override {
      buildPythonBindings = true;
      python3 = python;
    }
  );

  libpass = callPackage ../development/python-modules/libpass { };

  libpcap = callPackage ../development/python-modules/libpcap {
    pkgsLibpcap = pkgs.libpcap; # Needs the C library
  };

  libpurecool = callPackage ../development/python-modules/libpurecool { };

  libpwquality = lib.pipe pkgs.libpwquality [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
        };
      })
    )
    (
      p:
      p.override {
        enablePython = true;
        python3 = python;
      }
    )
    (p: p.py)
  ];

  libpyfoscamcgi = callPackage ../development/python-modules/libpyfoscamcgi { };

  libpysal = callPackage ../development/python-modules/libpysal { };

  libpyvivotek = callPackage ../development/python-modules/libpyvivotek { };

  libredwg = toPythonModule (
    pkgs.libredwg.override {
      enablePython = true;
      inherit (self) python libxml2;
    }
  );

  librehardwaremonitor-api = callPackage ../development/python-modules/librehardwaremonitor-api { };

  librepo = lib.pipe pkgs.librepo [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
        };
      })
    )
    (p: p.override { python3 = python; })
    (p: p.py)
  ];

  librespot = callPackage ../development/python-modules/librespot { };

  libretranslate = callPackage ../development/python-modules/libretranslate { };

  librosa = callPackage ../development/python-modules/librosa { };

  librouteros = callPackage ../development/python-modules/librouteros { };

  libsass = callPackage ../development/python-modules/libsass { inherit (pkgs) libsass; };

  libsavitar = callPackage ../development/python-modules/libsavitar { };

  libsbml = toPythonModule (
    pkgs.libsbml.override {
      withPython = true;
      inherit (self) python;
    }
  );

  libscanbuild = callPackage ../development/python-modules/libscanbuild { };

  libselinux = lib.pipe pkgs.libselinux [
    toPythonModule
    (
      p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
          broken = super.meta.broken or isPy27;
        };
      })
    )
    (
      p:
      p.override {
        enablePython = true;
        python3 = python;
        python3Packages = self;
      }
    )
    (p: p.py)
  ];

  libsixel = callPackage ../development/python-modules/libsixel { inherit (pkgs) libsixel; };

  libsoundtouch = callPackage ../development/python-modules/libsoundtouch { };

  libsupermesh = callPackage ../development/python-modules/libsupermesh { };

  libtfr = callPackage ../development/python-modules/libtfr { };

  libthumbor = callPackage ../development/python-modules/libthumbor { };

  libtmux = callPackage ../development/python-modules/libtmux { };

  libtorrent-rasterbar =
    (toPythonModule (pkgs.libtorrent-rasterbar.override { python3 = python; })).python;

  libusb-package = callPackage ../development/python-modules/libusb-package {
    inherit (pkgs) libusb1;
  };

  libusb1 = callPackage ../development/python-modules/libusb1 { inherit (pkgs) libusb1; };

  libusbsio = callPackage ../development/python-modules/libusbsio { inherit (pkgs) libusbsio; };

  libuuu = callPackage ../development/python-modules/libuuu { };

  libversion = callPackage ../development/python-modules/libversion { inherit (pkgs) libversion; };

  libvirt = callPackage ../development/python-modules/libvirt { inherit (pkgs) libvirt; };

  libxml2 =
    (toPythonModule (
      pkgs.libxml2.override {
        pythonSupport = true;
        python3 = python;
      }
    )).py;

  libxslt =
    (toPythonModule (
      pkgs.libxslt.override {
        pythonSupport = true;
        python3 = python;
        inherit (self) libxml2;
      }
    )).py;

  liccheck = callPackage ../development/python-modules/liccheck { };

  license-expression = callPackage ../development/python-modules/license-expression { };

  lida = callPackage ../development/python-modules/lida { };

  lief = (toPythonModule (pkgs.lief.override { python3 = python; })).py;

  life360 = callPackage ../development/python-modules/life360 { };

  lifelines = callPackage ../development/python-modules/lifelines { };

  lightgbm = callPackage ../development/python-modules/lightgbm { };

  lightify = callPackage ../development/python-modules/lightify { };

  lightning = callPackage ../development/python-modules/lightning { };

  lightning-utilities = callPackage ../development/python-modules/lightning-utilities { };

  lightparam = callPackage ../development/python-modules/lightparam { };

  lightwave = callPackage ../development/python-modules/lightwave { };

  lightwave2 = callPackage ../development/python-modules/lightwave2 { };

  lima = callPackage ../development/python-modules/lima { };

  lime = callPackage ../development/python-modules/lime { };

  limiter = callPackage ../development/python-modules/limiter { };

  limitlessled = callPackage ../development/python-modules/limitlessled { };

  limits = callPackage ../development/python-modules/limits { };

  limnoria = callPackage ../development/python-modules/limnoria { };

  line-profiler = callPackage ../development/python-modules/line-profiler { };

  linear-operator = callPackage ../development/python-modules/linear-operator { };

  linearmodels = callPackage ../development/python-modules/linearmodels { };

  lineax = callPackage ../development/python-modules/lineax { };

  linecache2 = callPackage ../development/python-modules/linecache2 { };

  lineedit = callPackage ../development/python-modules/lineedit { };

  linetable = callPackage ../development/python-modules/linetable { };

  lingua = callPackage ../development/python-modules/lingua { };

  lingva = callPackage ../development/python-modules/lingva { };

  linien-client = callPackage ../development/python-modules/linien-client { };

  linien-common = callPackage ../development/python-modules/linien-common { };

  linkify-it-py = callPackage ../development/python-modules/linkify-it-py { };

  linknlink = callPackage ../development/python-modules/linknlink { };

  linode = callPackage ../development/python-modules/linode { };

  linode-api = callPackage ../development/python-modules/linode-api { };

  linode-metadata = callPackage ../development/python-modules/linode-metadata { };

  linuxfd = callPackage ../development/python-modules/linuxfd { };

  linuxpy = callPackage ../development/python-modules/linuxpy { };

  lion-pytorch = callPackage ../development/python-modules/lion-pytorch { };

  liquidctl = callPackage ../development/python-modules/liquidctl { };

  lirc = toPythonModule (pkgs.lirc.override { python3 = python; });

  lit = callPackage ../development/python-modules/lit { };

  litellm = callPackage ../development/python-modules/litellm { };

  litemapy = callPackage ../development/python-modules/litemapy { };

  litestar = callPackage ../development/python-modules/litestar { };

  litestar-htmx = callPackage ../development/python-modules/litestar-htmx { };

  littleutils = callPackage ../development/python-modules/littleutils { };

  livekit-api = callPackage ../development/python-modules/livekit-api { };

  livekit-protocol = callPackage ../development/python-modules/livekit-protocol { };

  livelossplot = callPackage ../development/python-modules/livelossplot { };

  livereload = callPackage ../development/python-modules/livereload { };

  livisi = callPackage ../development/python-modules/livisi { };

  lizard = callPackage ../development/python-modules/lizard { };

  llama-cloud = callPackage ../development/python-modules/llama-cloud { };

  llama-cloud-services = callPackage ../development/python-modules/llama-cloud-services { };

  llama-cpp-python = callPackage ../development/python-modules/llama-cpp-python { };

  llama-index = callPackage ../development/python-modules/llama-index { };

  llama-index-cli = callPackage ../development/python-modules/llama-index-cli { };

  llama-index-core = callPackage ../development/python-modules/llama-index-core { };

  llama-index-embeddings-gemini =
    callPackage ../development/python-modules/llama-index-embeddings-gemini
      { };

  llama-index-embeddings-google =
    callPackage ../development/python-modules/llama-index-embeddings-google
      { };

  llama-index-embeddings-huggingface =
    callPackage ../development/python-modules/llama-index-embeddings-huggingface
      { };

  llama-index-embeddings-ollama =
    callPackage ../development/python-modules/llama-index-embeddings-ollama
      { };

  llama-index-embeddings-openai =
    callPackage ../development/python-modules/llama-index-embeddings-openai
      { };

  llama-index-graph-stores-nebula =
    callPackage ../development/python-modules/llama-index-graph-stores-nebula
      { };

  llama-index-graph-stores-neo4j =
    callPackage ../development/python-modules/llama-index-graph-stores-neo4j
      { };

  llama-index-graph-stores-neptune =
    callPackage ../development/python-modules/llama-index-graph-stores-neptune
      { };

  llama-index-indices-managed-llama-cloud =
    callPackage ../development/python-modules/llama-index-indices-managed-llama-cloud
      { };

  llama-index-instrumentation =
    callPackage ../development/python-modules/llama-index-instrumentation
      { };

  llama-index-legacy = callPackage ../development/python-modules/llama-index-legacy { };

  llama-index-llms-ollama = callPackage ../development/python-modules/llama-index-llms-ollama { };

  llama-index-llms-openai = callPackage ../development/python-modules/llama-index-llms-openai { };

  llama-index-llms-openai-like =
    callPackage ../development/python-modules/llama-index-llms-openai-like
      { };

  llama-index-multi-modal-llms-openai =
    callPackage ../development/python-modules/llama-index-multi-modal-llms-openai
      { };

  llama-index-node-parser-docling =
    callPackage ../development/python-modules/llama-index-node-parser-docling
      { };

  llama-index-readers-database =
    callPackage ../development/python-modules/llama-index-readers-database
      { };

  llama-index-readers-docling =
    callPackage ../development/python-modules/llama-index-readers-docling
      { };

  llama-index-readers-file = callPackage ../development/python-modules/llama-index-readers-file { };

  llama-index-readers-json = callPackage ../development/python-modules/llama-index-readers-json { };

  llama-index-readers-llama-parse =
    callPackage ../development/python-modules/llama-index-readers-llama-parse
      { };

  llama-index-readers-s3 = callPackage ../development/python-modules/llama-index-readers-s3 { };

  llama-index-readers-twitter =
    callPackage ../development/python-modules/llama-index-readers-twitter
      { };

  llama-index-readers-txtai = callPackage ../development/python-modules/llama-index-readers-txtai { };

  llama-index-readers-weather =
    callPackage ../development/python-modules/llama-index-readers-weather
      { };

  llama-index-vector-stores-chroma =
    callPackage ../development/python-modules/llama-index-vector-stores-chroma
      { };

  llama-index-vector-stores-google =
    callPackage ../development/python-modules/llama-index-vector-stores-google
      { };

  llama-index-vector-stores-milvus =
    callPackage ../development/python-modules/llama-index-vector-stores-milvus
      { };

  llama-index-vector-stores-postgres =
    callPackage ../development/python-modules/llama-index-vector-stores-postgres
      { };

  llama-index-vector-stores-qdrant =
    callPackage ../development/python-modules/llama-index-vector-stores-qdrant
      { };

  llama-index-workflows = callPackage ../development/python-modules/llama-index-workflows { };

  llama-parse = callPackage ../development/python-modules/llama-parse { };

  llama-stack-client = callPackage ../development/python-modules/llama-stack-client { };

  llamaindex-py-client = callPackage ../development/python-modules/llamaindex-py-client { };

  llfuse = callPackage ../development/python-modules/llfuse { inherit (pkgs) fuse; };

  llguidance = callPackage ../development/python-modules/llguidance { };

  llm = callPackage ../development/python-modules/llm { };

  llm-anthropic = callPackage ../development/python-modules/llm-anthropic { };

  llm-cmd = callPackage ../development/python-modules/llm-cmd { };

  llm-command-r = callPackage ../development/python-modules/llm-command-r { };

  llm-deepseek = callPackage ../development/python-modules/llm-deepseek { };

  llm-docs = callPackage ../development/python-modules/llm-docs { };

  llm-echo = callPackage ../development/python-modules/llm-echo { };

  llm-fragments-github = callPackage ../development/python-modules/llm-fragments-github { };

  llm-fragments-pypi = callPackage ../development/python-modules/llm-fragments-pypi { };

  llm-fragments-reader = callPackage ../development/python-modules/llm-fragments-reader { };

  llm-fragments-symbex = callPackage ../development/python-modules/llm-fragments-symbex { };

  llm-gemini = callPackage ../development/python-modules/llm-gemini { };

  llm-gguf = callPackage ../development/python-modules/llm-gguf { };

  llm-git = callPackage ../development/python-modules/llm-git { };

  llm-github-copilot = callPackage ../development/python-modules/llm-github-copilot { };

  llm-grok = callPackage ../development/python-modules/llm-grok { };

  llm-groq = callPackage ../development/python-modules/llm-groq { };

  llm-hacker-news = callPackage ../development/python-modules/llm-hacker-news { };

  llm-jq = callPackage ../development/python-modules/llm-jq { };

  llm-llama-server = callPackage ../development/python-modules/llm-llama-server { };

  llm-mistral = callPackage ../development/python-modules/llm-mistral { };

  llm-ollama = callPackage ../development/python-modules/llm-ollama { };

  llm-openai-plugin = callPackage ../development/python-modules/llm-openai-plugin { };

  llm-openrouter = callPackage ../development/python-modules/llm-openrouter { };

  llm-pdf-to-images = callPackage ../development/python-modules/llm-pdf-to-images { };

  llm-perplexity = callPackage ../development/python-modules/llm-perplexity { };

  llm-sentence-transformers = callPackage ../development/python-modules/llm-sentence-transformers { };

  llm-templates-fabric = callPackage ../development/python-modules/llm-templates-fabric { };

  llm-templates-github = callPackage ../development/python-modules/llm-templates-github { };

  llm-tools-datasette = callPackage ../development/python-modules/llm-tools-datasette { };

  llm-tools-quickjs = callPackage ../development/python-modules/llm-tools-quickjs { };

  llm-tools-simpleeval = callPackage ../development/python-modules/llm-tools-simpleeval { };

  llm-tools-sqlite = callPackage ../development/python-modules/llm-tools-sqlite { };

  llm-venice = callPackage ../development/python-modules/llm-venice { };

  llm-video-frames = callPackage ../development/python-modules/llm-video-frames { };

  llmx = callPackage ../development/python-modules/llmx { };

  llvmlite = callPackage ../development/python-modules/llvmlite {
    inherit (pkgs) cmake ninja;
  };

  lm-eval = callPackage ../development/python-modules/lm-eval { };

  lm-format-enforcer = callPackage ../development/python-modules/lm-format-enforcer { };

  lmdb = callPackage ../development/python-modules/lmdb { inherit (pkgs) lmdb; };

  lmfit = callPackage ../development/python-modules/lmfit { };

  lml = callPackage ../development/python-modules/lml { };

  lmnotify = callPackage ../development/python-modules/lmnotify { };

  lmtpd = callPackage ../development/python-modules/lmtpd { };

  lnkparse3 = callPackage ../development/python-modules/lnkparse3 { };

  loca = callPackage ../development/python-modules/loca { };

  local-attention = callPackage ../development/python-modules/local-attention { };

  localimport = callPackage ../development/python-modules/localimport { };

  localstack-client = callPackage ../development/python-modules/localstack-client { };

  localstack-ext = callPackage ../development/python-modules/localstack-ext { };

  localzone = callPackage ../development/python-modules/localzone { };

  locationsharinglib = callPackage ../development/python-modules/locationsharinglib { };

  locket = callPackage ../development/python-modules/locket { };

  lockfile = callPackage ../development/python-modules/lockfile { };

  locust = callPackage ../development/python-modules/locust { };

  locust-cloud = callPackage ../development/python-modules/locust-cloud { };

  log-symbols = callPackage ../development/python-modules/log-symbols { };

  logbook = callPackage ../development/python-modules/logbook { };

  logfury = callPackage ../development/python-modules/logfury { };

  logging-journald = callPackage ../development/python-modules/logging-journald { };

  logging-tree = callPackage ../development/python-modules/logging-tree { };

  logical-unification = callPackage ../development/python-modules/logical-unification { };

  logilab-common = callPackage ../development/python-modules/logilab/common.nix {
    pytestCheckHook = pytest7CheckHook;
  };

  logilab-constraint = callPackage ../development/python-modules/logilab/constraint.nix { };

  logmatic-python = callPackage ../development/python-modules/logmatic-python { };

  logster = callPackage ../development/python-modules/logster { };

  loguru = callPackage ../development/python-modules/loguru { };

  loguru-logging-intercept = callPackage ../development/python-modules/loguru-logging-intercept { };

  logutils = callPackage ../development/python-modules/logutils { };

  logzero = callPackage ../development/python-modules/logzero { };

  lomond = callPackage ../development/python-modules/lomond { };

  london-tube-status = callPackage ../development/python-modules/london-tube-status { };

  loompy = callPackage ../development/python-modules/loompy { };

  loopy = callPackage ../development/python-modules/loopy { };

  looseversion = callPackage ../development/python-modules/looseversion { };

  loqedapi = callPackage ../development/python-modules/loqedapi { };

  loro = callPackage ../development/python-modules/loro { };

  losant-rest = callPackage ../development/python-modules/losant-rest { };

  lottie = callPackage ../development/python-modules/lottie { };

  low-index = callPackage ../development/python-modules/low-index { };

  lox = callPackage ../development/python-modules/lox { };

  lpc-checksum = callPackage ../development/python-modules/lpc-checksum { };

  lrcalc-python = callPackage ../development/python-modules/lrcalc-python { };

  lrclibapi = callPackage ../development/python-modules/lrclibapi { };

  lru-dict = callPackage ../development/python-modules/lru-dict { };

  lsassy = callPackage ../development/python-modules/lsassy { };

  lsp-tree-sitter = callPackage ../development/python-modules/lsp-tree-sitter { };

  lsprotocol = lsprotocol_2023;

  lsprotocol_2023 = callPackage ../development/python-modules/lsprotocol/2023.nix { };

  lsprotocol_2025 = callPackage ../development/python-modules/lsprotocol/2025.nix { };

  ltpycld2 = callPackage ../development/python-modules/ltpycld2 { };

  lttng = callPackage ../development/python-modules/lttng { };

  luddite = callPackage ../development/python-modules/luddite { };

  luftdaten = callPackage ../development/python-modules/luftdaten { };

  luhn = callPackage ../development/python-modules/luhn { };

  luma-core = callPackage ../development/python-modules/luma-core { };

  luna-soc = callPackage ../development/python-modules/luna-soc { };

  luna-usb = callPackage ../development/python-modules/luna-usb { };

  lunarcalendar = callPackage ../development/python-modules/lunarcalendar { };

  lunatone-rest-api-client = callPackage ../development/python-modules/lunatone-rest-api-client { };

  lupa = callPackage ../development/python-modules/lupa { };

  lupupy = callPackage ../development/python-modules/lupupy { };

  luqum = callPackage ../development/python-modules/luqum { };

  luxtronik = callPackage ../development/python-modules/luxtronik { };

  lw12 = callPackage ../development/python-modules/lw12 { };

  lxmf = callPackage ../development/python-modules/lxmf { };

  lxml = callPackage ../development/python-modules/lxml { inherit (pkgs) libxml2 libxslt zlib; };

  lxml-html-clean = callPackage ../development/python-modules/lxml-html-clean { };

  lyricwikia = callPackage ../development/python-modules/lyricwikia { };

  lz4 = callPackage ../development/python-modules/lz4 { };

  lzallright = callPackage ../development/python-modules/lzallright { };

  lzfse = callPackage ../development/python-modules/lzfse { };

  m2crypto = callPackage ../development/python-modules/m2crypto { };

  m2r = callPackage ../development/python-modules/m2r { };

  m3u8 = callPackage ../development/python-modules/m3u8 { };

  mac-alias = callPackage ../development/python-modules/mac-alias { };

  mac-vendor-lookup = callPackage ../development/python-modules/mac-vendor-lookup { };

  macaddress = callPackage ../development/python-modules/macaddress { };

  macfsevents = callPackage ../development/python-modules/macfsevents { };

  macholib = callPackage ../development/python-modules/macholib { };

  maec = callPackage ../development/python-modules/maec { };

  maestral = callPackage ../development/python-modules/maestral { };

  magic = callPackage ../development/python-modules/magic { };

  magic-filter = callPackage ../development/python-modules/magic-filter { };

  magic-wormhole = callPackage ../development/python-modules/magic-wormhole { };

  magic-wormhole-mailbox-server =
    callPackage ../development/python-modules/magic-wormhole-mailbox-server
      { };

  magic-wormhole-transit-relay =
    callPackage ../development/python-modules/magic-wormhole-transit-relay
      { };

  magicgui = callPackage ../development/python-modules/magicgui { };

  magika = callPackage ../development/python-modules/magika { };

  mahotas = callPackage ../development/python-modules/mahotas { };

  mail-parser = callPackage ../development/python-modules/mail-parser { };

  mailcap-fix = callPackage ../development/python-modules/mailcap-fix { };

  mailchecker = callPackage ../development/python-modules/mailchecker { };

  mailchimp = callPackage ../development/python-modules/mailchimp { };

  mailmanclient = callPackage ../development/python-modules/mailmanclient { };

  mailsuite = callPackage ../development/python-modules/mailsuite { };

  maison = callPackage ../development/python-modules/maison { };

  makefun = callPackage ../development/python-modules/makefun { };

  mako = callPackage ../development/python-modules/mako { };

  malduck = callPackage ../development/python-modules/malduck { };

  mallard-ducktype = callPackage ../development/python-modules/mallard-ducktype { };

  mamba-ssm = callPackage ../development/python-modules/mamba-ssm { };

  mammoth = callPackage ../development/python-modules/mammoth { };

  managesieve = callPackage ../development/python-modules/managesieve { };

  mando = callPackage ../development/python-modules/mando { };

  mandown = callPackage ../development/python-modules/mandown { };

  manga-ocr = callPackage ../development/python-modules/manga-ocr { };

  manhole = callPackage ../development/python-modules/manhole { };

  manifest-ml = callPackage ../development/python-modules/manifest-ml { };

  manifestoo = callPackage ../development/python-modules/manifestoo { };

  manifestoo-core = callPackage ../development/python-modules/manifestoo-core { };

  manifestparser =
    callPackage ../development/python-modules/marionette-harness/manifestparser.nix
      { };

  manifold3d = callPackage ../development/python-modules/manifold3d { };

  manim = callPackage ../development/python-modules/manim { };

  manim-slides = callPackage ../development/python-modules/manim-slides { };

  manimgl = callPackage ../development/python-modules/manimgl { };

  manimpango = callPackage ../development/python-modules/manimpango { };

  manuel = callPackage ../development/python-modules/manuel { };

  manuf = callPackage ../development/python-modules/manuf { };

  mapbox-earcut = callPackage ../development/python-modules/mapbox-earcut { };

  mapclassify = callPackage ../development/python-modules/mapclassify { };

  mariadb = callPackage ../development/python-modules/mariadb { };

  marimo = callPackage ../development/python-modules/marimo { };

  marisa = callPackage ../development/python-modules/marisa { inherit (pkgs) marisa; };

  marisa-trie = callPackage ../development/python-modules/marisa-trie {
    marisa-cpp = pkgs.marisa;
  };

  markdown = callPackage ../development/python-modules/markdown { };

  markdown-include = callPackage ../development/python-modules/markdown-include { };

  markdown-inline-graphviz = callPackage ../development/python-modules/markdown-inline-graphviz { };

  markdown-it-py = callPackage ../development/python-modules/markdown-it-py { };

  markdown-macros = callPackage ../development/python-modules/markdown-macros { };

  markdown2 = callPackage ../development/python-modules/markdown2 { };

  markdownify = callPackage ../development/python-modules/markdownify { };

  markitdown = callPackage ../development/python-modules/markitdown { };

  marko = callPackage ../development/python-modules/marko { };

  markuppy = callPackage ../development/python-modules/markuppy { };

  markups = callPackage ../development/python-modules/markups { };

  markupsafe = callPackage ../development/python-modules/markupsafe { };

  marqo = callPackage ../development/python-modules/marqo { };

  marshmallow = callPackage ../development/python-modules/marshmallow { };

  marshmallow-dataclass = callPackage ../development/python-modules/marshmallow-dataclass { };

  marshmallow-oneofschema = callPackage ../development/python-modules/marshmallow-oneofschema { };

  marshmallow-polyfield = callPackage ../development/python-modules/marshmallow-polyfield { };

  marshmallow-sqlalchemy = callPackage ../development/python-modules/marshmallow-sqlalchemy { };

  mashumaro = callPackage ../development/python-modules/mashumaro { };

  masky = callPackage ../development/python-modules/masky { };

  mastodon-py = callPackage ../development/python-modules/mastodon-py { };

  mat2 = callPackage ../development/python-modules/mat2 { };

  matchpy = callPackage ../development/python-modules/matchpy { };

  material-color-utilities = callPackage ../development/python-modules/material-color-utilities { };

  materialx = callPackage ../development/python-modules/materialx { };

  materialyoucolor = callPackage ../development/python-modules/materialyoucolor { };

  mathutils = callPackage ../development/python-modules/mathutils { };

  matplotlib = callPackage ../development/python-modules/matplotlib {
    stdenv = if stdenv.hostPlatform.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
  };

  matplotlib-inline = callPackage ../development/python-modules/matplotlib-inline { };

  matplotlib-sixel = callPackage ../development/python-modules/matplotlib-sixel { };

  matplotlib-venn = callPackage ../development/python-modules/matplotlib-venn { };

  matplotx = callPackage ../development/python-modules/matplotx { };

  matrix-client = callPackage ../development/python-modules/matrix-client { };

  matrix-common = callPackage ../development/python-modules/matrix-common { };

  matrix-nio = callPackage ../development/python-modules/matrix-nio { };

  mattermostdriver = callPackage ../development/python-modules/mattermostdriver { };

  maubot = callPackage ../tools/networking/maubot { };

  mautrix = callPackage ../development/python-modules/mautrix { };

  mautrix-appservice = self.mautrix; # alias 2019-12-28

  maxcube-api = callPackage ../development/python-modules/maxcube-api { };

  maxminddb = callPackage ../development/python-modules/maxminddb { };

  maya = callPackage ../development/python-modules/maya { };

  mayavi = pkgs.libsForQt5.callPackage ../development/python-modules/mayavi {
    inherit buildPythonPackage pythonOlder;
    inherit (self)
      pyface
      pygments
      numpy
      packaging
      vtk
      traitsui
      envisage
      apptools
      pyqt5
      ;
  };

  mayim = callPackage ../development/python-modules/mayim { };

  mbddns = callPackage ../development/python-modules/mbddns { };

  mbstrdecoder = callPackage ../development/python-modules/mbstrdecoder { };

  mccabe = callPackage ../development/python-modules/mccabe { };

  mcdreforged = callPackage ../development/python-modules/mcdreforged { };

  mcp = callPackage ../development/python-modules/mcp { };

  mcpadapt = callPackage ../development/python-modules/mcpadapt { };

  mcstatus = callPackage ../development/python-modules/mcstatus { };

  mcuuid = callPackage ../development/python-modules/mcuuid { };

  md-toc = callPackage ../development/python-modules/md-toc { };

  md2gemini = callPackage ../development/python-modules/md2gemini { };

  md2pdf = callPackage ../development/python-modules/md2pdf { };

  mdformat = callPackage ../development/python-modules/mdformat { };

  mdformat-admon = callPackage ../development/python-modules/mdformat-admon { };

  mdformat-beautysh = callPackage ../development/python-modules/mdformat-beautysh { };

  mdformat-footnote = callPackage ../development/python-modules/mdformat-footnote { };

  mdformat-frontmatter = callPackage ../development/python-modules/mdformat-frontmatter { };

  mdformat-gfm = callPackage ../development/python-modules/mdformat-gfm { };

  mdformat-gfm-alerts = callPackage ../development/python-modules/mdformat-gfm-alerts { };

  mdformat-mkdocs = callPackage ../development/python-modules/mdformat-mkdocs { };

  mdformat-myst = callPackage ../development/python-modules/mdformat-myst { };

  mdformat-nix-alejandra = callPackage ../development/python-modules/mdformat-nix-alejandra { };

  mdformat-simple-breaks = callPackage ../development/python-modules/mdformat-simple-breaks { };

  mdformat-tables = callPackage ../development/python-modules/mdformat-tables { };

  mdformat-toc = callPackage ../development/python-modules/mdformat-toc { };

  mdformat-wikilink = callPackage ../development/python-modules/mdformat-wikilink { };

  mdit-py-plugins = callPackage ../development/python-modules/mdit-py-plugins { };

  mdtraj = callPackage ../development/python-modules/mdtraj { };

  mdurl = callPackage ../development/python-modules/mdurl { };

  mdutils = callPackage ../development/python-modules/mdutils { };

  mdx-truly-sane-lists = callPackage ../development/python-modules/mdx-truly-sane-lists { };

  mean-average-precision = callPackage ../development/python-modules/mean-average-precision { };

  measurement = callPackage ../development/python-modules/measurement { };

  meater-python = callPackage ../development/python-modules/meater-python { };

  mecab-python3 = callPackage ../development/python-modules/mecab-python3 { };

  mechanicalsoup = callPackage ../development/python-modules/mechanicalsoup { };

  mechanize = callPackage ../development/python-modules/mechanize { };

  medallion = callPackage ../development/python-modules/medallion { };

  medcom-ble = callPackage ../development/python-modules/medcom-ble { };

  mediafile = callPackage ../development/python-modules/mediafile { };

  mediafire-dl = callPackage ../development/python-modules/mediafire-dl { };

  mediapy = callPackage ../development/python-modules/mediapy { };

  medpy = callPackage ../development/python-modules/medpy { };

  medvol = callPackage ../development/python-modules/medvol { };

  meeko = callPackage ../development/python-modules/meeko { };

  meep = callPackage ../development/python-modules/meep { };

  meilisearch = callPackage ../development/python-modules/meilisearch { };

  meinheld = callPackage ../development/python-modules/meinheld { };

  meld3 = callPackage ../development/python-modules/meld3 { };

  melnor-bluetooth = callPackage ../development/python-modules/melnor-bluetooth { };

  memestra = callPackage ../development/python-modules/memestra { };

  memory-allocator = callPackage ../development/python-modules/memory-allocator { };

  memory-profiler = callPackage ../development/python-modules/memory-profiler { };

  memory-tempfile = callPackage ../development/python-modules/memory-tempfile { };

  meraki = callPackage ../development/python-modules/meraki { };

  mercadopago = callPackage ../development/python-modules/mercadopago { };

  mercantile = callPackage ../development/python-modules/mercantile { };

  mercurial = toPythonModule (pkgs.mercurial.override { python3Packages = self; });

  merge3 = callPackage ../development/python-modules/merge3 { };

  mergecal = callPackage ../development/python-modules/mergecal { };

  mergedb = callPackage ../development/python-modules/mergedb { };

  mergedeep = callPackage ../development/python-modules/mergedeep { };

  mergedict = callPackage ../development/python-modules/mergedict { };

  merkletools = callPackage ../development/python-modules/merkletools { };

  meross-iot = callPackage ../development/python-modules/meross-iot { };

  meshcat = callPackage ../development/python-modules/meshcat { };

  meshcore = callPackage ../development/python-modules/meshcore { };

  meshio = callPackage ../development/python-modules/meshio { };

  meshlabxml = callPackage ../development/python-modules/meshlabxml { };

  meshtastic = callPackage ../development/python-modules/meshtastic { };

  meson = toPythonModule (
    (pkgs.meson.override { python3 = python; }).overridePythonAttrs (oldAttrs: {
      # We do not want the setup hook in Python packages because the build is performed differently.
      setupHook = null;
    })
  );

  meson-python = callPackage ../development/python-modules/meson-python { inherit (pkgs) ninja; };

  messagebird = callPackage ../development/python-modules/messagebird { };

  metaflow = callPackage ../development/python-modules/metaflow { };

  metakernel = callPackage ../development/python-modules/metakernel { };

  metar = callPackage ../development/python-modules/metar { };

  metawear = callPackage ../development/python-modules/metawear { };

  meteo-lt-pkg = callPackage ../development/python-modules/meteo-lt-pkg { };

  meteoalertapi = callPackage ../development/python-modules/meteoalertapi { };

  meteocalc = callPackage ../development/python-modules/meteocalc { };

  meteofrance-api = callPackage ../development/python-modules/meteofrance-api { };

  meteoswiss-async = callPackage ../development/python-modules/meteoswiss-async { };

  methodtools = callPackage ../development/python-modules/methodtools { };

  mezzanine = callPackage ../development/python-modules/mezzanine { };

  mf2py = callPackage ../development/python-modules/mf2py { };

  mficlient = callPackage ../development/python-modules/mficlient { };

  mhcflurry = callPackage ../development/python-modules/mhcflurry { };

  mhcgnomes = callPackage ../development/python-modules/mhcgnomes { };

  miasm = callPackage ../development/python-modules/miasm { };

  miauth = callPackage ../development/python-modules/miauth { };

  micawber = callPackage ../development/python-modules/micawber { };

  micloud = callPackage ../development/python-modules/micloud { };

  microbeespy = callPackage ../development/python-modules/microbeespy { };

  microdata = callPackage ../development/python-modules/microdata { };

  microsoft-kiota-abstractions =
    callPackage ../development/python-modules/microsoft-kiota-abstractions
      { };

  microsoft-kiota-authentication-azure =
    callPackage ../development/python-modules/microsoft-kiota-authentication-azure
      { };

  microsoft-kiota-http = callPackage ../development/python-modules/microsoft-kiota-http { };

  microsoft-kiota-serialization-form =
    callPackage ../development/python-modules/microsoft-kiota-serialization-form
      { };

  microsoft-kiota-serialization-json =
    callPackage ../development/python-modules/microsoft-kiota-serialization-json
      { };

  microsoft-kiota-serialization-multipart =
    callPackage ../development/python-modules/microsoft-kiota-serialization-multipart
      { };

  microsoft-kiota-serialization-text =
    callPackage ../development/python-modules/microsoft-kiota-serialization-text
      { };

  microsoft-security-utilities-secret-masker =
    callPackage ../development/python-modules/microsoft-security-utilities-secret-masker
      { };

  midea-beautiful-air = callPackage ../development/python-modules/midea-beautiful-air { };

  midea-local = callPackage ../development/python-modules/midea-local { };

  midiutil = callPackage ../development/python-modules/midiutil { };

  mido = callPackage ../development/python-modules/mido { };

  migen = callPackage ../development/python-modules/migen { };

  mike = callPackage ../development/python-modules/mike { };

  milc = callPackage ../development/python-modules/milc { };

  milksnake = callPackage ../development/python-modules/milksnake { };

  mill-local = callPackage ../development/python-modules/mill-local { };

  millheater = callPackage ../development/python-modules/millheater { };

  mim-solvers = callPackage ../development/python-modules/mim-solvers { inherit (pkgs) mim-solvers; };

  minari = callPackage ../development/python-modules/minari { };

  mindsdb-evaluator = callPackage ../development/python-modules/mindsdb-evaluator { };

  minexr = callPackage ../development/python-modules/minexr { };

  miniaudio = callPackage ../development/python-modules/miniaudio { };

  minichain = callPackage ../development/python-modules/minichain { };

  minidb = callPackage ../development/python-modules/minidb { };

  minidump = callPackage ../development/python-modules/minidump { };

  miniful = callPackage ../development/python-modules/miniful { };

  minify-html = callPackage ../development/python-modules/minify-html { };

  minikanren = callPackage ../development/python-modules/minikanren { };

  minikerberos = callPackage ../development/python-modules/minikerberos { };

  minimal-snowplow-tracker = callPackage ../development/python-modules/minimal-snowplow-tracker { };

  minimock = callPackage ../development/python-modules/minimock { };

  mininet-python = (toPythonModule (pkgs.mininet.override { python3 = python; })).py;

  minio = callPackage ../development/python-modules/minio { };

  miniupnpc = callPackage ../development/python-modules/miniupnpc { };

  mip = callPackage ../development/python-modules/mip { };

  mir-eval = callPackage ../development/python-modules/mir-eval { };

  miraie-ac = callPackage ../development/python-modules/miraie-ac { };

  mirakuru = callPackage ../development/python-modules/mirakuru { };

  misaka = callPackage ../development/python-modules/misaka { };

  misaki = callPackage ../development/python-modules/misaki { };

  misoc = callPackage ../development/python-modules/misoc { };

  miss-hit = callPackage ../development/python-modules/miss-hit { };

  miss-hit-core = callPackage ../development/python-modules/miss-hit-core { };

  mistletoe = callPackage ../development/python-modules/mistletoe { };

  mistral-common = callPackage ../development/python-modules/mistral-common { };

  mistune = callPackage ../development/python-modules/mistune { };

  mitmproxy = callPackage ../development/python-modules/mitmproxy { };

  mitmproxy-linux = callPackage ../development/python-modules/mitmproxy-linux { };

  mitmproxy-macos = callPackage ../development/python-modules/mitmproxy-macos { };

  mitmproxy-rs = callPackage ../development/python-modules/mitmproxy-rs { };

  mitogen = callPackage ../development/python-modules/mitogen { };

  mixbox = callPackage ../development/python-modules/mixbox { };

  mixins = callPackage ../development/python-modules/mixins { };

  mixpanel = callPackage ../development/python-modules/mixpanel { };

  mizani = callPackage ../development/python-modules/mizani { };

  mkdocs = callPackage ../development/python-modules/mkdocs { };

  mkdocs-autolinks-plugin = callPackage ../development/python-modules/mkdocs-autolinks-plugin { };

  mkdocs-autorefs = callPackage ../development/python-modules/mkdocs-autorefs { };

  mkdocs-awesome-nav = callPackage ../development/python-modules/mkdocs-awesome-nav { };

  mkdocs-backlinks = callPackage ../development/python-modules/mkdocs-backlinks { };

  mkdocs-build-plantuml = callPackage ../development/python-modules/mkdocs-build-plantuml { };

  mkdocs-drawio-exporter = callPackage ../development/python-modules/mkdocs-drawio-exporter { };

  mkdocs-drawio-file = callPackage ../development/python-modules/mkdocs-drawio-file { };

  mkdocs-exclude = callPackage ../development/python-modules/mkdocs-exclude { };

  mkdocs-gen-files = callPackage ../development/python-modules/mkdocs-gen-files { };

  mkdocs-get-deps = callPackage ../development/python-modules/mkdocs-get-deps { };

  mkdocs-git-authors-plugin = callPackage ../development/python-modules/mkdocs-git-authors-plugin { };

  mkdocs-git-committers-plugin-2 =
    callPackage ../development/python-modules/mkdocs-git-committers-plugin-2
      { };

  mkdocs-git-revision-date-localized-plugin =
    callPackage ../development/python-modules/mkdocs-git-revision-date-localized-plugin
      { };

  mkdocs-gitlab = callPackage ../development/python-modules/mkdocs-gitlab-plugin { };

  mkdocs-glightbox = callPackage ../development/python-modules/mkdocs-glightbox { };

  mkdocs-graphviz = callPackage ../development/python-modules/mkdocs-graphviz { };

  mkdocs-include-markdown-plugin =
    callPackage ../development/python-modules/mkdocs-include-markdown-plugin
      { };

  mkdocs-jupyter = callPackage ../development/python-modules/mkdocs-jupyter { };

  mkdocs-linkcheck = callPackage ../development/python-modules/mkdocs-linkcheck { };

  mkdocs-literate-nav = callPackage ../development/python-modules/mkdocs-literate-nav { };

  mkdocs-macros-plugin = callPackage ../development/python-modules/mkdocs-macros-plugin { };

  mkdocs-macros-test = callPackage ../development/python-modules/mkdocs-macros-test { };

  mkdocs-markmap = callPackage ../development/python-modules/mkdocs-markmap { };

  mkdocs-material = callPackage ../development/python-modules/mkdocs-material { };

  mkdocs-material-extensions =
    callPackage ../development/python-modules/mkdocs-material/mkdocs-material-extensions.nix
      { };

  mkdocs-mermaid2-plugin = callPackage ../development/python-modules/mkdocs-mermaid2-plugin { };

  mkdocs-minify-plugin = callPackage ../development/python-modules/mkdocs-minify-plugin { };

  mkdocs-puml = callPackage ../development/python-modules/mkdocs-puml { };

  mkdocs-redirects = callPackage ../development/python-modules/mkdocs-redirects { };

  mkdocs-redoc-tag = callPackage ../development/python-modules/mkdocs-redoc-tag { };

  mkdocs-rss-plugin = callPackage ../development/python-modules/mkdocs-rss-plugin { };

  mkdocs-section-index = callPackage ../development/python-modules/mkdocs-section-index { };

  mkdocs-simple-blog = callPackage ../development/python-modules/mkdocs-simple-blog { };

  mkdocs-swagger-ui-tag = callPackage ../development/python-modules/mkdocs-swagger-ui-tag { };

  mkdocs-table-reader-plugin =
    callPackage ../development/python-modules/mkdocs-table-reader-plugin
      { };

  mkdocs-test = callPackage ../development/python-modules/mkdocs-test { };

  mkdocstrings = callPackage ../development/python-modules/mkdocstrings { };

  mkdocstrings-python = callPackage ../development/python-modules/mkdocstrings-python { };

  mkl-service = callPackage ../development/python-modules/mkl-service { };

  mktestdocs = callPackage ../development/python-modules/mktestdocs { };

  ml-collections = callPackage ../development/python-modules/ml-collections { };

  ml-dtypes = callPackage ../development/python-modules/ml-dtypes { };

  mlcroissant = callPackage ../development/python-modules/mlcroissant { };

  mlflow = callPackage ../development/python-modules/mlflow { };

  mlrose = callPackage ../development/python-modules/mlrose { };

  mlt = toPythonModule (
    pkgs.mlt.override {
      python3 = python;
      enablePython = true;
    }
  );

  mlx = callPackage ../development/python-modules/mlx { };

  mlx-lm = callPackage ../development/python-modules/mlx-lm { };

  mlx-vlm = callPackage ../development/python-modules/mlx-vlm { };

  mlxtend = callPackage ../development/python-modules/mlxtend { };

  mmcif-pdbx = callPackage ../development/python-modules/mmcif-pdbx { };

  mmcv = callPackage ../development/python-modules/mmcv { };

  mmengine = callPackage ../development/python-modules/mmengine { };

  mmh3 = callPackage ../development/python-modules/mmh3 { };

  mmpython = callPackage ../development/python-modules/mmpython { };

  mmtf-python = callPackage ../development/python-modules/mmtf-python { };

  mne = callPackage ../development/python-modules/mne { };

  mnemonic = callPackage ../development/python-modules/mnemonic { };

  mnist = callPackage ../development/python-modules/mnist { };

  moat-ble = callPackage ../development/python-modules/moat-ble { };

  mobi = callPackage ../development/python-modules/mobi { };

  mobly = callPackage ../development/python-modules/mobly { };

  mock = callPackage ../development/python-modules/mock { };

  mock-django = callPackage ../development/python-modules/mock-django { };

  mock-open = callPackage ../development/python-modules/mock-open { };

  mock-services = callPackage ../development/python-modules/mock-services { };

  mock-ssh-server = callPackage ../development/python-modules/mock-ssh-server { };

  mocket = callPackage ../development/python-modules/mocket { };

  mockfs = callPackage ../development/python-modules/mockfs { };

  mockito = callPackage ../development/python-modules/mockito { };

  mockupdb = callPackage ../development/python-modules/mockupdb { };

  modbus-tk = callPackage ../development/python-modules/modbus-tk { };

  moddb = callPackage ../development/python-modules/moddb { };

  model-bakery = callPackage ../development/python-modules/model-bakery { };

  model-checker = callPackage ../development/python-modules/model-checker { };

  model-hosting-container-standards =
    callPackage ../development/python-modules/model-hosting-container-standards
      { };

  model-signing = callPackage ../development/python-modules/model-signing { };

  modelcif = callPackage ../development/python-modules/modelcif { };

  modeled = callPackage ../development/python-modules/modeled { };

  modern-colorthief = callPackage ../development/python-modules/modern-colorthief { };

  moderngl = callPackage ../development/python-modules/moderngl { };

  moderngl-window = callPackage ../development/python-modules/moderngl-window {
    inherit (pkgs) mesa;
  };

  moehlenhoff-alpha2 = callPackage ../development/python-modules/moehlenhoff-alpha2 { };

  mohawk = callPackage ../development/python-modules/mohawk { };

  molbar = callPackage ../development/python-modules/molbar { };

  molecule = callPackage ../development/python-modules/molecule { };

  molecule-plugins = callPackage ../development/python-modules/molecule/plugins.nix { };

  momepy = callPackage ../development/python-modules/momepy { };

  momonga = callPackage ../development/python-modules/momonga { };

  monai = callPackage ../development/python-modules/monai { };

  monai-deploy = callPackage ../development/python-modules/monai-deploy { };

  monarchmoney = callPackage ../development/python-modules/monarchmoney { };

  monero = callPackage ../development/python-modules/monero { };

  mongodict = callPackage ../development/python-modules/mongodict { };

  mongoengine = callPackage ../development/python-modules/mongoengine { };

  mongomock = callPackage ../development/python-modules/mongomock { };

  mongoquery = callPackage ../development/python-modules/mongoquery { };

  monitorcontrol = callPackage ../development/python-modules/monitorcontrol { };

  monkeyhex = callPackage ../development/python-modules/monkeyhex { };

  monkeytype = callPackage ../development/python-modules/monkeytype { };

  monosat = pkgs.monosat.python {
    inherit buildPythonPackage;
    inherit (self) cython pytestCheckHook;
  };

  monotonic = callPackage ../development/python-modules/monotonic { };

  monotonic-alignment-search =
    callPackage ../development/python-modules/monotonic-alignment-search
      { };

  monty = callPackage ../development/python-modules/monty { };

  monzopy = callPackage ../development/python-modules/monzopy { };

  moonraker-api = callPackage ../development/python-modules/moonraker-api { };

  mopeka-iot-ble = callPackage ../development/python-modules/mopeka-iot-ble { };

  mopidyapi = callPackage ../development/python-modules/mopidyapi { };

  more-itertools = callPackage ../development/python-modules/more-itertools { };

  more-properties = callPackage ../development/python-modules/more-properties { };

  morecantile = callPackage ../development/python-modules/morecantile { };

  moreorless = callPackage ../development/python-modules/moreorless { };

  moretools = callPackage ../development/python-modules/moretools { };

  morfessor = callPackage ../development/python-modules/morfessor { };

  morphys = callPackage ../development/python-modules/morphys { };

  mortgage = callPackage ../development/python-modules/mortgage { };

  motionblinds = callPackage ../development/python-modules/motionblinds { };

  motionblindsble = callPackage ../development/python-modules/motionblindsble { };

  motioneye-client = callPackage ../development/python-modules/motioneye-client { };

  motmetrics = callPackage ../development/python-modules/motmetrics { };

  moto = callPackage ../development/python-modules/moto { };

  motor = callPackage ../development/python-modules/motor { };

  mouseinfo = callPackage ../development/python-modules/mouseinfo { };

  moviepy = callPackage ../development/python-modules/moviepy { };

  moyopy = callPackage ../development/python-modules/moyopy { };

  mozart-api = callPackage ../development/python-modules/mozart-api { };

  mozilla-django-oidc = callPackage ../development/python-modules/mozilla-django-oidc { };

  mozjpeg_lossless_optimization =
    callPackage ../development/python-modules/mozjpeg_lossless_optimization
      { };

  mpd2 = callPackage ../development/python-modules/mpd2 { };

  mpegdash = callPackage ../development/python-modules/mpegdash { };

  mpi-pytest = callPackage ../development/python-modules/mpi-pytest { };

  mpi4py = callPackage ../development/python-modules/mpi4py { };

  mpire = callPackage ../development/python-modules/mpire { };

  mpl-scatter-density = callPackage ../development/python-modules/mpl-scatter-density { };

  mpl-typst = callPackage ../development/python-modules/mpl-typst {
    inherit (pkgs) typst;
  };

  mplcursors = callPackage ../development/python-modules/mplcursors { };

  mpldatacursor = callPackage ../development/python-modules/mpldatacursor { };

  mplfinance = callPackage ../development/python-modules/mplfinance { };

  mplhep = callPackage ../development/python-modules/mplhep { };

  mplhep-data = callPackage ../development/python-modules/mplhep-data { };

  mplleaflet = callPackage ../development/python-modules/mplleaflet { };

  mpltoolbox = callPackage ../development/python-modules/mpltoolbox { };

  mpmath = callPackage ../development/python-modules/mpmath { };

  mpris-server = callPackage ../development/python-modules/mpris-server { };

  mprisify = callPackage ../development/python-modules/mprisify { };

  mpv = callPackage ../development/python-modules/mpv { inherit (pkgs) mpv; };

  mpyq = callPackage ../development/python-modules/mpyq { };

  mqtt2influxdb = callPackage ../development/python-modules/mqtt2influxdb { };

  mrjob = callPackage ../development/python-modules/mrjob { };

  mrsqm = callPackage ../development/python-modules/mrsqm { };

  ms-active-directory = callPackage ../development/python-modules/ms-active-directory { };

  ms-cv = callPackage ../development/python-modules/ms-cv { };

  msal = callPackage ../development/python-modules/msal { };

  msal-extensions = callPackage ../development/python-modules/msal-extensions { };

  mscerts = callPackage ../development/python-modules/mscerts { };

  msg-parser = callPackage ../development/python-modules/msg-parser { };

  msgpack = callPackage ../development/python-modules/msgpack { };

  msgpack-numpy = callPackage ../development/python-modules/msgpack-numpy { };

  msgraph-core = callPackage ../development/python-modules/msgraph-core { };

  msgraph-sdk = callPackage ../development/python-modules/msgraph-sdk { };

  msgspec = callPackage ../development/python-modules/msgspec { };

  msldap = callPackage ../development/python-modules/msldap { };

  mslex = callPackage ../development/python-modules/mslex { };

  msmart-ng = callPackage ../development/python-modules/msmart-ng { };

  msoffcrypto-tool = callPackage ../development/python-modules/msoffcrypto-tool { };

  msprime = callPackage ../development/python-modules/msprime { };

  msrest = callPackage ../development/python-modules/msrest { };

  msrestazure = callPackage ../development/python-modules/msrestazure { };

  msrplib = callPackage ../development/python-modules/msrplib { };

  mss = callPackage ../development/python-modules/mss { };

  msticpy = callPackage ../development/python-modules/msticpy { };

  mt-940 = callPackage ../development/python-modules/mt-940 { };

  mtcnn = callPackage ../development/python-modules/mtcnn { };

  mujoco = callPackage ../development/python-modules/mujoco { inherit (pkgs) mujoco; };

  mujoco-mjx = callPackage ../development/python-modules/mujoco-mjx { mujoco-main = pkgs.mujoco; };

  mujson = callPackage ../development/python-modules/mujson { };

  mullvad-api = callPackage ../development/python-modules/mullvad-api { };

  mullvad-closest = callPackage ../development/python-modules/mullvad-closest { };

  mulpyplexer = callPackage ../development/python-modules/mulpyplexer { };

  multi-key-dict = callPackage ../development/python-modules/multi-key-dict { };

  multidict = callPackage ../development/python-modules/multidict { };

  multimethod = callPackage ../development/python-modules/multimethod { };

  multipart = callPackage ../development/python-modules/multipart { };

  multipledispatch = callPackage ../development/python-modules/multipledispatch { };

  multiprocess = callPackage ../development/python-modules/multiprocess { };

  multiscale-spatial-image = callPackage ../development/python-modules/multiscale-spatial-image { };

  multiset = callPackage ../development/python-modules/multiset { };

  multitasking = callPackage ../development/python-modules/multitasking { };

  multivolumefile = callPackage ../development/python-modules/multivolumefile { };

  munch = callPackage ../development/python-modules/munch { };

  mung = callPackage ../development/python-modules/mung { };

  munkres = callPackage ../development/python-modules/munkres { };

  murmurhash = callPackage ../development/python-modules/murmurhash { };

  muscima = callPackage ../development/python-modules/muscima { };

  music-assistant-client = callPackage ../development/python-modules/music-assistant-client { };

  music-assistant-models = callPackage ../development/python-modules/music-assistant-models { };

  music-tag = callPackage ../development/python-modules/music-tag { };

  musicbrainzngs = callPackage ../development/python-modules/musicbrainzngs { };

  mutagen = callPackage ../development/python-modules/mutagen { };

  mutatormath = callPackage ../development/python-modules/mutatormath { };

  mutesync = callPackage ../development/python-modules/mutesync { };

  mutf8 = callPackage ../development/python-modules/mutf8 { };

  mwcli = callPackage ../development/python-modules/mwcli { };

  mwclient = callPackage ../development/python-modules/mwclient { };

  mwdblib = callPackage ../development/python-modules/mwdblib { };

  mwoauth = callPackage ../development/python-modules/mwoauth { };

  mwparserfromhell = callPackage ../development/python-modules/mwparserfromhell { };

  mwtypes = callPackage ../development/python-modules/mwtypes { };

  mwxml = callPackage ../development/python-modules/mwxml { };

  mxnet = callPackage ../development/python-modules/mxnet { };

  myfitnesspal = callPackage ../development/python-modules/myfitnesspal { };

  mygene = callPackage ../development/python-modules/mygene { };

  mygpoclient = callPackage ../development/python-modules/mygpoclient { };

  myhdl = callPackage ../development/python-modules/myhdl { inherit (pkgs) ghdl iverilog; };

  myhome = callPackage ../development/python-modules/myhome { };

  myjwt = callPackage ../development/python-modules/myjwt { };

  mypermobil = callPackage ../development/python-modules/mypermobil { };

  mypy = callPackage ../development/python-modules/mypy { };

  inherit (callPackage ../development/python-modules/mypy-boto3 { })
    mypy-boto3-accessanalyzer
    mypy-boto3-account
    mypy-boto3-acm
    mypy-boto3-acm-pca
    mypy-boto3-amp
    mypy-boto3-amplify
    mypy-boto3-amplifybackend
    mypy-boto3-amplifyuibuilder
    mypy-boto3-apigateway
    mypy-boto3-apigatewaymanagementapi
    mypy-boto3-apigatewayv2
    mypy-boto3-appconfig
    mypy-boto3-appconfigdata
    mypy-boto3-appfabric
    mypy-boto3-appflow
    mypy-boto3-appintegrations
    mypy-boto3-application-autoscaling
    mypy-boto3-application-insights
    mypy-boto3-applicationcostprofiler
    mypy-boto3-appmesh
    mypy-boto3-apprunner
    mypy-boto3-appstream
    mypy-boto3-appsync
    mypy-boto3-arc-zonal-shift
    mypy-boto3-athena
    mypy-boto3-auditmanager
    mypy-boto3-autoscaling
    mypy-boto3-autoscaling-plans
    mypy-boto3-backup
    mypy-boto3-backup-gateway
    mypy-boto3-batch
    mypy-boto3-billingconductor
    mypy-boto3-braket
    mypy-boto3-budgets
    mypy-boto3-ce
    mypy-boto3-chime
    mypy-boto3-chime-sdk-identity
    mypy-boto3-chime-sdk-media-pipelines
    mypy-boto3-chime-sdk-meetings
    mypy-boto3-chime-sdk-messaging
    mypy-boto3-chime-sdk-voice
    mypy-boto3-cleanrooms
    mypy-boto3-cloud9
    mypy-boto3-cloudcontrol
    mypy-boto3-clouddirectory
    mypy-boto3-cloudformation
    mypy-boto3-cloudfront
    mypy-boto3-cloudhsm
    mypy-boto3-cloudhsmv2
    mypy-boto3-cloudsearch
    mypy-boto3-cloudsearchdomain
    mypy-boto3-cloudtrail
    mypy-boto3-cloudtrail-data
    mypy-boto3-cloudwatch
    mypy-boto3-codeartifact
    mypy-boto3-codebuild
    mypy-boto3-codecatalyst
    mypy-boto3-codecommit
    mypy-boto3-codedeploy
    mypy-boto3-codeguru-reviewer
    mypy-boto3-codeguru-security
    mypy-boto3-codeguruprofiler
    mypy-boto3-codepipeline
    mypy-boto3-codestar
    mypy-boto3-codestar-connections
    mypy-boto3-codestar-notifications
    mypy-boto3-cognito-identity
    mypy-boto3-cognito-idp
    mypy-boto3-cognito-sync
    mypy-boto3-comprehend
    mypy-boto3-comprehendmedical
    mypy-boto3-compute-optimizer
    mypy-boto3-config
    mypy-boto3-connect
    mypy-boto3-connect-contact-lens
    mypy-boto3-connectcampaigns
    mypy-boto3-connectcases
    mypy-boto3-connectparticipant
    mypy-boto3-controltower
    mypy-boto3-cur
    mypy-boto3-customer-profiles
    mypy-boto3-databrew
    mypy-boto3-dataexchange
    mypy-boto3-datapipeline
    mypy-boto3-datasync
    mypy-boto3-dax
    mypy-boto3-detective
    mypy-boto3-devicefarm
    mypy-boto3-devops-guru
    mypy-boto3-directconnect
    mypy-boto3-discovery
    mypy-boto3-dlm
    mypy-boto3-dms
    mypy-boto3-docdb
    mypy-boto3-docdb-elastic
    mypy-boto3-drs
    mypy-boto3-ds
    mypy-boto3-dynamodb
    mypy-boto3-dynamodbstreams
    mypy-boto3-ebs
    mypy-boto3-ec2
    mypy-boto3-ec2-instance-connect
    mypy-boto3-ecr
    mypy-boto3-ecr-public
    mypy-boto3-ecs
    mypy-boto3-efs
    mypy-boto3-eks
    mypy-boto3-elastic-inference
    mypy-boto3-elasticache
    mypy-boto3-elasticbeanstalk
    mypy-boto3-elastictranscoder
    mypy-boto3-elb
    mypy-boto3-elbv2
    mypy-boto3-emr
    mypy-boto3-emr-containers
    mypy-boto3-emr-serverless
    mypy-boto3-entityresolution
    mypy-boto3-es
    mypy-boto3-events
    mypy-boto3-evidently
    mypy-boto3-finspace
    mypy-boto3-finspace-data
    mypy-boto3-firehose
    mypy-boto3-fis
    mypy-boto3-fms
    mypy-boto3-forecast
    mypy-boto3-forecastquery
    mypy-boto3-frauddetector
    mypy-boto3-fsx
    mypy-boto3-gamelift
    mypy-boto3-glacier
    mypy-boto3-globalaccelerator
    mypy-boto3-glue
    mypy-boto3-grafana
    mypy-boto3-greengrass
    mypy-boto3-greengrassv2
    mypy-boto3-groundstation
    mypy-boto3-guardduty
    mypy-boto3-health
    mypy-boto3-healthlake
    mypy-boto3-iam
    mypy-boto3-identitystore
    mypy-boto3-imagebuilder
    mypy-boto3-importexport
    mypy-boto3-inspector
    mypy-boto3-inspector2
    mypy-boto3-internetmonitor
    mypy-boto3-iot
    mypy-boto3-iot-data
    mypy-boto3-iot-jobs-data
    mypy-boto3-iot1click-devices
    mypy-boto3-iot1click-projects
    mypy-boto3-iotanalytics
    mypy-boto3-iotdeviceadvisor
    mypy-boto3-iotevents
    mypy-boto3-iotevents-data
    mypy-boto3-iotfleethub
    mypy-boto3-iotfleetwise
    mypy-boto3-iotsecuretunneling
    mypy-boto3-iotsitewise
    mypy-boto3-iotthingsgraph
    mypy-boto3-iottwinmaker
    mypy-boto3-iotwireless
    mypy-boto3-ivs
    mypy-boto3-ivs-realtime
    mypy-boto3-ivschat
    mypy-boto3-kafka
    mypy-boto3-kafkaconnect
    mypy-boto3-kendra
    mypy-boto3-kendra-ranking
    mypy-boto3-keyspaces
    mypy-boto3-kinesis
    mypy-boto3-kinesis-video-archived-media
    mypy-boto3-kinesis-video-media
    mypy-boto3-kinesis-video-signaling
    mypy-boto3-kinesis-video-webrtc-storage
    mypy-boto3-kinesisanalytics
    mypy-boto3-kinesisanalyticsv2
    mypy-boto3-kinesisvideo
    mypy-boto3-kms
    mypy-boto3-lakeformation
    mypy-boto3-lambda
    mypy-boto3-lex-models
    mypy-boto3-lex-runtime
    mypy-boto3-lexv2-models
    mypy-boto3-lexv2-runtime
    mypy-boto3-license-manager
    mypy-boto3-license-manager-linux-subscriptions
    mypy-boto3-license-manager-user-subscriptions
    mypy-boto3-lightsail
    mypy-boto3-location
    mypy-boto3-logs
    mypy-boto3-lookoutequipment
    mypy-boto3-lookoutmetrics
    mypy-boto3-lookoutvision
    mypy-boto3-m2
    mypy-boto3-machinelearning
    mypy-boto3-macie2
    mypy-boto3-managedblockchain
    mypy-boto3-managedblockchain-query
    mypy-boto3-marketplace-catalog
    mypy-boto3-marketplace-entitlement
    mypy-boto3-marketplacecommerceanalytics
    mypy-boto3-mediaconnect
    mypy-boto3-mediaconvert
    mypy-boto3-medialive
    mypy-boto3-mediapackage
    mypy-boto3-mediapackage-vod
    mypy-boto3-mediapackagev2
    mypy-boto3-mediastore
    mypy-boto3-mediastore-data
    mypy-boto3-mediatailor
    mypy-boto3-medical-imaging
    mypy-boto3-memorydb
    mypy-boto3-meteringmarketplace
    mypy-boto3-mgh
    mypy-boto3-mgn
    mypy-boto3-migration-hub-refactor-spaces
    mypy-boto3-migrationhub-config
    mypy-boto3-migrationhuborchestrator
    mypy-boto3-migrationhubstrategy
    mypy-boto3-mq
    mypy-boto3-mturk
    mypy-boto3-mwaa
    mypy-boto3-neptune
    mypy-boto3-neptunedata
    mypy-boto3-network-firewall
    mypy-boto3-networkmanager
    mypy-boto3-nimble
    mypy-boto3-oam
    mypy-boto3-omics
    mypy-boto3-opensearch
    mypy-boto3-opensearchserverless
    mypy-boto3-opsworks
    mypy-boto3-opsworkscm
    mypy-boto3-organizations
    mypy-boto3-osis
    mypy-boto3-outposts
    mypy-boto3-panorama
    mypy-boto3-payment-cryptography
    mypy-boto3-payment-cryptography-data
    mypy-boto3-pca-connector-ad
    mypy-boto3-personalize
    mypy-boto3-personalize-events
    mypy-boto3-personalize-runtime
    mypy-boto3-pi
    mypy-boto3-pinpoint
    mypy-boto3-pinpoint-email
    mypy-boto3-pinpoint-sms-voice
    mypy-boto3-pinpoint-sms-voice-v2
    mypy-boto3-pipes
    mypy-boto3-polly
    mypy-boto3-pricing
    mypy-boto3-privatenetworks
    mypy-boto3-proton
    mypy-boto3-qldb
    mypy-boto3-qldb-session
    mypy-boto3-quicksight
    mypy-boto3-ram
    mypy-boto3-rbin
    mypy-boto3-rds
    mypy-boto3-rds-data
    mypy-boto3-redshift
    mypy-boto3-redshift-data
    mypy-boto3-redshift-serverless
    mypy-boto3-rekognition
    mypy-boto3-resiliencehub
    mypy-boto3-resource-explorer-2
    mypy-boto3-resource-groups
    mypy-boto3-resourcegroupstaggingapi
    mypy-boto3-robomaker
    mypy-boto3-rolesanywhere
    mypy-boto3-route53
    mypy-boto3-route53-recovery-cluster
    mypy-boto3-route53-recovery-control-config
    mypy-boto3-route53-recovery-readiness
    mypy-boto3-route53domains
    mypy-boto3-route53resolver
    mypy-boto3-rum
    mypy-boto3-s3
    mypy-boto3-s3control
    mypy-boto3-s3outposts
    mypy-boto3-sagemaker
    mypy-boto3-sagemaker-a2i-runtime
    mypy-boto3-sagemaker-edge
    mypy-boto3-sagemaker-featurestore-runtime
    mypy-boto3-sagemaker-geospatial
    mypy-boto3-sagemaker-metrics
    mypy-boto3-sagemaker-runtime
    mypy-boto3-savingsplans
    mypy-boto3-scheduler
    mypy-boto3-schemas
    mypy-boto3-sdb
    mypy-boto3-secretsmanager
    mypy-boto3-securityhub
    mypy-boto3-securitylake
    mypy-boto3-serverlessrepo
    mypy-boto3-service-quotas
    mypy-boto3-servicecatalog
    mypy-boto3-servicecatalog-appregistry
    mypy-boto3-servicediscovery
    mypy-boto3-ses
    mypy-boto3-sesv2
    mypy-boto3-shield
    mypy-boto3-signer
    mypy-boto3-simspaceweaver
    mypy-boto3-sms
    mypy-boto3-sms-voice
    mypy-boto3-snow-device-management
    mypy-boto3-snowball
    mypy-boto3-sns
    mypy-boto3-sqs
    mypy-boto3-ssm
    mypy-boto3-ssm-contacts
    mypy-boto3-ssm-incidents
    mypy-boto3-ssm-sap
    mypy-boto3-sso
    mypy-boto3-sso-admin
    mypy-boto3-sso-oidc
    mypy-boto3-stepfunctions
    mypy-boto3-storagegateway
    mypy-boto3-sts
    mypy-boto3-support
    mypy-boto3-support-app
    mypy-boto3-swf
    mypy-boto3-synthetics
    mypy-boto3-textract
    mypy-boto3-timestream-query
    mypy-boto3-timestream-write
    mypy-boto3-tnb
    mypy-boto3-transcribe
    mypy-boto3-transfer
    mypy-boto3-translate
    mypy-boto3-verifiedpermissions
    mypy-boto3-voice-id
    mypy-boto3-vpc-lattice
    mypy-boto3-waf
    mypy-boto3-waf-regional
    mypy-boto3-wafv2
    mypy-boto3-wellarchitected
    mypy-boto3-wisdom
    mypy-boto3-workdocs
    mypy-boto3-worklink
    mypy-boto3-workmail
    mypy-boto3-workmailmessageflow
    mypy-boto3-workspaces
    mypy-boto3-workspaces-web
    mypy-boto3-xray
    ;

  mypy-boto3-builder = callPackage ../development/python-modules/mypy-boto3-builder { };

  mypy-extensions = callPackage ../development/python-modules/mypy/extensions.nix { };

  mypy-protobuf = callPackage ../development/python-modules/mypy-protobuf { };

  mysql-connector = callPackage ../development/python-modules/mysql-connector { };

  mysqlclient = callPackage ../development/python-modules/mysqlclient { };

  myst-docutils = callPackage ../development/python-modules/myst-docutils { };

  myst-nb = callPackage ../development/python-modules/myst-nb { };

  myst-parser = callPackage ../development/python-modules/myst-parser { };

  myuplink = callPackage ../development/python-modules/myuplink { };

  nad-receiver = callPackage ../development/python-modules/nad-receiver { };

  nagiosplugin = callPackage ../development/python-modules/nagiosplugin { };

  naked = callPackage ../development/python-modules/naked { };

  name-that-hash = callPackage ../development/python-modules/name-that-hash { };

  namedlist = callPackage ../development/python-modules/namedlist { };

  nameko = callPackage ../development/python-modules/nameko { };

  nameparser = callPackage ../development/python-modules/nameparser { };

  names = callPackage ../development/python-modules/names { };

  namex = callPackage ../development/python-modules/namex { };

  nampa = callPackage ../development/python-modules/nampa { };

  nanobind = callPackage ../development/python-modules/nanobind { };

  nanoeigenpy = callPackage ../development/python-modules/nanoeigenpy { };

  nanoemoji = callPackage ../development/python-modules/nanoemoji { };

  nanoid = callPackage ../development/python-modules/nanoid { };

  nanoleaf = callPackage ../development/python-modules/nanoleaf { };

  nanomsg-python = callPackage ../development/python-modules/nanomsg-python {
    inherit (pkgs) nanomsg;
  };

  nanotime = callPackage ../development/python-modules/nanotime { };

  napalm = callPackage ../development/python-modules/napalm { };

  napalm-hp-procurve = callPackage ../development/python-modules/napalm/hp-procurve.nix { };

  napalm-ros = callPackage ../development/python-modules/napalm/ros.nix { };

  napari = callPackage ../development/python-modules/napari {
    inherit (pkgs.libsForQt5) mkDerivationWith wrapQtAppsHook;
  };

  napari-console = callPackage ../development/python-modules/napari-console { };

  napari-nifti = callPackage ../development/python-modules/napari-nifti { };

  napari-npe2 = callPackage ../development/python-modules/napari-npe2 { };

  napari-plugin-engine = callPackage ../development/python-modules/napari-plugin-engine { };

  napari-svg = callPackage ../development/python-modules/napari-svg { };

  narwhals = callPackage ../development/python-modules/narwhals { };

  nasdaq-data-link = callPackage ../development/python-modules/nasdaq-data-link { };

  natasha = callPackage ../development/python-modules/natasha { };

  nats-py = callPackage ../development/python-modules/nats-py { };

  nats-python = callPackage ../development/python-modules/nats-python { };

  natsort = callPackage ../development/python-modules/natsort { };

  natural = callPackage ../development/python-modules/natural { };

  naturalsort = callPackage ../development/python-modules/naturalsort { };

  navec = callPackage ../development/python-modules/navec { };

  nbclassic = callPackage ../development/python-modules/nbclassic { };

  nbclient = callPackage ../development/python-modules/nbclient { };

  nbconflux = callPackage ../development/python-modules/nbconflux { };

  nbconvert = callPackage ../development/python-modules/nbconvert { };

  nbdev = callPackage ../development/python-modules/nbdev { };

  nbdime = callPackage ../development/python-modules/nbdime { };

  nbexec = callPackage ../development/python-modules/nbexec { };

  nbformat = callPackage ../development/python-modules/nbformat { };

  nbmake = callPackage ../development/python-modules/nbmake { };

  nbsmoke = callPackage ../development/python-modules/nbsmoke { };

  nbsphinx = callPackage ../development/python-modules/nbsphinx { };

  nbtlib = callPackage ../development/python-modules/nbtlib { };

  nbval = callPackage ../development/python-modules/nbval { };

  nbxmpp = callPackage ../development/python-modules/nbxmpp { };

  nc-dnsapi = callPackage ../development/python-modules/nc-dnsapi { };

  ncclient = callPackage ../development/python-modules/ncclient { };

  nclib = callPackage ../development/python-modules/nclib { };

  ndcurves = callPackage ../development/python-modules/ndcurves { inherit (pkgs) ndcurves; };

  ndeflib = callPackage ../development/python-modules/ndeflib { };

  ndg-httpsclient = callPackage ../development/python-modules/ndg-httpsclient { };

  ndindex = callPackage ../development/python-modules/ndindex { };

  ndjson = callPackage ../development/python-modules/ndjson { };

  ndms2-client = callPackage ../development/python-modules/ndms2-client { };

  ndspy = callPackage ../development/python-modules/ndspy { };

  ndtypes = callPackage ../development/python-modules/ndtypes { };

  nebula3-python = callPackage ../development/python-modules/nebula3-python { };

  nemosis = callPackage ../development/python-modules/nemosis { };

  nengo = callPackage ../development/python-modules/nengo { };

  neo = callPackage ../development/python-modules/neo { };

  neo4j = callPackage ../development/python-modules/neo4j { };

  neoteroi-mkdocs = callPackage ../development/python-modules/neoteroi-mkdocs { };

  nessclient = callPackage ../development/python-modules/nessclient { };

  nest = toPythonModule (
    pkgs.nest-mpi.override {
      withPython = true;
      python3 = python;
    }
  );

  nest-asyncio = callPackage ../development/python-modules/nest-asyncio { };

  nested-lookup = callPackage ../development/python-modules/nested-lookup { };

  nested-multipart-parser = callPackage ../development/python-modules/nested-multipart-parser { };

  nestedtext = callPackage ../development/python-modules/nestedtext { };

  netaddr = callPackage ../development/python-modules/netaddr { };

  netapp-lib = callPackage ../development/python-modules/netapp-lib { };

  netapp-ontap = callPackage ../development/python-modules/netapp-ontap { };

  netbox-attachments = callPackage ../development/python-modules/netbox-attachments { };

  netbox-bgp = callPackage ../development/python-modules/netbox-bgp { };

  netbox-contextmenus = callPackage ../development/python-modules/netbox-contextmenus { };

  netbox-contract = callPackage ../development/python-modules/netbox-contract { };

  netbox-dns = callPackage ../development/python-modules/netbox-dns { };

  netbox-documents = callPackage ../development/python-modules/netbox-documents { };

  netbox-floorplan-plugin = callPackage ../development/python-modules/netbox-floorplan-plugin { };

  netbox-interface-synchronization =
    callPackage ../development/python-modules/netbox-interface-synchronization
      { };

  netbox-napalm-plugin = callPackage ../development/python-modules/netbox-napalm-plugin { };

  netbox-plugin-prometheus-sd =
    callPackage ../development/python-modules/netbox-plugin-prometheus-sd
      { };

  netbox-qrcode = callPackage ../development/python-modules/netbox-qrcode { };

  netbox-reorder-rack = callPackage ../development/python-modules/netbox-reorder-rack { };

  netbox-routing = callPackage ../development/python-modules/netbox-routing { };

  netbox-topology-views = callPackage ../development/python-modules/netbox-topology-views { };

  netcdf4 = callPackage ../development/python-modules/netcdf4 { };

  netdata = callPackage ../development/python-modules/netdata { };

  netdata-pandas = callPackage ../development/python-modules/netdata-pandas { };

  netdisco = callPackage ../development/python-modules/netdisco { };

  netgen-mesher = toPythonModule (pkgs.netgen.override { python3Packages = self; });

  nethsm = callPackage ../development/python-modules/nethsm { };

  netifaces = callPackage ../development/python-modules/netifaces { };

  netifaces-plus = callPackage ../development/python-modules/netifaces-plus { };

  netifaces2 = callPackage ../development/python-modules/netifaces2 { };

  netio = callPackage ../development/python-modules/netio { };

  netmap = callPackage ../development/python-modules/netmap { };

  netmiko = callPackage ../development/python-modules/netmiko { };

  nettigo-air-monitor = callPackage ../development/python-modules/nettigo-air-monitor { };

  netutils = callPackage ../development/python-modules/netutils { };

  networkx = callPackage ../development/python-modules/networkx { };

  neuralfoil = callPackage ../development/python-modules/neuralfoil { };

  neurio = callPackage ../development/python-modules/neurio { };

  neurokit2 = callPackage ../development/python-modules/neurokit2 { };

  neuron-full = pkgs.neuron-full.override { python3 = python; };

  neuronpy = toPythonModule neuron-full;

  nevow = callPackage ../development/python-modules/nevow { };

  newick = callPackage ../development/python-modules/newick { };

  newspaper3k = callPackage ../development/python-modules/newspaper3k { };

  newversion = callPackage ../development/python-modules/newversion { };

  nexia = callPackage ../development/python-modules/nexia { };

  nextcloudmonitor = callPackage ../development/python-modules/nextcloudmonitor { };

  nextcord = callPackage ../development/python-modules/nextcord { };

  nextdns = callPackage ../development/python-modules/nextdns { };

  nexusformat = callPackage ../development/python-modules/nexusformat { };

  nexusrpc = callPackage ../development/python-modules/nexusrpc { };

  nfcpy = callPackage ../development/python-modules/nfcpy { };

  nftables = callPackage ../os-specific/linux/nftables/python.nix { inherit (pkgs) nftables; };

  nglview = callPackage ../development/python-modules/nglview { };

  nh3 = callPackage ../development/python-modules/nh3 { };

  nhc = callPackage ../development/python-modules/nhc { };

  niaaml = callPackage ../development/python-modules/niaaml { };

  niaarm = callPackage ../development/python-modules/niaarm { };

  niaclass = callPackage ../development/python-modules/niaclass { };

  nianet = callPackage ../development/python-modules/nianet { };

  niapy = callPackage ../development/python-modules/niapy { };

  nibabel = callPackage ../development/python-modules/nibabel { };

  nibe = callPackage ../development/python-modules/nibe { };

  nice-go = callPackage ../development/python-modules/nice-go { };

  nicegui = callPackage ../development/python-modules/nicegui { };

  nicegui-highcharts = callPackage ../development/python-modules/nicegui-highcharts { };

  nidaqmx = callPackage ../development/python-modules/nidaqmx { };

  nifty8 = callPackage ../development/python-modules/nifty8 { };

  nikola = callPackage ../development/python-modules/nikola { };

  nilearn = callPackage ../development/python-modules/nilearn { };

  niluclient = callPackage ../development/python-modules/niluclient { };

  nimfa = callPackage ../development/python-modules/nimfa { };

  nine = callPackage ../development/python-modules/nine { };

  ninebot-ble = callPackage ../development/python-modules/ninebot-ble { };

  ninja = callPackage ../development/python-modules/ninja { inherit (pkgs) ninja; };

  nipap = callPackage ../development/python-modules/nipap { };

  nipreps-versions = callPackage ../development/python-modules/nipreps-versions { };

  nipy = callPackage ../development/python-modules/nipy { };

  nipype = callPackage ../development/python-modules/nipype { inherit (pkgs) which; };

  niquests = callPackage ../development/python-modules/niquests { };

  nitime = callPackage ../development/python-modules/nitime { };

  nitransforms = callPackage ../development/python-modules/nitransforms { };

  nitrokey = callPackage ../development/python-modules/nitrokey { };

  niworkflows = callPackage ../development/python-modules/niworkflows { };

  nix-kernel = callPackage ../development/python-modules/nix-kernel { inherit (pkgs) nix; };

  nix-prefetch-github = callPackage ../development/python-modules/nix-prefetch-github { };

  nixpkgs-plugin-update = callPackage ../development/python-modules/nixpkgs-plugin-update { };

  nixpkgs-pytools = callPackage ../development/python-modules/nixpkgs-pytools { };

  nixpkgs-updaters-library = callPackage ../development/python-modules/nixpkgs-updaters-library { };

  nkdfu = callPackage ../development/python-modules/nkdfu { };

  nlopt = callPackage ../development/python-modules/nlopt { };

  nlpcloud = callPackage ../development/python-modules/nlpcloud { };

  nlpo3 = callPackage ../development/python-modules/nlpo3 { };

  nltk = callPackage ../development/python-modules/nltk { };

  nmapthon2 = callPackage ../development/python-modules/nmapthon2 { };

  nmcli = callPackage ../development/python-modules/nmcli { };

  nnpdf = toPythonModule (pkgs.nnpdf.override { python3 = python; });

  noaa-coops = callPackage ../development/python-modules/noaa-coops { };

  nocasedict = callPackage ../development/python-modules/nocasedict { };

  nocaselist = callPackage ../development/python-modules/nocaselist { };

  nocturne = callPackage ../development/python-modules/nocturne { };

  node-semver = callPackage ../development/python-modules/node-semver { };

  nodeenv = callPackage ../development/python-modules/nodeenv { };

  nodepy-runtime = callPackage ../development/python-modules/nodepy-runtime { };

  nodriver = callPackage ../development/python-modules/nodriver { };

  noise = callPackage ../development/python-modules/noise { };

  noiseprotocol = callPackage ../development/python-modules/noiseprotocol { };

  noisereduce = callPackage ../development/python-modules/noisereduce { };

  nomadnet = callPackage ../development/python-modules/nomadnet { };

  nominal = callPackage ../development/python-modules/nominal { };

  nominal-api = callPackage ../development/python-modules/nominal-api { };

  nominal-api-protos = callPackage ../development/python-modules/nominal-api-protos { };

  nominatim-api = callPackage ../by-name/no/nominatim/nominatim-api.nix { };

  nonbloat-db = callPackage ../development/python-modules/nonbloat-db { };

  noneprompt = callPackage ../development/python-modules/noneprompt { };

  nonestorage = callPackage ../development/python-modules/nonestorage { };

  norfair = callPackage ../development/python-modules/norfair { };

  normality = callPackage ../development/python-modules/normality { };

  nose2 = callPackage ../development/python-modules/nose2 { };

  nose2pytest = callPackage ../development/python-modules/nose2pytest { };

  notebook = callPackage ../development/python-modules/notebook { };

  notebook-shim = callPackage ../development/python-modules/notebook-shim { };

  notedown = callPackage ../development/python-modules/notedown { };

  notifications-android-tv = callPackage ../development/python-modules/notifications-android-tv { };

  notifications-python-client =
    callPackage ../development/python-modules/notifications-python-client
      { };

  notify-events = callPackage ../development/python-modules/notify-events { };

  notify-py = callPackage ../development/python-modules/notify-py { };

  notify2 = callPackage ../development/python-modules/notify2 { };

  notion-client = callPackage ../development/python-modules/notion-client { };

  notmuch = callPackage ../development/python-modules/notmuch { inherit (pkgs) notmuch; };

  notmuch2 = callPackage ../development/python-modules/notmuch2 { inherit (pkgs) notmuch; };

  notobuilder = callPackage ../development/python-modules/notobuilder { };

  notus-scanner = callPackage ../development/python-modules/notus-scanner { };

  nox = callPackage ../development/python-modules/nox { };

  nplusone = callPackage ../development/python-modules/nplusone { };

  nptyping = callPackage ../development/python-modules/nptyping { };

  npyscreen = callPackage ../development/python-modules/npyscreen { };

  nsapi = callPackage ../development/python-modules/nsapi { };

  nskeyedunarchiver = callPackage ../development/python-modules/nskeyedunarchiver { };

  nsw-fuel-api-client = callPackage ../development/python-modules/nsw-fuel-api-client { };

  nsz = callPackage ../development/python-modules/nsz { };

  ntc-templates = callPackage ../development/python-modules/ntc-templates { };

  ntfy-webpush = callPackage ../development/python-modules/ntfy-webpush { };

  ntplib = callPackage ../development/python-modules/ntplib { };

  nuclear = callPackage ../development/python-modules/nuclear { };

  nuheat = callPackage ../development/python-modules/nuheat { };

  nuitka = callPackage ../development/python-modules/nuitka { };

  nulltype = callPackage ../development/python-modules/nulltype { };

  num2words = callPackage ../development/python-modules/num2words { };

  numato-gpio = callPackage ../development/python-modules/numato-gpio { };

  numba = callPackage ../development/python-modules/numba { inherit (pkgs.config) cudaSupport; };

  numba-scipy = callPackage ../development/python-modules/numba-scipy { };

  numbaWithCuda = self.numba.override { cudaSupport = true; };

  numbagg = callPackage ../development/python-modules/numbagg { };

  numcodecs = callPackage ../development/python-modules/numcodecs { };

  numdifftools = callPackage ../development/python-modules/numdifftools { };

  numericalunits = callPackage ../development/python-modules/numericalunits { };

  numexpr = callPackage ../development/python-modules/numexpr { };

  numpy = numpy_2;

  numpy-financial = callPackage ../development/python-modules/numpy-financial { };

  numpy-groupies = callPackage ../development/python-modules/numpy-groupies { };

  numpy-stl = callPackage ../development/python-modules/numpy-stl { };

  numpy-typing-compat = callPackage ../development/python-modules/numpy-typing-compat { };

  numpy_1 = callPackage ../development/python-modules/numpy/1.nix { };

  numpy_2 = callPackage ../development/python-modules/numpy/2.nix { };

  numpydoc = callPackage ../development/python-modules/numpydoc { };

  numpyro = callPackage ../development/python-modules/numpyro { };

  nunavut = callPackage ../development/python-modules/nunavut { };

  nutils = callPackage ../development/python-modules/nutils { };

  nutils-poly = callPackage ../development/python-modules/nutils-poly { };

  nutpie = callPackage ../development/python-modules/nutpie { };

  nvchecker = callPackage ../development/python-modules/nvchecker { };

  nvdlib = callPackage ../development/python-modules/nvdlib { };

  nvidia-dlprof-pytorch-nvtx =
    callPackage ../development/python-modules/nvidia-dlprof-pytorch-nvtx
      { };

  nvidia-ml-py = callPackage ../development/python-modules/nvidia-ml-py { };

  nwdiag = callPackage ../development/python-modules/nwdiag { };

  nxt-python = callPackage ../development/python-modules/nxt-python { };

  nyt-games = callPackage ../development/python-modules/nyt-games { };

  oasatelematics = callPackage ../development/python-modules/oasatelematics { };

  oath = callPackage ../development/python-modules/oath { };

  oathtool = callPackage ../development/python-modules/oathtool { };

  oauth2-client = callPackage ../development/python-modules/oauth2-client { };

  oauth2client = callPackage ../development/python-modules/oauth2client { };

  oauthenticator = callPackage ../development/python-modules/oauthenticator { };

  oauthlib = callPackage ../development/python-modules/oauthlib { };

  obfsproxy = callPackage ../development/python-modules/obfsproxy { };

  objexplore = callPackage ../development/python-modules/objexplore { };

  objgraph = callPackage ../development/python-modules/objgraph {
    # requires both the graphviz package and python package
    graphvizPkgs = pkgs.graphviz;
  };

  objprint = callPackage ../development/python-modules/objprint { };

  objsize = callPackage ../development/python-modules/objsize { };

  obspy = callPackage ../development/python-modules/obspy { };

  oca-port = callPackage ../development/python-modules/oca-port { };

  ochre = callPackage ../development/python-modules/ochre { };

  oci = callPackage ../development/python-modules/oci { };

  ocifs = callPackage ../development/python-modules/ocifs { };

  ocrmypdf = callPackage ../development/python-modules/ocrmypdf { tesseract = pkgs.tesseract5; };

  od = callPackage ../development/python-modules/od { };

  odc-geo = callPackage ../development/python-modules/odc-geo { };

  odc-loader = callPackage ../development/python-modules/odc-loader { };

  odc-stac = callPackage ../development/python-modules/odc-stac { };

  oddsprout = callPackage ../development/python-modules/oddsprout { };

  odfpy = callPackage ../development/python-modules/odfpy { };

  odp-amsterdam = callPackage ../development/python-modules/odp-amsterdam { };

  oelint-data = callPackage ../development/python-modules/oelint-data { };

  oelint-parser = callPackage ../development/python-modules/oelint-parser { };

  oemthermostat = callPackage ../development/python-modules/oemthermostat { };

  offtrac = callPackage ../development/python-modules/offtrac { };

  ofxclient = callPackage ../development/python-modules/ofxclient { };

  ofxhome = callPackage ../development/python-modules/ofxhome { };

  ofxparse = callPackage ../development/python-modules/ofxparse { };

  ofxtools = callPackage ../development/python-modules/ofxtools { };

  ogmios = callPackage ../development/python-modules/ogmios { };

  ohme = callPackage ../development/python-modules/ohme { };

  oic = callPackage ../development/python-modules/oic { };

  okonomiyaki = callPackage ../development/python-modules/okonomiyaki { };

  okta = callPackage ../development/python-modules/okta { };

  oldest-supported-numpy = callPackage ../development/python-modules/oldest-supported-numpy { };

  oldmemo = callPackage ../development/python-modules/oldmemo { };

  olefile = callPackage ../development/python-modules/olefile { };

  oletools = callPackage ../development/python-modules/oletools { };

  ollama = callPackage ../development/python-modules/ollama { };

  ome-zarr = callPackage ../development/python-modules/ome-zarr { };

  omegaconf = callPackage ../development/python-modules/omegaconf { };

  omemo = callPackage ../development/python-modules/omemo { };

  omemo-dr = callPackage ../development/python-modules/omemo-dr { };

  omnikinverter = callPackage ../development/python-modules/omnikinverter { };

  omnilogic = callPackage ../development/python-modules/omnilogic { };

  omniorb = toPythonModule (pkgs.omniorb.override { python3 = self.python; });

  omniorbpy = callPackage ../development/python-modules/omniorbpy { };

  omorfi = callPackage ../development/python-modules/omorfi { };

  omrdatasettools = callPackage ../development/python-modules/omrdatasettools { };

  oncalendar = callPackage ../development/python-modules/oncalendar { };

  ondilo = callPackage ../development/python-modules/ondilo { };

  onecache = callPackage ../development/python-modules/onecache { };

  onedrive-personal-sdk = callPackage ../development/python-modules/onedrive-personal-sdk { };

  onetimepad = callPackage ../development/python-modules/onetimepad { };

  onetimepass = callPackage ../development/python-modules/onetimepass { };

  onigurumacffi = callPackage ../development/python-modules/onigurumacffi { };

  onkyo-eiscp = callPackage ../development/python-modules/onkyo-eiscp { };

  online-judge-api-client = callPackage ../development/python-modules/online-judge-api-client { };

  online-judge-tools = callPackage ../development/python-modules/online-judge-tools { };

  online-judge-verify-helper =
    callPackage ../development/python-modules/online-judge-verify-helper
      { };

  onlykey-solo-python = callPackage ../development/python-modules/onlykey-solo-python { };

  onnx = callPackage ../development/python-modules/onnx { };

  onnxconverter-common = callPackage ../development/python-modules/onnxconverter-common { };

  onnxmltools = callPackage ../development/python-modules/onnxmltools { };

  onnxruntime = callPackage ../development/python-modules/onnxruntime {
    onnxruntime = pkgs.onnxruntime.override {
      python3Packages = self;
      pythonSupport = true;
    };
  };

  onnxruntime-tools = callPackage ../development/python-modules/onnxruntime-tools { };

  onnxslim = callPackage ../development/python-modules/onnxslim { };

  onvif-zeep = callPackage ../development/python-modules/onvif-zeep { };

  onvif-zeep-async = callPackage ../development/python-modules/onvif-zeep-async { };

  oocsi = callPackage ../development/python-modules/oocsi { };

  opack2 = callPackage ../development/python-modules/opack2 { };

  opaque = callPackage ../development/python-modules/opaque { };

  opcua-widgets = callPackage ../development/python-modules/opcua-widgets { };

  open-clip-torch = callPackage ../development/python-modules/open-clip-torch { };

  open-garage = callPackage ../development/python-modules/open-garage { };

  open-hypergraphs = callPackage ../development/python-modules/open-hypergraphs { };

  open-interpreter = callPackage ../development/python-modules/open-interpreter { };

  open-meteo = callPackage ../development/python-modules/open-meteo { };

  openai = callPackage ../development/python-modules/openai { };

  openai-agents = callPackage ../development/python-modules/openai-agents { };

  openai-harmony = callPackage ../development/python-modules/openai-harmony { };

  openai-whisper = callPackage ../development/python-modules/openai-whisper { };

  openaiauth = callPackage ../development/python-modules/openaiauth { };

  openant = callPackage ../development/python-modules/openant { };

  openapi-core = callPackage ../development/python-modules/openapi-core { };

  openapi-pydantic = callPackage ../development/python-modules/openapi-pydantic { };

  openapi-schema-validator = callPackage ../development/python-modules/openapi-schema-validator { };

  openapi-spec-validator = callPackage ../development/python-modules/openapi-spec-validator { };

  openapi3 = callPackage ../development/python-modules/openapi3 { };

  openbabel = toPythonModule (pkgs.openbabel.override { python3 = python; });

  opencamlib = callPackage ../development/python-modules/opencamlib { };

  opencc = callPackage ../development/python-modules/opencc { };

  opencensus = callPackage ../development/python-modules/opencensus { };

  opencensus-context = callPackage ../development/python-modules/opencensus-context { };

  opencensus-ext-azure = callPackage ../development/python-modules/opencensus-ext-azure { };

  opencontainers = callPackage ../development/python-modules/opencontainers { };

  opencv-python = callPackage ../development/python-modules/opencv-python { };

  opencv-python-headless = callPackage ../development/python-modules/opencv-python-headless { };

  opencv4 = toPythonModule (
    pkgs.opencv4.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  opencv4Full = toPythonModule (
    pkgs.opencv4.override rec {
      enablePython = true;
      pythonPackages = self;
      enableCuda = pkgs.config.cudaSupport;
      enableCublas = enableCuda;
      enableCudnn = enableCuda;
      enableCufft = enableCuda;
      enableLto = !stdenv.hostPlatform.isLinux; # https://github.com/NixOS/nixpkgs/issues/343123
      enableUnfree = false; # prevents cache
      enableIpp = true;
      enableGtk2 = true;
      enableGtk3 = true;
      enableVtk = true;
      enableFfmpeg = true;
      enableGStreamer = true;
      enableTesseract = true;
      enableTbb = true;
      enableOvis = true;
      enableGPhoto2 = true;
      enableDC1394 = true;
      enableDocs = true;
    }
  );

  opendal = callPackage ../development/python-modules/opendal { };

  openerz-api = callPackage ../development/python-modules/openerz-api { };

  openevsewifi = callPackage ../development/python-modules/openevsewifi { };

  openfga-sdk = callPackage ../development/python-modules/openfga-sdk { };

  openhomedevice = callPackage ../development/python-modules/openhomedevice { };

  openidc-client = callPackage ../development/python-modules/openidc-client { };

  openmm = toPythonModule (
    pkgs.openmm.override {
      python3Packages = self;
      enablePython = true;
    }
  );

  openpaperwork-core = callPackage ../applications/office/paperwork/openpaperwork-core.nix { };

  openpaperwork-gtk = callPackage ../applications/office/paperwork/openpaperwork-gtk.nix { };

  openpyxl = callPackage ../development/python-modules/openpyxl { };

  openrazer = callPackage ../development/python-modules/openrazer/pylib.nix { };

  openrazer-daemon = callPackage ../development/python-modules/openrazer/daemon.nix { };

  openrgb-python = callPackage ../development/python-modules/openrgb-python { };

  openrouteservice = callPackage ../development/python-modules/openrouteservice { };

  opensearch-py = callPackage ../development/python-modules/opensearch-py { };

  opensensemap-api = callPackage ../development/python-modules/opensensemap-api { };

  opensfm = callPackage ../development/python-modules/opensfm { };

  openshift = callPackage ../development/python-modules/openshift { };

  opensimplex = callPackage ../development/python-modules/opensimplex { };

  openslide = callPackage ../development/python-modules/openslide { inherit (pkgs) openslide; };

  openstackdocstheme = callPackage ../development/python-modules/openstackdocstheme { };

  openstacksdk = callPackage ../development/python-modules/openstacksdk { };

  openstep-parser = callPackage ../development/python-modules/openstep-parser { };

  openstep-plist = callPackage ../development/python-modules/openstep-plist { };

  opentelemetry-api = callPackage ../development/python-modules/opentelemetry-api { };

  opentelemetry-distro = callPackage ../development/python-modules/opentelemetry-distro { };

  opentelemetry-exporter-otlp =
    callPackage ../development/python-modules/opentelemetry-exporter-otlp
      { };

  opentelemetry-exporter-otlp-proto-common =
    callPackage ../development/python-modules/opentelemetry-exporter-otlp-proto-common
      { };

  opentelemetry-exporter-otlp-proto-grpc =
    callPackage ../development/python-modules/opentelemetry-exporter-otlp-proto-grpc
      { };

  opentelemetry-exporter-otlp-proto-http =
    callPackage ../development/python-modules/opentelemetry-exporter-otlp-proto-http
      { };

  opentelemetry-exporter-prometheus =
    callPackage ../development/python-modules/opentelemetry-exporter-prometheus
      { };

  opentelemetry-instrumentation =
    callPackage ../development/python-modules/opentelemetry-instrumentation
      { };

  opentelemetry-instrumentation-aiohttp-client =
    callPackage ../development/python-modules/opentelemetry-instrumentation-aiohttp-client
      { };

  opentelemetry-instrumentation-asgi =
    callPackage ../development/python-modules/opentelemetry-instrumentation-asgi
      { };

  opentelemetry-instrumentation-botocore =
    callPackage ../development/python-modules/opentelemetry-instrumentation-botocore
      { };

  opentelemetry-instrumentation-celery =
    callPackage ../development/python-modules/opentelemetry-instrumentation-celery
      { };

  opentelemetry-instrumentation-dbapi =
    callPackage ../development/python-modules/opentelemetry-instrumentation-dbapi
      { };

  opentelemetry-instrumentation-django =
    callPackage ../development/python-modules/opentelemetry-instrumentation-django
      { };

  opentelemetry-instrumentation-fastapi =
    callPackage ../development/python-modules/opentelemetry-instrumentation-fastapi
      { };

  opentelemetry-instrumentation-flask =
    callPackage ../development/python-modules/opentelemetry-instrumentation-flask
      { };

  opentelemetry-instrumentation-grpc =
    callPackage ../development/python-modules/opentelemetry-instrumentation-grpc
      { };

  opentelemetry-instrumentation-httpx =
    callPackage ../development/python-modules/opentelemetry-instrumentation-httpx
      { };

  opentelemetry-instrumentation-logging =
    callPackage ../development/python-modules/opentelemetry-instrumentation-logging
      { };

  opentelemetry-instrumentation-psycopg2 =
    callPackage ../development/python-modules/opentelemetry-instrumentation-psycopg2
      { };

  opentelemetry-instrumentation-redis =
    callPackage ../development/python-modules/opentelemetry-instrumentation-redis
      { };

  opentelemetry-instrumentation-requests =
    callPackage ../development/python-modules/opentelemetry-instrumentation-requests
      { };

  opentelemetry-instrumentation-sqlalchemy =
    callPackage ../development/python-modules/opentelemetry-instrumentation-sqlalchemy
      { };

  opentelemetry-instrumentation-urllib3 =
    callPackage ../development/python-modules/opentelemetry-instrumentation-urllib3
      { };

  opentelemetry-instrumentation-wsgi =
    callPackage ../development/python-modules/opentelemetry-instrumentation-wsgi
      { };

  opentelemetry-propagator-aws-xray =
    callPackage ../development/python-modules/opentelemetry-propagator-aws-xray
      { };

  opentelemetry-proto = callPackage ../development/python-modules/opentelemetry-proto { };

  opentelemetry-sdk = callPackage ../development/python-modules/opentelemetry-sdk { };

  opentelemetry-semantic-conventions =
    callPackage ../development/python-modules/opentelemetry-semantic-conventions
      { };

  opentelemetry-test-utils = callPackage ../development/python-modules/opentelemetry-test-utils { };

  opentelemetry-util-http = callPackage ../development/python-modules/opentelemetry-util-http { };

  opentimestamps = callPackage ../development/python-modules/opentimestamps { };

  opentsne = callPackage ../development/python-modules/opentsne { };

  openturns = toPythonModule (
    pkgs.openturns.override {
      python3Packages = self;
      enablePython = true;
    }
  );

  opentype-feature-freezer = callPackage ../development/python-modules/opentype-feature-freezer { };

  opentypespec = callPackage ../development/python-modules/opentypespec { };

  openusd = callPackage ../development/python-modules/openusd { alembic = pkgs.alembic; };

  openvino = callPackage ../development/python-modules/openvino {
    openvino-native = pkgs.openvino.override { python3Packages = self; };
  };

  openwebifpy = callPackage ../development/python-modules/openwebifpy { };

  openwrt-luci-rpc = callPackage ../development/python-modules/openwrt-luci-rpc { };

  openwrt-ubus-rpc = callPackage ../development/python-modules/openwrt-ubus-rpc { };

  opower = callPackage ../development/python-modules/opower { };

  opsdroid-get-image-size = callPackage ../development/python-modules/opsdroid-get-image-size { };

  opt-einsum = callPackage ../development/python-modules/opt-einsum { };

  optax = callPackage ../development/python-modules/optax { };

  optimistix = callPackage ../development/python-modules/optimistix { };

  optimum = callPackage ../development/python-modules/optimum { };

  optree = callPackage ../development/python-modules/optree { };

  optuna = callPackage ../development/python-modules/optuna { };

  optuna-dashboard = callPackage ../development/python-modules/optuna-dashboard { };

  optype = callPackage ../development/python-modules/optype { };

  opuslib = callPackage ../development/python-modules/opuslib { };

  opytimark = callPackage ../development/python-modules/opytimark { };

  oracledb = callPackage ../development/python-modules/oracledb { };

  oralb-ble = callPackage ../development/python-modules/oralb-ble { };

  orange-canvas-core = callPackage ../development/python-modules/orange-canvas-core { };

  orange-widget-base = callPackage ../development/python-modules/orange-widget-base { };

  orange3 = callPackage ../development/python-modules/orange3 { };

  oras = callPackage ../development/python-modules/oras { };

  orbax-checkpoint = callPackage ../development/python-modules/orbax-checkpoint { };

  ordered-set = callPackage ../development/python-modules/ordered-set { };

  orderedmultidict = callPackage ../development/python-modules/orderedmultidict { };

  orderly-set = callPackage ../development/python-modules/orderly-set { };

  orgformat = callPackage ../development/python-modules/orgformat { };

  orgparse = callPackage ../development/python-modules/orgparse { };

  orjson = callPackage ../development/python-modules/orjson { };

  ormar = callPackage ../development/python-modules/ormar { };

  ormsgpack = callPackage ../development/python-modules/ormsgpack { };

  ortools = (toPythonModule (pkgs.or-tools.override { python3 = self.python; })).python;

  oru = callPackage ../development/python-modules/oru { };

  orvibo = callPackage ../development/python-modules/orvibo { };

  oryx = callPackage ../development/python-modules/oryx { };

  os-client-config = callPackage ../development/python-modules/os-client-config { };

  os-service-types = callPackage ../development/python-modules/os-service-types { };

  osc = callPackage ../development/python-modules/osc { };

  osc-diagram = callPackage ../development/python-modules/osc-diagram { };

  osc-lib = callPackage ../development/python-modules/osc-lib { };

  osc-placement = callPackage ../development/python-modules/osc-placement { };

  osc-sdk-python = callPackage ../development/python-modules/osc-sdk-python { };

  oschmod = callPackage ../development/python-modules/oschmod { };

  oscpy = callPackage ../development/python-modules/oscpy { };

  oscrypto = callPackage ../development/python-modules/oscrypto { };

  oscscreen = callPackage ../development/python-modules/oscscreen { };

  oset = callPackage ../development/python-modules/oset { };

  oslex = callPackage ../development/python-modules/oslex { };

  oslo-concurrency = callPackage ../development/python-modules/oslo-concurrency { };

  oslo-config = callPackage ../development/python-modules/oslo-config { };

  oslo-context = callPackage ../development/python-modules/oslo-context { };

  oslo-db = callPackage ../development/python-modules/oslo-db { };

  oslo-i18n = callPackage ../development/python-modules/oslo-i18n { };

  oslo-log = callPackage ../development/python-modules/oslo-log { };

  oslo-metrics = callPackage ../development/python-modules/oslo-metrics { };

  oslo-serialization = callPackage ../development/python-modules/oslo-serialization { };

  oslo-utils = callPackage ../development/python-modules/oslo-utils { };

  oslotest = callPackage ../development/python-modules/oslotest { };

  osmapi = callPackage ../development/python-modules/osmapi { };

  osmnx = callPackage ../development/python-modules/osmnx { };

  osmpythontools = callPackage ../development/python-modules/osmpythontools { };

  ospd = callPackage ../development/python-modules/ospd { };

  osprofiler = callPackage ../development/python-modules/osprofiler { };

  osqp = callPackage ../development/python-modules/osqp { };

  osrparse = callPackage ../development/python-modules/osrparse { };

  oss2 = callPackage ../development/python-modules/oss2 { };

  ossapi = callPackage ../development/python-modules/ossapi { };

  ossfs = callPackage ../development/python-modules/ossfs { };

  osxphotos = callPackage ../development/python-modules/osxphotos { };

  otpauth = callPackage ../development/python-modules/otpauth { };

  otr = callPackage ../development/python-modules/otr { };

  ots-python = callPackage ../development/python-modules/ots-python { };

  ourgroceries = callPackage ../development/python-modules/ourgroceries { };

  outcome = callPackage ../development/python-modules/outcome { };

  outdated = callPackage ../development/python-modules/outdated { };

  outlines = callPackage ../development/python-modules/outlines { };

  outlines-core = callPackage ../development/python-modules/outlines-core { };

  outspin = callPackage ../development/python-modules/outspin { };

  overly = callPackage ../development/python-modules/overly { };

  overpy = callPackage ../development/python-modules/overpy { };

  overrides = callPackage ../development/python-modules/overrides { };

  ovh = callPackage ../development/python-modules/ovh { };

  ovmfvartool = callPackage ../development/python-modules/ovmfvartool { };

  ovoenergy = callPackage ../development/python-modules/ovoenergy { };

  owslib = callPackage ../development/python-modules/owslib { };

  oyaml = callPackage ../development/python-modules/oyaml { };

  p1monitor = callPackage ../development/python-modules/p1monitor { };

  pa-ringbuffer = callPackage ../development/python-modules/pa-ringbuffer { };

  packageurl-python = callPackage ../development/python-modules/packageurl-python { };

  packaging = callPackage ../development/python-modules/packaging { };

  packaging-legacy = callPackage ../development/python-modules/packaging-legacy { };

  packbits = callPackage ../development/python-modules/packbits { };

  packet-python = callPackage ../development/python-modules/packet-python { };

  packvers = callPackage ../development/python-modules/packvers { };

  pad4pi = callPackage ../development/python-modules/pad4pi { };

  paddle-bfloat = callPackage ../development/python-modules/paddle-bfloat { };

  paddle2onnx = callPackage ../development/python-modules/paddle2onnx { };

  paddleocr = callPackage ../development/python-modules/paddleocr { };

  paddlepaddle = callPackage ../development/python-modules/paddlepaddle { };

  paddlex = callPackage ../development/python-modules/paddlex { };

  pagelabels = callPackage ../development/python-modules/pagelabels { };

  paginate = callPackage ../development/python-modules/paginate { };

  paho-mqtt = callPackage ../development/python-modules/paho-mqtt/default.nix { };

  paintcompiler = callPackage ../development/python-modules/paintcompiler { };

  palace = callPackage ../development/python-modules/palace { };

  palettable = callPackage ../development/python-modules/palettable { };

  pallets-sphinx-themes = callPackage ../development/python-modules/pallets-sphinx-themes { };

  pamela = callPackage ../development/python-modules/pamela { };

  pamqp = callPackage ../development/python-modules/pamqp { };

  pan-os-python = callPackage ../development/python-modules/pan-os-python { };

  pan-python = callPackage ../development/python-modules/pan-python { };

  panacotta = callPackage ../development/python-modules/panacotta { };

  panasonic-viera = callPackage ../development/python-modules/panasonic-viera { };

  pandantic = callPackage ../development/python-modules/pandantic { };

  pandas = callPackage ../development/python-modules/pandas { inherit (pkgs.darwin) adv_cmds; };

  pandas-datareader = callPackage ../development/python-modules/pandas-datareader { };

  pandas-stubs = callPackage ../development/python-modules/pandas-stubs { };

  pandas-ta = callPackage ../development/python-modules/pandas-ta { };

  pandera = callPackage ../development/python-modules/pandera { };

  pandoc-attributes = callPackage ../development/python-modules/pandoc-attributes { };

  pandoc-latex-environment = callPackage ../development/python-modules/pandoc-latex-environment { };

  pandoc-xnos = callPackage ../development/python-modules/pandoc-xnos { };

  pandocfilters = callPackage ../development/python-modules/pandocfilters { };

  panel = callPackage ../development/python-modules/panel { };

  panflute = callPackage ../development/python-modules/panflute { };

  panphon = callPackage ../development/python-modules/panphon { };

  panzi-json-logic = callPackage ../development/python-modules/panzi-json-logic { };

  paperbush = callPackage ../development/python-modules/paperbush { };

  papermill = callPackage ../development/python-modules/papermill { };

  paperwork-backend = callPackage ../applications/office/paperwork/paperwork-backend.nix { };

  paperwork-shell = callPackage ../applications/office/paperwork/paperwork-shell.nix { };

  papis = callPackage ../development/python-modules/papis { };

  papis-python-rofi = callPackage ../development/python-modules/papis-python-rofi { };

  para = callPackage ../development/python-modules/para { };

  paragraphs = callPackage ../development/python-modules/paragraphs { };

  parallel-ssh = callPackage ../development/python-modules/parallel-ssh { };

  param = callPackage ../development/python-modules/param { };

  paramax = callPackage ../development/python-modules/paramax { };

  parameter-decorators = callPackage ../development/python-modules/parameter-decorators { };

  parameter-expansion-patched =
    callPackage ../development/python-modules/parameter-expansion-patched
      { };

  parameterized = callPackage ../development/python-modules/parameterized { };

  parametrize-from-file = callPackage ../development/python-modules/parametrize-from-file { };

  paramiko = callPackage ../development/python-modules/paramiko { };

  paranoid-crypto = callPackage ../development/python-modules/paranoid-crypto { };

  parfive = callPackage ../development/python-modules/parfive { };

  parquet = callPackage ../development/python-modules/parquet { };

  parse = callPackage ../development/python-modules/parse { };

  parse-type = callPackage ../development/python-modules/parse-type { };

  parsedatetime = callPackage ../development/python-modules/parsedatetime { };

  parsedmarc = callPackage ../development/python-modules/parsedmarc { };

  parsel = callPackage ../development/python-modules/parsel { };

  parselmouth = callPackage ../development/python-modules/parselmouth { };

  parsimonious = callPackage ../development/python-modules/parsimonious { };

  parsley = callPackage ../development/python-modules/parsley { };

  parsnip = callPackage ../development/python-modules/parsnip { };

  parso = callPackage ../development/python-modules/parso { };

  parsy = callPackage ../development/python-modules/parsy { };

  partd = callPackage ../development/python-modules/partd { };

  partftpy = callPackage ../development/python-modules/partftpy { };

  partial-json-parser = callPackage ../development/python-modules/partial-json-parser { };

  particle = callPackage ../development/python-modules/particle { };

  parts = callPackage ../development/python-modules/parts { };

  parver = callPackage ../development/python-modules/parver { };

  pasimple = callPackage ../development/python-modules/pasimple { };

  passlib = callPackage ../development/python-modules/passlib { };

  password-entropy = callPackage ../development/python-modules/password-entropy { };

  paste = callPackage ../development/python-modules/paste { };

  pastedeploy = callPackage ../development/python-modules/pastedeploy { };

  pastel = callPackage ../development/python-modules/pastel { };

  pastescript = callPackage ../development/python-modules/pastescript { };

  patator = callPackage ../development/python-modules/patator { };

  patch = callPackage ../development/python-modules/patch { };

  patch-ng = callPackage ../development/python-modules/patch-ng { };

  patchpy = callPackage ../development/python-modules/patchpy { };

  path = callPackage ../development/python-modules/path { };

  path-and-address = callPackage ../development/python-modules/path-and-address { };

  pathable = callPackage ../development/python-modules/pathable { };

  pathlib-abc = callPackage ../development/python-modules/pathlib-abc { };

  pathlib2 = callPackage ../development/python-modules/pathlib2 { };

  pathos = callPackage ../development/python-modules/pathos { };

  pathspec = callPackage ../development/python-modules/pathspec { };

  pathtools = callPackage ../development/python-modules/pathtools { };

  pathvalidate = callPackage ../development/python-modules/pathvalidate { };

  pathy = callPackage ../development/python-modules/pathy { };

  patiencediff = callPackage ../development/python-modules/patiencediff { };

  patool = callPackage ../development/python-modules/patool { };

  patrowl4py = callPackage ../development/python-modules/patrowl4py { };

  patsy = callPackage ../development/python-modules/patsy { };

  paver = callPackage ../development/python-modules/paver { };

  paypal-checkout-serversdk = callPackage ../development/python-modules/paypal-checkout-serversdk { };

  paypalhttp = callPackage ../development/python-modules/paypalhttp { };

  paypalrestsdk = callPackage ../development/python-modules/paypalrestsdk { };

  pbar = callPackage ../development/python-modules/pbar { };

  pbkdf2 = callPackage ../development/python-modules/pbkdf2 { };

  pbr = callPackage ../development/python-modules/pbr { };

  pbs-installer = callPackage ../development/python-modules/pbs-installer { };

  pbxproj = callPackage ../development/python-modules/pbxproj { };

  pcapy-ng = callPackage ../development/python-modules/pcapy-ng {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  pcbnewtransition = callPackage ../development/python-modules/pcbnewtransition { };

  pcffont = callPackage ../development/python-modules/pcffont { };

  pcodec = callPackage ../development/python-modules/pcodec { };

  pcodedmp = callPackage ../development/python-modules/pcodedmp { };

  pcpp = callPackage ../development/python-modules/pcpp { };

  pcre2-py = callPackage ../development/python-modules/pcre2-py { };

  pdb2pqr = callPackage ../development/python-modules/pdb2pqr { };

  pdbfixer = callPackage ../development/python-modules/pdbfixer { };

  pdf2docx = callPackage ../development/python-modules/pdf2docx { };

  pdf2image = callPackage ../development/python-modules/pdf2image { };

  pdfkit = callPackage ../development/python-modules/pdfkit { };

  pdfminer-six = callPackage ../development/python-modules/pdfminer-six { };

  pdfplumber = callPackage ../development/python-modules/pdfplumber { };

  pdfquery = callPackage ../development/python-modules/pdfquery { };

  pdfrw = callPackage ../development/python-modules/pdfrw { };

  pdfrw2 = callPackage ../development/python-modules/pdfrw2 { };

  pdftotext = callPackage ../development/python-modules/pdftotext { };

  pdm-backend = callPackage ../development/python-modules/pdm-backend { };

  pdm-build-locked = callPackage ../development/python-modules/pdm-build-locked { };

  pdm-pep517 = callPackage ../development/python-modules/pdm-pep517 { };

  pdoc = callPackage ../development/python-modules/pdoc { };

  pdoc-pyo3-sample-library = callPackage ../development/python-modules/pdoc-pyo3-sample-library { };

  pdoc3 = callPackage ../development/python-modules/pdoc3 { };

  pdunehd = callPackage ../development/python-modules/pdunehd { };

  peacasso = callPackage ../development/python-modules/peacasso { };

  peakutils = callPackage ../development/python-modules/peakutils { };

  peaqevcore = callPackage ../development/python-modules/peaqevcore { };

  pebble = callPackage ../development/python-modules/pebble { };

  peblar = callPackage ../development/python-modules/peblar { };

  pecan = callPackage ../development/python-modules/pecan { };

  peco = callPackage ../development/python-modules/peco { };

  peewee = callPackage ../development/python-modules/peewee { };

  peewee-migrate = callPackage ../development/python-modules/peewee-migrate { };

  pefile = callPackage ../development/python-modules/pefile { };

  peft = callPackage ../development/python-modules/peft { };

  pegen = callPackage ../development/python-modules/pegen { };

  pelican = callPackage ../development/python-modules/pelican { inherit (pkgs) glibcLocales git; };

  pem = callPackage ../development/python-modules/pem { };

  pencompy = callPackage ../development/python-modules/pencompy { };

  pendulum = callPackage ../development/python-modules/pendulum { };

  pentapy = callPackage ../development/python-modules/pentapy { };

  pep440 = callPackage ../development/python-modules/pep440 { };

  pep517 = callPackage ../development/python-modules/pep517 { };

  pep8 = callPackage ../development/python-modules/pep8 { };

  pep8-naming = callPackage ../development/python-modules/pep8-naming { };

  pepit = callPackage ../development/python-modules/pepit { };

  peppercorn = callPackage ../development/python-modules/peppercorn { };

  perfplot = callPackage ../development/python-modules/perfplot { };

  periodictable = callPackage ../development/python-modules/periodictable { };

  periodiq = callPackage ../development/python-modules/periodiq { };

  permissionedforms = callPackage ../development/python-modules/permissionedforms { };

  persim = callPackage ../development/python-modules/persim { };

  persist-queue = callPackage ../development/python-modules/persist-queue { };

  persistent = callPackage ../development/python-modules/persistent { };

  persisting-theory = callPackage ../development/python-modules/persisting-theory { };

  pescea = callPackage ../development/python-modules/pescea { };

  pesq = callPackage ../development/python-modules/pesq { };

  petl = callPackage ../development/python-modules/petl { };

  petsc4py = toPythonModule (
    pkgs.petsc.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  petsctools = callPackage ../development/python-modules/petsctools { };

  pettingzoo = callPackage ../development/python-modules/pettingzoo { };

  pex = callPackage ../development/python-modules/pex { };

  pexif = callPackage ../development/python-modules/pexif { };

  pexpect = callPackage ../development/python-modules/pexpect { };

  pfzy = callPackage ../development/python-modules/pfzy { };

  pg8000 = callPackage ../development/python-modules/pg8000 { };

  pgcli = callPackage ../development/python-modules/pgcli { };

  pglast = callPackage ../development/python-modules/pglast { };

  pglive = callPackage ../development/python-modules/pglive { };

  pgmpy = callPackage ../development/python-modules/pgmpy { };

  pgpdump = callPackage ../development/python-modules/pgpdump { };

  pgpy = callPackage ../development/python-modules/pgpy { };

  pgpy-dtc = callPackage ../development/python-modules/pgpy-dtc { };

  pgsanity = callPackage ../development/python-modules/pgsanity { };

  pgspecial = callPackage ../development/python-modules/pgspecial { };

  pgvector = callPackage ../development/python-modules/pgvector { };

  phart = callPackage ../development/python-modules/phart { };

  phe = callPackage ../development/python-modules/phe { };

  phik = callPackage ../development/python-modules/phik { };

  philipstv = callPackage ../development/python-modules/philipstv { };

  phone-modem = callPackage ../development/python-modules/phone-modem { };

  phonemizer = callPackage ../development/python-modules/phonemizer { };

  phonenumbers = callPackage ../development/python-modules/phonenumbers { };

  phonenumberslite = callPackage ../development/python-modules/phonenumberslite { };

  phonopy = callPackage ../development/python-modules/phonopy { };

  photutils = callPackage ../development/python-modules/photutils { };

  phply = callPackage ../development/python-modules/phply { };

  phpserialize = callPackage ../development/python-modules/phpserialize { };

  phunspell = callPackage ../development/python-modules/phunspell { };

  phx-class-registry = callPackage ../development/python-modules/phx-class-registry { };

  pi1wire = callPackage ../development/python-modules/pi1wire { };

  piano-transcription-inference =
    callPackage ../development/python-modules/piano-transcription-inference
      { };

  piccata = callPackage ../development/python-modules/piccata { };

  piccolo = callPackage ../development/python-modules/piccolo { };

  piccolo-theme = callPackage ../development/python-modules/piccolo-theme { };

  pick = callPackage ../development/python-modules/pick { };

  pickleshare = callPackage ../development/python-modules/pickleshare { };

  pickpack = callPackage ../development/python-modules/pickpack { };

  picobox = callPackage ../development/python-modules/picobox { };

  picologging = callPackage ../development/python-modules/picologging { };

  picos = callPackage ../development/python-modules/picos { };

  picosvg = callPackage ../development/python-modules/picosvg { };

  pid = callPackage ../development/python-modules/pid { };

  piep = callPackage ../development/python-modules/piep { };

  piexif = callPackage ../development/python-modules/piexif { };

  pigpio = toPythonModule (
    pkgs.pigpio.override {
      inherit buildPythonPackage;
    }
  );

  pijuice = callPackage ../development/python-modules/pijuice { };

  pika = callPackage ../development/python-modules/pika { };

  pika-pool = callPackage ../development/python-modules/pika-pool { };

  pikepdf = callPackage ../development/python-modules/pikepdf { };

  pilight = callPackage ../development/python-modules/pilight { };

  pilkit = callPackage ../development/python-modules/pilkit { };

  pillow = callPackage ../development/python-modules/pillow {
    inherit (pkgs)
      freetype
      lcms2
      libavif
      libimagequant
      libjpeg
      libraqm
      libtiff
      libwebp
      openjpeg
      zlib-ng
      ;
    inherit (pkgs.xorg) libxcb;
  };

  pillow-heif = callPackage ../development/python-modules/pillow-heif { };

  pillow-jpls = callPackage ../development/python-modules/pillow-jpls { };

  pillowfight = callPackage ../development/python-modules/pillowfight { };

  pims = callPackage ../development/python-modules/pims { };

  pinboard = callPackage ../development/python-modules/pinboard { };

  pinecone-client = callPackage ../development/python-modules/pinecone-client { };

  pinecone-plugin-assistant = callPackage ../development/python-modules/pinecone-plugin-assistant { };

  pinecone-plugin-interface = callPackage ../development/python-modules/pinecone-plugin-interface { };

  ping3 = callPackage ../development/python-modules/ping3 { };

  pinocchio = callPackage ../development/python-modules/pinocchio { inherit (pkgs) pinocchio; };

  pins = callPackage ../development/python-modules/pins { };

  pint = callPackage ../development/python-modules/pint { };

  pint-pandas = callPackage ../development/python-modules/pint-pandas { };

  pint-xarray = callPackage ../development/python-modules/pint-xarray { };

  pip = callPackage ../development/python-modules/pip { };

  pip-api = callPackage ../development/python-modules/pip-api { };

  pip-chill = callPackage ../development/python-modules/pip-chill { };

  pip-install-test = callPackage ../development/python-modules/pip-install-test { };

  pip-requirements-parser = callPackage ../development/python-modules/pip-requirements-parser { };

  pip-system-certs = callPackage ../development/python-modules/pip-system-certs { };

  pip-tools = callPackage ../development/python-modules/pip-tools { };

  pipdate = callPackage ../development/python-modules/pipdate { };

  pipdeptree = callPackage ../development/python-modules/pipdeptree { };

  pipe = callPackage ../development/python-modules/pipe { };

  piper-phonemize = callPackage ../development/python-modules/piper-phonemize {
    onnxruntime-native = pkgs.onnxruntime;
    piper-phonemize-native = pkgs.piper-phonemize;
  };

  pipetools = callPackage ../development/python-modules/pipetools { };

  pipx = callPackage ../development/python-modules/pipx { };

  piqp = callPackage ../development/python-modules/piqp { };

  pivy = callPackage ../development/python-modules/pivy { };

  pixcat = callPackage ../development/python-modules/pixcat { };

  pixel-font-builder = callPackage ../development/python-modules/pixel-font-builder { };

  pixel-font-knife = callPackage ../development/python-modules/pixel-font-knife { };

  pixel-ring = callPackage ../development/python-modules/pixel-ring { };

  pixelmatch = callPackage ../development/python-modules/pixelmatch { };

  pizzapi = callPackage ../development/python-modules/pizzapi { };

  pjsua2 =
    (toPythonModule (
      pkgs.pjsip.override {
        pythonSupport = true;
        python3 = self.python;
      }
    )).py;

  pkce = callPackage ../development/python-modules/pkce { };

  pkg-about = callPackage ../development/python-modules/pkg-about { };

  pkgconfig = callPackage ../development/python-modules/pkgconfig { };

  pkginfo = callPackage ../development/python-modules/pkginfo { };

  pkginfo2 = callPackage ../development/python-modules/pkginfo2 { };

  pkgutil-resolve-name = callPackage ../development/python-modules/pkgutil-resolve-name { };

  pkuseg = callPackage ../development/python-modules/pkuseg { };

  plac = callPackage ../development/python-modules/plac { };

  plaid-python = callPackage ../development/python-modules/plaid-python { };

  planetary-computer = callPackage ../development/python-modules/planetary-computer { };

  plantuml = callPackage ../development/python-modules/plantuml { };

  plantuml-markdown = callPackage ../development/python-modules/plantuml-markdown {
    inherit (pkgs) plantuml;
  };

  plasTeX = callPackage ../development/python-modules/plasTeX { };

  plaster = callPackage ../development/python-modules/plaster { };

  plaster-pastedeploy = callPackage ../development/python-modules/plaster-pastedeploy { };

  plastexdepgraph = callPackage ../development/python-modules/plastexdepgraph { };

  plastexshowmore = callPackage ../development/python-modules/plastexshowmore { };

  platformdirs = callPackage ../development/python-modules/platformdirs { };

  playsound = callPackage ../development/python-modules/playsound { };

  playwright = callPackage ../development/python-modules/playwright { };

  playwright-stealth = callPackage ../development/python-modules/playwright-stealth { };

  playwrightcapture = callPackage ../development/python-modules/playwrightcapture { };

  plexapi = callPackage ../development/python-modules/plexapi { };

  plexauth = callPackage ../development/python-modules/plexauth { };

  plexwebsocket = callPackage ../development/python-modules/plexwebsocket { };

  plfit = toPythonModule (pkgs.plfit.override { inherit (self) python; });

  plink = callPackage ../development/python-modules/plink { };

  plone-testing = callPackage ../development/python-modules/plone-testing { };

  ploomber-core = callPackage ../development/python-modules/ploomber-core { };

  ploomber-extension = callPackage ../development/python-modules/ploomber-extension { };

  plopp = callPackage ../development/python-modules/plopp { };

  plotext = callPackage ../development/python-modules/plotext { };

  plotille = callPackage ../development/python-modules/plotille { };

  plotly = callPackage ../development/python-modules/plotly { };

  plotnine = callPackage ../development/python-modules/plotnine { };

  plotpy = callPackage ../development/python-modules/plotpy { };

  pluggy = callPackage ../development/python-modules/pluggy { };

  pluginbase = callPackage ../development/python-modules/pluginbase { };

  plugincode = callPackage ../development/python-modules/plugincode { };

  pluginlib = callPackage ../development/python-modules/pluginlib { };

  plugnplay = callPackage ../development/python-modules/plugnplay { };

  plugp100 = callPackage ../development/python-modules/plugp100 { };

  plugwise = callPackage ../development/python-modules/plugwise { };

  plum-py = callPackage ../development/python-modules/plum-py { };

  plumbum = callPackage ../development/python-modules/plumbum { };

  pluralizer = callPackage ../development/python-modules/pluralizer { };

  pluthon = callPackage ../development/python-modules/pluthon { };

  plux = callPackage ../development/python-modules/plux { };

  ply = callPackage ../development/python-modules/ply { };

  plyara = callPackage ../development/python-modules/plyara { };

  plyer = callPackage ../development/python-modules/plyer { };

  plyfile = callPackage ../development/python-modules/plyfile { };

  plyplus = callPackage ../development/python-modules/plyplus { };

  plyvel = callPackage ../development/python-modules/plyvel { };

  pmdarima = callPackage ../development/python-modules/pmdarima { };

  pmdsky-debug-py = callPackage ../development/python-modules/pmdsky-debug-py { };

  pmsensor = callPackage ../development/python-modules/pmsensor { };

  pmw = callPackage ../development/python-modules/pmw { };

  pnglatex = callPackage ../development/python-modules/pnglatex { };

  pocket = callPackage ../development/python-modules/pocket { };

  pocketsphinx = callPackage ../development/python-modules/pocketsphinx {
    inherit (pkgs) pocketsphinx;
  };

  podcastparser = callPackage ../development/python-modules/podcastparser { };

  podcats = callPackage ../development/python-modules/podcats { };

  podgen = callPackage ../development/python-modules/podgen { };

  podman = callPackage ../development/python-modules/podman { };

  poetry-core = callPackage ../development/python-modules/poetry-core { };

  poetry-dynamic-versioning = callPackage ../development/python-modules/poetry-dynamic-versioning { };

  poetry-semver = callPackage ../development/python-modules/poetry-semver { };

  polarizationsolver = callPackage ../development/python-modules/polarizationsolver { };

  polars = callPackage ../development/python-modules/polars { };

  polib = callPackage ../development/python-modules/polib { };

  policy-sentry = callPackage ../development/python-modules/policy-sentry { };

  policyuniverse = callPackage ../development/python-modules/policyuniverse { };

  polling = callPackage ../development/python-modules/polling { };

  polyfactory = callPackage ../development/python-modules/polyfactory { };

  polygon3 = callPackage ../development/python-modules/polygon3 { };

  polyline = callPackage ../development/python-modules/polyline { };

  polyswarm-api = callPackage ../development/python-modules/polyswarm-api { };

  pomegranate = callPackage ../development/python-modules/pomegranate { };

  pontos = callPackage ../development/python-modules/pontos { };

  pony = callPackage ../development/python-modules/pony { };

  ponywhoosh = callPackage ../development/python-modules/ponywhoosh { };

  pooch = callPackage ../development/python-modules/pooch { };

  pook = callPackage ../development/python-modules/pook { };

  poolsense = callPackage ../development/python-modules/poolsense { };

  poppler-qt5 = callPackage ../development/python-modules/poppler-qt5 {
    inherit (pkgs.qt5) qtbase qmake;
    inherit (pkgs.libsForQt5) poppler;
  };

  port-for = callPackage ../development/python-modules/port-for { };

  portalocker = callPackage ../development/python-modules/portalocker { };

  portend = callPackage ../development/python-modules/portend { };

  portion = callPackage ../development/python-modules/portion { };

  portpicker = callPackage ../development/python-modules/portpicker { };

  posix-ipc = callPackage ../development/python-modules/posix-ipc { };

  postgrest = callPackage ../development/python-modules/postgrest { };

  posthog = callPackage ../development/python-modules/posthog { };

  pot = callPackage ../development/python-modules/pot { };

  potentials = callPackage ../development/python-modules/potentials { };

  potr = callPackage ../development/python-modules/potr { };

  power = callPackage ../development/python-modules/power { };

  powerapi = callPackage ../development/python-modules/powerapi { };

  powerfox = callPackage ../development/python-modules/powerfox { };

  powerline = callPackage ../development/python-modules/powerline { };

  powerline-mem-segment = callPackage ../development/python-modules/powerline-mem-segment { };

  pox = callPackage ../development/python-modules/pox { };

  poyo = callPackage ../development/python-modules/poyo { };

  ppdeep = callPackage ../development/python-modules/ppdeep { };

  ppft = callPackage ../development/python-modules/ppft { };

  ppk2-api = callPackage ../development/python-modules/ppk2-api { };

  pplpy = callPackage ../development/python-modules/pplpy { };

  pprintpp = callPackage ../development/python-modules/pprintpp { };

  pproxy = callPackage ../development/python-modules/pproxy { };

  ppscore = callPackage ../development/python-modules/ppscore { };

  pq = callPackage ../development/python-modules/pq { };

  prance = callPackage ../development/python-modules/prance { };

  praw = callPackage ../development/python-modules/praw { };

  prawcore = callPackage ../development/python-modules/prawcore { };

  prayer-times-calculator-offline =
    callPackage ../development/python-modules/prayer-times-calculator-offline
      { };

  pre-commit-hooks = callPackage ../development/python-modules/pre-commit-hooks { };

  pre-commit-po-hooks = callPackage ../development/python-modules/pre-commit-po-hooks { };

  precis-i18n = callPackage ../development/python-modules/precis-i18n { };

  precisely = callPackage ../development/python-modules/precisely { };

  prefect = toPythonModule pkgs.prefect;

  prefixed = callPackage ../development/python-modules/prefixed { };

  preggy = callPackage ../development/python-modules/preggy { };

  preprocess-cancellation = callPackage ../development/python-modules/preprocess-cancellation { };

  presenterm-export = callPackage ../development/python-modules/presenterm-export { };

  preshed = callPackage ../development/python-modules/preshed { };

  presto-python-client = callPackage ../development/python-modules/presto-python-client { };

  pretend = callPackage ../development/python-modules/pretend { };

  pretty-errors = callPackage ../development/python-modules/pretty-errors { };

  prettytable = callPackage ../development/python-modules/prettytable { };

  price-parser = callPackage ../development/python-modules/price-parser { };

  primecountpy = callPackage ../development/python-modules/primecountpy { };

  primepy = callPackage ../development/python-modules/primepy { };

  primer3 = callPackage ../development/python-modules/primer3 { };

  print-color = callPackage ../development/python-modules/print-color { };

  priority = callPackage ../development/python-modules/priority { };

  prisma = callPackage ../development/python-modules/prisma { };

  prison = callPackage ../development/python-modules/prison { };

  process-tests = callPackage ../development/python-modules/process-tests { };

  procmon-parser = callPackage ../development/python-modules/procmon-parser { };

  prodict = callPackage ../development/python-modules/prodict { };

  progettihwsw = callPackage ../development/python-modules/progettihwsw { };

  proglog = callPackage ../development/python-modules/proglog { };

  progress = callPackage ../development/python-modules/progress { };

  progressbar = callPackage ../development/python-modules/progressbar { };

  progressbar2 = callPackage ../development/python-modules/progressbar2 { };

  progressbar33 = callPackage ../development/python-modules/progressbar33 { };

  proliphix = callPackage ../development/python-modules/proliphix { };

  prometheus-api-client = callPackage ../development/python-modules/prometheus-api-client { };

  prometheus-async = callPackage ../development/python-modules/prometheus-async { };

  prometheus-client = callPackage ../development/python-modules/prometheus-client { };

  prometheus-fastapi-instrumentator =
    callPackage ../development/python-modules/prometheus-fastapi-instrumentator
      { };

  prometheus-flask-exporter = callPackage ../development/python-modules/prometheus-flask-exporter { };

  prometheus-pandas = callPackage ../development/python-modules/prometheus-pandas { };

  prometrix = callPackage ../development/python-modules/prometrix { };

  promise = callPackage ../development/python-modules/promise { };

  prompt-toolkit = callPackage ../development/python-modules/prompt-toolkit { };

  prompthub-py = callPackage ../development/python-modules/prompthub-py { };

  propcache = callPackage ../development/python-modules/propcache { };

  property-cached = callPackage ../development/python-modules/property-cached { };

  property-manager = callPackage ../development/python-modules/property-manager { };

  prophet = callPackage ../development/python-modules/prophet { };

  propka = callPackage ../development/python-modules/propka { };

  prosemirror = callPackage ../development/python-modules/prosemirror { };

  protego = callPackage ../development/python-modules/protego { };

  proto-plus = callPackage ../development/python-modules/proto-plus { };

  # If a protobuf upgrade causes many Python packages to fail, please pin it here to the previous version.
  protobuf = protobuf6;

  protobuf3-to-dict = callPackage ../development/python-modules/protobuf3-to-dict { };

  # Protobuf 4.x
  protobuf4 = callPackage ../development/python-modules/protobuf/4.nix {
    protobuf = pkgs.protobuf_25;
  };

  # Protobuf 5.x
  protobuf5 = callPackage ../development/python-modules/protobuf/5.nix {
    protobuf = pkgs.__splicedPackages.protobuf_29;
  };

  # Protobuf 6.x
  protobuf6 = callPackage ../development/python-modules/protobuf/6.nix {
    inherit (pkgs.__splicedPackages) protobuf;
  };

  protoletariat = callPackage ../development/python-modules/protoletariat { };

  proton-client = callPackage ../development/python-modules/proton-client { };

  proton-core = callPackage ../development/python-modules/proton-core { };

  proton-keyring-linux = callPackage ../development/python-modules/proton-keyring-linux { };

  proton-vpn-api-core = callPackage ../development/python-modules/proton-vpn-api-core { };

  proton-vpn-local-agent = callPackage ../development/python-modules/proton-vpn-local-agent { };

  proton-vpn-network-manager =
    callPackage ../development/python-modules/proton-vpn-network-manager
      { };

  protonup-ng = callPackage ../development/python-modules/protonup-ng { };

  prov = callPackage ../development/python-modules/prov { };

  prowlpy = callPackage ../development/python-modules/prowlpy { };

  prox-tv = callPackage ../development/python-modules/prox-tv { };

  proxmoxer = callPackage ../development/python-modules/proxmoxer { };

  proxsuite = toPythonModule (
    pkgs.proxsuite.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  proxy-db = callPackage ../development/python-modules/proxy-db { };

  proxy-py = callPackage ../development/python-modules/proxy-py { };

  proxy-tools = callPackage ../development/python-modules/proxy-tools { };

  psautohint = callPackage ../development/python-modules/psautohint { };

  pscript = callPackage ../development/python-modules/pscript { };

  psd-tools = callPackage ../development/python-modules/psd-tools { };

  psnawp = callPackage ../development/python-modules/psnawp { };

  psrpcore = callPackage ../development/python-modules/psrpcore { };

  psutil = callPackage ../development/python-modules/psutil { };

  psutil-home-assistant = callPackage ../development/python-modules/psutil-home-assistant { };

  psychrolib = callPackage ../development/python-modules/psychrolib { };

  psycopg = callPackage ../development/python-modules/psycopg { };

  psycopg-c = psycopg.c;

  psycopg-pool = psycopg.pool;

  psycopg2 = callPackage ../development/python-modules/psycopg2 { };

  psycopg2-binary = callPackage ../development/python-modules/psycopg2-binary { };

  psycopg2cffi = callPackage ../development/python-modules/psycopg2cffi { };

  psygnal = callPackage ../development/python-modules/psygnal { };

  ptest = callPackage ../development/python-modules/ptest { };

  ptpython = callPackage ../development/python-modules/ptpython { };

  ptyprocess = callPackage ../development/python-modules/ptyprocess { };

  publicsuffix = callPackage ../development/python-modules/publicsuffix { };

  publicsuffix2 = callPackage ../development/python-modules/publicsuffix2 { };

  publicsuffixlist = callPackage ../development/python-modules/publicsuffixlist { };

  pubnub = callPackage ../development/python-modules/pubnub { };

  pubnubsub-handler = callPackage ../development/python-modules/pubnubsub-handler { };

  pudb = callPackage ../development/python-modules/pudb { };

  pueblo = callPackage ../development/python-modules/pueblo { };

  pulp = callPackage ../development/python-modules/pulp { };

  pulsar-client = callPackage ../development/python-modules/pulsar-client { };

  pulsectl = callPackage ../development/python-modules/pulsectl { };

  pulsectl-asyncio = callPackage ../development/python-modules/pulsectl-asyncio { };

  pulumi = callPackage ../development/python-modules/pulumi { };

  pulumi-aws = callPackage ../development/python-modules/pulumi-aws { };

  pulumi-aws-native = pkgs.pulumiPackages.pulumi-aws-native.sdks.python;

  pulumi-azure-native = pkgs.pulumiPackages.pulumi-azure-native.sdks.python;

  pulumi-command = pkgs.pulumiPackages.pulumi-command.sdks.python;

  pulumi-hcloud = pkgs.pulumiPackages.pulumi-hcloud.sdks.python;

  pulumi-random = pkgs.pulumiPackages.pulumi-random.sdks.python;

  pure-cdb = callPackage ../development/python-modules/pure-cdb { };

  pure-eval = callPackage ../development/python-modules/pure-eval { };

  pure-pcapy3 = callPackage ../development/python-modules/pure-pcapy3 { };

  pure-protobuf = callPackage ../development/python-modules/pure-protobuf { };

  pure-python-adb = callPackage ../development/python-modules/pure-python-adb { };

  pure-python-adb-homeassistant =
    callPackage ../development/python-modules/pure-python-adb-homeassistant
      { };

  pure-sasl = callPackage ../development/python-modules/pure-sasl { };

  puremagic = callPackage ../development/python-modules/puremagic { };

  purepng = callPackage ../development/python-modules/purepng { };

  purl = callPackage ../development/python-modules/purl { };

  pushbullet-py = callPackage ../development/python-modules/pushbullet-py { };

  pushover-complete = callPackage ../development/python-modules/pushover-complete { };

  pvextractor = callPackage ../development/python-modules/pvextractor { };

  pvlib = callPackage ../development/python-modules/pvlib { };

  pvo = callPackage ../development/python-modules/pvo { };

  pwdlib = callPackage ../development/python-modules/pwdlib { };

  pweave = callPackage ../development/python-modules/pweave { };

  pwinput = callPackage ../development/python-modules/pwinput { };

  pwkit = callPackage ../development/python-modules/pwkit { };

  pwlf = callPackage ../development/python-modules/pwlf { };

  pwntools = callPackage ../development/python-modules/pwntools { debugger = pkgs.gdb; };

  py = callPackage ../development/python-modules/py { };

  py-air-control = callPackage ../development/python-modules/py-air-control { };

  py-air-control-exporter = callPackage ../development/python-modules/py-air-control-exporter { };

  py-aosmith = callPackage ../development/python-modules/py-aosmith { };

  py-bip39-bindings = callPackage ../development/python-modules/py-bip39-bindings { };

  py-canary = callPackage ../development/python-modules/py-canary { };

  py-ccm15 = callPackage ../development/python-modules/py-ccm15 { };

  py-cid = callPackage ../development/python-modules/py-cid { };

  py-cpuinfo = callPackage ../development/python-modules/py-cpuinfo { };

  py-dactyl = callPackage ../development/python-modules/py-dactyl { };

  py-datastruct = callPackage ../development/python-modules/py-datastruct { };

  py-deprecate = callPackage ../development/python-modules/py-deprecate { };

  py-desmume = callPackage ../development/python-modules/py-desmume {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  py-deviceid = callPackage ../development/python-modules/py-deviceid { };

  py-dmidecode = callPackage ../development/python-modules/py-dmidecode { };

  py-dormakaba-dkey = callPackage ../development/python-modules/py-dormakaba-dkey { };

  py-ecc = callPackage ../development/python-modules/py-ecc { };

  py-evm = callPackage ../development/python-modules/py-evm { };

  py-expression-eval = callPackage ../development/python-modules/py-expression-eval { };

  py-iam-expand = callPackage ../development/python-modules/py-iam-expand { };

  py-improv-ble-client = callPackage ../development/python-modules/py-improv-ble-client { };

  py-libnuma = callPackage ../development/python-modules/py-libnuma { };

  py-libzfs = callPackage ../development/python-modules/py-libzfs { };

  py-lru-cache = callPackage ../development/python-modules/py-lru-cache { };

  py-machineid = callPackage ../development/python-modules/py-machineid { };

  py-madvr2 = callPackage ../development/python-modules/py-madvr2 { };

  py-melissa-climate = callPackage ../development/python-modules/py-melissa-climate { };

  py-multiaddr = callPackage ../development/python-modules/py-multiaddr { };

  py-multibase = callPackage ../development/python-modules/py-multibase { };

  py-multicodec = callPackage ../development/python-modules/py-multicodec { };

  py-multihash = callPackage ../development/python-modules/py-multihash { };

  py-nextbusnext = callPackage ../development/python-modules/py-nextbusnext { };

  py-nightscout = callPackage ../development/python-modules/py-nightscout { };

  py-ocsf-models = callPackage ../development/python-modules/py-ocsf-models { };

  py-opensonic = callPackage ../development/python-modules/py-opensonic { };

  py-partiql-parser = callPackage ../development/python-modules/py-partiql-parser { };

  py-pdf-parser = callPackage ../development/python-modules/py-pdf-parser { };

  py-radix-sr = callPackage ../development/python-modules/py-radix-sr { };

  py-rust-stemmers = callPackage ../development/python-modules/py-rust-stemmers { };

  py-schluter = callPackage ../development/python-modules/py-schluter { };

  py-serializable = callPackage ../development/python-modules/py-serializable { };

  py-slvs = callPackage ../development/python-modules/py-slvs { };

  py-sneakers = callPackage ../development/python-modules/py-sneakers { };

  py-sonic = callPackage ../development/python-modules/py-sonic { };

  py-sr25519-bindings = callPackage ../development/python-modules/py-sr25519-bindings { };

  py-stringmatching = callPackage ../development/python-modules/py-stringmatching { };

  py-sucks = callPackage ../development/python-modules/py-sucks { };

  py-synologydsm-api = callPackage ../development/python-modules/py-synologydsm-api { };

  py-tes = callPackage ../development/python-modules/py-tes { };

  py-ubjson = callPackage ../development/python-modules/py-ubjson { };

  py-vapid = callPackage ../development/python-modules/py-vapid { };

  py-zabbix = callPackage ../development/python-modules/py-zabbix { };

  py2bit = callPackage ../development/python-modules/py2bit { };

  py2vega = callPackage ../development/python-modules/py2vega { };

  py3amf = callPackage ../development/python-modules/py3amf { };

  py3buddy = callPackage ../development/python-modules/py3buddy { };

  py3dns = callPackage ../development/python-modules/py3dns { };

  py3exiv2 = callPackage ../development/python-modules/py3exiv2 { inherit (pkgs) exiv2; };

  py3langid = callPackage ../development/python-modules/py3langid { };

  py3nvml = callPackage ../development/python-modules/py3nvml { };

  py3rijndael = callPackage ../development/python-modules/py3rijndael { };

  py3status = callPackage ../development/python-modules/py3status { };

  py4j = callPackage ../development/python-modules/py4j { };

  py65 = callPackage ../development/python-modules/py65 { };

  py7zr = callPackage ../development/python-modules/py7zr { };

  pyabpoa = toPythonModule (
    pkgs.abpoa.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  pyacaia-async = callPackage ../development/python-modules/pyacaia-async { };

  pyacoustid = callPackage ../development/python-modules/pyacoustid { };

  pyadjoint-ad = callPackage ../development/python-modules/pyadjoint-ad { };

  pyads = callPackage ../development/python-modules/pyads { };

  pyaehw4a1 = callPackage ../development/python-modules/pyaehw4a1 { };

  pyaes = callPackage ../development/python-modules/pyaes { };

  pyaftership = callPackage ../development/python-modules/pyaftership { };

  pyahocorasick = callPackage ../development/python-modules/pyahocorasick { };

  pyairnow = callPackage ../development/python-modules/pyairnow { };

  pyairports = callPackage ../development/python-modules/pyairports { };

  pyairtable = callPackage ../development/python-modules/pyairtable { };

  pyairvisual = callPackage ../development/python-modules/pyairvisual { };

  pyais = callPackage ../development/python-modules/pyais { };

  pyalgotrade = callPackage ../development/python-modules/pyalgotrade { };

  pyalsaaudio = callPackage ../development/python-modules/pyalsaaudio { };

  pyamg = callPackage ../development/python-modules/pyamg { };

  pyaml = callPackage ../development/python-modules/pyaml { };

  pyaml-env = callPackage ../development/python-modules/pyaml-env { };

  pyannotate = callPackage ../development/python-modules/pyannotate { };

  pyannote-audio = callPackage ../development/python-modules/pyannote-audio { };

  pyannote-core = callPackage ../development/python-modules/pyannote-core { };

  pyannote-database = callPackage ../development/python-modules/pyannote-database { };

  pyannote-metrics = callPackage ../development/python-modules/pyannote-metrics { };

  pyannote-pipeline = callPackage ../development/python-modules/pyannote-pipeline { };

  pyannoteai-sdk = callPackage ../development/python-modules/pyannoteai-sdk { };

  pyaprilaire = callPackage ../development/python-modules/pyaprilaire { };

  pyarlo = callPackage ../development/python-modules/pyarlo { };

  pyarr = callPackage ../development/python-modules/pyarr { };

  pyarrow = callPackage ../development/python-modules/pyarrow { inherit (pkgs) arrow-cpp cmake; };

  pyarrow-hotfix = callPackage ../development/python-modules/pyarrow-hotfix { };

  pyasn = callPackage ../development/python-modules/pyasn { };

  pyasn1 = callPackage ../development/python-modules/pyasn1 { };

  pyasn1-modules = callPackage ../development/python-modules/pyasn1-modules { };

  pyasuswrt = callPackage ../development/python-modules/pyasuswrt { };

  pyasynchat = callPackage ../development/python-modules/pyasynchat { };

  pyasyncore = callPackage ../development/python-modules/pyasyncore { };

  pyatag = callPackage ../development/python-modules/pyatag { };

  pyatem = callPackage ../development/python-modules/pyatem { };

  pyathena = callPackage ../development/python-modules/pyathena { };

  pyatmo = callPackage ../development/python-modules/pyatmo { };

  pyatome = callPackage ../development/python-modules/pyatome { };

  pyatspi = callPackage ../development/python-modules/pyatspi { inherit (pkgs.buildPackages) meson; };

  pyatv = callPackage ../development/python-modules/pyatv { };

  pyaudio = callPackage ../development/python-modules/pyaudio { };

  pyaussiebb = callPackage ../development/python-modules/pyaussiebb { };

  pyautogui = callPackage ../development/python-modules/pyautogui { };

  pyavm = callPackage ../development/python-modules/pyavm { };

  pyaxmlparser = callPackage ../development/python-modules/pyaxmlparser { };

  pybalboa = callPackage ../development/python-modules/pybalboa { };

  pybars3 = callPackage ../development/python-modules/pybars3 { };

  pybase64 = callPackage ../development/python-modules/pybase64 { };

  pybbox = callPackage ../development/python-modules/pybbox { };

  pybcj = callPackage ../development/python-modules/pybcj { };

  pybids = callPackage ../development/python-modules/pybids { };

  pybigwig = callPackage ../development/python-modules/pybigwig { };

  pybind11 = callPackage ../development/python-modules/pybind11 { };

  pybind11-abseil = callPackage ../development/python-modules/pybind11-abseil { };

  pybind11-stubgen = callPackage ../development/python-modules/pybind11-stubgen { };

  pybindgen = callPackage ../development/python-modules/pybindgen { };

  pyblackbird = callPackage ../development/python-modules/pyblackbird { };

  pybloom-live = callPackage ../development/python-modules/pybloom-live { };

  pyblu = callPackage ../development/python-modules/pyblu { };

  pybluez = callPackage ../development/python-modules/pybluez { inherit (pkgs) bluez; };

  pybotvac = callPackage ../development/python-modules/pybotvac { };

  pybox2d = callPackage ../development/python-modules/pybox2d { };

  pybravia = callPackage ../development/python-modules/pybravia { };

  pybrowserid = callPackage ../development/python-modules/pybrowserid { };

  pybrowsers = callPackage ../development/python-modules/pybrowsers { };

  pybtex = callPackage ../development/python-modules/pybtex { };

  pybtex-docutils = callPackage ../development/python-modules/pybtex-docutils { };

  pybullet = callPackage ../development/python-modules/pybullet { };

  pycairo = callPackage ../development/python-modules/pycairo { inherit (pkgs.buildPackages) meson; };

  pycangjie = callPackage ../development/python-modules/pycangjie {
    inherit (pkgs.buildPackages) meson;
  };

  pycapnp = callPackage ../development/python-modules/pycapnp { };

  pycaption = callPackage ../development/python-modules/pycaption { };

  pycardano = callPackage ../development/python-modules/pycardano { };

  pycares = callPackage ../development/python-modules/pycares { };

  pycarwings2 = callPackage ../development/python-modules/pycarwings2 { };

  pycasbin = callPackage ../development/python-modules/pycasbin { };

  pycatch22 = callPackage ../development/python-modules/pycatch22 { };

  pycayennelpp = callPackage ../development/python-modules/pycayennelpp { };

  pycddl = callPackage ../development/python-modules/pycddl { };

  pycdio = callPackage ../development/python-modules/pycdio { };

  pycec = callPackage ../development/python-modules/pycec { };

  pycep-parser = callPackage ../development/python-modules/pycep-parser { };

  pycfdns = callPackage ../development/python-modules/pycfdns { };

  pycflow2dot = callPackage ../development/python-modules/pycflow2dot { inherit (pkgs) graphviz; };

  pycfmodel = callPackage ../development/python-modules/pycfmodel { };

  pychannels = callPackage ../development/python-modules/pychannels { };

  pychm = callPackage ../development/python-modules/pychm { };

  pychromecast = callPackage ../development/python-modules/pychromecast { };

  pycketcasts = callPackage ../development/python-modules/pycketcasts { };

  pyclimacell = callPackage ../development/python-modules/pyclimacell { };

  pyclip = callPackage ../development/python-modules/pyclip { };

  pyclipper = callPackage ../development/python-modules/pyclipper { };

  pycm = callPackage ../development/python-modules/pycm { };

  pycmarkgfm = callPackage ../development/python-modules/pycmarkgfm { };

  pycmus = callPackage ../development/python-modules/pycmus { };

  pycobertura = callPackage ../development/python-modules/pycobertura { };

  pycocotools = callPackage ../development/python-modules/pycocotools { };

  pycodestyle = callPackage ../development/python-modules/pycodestyle { };

  pycognito = callPackage ../development/python-modules/pycognito { };

  pycoin = callPackage ../development/python-modules/pycoin { };

  pycollada = callPackage ../development/python-modules/pycollada { };

  pycolorecho = callPackage ../development/python-modules/pycolorecho { };

  pycomfoconnect = callPackage ../development/python-modules/pycomfoconnect { };

  pycomm3 = callPackage ../development/python-modules/pycomm3 { };

  pycompliance = callPackage ../development/python-modules/pycompliance { };

  pycomposefile = callPackage ../development/python-modules/pycomposefile { };

  pycontrol4 = callPackage ../development/python-modules/pycontrol4 { };

  pycookiecheat = callPackage ../development/python-modules/pycookiecheat { };

  pycoolmasternet-async = callPackage ../development/python-modules/pycoolmasternet-async { };

  pycosat = callPackage ../development/python-modules/pycosat { };

  pycotap = callPackage ../development/python-modules/pycotap { };

  pycountry = callPackage ../development/python-modules/pycountry { };

  pycountry-convert = callPackage ../development/python-modules/pycountry-convert { };

  pycparser = callPackage ../development/python-modules/pycparser { };

  pycrashreport = callPackage ../development/python-modules/pycrashreport { };

  pycrc = callPackage ../development/python-modules/pycrc { };

  pycrdt = callPackage ../development/python-modules/pycrdt { };

  pycrdt-store = callPackage ../development/python-modules/pycrdt-store { };

  pycrdt-websocket = callPackage ../development/python-modules/pycrdt-websocket { };

  pycritty = callPackage ../development/python-modules/pycritty { };

  pycron = callPackage ../development/python-modules/pycron { };

  pycrypto = callPackage ../development/python-modules/pycrypto { };

  pycryptodome = callPackage ../development/python-modules/pycryptodome { };

  pycryptodomex = callPackage ../development/python-modules/pycryptodomex { };

  pycsdr = callPackage ../development/python-modules/pycsdr { };

  pycsspeechtts = callPackage ../development/python-modules/pycsspeechtts { };

  pyct = callPackage ../development/python-modules/pyct { };

  pyctr = callPackage ../development/python-modules/pyctr { };

  pycuda = callPackage ../development/python-modules/pycuda { inherit (pkgs.stdenv) mkDerivation; };

  pycups = callPackage ../development/python-modules/pycups { };

  pycurl = callPackage ../development/python-modules/pycurl { };

  pycxx = callPackage ../development/python-modules/pycxx { };

  pycycling = callPackage ../development/python-modules/pycycling { };

  pycync = callPackage ../development/python-modules/pycync { };

  pycyphal = callPackage ../development/python-modules/pycyphal { };

  pydaikin = callPackage ../development/python-modules/pydaikin { };

  pydal = callPackage ../development/python-modules/pydal { };

  pydanfossair = callPackage ../development/python-modules/pydanfossair { };

  pydantic = callPackage ../development/python-modules/pydantic { };

  pydantic-argparse-extensible =
    callPackage ../development/python-modules/pydantic-argparse-extensible
      { };

  pydantic-compat = callPackage ../development/python-modules/pydantic-compat { };

  pydantic-core = callPackage ../development/python-modules/pydantic-core { };

  pydantic-extra-types = callPackage ../development/python-modules/pydantic-extra-types { };

  pydantic-scim = callPackage ../development/python-modules/pydantic-scim { };

  pydantic-settings = callPackage ../development/python-modules/pydantic-settings { };

  pydantic_1 = callPackage ../development/python-modules/pydantic/1.nix { };

  pydash = callPackage ../development/python-modules/pydash { };

  pydata-google-auth = callPackage ../development/python-modules/pydata-google-auth { };

  pydata-sphinx-theme = callPackage ../development/python-modules/pydata-sphinx-theme { };

  pydateinfer = callPackage ../development/python-modules/pydateinfer { };

  pydbus = callPackage ../development/python-modules/pydbus { };

  pydeako = callPackage ../development/python-modules/pydeako { };

  pydeck = callPackage ../development/python-modules/pydeck { };

  pydeconz = callPackage ../development/python-modules/pydeconz { };

  pydelijn = callPackage ../development/python-modules/pydelijn { };

  pydemumble = callPackage ../development/python-modules/pydemumble { };

  pydenticon = callPackage ../development/python-modules/pydenticon { };

  pydeps = callPackage ../development/python-modules/pydeps { inherit (pkgs) graphviz; };

  pydes = callPackage ../development/python-modules/pydes { };

  pydevccu = callPackage ../development/python-modules/pydevccu { };

  pydevd = callPackage ../development/python-modules/pydevd { };

  pydevtool = callPackage ../development/python-modules/pydevtool { };

  pydexcom = callPackage ../development/python-modules/pydexcom { };

  pydicom = callPackage ../development/python-modules/pydicom { };

  pydicom-seg = callPackage ../development/python-modules/pydicom-seg { };

  pydiffx = callPackage ../development/python-modules/pydiffx { };

  pydigiham = callPackage ../development/python-modules/pydigiham { };

  pydiscourse = callPackage ../development/python-modules/pydiscourse { };

  pydiscovergy = callPackage ../development/python-modules/pydiscovergy { };

  pydispatcher = callPackage ../development/python-modules/pydispatcher { };

  pydmd = callPackage ../development/python-modules/pydmd { };

  pydo = callPackage ../development/python-modules/pydo { };

  pydocstyle = callPackage ../development/python-modules/pydocstyle { };

  pydocumentdb = callPackage ../development/python-modules/pydocumentdb { };

  pydoe = callPackage ../development/python-modules/pydoe { };

  pydoods = callPackage ../development/python-modules/pydoods { };

  pydot = callPackage ../development/python-modules/pydot { inherit (pkgs) graphviz; };

  pydrawise = callPackage ../development/python-modules/pydrawise { };

  pydrive2 = callPackage ../development/python-modules/pydrive2 { };

  pydroid-ipcam = callPackage ../development/python-modules/pydroid-ipcam { };

  pydroplet = callPackage ../development/python-modules/pydroplet { };

  pydruid = callPackage ../development/python-modules/pydruid { };

  pydsdl = callPackage ../development/python-modules/pydsdl { };

  pydub = callPackage ../development/python-modules/pydub { };

  pyduke-energy = callPackage ../development/python-modules/pyduke-energy { };

  pyduotecno = callPackage ../development/python-modules/pyduotecno { };

  pydy = callPackage ../development/python-modules/pydy { };

  pydyf = callPackage ../development/python-modules/pydyf { };

  pyeapi = callPackage ../development/python-modules/pyeapi { };

  pyebox = callPackage ../development/python-modules/pyebox { };

  pyebus = callPackage ../development/python-modules/pyebus { };

  pyecharts = callPackage ../development/python-modules/pyecharts { };

  pyeclib = callPackage ../development/python-modules/pyeclib { };

  pyecoforest = callPackage ../development/python-modules/pyecoforest { };

  pyeconet = callPackage ../development/python-modules/pyeconet { };

  pyecotrend-ista = callPackage ../development/python-modules/pyecotrend-ista { };

  pyecowitt = callPackage ../development/python-modules/pyecowitt { };

  pyedflib = callPackage ../development/python-modules/pyedflib { };

  pyedimax = callPackage ../development/python-modules/pyedimax { };

  pyee = callPackage ../development/python-modules/pyee { };

  pyefergy = callPackage ../development/python-modules/pyefergy { };

  pyegps = callPackage ../development/python-modules/pyegps { };

  pyeight = callPackage ../development/python-modules/pyeight { };

  pyeiscp = callPackage ../development/python-modules/pyeiscp { };

  pyelectra = callPackage ../development/python-modules/pyelectra { };

  pyelftools = callPackage ../development/python-modules/pyelftools { };

  pyembroidery = callPackage ../development/python-modules/pyembroidery { };

  pyemby = callPackage ../development/python-modules/pyemby { };

  pyemd = callPackage ../development/python-modules/pyemd { };

  pyemoncms = callPackage ../development/python-modules/pyemoncms { };

  pyemvue = callPackage ../development/python-modules/pyemvue { };

  pyenchant = callPackage ../development/python-modules/pyenchant { inherit (pkgs) enchant2; };

  pyenphase = callPackage ../development/python-modules/pyenphase { };

  pyenvisalink = callPackage ../development/python-modules/pyenvisalink { };

  pyephember2 = callPackage ../development/python-modules/pyephember2 { };

  pyepsg = callPackage ../development/python-modules/pyepsg { };

  pyequihash = callPackage ../development/python-modules/pyequihash { };

  pyerfa = callPackage ../development/python-modules/pyerfa { };

  pyeverlights = callPackage ../development/python-modules/pyeverlights { };

  pyevilgenius = callPackage ../development/python-modules/pyevilgenius { };

  pyevmasm = callPackage ../development/python-modules/pyevmasm { };

  pyevtk = callPackage ../development/python-modules/pyevtk { };

  pyexcel = callPackage ../development/python-modules/pyexcel { };

  pyexcel-io = callPackage ../development/python-modules/pyexcel-io { };

  pyexcel-ods = callPackage ../development/python-modules/pyexcel-ods { };

  pyexcel-xls = callPackage ../development/python-modules/pyexcel-xls { };

  pyexiftool = callPackage ../development/python-modules/pyexiftool { };

  pyexpect = callPackage ../development/python-modules/pyexpect { };

  pyexploitdb = callPackage ../development/python-modules/pyexploitdb { };

  pyezvizapi = callPackage ../development/python-modules/pyezvizapi { };

  pyface = callPackage ../development/python-modules/pyface { };

  pyfaidx = callPackage ../development/python-modules/pyfaidx { };

  pyfakefs = callPackage ../development/python-modules/pyfakefs { };

  pyfakewebcam = callPackage ../development/python-modules/pyfakewebcam { };

  pyfatfs = callPackage ../development/python-modules/pyfatfs { };

  pyfcm = callPackage ../development/python-modules/pyfcm { };

  pyfdt = callPackage ../development/python-modules/pyfdt { };

  pyfibaro = callPackage ../development/python-modules/pyfibaro { };

  pyfido = callPackage ../development/python-modules/pyfido { };

  pyfiglet = callPackage ../development/python-modules/pyfiglet { };

  pyfirefly = callPackage ../development/python-modules/pyfirefly { };

  pyfireservicerota = callPackage ../development/python-modules/pyfireservicerota { };

  pyflakes = callPackage ../development/python-modules/pyflakes { };

  pyflexit = callPackage ../development/python-modules/pyflexit { };

  pyflic = callPackage ../development/python-modules/pyflic { };

  pyflick = callPackage ../development/python-modules/pyflick { };

  pyflipper = callPackage ../development/python-modules/pyflipper { };

  pyfluidsynth = callPackage ../development/python-modules/pyfluidsynth { };

  pyflume = callPackage ../development/python-modules/pyflume { };

  pyfma = callPackage ../development/python-modules/pyfma { };

  pyfnip = callPackage ../development/python-modules/pyfnip { };

  pyforked-daapd = callPackage ../development/python-modules/pyforked-daapd { };

  pyformlang = callPackage ../development/python-modules/pyformlang { };

  pyfreedompro = callPackage ../development/python-modules/pyfreedompro { };

  pyfribidi = callPackage ../development/python-modules/pyfribidi { };

  pyfritzhome = callPackage ../development/python-modules/pyfritzhome { };

  pyfronius = callPackage ../development/python-modules/pyfronius { };

  pyftdi = callPackage ../development/python-modules/pyftdi { };

  pyftgl = callPackage ../development/python-modules/pyftgl { };

  pyftpdlib = callPackage ../development/python-modules/pyftpdlib { };

  pyfttt = callPackage ../development/python-modules/pyfttt { };

  pyfume = callPackage ../development/python-modules/pyfume { };

  pyfunctional = callPackage ../development/python-modules/pyfunctional { };

  pyfuse3 = callPackage ../development/python-modules/pyfuse3 { };

  pyfwup = callPackage ../development/python-modules/pyfwup { inherit (pkgs) libusb1; };

  pyfxa = callPackage ../development/python-modules/pyfxa { };

  pyfzf = callPackage ../development/python-modules/pyfzf { inherit (pkgs) fzf; };

  pygal = callPackage ../development/python-modules/pygal { };

  pygame = callPackage ../development/python-modules/pygame { };

  pygame-ce = callPackage ../development/python-modules/pygame-ce { };

  pygame-gui = callPackage ../development/python-modules/pygame-gui { };

  pygame-sdl2 = callPackage ../development/python-modules/pygame-sdl2 { };

  pygatt = callPackage ../development/python-modules/pygatt { };

  pygccxml = callPackage ../development/python-modules/pygccxml { };

  pygdbmi = callPackage ../development/python-modules/pygdbmi { };

  pygelf = callPackage ../development/python-modules/pygelf { };

  pygeocodio = callPackage ../development/python-modules/pygeocodio { };

  pygerber = callPackage ../development/python-modules/pygerber { };

  pygetwindow = callPackage ../development/python-modules/pygetwindow { };

  pyghmi = callPackage ../development/python-modules/pyghmi { };

  pygit2 = callPackage ../development/python-modules/pygit2 { };

  pygitguardian = callPackage ../development/python-modules/pygitguardian { };

  pygithub = callPackage ../development/python-modules/pygithub { };

  pyglet = callPackage ../development/python-modules/pyglet { };

  pyglm = callPackage ../development/python-modules/pyglm { };

  pyglossary = callPackage ../development/python-modules/pyglossary { };

  pygls = pygls_1;

  pygls_1 = callPackage ../development/python-modules/pygls/1.nix {
    lsprotocol = lsprotocol_2023;
  };

  pygls_2 = callPackage ../development/python-modules/pygls/2.nix {
    lsprotocol = lsprotocol_2025;
  };

  pygltflib = callPackage ../development/python-modules/pygltflib { };

  pygmars = callPackage ../development/python-modules/pygmars { };

  pygments = callPackage ../development/python-modules/pygments { };

  pygments-better-html = callPackage ../development/python-modules/pygments-better-html { };

  pygments-markdown-lexer = callPackage ../development/python-modules/pygments-markdown-lexer { };

  pygments-style-github = callPackage ../development/python-modules/pygments-style-github { };

  pygmo = callPackage ../development/python-modules/pygmo { };

  pygmt = callPackage ../development/python-modules/pygmt { };

  pygnmi = callPackage ../development/python-modules/pygnmi { };

  pygnuutils = callPackage ../development/python-modules/pygnuutils { };

  pygobject-stubs = callPackage ../development/python-modules/pygobject-stubs { };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.nix {
    # inherit (pkgs) meson won't work because it won't be spliced
    inherit (pkgs.buildPackages) meson;
  };

  pygount = callPackage ../development/python-modules/pygount { };

  pygpgme = callPackage ../development/python-modules/pygpgme { };

  pygraphviz = callPackage ../development/python-modules/pygraphviz { inherit (pkgs) graphviz; };

  pygreat = callPackage ../development/python-modules/pygreat { };

  pygrok = callPackage ../development/python-modules/pygrok { };

  pygsl = callPackage ../development/python-modules/pygsl { inherit (pkgs) gsl swig; };

  pygtail = callPackage ../development/python-modules/pygtail { };

  pygtfs = callPackage ../development/python-modules/pygtfs { };

  pygti = callPackage ../development/python-modules/pygti { };

  pygtkspellcheck = callPackage ../development/python-modules/pygtkspellcheck { };

  pygtrie = callPackage ../development/python-modules/pygtrie { };

  pyhacrf-datamade = callPackage ../development/python-modules/pyhacrf-datamade { };

  pyhamcrest = callPackage ../development/python-modules/pyhamcrest { };

  pyhanko = callPackage ../development/python-modules/pyhanko { };

  pyhanko-certvalidator = callPackage ../development/python-modules/pyhanko-certvalidator { };

  pyhaversion = callPackage ../development/python-modules/pyhaversion { };

  pyhcl = callPackage ../development/python-modules/pyhcl { };

  pyhdfe = callPackage ../development/python-modules/pyhdfe { };

  pyheck = callPackage ../development/python-modules/pyheck { };

  pyheos = callPackage ../development/python-modules/pyheos { };

  pyhepmc = callPackage ../development/python-modules/pyhepmc { };

  pyhibp = callPackage ../development/python-modules/pyhibp { };

  pyhidra = callPackage ../development/python-modules/pyhidra { };

  pyhik = callPackage ../development/python-modules/pyhik { };

  pyhive-integration = callPackage ../development/python-modules/pyhive-integration { };

  pyhocon = callPackage ../development/python-modules/pyhocon { };

  pyhomee = callPackage ../development/python-modules/pyhomee { };

  pyhomematic = callPackage ../development/python-modules/pyhomematic { };

  pyhomepilot = callPackage ../development/python-modules/pyhomepilot { };

  pyhomeworks = callPackage ../development/python-modules/pyhomeworks { };

  pyhumps = callPackage ../development/python-modules/pyhumps { };

  pyi2cflash = callPackage ../development/python-modules/pyi2cflash { };

  pyialarm = callPackage ../development/python-modules/pyialarm { };

  pyiceberg = callPackage ../development/python-modules/pyiceberg { };

  pyiceberg-core = callPackage ../development/python-modules/pyiceberg-core { };

  pyicloud = callPackage ../development/python-modules/pyicloud { };

  pyicu = callPackage ../development/python-modules/pyicu { };

  pyicumessageformat = callPackage ../development/python-modules/pyicumessageformat { };

  pyimg4 = callPackage ../development/python-modules/pyimg4 { };

  pyimgbox = callPackage ../development/python-modules/pyimgbox { };

  pyimpfuzzy = callPackage ../development/python-modules/pyimpfuzzy { inherit (pkgs) ssdeep; };

  pyindego = callPackage ../development/python-modules/pyindego { };

  pyinfra = callPackage ../development/python-modules/pyinfra { };

  pyinotify = callPackage ../development/python-modules/pyinotify { };

  pyinputevent = callPackage ../development/python-modules/pyinputevent { };

  pyinstaller = callPackage ../development/python-modules/pyinstaller { };

  pyinstaller-hooks-contrib = callPackage ../development/python-modules/pyinstaller-hooks-contrib { };

  pyinstaller-versionfile = callPackage ../development/python-modules/pyinstaller-versionfile { };

  pyinsteon = callPackage ../development/python-modules/pyinsteon { };

  pyinstrument = callPackage ../development/python-modules/pyinstrument { };

  pyinterp = callPackage ../development/python-modules/pyinterp { };

  pyintesishome = callPackage ../development/python-modules/pyintesishome { };

  pyipma = callPackage ../development/python-modules/pyipma { };

  pyipp = callPackage ../development/python-modules/pyipp { };

  pyipv8 = callPackage ../development/python-modules/pyipv8 { };

  pyiqvia = callPackage ../development/python-modules/pyiqvia { };

  pyirishrail = callPackage ../development/python-modules/pyirishrail { };

  pyisbn = callPackage ../development/python-modules/pyisbn { };

  pyisemail = callPackage ../development/python-modules/pyisemail { };

  pyiskra = callPackage ../development/python-modules/pyiskra { };

  pyiss = callPackage ../development/python-modules/pyiss { };

  pyisy = callPackage ../development/python-modules/pyisy { };

  pyitachip2ir = callPackage ../development/python-modules/pyitachip2ir { };

  pyituran = callPackage ../development/python-modules/pyituran { };

  pyixapi = callPackage ../development/python-modules/pyixapi { };

  pyjks = callPackage ../development/python-modules/pyjks { };

  pyjnius = callPackage ../development/python-modules/pyjnius { };

  pyjpegls = callPackage ../development/python-modules/pyjpegls { };

  pyjson5 = callPackage ../development/python-modules/pyjson5 { };

  pyjsparser = callPackage ../development/python-modules/pyjsparser { };

  pyjvcprojector = callPackage ../development/python-modules/pyjvcprojector { };

  pyjwkest = callPackage ../development/python-modules/pyjwkest { };

  pyjwt = callPackage ../development/python-modules/pyjwt { };

  pykakasi = callPackage ../development/python-modules/pykakasi { };

  pykaleidescape = callPackage ../development/python-modules/pykaleidescape { };

  pykalman = callPackage ../development/python-modules/pykalman { };

  pykcs11 = callPackage ../development/python-modules/pykcs11 { };

  pykdebugparser = callPackage ../development/python-modules/pykdebugparser { };

  pykdl = callPackage ../development/python-modules/pykdl { };

  pykdtree = callPackage ../development/python-modules/pykdtree {
    inherit (pkgs.llvmPackages) openmp;
  };

  pykeepass = callPackage ../development/python-modules/pykeepass { };

  pykerberos = callPackage ../development/python-modules/pykerberos { krb5-c = pkgs.krb5; };

  pykeyatome = callPackage ../development/python-modules/pykeyatome { };

  pykira = callPackage ../development/python-modules/pykira { };

  pykka = callPackage ../development/python-modules/pykka { };

  pykmtronic = callPackage ../development/python-modules/pykmtronic { };

  pykodi = callPackage ../development/python-modules/pykodi { };

  pykoplenti = callPackage ../development/python-modules/pykoplenti { };

  pykostalpiko = callPackage ../development/python-modules/pykostalpiko { };

  pykrakenapi = callPackage ../development/python-modules/pykrakenapi { };

  pykrige = callPackage ../development/python-modules/pykrige { };

  pykulersky = callPackage ../development/python-modules/pykulersky { };

  pykwalify = callPackage ../development/python-modules/pykwalify { };

  pykwb = callPackage ../development/python-modules/pykwb { };

  pylacrosse = callPackage ../development/python-modules/pylacrosse { };

  pylacus = callPackage ../development/python-modules/pylacus { };

  pylama = callPackage ../development/python-modules/pylama { };

  pylamarzocco = callPackage ../development/python-modules/pylamarzocco { };

  pylance = callPackage ../development/python-modules/pylance { };

  pylast = callPackage ../development/python-modules/pylast { };

  pylatex = callPackage ../development/python-modules/pylatex { };

  pylatexenc = callPackage ../development/python-modules/pylatexenc { };

  pylaunches = callPackage ../development/python-modules/pylaunches { };

  pyld = callPackage ../development/python-modules/pyld { };

  pyldavis = callPackage ../development/python-modules/pyldavis { };

  pylddwrap = callPackage ../development/python-modules/pylddwrap { };

  pyleri = callPackage ../development/python-modules/pyleri { };

  pylette = callPackage ../development/python-modules/pylette { };

  pylev = callPackage ../development/python-modules/pylev { };

  pylgnetcast = callPackage ../development/python-modules/pylgnetcast { };

  pylibacl = callPackage ../development/python-modules/pylibacl { };

  pylibconfig2 = callPackage ../development/python-modules/pylibconfig2 { };

  pylibdmtx = callPackage ../development/python-modules/pylibdmtx { };

  pylibftdi = callPackage ../development/python-modules/pylibftdi { inherit (pkgs) libusb1; };

  pylibjpeg = callPackage ../development/python-modules/pylibjpeg { };

  pylibjpeg-data = callPackage ../development/python-modules/pylibjpeg-data { };

  pylibjpeg-libjpeg = callPackage ../development/python-modules/pylibjpeg-libjpeg { };

  pylibjpeg-openjpeg = callPackage ../development/python-modules/pylibjpeg-openjpeg { };

  pylibjpeg-rle = callPackage ../development/python-modules/pylibjpeg-rle { };

  pyliblo3 = callPackage ../development/python-modules/pyliblo3 { };

  pylibmc = callPackage ../development/python-modules/pylibmc { };

  pylibrespot-java = callPackage ../development/python-modules/pylibrespot-java { };

  pylibsrtp = callPackage ../development/python-modules/pylibsrtp { };

  pylink-square = callPackage ../development/python-modules/pylink-square { };

  pylint = callPackage ../development/python-modules/pylint { };

  pylint-celery = callPackage ../development/python-modules/pylint-celery { };

  pylint-django = callPackage ../development/python-modules/pylint-django { };

  pylint-flask = callPackage ../development/python-modules/pylint-flask { };

  pylint-odoo = callPackage ../development/python-modules/pylint-odoo { };

  pylint-plugin-utils = callPackage ../development/python-modules/pylint-plugin-utils { };

  pylint-venv = callPackage ../development/python-modules/pylint-venv { };

  pylion = callPackage ../development/python-modules/pylion { };

  pylit = callPackage ../development/python-modules/pylit { };

  pylitejet = callPackage ../development/python-modules/pylitejet { };

  pylitterbot = callPackage ../development/python-modules/pylitterbot { };

  pylnk3 = callPackage ../development/python-modules/pylnk3 { };

  pyloadapi = callPackage ../development/python-modules/pyloadapi { };

  pyloggermanager = callPackage ../development/python-modules/pyloggermanager { };

  pylpsd = callPackage ../development/python-modules/pylpsd { };

  pylru = callPackage ../development/python-modules/pylru { };

  pyls-flake8 = callPackage ../development/python-modules/pyls-flake8 { };

  pyls-isort = callPackage ../development/python-modules/pyls-isort { };

  pyls-memestra = callPackage ../development/python-modules/pyls-memestra { };

  pyls-spyder = callPackage ../development/python-modules/pyls-spyder { };

  pylsl = callPackage ../development/python-modules/pylsl { };

  pylsp-mypy = callPackage ../development/python-modules/pylsp-mypy { };

  pylsp-rope = callPackage ../development/python-modules/pylsp-rope { };

  pylsqpack = callPackage ../development/python-modules/pylsqpack { };

  pylutron = callPackage ../development/python-modules/pylutron { };

  pylutron-caseta = callPackage ../development/python-modules/pylutron-caseta { };

  pyluwen = callPackage ../development/python-modules/pyluwen { };

  pylxd = callPackage ../development/python-modules/pylxd { };

  pylyrics = callPackage ../development/python-modules/pylyrics { };

  pylzma = callPackage ../development/python-modules/pylzma { };

  pylzss = callPackage ../development/python-modules/pylzss { };

  pym3u8downloader = callPackage ../development/python-modules/pym3u8downloader { };

  pymacaroons = callPackage ../development/python-modules/pymacaroons { };

  pymailgunner = callPackage ../development/python-modules/pymailgunner { };

  pymanopt = callPackage ../development/python-modules/pymanopt { };

  pymarshal = callPackage ../development/python-modules/pymarshal { };

  pymata-express = callPackage ../development/python-modules/pymata-express { };

  pymatgen = callPackage ../development/python-modules/pymatgen { };

  pymatreader = callPackage ../development/python-modules/pymatreader { };

  pymatting = callPackage ../development/python-modules/pymatting { };

  pymaven-patch = callPackage ../development/python-modules/pymaven-patch { };

  pymavlink = callPackage ../development/python-modules/pymavlink { };

  pymbolic = callPackage ../development/python-modules/pymbolic { };

  pymc = callPackage ../development/python-modules/pymc { };

  pymdown-extensions = callPackage ../development/python-modules/pymdown-extensions { };

  pymdstat = callPackage ../development/python-modules/pymdstat { };

  pymediainfo = callPackage ../development/python-modules/pymediainfo { };

  pymediaroom = callPackage ../development/python-modules/pymediaroom { };

  pymedio = callPackage ../development/python-modules/pymedio { };

  pymee = callPackage ../development/python-modules/pymee { };

  pymeeus = callPackage ../development/python-modules/pymeeus { };

  pymemcache = callPackage ../development/python-modules/pymemcache { };

  pymemoize = callPackage ../development/python-modules/pymemoize { };

  pyment = callPackage ../development/python-modules/pyment { };

  pymeshlab = toPythonModule (pkgs.libsForQt5.callPackage ../applications/graphics/pymeshlab { });

  pymeta3 = callPackage ../development/python-modules/pymeta3 { };

  pymetar = callPackage ../development/python-modules/pymetar { };

  pymetasploit3 = callPackage ../development/python-modules/pymetasploit3 { };

  pymeteireann = callPackage ../development/python-modules/pymeteireann { };

  pymeteoclimatic = callPackage ../development/python-modules/pymeteoclimatic { };

  pymetno = callPackage ../development/python-modules/pymetno { };

  pymfy = callPackage ../development/python-modules/pymfy { };

  pymicro-vad = callPackage ../development/python-modules/pymicro-vad { };

  pymicrobot = callPackage ../development/python-modules/pymicrobot { };

  pymiele = callPackage ../development/python-modules/pymiele { };

  pymilter = callPackage ../development/python-modules/pymilter { };

  pymilvus = callPackage ../development/python-modules/pymilvus { };

  pymitsubishi = callPackage ../development/python-modules/pymitsubishi { };

  pymitv = callPackage ../development/python-modules/pymitv { };

  pymobiledevice3 = callPackage ../development/python-modules/pymobiledevice3 { };

  pymochad = callPackage ../development/python-modules/pymochad { };

  pymodbus = callPackage ../development/python-modules/pymodbus { };

  pymodbus-repl = callPackage ../development/python-modules/pymodbus-repl { };

  pymodes = callPackage ../development/python-modules/pymodes { };

  pymonctl = callPackage ../development/python-modules/pymonctl { };

  pymongo = callPackage ../development/python-modules/pymongo { };

  pymongo-inmemory = callPackage ../development/python-modules/pymongo-inmemory { };

  pymonoprice = callPackage ../development/python-modules/pymonoprice { };

  pymoo = callPackage ../development/python-modules/pymoo { };

  pymorphy2 = callPackage ../development/python-modules/pymorphy2 { };

  pymorphy2-dicts-ru = callPackage ../development/python-modules/pymorphy2-dicts-ru { };

  pymorphy3 = callPackage ../development/python-modules/pymorphy3 { };

  pymorphy3-dicts-ru = callPackage ../development/python-modules/pymorphy3-dicts-ru { };

  pymorphy3-dicts-uk = callPackage ../development/python-modules/pymorphy3-dicts-uk { };

  pympler = callPackage ../development/python-modules/pympler { };

  pymsgbox = callPackage ../development/python-modules/pymsgbox { };

  pymssql = callPackage ../development/python-modules/pymssql { krb5-c = pkgs.krb5; };

  pymsteams = callPackage ../development/python-modules/pymsteams { };

  pymumble = callPackage ../development/python-modules/pymumble { };

  pymunk = callPackage ../development/python-modules/pymunk { };

  pymupdf = callPackage ../development/python-modules/pymupdf { };

  pymupdf-fonts = callPackage ../development/python-modules/pymupdf-fonts { };

  pymupdf4llm = callPackage ../development/python-modules/pymupdf4llm { };

  pymvglive = callPackage ../development/python-modules/pymvglive { };

  pymysensors = callPackage ../development/python-modules/pymysensors { };

  pymysql = callPackage ../development/python-modules/pymysql { };

  pymysqlsa = callPackage ../development/python-modules/pymysqlsa { };

  pymystem3 = callPackage ../development/python-modules/pymystem3 { };

  pynac = callPackage ../development/python-modules/pynac { };

  pynacl = callPackage ../development/python-modules/pynacl { };

  pynamecheap = callPackage ../development/python-modules/pynamecheap { };

  pynamodb = callPackage ../development/python-modules/pynamodb { };

  pynanoleaf = callPackage ../development/python-modules/pynanoleaf { };

  pync = callPackage ../development/python-modules/pync { inherit (pkgs) which; };

  pynecil = callPackage ../development/python-modules/pynecil { };

  pynello = callPackage ../development/python-modules/pynello { };

  pynest2d = callPackage ../development/python-modules/pynest2d { };

  pynetbox = callPackage ../development/python-modules/pynetbox { };

  pynetdicom = callPackage ../development/python-modules/pynetdicom { };

  pynetgear = callPackage ../development/python-modules/pynetgear { };

  pynetio = callPackage ../development/python-modules/pynetio { };

  pynfsclient = callPackage ../development/python-modules/pynfsclient { };

  pyngo = callPackage ../development/python-modules/pyngo { };

  pyngrok = callPackage ../development/python-modules/pyngrok { };

  pynina = callPackage ../development/python-modules/pynina { };

  pynintendoparental = callPackage ../development/python-modules/pynintendoparental { };

  pynipap = callPackage ../development/python-modules/pynipap { };

  pynisher = callPackage ../development/python-modules/pynisher { };

  pynitrokey = callPackage ../development/python-modules/pynitrokey { };

  pynmea2 = callPackage ../development/python-modules/pynmea2 { };

  pynmeagps = callPackage ../development/python-modules/pynmeagps { };

  pynndescent = callPackage ../development/python-modules/pynndescent { };

  pynng = callPackage ../development/python-modules/pynng { };

  pynobo = callPackage ../development/python-modules/pynobo { };

  pynordpool = callPackage ../development/python-modules/pynordpool { };

  pynotifier = callPackage ../development/python-modules/pynotifier { };

  pynput = callPackage ../development/python-modules/pynput { };

  pynrrd = callPackage ../development/python-modules/pynrrd { };

  pynslookup = callPackage ../development/python-modules/pynslookup { };

  pynuki = callPackage ../development/python-modules/pynuki { };

  pynut2 = callPackage ../development/python-modules/pynut2 { };

  pynvim = callPackage ../development/python-modules/pynvim { };

  pynvim-pp = callPackage ../development/python-modules/pynvim-pp { };

  pynvml = callPackage ../development/python-modules/pynvml { };

  pynws = callPackage ../development/python-modules/pynws { };

  pynx584 = callPackage ../development/python-modules/pynx584 { };

  pynzb = callPackage ../development/python-modules/pynzb { };

  pynzbgetapi = callPackage ../development/python-modules/pynzbgetapi { };

  pyobihai = callPackage ../development/python-modules/pyobihai { };

  pyobjc-core = callPackage ../development/python-modules/pyobjc-core { };

  pyobjc-framework-Cocoa = callPackage ../development/python-modules/pyobjc-framework-Cocoa { };

  pyobjc-framework-Quartz = callPackage ../development/python-modules/pyobjc-framework-Quartz { };

  pyobjc-framework-Security = callPackage ../development/python-modules/pyobjc-framework-Security { };

  pyobjc-framework-WebKit = callPackage ../development/python-modules/pyobjc-framework-WebKit { };

  pyocd = callPackage ../development/python-modules/pyocd { };

  pyocd-pemicro = callPackage ../development/python-modules/pyocd-pemicro { };

  pyocr = callPackage ../development/python-modules/pyocr { tesseract = pkgs.tesseract4; };

  pyoctoprintapi = callPackage ../development/python-modules/pyoctoprintapi { };

  pyodbc = callPackage ../development/python-modules/pyodbc { };

  pyogg = callPackage ../development/python-modules/pyogg { };

  pyogrio = callPackage ../development/python-modules/pyogrio { };

  pyombi = callPackage ../development/python-modules/pyombi { };

  pyomo = callPackage ../development/python-modules/pyomo { };

  pyopen-wakeword = callPackage ../development/python-modules/pyopen-wakeword/default.nix { };

  pyopencl = callPackage ../development/python-modules/pyopencl { };

  pyopengl = callPackage ../development/python-modules/pyopengl {
    inherit (pkgs) mesa;
  };

  pyopengl-accelerate = callPackage ../development/python-modules/pyopengl-accelerate { };

  pyopengltk = callPackage ../development/python-modules/pyopengltk { };

  pyopenjtalk = callPackage ../development/python-modules/pyopenjtalk { };

  pyopensprinkler = callPackage ../development/python-modules/pyopensprinkler { };

  pyopenssl = callPackage ../development/python-modules/pyopenssl { };

  pyopenuv = callPackage ../development/python-modules/pyopenuv { };

  pyopenweathermap = callPackage ../development/python-modules/pyopenweathermap { };

  pyopnsense = callPackage ../development/python-modules/pyopnsense { };

  pyoppleio = callPackage ../development/python-modules/pyoppleio { };

  pyoppleio-legacy = callPackage ../development/python-modules/pyoppleio-legacy { };

  pyoprf = callPackage ../development/python-modules/pyoprf { };

  pyorc = callPackage ../development/python-modules/pyorc { };

  pyorthanc = callPackage ../development/python-modules/pyorthanc { };

  pyosf = callPackage ../development/python-modules/pyosf { };

  pyosmium = callPackage ../development/python-modules/pyosmium { inherit (pkgs) lz4; };

  pyosoenergyapi = callPackage ../development/python-modules/pyosoenergyapi { };

  pyosohotwaterapi = callPackage ../development/python-modules/pyosohotwaterapi { };

  pyotb = callPackage ../development/python-modules/pyotb { };

  pyotgw = callPackage ../development/python-modules/pyotgw { };

  pyotp = callPackage ../development/python-modules/pyotp { };

  pyoutbreaksnearme = callPackage ../development/python-modules/pyoutbreaksnearme { };

  pyoverkiz = callPackage ../development/python-modules/pyoverkiz { };

  pyowm = callPackage ../development/python-modules/pyowm { };

  pyoxigraph = callPackage ../development/python-modules/pyoxigraph { };

  pypager = callPackage ../development/python-modules/pypager { };

  pypalazzetti = callPackage ../development/python-modules/pypalazzetti { };

  pypamtest = toPythonModule (
    pkgs.libpam-wrapper.override {
      enablePython = true;
      inherit python;
    }
  );

  pypandoc = callPackage ../development/python-modules/pypandoc { };

  pypaperless = callPackage ../development/python-modules/pypaperless { };

  pyparsebluray = callPackage ../development/python-modules/pyparsebluray { };

  pyparser = callPackage ../development/python-modules/pyparser { };

  pyparsing = callPackage ../development/python-modules/pyparsing { };

  pyparted = callPackage ../development/python-modules/pyparted { };

  pypass = callPackage ../development/python-modules/pypass { };

  pypasser = callPackage ../development/python-modules/pypasser { };

  pypblib = callPackage ../development/python-modules/pypblib { };

  pypca = callPackage ../development/python-modules/pypca { };

  pypck = callPackage ../development/python-modules/pypck { };

  pypdf = callPackage ../development/python-modules/pypdf { };

  pypdf2 = callPackage ../development/python-modules/pypdf2 { };

  pypdf3 = callPackage ../development/python-modules/pypdf3 { };

  pypdfium2 = callPackage ../development/python-modules/pypdfium2 { };

  pypeg2 = callPackage ../development/python-modules/pypeg2 { };

  pypemicro = callPackage ../development/python-modules/pypemicro { };

  pyperclip = callPackage ../development/python-modules/pyperclip { };

  pyperclipfix = callPackage ../development/python-modules/pyperclipfix { };

  pyperf = callPackage ../development/python-modules/pyperf { };

  pyperscan = callPackage ../development/python-modules/pyperscan { };

  pypglab = callPackage ../development/python-modules/pypglab { };

  pyphen = callPackage ../development/python-modules/pyphen { };

  pyphotonfile = callPackage ../development/python-modules/pyphotonfile { };

  pypika = callPackage ../development/python-modules/pypika { };

  pypillowfight = callPackage ../development/python-modules/pypillowfight { };

  pypinyin = callPackage ../development/python-modules/pypinyin { };

  pypiserver = callPackage ../development/python-modules/pypiserver { };

  pypitoken = callPackage ../development/python-modules/pypitoken { };

  pypjlink2 = callPackage ../development/python-modules/pypjlink2 { };

  pyplaato = callPackage ../development/python-modules/pyplaato { };

  pyplatec = callPackage ../development/python-modules/pyplatec { };

  pypng = callPackage ../development/python-modules/pypng { };

  pypoint = callPackage ../development/python-modules/pypoint { };

  pypoolstation = callPackage ../development/python-modules/pypoolstation { };

  pyporscheconnectapi = callPackage ../development/python-modules/pyporscheconnectapi { };

  pyportainer = callPackage ../development/python-modules/pyportainer { };

  pyppeteer = callPackage ../development/python-modules/pyppeteer { };

  pyppeteer-ng = callPackage ../development/python-modules/pyppeteer-ng { };

  pyppmd = callPackage ../development/python-modules/pyppmd { };

  pyprecice = callPackage ../development/python-modules/pyprecice {
    precice = pkgs.precice.override {
      python3Packages = self;
    };
  };

  pypresence = callPackage ../development/python-modules/pypresence { };

  pyprind = callPackage ../development/python-modules/pyprind { };

  pyprobables = callPackage ../development/python-modules/pyprobables { };

  pyprobeplus = callPackage ../development/python-modules/pyprobeplus { };

  pyprof2calltree = callPackage ../development/python-modules/pyprof2calltree { };

  pyproj = callPackage ../development/python-modules/pyproj { };

  pyproject-api = callPackage ../development/python-modules/pyproject-api { };

  pyproject-hooks = callPackage ../development/python-modules/pyproject-hooks { };

  pyproject-metadata = callPackage ../development/python-modules/pyproject-metadata { };

  pyproject-parser = callPackage ../development/python-modules/pyproject-parser { };

  pyprosegur = callPackage ../development/python-modules/pyprosegur { };

  pyprusalink = callPackage ../development/python-modules/pyprusalink { };

  pyps4-2ndscreen = callPackage ../development/python-modules/pyps4-2ndscreen { };

  pypsrp = callPackage ../development/python-modules/pypsrp { };

  pyptlib = callPackage ../development/python-modules/pyptlib { };

  pypubsub = callPackage ../development/python-modules/pypubsub { };

  pypugjs = callPackage ../development/python-modules/pypugjs { };

  pypykatz = callPackage ../development/python-modules/pypykatz { };

  pypytools = callPackage ../development/python-modules/pypytools { };

  pyqodeng-angr = callPackage ../development/python-modules/pyqodeng-angr { };

  pyqrcode = callPackage ../development/python-modules/pyqrcode { };

  pyqt-builder = callPackage ../development/python-modules/pyqt-builder { };

  pyqt3d = pkgs.libsForQt5.callPackage ../development/python-modules/pyqt3d {
    inherit (self)
      buildPythonPackage
      pyqt5
      pyqt-builder
      python
      pythonOlder
      setuptools
      sip
      ;
  };

  pyqt5 = callPackage ../development/python-modules/pyqt/5.x.nix { inherit (pkgs) mesa; };

  pyqt5-multimedia = self.pyqt5.override { withMultimedia = true; };

  pyqt5-sip = callPackage ../development/python-modules/pyqt/sip.nix {
    inherit (pkgs) mesa;
  };

  pyqt5-stubs = callPackage ../development/python-modules/pyqt5-stubs { };

  # `pyqt5-webkit` should not be used by python libraries in
  # pkgs/development/python-modules/*. Putting this attribute in
  # `propagatedBuildInputs` may cause collisions.
  pyqt5-webkit = self.pyqt5.override { withWebKit = true; };

  pyqt6 = callPackage ../development/python-modules/pyqt/6.x.nix {
    inherit (pkgs) mesa;
  };

  pyqt6-charts = callPackage ../development/python-modules/pyqt6-charts {
    inherit (pkgs) mesa;
  };

  pyqt6-sip = callPackage ../development/python-modules/pyqt/pyqt6-sip.nix {
    inherit (pkgs) mesa;
  };

  pyqt6-webengine = callPackage ../development/python-modules/pyqt6-webengine {
    inherit (pkgs) mesa;
  };

  pyqtchart = pkgs.libsForQt5.callPackage ../development/python-modules/pyqtchart {
    inherit (self)
      buildPythonPackage
      pyqt5
      pyqt-builder
      python
      pythonOlder
      setuptools
      sip
      ;
  };

  pyqtdarktheme = callPackage ../development/python-modules/pyqtdarktheme { };

  pyqtdatavisualization =
    pkgs.libsForQt5.callPackage ../development/python-modules/pyqtdatavisualization
      {
        inherit (self)
          buildPythonPackage
          pyqt5
          pyqt-builder
          python
          pythonOlder
          setuptools
          sip
          ;
      };

  pyqtgraph = callPackage ../development/python-modules/pyqtgraph { };

  pyqtwebengine = callPackage ../development/python-modules/pyqtwebengine {
    inherit (pkgs) mesa;
  };

  pyquaternion = callPackage ../development/python-modules/pyquaternion { };

  pyquery = callPackage ../development/python-modules/pyquery { };

  pyquerylist = callPackage ../development/python-modules/pyquerylist { };

  pyquil = callPackage ../development/python-modules/pyquil { };

  pyqvrpro = callPackage ../development/python-modules/pyqvrpro { };

  pyqwikswitch = callPackage ../development/python-modules/pyqwikswitch { };

  pyrabbit2 = callPackage ../development/python-modules/pyrabbit2 { };

  pyrad = callPackage ../development/python-modules/pyrad { };

  pyradiomics = callPackage ../development/python-modules/pyradiomics { };

  pyradios = callPackage ../development/python-modules/pyradios { };

  pyrail = callPackage ../development/python-modules/pyrail { };

  pyrainbird = callPackage ../development/python-modules/pyrainbird { };

  pyramid = callPackage ../development/python-modules/pyramid { };

  pyramid-beaker = callPackage ../development/python-modules/pyramid-beaker { };

  pyramid-chameleon = callPackage ../development/python-modules/pyramid-chameleon { };

  pyramid-exclog = callPackage ../development/python-modules/pyramid-exclog { };

  pyramid-jinja2 = callPackage ../development/python-modules/pyramid-jinja2 { };

  pyramid-mako = callPackage ../development/python-modules/pyramid-mako { };

  pyramid-multiauth = callPackage ../development/python-modules/pyramid-multiauth { };

  pyrate-limiter = callPackage ../development/python-modules/pyrate-limiter { };

  pyrdfa3 = callPackage ../development/python-modules/pyrdfa3 { };

  pyre-extensions = callPackage ../development/python-modules/pyre-extensions { };

  pyreaderwriterlock = callPackage ../development/python-modules/pyreaderwriterlock { };

  pyreadstat = callPackage ../development/python-modules/pyreadstat { };

  pyrealsense2 = toPythonModule (
    pkgs.librealsense.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  pyrealsense2WithCuda = toPythonModule (
    pkgs.librealsenseWithCuda.override {
      cudaSupport = true;
      enablePython = true;
      pythonPackages = self;
    }
  );

  pyrealsense2WithoutCuda = toPythonModule (
    pkgs.librealsenseWithoutCuda.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  pyrecswitch = callPackage ../development/python-modules/pyrecswitch { };

  pyrect = callPackage ../development/python-modules/pyrect { };

  pyregion = callPackage ../development/python-modules/pyregion { };

  pyrender = callPackage ../development/python-modules/pyrender {
    inherit (pkgs) mesa;
  };

  pyrepetierng = callPackage ../development/python-modules/pyrepetierng { };

  pyrevolve = callPackage ../development/python-modules/pyrevolve { };

  pyrfc3339 = callPackage ../development/python-modules/pyrfc3339 { };

  pyrfxtrx = callPackage ../development/python-modules/pyrfxtrx { };

  pyric = callPackage ../development/python-modules/pyric { };

  pyring-buffer = callPackage ../development/python-modules/pyring-buffer { };

  pyrisco = callPackage ../development/python-modules/pyrisco { };

  pyrituals = callPackage ../development/python-modules/pyrituals { };

  pyrmvtransport = callPackage ../development/python-modules/pyrmvtransport { };

  pyro-api = callPackage ../development/python-modules/pyro-api { };

  pyro-ppl = callPackage ../development/python-modules/pyro-ppl { };

  pyro4 = callPackage ../development/python-modules/pyro4 { };

  pyro5 = callPackage ../development/python-modules/pyro5 { };

  pyroaring = callPackage ../development/python-modules/pyroaring { };

  pyrogram = callPackage ../development/python-modules/pyrogram { };

  pyroma = callPackage ../development/python-modules/pyroma { };

  pyroute2 = callPackage ../development/python-modules/pyroute2 { };

  pyrr = callPackage ../development/python-modules/pyrr { };

  pyrsistent = callPackage ../development/python-modules/pyrsistent { };

  pyrss2gen = callPackage ../development/python-modules/pyrss2gen { };

  pyrtlsdr = callPackage ../development/python-modules/pyrtlsdr { };

  pyrympro = callPackage ../development/python-modules/pyrympro { };

  pysabnzbd = callPackage ../development/python-modules/pysabnzbd { };

  pysaj = callPackage ../development/python-modules/pysaj { };

  pysam = callPackage ../development/python-modules/pysam { };

  pysaml2 = callPackage ../development/python-modules/pysaml2 { inherit (pkgs) xmlsec; };

  pysatochip = callPackage ../development/python-modules/pysatochip { };

  pysbd = callPackage ../development/python-modules/pysbd { };

  pysc2 = callPackage ../development/python-modules/pysc2 { };

  pyscaffold = callPackage ../development/python-modules/pyscaffold { };

  pyscaffoldext-cookiecutter =
    callPackage ../development/python-modules/pyscaffoldext-cookiecutter
      { };

  pyscaffoldext-custom-extension =
    callPackage ../development/python-modules/pyscaffoldext-custom-extension
      { };

  pyscaffoldext-django = callPackage ../development/python-modules/pyscaffoldext-django { };

  pyscaffoldext-dsproject = callPackage ../development/python-modules/pyscaffoldext-dsproject { };

  pyscaffoldext-markdown = callPackage ../development/python-modules/pyscaffoldext-markdown { };

  pyscaffoldext-travis = callPackage ../development/python-modules/pyscaffoldext-travis { };

  pyscard = callPackage ../development/python-modules/pyscard { };

  pyscf = callPackage ../development/python-modules/pyscf { };

  pyschedule = callPackage ../development/python-modules/pyschedule { };

  pyschemes = callPackage ../development/python-modules/pyschemes { };

  pyschlage = callPackage ../development/python-modules/pyschlage { };

  pyscreenshot = callPackage ../development/python-modules/pyscreenshot { };

  pyscreeze = callPackage ../development/python-modules/pyscreeze { };

  pyscrypt = callPackage ../development/python-modules/pyscrypt { };

  pyscss = callPackage ../development/python-modules/pyscss { };

  pysdcp = callPackage ../development/python-modules/pysdcp { };

  pysdl2 = callPackage ../development/python-modules/pysdl2 { };

  pysdl3 = callPackage ../development/python-modules/pysdl3 { };

  pysearpc = toPythonModule (pkgs.libsearpc.override { python3 = self.python; });

  pysecretsocks = callPackage ../development/python-modules/pysecretsocks { };

  pysecuritas = callPackage ../development/python-modules/pysecuritas { };

  pysendfile = callPackage ../development/python-modules/pysendfile { };

  pysensibo = callPackage ../development/python-modules/pysensibo { };

  pysensors = callPackage ../development/python-modules/pysensors { };

  pysequoia = callPackage ../development/python-modules/pysequoia { };

  pyserial = callPackage ../development/python-modules/pyserial { };

  pyserial-asyncio = callPackage ../development/python-modules/pyserial-asyncio { };

  pyserial-asyncio-fast = callPackage ../development/python-modules/pyserial-asyncio-fast { };

  pyseries = callPackage ../development/python-modules/pyseries { };

  pysesame2 = callPackage ../development/python-modules/pysesame2 { };

  pyseventeentrack = callPackage ../development/python-modules/pyseventeentrack { };

  pysftp = callPackage ../development/python-modules/pysftp { };

  pyshark = callPackage ../development/python-modules/pyshark { };

  pyshp = callPackage ../development/python-modules/pyshp { };

  pysiaalarm = callPackage ../development/python-modules/pysiaalarm { };

  pyside2 = toPythonModule (
    callPackage ../development/python-modules/pyside2 { inherit (pkgs) cmake ninja qt5; }
  );

  pyside2-tools = toPythonModule (
    callPackage ../development/python-modules/pyside2-tools { inherit (pkgs) cmake qt5; }
  );

  pyside6 = toPythonModule (
    callPackage ../development/python-modules/pyside6 { inherit (pkgs) cmake ninja; }
  );

  pyside6-qtads = callPackage ../development/python-modules/pyside6-qtads { };

  pysigma = callPackage ../development/python-modules/pysigma { };

  pysigma-backend-elasticsearch =
    callPackage ../development/python-modules/pysigma-backend-elasticsearch
      { };

  pysigma-backend-insightidr =
    callPackage ../development/python-modules/pysigma-backend-insightidr
      { };

  pysigma-backend-loki = callPackage ../development/python-modules/pysigma-backend-loki { };

  pysigma-backend-opensearch =
    callPackage ../development/python-modules/pysigma-backend-opensearch
      { };

  pysigma-backend-qradar = callPackage ../development/python-modules/pysigma-backend-qradar { };

  pysigma-backend-splunk = callPackage ../development/python-modules/pysigma-backend-splunk { };

  pysigma-backend-sqlite = callPackage ../development/python-modules/pysigma-backend-sqlite { };

  pysigma-pipeline-crowdstrike =
    callPackage ../development/python-modules/pysigma-pipeline-crowdstrike
      { };

  pysigma-pipeline-sysmon = callPackage ../development/python-modules/pysigma-pipeline-sysmon { };

  pysigma-pipeline-windows = callPackage ../development/python-modules/pysigma-pipeline-windows { };

  pysignalclirestapi = callPackage ../development/python-modules/pysignalclirestapi { };

  pysignalr = callPackage ../development/python-modules/pysignalr { };

  pysigset = callPackage ../development/python-modules/pysigset { };

  pysilero-vad = callPackage ../development/python-modules/pysilero-vad { };

  pysim = callPackage ../development/python-modules/pysim { };

  pysimplesoap = callPackage ../development/python-modules/pysimplesoap { };

  pysingleton = callPackage ../development/python-modules/pysingleton { };

  pyskyqhub = callPackage ../development/python-modules/pyskyqhub { };

  pyskyqremote = callPackage ../development/python-modules/pyskyqremote { };

  pyslim = callPackage ../development/python-modules/pyslim { };

  pyslurm = callPackage ../development/python-modules/pyslurm { inherit (pkgs) slurm; };

  pysma = callPackage ../development/python-modules/pysma { };

  pysmappee = callPackage ../development/python-modules/pysmappee { };

  pysmarlaapi = callPackage ../development/python-modules/pysmarlaapi { };

  pysmart = callPackage ../development/python-modules/pysmart { };

  pysmartapp = callPackage ../development/python-modules/pysmartapp { };

  pysmartdl = callPackage ../development/python-modules/pysmartdl { };

  pysmartthings = callPackage ../development/python-modules/pysmartthings { };

  pysmarty2 = callPackage ../development/python-modules/pysmarty2 { };

  pysmb = callPackage ../development/python-modules/pysmb { };

  pysmbc = callPackage ../development/python-modules/pysmbc { };

  pysmf = callPackage ../development/python-modules/pysmf { };

  pysmhi = callPackage ../development/python-modules/pysmhi { };

  pysmi = callPackage ../development/python-modules/pysmi { };

  pysml = callPackage ../development/python-modules/pysml { };

  pysmlight = callPackage ../development/python-modules/pysmlight { };

  pysmt = callPackage ../development/python-modules/pysmt { };

  pysnmp = callPackage ../development/python-modules/pysnmp { };

  pysnmp-pyasn1 = callPackage ../development/python-modules/pysnmp-pyasn1 { };

  pysnmp-pysmi = callPackage ../development/python-modules/pysnmp-pysmi { };

  pysnmpcrypto = callPackage ../development/python-modules/pysnmpcrypto { };

  pysnmplib = callPackage ../development/python-modules/pysnmplib { };

  pysnooper = callPackage ../development/python-modules/pysnooper { };

  pysnooz = callPackage ../development/python-modules/pysnooz { };

  pysnow = callPackage ../development/python-modules/pysnow { };

  pysocks = callPackage ../development/python-modules/pysocks { };

  pysodium = callPackage ../development/python-modules/pysodium { };

  pysol-cards = callPackage ../development/python-modules/pysol-cards { };

  pysolarmanv5 = callPackage ../development/python-modules/pysolarmanv5 { };

  pysolcast = callPackage ../development/python-modules/pysolcast { };

  pysolr = callPackage ../development/python-modules/pysolr { };

  pysoma = callPackage ../development/python-modules/pysoma { };

  pysonos = callPackage ../development/python-modules/pysonos { };

  pysoundfile = self.soundfile; # Alias added 23-06-2019

  pyspark = callPackage ../development/python-modules/pyspark { };

  pyspcwebgw = callPackage ../development/python-modules/pyspcwebgw { };

  pyspeex-noise = callPackage ../development/python-modules/pyspeex-noise { };

  pyspellchecker = callPackage ../development/python-modules/pyspellchecker { };

  pyspelling = callPackage ../development/python-modules/pyspelling { };

  pyspf = callPackage ../development/python-modules/pyspf { };

  pyspice = callPackage ../development/python-modules/pyspice { };

  pyspiflash = callPackage ../development/python-modules/pyspiflash { };

  pyspinel = callPackage ../development/python-modules/pyspinel { };

  pyspnego = callPackage ../development/python-modules/pyspnego { };

  pysptk = callPackage ../development/python-modules/pysptk { };

  pyspx = callPackage ../development/python-modules/pyspx { };

  pysqlcipher3 = callPackage ../development/python-modules/pysqlcipher3 { inherit (pkgs) sqlcipher; };

  pysqlitecipher = callPackage ../development/python-modules/pysqlitecipher { };

  pysqueezebox = callPackage ../development/python-modules/pysqueezebox { };

  pysrdaligateway = callPackage ../development/python-modules/pysrdaligateway { };

  pysrim = callPackage ../development/python-modules/pysrim { };

  pysrt = callPackage ../development/python-modules/pysrt { };

  pyssim = callPackage ../development/python-modules/pyssim { };

  pystac = callPackage ../development/python-modules/pystac { };

  pystac-client = callPackage ../development/python-modules/pystac-client { };

  pystache = callPackage ../development/python-modules/pystache { };

  pystardict = callPackage ../development/python-modules/pystardict { };

  pystatgrab = callPackage ../development/python-modules/pystatgrab { };

  pystemd = callPackage ../development/python-modules/pystemd { inherit (pkgs) systemd; };

  pystemmer = callPackage ../development/python-modules/pystemmer { };

  pystiebeleltron = callPackage ../development/python-modules/pystiebeleltron { };

  pystray = callPackage ../development/python-modules/pystray { };

  pysubs2 = callPackage ../development/python-modules/pysubs2 { };

  pysuezv2 = callPackage ../development/python-modules/pysuezv2 { };

  pysunspec2 = callPackage ../development/python-modules/pysunspec2 { };

  pysvg-py3 = callPackage ../development/python-modules/pysvg-py3 { };

  pysvn = callPackage ../development/python-modules/pysvn {
    inherit (pkgs)
      bash
      subversion
      apr
      aprutil
      ;
  };

  pyswitchbee = callPackage ../development/python-modules/pyswitchbee { };

  pyswitchbot = callPackage ../development/python-modules/pyswitchbot { };

  pyswitchmate = callPackage ../development/python-modules/pyswitchmate { };

  pysychonaut = callPackage ../development/python-modules/pysychonaut { };

  pysyncobj = callPackage ../development/python-modules/pysyncobj { };

  pysyncthru = callPackage ../development/python-modules/pysyncthru { };

  pytabix = callPackage ../development/python-modules/pytabix { };

  pytablewriter = callPackage ../development/python-modules/pytablewriter { };

  pytaglib = callPackage ../development/python-modules/pytaglib { };

  pytankerkoenig = callPackage ../development/python-modules/pytankerkoenig { };

  pytap2 = callPackage ../development/python-modules/pytap2 { };

  pytapo = callPackage ../development/python-modules/pytapo { };

  pytask = callPackage ../development/python-modules/pytask { };

  pytautulli = callPackage ../development/python-modules/pytautulli { };

  pyte = callPackage ../development/python-modules/pyte { };

  pytelegrambotapi = callPackage ../development/python-modules/pyTelegramBotAPI { };

  pytenable = callPackage ../development/python-modules/pytenable { };

  pytensor = callPackage ../development/python-modules/pytensor { };

  pytesseract = callPackage ../development/python-modules/pytesseract { };

  pytest = callPackage ../development/python-modules/pytest { };

  pytest-aio = callPackage ../development/python-modules/pytest-aio { };

  pytest-aiohttp = callPackage ../development/python-modules/pytest-aiohttp { };

  pytest-aioresponses = callPackage ../development/python-modules/pytest-aioresponses { };

  pytest-annotate = callPackage ../development/python-modules/pytest-annotate { };

  pytest-ansible = callPackage ../development/python-modules/pytest-ansible { };

  pytest-archon = callPackage ../development/python-modules/pytest-archon { };

  pytest-arraydiff = callPackage ../development/python-modules/pytest-arraydiff { };

  pytest-astropy = callPackage ../development/python-modules/pytest-astropy { };

  pytest-astropy-header = callPackage ../development/python-modules/pytest-astropy-header { };

  pytest-asyncio = callPackage ../development/python-modules/pytest-asyncio { };

  pytest-asyncio-cooperative =
    callPackage ../development/python-modules/pytest-asyncio-cooperative
      { };

  pytest-asyncio_0 = callPackage ../development/python-modules/pytest-asyncio/0.nix { };

  pytest-base-url = callPackage ../development/python-modules/pytest-base-url { };

  pytest-bdd = callPackage ../development/python-modules/pytest-bdd { };

  pytest-benchmark = callPackage ../development/python-modules/pytest-benchmark { };

  pytest-black = callPackage ../development/python-modules/pytest-black { };

  pytest-cache = self.pytestcache; # added 2021-01-04

  pytest-cases = callPackage ../development/python-modules/pytest-cases { };

  pytest-catchlog = callPackage ../development/python-modules/pytest-catchlog { };

  pytest-celery = callPackage ../development/python-modules/pytest-celery { };

  pytest-check = callPackage ../development/python-modules/pytest-check { };

  pytest-cid = callPackage ../development/python-modules/pytest-cid { };

  pytest-click = callPackage ../development/python-modules/pytest-click { };

  pytest-codspeed = callPackage ../development/python-modules/pytest-codspeed { };

  pytest-console-scripts = callPackage ../development/python-modules/pytest-console-scripts { };

  pytest-cov = callPackage ../development/python-modules/pytest-cov { };

  pytest-cov-stub = callPackage ../development/python-modules/pytest-cov-stub { };

  pytest-cram = callPackage ../development/python-modules/pytest-cram { };

  pytest-datadir = callPackage ../development/python-modules/pytest-datadir { };

  pytest-datafiles = callPackage ../development/python-modules/pytest-datafiles { };

  pytest-dependency = callPackage ../development/python-modules/pytest-dependency { };

  pytest-describe = callPackage ../development/python-modules/pytest-describe { };

  pytest-django = callPackage ../development/python-modules/pytest-django { };

  pytest-docker = callPackage ../development/python-modules/pytest-docker { };

  pytest-docker-tools = callPackage ../development/python-modules/pytest-docker-tools { };

  pytest-doctestplus = callPackage ../development/python-modules/pytest-doctestplus { };

  pytest-dotenv = callPackage ../development/python-modules/pytest-dotenv { };

  pytest-emoji = callPackage ../development/python-modules/pytest-emoji { };

  pytest-env = callPackage ../development/python-modules/pytest-env { };

  pytest-error-for-skips = callPackage ../development/python-modules/pytest-error-for-skips { };

  pytest-examples = callPackage ../development/python-modules/pytest-examples { };

  pytest-expect = callPackage ../development/python-modules/pytest-expect { };

  pytest-factoryboy = callPackage ../development/python-modules/pytest-factoryboy { };

  pytest-filter-subpackage = callPackage ../development/python-modules/pytest-filter-subpackage { };

  pytest-fixture-config = callPackage ../development/python-modules/pytest-fixture-config { };

  pytest-flake8 = callPackage ../development/python-modules/pytest-flake8 { };

  pytest-flakes = callPackage ../development/python-modules/pytest-flakes { };

  pytest-flask = callPackage ../development/python-modules/pytest-flask { };

  pytest-forked = callPackage ../development/python-modules/pytest-forked { };

  pytest-freezegun = callPackage ../development/python-modules/pytest-freezegun { };

  pytest-freezer = callPackage ../development/python-modules/pytest-freezer { };

  pytest-gitconfig = callPackage ../development/python-modules/pytest-gitconfig { };

  pytest-golden = callPackage ../development/python-modules/pytest-golden { };

  pytest-grpc = callPackage ../development/python-modules/pytest-grpc { };

  pytest-harvest = callPackage ../development/python-modules/pytest-harvest { };

  pytest-helpers-namespace = callPackage ../development/python-modules/pytest-helpers-namespace { };

  pytest-html = callPackage ../development/python-modules/pytest-html { };

  pytest-httpbin = callPackage ../development/python-modules/pytest-httpbin { };

  pytest-httpserver = callPackage ../development/python-modules/pytest-httpserver { };

  pytest-httpx = callPackage ../development/python-modules/pytest-httpx { };

  pytest-icdiff = callPackage ../development/python-modules/pytest-icdiff { };

  pytest-image-diff = callPackage ../development/python-modules/pytest-image-diff { };

  pytest-instafail = callPackage ../development/python-modules/pytest-instafail { };

  pytest-integration = callPackage ../development/python-modules/pytest-integration { };

  pytest-isort = callPackage ../development/python-modules/pytest-isort { };

  pytest-json-report = callPackage ../development/python-modules/pytest-json-report { };

  pytest-jupyter = callPackage ../development/python-modules/pytest-jupyter { };

  pytest-kafka = callPackage ../development/python-modules/pytest-kafka { };

  pytest-lazy-fixture = callPackage ../development/python-modules/pytest-lazy-fixture { };

  pytest-lazy-fixtures = callPackage ../development/python-modules/pytest-lazy-fixtures { };

  pytest-localserver = callPackage ../development/python-modules/pytest-localserver { };

  pytest-logdog = callPackage ../development/python-modules/pytest-logdog { };

  pytest-lsp = callPackage ../development/python-modules/pytest-lsp { };

  pytest-markdown-docs = callPackage ../development/python-modules/pytest-markdown-docs { };

  pytest-md-report = callPackage ../development/python-modules/pytest-md-report { };

  pytest-metadata = callPackage ../development/python-modules/pytest-metadata { };

  pytest-mock = callPackage ../development/python-modules/pytest-mock { };

  pytest-mockito = callPackage ../development/python-modules/pytest-mockito { };

  pytest-mockservers = callPackage ../development/python-modules/pytest-mockservers { };

  pytest-mpi = callPackage ../development/python-modules/pytest-mpi { };

  pytest-mpl = callPackage ../development/python-modules/pytest-mpl { };

  pytest-mypy = callPackage ../development/python-modules/pytest-mypy { };

  pytest-mypy-plugins = callPackage ../development/python-modules/pytest-mypy-plugins { };

  pytest-notebook = callPackage ../development/python-modules/pytest-notebook { };

  pytest-order = callPackage ../development/python-modules/pytest-order { };

  pytest-parallel = callPackage ../development/python-modules/pytest-parallel { };

  pytest-param-files = callPackage ../development/python-modules/pytest-param-files { };

  pytest-playwright = callPackage ../development/python-modules/pytest-playwright { };

  pytest-plt = callPackage ../development/python-modules/pytest-plt { };

  pytest-plus = callPackage ../development/python-modules/pytest-plus { };

  pytest-pook = callPackage ../development/python-modules/pytest-pook { };

  pytest-postgresql = callPackage ../development/python-modules/pytest-postgresql { };

  pytest-pudb = callPackage ../development/python-modules/pytest-pudb { };

  pytest-pycodestyle = callPackage ../development/python-modules/pytest-pycodestyle { };

  pytest-pylint = callPackage ../development/python-modules/pytest-pylint { };

  pytest-pytestrail = callPackage ../development/python-modules/pytest-pytestrail { };

  pytest-qt = callPackage ../development/python-modules/pytest-qt { };

  pytest-quickcheck = callPackage ../development/python-modules/pytest-quickcheck { };

  pytest-raises = callPackage ../development/python-modules/pytest-raises { };

  pytest-raisesregexp = callPackage ../development/python-modules/pytest-raisesregexp { };

  pytest-raisin = callPackage ../development/python-modules/pytest-raisin { };

  pytest-random-order = callPackage ../development/python-modules/pytest-random-order { };

  pytest-randomly = callPackage ../development/python-modules/pytest-randomly { };

  pytest-recording = callPackage ../development/python-modules/pytest-recording { };

  pytest-regressions = callPackage ../development/python-modules/pytest-regressions { };

  pytest-relaxed = callPackage ../development/python-modules/pytest-relaxed { };

  pytest-remotedata = callPackage ../development/python-modules/pytest-remotedata { };

  pytest-repeat = callPackage ../development/python-modules/pytest-repeat { };

  pytest-reraise = callPackage ../development/python-modules/pytest-reraise { };

  pytest-rerunfailures = callPackage ../development/python-modules/pytest-rerunfailures { };

  pytest-resource-path = callPackage ../development/python-modules/pytest-resource-path { };

  pytest-responses = callPackage ../development/python-modules/pytest-responses { };

  pytest-retry = callPackage ../development/python-modules/pytest-retry { };

  pytest-reverse = callPackage ../development/python-modules/pytest-reverse { };

  pytest-ruff = callPackage ../development/python-modules/pytest-ruff { };

  pytest-run-parallel = callPackage ../development/python-modules/pytest-run-parallel { };

  pytest-scim2-server = callPackage ../development/python-modules/pytest-scim2-server { };

  pytest-selenium = callPackage ../development/python-modules/pytest-selenium { };

  pytest-server-fixtures = callPackage ../development/python-modules/pytest-server-fixtures { };

  pytest-services = callPackage ../development/python-modules/pytest-services { };

  pytest-shared-session-scope =
    callPackage ../development/python-modules/pytest-shared-session-scope
      { };

  pytest-shutil = callPackage ../development/python-modules/pytest-shutil { };

  pytest-smtpd = callPackage ../development/python-modules/pytest-smtpd { };

  pytest-snapshot = callPackage ../development/python-modules/pytest-snapshot { };

  pytest-socket = callPackage ../development/python-modules/pytest-socket { };

  pytest-spec = callPackage ../development/python-modules/pytest-spec { };

  pytest-subprocess = callPackage ../development/python-modules/pytest-subprocess { };

  pytest-subtesthack = callPackage ../development/python-modules/pytest-subtesthack { };

  pytest-subtests = callPackage ../development/python-modules/pytest-subtests { };

  pytest-sugar = callPackage ../development/python-modules/pytest-sugar { };

  pytest-tap = callPackage ../development/python-modules/pytest-tap { };

  pytest-test-utils = callPackage ../development/python-modules/pytest-test-utils { };

  pytest-testinfra = callPackage ../development/python-modules/pytest-testinfra { };

  pytest-testmon = callPackage ../development/python-modules/pytest-testmon { };

  pytest-textual-snapshot = callPackage ../development/python-modules/pytest-textual-snapshot { };

  pytest-timeout = callPackage ../development/python-modules/pytest-timeout { };

  pytest-tornado = callPackage ../development/python-modules/pytest-tornado { };

  pytest-tornasync = callPackage ../development/python-modules/pytest-tornasync { };

  pytest-trio = callPackage ../development/python-modules/pytest-trio { };

  pytest-twisted = callPackage ../development/python-modules/pytest-twisted { };

  pytest-unmagic = callPackage ../development/python-modules/pytest-unmagic { };

  pytest-unordered = callPackage ../development/python-modules/pytest-unordered { };

  pytest-variables = callPackage ../development/python-modules/pytest-variables { };

  pytest-vcr = callPackage ../development/python-modules/pytest-vcr { };

  pytest-virtualenv = callPackage ../development/python-modules/pytest-virtualenv { };

  pytest-voluptuous = callPackage ../development/python-modules/pytest-voluptuous { };

  pytest-warnings = callPackage ../development/python-modules/pytest-warnings { };

  pytest-watch = callPackage ../development/python-modules/pytest-watch { };

  pytest-xdist = callPackage ../development/python-modules/pytest-xdist { };

  pytest-xprocess = callPackage ../development/python-modules/pytest-xprocess { };

  pytest-xvfb = callPackage ../development/python-modules/pytest-xvfb { };

  pytest7CheckHook = pytestCheckHook.override { pytest = pytest_7; };

  pytest8_3CheckHook = pytestCheckHook.override { pytest = pytest_8_3; };

  pytest_7 = callPackage ../development/python-modules/pytest/7.nix { };

  pytest_8_3 = callPackage ../development/python-modules/pytest/8_3.nix { };

  pytestcache = callPackage ../development/python-modules/pytestcache { };

  pythinkingcleaner = callPackage ../development/python-modules/pythinkingcleaner { };

  python-aodhclient = callPackage ../development/python-modules/python-aodhclient { };

  python-apt = callPackage ../development/python-modules/python-apt { };

  python-arango = callPackage ../development/python-modules/python-arango { };

  python-awair = callPackage ../development/python-modules/python-awair { };

  python-axolotl = callPackage ../development/python-modules/python-axolotl { };

  python-axolotl-curve25519 = callPackage ../development/python-modules/python-axolotl-curve25519 { };

  python-barbicanclient = callPackage ../development/python-modules/python-barbicanclient { };

  python-barcode = callPackage ../development/python-modules/python-barcode { };

  python-baseconv = callPackage ../development/python-modules/python-baseconv { };

  python-benedict = callPackage ../development/python-modules/python-benedict { };

  python-bidi = callPackage ../development/python-modules/python-bidi { };

  python-binance = callPackage ../development/python-modules/python-binance { };

  python-bitcoinlib = callPackage ../development/python-modules/python-bitcoinlib { };

  python-blockchain-api = callPackage ../development/python-modules/python-blockchain-api { };

  python-box = callPackage ../development/python-modules/python-box { };

  python-bsblan = callPackage ../development/python-modules/python-bsblan { };

  python-bugzilla = callPackage ../development/python-modules/python-bugzilla { };

  python-calamine = callPackage ../development/python-modules/python-calamine { };

  python-can = callPackage ../development/python-modules/python-can { };

  python-cinderclient = callPackage ../development/python-modules/python-cinderclient { };

  python-citybikes = callPackage ../development/python-modules/python-citybikes { };

  python-clementine-remote = callPackage ../development/python-modules/python-clementine-remote { };

  python-codon-tables = callPackage ../development/python-modules/python-codon-tables { };

  python-coinmarketcap = callPackage ../development/python-modules/python-coinmarketcap { };

  python-constraint = callPackage ../development/python-modules/python-constraint { };

  python-creole = callPackage ../development/python-modules/python-creole { };

  python-crfsuite = callPackage ../development/python-modules/python-crfsuite { };

  python-crontab = callPackage ../development/python-modules/python-crontab { };

  python-csxcad = callPackage ../development/python-modules/python-csxcad { };

  python-ctags3 = callPackage ../development/python-modules/python-ctags3 { };

  python-daemon = callPackage ../development/python-modules/python-daemon { };

  python-dali = callPackage ../development/python-modules/python-dali { };

  python-datemath = callPackage ../development/python-modules/python-datemath { };

  python-dateutil = callPackage ../development/python-modules/python-dateutil { };

  python-dbusmock = callPackage ../development/python-modules/python-dbusmock { };

  python-debian = callPackage ../development/python-modules/python-debian { };

  python-decouple = callPackage ../development/python-modules/python-decouple { };

  python-designateclient = callPackage ../development/python-modules/python-designateclient { };

  python-didl-lite = callPackage ../development/python-modules/python-didl-lite { };

  python-digitalocean = callPackage ../development/python-modules/python-digitalocean { };

  python-djvulibre = callPackage ../development/python-modules/python-djvulibre { };

  python-docs-theme = callPackage ../development/python-modules/python-docs-theme { };

  python-docx = callPackage ../development/python-modules/python-docx { };

  python-doi = callPackage ../development/python-modules/python-doi { };

  python-dotenv = callPackage ../development/python-modules/python-dotenv { };

  python-ecobee-api = callPackage ../development/python-modules/python-ecobee-api { };

  python-editor = callPackage ../development/python-modules/python-editor { };

  python-engineio = callPackage ../development/python-modules/python-engineio { };

  python-engineio-v3 = callPackage ../development/python-modules/python-engineio-v3 { };

  python-escpos = callPackage ../development/python-modules/python-escpos { };

  python-etcd = callPackage ../development/python-modules/python-etcd { };

  python-etherscan-api = callPackage ../development/python-modules/python-etherscan-api { };

  python-ev3dev2 = callPackage ../development/python-modules/python-ev3dev2 { };

  python-family-hub-local = callPackage ../development/python-modules/python-family-hub-local { };

  python-fedora = callPackage ../development/python-modules/python-fedora { };

  python-ffmpeg = callPackage ../development/python-modules/python-ffmpeg { };

  python-flirt = callPackage ../development/python-modules/python-flirt { };

  python-fontconfig = callPackage ../development/python-modules/python-fontconfig { };

  python-frontmatter = callPackage ../development/python-modules/python-frontmatter { };

  python-fsutil = callPackage ../development/python-modules/python-fsutil { };

  python-fullykiosk = callPackage ../development/python-modules/python-fullykiosk { };

  python-fx = callPackage ../development/python-modules/python-fx { };

  python-gammu = callPackage ../development/python-modules/python-gammu { };

  python-gc100 = callPackage ../development/python-modules/python-gc100 { };

  python-gitlab = callPackage ../development/python-modules/python-gitlab { };

  python-glanceclient = callPackage ../development/python-modules/python-glanceclient { };

  python-gnupg = callPackage ../development/python-modules/python-gnupg { };

  python-google-drive-api = callPackage ../development/python-modules/python-google-drive-api { };

  python-google-nest = callPackage ../development/python-modules/python-google-nest { };

  python-gvm = callPackage ../development/python-modules/python-gvm { };

  python-hcl2 = callPackage ../development/python-modules/python-hcl2 { };

  python-heatclient = callPackage ../development/python-modules/python-heatclient { };

  python-hglib = callPackage ../development/python-modules/python-hglib { };

  python-hl7 = callPackage ../development/python-modules/python-hl7 { };

  python-homeassistant-analytics =
    callPackage ../development/python-modules/python-homeassistant-analytics
      { };

  python-homewizard-energy = callPackage ../development/python-modules/python-homewizard-energy { };

  python-hosts = callPackage ../development/python-modules/python-hosts { };

  python-hpilo = callPackage ../development/python-modules/python-hpilo { };

  python-http-client = callPackage ../development/python-modules/python-http-client { };

  python-i18n = callPackage ../development/python-modules/python-i18n { };

  python-idzip = callPackage ../development/python-modules/python-idzip { };

  python-ipmi = callPackage ../development/python-modules/python-ipmi { };

  python-ipware = callPackage ../development/python-modules/python-ipware { };

  python-ironicclient = callPackage ../development/python-modules/python-ironicclient { };

  python-iso639 = callPackage ../development/python-modules/python-iso639 { };

  python-izone = callPackage ../development/python-modules/python-izone { };

  python-jenkins = callPackage ../development/python-modules/python-jenkins { };

  python-join-api = callPackage ../development/python-modules/python-join-api { };

  python-jose = callPackage ../development/python-modules/python-jose { };

  python-json-logger = callPackage ../development/python-modules/python-json-logger { };

  python-jsonpath = callPackage ../development/python-modules/python-jsonpath { };

  python-juicenet = callPackage ../development/python-modules/python-juicenet { };

  python-kadmin-rs = callPackage ../development/python-modules/python-kadmin-rs { };

  python-kasa = callPackage ../development/python-modules/python-kasa { };

  python-keycloak = callPackage ../development/python-modules/python-keycloak { };

  python-keystoneclient = callPackage ../development/python-modules/python-keystoneclient { };

  python-ldap = callPackage ../development/python-modules/python-ldap {
    inherit (pkgs) openldap cyrus_sasl;
  };

  python-ldap-test = callPackage ../development/python-modules/python-ldap-test { };

  python-libnmap = callPackage ../development/python-modules/python-libnmap { };

  python-linkplay = callPackage ../development/python-modules/python-linkplay { };

  python-linux-procfs = callPackage ../development/python-modules/python-linux-procfs { };

  python-logging-loki = callPackage ../development/python-modules/python-logging-loki { };

  python-logstash = callPackage ../development/python-modules/python-logstash { };

  python-lorem = callPackage ../development/python-modules/python-lorem { };

  python-louvain = callPackage ../development/python-modules/python-louvain { };

  python-lsp-black = callPackage ../development/python-modules/python-lsp-black { };

  python-lsp-jsonrpc = callPackage ../development/python-modules/python-lsp-jsonrpc { };

  python-lsp-ruff = callPackage ../development/python-modules/python-lsp-ruff { };

  python-lsp-server = callPackage ../development/python-modules/python-lsp-server { };

  python-ly = callPackage ../development/python-modules/python-ly { };

  python-lzf = callPackage ../development/python-modules/python-lzf { };

  python-lzo = callPackage ../development/python-modules/python-lzo { inherit (pkgs) lzo; };

  python-magic = callPackage ../development/python-modules/python-magic { };

  python-magnumclient = callPackage ../development/python-modules/python-magnumclient { };

  python-manilaclient = callPackage ../development/python-modules/python-manilaclient { };

  python-mapnik = callPackage ../development/python-modules/python-mapnik rec {
    inherit (pkgs)
      pkg-config
      cairo
      icu
      libjpeg
      libpng
      libtiff
      libwebp
      proj
      zlib
      ;
    boost = pkgs.boost.override {
      enablePython = true;
      inherit python;
    };
    harfbuzz = pkgs.harfbuzz.override { withIcu = true; };
    mapnik = pkgs.mapnik.override { inherit boost harfbuzz; };
  };

  python-markdown-math = callPackage ../development/python-modules/python-markdown-math { };

  python-matter-server = callPackage ../development/python-modules/python-matter-server { };

  python-mbedtls = callPackage ../development/python-modules/python-mbedtls { };

  python-melcloud = callPackage ../development/python-modules/python-melcloud { };

  python-memcached = callPackage ../development/python-modules/python-memcached {
    inherit (pkgs) memcached;
  };

  python-miio = callPackage ../development/python-modules/python-miio { };

  python-mimeparse = callPackage ../development/python-modules/python-mimeparse { };

  python-mistralclient = callPackage ../development/python-modules/python-mistralclient { };

  python-mnist = callPackage ../development/python-modules/python-mnist { };

  python-motionmount = callPackage ../development/python-modules/python-motionmount { };

  python-mpv-jsonipc = callPackage ../development/python-modules/python-mpv-jsonipc { };

  python-multipart = callPackage ../development/python-modules/python-multipart { };

  python-musicpd = callPackage ../development/python-modules/python-musicpd { };

  python-mystrom = callPackage ../development/python-modules/python-mystrom { };

  python-ndn = callPackage ../development/python-modules/python-ndn { };

  python-nest = callPackage ../development/python-modules/python-nest { };

  python-neutronclient = callPackage ../development/python-modules/python-neutronclient { };

  python-nmap = callPackage ../development/python-modules/python-nmap { };

  python-nomad = callPackage ../development/python-modules/python-nomad { };

  python-novaclient = callPackage ../development/python-modules/python-novaclient { };

  python-nvd3 = callPackage ../development/python-modules/python-nvd3 { };

  python-oauth2 = callPackage ../development/python-modules/python-oauth2 { };

  python-obfuscator = callPackage ../development/python-modules/python-obfuscator { };

  python-octaviaclient = callPackage ../development/python-modules/python-octaviaclient { };

  python-olm = callPackage ../development/python-modules/python-olm { };

  python-on-whales = callPackage ../development/python-modules/python-on-whales { };

  python-open-router = callPackage ../development/python-modules/python-open-router { };

  python-opendata-transport = callPackage ../development/python-modules/python-opendata-transport { };

  python-openems = callPackage ../development/python-modules/python-openems { };

  python-opensky = callPackage ../development/python-modules/python-opensky { };

  python-openstackclient = callPackage ../development/python-modules/python-openstackclient { };

  python-openzwave = callPackage ../development/python-modules/python-openzwave { };

  python-osc = callPackage ../development/python-modules/python-osc { };

  python-otbr-api = callPackage ../development/python-modules/python-otbr-api { };

  python-overseerr = callPackage ../development/python-modules/python-overseerr { };

  python-owasp-zap-v2-4 = callPackage ../development/python-modules/python-owasp-zap-v2-4 { };

  python-oxmsg = callPackage ../development/python-modules/python-oxmsg { };

  python-packer = callPackage ../development/python-modules/python-packer { };

  python-pae = callPackage ../development/python-modules/python-pae { };

  python-pam = callPackage ../development/python-modules/python-pam { inherit (pkgs) pam; };

  python-path = callPackage ../development/python-modules/python-path { };

  python-pcapng = callPackage ../development/python-modules/python-pcapng { };

  python-periphery = callPackage ../development/python-modules/python-periphery { };

  python-picnic-api2 = callPackage ../development/python-modules/python-picnic-api2 { };

  python-pidfile = callPackage ../development/python-modules/python-pidfile { };

  python-pipedrive = callPackage ../development/python-modules/python-pipedrive { };

  python-pkcs11 = callPackage ../development/python-modules/python-pkcs11 { };

  python-pooldose = callPackage ../development/python-modules/python-pooldose { };

  python-poppler = callPackage ../development/python-modules/python-poppler { };

  python-pptx = callPackage ../development/python-modules/python-pptx { };

  python-prctl = callPackage ../development/python-modules/python-prctl { };

  python-ptrace = callPackage ../development/python-modules/python-ptrace { };

  python-qt = toPythonModule (pkgs.python-qt.override { python3 = self.python; });

  python-rabbitair = callPackage ../development/python-modules/python-rabbitair { };

  python-rapidjson = callPackage ../development/python-modules/python-rapidjson { };

  python-redis-lock = callPackage ../development/python-modules/python-redis-lock { };

  python-registry = callPackage ../development/python-modules/python-registry { };

  python-ripple-api = callPackage ../development/python-modules/python-ripple-api { };

  python-roborock = callPackage ../development/python-modules/python-roborock { };

  python-rtmidi = callPackage ../development/python-modules/python-rtmidi { };

  python-sat = callPackage ../development/python-modules/python-sat { };

  python-secp256k1-cardano = callPackage ../development/python-modules/python-secp256k1-cardano { };

  python-slugify = callPackage ../development/python-modules/python-slugify { };

  python-smarttub = callPackage ../development/python-modules/python-smarttub { };

  python-snap7 = callPackage ../development/python-modules/python-snap7 { inherit (pkgs) snap7; };

  python-snappy = callPackage ../development/python-modules/python-snappy {
    snappy-cpp = pkgs.snappy;
  };

  python-snoo = callPackage ../development/python-modules/python-snoo { };

  python-socketio = callPackage ../development/python-modules/python-socketio { };

  python-socketio-v4 = callPackage ../development/python-modules/python-socketio-v4 { };

  python-socks = callPackage ../development/python-modules/python-socks { };

  python-songpal = callPackage ../development/python-modules/python-songpal { };

  python-speech-features = callPackage ../development/python-modules/python-speech-features { };

  python-sql = callPackage ../development/python-modules/python-sql { };

  python-status = callPackage ../development/python-modules/python-status { };

  python-stdnum = callPackage ../development/python-modules/python-stdnum { };

  python-string-utils = callPackage ../development/python-modules/python-string-utils { };

  python-swiftclient = callPackage ../development/python-modules/python-swiftclient { };

  python-tado = callPackage ../development/python-modules/python-tado { };

  python-tds = callPackage ../development/python-modules/python-tds { };

  python-technove = callPackage ../development/python-modules/python-technove { };

  python-telegram = callPackage ../development/python-modules/python-telegram { };

  python-telegram-bot = callPackage ../development/python-modules/python-telegram-bot { };

  python-toolbox = callPackage ../development/python-modules/python-toolbox { };

  python-transip = callPackage ../development/python-modules/python-transip { };

  python-troveclient = callPackage ../development/python-modules/python-troveclient { };

  python-trovo = callPackage ../development/python-modules/python-trovo { };

  python-tsp = callPackage ../development/python-modules/python-tsp { };

  python-twitch-client = callPackage ../development/python-modules/python-twitch-client { };

  python-twitter = callPackage ../development/python-modules/python-twitter { };

  python-u2flib-host = callPackage ../development/python-modules/python-u2flib-host { };

  python-uinput = callPackage ../development/python-modules/python-uinput { };

  python-ulid = callPackage ../development/python-modules/python-ulid { };

  python-unrar = callPackage ../development/python-modules/python-unrar { inherit (pkgs) unrar; };

  python-utils = callPackage ../development/python-modules/python-utils { };

  python-vagrant = callPackage ../development/python-modules/python-vagrant { };

  python-velbus = callPackage ../development/python-modules/python-velbus { };

  python-vipaccess = callPackage ../development/python-modules/python-vipaccess { };

  python-vlc = callPackage ../development/python-modules/python-vlc { };

  python-watcherclient = callPackage ../development/python-modules/python-watcherclient { };

  python-whois = callPackage ../development/python-modules/python-whois { };

  python-wink = callPackage ../development/python-modules/python-wink { };

  python-xapp = callPackage ../development/python-modules/python-xapp {
    inherit (pkgs.buildPackages) meson;
    inherit (pkgs)
      gtk3
      gobject-introspection
      polkit
      xapp
      ;
  };

  python-xmp-toolkit = callPackage ../development/python-modules/python-xmp-toolkit { };

  python-xz = callPackage ../development/python-modules/python-xz { };

  python-yakh = callPackage ../development/python-modules/python-yakh { };

  python-yate = callPackage ../development/python-modules/python-yate { };

  python-youtube = callPackage ../development/python-modules/python-youtube { };

  python-zaqarclient = callPackage ../development/python-modules/python-zaqarclient { };

  python-zbar = callPackage ../development/python-modules/python-zbar { };

  python-zunclient = callPackage ../development/python-modules/python-zunclient { };

  python3-application = callPackage ../development/python-modules/python3-application { };

  python3-eventlib = callPackage ../development/python-modules/python3-eventlib { };

  python3-gnutls = callPackage ../development/python-modules/python3-gnutls { };

  python3-openid = callPackage ../development/python-modules/python3-openid { };

  python3-saml = callPackage ../development/python-modules/python3-saml { };

  pythondialog = callPackage ../development/python-modules/pythondialog { };

  pythonefl = callPackage ../development/python-modules/python-efl { };

  pythonegardia = callPackage ../development/python-modules/pythonegardia { };

  pythonfinder = callPackage ../development/python-modules/pythonfinder { };

  pythonkuma = callPackage ../development/python-modules/pythonkuma { };

  pythonnet = callPackage ../development/python-modules/pythonnet { };

  pythonocc-core = toPythonModule (
    callPackage ../development/python-modules/pythonocc-core {
      inherit (pkgs) fontconfig rapidjson;
      inherit (pkgs.xorg)
        libX11
        libXi
        libXmu
        libXext
        ;
    }
  );

  pythonqwt = callPackage ../development/python-modules/pythonqwt { };

  pythran = callPackage ../development/python-modules/pythran { inherit (pkgs.llvmPackages) openmp; };

  pythreejs = callPackage ../development/python-modules/pythreejs { };

  pytibber = callPackage ../development/python-modules/pytibber { };

  pytikz-allefeld = callPackage ../development/python-modules/pytikz-allefeld { };

  pytile = callPackage ../development/python-modules/pytile { };

  pytimeparse = callPackage ../development/python-modules/pytimeparse { };

  pytimeparse2 = callPackage ../development/python-modules/pytimeparse2 { };

  pytinyrenderer = callPackage ../development/python-modules/pytinyrenderer { };

  pytlv = callPackage ../development/python-modules/pytlv { };

  pytm = callPackage ../development/python-modules/pytm { };

  pytmx = callPackage ../development/python-modules/pytmx { };

  pytomlpp = callPackage ../development/python-modules/pytomlpp { };

  pytomorrowio = callPackage ../development/python-modules/pytomorrowio { };

  pytoolconfig = callPackage ../development/python-modules/pytoolconfig { };

  pytools = callPackage ../development/python-modules/pytools { };

  pytorch-bench = callPackage ../development/python-modules/pytorch-bench { };

  pytorch-lightning = callPackage ../development/python-modules/pytorch-lightning { };

  pytorch-memlab = callPackage ../development/python-modules/pytorch-memlab { };

  pytorch-metric-learning = callPackage ../development/python-modules/pytorch-metric-learning { };

  pytorch-msssim = callPackage ../development/python-modules/pytorch-msssim { };

  pytorch-pfn-extras = callPackage ../development/python-modules/pytorch-pfn-extras { };

  pytorch-tabnet = callPackage ../development/python-modules/pytorch-tabnet { };

  pytorch-tokenizers = callPackage ../development/python-modules/pytorch-tokenizers { };

  pytorch3d = callPackage ../development/python-modules/pytorch3d { };

  pytorchviz = callPackage ../development/python-modules/pytorchviz { };

  pytouchline-extended = callPackage ../development/python-modules/pytouchline-extended { };

  pytouchlinesl = callPackage ../development/python-modules/pytouchlinesl { };

  pytraccar = callPackage ../development/python-modules/pytraccar { };

  pytradfri = callPackage ../development/python-modules/pytradfri { };

  pytrafikverket = callPackage ../development/python-modules/pytrafikverket { };

  pytransportnsw = callPackage ../development/python-modules/pytransportnsw { };

  pytransportnswv2 = callPackage ../development/python-modules/pytransportnswv2 { };

  pytricia = callPackage ../development/python-modules/pytricia { };

  pytrydan = callPackage ../development/python-modules/pytrydan { };

  pyttsx3 = callPackage ../development/python-modules/pyttsx3 { };

  pytube = callPackage ../development/python-modules/pytube { };

  pytubefix = callPackage ../development/python-modules/pytubefix { };

  pytun = callPackage ../development/python-modules/pytun { };

  pytun-pmd3 = callPackage ../development/python-modules/pytun-pmd3 { };

  pyturbojpeg = callPackage ../development/python-modules/pyturbojpeg { };

  pytweening = callPackage ../development/python-modules/pytweening { };

  pytz = callPackage ../development/python-modules/pytz {
    inherit (pkgs) tzdata;
  };

  pytz-deprecation-shim = callPackage ../development/python-modules/pytz-deprecation-shim { };

  pyu2f = callPackage ../development/python-modules/pyu2f { };

  pyuca = callPackage ../development/python-modules/pyuca { };

  pyudev = callPackage ../development/python-modules/pyudev { inherit (pkgs) udev; };

  pyunbound = callPackage ../development/python-modules/pyunbound { };

  pyunifi = callPackage ../development/python-modules/pyunifi { };

  pyunormalize = callPackage ../development/python-modules/pyunormalize { };

  pyunpack = callPackage ../development/python-modules/pyunpack { };

  pyupdate = callPackage ../development/python-modules/pyupdate { };

  pyupgrade = callPackage ../development/python-modules/pyupgrade { };

  pyuptimerobot = callPackage ../development/python-modules/pyuptimerobot { };

  pyusb = callPackage ../development/python-modules/pyusb { inherit (pkgs) libusb1; };

  pyuseragents = callPackage ../development/python-modules/pyuseragents { };

  pyutil = callPackage ../development/python-modules/pyutil { };

  pyuv = callPackage ../development/python-modules/pyuv { };

  pyvcd = callPackage ../development/python-modules/pyvcd { };

  pyvera = callPackage ../development/python-modules/pyvera { };

  pyverilog = callPackage ../development/python-modules/pyverilog { };

  pyvers = callPackage ../development/python-modules/pyvers { };

  pyversasense = callPackage ../development/python-modules/pyversasense { };

  pyvesync = callPackage ../development/python-modules/pyvesync { };

  pyvex = callPackage ../development/python-modules/pyvex { };

  pyvicare = callPackage ../development/python-modules/pyvicare { };

  pyvips = callPackage ../development/python-modules/pyvips { inherit (pkgs) vips glib; };

  pyvirtualdisplay = callPackage ../development/python-modules/pyvirtualdisplay { };

  pyvis = callPackage ../development/python-modules/pyvis { };

  pyvisa = callPackage ../development/python-modules/pyvisa { };

  pyvisa-py = callPackage ../development/python-modules/pyvisa-py { };

  pyvisa-sim = callPackage ../development/python-modules/pyvisa-sim { };

  pyvista = callPackage ../development/python-modules/pyvista { };

  pyviz-comms = callPackage ../development/python-modules/pyviz-comms { };

  pyvizio = callPackage ../development/python-modules/pyvizio { };

  pyvlx = callPackage ../development/python-modules/pyvlx { };

  pyvmomi = callPackage ../development/python-modules/pyvmomi { };

  pyvo = callPackage ../development/python-modules/pyvo { };

  pyvolumio = callPackage ../development/python-modules/pyvolumio { };

  pyvows = callPackage ../development/python-modules/pyvows { };

  pyw215 = callPackage ../development/python-modules/pyw215 { };

  pyw800rf32 = callPackage ../development/python-modules/pyw800rf32 { };

  pywal = callPackage ../development/python-modules/pywal { };

  pywatchman = callPackage ../development/python-modules/pywatchman { };

  pywaterkotte = callPackage ../development/python-modules/pywaterkotte { };

  pywavefront = callPackage ../development/python-modules/pywavefront { };

  pywavelets = callPackage ../development/python-modules/pywavelets { };

  pywayland = callPackage ../development/python-modules/pywayland { };

  pywaze = callPackage ../development/python-modules/pywaze { };

  pywbem = callPackage ../development/python-modules/pywbem { inherit (pkgs) libxml2; };

  pyweatherflowrest = callPackage ../development/python-modules/pyweatherflowrest { };

  pyweatherflowudp = callPackage ../development/python-modules/pyweatherflowudp { };

  pywebcopy = callPackage ../development/python-modules/pywebcopy { };

  pywebpush = callPackage ../development/python-modules/pywebpush { };

  pywebview = callPackage ../development/python-modules/pywebview { };

  pywemo = callPackage ../development/python-modules/pywemo { };

  pywerview = callPackage ../development/python-modules/pywerview { };

  pywfa = callPackage ../development/python-modules/pywfa { };

  pywikibot = callPackage ../development/python-modules/pywikibot { };

  pywilight = callPackage ../development/python-modules/pywilight { };

  pywinbox = callPackage ../development/python-modules/pywinbox { };

  pywinctl = callPackage ../development/python-modules/pywinctl { };

  pywinrm = callPackage ../development/python-modules/pywinrm { };

  pywizlight = callPackage ../development/python-modules/pywizlight { };

  pywlroots = callPackage ../development/python-modules/pywlroots { wlroots = pkgs.wlroots_0_17; };

  pywmspro = callPackage ../development/python-modules/pywmspro { };

  pyworld = callPackage ../development/python-modules/pyworld { };

  pyworxcloud = callPackage ../development/python-modules/pyworxcloud { };

  pyws66i = callPackage ../development/python-modules/pyws66i { };

  pyx = callPackage ../development/python-modules/pyx { };

  pyxattr = callPackage ../development/python-modules/pyxattr { };

  pyxbe = callPackage ../development/python-modules/pyxbe { };

  pyxdg = callPackage ../development/python-modules/pyxdg { };

  pyxeoma = callPackage ../development/python-modules/pyxeoma { };

  pyxiaomigateway = callPackage ../development/python-modules/pyxiaomigateway { };

  pyxl3 = callPackage ../development/python-modules/pyxl3 { };

  pyxlsb = callPackage ../development/python-modules/pyxlsb { };

  pyxnat = callPackage ../development/python-modules/pyxnat { };

  pyyaml = callPackage ../development/python-modules/pyyaml { };

  pyyaml-env-tag = callPackage ../development/python-modules/pyyaml-env-tag { };

  pyyaml-ft = callPackage ../development/python-modules/pyyaml-ft { };

  pyyaml-include = callPackage ../development/python-modules/pyyaml-include { };

  pyyardian = callPackage ../development/python-modules/pyyardian { };

  pyytlounge = callPackage ../development/python-modules/pyytlounge { };

  pyzabbix = callPackage ../development/python-modules/pyzabbix { };

  pyzbar = callPackage ../development/python-modules/pyzbar { };

  pyzerproc = callPackage ../development/python-modules/pyzerproc { };

  pyzipper = callPackage ../development/python-modules/pyzipper { };

  pyzmq = callPackage ../development/python-modules/pyzmq { };

  pyzstd = callPackage ../development/python-modules/pyzstd { zstd-c = pkgs.zstd; };

  pyzx = callPackage ../development/python-modules/pyzx { };

  qasync = callPackage ../development/python-modules/qasync { };

  qbittorrent-api = callPackage ../development/python-modules/qbittorrent-api { };

  qbusmqttapi = callPackage ../development/python-modules/qbusmqttapi { };

  qcelemental = callPackage ../development/python-modules/qcelemental { };

  qcengine = callPackage ../development/python-modules/qcengine { };

  qcodes = callPackage ../development/python-modules/qcodes { };

  qcodes-contrib-drivers = callPackage ../development/python-modules/qcodes-contrib-drivers { };

  qcs-api-client = callPackage ../development/python-modules/qcs-api-client { };

  qcs-api-client-common = callPackage ../development/python-modules/qcs-api-client-common { };

  qcs-sdk-python = callPackage ../development/python-modules/qcs-sdk-python { };

  qdarkstyle = callPackage ../development/python-modules/qdarkstyle { };

  qdldl = callPackage ../development/python-modules/qdldl { inherit (pkgs) qdldl; };

  qdrant-client = callPackage ../development/python-modules/qdrant-client { };

  qemu = callPackage ../development/python-modules/qemu { qemu = pkgs.qemu; };

  qemu-qmp = callPackage ../development/python-modules/qemu-qmp { };

  qgrid = callPackage ../development/python-modules/qgrid { };

  qh3 = callPackage ../development/python-modules/qh3 {
    inherit (pkgs) cmake;
  };

  qiling = callPackage ../development/python-modules/qiling { };

  qimage2ndarray = callPackage ../development/python-modules/qimage2ndarray { };

  qingping-ble = callPackage ../development/python-modules/qingping-ble { };

  qiskit = callPackage ../development/python-modules/qiskit { };

  qiskit-aer = callPackage ../development/python-modules/qiskit-aer { };

  qiskit-finance = callPackage ../development/python-modules/qiskit-finance { };

  qiskit-ibmq-provider = callPackage ../development/python-modules/qiskit-ibmq-provider { };

  qiskit-ignis = callPackage ../development/python-modules/qiskit-ignis { };

  qiskit-machine-learning = callPackage ../development/python-modules/qiskit-machine-learning { };

  qiskit-nature = callPackage ../development/python-modules/qiskit-nature { };

  qiskit-optimization = callPackage ../development/python-modules/qiskit-optimization { };

  qiskit-terra = callPackage ../development/python-modules/qiskit-terra { };

  qnap-qsw = callPackage ../development/python-modules/qnap-qsw { };

  qnapstats = callPackage ../development/python-modules/qnapstats { };

  qpageview = callPackage ../development/python-modules/qpageview { };

  qpsolvers = callPackage ../development/python-modules/qpsolvers { };

  qrcode = callPackage ../development/python-modules/qrcode { };

  qrcode-terminal = callPackage ../development/python-modules/qrcode-terminal { };

  qrcodegen = callPackage ../development/python-modules/qrcodegen { qrcodegen = pkgs.qrcodegen; };

  qreactor = callPackage ../development/python-modules/qreactor { };

  qscintilla = self.qscintilla-qt5;

  qscintilla-qt5 = pkgs.libsForQt5.callPackage ../development/python-modules/qscintilla {
    pythonPackages = self;
  };

  qscintilla-qt6 = pkgs.qt6Packages.callPackage ../development/python-modules/qscintilla {
    pythonPackages = self;
  };

  qstylizer = callPackage ../development/python-modules/qstylizer { };

  qt-material = callPackage ../development/python-modules/qt-material { };

  qt5reactor = callPackage ../development/python-modules/qt5reactor { };

  qt6 = pkgs.qt6.override { python3 = self.python; };

  qtawesome = callPackage ../development/python-modules/qtawesome { };

  qtconsole = callPackage ../development/python-modules/qtconsole { };

  qtile = callPackage ../development/python-modules/qtile { wlroots = pkgs.wlroots_0_17; };

  qtile-bonsai = callPackage ../development/python-modules/qtile-bonsai { };

  qtile-extras = callPackage ../development/python-modules/qtile-extras { };

  qtpy = callPackage ../development/python-modules/qtpy { };

  quadprog = callPackage ../development/python-modules/quadprog { };

  qualysclient = callPackage ../development/python-modules/qualysclient { };

  quandl = callPackage ../development/python-modules/quandl { };

  quantile-forest = callPackage ../development/python-modules/quantile-forest { };

  quantile-python = callPackage ../development/python-modules/quantile-python { };

  quantiphy = callPackage ../development/python-modules/quantiphy { };

  quantiphy-eval = callPackage ../development/python-modules/quantiphy-eval { };

  quantities = callPackage ../development/python-modules/quantities { };

  quantulum3 = callPackage ../development/python-modules/quantulum3 { };

  quantum-gateway = callPackage ../development/python-modules/quantum-gateway { };

  quart = callPackage ../development/python-modules/quart { };

  quart-cors = callPackage ../development/python-modules/quart-cors { };

  quart-schema = callPackage ../development/python-modules/quart-schema { };

  quaternion = callPackage ../development/python-modules/quaternion { };

  qudida = callPackage ../development/python-modules/qudida { };

  querystring-parser = callPackage ../development/python-modules/querystring-parser { };

  questionary = callPackage ../development/python-modules/questionary { };

  questo = callPackage ../development/python-modules/questo { };

  queuelib = callPackage ../development/python-modules/queuelib { };

  quickjs = callPackage ../development/python-modules/quickjs { };

  quil = callPackage ../development/python-modules/quil { };

  quixote = callPackage ../development/python-modules/quixote { };

  qutip = callPackage ../development/python-modules/qutip { };

  r2pipe = callPackage ../development/python-modules/r2pipe { };

  rachiopy = callPackage ../development/python-modules/rachiopy { };

  radicale-infcloud = callPackage ../development/python-modules/radicale-infcloud {
    radicale = pkgs.radicale.override { python3 = python; };
  };

  radio-beam = callPackage ../development/python-modules/radio-beam { };

  radios = callPackage ../development/python-modules/radios { };

  radiotherm = callPackage ../development/python-modules/radiotherm { };

  radish-bdd = callPackage ../development/python-modules/radish-bdd { };

  radixtarget = callPackage ../development/python-modules/radixtarget { };

  radon = callPackage ../development/python-modules/radon { };

  railroad-diagrams = callPackage ../development/python-modules/railroad-diagrams { };

  rainbowstream = callPackage ../development/python-modules/rainbowstream { };

  raincloudy = callPackage ../development/python-modules/raincloudy { };

  ramlfications = callPackage ../development/python-modules/ramlfications { };

  random2 = callPackage ../development/python-modules/random2 { };

  randomfiletree = callPackage ../development/python-modules/randomfiletree { };

  range-typed-integers = callPackage ../development/python-modules/range-typed-integers { };

  rangehttpserver = callPackage ../development/python-modules/rangehttpserver { };

  rangeparser = callPackage ../development/python-modules/rangeparser { };

  rank-bm25 = callPackage ../development/python-modules/rank-bm25 { };

  rapidfuzz = callPackage ../development/python-modules/rapidfuzz { };

  rapidfuzz-capi = callPackage ../development/python-modules/rapidfuzz-capi { };

  rapidgzip = callPackage ../development/python-modules/rapidgzip { inherit (pkgs) nasm; };

  rapidocr = callPackage ../development/python-modules/rapidocr { };

  rapidocr-onnxruntime = callPackage ../development/python-modules/rapidocr-onnxruntime { };

  rapt-ble = callPackage ../development/python-modules/rapt-ble { };

  rarfile = callPackage ../development/python-modules/rarfile { inherit (pkgs) libarchive; };

  raspyrfm-client = callPackage ../development/python-modules/raspyrfm-client { };

  rasterio = callPackage ../development/python-modules/rasterio { };

  ratarmount = callPackage ../development/python-modules/ratarmount { };

  ratarmountcore = callPackage ../development/python-modules/ratarmountcore { inherit (pkgs) zstd; };

  ratelim = callPackage ../development/python-modules/ratelim { };

  ratelimit = callPackage ../development/python-modules/ratelimit { };

  raven = callPackage ../development/python-modules/raven { };

  rawkit = callPackage ../development/python-modules/rawkit { };

  rawpy = callPackage ../development/python-modules/rawpy { };

  ray = callPackage ../development/python-modules/ray { };

  raylib-python-cffi = callPackage ../development/python-modules/raylib-python-cffi { };

  razdel = callPackage ../development/python-modules/razdel { };

  rbtools = callPackage ../development/python-modules/rbtools { };

  rchitect = callPackage ../development/python-modules/rchitect { };

  rclone-python = callPackage ../development/python-modules/rclone-python { };

  rcssmin = callPackage ../development/python-modules/rcssmin { };

  rctclient = callPackage ../development/python-modules/rctclient { };

  rdbtools = callPackage ../development/python-modules/rdbtools { };

  rdflib = callPackage ../development/python-modules/rdflib { };

  rdkit = callPackage ../development/python-modules/rdkit {
    boost = pkgs.boost.override {
      enablePython = true;
      inherit python;
    };
  };

  rds2py = callPackage ../development/python-modules/rds2py { };

  re-assert = callPackage ../development/python-modules/re-assert { };

  reactionmenu = callPackage ../development/python-modules/reactionmenu { };

  reactivex = callPackage ../development/python-modules/reactivex { };

  readabilipy = callPackage ../development/python-modules/readabilipy { };

  readability-lxml = callPackage ../development/python-modules/readability-lxml { };

  readchar = callPackage ../development/python-modules/readchar { };

  readlike = callPackage ../development/python-modules/readlike { };

  readmdict = callPackage ../development/python-modules/readmdict { };

  readme = callPackage ../development/python-modules/readme { };

  readme-renderer = callPackage ../development/python-modules/readme-renderer { };

  readthedocs-sphinx-ext = callPackage ../development/python-modules/readthedocs-sphinx-ext { };

  realtime = callPackage ../development/python-modules/realtime { };

  rebulk = callPackage ../development/python-modules/rebulk { };

  recipe-scrapers = callPackage ../development/python-modules/recipe-scrapers { };

  recline = callPackage ../development/python-modules/recline { };

  recoll = toPythonModule (pkgs.recoll.override { python3Packages = self; });

  recommonmark = callPackage ../development/python-modules/recommonmark { };

  reconplogger = callPackage ../development/python-modules/reconplogger { };

  recordlinkage = callPackage ../development/python-modules/recordlinkage { };

  rectangle-packer = callPackage ../development/python-modules/rectangle-packer { };

  rectpack = callPackage ../development/python-modules/rectpack { };

  recurring-ical-events = callPackage ../development/python-modules/recurring-ical-events { };

  recursive-pth-loader = toPythonModule (
    callPackage ../development/python-modules/recursive-pth-loader { }
  );

  recursivenodes = callPackage ../development/python-modules/recursivenodes { };

  red-black-tree-mod = callPackage ../development/python-modules/red-black-tree-mod { };

  redbaron = callPackage ../development/python-modules/redbaron { };

  redis = callPackage ../development/python-modules/redis { };

  redis-om = callPackage ../development/python-modules/redis-om { };

  redshift-connector = callPackage ../development/python-modules/redshift-connector { };

  reedsolo = callPackage ../development/python-modules/reedsolo { };

  referencing = callPackage ../development/python-modules/referencing { };

  refery = callPackage ../development/python-modules/refery { };

  reflex = callPackage ../development/python-modules/reflex { };

  reflex-chakra = callPackage ../development/python-modules/reflex-chakra { };

  reflex-hosting-cli = callPackage ../development/python-modules/reflex-hosting-cli { };

  reflink = callPackage ../development/python-modules/reflink { };

  reflink-copy = callPackage ../development/python-modules/reflink-copy { };

  refoss-ha = callPackage ../development/python-modules/refoss-ha { };

  regenmaschine = callPackage ../development/python-modules/regenmaschine { };

  regex = callPackage ../development/python-modules/regex { };

  regional = callPackage ../development/python-modules/regional { };

  regress = callPackage ../development/python-modules/regress { };

  reikna = callPackage ../development/python-modules/reikna { };

  related = callPackage ../development/python-modules/related { };

  relatorio = callPackage ../development/python-modules/relatorio { };

  releases = callPackage ../development/python-modules/releases { };

  remarshal = callPackage ../development/python-modules/remarshal { };

  rembg = callPackage ../development/python-modules/rembg { };

  remctl = callPackage ../development/python-modules/remctl { remctl-c = pkgs.remctl; };

  remi = callPackage ../development/python-modules/remi { };

  remote-pdb = callPackage ../development/python-modules/remote-pdb { };

  remotezip = callPackage ../development/python-modules/remotezip { };

  remotezip2 = callPackage ../development/python-modules/remotezip2 { };

  renault-api = callPackage ../development/python-modules/renault-api { };

  rencode = callPackage ../development/python-modules/rencode { };

  rendercanvas = callPackage ../development/python-modules/rendercanvas { };

  rendercv-fonts = callPackage ../development/python-modules/rendercv-fonts { };

  reno = callPackage ../development/python-modules/reno { };

  renson-endura-delta = callPackage ../development/python-modules/renson-endura-delta { };

  reolink = callPackage ../development/python-modules/reolink { };

  reolink-aio = callPackage ../development/python-modules/reolink-aio { };

  reorder-python-imports = callPackage ../development/python-modules/reorder-python-imports { };

  reparser = callPackage ../development/python-modules/reparser { };

  repath = callPackage ../development/python-modules/repath { };

  repeated-test = callPackage ../development/python-modules/repeated-test { };

  repl-python-wakatime = callPackage ../development/python-modules/repl-python-wakatime { };

  replicate = callPackage ../development/python-modules/replicate { };

  reportlab = callPackage ../development/python-modules/reportlab { };

  reportlab-qrcode = callPackage ../development/python-modules/reportlab-qrcode { };

  repoze-lru = callPackage ../development/python-modules/repoze-lru { };

  repoze-sphinx-autointerface =
    callPackage ../development/python-modules/repoze-sphinx-autointerface
      { };

  repoze-who = callPackage ../development/python-modules/repoze-who { };

  reprint = callPackage ../development/python-modules/reprint { };

  reproject = callPackage ../development/python-modules/reproject { };

  reprshed = callPackage ../development/python-modules/reprshed { };

  reptor = callPackage ../development/python-modules/reptor { };

  reqif = callPackage ../development/python-modules/reqif { };

  requests = callPackage ../development/python-modules/requests { };

  requests-aws4auth = callPackage ../development/python-modules/requests-aws4auth { };

  requests-cache = callPackage ../development/python-modules/requests-cache { };

  requests-credssp = callPackage ../development/python-modules/requests-credssp { };

  requests-download = callPackage ../development/python-modules/requests-download { };

  requests-file = callPackage ../development/python-modules/requests-file { };

  requests-futures = callPackage ../development/python-modules/requests-futures { };

  requests-gssapi = callPackage ../development/python-modules/requests-gssapi { };

  requests-hawk = callPackage ../development/python-modules/requests-hawk { };

  requests-http-message-signatures =
    callPackage ../development/python-modules/requests-http-message-signatures
      { };

  requests-http-signature = callPackage ../development/python-modules/requests-http-signature { };

  requests-kerberos = callPackage ../development/python-modules/requests-kerberos { };

  requests-mock = callPackage ../development/python-modules/requests-mock { };

  requests-ntlm = callPackage ../development/python-modules/requests-ntlm { };

  requests-oauthlib = callPackage ../development/python-modules/requests-oauthlib { };

  requests-pkcs12 = callPackage ../development/python-modules/requests-pkcs12 { };

  requests-ratelimiter = callPackage ../development/python-modules/requests-ratelimiter { };

  requests-toolbelt = callPackage ../development/python-modules/requests-toolbelt { };

  requests-unixsocket = callPackage ../development/python-modules/requests-unixsocket { };

  requests-unixsocket2 = callPackage ../development/python-modules/requests-unixsocket2 { };

  requests-wsgi-adapter = callPackage ../development/python-modules/requests-wsgi-adapter { };

  requestsexceptions = callPackage ../development/python-modules/requestsexceptions { };

  requirements-detector = callPackage ../development/python-modules/requirements-detector { };

  requirements-parser = callPackage ../development/python-modules/requirements-parser { };

  reretry = callPackage ../development/python-modules/reretry { };

  rerun-sdk = callPackage ../development/python-modules/rerun-sdk { };

  resampy = callPackage ../development/python-modules/resampy { };

  resend = callPackage ../development/python-modules/resend { };

  resize-right = callPackage ../development/python-modules/resize-right { };

  resolvelib = callPackage ../development/python-modules/resolvelib { };

  responses = callPackage ../development/python-modules/responses { };

  respx = callPackage ../development/python-modules/respx { };

  restfly = callPackage ../development/python-modules/restfly { };

  restrictedpython = callPackage ../development/python-modules/restrictedpython { };

  restructuredtext-lint = callPackage ../development/python-modules/restructuredtext-lint { };

  restview = callPackage ../development/python-modules/restview { };

  result = callPackage ../development/python-modules/result { };

  rethinkdb = callPackage ../development/python-modules/rethinkdb { };

  retinaface = callPackage ../development/python-modules/retinaface { };

  retry = callPackage ../development/python-modules/retry { };

  retry-decorator = callPackage ../development/python-modules/retry-decorator { };

  retry2 = callPackage ../development/python-modules/retry2 { };

  retrying = callPackage ../development/python-modules/retrying { };

  returns = callPackage ../development/python-modules/returns { };

  reuse = callPackage ../development/python-modules/reuse { };

  reverse-geocode = callPackage ../development/python-modules/reverse-geocode { };

  rfc3161-client = callPackage ../development/python-modules/rfc3161-client { };

  rfc3339 = callPackage ../development/python-modules/rfc3339 { };

  rfc3339-validator = callPackage ../development/python-modules/rfc3339-validator { };

  rfc3986 = callPackage ../development/python-modules/rfc3986 { };

  rfc3986-validator = callPackage ../development/python-modules/rfc3986-validator { };

  rfc3987 = callPackage ../development/python-modules/rfc3987 { };

  rfc3987-syntax = callPackage ../development/python-modules/rfc3987-syntax { };

  rfc6555 = callPackage ../development/python-modules/rfc6555 { };

  rfc7464 = callPackage ../development/python-modules/rfc7464 { };

  rfc8785 = callPackage ../development/python-modules/rfc8785 { };

  rfcat = callPackage ../development/python-modules/rfcat { };

  rfk101py = callPackage ../development/python-modules/rfk101py { };

  rflink = callPackage ../development/python-modules/rflink { };

  rgpio = toPythonModule (
    pkgs.lgpio.override {
      inherit buildPythonPackage;
      pyProject = "PY_RGPIO";
    }
  );

  rich = callPackage ../development/python-modules/rich { };

  rich-argparse = callPackage ../development/python-modules/rich-argparse { };

  rich-argparse-plus = callPackage ../development/python-modules/rich-argparse-plus { };

  rich-click = callPackage ../development/python-modules/rich-click { };

  rich-pixels = callPackage ../development/python-modules/rich-pixels { };

  rich-rst = callPackage ../development/python-modules/rich-rst { };

  rich-tables = callPackage ../development/python-modules/rich-tables { };

  rich-theme-manager = callPackage ../development/python-modules/rich-theme-manager { };

  rich-toolkit = callPackage ../development/python-modules/rich-toolkit { };

  riden = callPackage ../development/python-modules/riden { };

  rigour = callPackage ../development/python-modules/rigour { };

  ring-doorbell = callPackage ../development/python-modules/ring-doorbell { };

  rio-stac = callPackage ../development/python-modules/rio-stac { };

  rio-tiler = callPackage ../development/python-modules/rio-tiler { };

  rioxarray = callPackage ../development/python-modules/rioxarray { };

  ripe-atlas-cousteau = callPackage ../development/python-modules/ripe-atlas-cousteau { };

  ripe-atlas-sagan = callPackage ../development/python-modules/ripe-atlas-sagan { };

  riprova = callPackage ../development/python-modules/riprova { };

  ripser = callPackage ../development/python-modules/ripser { };

  riscof = callPackage ../development/python-modules/riscof { };

  riscv-config = callPackage ../development/python-modules/riscv-config { };

  riscv-isac = callPackage ../development/python-modules/riscv-isac { };

  ritassist = callPackage ../development/python-modules/ritassist { };

  rivet = toPythonModule (pkgs.rivet.override { python3 = python; });

  rjpl = callPackage ../development/python-modules/rjpl { };

  rjsmin = callPackage ../development/python-modules/rjsmin { };

  rkm-codes = callPackage ../development/python-modules/rkm-codes { };

  rlax = callPackage ../development/python-modules/rlax { };

  rlcard = callPackage ../development/python-modules/rlcard { };

  rlp = callPackage ../development/python-modules/rlp { };

  rmcl = callPackage ../development/python-modules/rmcl { };

  rmrl = callPackage ../development/python-modules/rmrl { };

  rmscene = callPackage ../development/python-modules/rmscene { };

  rmsd = callPackage ../development/python-modules/rmsd { };

  rnc2rng = callPackage ../development/python-modules/rnc2rng { };

  rnginline = callPackage ../development/python-modules/rnginline { };

  rns = callPackage ../development/python-modules/rns { };

  roadlib = callPackage ../development/python-modules/roadlib { };

  roadrecon = callPackage ../development/python-modules/roadrecon { };

  roadtools = callPackage ../development/python-modules/roadtools { };

  roadtx = callPackage ../development/python-modules/roadtx { };

  robomachine = callPackage ../development/python-modules/robomachine { };

  robot-descriptions = callPackage ../development/python-modules/robot-descriptions { };

  robot-detection = callPackage ../development/python-modules/robot-detection { };

  robotframework = callPackage ../development/python-modules/robotframework { };

  robotframework-assertion-engine =
    callPackage ../development/python-modules/robotframework-assertion-engine
      { };

  robotframework-databaselibrary =
    callPackage ../development/python-modules/robotframework-databaselibrary
      { };

  robotframework-excellib = callPackage ../development/python-modules/robotframework-excellib { };

  robotframework-pythonlibcore =
    callPackage ../development/python-modules/robotframework-pythonlibcore
      { };

  robotframework-requests = callPackage ../development/python-modules/robotframework-requests { };

  robotframework-selenium2library =
    callPackage ../development/python-modules/robotframework-selenium2library
      { };

  robotframework-seleniumlibrary =
    callPackage ../development/python-modules/robotframework-seleniumlibrary
      { };

  robotframework-sshlibrary = callPackage ../development/python-modules/robotframework-sshlibrary { };

  robotframework-tools = callPackage ../development/python-modules/robotframework-tools { };

  robotstatuschecker = callPackage ../development/python-modules/robotstatuschecker { };

  robotsuite = callPackage ../development/python-modules/robotsuite { };

  rocket-errbot = callPackage ../development/python-modules/rocket-errbot { };

  rocketchat-api = callPackage ../development/python-modules/rocketchat-api { };

  roku = callPackage ../development/python-modules/roku { };

  rokuecp = callPackage ../development/python-modules/rokuecp { };

  rollbar = callPackage ../development/python-modules/rollbar { };

  roma = callPackage ../development/python-modules/roma { };

  roman = callPackage ../development/python-modules/roman { };

  roman-numerals-py = callPackage ../development/python-modules/roman-numerals-py { };

  romy = callPackage ../development/python-modules/romy { };

  roombapy = callPackage ../development/python-modules/roombapy { };

  roonapi = callPackage ../development/python-modules/roonapi { };

  root = callPackage ../development/python-modules/root {
    inherit (pkgs) root;
  };

  rope = callPackage ../development/python-modules/rope { };

  ropgadget = callPackage ../development/python-modules/ropgadget { };

  ropper = callPackage ../development/python-modules/ropper { };

  rosbags = callPackage ../development/python-modules/rosbags { };

  rospkg = callPackage ../development/python-modules/rospkg { };

  rotary-embedding-torch = callPackage ../development/python-modules/rotary-embedding-torch { };

  rouge-score = callPackage ../development/python-modules/rouge-score { };

  routeros-api = callPackage ../development/python-modules/routeros-api { };

  routes = callPackage ../development/python-modules/routes { };

  rova = callPackage ../development/python-modules/rova { };

  rowan = callPackage ../development/python-modules/rowan { };

  rpcq = callPackage ../development/python-modules/rpcq { };

  rpdb = callPackage ../development/python-modules/rpdb { };

  rpds-py = callPackage ../development/python-modules/rpds-py { };

  rpi-bad-power = callPackage ../development/python-modules/rpi-bad-power { };

  rpi-gpio = callPackage ../development/python-modules/rpi-gpio { };

  rplcd = callPackage ../development/python-modules/rplcd { };

  rply = callPackage ../development/python-modules/rply { };

  rpm = toPythonModule (pkgs.rpm.override { python3 = self.python; });

  rpmfile = callPackage ../development/python-modules/rpmfile { };

  rpmfluff = callPackage ../development/python-modules/rpmfluff { };

  rpy2 = callPackage ../development/python-modules/rpy2 { };

  rpy2-rinterface = callPackage ../development/python-modules/rpy2-rinterface {
    inherit (pkgs) zstd;
  };

  rpy2-robjects = callPackage ../development/python-modules/rpy2-robjects { };

  rpyc = callPackage ../development/python-modules/rpyc { };

  rq = callPackage ../development/python-modules/rq { };

  rrdtool = callPackage ../development/python-modules/rrdtool { };

  rsa = callPackage ../development/python-modules/rsa { };

  rsskey = callPackage ../development/python-modules/rsskey { };

  rst2ansi = callPackage ../development/python-modules/rst2ansi { };

  rst2pdf = callPackage ../development/python-modules/rst2pdf { };

  rstcheck = callPackage ../development/python-modules/rstcheck { };

  rstcheck-core = callPackage ../development/python-modules/rstcheck-core { };

  rstr = callPackage ../development/python-modules/rstr { };

  rtb-data = callPackage ../development/python-modules/rtb-data { };

  rtfde = callPackage ../development/python-modules/rtfde { };

  rtfunicode = callPackage ../development/python-modules/rtfunicode { };

  rtmapi = callPackage ../development/python-modules/rtmapi { };

  rtmidi-python = callPackage ../development/python-modules/rtmidi-python { };

  rtmixer = callPackage ../development/python-modules/rtmixer { };

  rtoml = callPackage ../development/python-modules/rtoml { };

  rtp = callPackage ../development/python-modules/rtp { };

  rtree = callPackage ../development/python-modules/rtree { inherit (pkgs) libspatialindex; };

  rtslib-fb = callPackage ../development/python-modules/rtslib-fb { };

  ruamel-base = callPackage ../development/python-modules/ruamel-base { };

  ruamel-yaml = callPackage ../development/python-modules/ruamel-yaml { };

  ruamel-yaml-clib = callPackage ../development/python-modules/ruamel-yaml-clib { };

  ruamel-yaml-string = callPackage ../development/python-modules/ruamel-yaml-string { };

  rubicon-objc = callPackage ../development/python-modules/rubicon-objc { };

  rubymarshal = callPackage ../development/python-modules/rubymarshal { };

  rucio = callPackage ../development/python-modules/rucio { };

  ruff = callPackage ../development/python-modules/ruff { inherit (pkgs) ruff; };

  ruff-api = callPackage ../development/python-modules/ruff-api { };

  ruffus = callPackage ../development/python-modules/ruffus { };

  rules = callPackage ../development/python-modules/rules { };

  rumps = callPackage ../development/python-modules/rumps { };

  runs = callPackage ../development/python-modules/runs { };

  runstats = callPackage ../development/python-modules/runstats { };

  russound = callPackage ../development/python-modules/russound { };

  rustworkx = callPackage ../development/python-modules/rustworkx { };

  ruuvitag-ble = callPackage ../development/python-modules/ruuvitag-ble { };

  ruyaml = callPackage ../development/python-modules/ruyaml { };

  rx = callPackage ../development/python-modules/rx { };

  rxv = callPackage ../development/python-modules/rxv { };

  ryd-client = callPackage ../development/python-modules/ryd-client { };

  rzpipe = callPackage ../development/python-modules/rzpipe { };

  s2clientprotocol = callPackage ../development/python-modules/s2clientprotocol { };

  s3-credentials = callPackage ../development/python-modules/s3-credentials { };

  s3fs = callPackage ../development/python-modules/s3fs { };

  s3transfer = callPackage ../development/python-modules/s3transfer { };

  sabctools = callPackage ../development/python-modules/sabctools { };

  sabyenc3 = callPackage ../development/python-modules/sabyenc3 { };

  sacn = callPackage ../development/python-modules/sacn { };

  sacrebleu = callPackage ../development/python-modules/sacrebleu { };

  sacremoses = callPackage ../development/python-modules/sacremoses { };

  safe-pysha3 = callPackage ../development/python-modules/safe-pysha3 { };

  safehttpx = callPackage ../development/python-modules/safehttpx { };

  safeio = callPackage ../development/python-modules/safeio { };

  safetensors = callPackage ../development/python-modules/safetensors { };

  safety = callPackage ../development/python-modules/safety { };

  safety-schemas = callPackage ../development/python-modules/safety-schemas { };

  sagemaker = callPackage ../development/python-modules/sagemaker { };

  sagemaker-core = callPackage ../development/python-modules/sagemaker-core { };

  sagemaker-mlflow = callPackage ../development/python-modules/sagemaker-mlflow { };

  saiph = callPackage ../development/python-modules/saiph { };

  salib = callPackage ../development/python-modules/salib { };

  salmon-mail = callPackage ../development/python-modules/salmon-mail { };

  samarium = callPackage ../development/python-modules/samarium { };

  samplerate = callPackage ../development/python-modules/samplerate { inherit (pkgs) libsamplerate; };

  samsungctl = callPackage ../development/python-modules/samsungctl { };

  samsungtvws = callPackage ../development/python-modules/samsungtvws { };

  sane = callPackage ../development/python-modules/sane { inherit (pkgs) sane-backends; };

  saneyaml = callPackage ../development/python-modules/saneyaml { };

  sanic = callPackage ../development/python-modules/sanic {
    # Don't pass any `sanic` to avoid dependency loops.  `sanic-testing`
    # has special logic to disable tests when this is the case.
    sanic-testing = self.sanic-testing.override { sanic = null; };
  };

  sanic-auth = callPackage ../development/python-modules/sanic-auth { };

  sanic-ext = callPackage ../development/python-modules/sanic-ext { };

  sanic-routing = callPackage ../development/python-modules/sanic-routing { };

  sanic-testing = callPackage ../development/python-modules/sanic-testing { };

  sanix = callPackage ../development/python-modules/sanix { };

  sansio-multipart = callPackage ../development/python-modules/sansio-multipart { };

  sarge = callPackage ../development/python-modules/sarge { };

  sarif-om = callPackage ../development/python-modules/sarif-om { };

  sarif-tools = callPackage ../development/python-modules/sarif-tools { };

  sasmodels = callPackage ../development/python-modules/sasmodels { };

  sat-tmp = callPackage ../development/python-modules/sat-tmp { };

  satel-integra = callPackage ../development/python-modules/satel-integra { };

  sbom2dot = callPackage ../development/python-modules/sbom2dot { };

  sbom4files = callPackage ../development/python-modules/sbom4files { };

  scalar-fastapi = callPackage ../development/python-modules/scalar-fastapi { };

  scalene = callPackage ../development/python-modules/scalene { };

  scales = callPackage ../development/python-modules/scales { };

  scancode-toolkit = callPackage ../development/python-modules/scancode-toolkit { };

  scanpy = callPackage ../development/python-modules/scanpy { };

  scapy = callPackage ../development/python-modules/scapy {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  scenedetect = callPackage ../development/python-modules/scenedetect { };

  schedula = callPackage ../development/python-modules/schedula { };

  schedule = callPackage ../development/python-modules/schedule { };

  scheduler = callPackage ../development/python-modules/scheduler { };

  schema = callPackage ../development/python-modules/schema { };

  schema-salad = callPackage ../development/python-modules/schema-salad { };

  schemdraw = callPackage ../development/python-modules/schemdraw { };

  schiene = callPackage ../development/python-modules/schiene { };

  scholarly = callPackage ../development/python-modules/scholarly { };

  schwifty = callPackage ../development/python-modules/schwifty { };

  scienceplots = callPackage ../development/python-modules/scienceplots { };

  sciform = callPackage ../development/python-modules/sciform { };

  scikit-base = callPackage ../development/python-modules/scikit-base { };

  scikit-bio = callPackage ../development/python-modules/scikit-bio { };

  scikit-build = callPackage ../development/python-modules/scikit-build { };

  scikit-build-core = callPackage ../development/python-modules/scikit-build-core { };

  scikit-fmm = callPackage ../development/python-modules/scikit-fmm { };

  scikit-fuzzy = callPackage ../development/python-modules/scikit-fuzzy { };

  scikit-hep-testdata = callPackage ../development/python-modules/scikit-hep-testdata { };

  scikit-image = callPackage ../development/python-modules/scikit-image { };

  scikit-learn = callPackage ../development/python-modules/scikit-learn { };

  scikit-learn-extra = callPackage ../development/python-modules/scikit-learn-extra { };

  scikit-misc = callPackage ../development/python-modules/scikit-misc { };

  scikit-posthocs = callPackage ../development/python-modules/scikit-posthocs { };

  scikit-rf = callPackage ../development/python-modules/scikit-rf { };

  scikit-survival = callPackage ../development/python-modules/scikit-survival { };

  scikit-tda = callPackage ../development/python-modules/scikit-tda { };

  scikits-odes = callPackage ../development/python-modules/scikits-odes { };

  scikits-odes-core = callPackage ../development/python-modules/scikits-odes-core { };

  scikits-odes-daepack = callPackage ../development/python-modules/scikits-odes-daepack { };

  scikits-odes-sundials = callPackage ../development/python-modules/scikits-odes-sundials { };

  scim2-client = callPackage ../development/python-modules/scim2-client { };

  scim2-filter-parser = callPackage ../development/python-modules/scim2-filter-parser { };

  scim2-models = callPackage ../development/python-modules/scim2-models { };

  scim2-server = callPackage ../development/python-modules/scim2-server { };

  scim2-tester = callPackage ../development/python-modules/scim2-tester { };

  scipp = callPackage ../development/python-modules/scipp { };

  scipy = callPackage ../development/python-modules/scipy { };

  scipy-stubs = callPackage ../development/python-modules/scipy-stubs { };

  scmrepo = callPackage ../development/python-modules/scmrepo { };

  scooby = callPackage ../development/python-modules/scooby { };

  scour = callPackage ../development/python-modules/scour { };

  scp = callPackage ../development/python-modules/scp { };

  scramp = callPackage ../development/python-modules/scramp { };

  scrap-engine = callPackage ../development/python-modules/scrap-engine { };

  scrapy = callPackage ../development/python-modules/scrapy { };

  scrapy-deltafetch = callPackage ../development/python-modules/scrapy-deltafetch { };

  scrapy-fake-useragent = callPackage ../development/python-modules/scrapy-fake-useragent { };

  scrapy-splash = callPackage ../development/python-modules/scrapy-splash { };

  screed = callPackage ../development/python-modules/screed { };

  screeninfo = callPackage ../development/python-modules/screeninfo { };

  screenlogicpy = callPackage ../development/python-modules/screenlogicpy { };

  scripttest = callPackage ../development/python-modules/scripttest { };

  scrypt = callPackage ../development/python-modules/scrypt { };

  scs = callPackage ../development/python-modules/scs { };

  scsgate = callPackage ../development/python-modules/scsgate { };

  scspell = callPackage ../development/python-modules/scspell { };

  sdbus = callPackage ../development/python-modules/sdbus { };

  sdbus-networkmanager = callPackage ../development/python-modules/sdbus-networkmanager { };

  sdds = callPackage ../development/python-modules/sdds { };

  sdflit = callPackage ../development/python-modules/sdflit { };

  sdjson = callPackage ../development/python-modules/sdjson { };

  sdkmanager = callPackage ../development/python-modules/sdkmanager { };

  sdnotify = callPackage ../development/python-modules/sdnotify { };

  seaborn = callPackage ../development/python-modules/seaborn { };

  seabreeze = callPackage ../development/python-modules/seabreeze { };

  seasonal = callPackage ../development/python-modules/seasonal { };

  seatconnect = callPackage ../development/python-modules/seatconnect { };

  seccomp = callPackage ../development/python-modules/seccomp { };

  secp256k1 = callPackage ../development/python-modules/secp256k1 { inherit (pkgs) secp256k1; };

  secretstorage = callPackage ../development/python-modules/secretstorage { };

  sectools = callPackage ../development/python-modules/sectools { };

  sectxt = callPackage ../development/python-modules/sectxt { };

  secure = callPackage ../development/python-modules/secure { };

  securestring = callPackage ../development/python-modules/securestring { };

  securesystemslib = callPackage ../development/python-modules/securesystemslib { };

  securetar = callPackage ../development/python-modules/securetar { };

  securityreporter = callPackage ../development/python-modules/securityreporter { };

  seedir = callPackage ../development/python-modules/seedir { };

  seekpath = callPackage ../development/python-modules/seekpath { };

  segments = callPackage ../development/python-modules/segments { };

  segno = callPackage ../development/python-modules/segno { };

  segyio = callPackage ../development/python-modules/segyio { inherit (pkgs) cmake ninja; };

  selectolax = callPackage ../development/python-modules/selectolax { };

  selenium = callPackage ../development/python-modules/selenium { };

  selenium-wire = callPackage ../development/python-modules/selenium-wire { };

  semantic-version = callPackage ../development/python-modules/semantic-version { };

  semaphore-bot = callPackage ../development/python-modules/semaphore-bot { };

  semchunk = callPackage ../development/python-modules/semchunk { };

  semgrep = callPackage ../development/python-modules/semgrep {
    semgrep-core = callPackage ../development/python-modules/semgrep/semgrep-core.nix { };
  };

  semver = callPackage ../development/python-modules/semver { };

  send2trash = callPackage ../development/python-modules/send2trash { };

  sendgrid = callPackage ../development/python-modules/sendgrid { };

  senf = callPackage ../development/python-modules/senf { };

  sensai-utils = callPackage ../development/python-modules/sensai-utils { };

  sense-energy = callPackage ../development/python-modules/sense-energy { };

  sensirion-ble = callPackage ../development/python-modules/sensirion-ble { };

  sensor-state-data = callPackage ../development/python-modules/sensor-state-data { };

  sensorpro-ble = callPackage ../development/python-modules/sensorpro-ble { };

  sensorpush-api = callPackage ../development/python-modules/sensorpush-api { };

  sensorpush-ble = callPackage ../development/python-modules/sensorpush-ble { };

  sensorpush-ha = callPackage ../development/python-modules/sensorpush-ha { };

  sensoterra = callPackage ../development/python-modules/sensoterra { };

  sentence-splitter = callPackage ../development/python-modules/sentence-splitter { };

  sentence-stream = callPackage ../development/python-modules/sentence-stream { };

  sentence-transformers = callPackage ../development/python-modules/sentence-transformers { };

  sentencepiece = callPackage ../development/python-modules/sentencepiece {
    inherit (pkgs) sentencepiece;
  };

  sentinel = callPackage ../development/python-modules/sentinel { };

  sentinels = callPackage ../development/python-modules/sentinels { };

  sentry-sdk = callPackage ../development/python-modules/sentry-sdk/default.nix { };

  sepaxml = callPackage ../development/python-modules/sepaxml { };

  seqdiag = callPackage ../development/python-modules/seqdiag { };

  seqeval = callPackage ../development/python-modules/seqeval { };

  serialio = callPackage ../development/python-modules/serialio { };

  serializable = callPackage ../development/python-modules/serializable { };

  serpent = callPackage ../development/python-modules/serpent { };

  serpy = callPackage ../development/python-modules/serpy { };

  servefile = callPackage ../development/python-modules/servefile { };

  serverfiles = callPackage ../development/python-modules/serverfiles { };

  serverlessrepo = callPackage ../development/python-modules/serverlessrepo { };

  service-identity = callPackage ../development/python-modules/service-identity { };

  session-info2 = callPackage ../development/python-modules/session-info2 { };

  setproctitle = callPackage ../development/python-modules/setproctitle { };

  setupmeta = callPackage ../development/python-modules/setupmeta { };

  setuptools-changelog-shortener =
    callPackage ../development/python-modules/setuptools-changelog-shortener
      { };

  setuptools-declarative-requirements =
    callPackage ../development/python-modules/setuptools-declarative-requirements
      { };

  setuptools-dso = callPackage ../development/python-modules/setuptools-dso { };

  setuptools-generate = callPackage ../development/python-modules/setuptools-generate { };

  setuptools-gettext = callPackage ../development/python-modules/setuptools-gettext { };

  setuptools-git = callPackage ../development/python-modules/setuptools-git { };

  setuptools-git-versioning = callPackage ../development/python-modules/setuptools-git-versioning { };

  setuptools-lint = callPackage ../development/python-modules/setuptools-lint { };

  setuptools-odoo = callPackage ../development/python-modules/setuptools-odoo { };

  setuptools-rust = callPackage ../development/python-modules/setuptools-rust { };

  setuptools-scm = callPackage ../development/python-modules/setuptools-scm { };

  setuptools-scm-git-archive =
    callPackage ../development/python-modules/setuptools-scm-git-archive
      { };

  setuptools-trial = callPackage ../development/python-modules/setuptools-trial { };

  sev-snp-measure = callPackage ../development/python-modules/sev-snp-measure { };

  seventeentrack = callPackage ../development/python-modules/seventeentrack { };

  sexpdata = callPackage ../development/python-modules/sexpdata { };

  sfepy = callPackage ../development/python-modules/sfepy { };

  sfrbox-api = callPackage ../development/python-modules/sfrbox-api { };

  sgmllib3k = callPackage ../development/python-modules/sgmllib3k { };

  sgp4 = callPackage ../development/python-modules/sgp4 { };

  sh = callPackage ../development/python-modules/sh { };

  shamir-mnemonic = callPackage ../development/python-modules/shamir-mnemonic { };

  shap = callPackage ../development/python-modules/shap { };

  shapely = callPackage ../development/python-modules/shapely { };

  shaperglot = callPackage ../development/python-modules/shaperglot { };

  sharedmem = callPackage ../development/python-modules/sharedmem { };

  sharkiq = callPackage ../development/python-modules/sharkiq { };

  sharp-aquos-rc = callPackage ../development/python-modules/sharp-aquos-rc { };

  shazamio = callPackage ../development/python-modules/shazamio { };

  shellescape = callPackage ../development/python-modules/shellescape { };

  shellingham = callPackage ../development/python-modules/shellingham { };

  shiboken2 = toPythonModule (
    callPackage ../development/python-modules/shiboken2 { inherit (pkgs) cmake llvmPackages qt5; }
  );

  shiboken6 = toPythonModule (
    callPackage ../development/python-modules/shiboken6 { inherit (pkgs) cmake llvmPackages; }
  );

  shimmy = callPackage ../development/python-modules/shimmy { };

  shiny = callPackage ../development/python-modules/shiny { };

  shinychat = callPackage ../development/python-modules/shinychat { };

  shippinglabel = callPackage ../development/python-modules/shippinglabel { };

  shiv = callPackage ../development/python-modules/shiv { };

  shlib = callPackage ../development/python-modules/shlib { };

  shodan = callPackage ../development/python-modules/shodan { };

  shortuuid = callPackage ../development/python-modules/shortuuid { };

  should-dsl = callPackage ../development/python-modules/should-dsl { };

  show-in-file-manager = callPackage ../development/python-modules/show-in-file-manager { };

  showit = callPackage ../development/python-modules/showit { };

  shtab = callPackage ../development/python-modules/shtab { };

  shutilwhich = callPackage ../development/python-modules/shutilwhich { };

  sievelib = callPackage ../development/python-modules/sievelib { };

  signalslot = callPackage ../development/python-modules/signalslot { };

  signedjson = callPackage ../development/python-modules/signedjson { };

  signify = callPackage ../development/python-modules/signify { };

  signxml = callPackage ../development/python-modules/signxml { };

  sigparse = callPackage ../development/python-modules/sigparse { };

  sigrok = callPackage ../development/python-modules/sigrok { };

  sigstore = callPackage ../development/python-modules/sigstore { };

  sigstore-models = callPackage ../development/python-modules/sigstore-models { };

  sigstore-protobuf-specs = callPackage ../development/python-modules/sigstore-protobuf-specs { };

  sigstore-rekor-types = callPackage ../development/python-modules/sigstore-rekor-types { };

  sigtools = callPackage ../development/python-modules/sigtools { };

  simanneal = callPackage ../development/python-modules/simanneal { };

  simber = callPackage ../development/python-modules/simber { };

  simpful = callPackage ../development/python-modules/simpful { };

  simple-dftd3 = callPackage ../development/libraries/science/chemistry/simple-dftd3/python.nix {
    inherit (pkgs) simple-dftd3;
  };

  simple-di = callPackage ../development/python-modules/simple-di { };

  simple-parsing = callPackage ../development/python-modules/simple-parsing { };

  simple-rest-client = callPackage ../development/python-modules/simple-rest-client { };

  simple-rlp = callPackage ../development/python-modules/simple-rlp { };

  simple-salesforce = callPackage ../development/python-modules/simple-salesforce { };

  simple-term-menu = callPackage ../development/python-modules/simple-term-menu { };

  simple-websocket = callPackage ../development/python-modules/simple-websocket { };

  simple-websocket-server = callPackage ../development/python-modules/simple-websocket-server { };

  simpleaudio = callPackage ../development/python-modules/simpleaudio { };

  simplebayes = callPackage ../development/python-modules/simplebayes { };

  simplecosine = callPackage ../development/python-modules/simplecosine { };

  simpleeval = callPackage ../development/python-modules/simpleeval { };

  simplefin4py = callPackage ../development/python-modules/simplefin4py { };

  simplefix = callPackage ../development/python-modules/simplefix { };

  simplegeneric = callPackage ../development/python-modules/simplegeneric { };

  simplehound = callPackage ../development/python-modules/simplehound { };

  simpleitk = callPackage ../development/python-modules/simpleitk { inherit (pkgs) itk simpleitk; };

  simplejson = callPackage ../development/python-modules/simplejson { };

  simplekml = callPackage ../development/python-modules/simplekml { };

  simplekv = callPackage ../development/python-modules/simplekv { };

  simplemma = callPackage ../development/python-modules/simplemma { };

  simplenote = callPackage ../development/python-modules/simplenote { };

  simplepush = callPackage ../development/python-modules/simplepush { };

  simplesat = callPackage ../development/python-modules/simplesat { };

  simplesqlite = callPackage ../development/python-modules/simplesqlite { };

  simplisafe-python = callPackage ../development/python-modules/simplisafe-python { };

  simpy = callPackage ../development/python-modules/simpy { };

  simsimd = callPackage ../development/python-modules/simsimd { };

  single-source = callPackage ../development/python-modules/single-source { };

  single-version = callPackage ../development/python-modules/single-version { };

  siobrultech-protocols = callPackage ../development/python-modules/siobrultech-protocols { };

  siosocks = callPackage ../development/python-modules/siosocks { };

  sip = callPackage ../development/python-modules/sip { };

  sip4 = callPackage ../development/python-modules/sip/4.x.nix { };

  siphash24 = callPackage ../development/python-modules/siphash24 { };

  siphashc = callPackage ../development/python-modules/siphashc { };

  sipsimple = callPackage ../development/python-modules/sipsimple { };

  sipyco = callPackage ../development/python-modules/sipyco { };

  sirius = toPythonModule (
    pkgs.sirius.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  sismic = callPackage ../development/python-modules/sismic { };

  sisyphus-control = callPackage ../development/python-modules/sisyphus-control { };

  siuba = callPackage ../development/python-modules/siuba { };

  six = callPackage ../development/python-modules/six { };

  sixel = callPackage ../development/python-modules/sixel { };

  sixelcrop = callPackage ../development/python-modules/sixelcrop { };

  sjcl = callPackage ../development/python-modules/sjcl { };

  skein = callPackage ../development/python-modules/skein { };

  skia-pathops = callPackage ../development/python-modules/skia-pathops { };

  skidl = callPackage ../development/python-modules/skidl { };

  skl2onnx = callPackage ../development/python-modules/skl2onnx { };

  sklearn-compat = callPackage ../development/python-modules/sklearn-compat { };

  sklearn-deap = callPackage ../development/python-modules/sklearn-deap { };

  skodaconnect = callPackage ../development/python-modules/skodaconnect { };

  skops = callPackage ../development/python-modules/skops { };

  skorch = callPackage ../development/python-modules/skorch { };

  skrl = callPackage ../development/python-modules/skrl { };

  skybellpy = callPackage ../development/python-modules/skybellpy { };

  skyboxremote = callPackage ../development/python-modules/skyboxremote { };

  skyfield = callPackage ../development/python-modules/skyfield { };

  skytemple-dtef = callPackage ../development/python-modules/skytemple-dtef { };

  skytemple-eventserver = callPackage ../development/python-modules/skytemple-eventserver { };

  skytemple-files = callPackage ../development/python-modules/skytemple-files { };

  skytemple-icons = callPackage ../development/python-modules/skytemple-icons { };

  skytemple-rust = callPackage ../development/python-modules/skytemple-rust { };

  skytemple-ssb-debugger = callPackage ../development/python-modules/skytemple-ssb-debugger { };

  skytemple-ssb-emulator = callPackage ../development/python-modules/skytemple-ssb-emulator {
    inherit (pkgs) libpcap;
  };

  slack-bolt = callPackage ../development/python-modules/slack-bolt { };

  slack-sdk = callPackage ../development/python-modules/slack-sdk { };

  slapd = callPackage ../development/python-modules/slapd { };

  sleekxmpp = callPackage ../development/python-modules/sleekxmpp { };

  sleekxmppfs = callPackage ../development/python-modules/sleekxmppfs { };

  sleepyq = callPackage ../development/python-modules/sleepyq { };

  slepc4py = toPythonModule (
    pkgs.slepc.override {
      pythonSupport = true;
      python3Packages = self;
      petsc = petsc4py;
    }
  );

  sleqp = toPythonModule (
    pkgs.sleqp.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  slh-dsa = callPackage ../development/python-modules/slh-dsa { };

  slicedimage = callPackage ../development/python-modules/slicedimage { };

  slicer = callPackage ../development/python-modules/slicer { };

  slicerator = callPackage ../development/python-modules/slicerator { };

  slip10 = callPackage ../development/python-modules/slip10 { };

  slither-analyzer = callPackage ../development/python-modules/slither-analyzer { };

  slixmpp = callPackage ../development/python-modules/slixmpp { inherit (pkgs) gnupg; };

  slob = callPackage ../development/python-modules/slob { };

  slovnet = callPackage ../development/python-modules/slovnet { };

  slowapi = callPackage ../development/python-modules/slowapi { };

  slpp = callPackage ../development/python-modules/slpp { };

  slugid = callPackage ../development/python-modules/slugid { };

  sly = callPackage ../development/python-modules/sly { };

  smart-meter-texas = callPackage ../development/python-modules/smart-meter-texas { };

  smart-open = callPackage ../development/python-modules/smart-open { };

  smarthab = callPackage ../development/python-modules/smarthab { };

  smartypants = callPackage ../development/python-modules/smartypants { };

  smbprotocol = callPackage ../development/python-modules/smbprotocol { };

  smbus-cffi = callPackage ../development/python-modules/smbus-cffi { };

  smbus2 = callPackage ../development/python-modules/smbus2 { };

  smdebug-rulesconfig = callPackage ../development/python-modules/smdebug-rulesconfig { };

  smhi-pkg = callPackage ../development/python-modules/smhi-pkg { };

  smmap = callPackage ../development/python-modules/smmap { };

  smoke-zephyr = callPackage ../development/python-modules/smoke-zephyr { };

  smolagents = callPackage ../development/python-modules/smolagents { };

  smp = callPackage ../development/python-modules/smp { };

  smpclient = callPackage ../development/python-modules/smpclient { };

  smpp-pdu = callPackage ../development/python-modules/smpp-pdu { };

  smpplib = callPackage ../development/python-modules/smpplib { };

  smtpdfix = callPackage ../development/python-modules/smtpdfix { };

  snack = toPythonModule (pkgs.newt.override { python3 = self.python; });

  snakebite = callPackage ../development/python-modules/snakebite { };

  snakemake = toPythonModule (pkgs.snakemake.override { python3Packages = self; });

  snakemake-executor-plugin-cluster-generic =
    callPackage ../development/python-modules/snakemake-executor-plugin-cluster-generic
      { };

  snakemake-interface-common =
    callPackage ../development/python-modules/snakemake-interface-common
      { };

  snakemake-interface-executor-plugins =
    callPackage ../development/python-modules/snakemake-interface-executor-plugins
      { };

  snakemake-interface-logger-plugins =
    callPackage ../development/python-modules/snakemake-interface-logger-plugins
      { };

  snakemake-interface-report-plugins =
    callPackage ../development/python-modules/snakemake-interface-report-plugins
      { };

  snakemake-interface-scheduler-plugins =
    callPackage ../development/python-modules/snakemake-interface-scheduler-plugins
      { };

  snakemake-interface-storage-plugins =
    callPackage ../development/python-modules/snakemake-interface-storage-plugins
      { };

  snakemake-storage-plugin-fs =
    callPackage ../development/python-modules/snakemake-storage-plugin-fs
      { };

  snakemake-storage-plugin-s3 =
    callPackage ../development/python-modules/snakemake-storage-plugin-s3
      { };

  snakemake-storage-plugin-xrootd =
    callPackage ../development/python-modules/snakemake-storage-plugin-xrootd
      { };

  snakeviz = callPackage ../development/python-modules/snakeviz { };

  snapcast = callPackage ../development/python-modules/snapcast { };

  snappy = callPackage ../development/python-modules/snappy { };

  snappy-15-knots = callPackage ../development/python-modules/snappy-15-knots { };

  snappy-manifolds = callPackage ../development/python-modules/snappy-manifolds { };

  snapshot-restore-py = callPackage ../development/python-modules/snapshot-restore-py { };

  snapshottest = callPackage ../development/python-modules/snapshottest { };

  snaptime = callPackage ../development/python-modules/snaptime { };

  sniffio = callPackage ../development/python-modules/sniffio { };

  snitun = callPackage ../development/python-modules/snitun { };

  snorkel = callPackage ../development/python-modules/snorkel { };

  snowballstemmer = callPackage ../development/python-modules/snowballstemmer { };

  snowflake-connector-python =
    callPackage ../development/python-modules/snowflake-connector-python
      { };

  snowflake-core = callPackage ../development/python-modules/snowflake-core { };

  snowflake-sqlalchemy = callPackage ../development/python-modules/snowflake-sqlalchemy { };

  snowplow-tracker = callPackage ../development/python-modules/snowplow-tracker { };

  snscrape = callPackage ../development/python-modules/snscrape { };

  snuggs = callPackage ../development/python-modules/snuggs { };

  soapysdr = toPythonModule (
    pkgs.soapysdr.override {
      inherit (self) python;
      usePython = true;
    }
  );

  soapysdr-with-plugins = toPythonModule (
    pkgs.soapysdr-with-plugins.override {
      inherit (self) python;
      usePython = true;
    }
  );

  social-auth-app-django = callPackage ../development/python-modules/social-auth-app-django { };

  social-auth-core = callPackage ../development/python-modules/social-auth-core { };

  socialscan = callPackage ../development/python-modules/socialscan { };

  socid-extractor = callPackage ../development/python-modules/socid-extractor { };

  socketio-client = callPackage ../development/python-modules/socketio-client { };

  sockio = callPackage ../development/python-modules/sockio { };

  sockjs = callPackage ../development/python-modules/sockjs { };

  sockjs-tornado = callPackage ../development/python-modules/sockjs-tornado { };

  socksio = callPackage ../development/python-modules/socksio { };

  socksipy-branch = callPackage ../development/python-modules/socksipy-branch { };

  soco = callPackage ../development/python-modules/soco { };

  softlayer = callPackage ../development/python-modules/softlayer { };

  solaredge-local = callPackage ../development/python-modules/solaredge-local { };

  solaredge-web = callPackage ../development/python-modules/solaredge-web { };

  solarlog-cli = callPackage ../development/python-modules/solarlog-cli { };

  solax = callPackage ../development/python-modules/solax { };

  solc-select = callPackage ../development/python-modules/solc-select { };

  solidpython2 = callPackage ../development/python-modules/solidpython2 { };

  solo-python = disabledIf (!pythonAtLeast "3.6") (
    callPackage ../development/python-modules/solo-python { }
  );

  somajo = callPackage ../development/python-modules/somajo { };

  somfy-mylink-synergy = callPackage ../development/python-modules/somfy-mylink-synergy { };

  somweb = callPackage ../development/python-modules/somweb { };

  sonos-websocket = callPackage ../development/python-modules/sonos-websocket { };

  sopel = callPackage ../development/python-modules/sopel { };

  sorl-thumbnail = callPackage ../development/python-modules/sorl-thumbnail { };

  sortedcollections = callPackage ../development/python-modules/sortedcollections { };

  sortedcontainers = callPackage ../development/python-modules/sortedcontainers { };

  sotabenchapi = callPackage ../development/python-modules/sotabenchapi { };

  soundcard = callPackage ../development/python-modules/soundcard { };

  soundcloud-v2 = callPackage ../development/python-modules/soundcloud-v2 { };

  sounddevice = callPackage ../development/python-modules/sounddevice { };

  soundfile = callPackage ../development/python-modules/soundfile { };

  soupsieve = callPackage ../development/python-modules/soupsieve { };

  sourmash = callPackage ../development/python-modules/sourmash { };

  soxr = callPackage ../development/python-modules/soxr { libsoxr = pkgs.soxr; };

  spacy = callPackage ../development/python-modules/spacy { };

  spacy-alignments = callPackage ../development/python-modules/spacy-alignments { };

  spacy-curated-transformers =
    callPackage ../development/python-modules/spacy-curated-transformers
      { };

  spacy-legacy = callPackage ../development/python-modules/spacy/legacy.nix { };

  spacy-loggers = callPackage ../development/python-modules/spacy-loggers { };

  spacy-lookups-data = callPackage ../development/python-modules/spacy/lookups-data.nix { };

  spacy-models = callPackage ../development/python-modules/spacy/models.nix { inherit (pkgs) jq; };

  spacy-pkuseg = callPackage ../development/python-modules/spacy-pkuseg { };

  spacy-transformers = callPackage ../development/python-modules/spacy-transformers { };

  spake2 = callPackage ../development/python-modules/spake2 { };

  spark-parser = callPackage ../development/python-modules/spark-parser { };

  sparklines = callPackage ../development/python-modules/sparklines { };

  sparqlwrapper = callPackage ../development/python-modules/sparqlwrapper { };

  sparse = callPackage ../development/python-modules/sparse { };

  spatial-image = callPackage ../development/python-modules/spatial-image { };

  spatialmath-python = callPackage ../development/python-modules/spatialmath-python { };

  spdx = callPackage ../development/python-modules/spdx { };

  spdx-tools = callPackage ../development/python-modules/spdx-tools { };

  speak2mary = callPackage ../development/python-modules/speak2mary { };

  speaklater = callPackage ../development/python-modules/speaklater { };

  speaklater3 = callPackage ../development/python-modules/speaklater3 { };

  specfile = callPackage ../development/python-modules/specfile { };

  spectra = callPackage ../development/python-modules/spectra { };

  spectral-cube = callPackage ../development/python-modules/spectral-cube { };

  speechbrain = callPackage ../development/python-modules/speechbrain { };

  speechrecognition = callPackage ../development/python-modules/speechrecognition { };

  speedtest-cli = callPackage ../development/python-modules/speedtest-cli { };

  speg = callPackage ../development/python-modules/speg { };

  spglib = callPackage ../development/python-modules/spglib { };

  spherogram = callPackage ../development/python-modules/spherogram { };

  sphfile = callPackage ../development/python-modules/sphfile { };

  sphinx = callPackage ../development/python-modules/sphinx { };

  sphinx-argparse = callPackage ../development/python-modules/sphinx-argparse { };

  sphinx-autoapi = callPackage ../development/python-modules/sphinx-autoapi { };

  sphinx-autobuild = callPackage ../development/python-modules/sphinx-autobuild { };

  sphinx-autodoc-typehints = callPackage ../development/python-modules/sphinx-autodoc-typehints { };

  sphinx-autodoc2 = callPackage ../development/python-modules/sphinx-autodoc2 { };

  sphinx-automodapi = callPackage ../development/python-modules/sphinx-automodapi {
    graphviz = pkgs.graphviz;
  };

  sphinx-basic-ng = callPackage ../development/python-modules/sphinx-basic-ng { };

  sphinx-better-theme = callPackage ../development/python-modules/sphinx-better-theme { };

  sphinx-book-theme = callPackage ../development/python-modules/sphinx-book-theme { };

  sphinx-click = callPackage ../development/python-modules/sphinx-click { };

  sphinx-codeautolink = callPackage ../development/python-modules/sphinx-codeautolink { };

  sphinx-comments = callPackage ../development/python-modules/sphinx-comments { };

  sphinx-copybutton = callPackage ../development/python-modules/sphinx-copybutton { };

  sphinx-design = callPackage ../development/python-modules/sphinx-design { };

  sphinx-external-toc = callPackage ../development/python-modules/sphinx-external-toc { };

  sphinx-favicon = callPackage ../development/python-modules/sphinx-favicon { };

  sphinx-fortran = callPackage ../development/python-modules/sphinx-fortran { };

  sphinx-hoverxref = callPackage ../development/python-modules/sphinx-hoverxref { };

  sphinx-inline-tabs = callPackage ../development/python-modules/sphinx-inline-tabs { };

  sphinx-intl = callPackage ../development/python-modules/sphinx-intl { };

  sphinx-issues = callPackage ../development/python-modules/sphinx-issues { };

  sphinx-jinja = callPackage ../development/python-modules/sphinx-jinja { };

  sphinx-jinja2-compat = callPackage ../development/python-modules/sphinx-jinja2-compat { };

  sphinx-jupyterbook-latex = callPackage ../development/python-modules/sphinx-jupyterbook-latex { };

  sphinx-last-updated-by-git =
    callPackage ../development/python-modules/sphinx-last-updated-by-git
      { };

  sphinx-lv2-theme = callPackage ../development/python-modules/sphinx-lv2-theme { };

  sphinx-markdown-builder = callPackage ../development/python-modules/sphinx-markdown-builder { };

  sphinx-markdown-parser = callPackage ../development/python-modules/sphinx-markdown-parser { };

  sphinx-markdown-tables = callPackage ../development/python-modules/sphinx-markdown-tables { };

  sphinx-material = callPackage ../development/python-modules/sphinx-material { };

  sphinx-mdinclude = callPackage ../development/python-modules/sphinx-mdinclude { };

  sphinx-multitoc-numbering = callPackage ../development/python-modules/sphinx-multitoc-numbering { };

  sphinx-multiversion = callPackage ../development/python-modules/sphinx-multiversion { };

  sphinx-notfound-page = callPackage ../development/python-modules/sphinx-notfound-page { };

  sphinx-prompt = callPackage ../development/python-modules/sphinx-prompt { };

  sphinx-pytest = callPackage ../development/python-modules/sphinx-pytest { };

  sphinx-remove-toctrees = callPackage ../development/python-modules/sphinx-remove-toctrees { };

  sphinx-reredirects = callPackage ../development/python-modules/sphinx-reredirects { };

  sphinx-rtd-dark-mode = callPackage ../development/python-modules/sphinx-rtd-dark-mode { };

  sphinx-rtd-theme = callPackage ../development/python-modules/sphinx-rtd-theme { };

  sphinx-serve = callPackage ../development/python-modules/sphinx-serve { };

  sphinx-sitemap = callPackage ../development/python-modules/sphinx-sitemap { };

  sphinx-tabs = callPackage ../development/python-modules/sphinx-tabs { };

  sphinx-testing = callPackage ../development/python-modules/sphinx-testing { };

  sphinx-thebe = callPackage ../development/python-modules/sphinx-thebe { };

  sphinx-tippy = callPackage ../development/python-modules/sphinx-tippy { };

  sphinx-togglebutton = callPackage ../development/python-modules/sphinx-togglebutton { };

  sphinx-toolbox = callPackage ../development/python-modules/sphinx-toolbox { };

  sphinx-version-warning = callPackage ../development/python-modules/sphinx-version-warning { };

  sphinx-versions = callPackage ../development/python-modules/sphinx-versions { };

  sphinxawesome-theme = callPackage ../development/python-modules/sphinxawesome-theme { };

  sphinxcontrib-actdiag = callPackage ../development/python-modules/sphinxcontrib-actdiag { };

  sphinxcontrib-apidoc = callPackage ../development/python-modules/sphinxcontrib-apidoc { };

  sphinxcontrib-applehelp = callPackage ../development/python-modules/sphinxcontrib-applehelp { };

  sphinxcontrib-asyncio = callPackage ../development/python-modules/sphinxcontrib-asyncio { };

  sphinxcontrib-bayesnet = callPackage ../development/python-modules/sphinxcontrib-bayesnet { };

  sphinxcontrib-bibtex = callPackage ../development/python-modules/sphinxcontrib-bibtex { };

  sphinxcontrib-blockdiag = callPackage ../development/python-modules/sphinxcontrib-blockdiag { };

  sphinxcontrib-confluencebuilder =
    callPackage ../development/python-modules/sphinxcontrib-confluencebuilder
      { };

  sphinxcontrib-devhelp = callPackage ../development/python-modules/sphinxcontrib-devhelp { };

  sphinxcontrib-ditaa = callPackage ../development/python-modules/sphinxcontrib-ditaa { };

  sphinxcontrib-excel-table = callPackage ../development/python-modules/sphinxcontrib-excel-table { };

  sphinxcontrib-fulltoc = callPackage ../development/python-modules/sphinxcontrib-fulltoc { };

  sphinxcontrib-htmlhelp = callPackage ../development/python-modules/sphinxcontrib-htmlhelp { };

  sphinxcontrib-httpdomain = callPackage ../development/python-modules/sphinxcontrib-httpdomain { };

  sphinxcontrib-images = callPackage ../development/python-modules/sphinxcontrib-images { };

  sphinxcontrib-jinjadomain = callPackage ../development/python-modules/sphinxcontrib-jinjadomain { };

  sphinxcontrib-jquery = callPackage ../development/python-modules/sphinxcontrib-jquery { };

  sphinxcontrib-jsmath = callPackage ../development/python-modules/sphinxcontrib-jsmath { };

  sphinxcontrib-katex = callPackage ../development/python-modules/sphinxcontrib-katex { };

  sphinxcontrib-log-cabinet = callPackage ../development/python-modules/sphinxcontrib-log-cabinet { };

  sphinxcontrib-mermaid = callPackage ../development/python-modules/sphinxcontrib-mermaid { };

  sphinxcontrib-moderncmakedomain =
    callPackage ../development/python-modules/sphinxcontrib-moderncmakedomain
      { };

  sphinxcontrib-mscgen = callPackage ../development/python-modules/sphinxcontrib-mscgen {
    inherit (pkgs) mscgen;
  };

  sphinxcontrib-newsfeed = callPackage ../development/python-modules/sphinxcontrib-newsfeed { };

  sphinxcontrib-nwdiag = callPackage ../development/python-modules/sphinxcontrib-nwdiag { };

  sphinxcontrib-openapi = callPackage ../development/python-modules/sphinxcontrib-openapi { };

  sphinxcontrib-plantuml = callPackage ../development/python-modules/sphinxcontrib-plantuml {
    inherit (pkgs) plantuml;
  };

  sphinxcontrib-programoutput =
    callPackage ../development/python-modules/sphinxcontrib-programoutput
      { };

  sphinxcontrib-qthelp = callPackage ../development/python-modules/sphinxcontrib-qthelp { };

  sphinxcontrib-seqdiag = callPackage ../development/python-modules/sphinxcontrib-seqdiag { };

  sphinxcontrib-serializinghtml =
    callPackage ../development/python-modules/sphinxcontrib-serializinghtml
      { };

  sphinxcontrib-spelling = callPackage ../development/python-modules/sphinxcontrib-spelling { };

  sphinxcontrib-svg2pdfconverter =
    callPackage ../development/python-modules/sphinxcontrib-svg2pdfconverter
      { };

  sphinxcontrib-tikz = callPackage ../development/python-modules/sphinxcontrib-tikz { };

  sphinxcontrib-wavedrom = callPackage ../development/python-modules/sphinxcontrib-wavedrom { };

  sphinxcontrib-websupport = callPackage ../development/python-modules/sphinxcontrib-websupport { };

  sphinxcontrib-youtube = callPackage ../development/python-modules/sphinxcontrib-youtube { };

  sphinxemoji = callPackage ../development/python-modules/sphinxemoji { };

  sphinxext-opengraph = callPackage ../development/python-modules/sphinxext-opengraph { };

  sphinxext-rediraffe = callPackage ../development/python-modules/sphinxext-rediraffe { };

  spiderpy = callPackage ../development/python-modules/spiderpy { };

  spidev = callPackage ../development/python-modules/spidev { };

  spinners = callPackage ../development/python-modules/spinners { };

  splinter = callPackage ../development/python-modules/splinter { };

  splunk-sdk = callPackage ../development/python-modules/splunk-sdk { };

  spotifyaio = callPackage ../development/python-modules/spotifyaio { };

  spotipy = callPackage ../development/python-modules/spotipy { };

  spsdk = callPackage ../development/python-modules/spsdk { };

  spsdk-mcu-link = callPackage ../development/python-modules/spsdk-mcu-link { };

  spsdk-pyocd = callPackage ../development/python-modules/spsdk-pyocd { };

  spur = callPackage ../development/python-modules/spur { };

  spyder = callPackage ../development/python-modules/spyder { };

  spyder-kernels = callPackage ../development/python-modules/spyder-kernels { };

  spylls = callPackage ../development/python-modules/spylls { };

  spyse-python = callPackage ../development/python-modules/spyse-python { };

  spython = callPackage ../development/python-modules/spython { };

  sqids = callPackage ../development/python-modules/sqids { };

  sqlalchemy = callPackage ../development/python-modules/sqlalchemy { };

  sqlalchemy-citext = callPackage ../development/python-modules/sqlalchemy-citext { };

  sqlalchemy-cockroachdb = callPackage ../development/python-modules/sqlalchemy-cockroachdb { };

  sqlalchemy-continuum = callPackage ../development/python-modules/sqlalchemy-continuum { };

  sqlalchemy-file = callPackage ../development/python-modules/sqlalchemy-file { };

  sqlalchemy-i18n = callPackage ../development/python-modules/sqlalchemy-i18n { };

  sqlalchemy-json = callPackage ../development/python-modules/sqlalchemy-json { };

  sqlalchemy-jsonfield = callPackage ../development/python-modules/sqlalchemy-jsonfield { };

  sqlalchemy-mixins = callPackage ../development/python-modules/sqlalchemy-mixins { };

  sqlalchemy-utc = callPackage ../development/python-modules/sqlalchemy-utc { };

  sqlalchemy-utils = callPackage ../development/python-modules/sqlalchemy-utils { };

  sqlalchemy_1_4 = callPackage ../development/python-modules/sqlalchemy/1_4.nix { };

  sqlcipher3 = callPackage ../development/python-modules/sqlcipher3 { };

  sqlcipher3-binary = callPackage ../development/python-modules/sqlcipher3-binary { };

  sqlcipher3-wheels = callPackage ../development/python-modules/sqlcipher3-wheels { };

  sqlfmt = callPackage ../development/python-modules/sqlfmt { };

  sqlframe = callPackage ../development/python-modules/sqlframe { };

  sqlglot = callPackage ../development/python-modules/sqlglot { };

  sqlite-anyio = callPackage ../development/python-modules/sqlite-anyio { };

  sqlite-fts4 = callPackage ../development/python-modules/sqlite-fts4 { };

  sqlite-migrate = callPackage ../development/python-modules/sqlite-migrate { };

  sqlite-utils = callPackage ../development/python-modules/sqlite-utils { };

  sqlite-vec = callPackage ../development/python-modules/sqlite-vec {
    sqlite-vec-c = pkgs.sqlite-vec;
  };

  sqlitedict = callPackage ../development/python-modules/sqlitedict { };

  sqliteschema = callPackage ../development/python-modules/sqliteschema { };

  sqlmap = callPackage ../development/python-modules/sqlmap { };

  sqlmodel = callPackage ../development/python-modules/sqlmodel { };

  sqlobject = callPackage ../development/python-modules/sqlobject { };

  sqlparse = callPackage ../development/python-modules/sqlparse { };

  sqltrie = callPackage ../development/python-modules/sqltrie { };

  squarify = callPackage ../development/python-modules/squarify { };

  srctools = callPackage ../development/python-modules/srctools { };

  sre-yield = callPackage ../development/python-modules/sre-yield { };

  srp = callPackage ../development/python-modules/srp { };

  srpenergy = callPackage ../development/python-modules/srpenergy { };

  srptools = callPackage ../development/python-modules/srptools { };

  srsly = callPackage ../development/python-modules/srsly { };

  srt = callPackage ../development/python-modules/srt { };

  srvlookup = callPackage ../development/python-modules/srvlookup { };

  ssdeep = callPackage ../development/python-modules/ssdeep { inherit (pkgs) ssdeep; };

  ssdp = callPackage ../development/python-modules/ssdp { };

  ssdpy = callPackage ../development/python-modules/ssdpy { };

  sse-starlette = callPackage ../development/python-modules/sse-starlette { };

  sseclient = callPackage ../development/python-modules/sseclient { };

  sseclient-py = callPackage ../development/python-modules/sseclient-py { };

  ssg = callPackage ../development/python-modules/ssg { };

  ssh-python = callPackage ../development/python-modules/ssh-python { };

  ssh2-python = callPackage ../development/python-modules/ssh2-python { };

  sshfs = callPackage ../development/python-modules/sshfs { };

  sshpubkeys = callPackage ../development/python-modules/sshpubkeys { };

  sshtunnel = callPackage ../development/python-modules/sshtunnel { };

  sslib = callPackage ../development/python-modules/sslib { };

  sslpsk-pmd3 = callPackage ../development/python-modules/sslpsk-pmd3 { };

  ssort = callPackage ../development/python-modules/ssort { };

  sss = callPackage ../development/python-modules/sss { };

  st-pages = callPackage ../development/python-modules/st-pages { };

  stable-baselines3 = callPackage ../development/python-modules/stable-baselines3 { };

  stack-data = callPackage ../development/python-modules/stack-data { };

  stackprinter = callPackage ../development/python-modules/stackprinter { };

  stamina = callPackage ../development/python-modules/stamina { };

  standard-aifc =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/standard-aifc { } else null;

  standard-cgi =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/standard-cgi { } else null;

  standard-chunk =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/standard-chunk { } else null;

  standard-imghdr =
    if pythonAtLeast "3.13" then
      callPackage ../development/python-modules/standard-imghdr { }
    else
      null;

  standard-mailcap =
    if pythonOlder "3.13" then null else callPackage ../development/python-modules/standard-mailcap { };

  standard-nntplib =
    if pythonOlder "3.13" then null else callPackage ../development/python-modules/standard-nntplib { };

  standard-pipes =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/standard-pipes { } else null;

  standard-sndhdr =
    if pythonAtLeast "3.13" then
      callPackage ../development/python-modules/standard-sndhdr { }
    else
      null;

  standard-sunau =
    if pythonAtLeast "3.13" then callPackage ../development/python-modules/standard-sunau { } else null;

  standard-telnetlib =
    if pythonAtLeast "3.13" then
      callPackage ../development/python-modules/standard-telnetlib { }
    else
      null;

  standardwebhooks = callPackage ../development/python-modules/standardwebhooks { };

  stanio = callPackage ../development/python-modules/stanio { };

  stanza = callPackage ../development/python-modules/stanza { };

  starkbank-ecdsa = callPackage ../development/python-modules/starkbank-ecdsa { };

  starlette = callPackage ../development/python-modules/starlette { };

  starlette-admin = callPackage ../development/python-modules/starlette-admin { };

  starlette-compress = callPackage ../development/python-modules/starlette-compress { };

  starlette-context = callPackage ../development/python-modules/starlette-context { };

  starlette-wtf = callPackage ../development/python-modules/starlette-wtf { };

  starline = callPackage ../development/python-modules/starline { };

  starlingbank = callPackage ../development/python-modules/starlingbank { };

  starlink-grpc-core = callPackage ../development/python-modules/starlink-grpc-core { };

  starsessions = callPackage ../development/python-modules/starsessions { };

  stashy = callPackage ../development/python-modules/stashy { };

  static3 = callPackage ../development/python-modules/static3 { };

  staticjinja = callPackage ../development/python-modules/staticjinja { };

  staticmap = callPackage ../development/python-modules/staticmap { };

  staticmap3 = callPackage ../development/python-modules/staticmap3 { };

  staticvectors = callPackage ../development/python-modules/staticvectors { };

  statistics = callPackage ../development/python-modules/statistics { };

  statmake = callPackage ../development/python-modules/statmake { };

  statsd = callPackage ../development/python-modules/statsd { };

  statsmodels = callPackage ../development/python-modules/statsmodels { };

  std-uritemplate = callPackage ../development/python-modules/std-uritemplate { };

  std2 = callPackage ../development/python-modules/std2 { };

  stdiomask = callPackage ../development/python-modules/stdiomask { };

  stdlib-list = callPackage ../development/python-modules/stdlib-list { };

  stdlibs = callPackage ../development/python-modules/stdlibs { };

  steam = callPackage ../development/python-modules/steam { };

  steamodd = callPackage ../development/python-modules/steamodd { };

  steamship = callPackage ../development/python-modules/steamship { };

  steamworkspy = callPackage ../development/python-modules/steamworkspy { };

  stem = callPackage ../development/python-modules/stem { };

  stemming = callPackage ../development/python-modules/stemming { };

  stestr = callPackage ../development/python-modules/stestr { };

  stevedore = callPackage ../development/python-modules/stevedore { };

  stickytape = callPackage ../development/python-modules/stickytape { };

  stim = callPackage ../development/python-modules/stim { };

  stix2 = callPackage ../development/python-modules/stix2 { };

  stix2-patterns = callPackage ../development/python-modules/stix2-patterns { };

  stix2-validator = callPackage ../development/python-modules/stix2-validator { };

  stm32loader = callPackage ../development/python-modules/stm32loader { };

  stomp-py = callPackage ../development/python-modules/stomp-py { };

  stone = callPackage ../development/python-modules/stone { };

  stookalert = callPackage ../development/python-modules/stookalert { };

  stookwijzer = callPackage ../development/python-modules/stookwijzer { };

  stop-words = callPackage ../development/python-modules/stop-words { };

  stopit = callPackage ../development/python-modules/stopit { };

  storage3 = callPackage ../development/python-modules/storage3 { };

  stp = toPythonModule (pkgs.stp.override { python3 = self.python; });

  stransi = callPackage ../development/python-modules/stransi { };

  strategies = callPackage ../development/python-modules/strategies { };

  stravalib = callPackage ../development/python-modules/stravalib { };

  stravaweblib = callPackage ../development/python-modules/stravaweblib { };

  strawberry-django = callPackage ../development/python-modules/strawberry-django { };

  strawberry-graphql = callPackage ../development/python-modules/strawberry-graphql { };

  strct = callPackage ../development/python-modules/strct { };

  streamcontroller-plugin-tools =
    callPackage ../development/python-modules/streamcontroller-plugin-tools
      { };

  streamdeck = callPackage ../development/python-modules/streamdeck { };

  streaming-form-data = callPackage ../development/python-modules/streaming-form-data { };

  streamlabswater = callPackage ../development/python-modules/streamlabswater { };

  streamlit = callPackage ../development/python-modules/streamlit { };

  streamz = callPackage ../development/python-modules/streamz { };

  strenum = callPackage ../development/python-modules/strenum { };

  strict-rfc3339 = callPackage ../development/python-modules/strict-rfc3339 { };

  strictyaml = callPackage ../development/python-modules/strictyaml { };

  stringbrewer = callPackage ../development/python-modules/stringbrewer { };

  stringcase = callPackage ../development/python-modules/stringcase { };

  stringly = callPackage ../development/python-modules/stringly { };

  stringparser = callPackage ../development/python-modules/stringparser { };

  stringzilla = callPackage ../development/python-modules/stringzilla { };

  strip-ansi = callPackage ../development/python-modules/strip-ansi { };

  stripe = callPackage ../development/python-modules/stripe { };

  striprtf = callPackage ../development/python-modules/striprtf { };

  strpdatetime = callPackage ../development/python-modules/strpdatetime { };

  structlog = callPackage ../development/python-modules/structlog { };

  stubserver = callPackage ../development/python-modules/stubserver { };

  stumpy = callPackage ../development/python-modules/stumpy { };

  stupidartnet = callPackage ../development/python-modules/stupidartnet { };

  stups-cli-support = callPackage ../development/python-modules/stups-cli-support { };

  stups-fullstop = callPackage ../development/python-modules/stups-fullstop { };

  stups-pierone = callPackage ../development/python-modules/stups-pierone { };

  stups-tokens = callPackage ../development/python-modules/stups-tokens { };

  stups-zign = callPackage ../development/python-modules/stups-zign { };

  stytra = callPackage ../development/python-modules/stytra { };

  subarulink = callPackage ../development/python-modules/subarulink { };

  subliminal = callPackage ../development/python-modules/subliminal { };

  submitit = callPackage ../development/python-modules/submitit { };

  subprocess-tee = callPackage ../development/python-modules/subprocess-tee { };

  subunit = callPackage ../development/python-modules/subunit {
    inherit (pkgs) subunit cppunit check;
  };

  subzerod = callPackage ../development/python-modules/subzerod { };

  succulent = callPackage ../development/python-modules/succulent { };

  sudachidict-core = callPackage ../development/python-modules/sudachidict { };

  sudachidict-full = callPackage ../development/python-modules/sudachidict {
    sudachidict = pkgs.sudachidict.override { dict-type = "full"; };
  };

  sudachidict-small = callPackage ../development/python-modules/sudachidict {
    sudachidict = pkgs.sudachidict.override { dict-type = "small"; };
  };

  sudachipy = callPackage ../development/python-modules/sudachipy { };

  suds = callPackage ../development/python-modules/suds { };

  suds-community = callPackage ../development/python-modules/suds-community { };

  summarytools = callPackage ../development/python-modules/summarytools { };

  sumo = callPackage ../development/python-modules/sumo { };

  sumtypes = callPackage ../development/python-modules/sumtypes { };

  sunpy = callPackage ../development/python-modules/sunpy { };

  sunwatcher = callPackage ../development/python-modules/sunwatcher { };

  sunweg = callPackage ../development/python-modules/sunweg { };

  supabase = callPackage ../development/python-modules/supabase { };

  supabase-functions = self.supafunc;

  supafunc = callPackage ../development/python-modules/supafunc { };

  super-collections = callPackage ../development/python-modules/super-collections { };

  superqt = callPackage ../development/python-modules/superqt { };

  supervise-api = callPackage ../development/python-modules/supervise-api { };

  supervisor = callPackage ../development/python-modules/supervisor { };

  sure = callPackage ../development/python-modules/sure { };

  surepy = callPackage ../development/python-modules/surepy { };

  surt = callPackage ../development/python-modules/surt { };

  survey = callPackage ../development/python-modules/survey { };

  sv-ttk = callPackage ../development/python-modules/sv-ttk { };

  svg-path = callPackage ../development/python-modules/svg-path { };

  svg-py = callPackage ../development/python-modules/svg-py { };

  svg2tikz = callPackage ../development/python-modules/svg2tikz { };

  svgdigitizer = callPackage ../development/python-modules/svgdigitizer { };

  svgelements = callPackage ../development/python-modules/svgelements { };

  svglib = callPackage ../development/python-modules/svglib { };

  svgpathtools = callPackage ../development/python-modules/svgpathtools { };

  svgutils = callPackage ../development/python-modules/svgutils { };

  svgwrite = callPackage ../development/python-modules/svgwrite { };

  swagger-spec-validator = callPackage ../development/python-modules/swagger-spec-validator { };

  swagger-ui-bundle = callPackage ../development/python-modules/swagger-ui-bundle { };

  swagger-ui-py = callPackage ../development/python-modules/swagger-ui-py { };

  swcgeom = callPackage ../development/python-modules/swcgeom { };

  swh-auth = callPackage ../development/python-modules/swh-auth { };

  swh-core = callPackage ../development/python-modules/swh-core { };

  swh-export = callPackage ../development/python-modules/swh-export { };

  swh-journal = callPackage ../development/python-modules/swh-journal { };

  swh-model = callPackage ../development/python-modules/swh-model { };

  swh-objstorage = callPackage ../development/python-modules/swh-objstorage { };

  swh-scanner = callPackage ../development/python-modules/swh-scanner { };

  swh-scheduler = callPackage ../development/python-modules/swh-scheduler { };

  swh-shard = callPackage ../development/python-modules/swh-shard { };

  swh-storage = callPackage ../development/python-modules/swh-storage { };

  swh-web-client = callPackage ../development/python-modules/swh-web-client { };

  swift = callPackage ../development/python-modules/swift { };

  swifter = callPackage ../development/python-modules/swifter { };

  swisshydrodata = callPackage ../development/python-modules/swisshydrodata { };

  switchbot-api = callPackage ../development/python-modules/switchbot-api { };

  swspotify = callPackage ../development/python-modules/swspotify { };

  sybil = callPackage ../development/python-modules/sybil { };

  symbex = callPackage ../development/python-modules/symbex { };

  symbolic = callPackage ../development/python-modules/symbolic { };

  symengine = callPackage ../development/python-modules/symengine { inherit (pkgs) symengine; };

  symfc = callPackage ../development/python-modules/symfc { };

  sympy = callPackage ../development/python-modules/sympy { };

  symspellpy = callPackage ../development/python-modules/symspellpy { };

  syncedlyrics = callPackage ../development/python-modules/syncedlyrics { };

  syncer = callPackage ../development/python-modules/syncer { };

  syndication-domination = toPythonModule (
    pkgs.syndication-domination.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  syne-tune = callPackage ../development/python-modules/syne-tune { };

  synergy = callPackage ../development/python-modules/synergy { };

  synology-srm = callPackage ../development/python-modules/synology-srm { };

  syrupy = callPackage ../development/python-modules/syrupy { };

  syslog-rfc5424-formatter = callPackage ../development/python-modules/syslog-rfc5424-formatter { };

  sysrsync = callPackage ../development/python-modules/sysrsync { };

  systembridgeconnector = callPackage ../development/python-modules/systembridgeconnector { };

  systembridgemodels = callPackage ../development/python-modules/systembridgemodels { };

  systemd-python = callPackage ../development/python-modules/systemd-python {
    inherit (pkgs) systemd;
  };

  systemdunitparser = callPackage ../development/python-modules/systemdunitparser { };

  sysv-ipc = callPackage ../development/python-modules/sysv-ipc { };

  t61codec = callPackage ../development/python-modules/t61codec { };

  tabcmd = callPackage ../development/python-modules/tabcmd { };

  tableaudocumentapi = callPackage ../development/python-modules/tableaudocumentapi { };

  tableauserverclient = callPackage ../development/python-modules/tableauserverclient { };

  tabledata = callPackage ../development/python-modules/tabledata { };

  tables = callPackage ../development/python-modules/tables { };

  tablib = callPackage ../development/python-modules/tablib { };

  tabula-py = callPackage ../development/python-modules/tabula-py { };

  tabulate = callPackage ../development/python-modules/tabulate { };

  tabview = callPackage ../development/python-modules/tabview { };

  taco = toPythonModule (
    pkgs.taco.override {
      inherit (self) python;
      enablePython = true;
    }
  );

  tadasets = callPackage ../development/python-modules/tadasets { };

  tag-expressions = callPackage ../development/python-modules/tag-expressions { };

  tago = callPackage ../development/python-modules/tago { };

  tagoio-sdk = callPackage ../development/python-modules/tagoio-sdk { };

  tahoma-api = callPackage ../development/python-modules/tahoma-api { };

  tailer = callPackage ../development/python-modules/tailer { };

  tailscale = callPackage ../development/python-modules/tailscale { };

  takethetime = callPackage ../development/python-modules/takethetime { };

  tami4edgeapi = callPackage ../development/python-modules/tami4edgeapi { };

  tank-utility = callPackage ../development/python-modules/tank-utility { };

  tappy = callPackage ../development/python-modules/tappy { };

  tapsaff = callPackage ../development/python-modules/tapsaff { };

  targ = callPackage ../development/python-modules/targ { };

  tasklib = callPackage ../development/python-modules/tasklib { };

  taskw = callPackage ../development/python-modules/taskw { };

  taskw-ng = callPackage ../development/python-modules/taskw-ng { };

  tatsu = callPackage ../development/python-modules/tatsu { };

  tatsu-lts = callPackage ../development/python-modules/tatsu-lts { };

  taxi = callPackage ../development/python-modules/taxi { };

  taxii2-client = callPackage ../development/python-modules/taxii2-client { };

  tbats = callPackage ../development/python-modules/tbats { };

  tblib = callPackage ../development/python-modules/tblib { };

  tblite = callPackage ../development/libraries/science/chemistry/tblite/python.nix {
    inherit (pkgs)
      tblite
      meson
      simple-dftd3
      dftd4
      ;
  };

  tbm-utils = callPackage ../development/python-modules/tbm-utils { };

  tcolorpy = callPackage ../development/python-modules/tcolorpy { };

  tcxfile = callPackage ../development/python-modules/tcxfile { };

  tcxparser = callPackage ../development/python-modules/tcxparser { };

  tcxreader = callPackage ../development/python-modules/tcxreader { };

  tdir = callPackage ../development/python-modules/tdir { };

  teamcity-messages = callPackage ../development/python-modules/teamcity-messages { };

  telegram-text = callPackage ../development/python-modules/telegram-text { };

  telegraph = callPackage ../development/python-modules/telegraph { };

  telepath = callPackage ../development/python-modules/telepath { };

  telethon = callPackage ../development/python-modules/telethon { inherit (pkgs) openssl; };

  telethon-session-sqlalchemy =
    callPackage ../development/python-modules/telethon-session-sqlalchemy
      { };

  teletype = callPackage ../development/python-modules/teletype { };

  telfhash = callPackage ../development/python-modules/telfhash { };

  tellcore-net = callPackage ../development/python-modules/tellcore-net { };

  tellcore-py = callPackage ../development/python-modules/tellcore-py { };

  tellduslive = callPackage ../development/python-modules/tellduslive { };

  temescal = callPackage ../development/python-modules/temescal { };

  temperusb = callPackage ../development/python-modules/temperusb { };

  tempest = callPackage ../development/python-modules/tempest { };

  templateflow = callPackage ../development/python-modules/templateflow { };

  tempman = callPackage ../development/python-modules/tempman { };

  tempora = callPackage ../development/python-modules/tempora { };

  temporalio = callPackage ../development/python-modules/temporalio { };

  tenacity = callPackage ../development/python-modules/tenacity { };

  tenant-schemas-celery = callPackage ../development/python-modules/tenant-schemas-celery { };

  tencentcloud-sdk-python = callPackage ../development/python-modules/tencentcloud-sdk-python { };

  tendo = callPackage ../development/python-modules/tendo { };

  tensorboard = callPackage ../development/python-modules/tensorboard { };

  tensorboard-data-server = callPackage ../development/python-modules/tensorboard-data-server { };

  tensorboard-plugin-profile =
    callPackage ../development/python-modules/tensorboard-plugin-profile
      { };

  tensorboard-plugin-wit = callPackage ../development/python-modules/tensorboard-plugin-wit { };

  tensorboardx = callPackage ../development/python-modules/tensorboardx { };

  tensordict = callPackage ../development/python-modules/tensordict { };

  tensorflow = self.tensorflow-bin;

  tensorflow-bin = callPackage ../development/python-modules/tensorflow/bin.nix {
    inherit (pkgs.config) cudaSupport;
  };

  tensorflow-build =
    let
      compat = rec {
        #protobufTF = pkgs.protobuf_21.override { abseil-cpp = pkgs.abseil-cpp_202301; };
        protobufTF = pkgs.protobuf;
        # https://www.tensorflow.org/install/source#gpu
        #cudaPackagesTF = pkgs.cudaPackages_11;
        cudaPackagesTF = pkgs.cudaPackages;
        grpcTF =
          (pkgs.grpc.overrideAttrs (oldAttrs: rec {
            # nvcc fails on recent grpc versions, so we use the latest patch level
            #  of the grpc version bundled by upstream tensorflow to allow CUDA
            #  support
            version = "1.27.3";
            src = pkgs.fetchFromGitHub {
              owner = "grpc";
              repo = "grpc";
              rev = "v${version}";
              hash = "sha256-PpiOT4ZJe1uMp5j+ReQulC9jpT0xoR2sAl6vRYKA0AA=";
              fetchSubmodules = true;
            };
            patches = [ ];
            postPatch = ''
              sed -i "s/-std=c++11/-std=c++17/" CMakeLists.txt
              echo "set(CMAKE_CXX_STANDARD 17)" >> CMakeLists.txt
            '';
          })).override
            { protobuf = protobufTF; };
        protobuf-pythonTF = self.protobuf4.override { protobuf = protobufTF; };
        grpcioTF = self.grpcio.override { protobuf = protobufTF; };
        tensorboardTF = self.tensorboard.override {
          grpcio = grpcioTF;
          protobuf = protobuf-pythonTF;
        };
      };
    in
    callPackage ../development/python-modules/tensorflow {
      inherit (pkgs.config) cudaSupport;
      flatbuffers-core = pkgs.flatbuffers;
      flatbuffers-python = self.flatbuffers;
      cudaPackages = compat.cudaPackagesTF;
      protobuf-core = compat.protobufTF;
      protobuf-python = compat.protobuf-pythonTF;
      grpc = compat.grpcTF;
      grpcio = compat.grpcioTF;
      tensorboard = compat.tensorboardTF;
      #abseil-cpp = pkgs.abseil-cpp_202301;
      snappy-cpp = pkgs.snappy;

      # Tensorflow 2.13 doesn't support gcc13:
      # https://github.com/tensorflow/tensorflow/issues/61289
      #
      # We use the nixpkgs' default libstdc++ to stay compatible with other
      # python modules
      #stdenv = pkgs.stdenvAdapters.useLibsFrom stdenv pkgs.gcc12Stdenv;
    };

  tensorflow-datasets = callPackage ../development/python-modules/tensorflow-datasets { };

  tensorflow-estimator-bin =
    callPackage ../development/python-modules/tensorflow-estimator/bin.nix
      { };

  tensorflow-metadata = callPackage ../development/python-modules/tensorflow-metadata { };

  tensorflow-probability = callPackage ../development/python-modules/tensorflow-probability { };

  tensorflowWithCuda = self.tensorflow.override { cudaSupport = true; };

  tensorflowWithoutCuda = self.tensorflow.override { cudaSupport = false; };

  tensorly = callPackage ../development/python-modules/tensorly { };

  tensorrt = callPackage ../development/python-modules/tensorrt { };

  tensorstore = callPackage ../development/python-modules/tensorstore { };

  term-image = callPackage ../development/python-modules/term-image { };

  termcolor = callPackage ../development/python-modules/termcolor { };

  termgraph = callPackage ../development/python-modules/termgraph { };

  terminado = callPackage ../development/python-modules/terminado { };

  terminaltables = callPackage ../development/python-modules/terminaltables { };

  terminaltables3 = callPackage ../development/python-modules/terminaltables3 { };

  terminaltexteffects = callPackage ../development/python-modules/terminaltexteffects { };

  termplotlib = callPackage ../development/python-modules/termplotlib { };

  termstyle = callPackage ../development/python-modules/termstyle { };

  tern = callPackage ../development/python-modules/tern { };

  tesla-fleet-api = callPackage ../development/python-modules/tesla-fleet-api { };

  tesla-powerwall = callPackage ../development/python-modules/tesla-powerwall { };

  tesla-wall-connector = callPackage ../development/python-modules/tesla-wall-connector { };

  teslajsonpy = callPackage ../development/python-modules/teslajsonpy { };

  teslemetry-stream = callPackage ../development/python-modules/teslemetry-stream { };

  tess = callPackage ../development/python-modules/tess { };

  tesserocr = callPackage ../development/python-modules/tesserocr { };

  tessie-api = callPackage ../development/python-modules/tessie-api { };

  test-results-parser = callPackage ../development/python-modules/test-results-parser { };

  test-tube = callPackage ../development/python-modules/test-tube { };

  test2ref = callPackage ../development/python-modules/test2ref { };

  testbook = callPackage ../development/python-modules/testbook { };

  testcontainers = callPackage ../development/python-modules/testcontainers { };

  testfixtures = callPackage ../development/python-modules/testfixtures { };

  testing-common-database = callPackage ../development/python-modules/testing-common-database { };

  testpath = callPackage ../development/python-modules/testpath { };

  testrail-api = callPackage ../development/python-modules/testrail-api { };

  testrepository = callPackage ../development/python-modules/testrepository { };

  testresources = callPackage ../development/python-modules/testresources { };

  testscenarios = callPackage ../development/python-modules/testscenarios { };

  testtools = callPackage ../development/python-modules/testtools { };

  texsoup = callPackage ../development/python-modules/texsoup { };

  text-unidecode = callPackage ../development/python-modules/text-unidecode { };

  text2digits = callPackage ../development/python-modules/text2digits { };

  textacy = callPackage ../development/python-modules/textacy { };

  textblob = callPackage ../development/python-modules/textblob { };

  textdistance = callPackage ../development/python-modules/textdistance { };

  textfsm = callPackage ../development/python-modules/textfsm { };

  textile = callPackage ../development/python-modules/textile { };

  textnets = callPackage ../development/python-modules/textnets {
    en_core_web_sm = spacy-models.en_core_web_sm;
  };

  textparser = callPackage ../development/python-modules/textparser { };

  textstat = callPackage ../development/python-modules/textstat { };

  texttable = callPackage ../development/python-modules/texttable { };

  textual = callPackage ../development/python-modules/textual { };

  textual-autocomplete = callPackage ../development/python-modules/textual-autocomplete { };

  textual-dev = callPackage ../development/python-modules/textual-dev { };

  textual-fastdatatable = callPackage ../development/python-modules/textual-fastdatatable { };

  textual-image = callPackage ../development/python-modules/textual-image { };

  textual-serve = callPackage ../development/python-modules/textual-serve { };

  textual-slider = callPackage ../development/python-modules/textual-slider { };

  textual-textarea = callPackage ../development/python-modules/textual-textarea { };

  textual-universal-directorytree =
    callPackage ../development/python-modules/textual-universal-directorytree
      { };

  textualeffects = callPackage ../development/python-modules/textualeffects { };

  textwrap3 = callPackage ../development/python-modules/textwrap3 { };

  textx = callPackage ../development/python-modules/textx { };

  tf-keras = callPackage ../development/python-modules/tf-keras { };

  tf2onnx = callPackage ../development/python-modules/tf2onnx { };

  tflearn = callPackage ../development/python-modules/tflearn { };

  tftpy = callPackage ../development/python-modules/tftpy { };

  tgcrypto = callPackage ../development/python-modules/tgcrypto { };

  thefuzz = callPackage ../development/python-modules/thefuzz { };

  thelogrus = callPackage ../development/python-modules/thelogrus { };

  thermobeacon-ble = callPackage ../development/python-modules/thermobeacon-ble { };

  thermopro-ble = callPackage ../development/python-modules/thermopro-ble { };

  thespian = callPackage ../development/python-modules/thespian { };

  thinc = callPackage ../development/python-modules/thinc { };

  thingspeak = callPackage ../development/python-modules/thingspeak { };

  thinqconnect = callPackage ../development/python-modules/thinqconnect { };

  thorlabspm100 = callPackage ../development/python-modules/thorlabspm100 { };

  threadloop = callPackage ../development/python-modules/threadloop { };

  threadpool = callPackage ../development/python-modules/threadpool { };

  threadpoolctl = callPackage ../development/python-modules/threadpoolctl { };

  threat9-test-bed = callPackage ../development/python-modules/threat9-test-bed { };

  three-merge = callPackage ../development/python-modules/three-merge { };

  thrift = callPackage ../development/python-modules/thrift { };

  thriftpy2 = callPackage ../development/python-modules/thriftpy2 { };

  throttler = callPackage ../development/python-modules/throttler { };

  thttp = callPackage ../development/python-modules/thttp { };

  tianshou = callPackage ../development/python-modules/tianshou { };

  tidalapi = callPackage ../development/python-modules/tidalapi { };

  tidyexc = callPackage ../development/python-modules/tidyexc { };

  tidylib = callPackage ../development/python-modules/pytidylib { };

  tiered-debug = callPackage ../development/python-modules/tiered-debug { };

  tifffile = callPackage ../development/python-modules/tifffile { };

  tika = callPackage ../development/python-modules/tika { };

  tika-client = callPackage ../development/python-modules/tika-client { };

  tikteck = callPackage ../development/python-modules/tikteck { };

  tiktoken = callPackage ../development/python-modules/tiktoken { };

  tiledb = callPackage ../development/python-modules/tiledb { inherit (pkgs) tiledb; };

  tilequant = callPackage ../development/python-modules/tilequant { };

  tiler = callPackage ../development/python-modules/tiler { };

  tilt-ble = callPackage ../development/python-modules/tilt-ble { };

  tilt-pi = callPackage ../development/python-modules/tilt-pi { };

  time-machine = callPackage ../development/python-modules/time-machine { };

  timeago = callPackage ../development/python-modules/timeago { };

  timecop = callPackage ../development/python-modules/timecop { };

  timelength = callPackage ../development/python-modules/timelength { };

  timelib = callPackage ../development/python-modules/timelib { };

  timeout-decorator = callPackage ../development/python-modules/timeout-decorator { };

  timeslot = callPackage ../development/python-modules/timeslot { };

  timetagger = callPackage ../development/python-modules/timetagger { };

  timezonefinder = callPackage ../development/python-modules/timezonefinder { };

  timg = callPackage ../development/python-modules/timg { };

  timing-asgi = callPackage ../development/python-modules/timing-asgi { };

  timm = callPackage ../development/python-modules/timm { };

  timple = callPackage ../development/python-modules/timple { };

  timy = callPackage ../development/python-modules/timy { };

  tiny-cuda-nn = toPythonModule (
    pkgs.tiny-cuda-nn.override {
      cudaPackages = self.torch.cudaPackages;
      python3Packages = self;
      pythonSupport = true;
    }
  );

  tiny-proxy = callPackage ../development/python-modules/tiny-proxy { };

  tinycss = callPackage ../development/python-modules/tinycss { };

  tinycss2 = callPackage ../development/python-modules/tinycss2 { };

  tinydb = callPackage ../development/python-modules/tinydb { };

  tinygrad = callPackage ../development/python-modules/tinygrad { };

  tinyhtml5 = callPackage ../development/python-modules/tinyhtml5 { };

  tinyio = callPackage ../development/python-modules/tinyio { };

  tinyobjloader-py = callPackage ../development/python-modules/tinyobjloader-py { };

  tinyrecord = callPackage ../development/python-modules/tinyrecord { };

  tinysegmenter = callPackage ../development/python-modules/tinysegmenter { };

  tinytag = callPackage ../development/python-modules/tinytag { };

  tinytuya = callPackage ../development/python-modules/tinytuya { };

  tiptapy = callPackage ../development/python-modules/tiptapy { };

  titlecase = callPackage ../development/python-modules/titlecase { };

  tivars = callPackage ../development/python-modules/tivars { };

  tkinter =
    if isPyPy then
      null
    else
      callPackage ../development/python-modules/tkinter {
        # Tcl/Tk 9.0 support in Tkinter is not quite ready yet:
        # - https://github.com/python/cpython/issues/124111
        # - https://github.com/python/cpython/issues/104568
        tcl = pkgs.tcl-8_6;
        tk = pkgs.tk-8_6;
      };

  tkinter-gl = callPackage ../development/python-modules/tkinter-gl { };

  tld = callPackage ../development/python-modules/tld { };

  tldextract = callPackage ../development/python-modules/tldextract { };

  tlds = callPackage ../development/python-modules/tlds { };

  tls-client = callPackage ../development/python-modules/tls-client { };

  tls-parser = callPackage ../development/python-modules/tls-parser { };

  tlsh = callPackage ../development/python-modules/tlsh { };

  tlslite-ng = callPackage ../development/python-modules/tlslite-ng { };

  tlv8 = callPackage ../development/python-modules/tlv8 { };

  tmb = callPackage ../development/python-modules/tmb { };

  tmdbsimple = callPackage ../development/python-modules/tmdbsimple { };

  tnefparse = callPackage ../development/python-modules/tnefparse { };

  todoist = callPackage ../development/python-modules/todoist { };

  todoist-api-python = callPackage ../development/python-modules/todoist-api-python { };

  toggl-cli = callPackage ../development/python-modules/toggl-cli { };

  togrill-bluetooth = callPackage ../development/python-modules/togrill-bluetooth { };

  token-bucket = callPackage ../development/python-modules/token-bucket { };

  tokenize-rt = callPackage ../development/python-modules/tokenize-rt { };

  tokenizers = callPackage ../development/python-modules/tokenizers { };

  tokenlib = callPackage ../development/python-modules/tokenlib { };

  tokentrim = callPackage ../development/python-modules/tokentrim { };

  tololib = callPackage ../development/python-modules/tololib { };

  toml = callPackage ../development/python-modules/toml { };

  toml-adapt = callPackage ../development/python-modules/toml-adapt { };

  tomli = callPackage ../development/python-modules/tomli { };

  tomli-w = callPackage ../development/python-modules/tomli-w { };

  tomlkit = callPackage ../development/python-modules/tomlkit { };

  toolz = callPackage ../development/python-modules/toolz { };

  toonapi = callPackage ../development/python-modules/toonapi { };

  toposort = callPackage ../development/python-modules/toposort { };

  toptica-lasersdk = callPackage ../development/python-modules/toptica-lasersdk { };

  torch = callPackage ../development/python-modules/torch/source { };

  torch-audiomentations = callPackage ../development/python-modules/torch-audiomentations { };

  torch-bin = callPackage ../development/python-modules/torch/bin { triton = self.triton-bin; };

  torch-geometric = callPackage ../development/python-modules/torch-geometric { };

  # Required to test triton
  torch-no-triton = self.torch.override { tritonSupport = false; };

  torch-pitch-shift = callPackage ../development/python-modules/torch-pitch-shift { };

  torch-tb-profiler = callPackage ../development/python-modules/torch-tb-profiler/default.nix { };

  torchWithCuda = self.torch.override {
    triton = self.triton-cuda;
    cudaSupport = true;
    rocmSupport = false;
  };

  torchWithRocm = self.torch.override {
    triton = self.triton-no-cuda;
    rocmSupport = true;
    cudaSupport = false;
  };

  torchWithVulkan = self.torch.override { vulkanSupport = true; };

  torchWithoutCuda = self.torch.override { cudaSupport = false; };

  torchWithoutRocm = self.torch.override { rocmSupport = false; };

  torchao = callPackage ../development/python-modules/torchao { };

  torchaudio = callPackage ../development/python-modules/torchaudio { };

  torchaudio-bin = callPackage ../development/python-modules/torchaudio/bin.nix { };

  torchbench = callPackage ../development/python-modules/torchbench { };

  torchcodec = callPackage ../development/python-modules/torchcodec { };

  torchcrepe = callPackage ../development/python-modules/torchcrepe { };

  torchdata = callPackage ../development/python-modules/torchdata { };

  torchdiffeq = callPackage ../development/python-modules/torchdiffeq { };

  torcheval = callPackage ../development/python-modules/torcheval { };

  torchinfo = callPackage ../development/python-modules/torchinfo { };

  torchio = callPackage ../development/python-modules/torchio { };

  torchlibrosa = callPackage ../development/python-modules/torchlibrosa { };

  torchmetrics = callPackage ../development/python-modules/torchmetrics { };

  torchprofile = callPackage ../development/python-modules/torchprofile { };

  torchrl = callPackage ../development/python-modules/torchrl { };

  torchsde = callPackage ../development/python-modules/torchsde { };

  torchsnapshot = callPackage ../development/python-modules/torchsnapshot { };

  torchsummary = callPackage ../development/python-modules/torchsummary { };

  torchtnt = callPackage ../development/python-modules/torchtnt { };

  torchtune = callPackage ../development/python-modules/torchtune { };

  torchvision = callPackage ../development/python-modules/torchvision { };

  torchvision-bin = callPackage ../development/python-modules/torchvision/bin.nix { };

  torf = callPackage ../development/python-modules/torf { };

  tornado = callPackage ../development/python-modules/tornado { };

  torpy = callPackage ../development/python-modules/torpy { };

  torrent-parser = callPackage ../development/python-modules/torrent-parser { };

  torrequest = callPackage ../development/python-modules/torrequest { };

  total-connect-client = callPackage ../development/python-modules/total-connect-client { };

  touying = callPackage ../development/python-modules/touying { };

  towncrier = callPackage ../development/python-modules/towncrier { inherit (pkgs) git; };

  tox = callPackage ../development/python-modules/tox { };

  tplink-omada-client = callPackage ../development/python-modules/tplink-omada-client { };

  tpm2-pytss = callPackage ../development/python-modules/tpm2-pytss { };

  tqdm = callPackage ../development/python-modules/tqdm { };

  tqdm-multiprocess = callPackage ../development/python-modules/tqdm-multiprocess { };

  traceback2 = callPackage ../development/python-modules/traceback2 { };

  tracerite = callPackage ../development/python-modules/tracerite { };

  tracing = callPackage ../development/python-modules/tracing { };

  trackpy = callPackage ../development/python-modules/trackpy { };

  trafilatura = callPackage ../development/python-modules/trafilatura { };

  trailrunner = callPackage ../development/python-modules/trailrunner { };

  trainer = callPackage ../development/python-modules/trainer { };

  traitlets = callPackage ../development/python-modules/traitlets { };

  traits = callPackage ../development/python-modules/traits { };

  traitsui = callPackage ../development/python-modules/traitsui { };

  traittypes = callPackage ../development/python-modules/traittypes { };

  trakit = callPackage ../development/python-modules/trakit { };

  trampoline = callPackage ../development/python-modules/trampoline { };

  transaction = callPackage ../development/python-modules/transaction { };

  transformers = callPackage ../development/python-modules/transformers { };

  transforms3d = callPackage ../development/python-modules/transforms3d { };

  transitions = callPackage ../development/python-modules/transitions { };

  translate-toolkit = callPackage ../development/python-modules/translate-toolkit { };

  translatehtml = callPackage ../development/python-modules/translatehtml { };

  translatepy = callPackage ../development/python-modules/translatepy { };

  translation-finder = callPackage ../development/python-modules/translation-finder { };

  translationstring = callPackage ../development/python-modules/translationstring { };

  translitcodec = callPackage ../development/python-modules/translitcodec { };

  transmission-rpc = callPackage ../development/python-modules/transmission-rpc { };

  travispy = callPackage ../development/python-modules/travispy { };

  trectools = callPackage ../development/python-modules/trectools { };

  tree-sitter = callPackage ../development/python-modules/tree-sitter { };

  tree-sitter-c-sharp = callPackage ../development/python-modules/tree-sitter-c-sharp { };

  tree-sitter-embedded-template =
    callPackage ../development/python-modules/tree-sitter-embedded-template
      { };

  tree-sitter-grammars = lib.recurseIntoAttrs (
    lib.mapAttrs
      (
        name: grammarDrv:
        callPackage ../development/python-modules/tree-sitter-grammars { inherit name grammarDrv; }
      )
      (
        # Filtering grammars not compatible with current py-tree-sitter version
        lib.filterAttrs (
          name: value:
          !(builtins.elem name [
            "tree-sitter-go-template"
            "tree-sitter-sql"
            "tree-sitter-templ"
          ])
        ) pkgs.tree-sitter.builtGrammars
      )
  );

  tree-sitter-html = callPackage ../development/python-modules/tree-sitter-html { };

  tree-sitter-javascript = callPackage ../development/python-modules/tree-sitter-javascript { };

  tree-sitter-json = callPackage ../development/python-modules/tree-sitter-json { };

  tree-sitter-language-pack = callPackage ../development/python-modules/tree-sitter-language-pack { };

  tree-sitter-languages = callPackage ../development/python-modules/tree-sitter-languages { };

  tree-sitter-make = callPackage ../development/python-modules/tree-sitter-make { };

  tree-sitter-markdown = callPackage ../development/python-modules/tree-sitter-markdown { };

  tree-sitter-python = callPackage ../development/python-modules/tree-sitter-python { };

  tree-sitter-rust = callPackage ../development/python-modules/tree-sitter-rust { };

  tree-sitter-sql = callPackage ../development/python-modules/tree-sitter-sql { };

  tree-sitter-yaml = callPackage ../development/python-modules/tree-sitter-yaml { };

  tree-sitter-zeek = callPackage ../development/python-modules/tree-sitter-zeek { };

  treelib = callPackage ../development/python-modules/treelib { };

  treelog = callPackage ../development/python-modules/treelog { };

  treescope = callPackage ../development/python-modules/treescope { };

  treq = callPackage ../development/python-modules/treq { };

  trevorproxy = callPackage ../development/python-modules/trevorproxy { };

  trezor = callPackage ../development/python-modules/trezor { };

  trezor-agent = callPackage ../development/python-modules/trezor-agent {
    pinentry = pkgs.pinentry-curses;
  };

  trie = callPackage ../development/python-modules/trie { };

  triggercmd = callPackage ../development/python-modules/triggercmd { };

  trimesh = callPackage ../development/python-modules/trimesh { };

  trino-python-client = callPackage ../development/python-modules/trino-python-client { };

  trio = callPackage ../development/python-modules/trio { };

  trio-asyncio = callPackage ../development/python-modules/trio-asyncio { };

  trio-typing = callPackage ../development/python-modules/trio-typing { };

  trio-websocket = callPackage ../development/python-modules/trio-websocket { };

  triton = callPackage ../development/python-modules/triton { llvm = pkgs.triton-llvm; };

  triton-bin = callPackage ../development/python-modules/triton/bin.nix { };

  triton-cuda = self.triton.override { cudaSupport = true; };

  triton-no-cuda = self.triton.override { cudaSupport = false; };

  tritonclient = callPackage ../development/python-modules/tritonclient { };

  trl = callPackage ../development/python-modules/trl { };

  trlib = toPythonModule (
    pkgs.trlib.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  troi = callPackage ../development/python-modules/troi { };

  troposphere = callPackage ../development/python-modules/troposphere { };

  trove-classifiers = callPackage ../development/python-modules/trove-classifiers { };

  trubar = callPackage ../development/python-modules/trubar { };

  trueskill = callPackage ../development/python-modules/trueskill { };

  truncnorm = callPackage ../development/python-modules/truncnorm { };

  trustme = callPackage ../development/python-modules/trustme { };

  truststore = callPackage ../development/python-modules/truststore { };

  trx-python = callPackage ../development/python-modules/trx-python { };

  trytond = callPackage ../development/python-modules/trytond { };

  ts1-signatures = callPackage ../development/python-modules/ts1-signatures { };

  tsfresh = callPackage ../development/python-modules/tsfresh { };

  tsid = callPackage ../development/python-modules/tsid { inherit (pkgs) tsid; };

  tskit = callPackage ../development/python-modules/tskit { };

  tsplib95 = callPackage ../development/python-modules/tsplib95 { };

  tt-flash = callPackage ../development/python-modules/tt-flash { };

  tt-tools-common = callPackage ../development/python-modules/tt-tools-common { };

  ttach = callPackage ../development/python-modules/ttach { };

  ttfautohint-py = callPackage ../development/python-modules/ttfautohint-py { };

  ttkbootstrap = callPackage ../development/python-modules/ttkbootstrap { };

  ttls = callPackage ../development/python-modules/ttls { };

  ttn-client = callPackage ../development/python-modules/ttn-client { };

  ttp = callPackage ../development/python-modules/ttp { };

  ttp-templates = callPackage ../development/python-modules/ttp-templates { };

  ttstokenizer = callPackage ../development/python-modules/ttstokenizer { };

  tubes = callPackage ../development/python-modules/tubes { };

  tubeup = callPackage ../development/python-modules/tubeup { };

  tuf = callPackage ../development/python-modules/tuf { };

  tunigo = callPackage ../development/python-modules/tunigo { };

  turnt = callPackage ../development/python-modules/turnt { };

  turrishw = callPackage ../development/python-modules/turrishw { };

  tuya-device-sharing-sdk = callPackage ../development/python-modules/tuya-device-sharing-sdk { };

  tuya-iot-py-sdk = callPackage ../development/python-modules/tuya-iot-py-sdk { };

  tuyaha = callPackage ../development/python-modules/tuyaha { };

  tvdb-api = callPackage ../development/python-modules/tvdb-api { };

  tweepy = callPackage ../development/python-modules/tweepy { };

  twentemilieu = callPackage ../development/python-modules/twentemilieu { };

  twiggy = callPackage ../development/python-modules/twiggy { };

  twilio = callPackage ../development/python-modules/twilio { };

  twill = callPackage ../development/python-modules/twill { };

  twine = callPackage ../development/python-modules/twine { };

  twinkly-client = callPackage ../development/python-modules/twinkly-client { };

  twisted = callPackage ../development/python-modules/twisted { };

  twitch-python = callPackage ../development/python-modules/twitch-python { };

  twitchapi = callPackage ../development/python-modules/twitchapi { };

  twitter = callPackage ../development/python-modules/twitter { };

  twitterapi = callPackage ../development/python-modules/twitterapi { };

  twofish = callPackage ../development/python-modules/twofish { };

  twomemo = callPackage ../development/python-modules/twomemo { };

  twscrape = callPackage ../development/python-modules/twscrape { };

  txaio = callPackage ../development/python-modules/txaio { };

  txamqp = callPackage ../development/python-modules/txamqp { };

  txdbus = callPackage ../development/python-modules/txdbus { };

  txgithub = callPackage ../development/python-modules/txgithub { };

  txi2p-tahoe = callPackage ../development/python-modules/txi2p-tahoe { };

  txredisapi = callPackage ../development/python-modules/txredisapi { };

  txrequests = callPackage ../development/python-modules/txrequests { };

  txtai = callPackage ../development/python-modules/txtai { sqlite-vec-c = pkgs.sqlite-vec; };

  txtorcon = callPackage ../development/python-modules/txtorcon { };

  txzmq = callPackage ../development/python-modules/txzmq { };

  type-infer = callPackage ../development/python-modules/type-infer { };

  typechecks = callPackage ../development/python-modules/typechecks { };

  typecode = callPackage ../development/python-modules/typecode { };

  typecode-libmagic = callPackage ../development/python-modules/typecode/libmagic.nix {
    inherit (pkgs) file zlib;
  };

  typed-settings = callPackage ../development/python-modules/typed-settings { };

  typedmonarchmoney = callPackage ../development/python-modules/typedmonarchmoney { };

  typedunits = callPackage ../development/python-modules/typedunits { };

  typeguard = callPackage ../development/python-modules/typeguard { };

  typepy = callPackage ../development/python-modules/typepy { };

  typer = callPackage ../development/python-modules/typer { };

  typer-shell = callPackage ../development/python-modules/typer-shell { };

  typer-slim = self.typer.override { package = "typer-slim"; };

  types-aiobotocore = callPackage ../development/python-modules/types-aiobotocore { };

  inherit (callPackage ../development/python-modules/types-aiobotocore-packages { })
    types-aiobotocore-accessanalyzer
    types-aiobotocore-account
    types-aiobotocore-acm
    types-aiobotocore-acm-pca
    types-aiobotocore-alexaforbusiness
    types-aiobotocore-amp
    types-aiobotocore-amplify
    types-aiobotocore-amplifybackend
    types-aiobotocore-amplifyuibuilder
    types-aiobotocore-apigateway
    types-aiobotocore-apigatewaymanagementapi
    types-aiobotocore-apigatewayv2
    types-aiobotocore-appconfig
    types-aiobotocore-appconfigdata
    types-aiobotocore-appfabric
    types-aiobotocore-appflow
    types-aiobotocore-appintegrations
    types-aiobotocore-application-autoscaling
    types-aiobotocore-application-insights
    types-aiobotocore-applicationcostprofiler
    types-aiobotocore-appmesh
    types-aiobotocore-apprunner
    types-aiobotocore-appstream
    types-aiobotocore-appsync
    types-aiobotocore-arc-zonal-shift
    types-aiobotocore-athena
    types-aiobotocore-auditmanager
    types-aiobotocore-autoscaling
    types-aiobotocore-autoscaling-plans
    types-aiobotocore-backup
    types-aiobotocore-backup-gateway
    types-aiobotocore-backupstorage
    types-aiobotocore-batch
    types-aiobotocore-billingconductor
    types-aiobotocore-braket
    types-aiobotocore-budgets
    types-aiobotocore-ce
    types-aiobotocore-chime
    types-aiobotocore-chime-sdk-identity
    types-aiobotocore-chime-sdk-media-pipelines
    types-aiobotocore-chime-sdk-meetings
    types-aiobotocore-chime-sdk-messaging
    types-aiobotocore-chime-sdk-voice
    types-aiobotocore-cleanrooms
    types-aiobotocore-cloud9
    types-aiobotocore-cloudcontrol
    types-aiobotocore-clouddirectory
    types-aiobotocore-cloudformation
    types-aiobotocore-cloudfront
    types-aiobotocore-cloudhsm
    types-aiobotocore-cloudhsmv2
    types-aiobotocore-cloudsearch
    types-aiobotocore-cloudsearchdomain
    types-aiobotocore-cloudtrail
    types-aiobotocore-cloudtrail-data
    types-aiobotocore-cloudwatch
    types-aiobotocore-codeartifact
    types-aiobotocore-codebuild
    types-aiobotocore-codecatalyst
    types-aiobotocore-codecommit
    types-aiobotocore-codedeploy
    types-aiobotocore-codeguru-reviewer
    types-aiobotocore-codeguru-security
    types-aiobotocore-codeguruprofiler
    types-aiobotocore-codepipeline
    types-aiobotocore-codestar
    types-aiobotocore-codestar-connections
    types-aiobotocore-codestar-notifications
    types-aiobotocore-cognito-identity
    types-aiobotocore-cognito-idp
    types-aiobotocore-cognito-sync
    types-aiobotocore-comprehend
    types-aiobotocore-comprehendmedical
    types-aiobotocore-compute-optimizer
    types-aiobotocore-config
    types-aiobotocore-connect
    types-aiobotocore-connect-contact-lens
    types-aiobotocore-connectcampaigns
    types-aiobotocore-connectcases
    types-aiobotocore-connectparticipant
    types-aiobotocore-controltower
    types-aiobotocore-cur
    types-aiobotocore-customer-profiles
    types-aiobotocore-databrew
    types-aiobotocore-dataexchange
    types-aiobotocore-datapipeline
    types-aiobotocore-datasync
    types-aiobotocore-dax
    types-aiobotocore-detective
    types-aiobotocore-devicefarm
    types-aiobotocore-devops-guru
    types-aiobotocore-directconnect
    types-aiobotocore-discovery
    types-aiobotocore-dlm
    types-aiobotocore-dms
    types-aiobotocore-docdb
    types-aiobotocore-docdb-elastic
    types-aiobotocore-drs
    types-aiobotocore-ds
    types-aiobotocore-dynamodb
    types-aiobotocore-dynamodbstreams
    types-aiobotocore-ebs
    types-aiobotocore-ec2
    types-aiobotocore-ec2-instance-connect
    types-aiobotocore-ecr
    types-aiobotocore-ecr-public
    types-aiobotocore-ecs
    types-aiobotocore-efs
    types-aiobotocore-eks
    types-aiobotocore-elastic-inference
    types-aiobotocore-elasticache
    types-aiobotocore-elasticbeanstalk
    types-aiobotocore-elastictranscoder
    types-aiobotocore-elb
    types-aiobotocore-elbv2
    types-aiobotocore-emr
    types-aiobotocore-emr-containers
    types-aiobotocore-emr-serverless
    types-aiobotocore-entityresolution
    types-aiobotocore-es
    types-aiobotocore-events
    types-aiobotocore-evidently
    types-aiobotocore-finspace
    types-aiobotocore-finspace-data
    types-aiobotocore-firehose
    types-aiobotocore-fis
    types-aiobotocore-fms
    types-aiobotocore-forecast
    types-aiobotocore-forecastquery
    types-aiobotocore-frauddetector
    types-aiobotocore-fsx
    types-aiobotocore-gamelift
    types-aiobotocore-gamesparks
    types-aiobotocore-glacier
    types-aiobotocore-globalaccelerator
    types-aiobotocore-glue
    types-aiobotocore-grafana
    types-aiobotocore-greengrass
    types-aiobotocore-greengrassv2
    types-aiobotocore-groundstation
    types-aiobotocore-guardduty
    types-aiobotocore-health
    types-aiobotocore-healthlake
    types-aiobotocore-honeycode
    types-aiobotocore-iam
    types-aiobotocore-identitystore
    types-aiobotocore-imagebuilder
    types-aiobotocore-importexport
    types-aiobotocore-inspector
    types-aiobotocore-inspector2
    types-aiobotocore-internetmonitor
    types-aiobotocore-iot
    types-aiobotocore-iot-data
    types-aiobotocore-iot-jobs-data
    types-aiobotocore-iot-roborunner
    types-aiobotocore-iot1click-devices
    types-aiobotocore-iot1click-projects
    types-aiobotocore-iotanalytics
    types-aiobotocore-iotdeviceadvisor
    types-aiobotocore-iotevents
    types-aiobotocore-iotevents-data
    types-aiobotocore-iotfleethub
    types-aiobotocore-iotfleetwise
    types-aiobotocore-iotsecuretunneling
    types-aiobotocore-iotsitewise
    types-aiobotocore-iotthingsgraph
    types-aiobotocore-iottwinmaker
    types-aiobotocore-iotwireless
    types-aiobotocore-ivs
    types-aiobotocore-ivs-realtime
    types-aiobotocore-ivschat
    types-aiobotocore-kafka
    types-aiobotocore-kafkaconnect
    types-aiobotocore-kendra
    types-aiobotocore-kendra-ranking
    types-aiobotocore-keyspaces
    types-aiobotocore-kinesis
    types-aiobotocore-kinesis-video-archived-media
    types-aiobotocore-kinesis-video-media
    types-aiobotocore-kinesis-video-signaling
    types-aiobotocore-kinesis-video-webrtc-storage
    types-aiobotocore-kinesisanalytics
    types-aiobotocore-kinesisanalyticsv2
    types-aiobotocore-kinesisvideo
    types-aiobotocore-kms
    types-aiobotocore-lakeformation
    types-aiobotocore-lambda
    types-aiobotocore-lex-models
    types-aiobotocore-lex-runtime
    types-aiobotocore-lexv2-models
    types-aiobotocore-lexv2-runtime
    types-aiobotocore-license-manager
    types-aiobotocore-license-manager-linux-subscriptions
    types-aiobotocore-license-manager-user-subscriptions
    types-aiobotocore-lightsail
    types-aiobotocore-location
    types-aiobotocore-logs
    types-aiobotocore-lookoutequipment
    types-aiobotocore-lookoutmetrics
    types-aiobotocore-lookoutvision
    types-aiobotocore-m2
    types-aiobotocore-machinelearning
    types-aiobotocore-macie
    types-aiobotocore-macie2
    types-aiobotocore-managedblockchain
    types-aiobotocore-managedblockchain-query
    types-aiobotocore-marketplace-catalog
    types-aiobotocore-marketplace-entitlement
    types-aiobotocore-marketplacecommerceanalytics
    types-aiobotocore-mediaconnect
    types-aiobotocore-mediaconvert
    types-aiobotocore-medialive
    types-aiobotocore-mediapackage
    types-aiobotocore-mediapackage-vod
    types-aiobotocore-mediapackagev2
    types-aiobotocore-mediastore
    types-aiobotocore-mediastore-data
    types-aiobotocore-mediatailor
    types-aiobotocore-medical-imaging
    types-aiobotocore-memorydb
    types-aiobotocore-meteringmarketplace
    types-aiobotocore-mgh
    types-aiobotocore-mgn
    types-aiobotocore-migration-hub-refactor-spaces
    types-aiobotocore-migrationhub-config
    types-aiobotocore-migrationhuborchestrator
    types-aiobotocore-migrationhubstrategy
    types-aiobotocore-mobile
    types-aiobotocore-mq
    types-aiobotocore-mturk
    types-aiobotocore-mwaa
    types-aiobotocore-neptune
    types-aiobotocore-network-firewall
    types-aiobotocore-networkmanager
    types-aiobotocore-nimble
    types-aiobotocore-oam
    types-aiobotocore-omics
    types-aiobotocore-opensearch
    types-aiobotocore-opensearchserverless
    types-aiobotocore-opsworks
    types-aiobotocore-opsworkscm
    types-aiobotocore-organizations
    types-aiobotocore-osis
    types-aiobotocore-outposts
    types-aiobotocore-panorama
    types-aiobotocore-payment-cryptography
    types-aiobotocore-payment-cryptography-data
    types-aiobotocore-personalize
    types-aiobotocore-personalize-events
    types-aiobotocore-personalize-runtime
    types-aiobotocore-pi
    types-aiobotocore-pinpoint
    types-aiobotocore-pinpoint-email
    types-aiobotocore-pinpoint-sms-voice
    types-aiobotocore-pinpoint-sms-voice-v2
    types-aiobotocore-pipes
    types-aiobotocore-polly
    types-aiobotocore-pricing
    types-aiobotocore-privatenetworks
    types-aiobotocore-proton
    types-aiobotocore-qldb
    types-aiobotocore-qldb-session
    types-aiobotocore-quicksight
    types-aiobotocore-ram
    types-aiobotocore-rbin
    types-aiobotocore-rds
    types-aiobotocore-rds-data
    types-aiobotocore-redshift
    types-aiobotocore-redshift-data
    types-aiobotocore-redshift-serverless
    types-aiobotocore-rekognition
    types-aiobotocore-resiliencehub
    types-aiobotocore-resource-explorer-2
    types-aiobotocore-resource-groups
    types-aiobotocore-resourcegroupstaggingapi
    types-aiobotocore-robomaker
    types-aiobotocore-rolesanywhere
    types-aiobotocore-route53
    types-aiobotocore-route53-recovery-cluster
    types-aiobotocore-route53-recovery-control-config
    types-aiobotocore-route53-recovery-readiness
    types-aiobotocore-route53domains
    types-aiobotocore-route53resolver
    types-aiobotocore-rum
    types-aiobotocore-s3
    types-aiobotocore-s3control
    types-aiobotocore-s3outposts
    types-aiobotocore-sagemaker
    types-aiobotocore-sagemaker-a2i-runtime
    types-aiobotocore-sagemaker-edge
    types-aiobotocore-sagemaker-featurestore-runtime
    types-aiobotocore-sagemaker-geospatial
    types-aiobotocore-sagemaker-metrics
    types-aiobotocore-sagemaker-runtime
    types-aiobotocore-savingsplans
    types-aiobotocore-scheduler
    types-aiobotocore-schemas
    types-aiobotocore-sdb
    types-aiobotocore-secretsmanager
    types-aiobotocore-securityhub
    types-aiobotocore-securitylake
    types-aiobotocore-serverlessrepo
    types-aiobotocore-service-quotas
    types-aiobotocore-servicecatalog
    types-aiobotocore-servicecatalog-appregistry
    types-aiobotocore-servicediscovery
    types-aiobotocore-ses
    types-aiobotocore-sesv2
    types-aiobotocore-shield
    types-aiobotocore-signer
    types-aiobotocore-simspaceweaver
    types-aiobotocore-sms
    types-aiobotocore-sms-voice
    types-aiobotocore-snow-device-management
    types-aiobotocore-snowball
    types-aiobotocore-sns
    types-aiobotocore-sqs
    types-aiobotocore-ssm
    types-aiobotocore-ssm-contacts
    types-aiobotocore-ssm-incidents
    types-aiobotocore-ssm-sap
    types-aiobotocore-sso
    types-aiobotocore-sso-admin
    types-aiobotocore-sso-oidc
    types-aiobotocore-stepfunctions
    types-aiobotocore-storagegateway
    types-aiobotocore-sts
    types-aiobotocore-support
    types-aiobotocore-support-app
    types-aiobotocore-swf
    types-aiobotocore-synthetics
    types-aiobotocore-textract
    types-aiobotocore-timestream-query
    types-aiobotocore-timestream-write
    types-aiobotocore-tnb
    types-aiobotocore-transcribe
    types-aiobotocore-transfer
    types-aiobotocore-translate
    types-aiobotocore-verifiedpermissions
    types-aiobotocore-voice-id
    types-aiobotocore-vpc-lattice
    types-aiobotocore-waf
    types-aiobotocore-waf-regional
    types-aiobotocore-wafv2
    types-aiobotocore-wellarchitected
    types-aiobotocore-wisdom
    types-aiobotocore-workdocs
    types-aiobotocore-worklink
    types-aiobotocore-workmail
    types-aiobotocore-workmailmessageflow
    types-aiobotocore-workspaces
    types-aiobotocore-workspaces-web
    types-aiobotocore-xray
    ;

  types-appdirs = callPackage ../development/python-modules/types-appdirs { };

  types-awscrt = callPackage ../development/python-modules/types-awscrt { };

  types-beautifulsoup4 = callPackage ../development/python-modules/types-beautifulsoup4 { };

  types-click = callPackage ../development/python-modules/types-click { };

  types-colorama = callPackage ../development/python-modules/types-colorama { };

  types-dataclasses = callPackage ../development/python-modules/types-dataclasses { };

  types-dateutil = callPackage ../development/python-modules/types-dateutil { };

  types-decorator = callPackage ../development/python-modules/types-decorator { };

  types-deprecated = callPackage ../development/python-modules/types-deprecated { };

  types-docopt = callPackage ../development/python-modules/types-docopt { };

  types-docutils = callPackage ../development/python-modules/types-docutils { };

  types-freezegun = callPackage ../development/python-modules/types-freezegun { };

  types-futures = callPackage ../development/python-modules/types-futures { };

  types-greenlet = callPackage ../development/python-modules/types-greenlet { };

  types-html5lib = callPackage ../development/python-modules/types-html5lib { };

  types-ipaddress = callPackage ../development/python-modules/types-ipaddress { };

  types-jinja2 = callPackage ../development/python-modules/types-jinja2 { };

  types-lxml = callPackage ../development/python-modules/types-lxml { };

  types-markdown = callPackage ../development/python-modules/types-markdown { };

  types-markupsafe = callPackage ../development/python-modules/types-markupsafe { };

  types-mock = callPackage ../development/python-modules/types-mock { };

  types-mysqlclient = callPackage ../development/python-modules/types-mysqlclient { };

  types-pillow = callPackage ../development/python-modules/types-pillow { };

  types-protobuf = callPackage ../development/python-modules/types-protobuf { };

  types-psutil = callPackage ../development/python-modules/types-psutil { };

  types-psycopg2 = callPackage ../development/python-modules/types-psycopg2 { };

  types-pyopenssl = callPackage ../development/python-modules/types-pyopenssl { };

  types-python-dateutil = callPackage ../development/python-modules/types-python-dateutil { };

  types-pytz = callPackage ../development/python-modules/types-pytz { };

  types-pyyaml = callPackage ../development/python-modules/types-pyyaml { };

  types-redis = callPackage ../development/python-modules/types-redis { };

  types-regex = callPackage ../development/python-modules/types-regex { };

  types-requests = callPackage ../development/python-modules/types-requests { };

  types-retry = callPackage ../development/python-modules/types-retry { };

  types-s3transfer = callPackage ../development/python-modules/types-s3transfer { };

  types-setuptools = callPackage ../development/python-modules/types-setuptools { };

  types-six = callPackage ../development/python-modules/types-six { };

  types-tabulate = callPackage ../development/python-modules/types-tabulate { };

  types-toml = callPackage ../development/python-modules/types-toml { };

  types-tqdm = callPackage ../development/python-modules/types-tqdm { };

  types-ujson = callPackage ../development/python-modules/types-ujson { };

  types-urllib3 = callPackage ../development/python-modules/types-urllib3 { };

  types-webencodings = callPackage ../development/python-modules/types-webencodings { };

  types-xxhash = callPackage ../development/python-modules/types-xxhash { };

  typesense = callPackage ../development/python-modules/typesense {
    inherit (pkgs) typesense curl;
  };

  typesentry = callPackage ../development/python-modules/typesentry { };

  typeshed-client = callPackage ../development/python-modules/typeshed-client { };

  typesystem = callPackage ../development/python-modules/typesystem { };

  typical = callPackage ../development/python-modules/typical { };

  typing = null;

  typing-extensions = callPackage ../development/python-modules/typing-extensions { };

  typing-inspect = callPackage ../development/python-modules/typing-inspect { };

  typing-inspection = callPackage ../development/python-modules/typing-inspection { };

  typing-utils = callPackage ../development/python-modules/typing-utils { };

  typing-validation = callPackage ../development/python-modules/typing-validation { };

  typish = callPackage ../development/python-modules/typish { };

  typogrify = callPackage ../development/python-modules/typogrify { };

  typst = callPackage ../development/python-modules/typst { };

  tyro = callPackage ../development/python-modules/tyro { };

  tzdata = callPackage ../development/python-modules/tzdata { };

  tzlocal = callPackage ../development/python-modules/tzlocal { };

  u-msgpack-python = callPackage ../development/python-modules/u-msgpack-python { };

  ua-parser = callPackage ../development/python-modules/ua-parser { };

  ua-parser-builtins = callPackage ../development/python-modules/ua-parser-builtins { };

  ua-parser-rs = callPackage ../development/python-modules/ua-parser-rs { };

  uarray = callPackage ../development/python-modules/uarray { };

  uart-devices = callPackage ../development/python-modules/uart-devices { };

  uasiren = callPackage ../development/python-modules/uasiren { };

  ubelt = callPackage ../development/python-modules/ubelt { };

  uc-micro-py = callPackage ../development/python-modules/uc-micro-py { };

  ucsmsdk = callPackage ../development/python-modules/ucsmsdk { };

  udatetime = callPackage ../development/python-modules/udatetime { };

  ueagle = callPackage ../development/python-modules/ueagle { };

  ueberzug = callPackage ../development/python-modules/ueberzug {
    inherit (pkgs.xorg) libX11 libXext;
  };

  ufal-chu-liu-edmonds = callPackage ../development/python-modules/ufal-chu-liu-edmonds { };

  ufmt = callPackage ../development/python-modules/ufmt { };

  ufo2ft = callPackage ../development/python-modules/ufo2ft { };

  ufolib2 = callPackage ../development/python-modules/ufolib2 { };

  ufolint = callPackage ../development/python-modules/ufolint { };

  ufomerge = callPackage ../development/python-modules/ufomerge { };

  ufonormalizer = callPackage ../development/python-modules/ufonormalizer { };

  ufoprocessor = callPackage ../development/python-modules/ufoprocessor { };

  uharfbuzz = callPackage ../development/python-modules/uharfbuzz { };

  uhashring = callPackage ../development/python-modules/uhashring { };

  uhi = callPackage ../development/python-modules/uhi { };

  uiprotect = callPackage ../development/python-modules/uiprotect { };

  ujson = callPackage ../development/python-modules/ujson { };

  ukkonen = callPackage ../development/python-modules/ukkonen { };

  ukpostcodeparser = callPackage ../development/python-modules/ukpostcodeparser { };

  ulid-transform = callPackage ../development/python-modules/ulid-transform { };

  ultraheat-api = callPackage ../development/python-modules/ultraheat-api { };

  ultralytics = callPackage ../development/python-modules/ultralytics { };

  ultralytics-thop = callPackage ../development/python-modules/ultralytics-thop { };

  umalqurra = callPackage ../development/python-modules/umalqurra { };

  umap-learn = callPackage ../development/python-modules/umap-learn { };

  umodbus = callPackage ../development/python-modules/umodbus { };

  unasync = callPackage ../development/python-modules/unasync { };

  uncertainties = callPackage ../development/python-modules/uncertainties { };

  uncompresspy = callPackage ../development/python-modules/uncompresspy { };

  uncompyle6 = callPackage ../development/python-modules/uncompyle6 { };

  undefined = callPackage ../development/python-modules/undefined { };

  undetected-chromedriver = callPackage ../development/python-modules/undetected-chromedriver { };

  unearth = callPackage ../development/python-modules/unearth { };

  unicode-rbnf = callPackage ../development/python-modules/unicode-rbnf { };

  unicodecsv = callPackage ../development/python-modules/unicodecsv { };

  unicodedata2 = callPackage ../development/python-modules/unicodedata2 { };

  unicodeit = callPackage ../development/python-modules/unicodeit { };

  unicorn = callPackage ../development/python-modules/unicorn { inherit (pkgs) unicorn; };

  unicorn-angr = callPackage ../development/python-modules/unicorn-angr {
    inherit (pkgs) unicorn-angr;
  };

  unicrypto = callPackage ../development/python-modules/unicrypto { };

  unicurses = callPackage ../development/python-modules/unicurses { };

  unidata-blocks = callPackage ../development/python-modules/unidata-blocks { };

  unidecode = callPackage ../development/python-modules/unidecode { };

  unidic = callPackage ../development/python-modules/unidic { };

  unidic-lite = callPackage ../development/python-modules/unidic-lite { };

  unidiff = callPackage ../development/python-modules/unidiff { };

  unidns = callPackage ../development/python-modules/unidns { };

  unifi-ap = callPackage ../development/python-modules/unifi-ap { };

  unifi-discovery = callPackage ../development/python-modules/unifi-discovery { };

  unifiled = callPackage ../development/python-modules/unifiled { };

  unify = callPackage ../development/python-modules/unify { };

  unique-log-filter = callPackage ../development/python-modules/unique-log-filter { };

  units-llnl = callPackage ../development/python-modules/units-llnl {
    inherit (pkgs) units-llnl;
  };

  unittest-data-provider = callPackage ../development/python-modules/unittest-data-provider { };

  unittest-xml-reporting = callPackage ../development/python-modules/unittest-xml-reporting { };

  univers = callPackage ../development/python-modules/univers { };

  universal-pathlib = callPackage ../development/python-modules/universal-pathlib { };

  universal-silabs-flasher = callPackage ../development/python-modules/universal-silabs-flasher { };

  unix-ar = callPackage ../development/python-modules/unix-ar { };

  unpaddedbase64 = callPackage ../development/python-modules/unpaddedbase64 { };

  unrardll = callPackage ../development/python-modules/unrardll { };

  unrpa = callPackage ../development/python-modules/unrpa { };

  unsloth = callPackage ../development/python-modules/unsloth { };

  unsloth-zoo = callPackage ../development/python-modules/unsloth-zoo { };

  unstructured = callPackage ../development/python-modules/unstructured { };

  unstructured-api-tools = callPackage ../development/python-modules/unstructured-api-tools { };

  unstructured-client = callPackage ../development/python-modules/unstructured-client { };

  unstructured-inference = callPackage ../development/python-modules/unstructured-inference { };

  untangle = callPackage ../development/python-modules/untangle { };

  untokenize = callPackage ../development/python-modules/untokenize { };

  uonet-request-signer-hebe = callPackage ../development/python-modules/uonet-request-signer-hebe { };

  upass = callPackage ../development/python-modules/upass { };

  upb-lib = callPackage ../development/python-modules/upb-lib { };

  upcloud-api = callPackage ../development/python-modules/upcloud-api { };

  update-checker = callPackage ../development/python-modules/update-checker { };

  update-copyright = callPackage ../development/python-modules/update-copyright { };

  update-dotdee = callPackage ../development/python-modules/update-dotdee { };

  uplc = callPackage ../development/python-modules/uplc { };

  uplink = callPackage ../development/python-modules/uplink { };

  uplink-protobuf = callPackage ../development/python-modules/uplink-protobuf { };

  upnpy = callPackage ../development/python-modules/upnpy { };

  uproot = callPackage ../development/python-modules/uproot { };

  uptime = callPackage ../development/python-modules/uptime { };

  uptime-kuma-api = callPackage ../development/python-modules/uptime-kuma-api { };

  uptime-kuma-monitor = callPackage ../development/python-modules/uptime-kuma-monitor { };

  uqbar = callPackage ../development/python-modules/uqbar { };

  uranium = callPackage ../development/python-modules/uranium { };

  uri-template = callPackage ../development/python-modules/uri-template { };

  uritemplate = callPackage ../development/python-modules/uritemplate { };

  uritools = callPackage ../development/python-modules/uritools { };

  url-normalize = callPackage ../development/python-modules/url-normalize { };

  urlextract = callPackage ../development/python-modules/urlextract { };

  urlgrabber = callPackage ../development/python-modules/urlgrabber { };

  urllib3 = callPackage ../development/python-modules/urllib3 { };

  urllib3-future = callPackage ../development/python-modules/urllib3-future { };

  urlman = callPackage ../development/python-modules/urlman { };

  urlmatch = callPackage ../development/python-modules/urlmatch { };

  urlobject = callPackage ../development/python-modules/urlobject { };

  urlpy = callPackage ../development/python-modules/urlpy { };

  urwid = callPackage ../development/python-modules/urwid { };

  urwid-readline = callPackage ../development/python-modules/urwid-readline { };

  urwid-satext = callPackage ../development/python-modules/urwid-satext { };

  urwidgets = callPackage ../development/python-modules/urwidgets { };

  urwidtrees = callPackage ../development/python-modules/urwidtrees { };

  us = callPackage ../development/python-modules/us { };

  usb-devices = callPackage ../development/python-modules/usb-devices { };

  usb-monitor = callPackage ../development/python-modules/usb-monitor { };

  usb-protocol = callPackage ../development/python-modules/usb-protocol { };

  usbrelay-py = callPackage ../os-specific/linux/usbrelay/python.nix { };

  usbtmc = callPackage ../development/python-modules/usbtmc { };

  useful-types = callPackage ../development/python-modules/useful-types { };

  user-agents = callPackage ../development/python-modules/user-agents { };

  userpath = callPackage ../development/python-modules/userpath { };

  ush = callPackage ../development/python-modules/ush { };

  usort = callPackage ../development/python-modules/usort { };

  utils = callPackage ../development/python-modules/utils { };

  utitools = callPackage ../development/python-modules/utitools { };

  uuid6 = callPackage ../development/python-modules/uuid6 { };

  uv = callPackage ../development/python-modules/uv { inherit (pkgs) uv; };

  uv-build = callPackage ../development/python-modules/uv-build { };

  uv-dynamic-versioning = callPackage ../development/python-modules/uv-dynamic-versioning { };

  uvcclient = callPackage ../development/python-modules/uvcclient { };

  uvicorn = callPackage ../development/python-modules/uvicorn { };

  uvicorn-worker = callPackage ../development/python-modules/uvicorn-worker { };

  uvloop = callPackage ../development/python-modules/uvloop { };

  uwsgi-chunked = callPackage ../development/python-modules/uwsgi-chunked { };

  uxsim = callPackage ../development/python-modules/uxsim { };

  vaa = callPackage ../development/python-modules/vaa { };

  vacuum-map-parser-base = callPackage ../development/python-modules/vacuum-map-parser-base { };

  vacuum-map-parser-roborock =
    callPackage ../development/python-modules/vacuum-map-parser-roborock
      { };

  validate-email = callPackage ../development/python-modules/validate-email { };

  validator-collection = callPackage ../development/python-modules/validator-collection { };

  validators = callPackage ../development/python-modules/validators { };

  validobj = callPackage ../development/python-modules/validobj { };

  valkey = callPackage ../development/python-modules/valkey { };

  vallox-websocket-api = callPackage ../development/python-modules/vallox-websocket-api { };

  vapoursynth = callPackage ../development/python-modules/vapoursynth { inherit (pkgs) vapoursynth; };

  variants = callPackage ../development/python-modules/variants { };

  varint = callPackage ../development/python-modules/varint { };

  vat-moss = callPackage ../development/python-modules/vat-moss { };

  vbuild = callPackage ../development/python-modules/vbuild { };

  vcard = callPackage ../development/python-modules/vcard { };

  vcrpy = callPackage ../development/python-modules/vcrpy { };

  vcversioner = callPackage ../development/python-modules/vcversioner { };

  vdf = callPackage ../development/python-modules/vdf { };

  vdirsyncer = callPackage ../development/python-modules/vdirsyncer { };

  vector = callPackage ../development/python-modules/vector { };

  vega = callPackage ../development/python-modules/vega { };

  vega-datasets = callPackage ../development/python-modules/vega-datasets { };

  vegehub = callPackage ../development/python-modules/vegehub { };

  vehicle = callPackage ../development/python-modules/vehicle { };

  velbus-aio = callPackage ../development/python-modules/velbus-aio { };

  venstarcolortouch = callPackage ../development/python-modules/venstarcolortouch { };

  venusian = callPackage ../development/python-modules/venusian { };

  verboselogs = callPackage ../development/python-modules/verboselogs { };

  verilogae = callPackage ../development/python-modules/verilogae { };

  verlib2 = callPackage ../development/python-modules/verlib2 { };

  versioneer = callPackage ../development/python-modules/versioneer { };

  versionfinder = callPackage ../development/python-modules/versionfinder { };

  versioningit = callPackage ../development/python-modules/versioningit { };

  versiontag = callPackage ../development/python-modules/versiontag { };

  versiontools = callPackage ../development/python-modules/versiontools { };

  verspec = callPackage ../development/python-modules/verspec { };

  vertica-python = callPackage ../development/python-modules/vertica-python { };

  veryprettytable = callPackage ../development/python-modules/veryprettytable { };

  vfblib = callPackage ../development/python-modules/vfblib { };

  vg = callPackage ../development/python-modules/vg { };

  vharfbuzz = callPackage ../development/python-modules/vharfbuzz { };

  victron-vrm = callPackage ../development/python-modules/victron-vrm { };

  videocr = callPackage ../development/python-modules/videocr { };

  vidstab = callPackage ../development/python-modules/vidstab { };

  viennarna = toPythonModule (pkgs.viennarna.override { python3 = self.python; });

  viewstate = callPackage ../development/python-modules/viewstate { };

  vilfo-api-client = callPackage ../development/python-modules/vilfo-api-client { };

  vina = callPackage ../applications/science/chemistry/autodock-vina/python-bindings.nix { };

  vincenty = callPackage ../development/python-modules/vincenty { };

  vine = callPackage ../development/python-modules/vine { };

  virt-firmware = callPackage ../development/python-modules/virt-firmware { };

  virtual-glob = callPackage ../development/python-modules/virtual-glob { };

  virtualenv = callPackage ../development/python-modules/virtualenv { };

  virtualenv-clone = callPackage ../development/python-modules/virtualenv-clone { };

  virtualenvwrapper = callPackage ../development/python-modules/virtualenvwrapper { };

  viser = callPackage ../development/python-modules/viser { };

  visions = callPackage ../development/python-modules/visions { };

  visitor = callPackage ../development/python-modules/visitor { };

  vispy = callPackage ../development/python-modules/vispy { };

  viv-utils = callPackage ../development/python-modules/viv-utils { };

  vivisect = callPackage ../development/python-modules/vivisect {
    inherit (pkgs.libsForQt5) wrapQtAppsHook;
  };

  vl-convert-python = callPackage ../development/python-modules/vl-convert-python {
    inherit (pkgs) protobuf;
  };

  vllm = callPackage ../development/python-modules/vllm { };

  vmas = callPackage ../development/python-modules/vmas { };

  vmprof = callPackage ../development/python-modules/vmprof { };

  vncdo = callPackage ../development/python-modules/vncdo { };

  vnoise = callPackage ../development/python-modules/vnoise { };

  vobject = callPackage ../development/python-modules/vobject { };

  voip-utils = callPackage ../development/python-modules/voip-utils { };

  volatile = callPackage ../development/python-modules/volatile { };

  volkswagencarnet = callPackage ../development/python-modules/volkswagencarnet { };

  volkszaehler = callPackage ../development/python-modules/volkszaehler { };

  voluptuous = callPackage ../development/python-modules/voluptuous { };

  voluptuous-openapi = callPackage ../development/python-modules/voluptuous-openapi { };

  voluptuous-serialize = callPackage ../development/python-modules/voluptuous-serialize { };

  voluptuous-stubs = callPackage ../development/python-modules/voluptuous-stubs { };

  volvocarsapi = callPackage ../development/python-modules/volvocarsapi { };

  volvooncall = callPackage ../development/python-modules/volvooncall { };

  vowpalwabbit = callPackage ../development/python-modules/vowpalwabbit { };

  vpk = callPackage ../development/python-modules/vpk { };

  vprof = callPackage ../development/python-modules/vprof { };

  vqgan-jax = callPackage ../development/python-modules/vqgan-jax { };

  vsts = callPackage ../development/python-modules/vsts { };

  vsts-cd-manager = callPackage ../development/python-modules/vsts-cd-manager { };

  vsure = callPackage ../development/python-modules/vsure { };

  vt-py = callPackage ../development/python-modules/vt-py { };

  vtjp = callPackage ../development/python-modules/vtjp { };

  vtk = toPythonModule (
    pkgs.vtk.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  vttlib = callPackage ../development/python-modules/vttlib { };

  vulkan = callPackage ../development/python-modules/vulkan { };

  vultr = callPackage ../development/python-modules/vultr { };

  vulture = callPackage ../development/python-modules/vulture { };

  vxi11 = callPackage ../development/python-modules/vxi11 { };

  vyper = callPackage ../development/compilers/vyper { };

  w1thermsensor = callPackage ../development/python-modules/w1thermsensor { };

  w3lib = callPackage ../development/python-modules/w3lib { };

  wacz = callPackage ../development/python-modules/wacz { };

  wadler-lindig = callPackage ../development/python-modules/wadler-lindig { };

  wadllib = callPackage ../development/python-modules/wadllib { };

  wagtail = callPackage ../development/python-modules/wagtail { };

  wagtail-factories = callPackage ../development/python-modules/wagtail-factories { };

  wagtail-localize = callPackage ../development/python-modules/wagtail-localize { };

  wagtail-modeladmin = callPackage ../development/python-modules/wagtail-modeladmin { };

  waitress = callPackage ../development/python-modules/waitress { };

  waitress-django = callPackage ../development/python-modules/waitress-django { };

  wakeonlan = callPackage ../development/python-modules/wakeonlan { };

  wallbox = callPackage ../development/python-modules/wallbox { };

  wallet-py3k = callPackage ../development/python-modules/wallet-py3k { };

  walrus = callPackage ../development/python-modules/walrus { };

  wand = callPackage ../development/python-modules/wand { };

  wandb = callPackage ../development/python-modules/wandb { };

  wapiti-arsenic = callPackage ../development/python-modules/wapiti-arsenic { };

  wapiti-swagger = callPackage ../development/python-modules/wapiti-swagger { };

  waqiasync = callPackage ../development/python-modules/waqiasync { };

  warble = callPackage ../development/python-modules/warble { };

  warcio = callPackage ../development/python-modules/warcio { };

  ward = callPackage ../development/python-modules/ward { };

  warlock = callPackage ../development/python-modules/warlock { };

  warp-lang = callPackage ../development/python-modules/warp-lang {
    stdenv = if stdenv.hostPlatform.isDarwin then pkgs.llvmPackages_19.stdenv else pkgs.stdenv;
    llvmPackages = pkgs.llvmPackages_19;
  };

  warrant = callPackage ../development/python-modules/warrant { };

  warrant-lite = callPackage ../development/python-modules/warrant-lite { };

  wasabi = callPackage ../development/python-modules/wasabi { };

  inherit (self.wasmerPackages)
    wasmer
    wasmer-compiler-cranelift
    wasmer-compiler-llvm
    wasmer-compiler-singlepass
    ;

  wasmerPackages = lib.recurseIntoAttrs (callPackage ../development/python-modules/wasmer { });

  wasserstein = callPackage ../development/python-modules/wasserstein { };

  wassima = callPackage ../development/python-modules/wassima { };

  wat = callPackage ../development/python-modules/wat { };

  watchdog = callPackage ../development/python-modules/watchdog { };

  watchdog-gevent = callPackage ../development/python-modules/watchdog-gevent { };

  watchfiles = callPackage ../development/python-modules/watchfiles { };

  watchgod = callPackage ../development/python-modules/watchgod { };

  waterfurnace = callPackage ../development/python-modules/waterfurnace { };

  watergate-local-api = callPackage ../development/python-modules/watergate-local-api { };

  watermark = callPackage ../development/python-modules/watermark { };

  wavedrom = callPackage ../development/python-modules/wavedrom { };

  wavefile = callPackage ../development/python-modules/wavefile { };

  wavinsentio = callPackage ../development/python-modules/wavinsentio { };

  waybackpy = callPackage ../development/python-modules/waybackpy { };

  waymax = callPackage ../development/python-modules/waymax { };

  wazeroutecalculator = callPackage ../development/python-modules/wazeroutecalculator { };

  wcag-contrast-ratio = callPackage ../development/python-modules/wcag-contrast-ratio { };

  wcmatch = callPackage ../development/python-modules/wcmatch { };

  wcwidth = callPackage ../development/python-modules/wcwidth { };

  weasel = callPackage ../development/python-modules/weasel { };

  weasyprint = callPackage ../development/python-modules/weasyprint { };

  weatherflow4py = callPackage ../development/python-modules/weatherflow4py { };

  weaviate-client = callPackage ../development/python-modules/weaviate-client { };

  web = callPackage ../development/python-modules/web { };

  web-cache = callPackage ../development/python-modules/web-cache { };

  web3 = callPackage ../development/python-modules/web3 { };

  webargs = callPackage ../development/python-modules/webargs { };

  webassets = callPackage ../development/python-modules/webassets { };

  webauthn = callPackage ../development/python-modules/webauthn { };

  webcolors = callPackage ../development/python-modules/webcolors { };

  webdataset = callPackage ../development/python-modules/webdataset { };

  webdav4 = callPackage ../development/python-modules/webdav4 { };

  webdavclient3 = callPackage ../development/python-modules/webdavclient3 { };

  webdriver-manager = callPackage ../development/python-modules/webdriver-manager { };

  webencodings = callPackage ../development/python-modules/webencodings { };

  webexpythonsdk = callPackage ../development/python-modules/webexpythonsdk { };

  webexteamssdk = callPackage ../development/python-modules/webexteamssdk { };

  webidl = callPackage ../development/python-modules/webidl { };

  webio-api = callPackage ../development/python-modules/webio-api { };

  weblate-language-data = callPackage ../development/python-modules/weblate-language-data { };

  weblate-schemas = callPackage ../development/python-modules/weblate-schemas { };

  webmin-xmlrpc = callPackage ../development/python-modules/webmin-xmlrpc { };

  webob = callPackage ../development/python-modules/webob { };

  webrtc-models = callPackage ../development/python-modules/webrtc-models { };

  webrtc-noise-gain = callPackage ../development/python-modules/webrtc-noise-gain { };

  webrtcvad = callPackage ../development/python-modules/webrtcvad { };

  websocket-client = callPackage ../development/python-modules/websocket-client { };

  websockets = callPackage ../development/python-modules/websockets { };

  websockify = callPackage ../development/python-modules/websockify { };

  webssh = callPackage ../development/python-modules/webssh { };

  webtest = callPackage ../development/python-modules/webtest { };

  webtest-aiohttp = callPackage ../development/python-modules/webtest-aiohttp { };

  webthing = callPackage ../development/python-modules/webthing { };

  webthing-ws = callPackage ../development/python-modules/webthing-ws { };

  weconnect = callPackage ../development/python-modules/weconnect { };

  weconnect-mqtt = callPackage ../development/python-modules/weconnect-mqtt { };

  weheat = callPackage ../development/python-modules/weheat { };

  werkzeug = callPackage ../development/python-modules/werkzeug { };

  west = callPackage ../development/python-modules/west { };

  wfuzz = callPackage ../development/python-modules/wfuzz { };

  wget = callPackage ../development/python-modules/wget { };

  wgpu-py = callPackage ../development/python-modules/wgpu-py { };

  whatthepatch = callPackage ../development/python-modules/whatthepatch { };

  wheel = callPackage ../development/python-modules/wheel { };

  wheel-filename = callPackage ../development/python-modules/wheel-filename { };

  wheel-inspect = callPackage ../development/python-modules/wheel-inspect { };

  wheezy-captcha = callPackage ../development/python-modules/wheezy-captcha { };

  wheezy-template = callPackage ../development/python-modules/wheezy-template { };

  whenever = callPackage ../development/python-modules/whenever { };

  whey = callPackage ../development/python-modules/whey { };

  whey-pth = callPackage ../development/python-modules/whey-pth { };

  whichcraft = callPackage ../development/python-modules/whichcraft { };

  whirlpool-sixth-sense = callPackage ../development/python-modules/whirlpool-sixth-sense { };

  whisper = callPackage ../development/python-modules/whisper { };

  whispers = callPackage ../development/python-modules/whispers { };

  whisperx = callPackage ../development/python-modules/whisperx {
    inherit (pkgs) ffmpeg;
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  whitenoise = callPackage ../development/python-modules/whitenoise { };

  whodap = callPackage ../development/python-modules/whodap { };

  whois = callPackage ../development/python-modules/whois { };

  whois-api = callPackage ../development/python-modules/whois-api { };

  whoisdomain = callPackage ../development/python-modules/whoisdomain { };

  whool = callPackage ../development/python-modules/whool { };

  whoosh = callPackage ../development/python-modules/whoosh { };

  whoosh-reloaded = callPackage ../development/python-modules/whoosh-reloaded { };

  widgetsnbextension = callPackage ../development/python-modules/widgetsnbextension { };

  widlparser = callPackage ../development/python-modules/widlparser { };

  wiffi = callPackage ../development/python-modules/wiffi { };

  wifi = callPackage ../development/python-modules/wifi { };

  wikipedia = callPackage ../development/python-modules/wikipedia { };

  wikipedia-api = callPackage ../development/python-modules/wikipedia-api { };

  wikipedia2vec = callPackage ../development/python-modules/wikipedia2vec { };

  wikitextparser = callPackage ../development/python-modules/wikitextparser { };

  willow = callPackage ../development/python-modules/willow { };

  winacl = callPackage ../development/python-modules/winacl { };

  winsspi = callPackage ../development/python-modules/winsspi { };

  wirelesstagpy = callPackage ../development/python-modules/wirelesstagpy { };

  wirerope = callPackage ../development/python-modules/wirerope { };

  withings-api = callPackage ../development/python-modules/withings-api { };

  withings-sync = callPackage ../development/python-modules/withings-sync { };

  wktutils = callPackage ../development/python-modules/wktutils { };

  wled = callPackage ../development/python-modules/wled { };

  wn = callPackage ../development/python-modules/wn { };

  wokkel = callPackage ../development/python-modules/wokkel { };

  wolf-comm = callPackage ../development/python-modules/wolf-comm { };

  woob = callPackage ../development/python-modules/woob { };

  woodblock = callPackage ../development/python-modules/woodblock { };

  word2number = callPackage ../development/python-modules/word2number { };

  wordcloud = callPackage ../development/python-modules/wordcloud { };

  wordfreq = callPackage ../development/python-modules/wordfreq { };

  wordninja = callPackage ../development/python-modules/wordninja { };

  world-bank-data = callPackage ../development/python-modules/world-bank-data { };

  wrapcco = callPackage ../development/python-modules/wrapcco { };

  wrapio = callPackage ../development/python-modules/wrapio { };

  wrapt = callPackage ../development/python-modules/wrapt { };

  wrf-python = callPackage ../development/python-modules/wrf-python { };

  ws4py = callPackage ../development/python-modules/ws4py { };

  wsdiscovery = callPackage ../development/python-modules/wsdiscovery { };

  wsdot = callPackage ../development/python-modules/wsdot { };

  wsgi-intercept = callPackage ../development/python-modules/wsgi-intercept { };

  wsgidav = callPackage ../development/python-modules/wsgidav { };

  wsgiprox = callPackage ../development/python-modules/wsgiprox { };

  wsgiproxy2 = callPackage ../development/python-modules/wsgiproxy2 { };

  wsgitools = callPackage ../development/python-modules/wsgitools { };

  wslink = callPackage ../development/python-modules/wslink { };

  wsme = callPackage ../development/python-modules/wsme { };

  wsproto = callPackage ../development/python-modules/wsproto { };

  wtf-peewee = callPackage ../development/python-modules/wtf-peewee { };

  wtforms = callPackage ../development/python-modules/wtforms { };

  wtforms-bootstrap5 = callPackage ../development/python-modules/wtforms-bootstrap5 { };

  wtforms-sqlalchemy = callPackage ../development/python-modules/wtforms-sqlalchemy { };

  wunsen = callPackage ../development/python-modules/wunsen { };

  wurlitzer = callPackage ../development/python-modules/wurlitzer { };

  wxpython = callPackage ../development/python-modules/wxpython/4.2.nix {
    wxGTK = pkgs.wxGTK32.override { withWebKit = true; };
  };

  wyoming = callPackage ../development/python-modules/wyoming { };

  x-transformers = callPackage ../development/python-modules/x-transformers { };

  x-wr-timezone = callPackage ../development/python-modules/x-wr-timezone { };

  x11-hash = callPackage ../development/python-modules/x11-hash { };

  x256 = callPackage ../development/python-modules/x256 { };

  x3dh = callPackage ../development/python-modules/x3dh { };

  x690 = callPackage ../development/python-modules/x690 { };

  xapian = callPackage ../development/python-modules/xapian { inherit (pkgs) xapian; };

  xarray = callPackage ../development/python-modules/xarray { };

  xarray-dataclass = callPackage ../development/python-modules/xarray-dataclass { };

  xarray-dataclasses = callPackage ../development/python-modules/xarray-dataclasses { };

  xarray-einstats = callPackage ../development/python-modules/xarray-einstats { };

  xattr = callPackage ../development/python-modules/xattr { };

  xbox-webapi = callPackage ../development/python-modules/xbox-webapi { };

  xboxapi = callPackage ../development/python-modules/xboxapi { };

  xcaplib = callPackage ../development/python-modules/xcaplib { };

  xcffib = callPackage ../development/python-modules/xcffib { };

  xdg = callPackage ../development/python-modules/xdg { };

  xdg-base-dirs = callPackage ../development/python-modules/xdg-base-dirs { };

  xdis = callPackage ../development/python-modules/xdis { };

  xdoctest = callPackage ../development/python-modules/xdoctest { };

  xdot = callPackage ../development/python-modules/xdot { inherit (pkgs) graphviz; };

  xdxf2html = callPackage ../development/python-modules/xdxf2html { };

  xeddsa = toPythonModule (callPackage ../development/python-modules/xeddsa { });

  xeger = callPackage ../development/python-modules/xeger { };

  xen = toPythonModule (pkgs.xen.override { python3Packages = self; });

  xformers = callPackage ../development/python-modules/xformers {
    inherit (pkgs.llvmPackages) openmp;
  };

  xgboost = callPackage ../development/python-modules/xgboost { inherit (pkgs) xgboost; };

  xgrammar = callPackage ../development/python-modules/xgrammar { };

  xhtml2pdf = callPackage ../development/python-modules/xhtml2pdf { };

  xiaomi-ble = callPackage ../development/python-modules/xiaomi-ble { };

  xkbcommon = callPackage ../development/python-modules/xkbcommon { };

  xkcdpass = callPackage ../development/python-modules/xkcdpass { };

  xknx = callPackage ../development/python-modules/xknx { };

  xknxproject = callPackage ../development/python-modules/xknxproject { };

  xlib = callPackage ../development/python-modules/xlib { };

  xlrd = callPackage ../development/python-modules/xlrd { };

  xlsx2csv = callPackage ../development/python-modules/xlsx2csv { };

  xlsxwriter = callPackage ../development/python-modules/xlsxwriter { };

  xlwt = callPackage ../development/python-modules/xlwt { };

  xmind = callPackage ../development/python-modules/xmind { };

  xml-marshaller = callPackage ../development/python-modules/xml-marshaller { };

  xml2rfc = callPackage ../development/python-modules/xml2rfc { };

  xmldiff = callPackage ../development/python-modules/xmldiff { };

  xmljson = callPackage ../development/python-modules/xmljson { };

  xmlschema = callPackage ../development/python-modules/xmlschema { };

  xmlsec = callPackage ../development/python-modules/xmlsec {
    inherit (pkgs)
      libxslt
      libxml2
      libtool
      pkg-config
      xmlsec
      ;
  };

  xmltodict = callPackage ../development/python-modules/xmltodict { };

  xmod = callPackage ../development/python-modules/xmod { };

  xmodem = callPackage ../development/python-modules/xmodem { };

  xmpppy = callPackage ../development/python-modules/xmpppy { };

  xnatpy = callPackage ../development/python-modules/xnatpy { };

  xnd = callPackage ../development/python-modules/xnd { };

  xonsh = callPackage ../by-name/xo/xonsh/unwrapped.nix { };

  xpath-expressions = callPackage ../development/python-modules/xpath-expressions { };

  xpybutil = callPackage ../development/python-modules/xpybutil { };

  xrootd = callPackage ../development/python-modules/xrootd { inherit (pkgs) xrootd; };

  xs1-api-client = callPackage ../development/python-modules/xs1-api-client { };

  xsdata = callPackage ../development/python-modules/xsdata { };

  xsdata-pydantic = callPackage ../development/python-modules/xsdata-pydantic { };

  xstatic = callPackage ../development/python-modules/xstatic { };

  xstatic-asciinema-player = callPackage ../development/python-modules/xstatic-asciinema-player { };

  xstatic-bootbox = callPackage ../development/python-modules/xstatic-bootbox { };

  xstatic-bootstrap = callPackage ../development/python-modules/xstatic-bootstrap { };

  xstatic-font-awesome = callPackage ../development/python-modules/xstatic-font-awesome { };

  xstatic-jquery = callPackage ../development/python-modules/xstatic-jquery { };

  xstatic-jquery-file-upload =
    callPackage ../development/python-modules/xstatic-jquery-file-upload
      { };

  xstatic-jquery-ui = callPackage ../development/python-modules/xstatic-jquery-ui { };

  xstatic-pygments = callPackage ../development/python-modules/xstatic-pygments { };

  xtensor-python = callPackage ../development/python-modules/xtensor-python { };

  xvfbwrapper = callPackage ../development/python-modules/xvfbwrapper { };

  xxhash = callPackage ../development/python-modules/xxhash { };

  xyzservices = callPackage ../development/python-modules/xyzservices { };

  y-py = callPackage ../development/python-modules/y-py { };

  yabadaba = callPackage ../development/python-modules/yabadaba { };

  yacs = callPackage ../development/python-modules/yacs { };

  yagrc = callPackage ../development/python-modules/yagrc { };

  yalesmartalarmclient = callPackage ../development/python-modules/yalesmartalarmclient { };

  yalexs = callPackage ../development/python-modules/yalexs { };

  yalexs-ble = callPackage ../development/python-modules/yalexs-ble { };

  yamale = callPackage ../development/python-modules/yamale { };

  yamlfix = callPackage ../development/python-modules/yamlfix { };

  yamllint = callPackage ../development/python-modules/yamllint { };

  yamlloader = callPackage ../development/python-modules/yamlloader { };

  yamlordereddictloader = callPackage ../development/python-modules/yamlordereddictloader { };

  yangson = callPackage ../development/python-modules/yangson { };

  yapf = callPackage ../development/python-modules/yapf { };

  yappi = callPackage ../development/python-modules/yappi { };

  yapsy = callPackage ../development/python-modules/yapsy { };

  yara-python = callPackage ../development/python-modules/yara-python { };

  yara-x = callPackage ../development/python-modules/yara-x { };

  yaramod = callPackage ../development/python-modules/yaramod { };

  yarg = callPackage ../development/python-modules/yarg { };

  yargy = callPackage ../development/python-modules/yargy { };

  yark = callPackage ../development/python-modules/yark { };

  yarl = callPackage ../development/python-modules/yarl { };

  yasi = callPackage ../development/python-modules/yasi { };

  yaspin = callPackage ../development/python-modules/yaspin { };

  yaswfp = callPackage ../development/python-modules/yaswfp { };

  yattag = callPackage ../development/python-modules/yattag { };

  yaxmldiff = callPackage ../development/python-modules/yaxmldiff { };

  ydata-profiling = callPackage ../development/python-modules/ydata-profiling { };

  ydiff = callPackage ../development/python-modules/ydiff { };

  yeelight = callPackage ../development/python-modules/yeelight { };

  yeelightsunflower = callPackage ../development/python-modules/yeelightsunflower { };

  yfinance = callPackage ../development/python-modules/yfinance { };

  yoda = toPythonModule (pkgs.yoda.override { python3 = python; });

  yolink-api = callPackage ../development/python-modules/yolink-api { };

  yosys = toPythonModule (pkgs.yosys.override { python3 = python; });

  yoto-api = callPackage ../development/python-modules/yoto-api { };

  youless-api = callPackage ../development/python-modules/youless-api { };

  yourdfpy = callPackage ../development/python-modules/yourdfpy { };

  youseedee = callPackage ../development/python-modules/youseedee { };

  youtokentome = callPackage ../development/python-modules/youtokentome { };

  youtube-dl = callPackage ../tools/misc/youtube-dl { };

  youtube-dl-light = callPackage ../tools/misc/youtube-dl { ffmpegSupport = false; };

  youtube-search = callPackage ../development/python-modules/youtube-search { };

  youtube-search-python = callPackage ../development/python-modules/youtube-search-python { };

  youtube-transcript-api = callPackage ../development/python-modules/youtube-transcript-api { };

  youtubeaio = callPackage ../development/python-modules/youtubeaio { };

  yowsup = callPackage ../development/python-modules/yowsup { };

  yoyo-migrations = callPackage ../development/python-modules/yoyo-migrations { };

  ypy-websocket = callPackage ../development/python-modules/ypy-websocket { };

  yq = callPackage ../development/python-modules/yq { inherit (pkgs) jq; };

  yt-dlp = toPythonModule (pkgs.yt-dlp.override { python3Packages = self; });

  yt-dlp-dearrow = callPackage ../development/python-modules/yt-dlp-dearrow { };

  yt-dlp-ejs = callPackage ../development/python-modules/yt-dlp-ejs { };

  yt-dlp-light = toPythonModule (pkgs.yt-dlp-light.override { python3Packages = self; });

  yte = callPackage ../development/python-modules/yte { };

  ytmusicapi = callPackage ../development/python-modules/ytmusicapi { };

  yubico = callPackage ../development/python-modules/yubico { };

  yubico-client = callPackage ../development/python-modules/yubico-client { };

  z3-solver = (toPythonModule (pkgs.z3.override { python3Packages = self; })).python;

  z3c-checkversions = callPackage ../development/python-modules/z3c-checkversions { };

  zabbix-utils = callPackage ../development/python-modules/zabbix-utils { };

  zadnegoale = callPackage ../development/python-modules/zadnegoale { };

  zamg = callPackage ../development/python-modules/zamg { };

  zammad-py = callPackage ../development/python-modules/zammad-py { };

  zarr = callPackage ../development/python-modules/zarr { };

  zc-buildout = callPackage ../development/python-modules/zc-buildout { };

  zc-lockfile = callPackage ../development/python-modules/zc-lockfile { };

  zcbor = callPackage ../development/python-modules/zcbor { };

  zcc-helper = callPackage ../development/python-modules/zcc-helper { };

  zconfig = callPackage ../development/python-modules/zconfig { };

  zdaemon = callPackage ../development/python-modules/zdaemon { };

  zebrafy = callPackage ../development/python-modules/zebrafy { };

  zeek = (toPythonModule (pkgs.zeek.broker.override { python3 = python; })).py;

  zeep = callPackage ../development/python-modules/zeep { };

  zeitgeist = (toPythonModule (pkgs.zeitgeist.override { python3 = python; })).py;

  zenlog = callPackage ../development/python-modules/zenlog { };

  zenoh = callPackage ../development/python-modules/zenoh { };

  zephyr-python-api = callPackage ../development/python-modules/zephyr-python-api { };

  zephyr-test-management = callPackage ../development/python-modules/zephyr-test-management { };

  zeroc-ice = callPackage ../development/python-modules/zeroc-ice { };

  zeroconf = callPackage ../development/python-modules/zeroconf { };

  zerorpc = callPackage ../development/python-modules/zerorpc { };

  zetup = callPackage ../development/python-modules/zetup { };

  zeversolar = callPackage ../development/python-modules/zeversolar { };

  zeversolarlocal = callPackage ../development/python-modules/zeversolarlocal { };

  zfec = callPackage ../development/python-modules/zfec { };

  zha = callPackage ../development/python-modules/zha { };

  zha-quirks = callPackage ../development/python-modules/zha-quirks { };

  zhon = callPackage ../development/python-modules/zhon { };

  zhong-hong-hvac = callPackage ../development/python-modules/zhong-hong-hvac { };

  ziafont = callPackage ../development/python-modules/ziafont { };

  ziamath = callPackage ../development/python-modules/ziamath { };

  zict = callPackage ../development/python-modules/zict { };

  ziggo-mediabox-xl = callPackage ../development/python-modules/ziggo-mediabox-xl { };

  zigpy = callPackage ../development/python-modules/zigpy { };

  zigpy-cc = callPackage ../development/python-modules/zigpy-cc { };

  zigpy-deconz = callPackage ../development/python-modules/zigpy-deconz { };

  zigpy-xbee = callPackage ../development/python-modules/zigpy-xbee { };

  zigpy-zboss = callPackage ../development/python-modules/zigpy-zboss { };

  zigpy-zigate = callPackage ../development/python-modules/zigpy-zigate { };

  zigpy-znp = callPackage ../development/python-modules/zigpy-znp { };

  zimports = callPackage ../development/python-modules/zimports { };

  zipfile2 = callPackage ../development/python-modules/zipfile2 { };

  zipp = callPackage ../development/python-modules/zipp { };

  zipstream-ng = callPackage ../development/python-modules/zipstream-ng { };

  zlib-ng = callPackage ../development/python-modules/zlib-ng { inherit (pkgs) zlib-ng; };

  zm-py = callPackage ../development/python-modules/zm-py { };

  zodb = callPackage ../development/python-modules/zodb { };

  zodbpickle = callPackage ../development/python-modules/zodbpickle { };

  zope-cachedescriptors = callPackage ../development/python-modules/zope-cachedescriptors { };

  zope-component = callPackage ../development/python-modules/zope-component { };

  zope-configuration = callPackage ../development/python-modules/zope-configuration { };

  zope-contenttype = callPackage ../development/python-modules/zope-contenttype { };

  zope-copy = callPackage ../development/python-modules/zope-copy { };

  zope-deferredimport = callPackage ../development/python-modules/zope-deferredimport { };

  zope-deprecation = callPackage ../development/python-modules/zope-deprecation { };

  zope-dottedname = callPackage ../development/python-modules/zope-dottedname { };

  zope-event = callPackage ../development/python-modules/zope-event { };

  zope-exceptions = callPackage ../development/python-modules/zope-exceptions { };

  zope-filerepresentation = callPackage ../development/python-modules/zope-filerepresentation { };

  zope-hookable = callPackage ../development/python-modules/zope-hookable { };

  zope-i18nmessageid = callPackage ../development/python-modules/zope-i18nmessageid { };

  zope-index = callPackage ../development/python-modules/zope-index { };

  zope-interface = callPackage ../development/python-modules/zope-interface { };

  zope-lifecycleevent = callPackage ../development/python-modules/zope-lifecycleevent { };

  zope-location = callPackage ../development/python-modules/zope-location { };

  zope-proxy = callPackage ../development/python-modules/zope-proxy { };

  zope-schema = callPackage ../development/python-modules/zope-schema { };

  zope-security = callPackage ../development/python-modules/zope-security { };

  zope-size = callPackage ../development/python-modules/zope-size { };

  zope-testbrowser = callPackage ../development/python-modules/zope-testbrowser { };

  zope-testing = callPackage ../development/python-modules/zope-testing { };

  zope-testrunner = callPackage ../development/python-modules/zope-testrunner { };

  zopfli = callPackage ../development/python-modules/zopfli { inherit (pkgs) zopfli; };

  zpp = callPackage ../development/python-modules/zpp { };

  zstandard = callPackage ../development/python-modules/zstandard { };

  zstd = callPackage ../development/python-modules/zstd { inherit (pkgs) zstd; };

  zulip = callPackage ../development/python-modules/zulip { };

  zulip-emoji-mapping = callPackage ../development/python-modules/zulip-emoji-mapping { };

  zundler = callPackage ../development/python-modules/zundler { };

  zwave-js-server-python = callPackage ../development/python-modules/zwave-js-server-python { };

  zwave-me-ws = callPackage ../development/python-modules/zwave-me-ws { };

  zxcvbn = callPackage ../development/python-modules/zxcvbn { };

  zxcvbn-rs-py = callPackage ../development/python-modules/zxcvbn-rs-py { };

  zxing-cpp = callPackage ../development/python-modules/zxing-cpp { libzxing-cpp = pkgs.zxing-cpp; };

  # keep-sorted end
}
