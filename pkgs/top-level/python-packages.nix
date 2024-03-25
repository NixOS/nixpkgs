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
    installer = toPythonModule (callPackage ../development/python-modules/bootstrap/installer {
      inherit (bootstrap) flit-core;
    });
    build = toPythonModule (callPackage ../development/python-modules/bootstrap/build {
      inherit (bootstrap) flit-core installer;
    });
    packaging = toPythonModule (callPackage ../development/python-modules/bootstrap/packaging {
      inherit (bootstrap) flit-core installer;
    });
  };

  setuptools = callPackage ../development/python-modules/setuptools { };

  a2wsgi = callPackage ../development/python-modules/a2wsgi { };

  aadict = callPackage ../development/python-modules/aadict { };

  aafigure = callPackage ../development/python-modules/aafigure { };

  aardwolf = callPackage ../development/python-modules/aardwolf { };

  abjad = callPackage ../development/python-modules/abjad { };

  about-time = callPackage ../development/python-modules/about-time { };

  absl-py = callPackage ../development/python-modules/absl-py { };

  accessible-pygments = callPackage ../development/python-modules/accessible-pygments { };

  accelerate = callPackage ../development/python-modules/accelerate { };

  accuweather = callPackage ../development/python-modules/accuweather { };

  accupy = callPackage ../development/python-modules/accupy { };

  acme = callPackage ../development/python-modules/acme { };

  acme-tiny = callPackage ../development/python-modules/acme-tiny { };

  acoustics = callPackage ../development/python-modules/acoustics { };

  acquire = callPackage ../development/python-modules/acquire { };

  actdiag = callPackage ../development/python-modules/actdiag { };

  acunetix = callPackage ../development/python-modules/acunetix { };

  adafruit-io = callPackage ../development/python-modules/adafruit-io { };

  adafruit-platformdetect = callPackage ../development/python-modules/adafruit-platformdetect { };

  adafruit-pureio = callPackage ../development/python-modules/adafruit-pureio { };

  adal = callPackage ../development/python-modules/adal { };

  adax = callPackage ../development/python-modules/adax { };

  adax-local = callPackage ../development/python-modules/adax-local { };

  adb-enhanced = callPackage ../development/python-modules/adb-enhanced { };

  adb-homeassistant = callPackage ../development/python-modules/adb-homeassistant { };

  adb-shell = callPackage ../development/python-modules/adb-shell { };

  adblock = callPackage ../development/python-modules/adblock {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  add-trailing-comma = callPackage ../development/python-modules/add-trailing-comma { };

  addict = callPackage ../development/python-modules/addict { };

  adext = callPackage ../development/python-modules/adext { };

  adguardhome = callPackage ../development/python-modules/adguardhome { };

  adjusttext = callPackage ../development/python-modules/adjusttext { };

  adlfs = callPackage ../development/python-modules/adlfs { };

  advantage-air = callPackage ../development/python-modules/advantage-air { };

  advocate = callPackage ../development/python-modules/advocate { };

  aemet-opendata = callPackage ../development/python-modules/aemet-opendata { };

  aenum = callPackage ../development/python-modules/aenum { };

  aeppl = callPackage ../development/python-modules/aeppl { };

  aesara = callPackage ../development/python-modules/aesara { };

  aesedb = callPackage ../development/python-modules/aesedb { };

  aetcd = callPackage ../development/python-modules/aetcd { };

  afdko = callPackage ../development/python-modules/afdko { };

  affine = callPackage ../development/python-modules/affine { };

  afsapi = callPackage ../development/python-modules/afsapi { };

  agate = callPackage ../development/python-modules/agate { };

  agate-dbf = callPackage ../development/python-modules/agate-dbf { };

  agate-excel = callPackage ../development/python-modules/agate-excel { };

  agate-sql = callPackage ../development/python-modules/agate-sql { };

  agent-py = callPackage ../development/python-modules/agent-py { };

  ago = callPackage ../development/python-modules/ago { };

  aggdraw = callPackage ../development/python-modules/aggdraw { };

  aigpy = callPackage ../development/python-modules/aigpy { };

  aio-geojson-client = callPackage ../development/python-modules/aio-geojson-client { };

  aio-geojson-generic-client = callPackage ../development/python-modules/aio-geojson-generic-client { };

  aio-geojson-geonetnz-quakes = callPackage ../development/python-modules/aio-geojson-geonetnz-quakes { };

  aio-geojson-geonetnz-volcano = callPackage ../development/python-modules/aio-geojson-geonetnz-volcano { };

  aio-geojson-nsw-rfs-incidents = callPackage ../development/python-modules/aio-geojson-nsw-rfs-incidents { };

  aio-geojson-usgs-earthquakes = callPackage ../development/python-modules/aio-geojson-usgs-earthquakes { };

  aio-georss-client = callPackage ../development/python-modules/aio-georss-client { };

  aio-georss-gdacs = callPackage ../development/python-modules/aio-georss-gdacs { };

  aio-pika = callPackage ../development/python-modules/aio-pika { };

  aioairzone = callPackage ../development/python-modules/aioairzone { };

  aioairzone-cloud = callPackage ../development/python-modules/aioairzone-cloud { };

  aioairq = callPackage ../development/python-modules/aioairq { };

  aioaladdinconnect = callPackage ../development/python-modules/aioaladdinconnect { };

  aioambient = callPackage ../development/python-modules/aioambient { };

  aioapcaccess = callPackage ../development/python-modules/aioapcaccess { };

  aioapns = callPackage ../development/python-modules/aioapns { };

  aiocron = callPackage ../development/python-modules/aiocron { };

  ailment = callPackage ../development/python-modules/ailment { };

  aioamqp = callPackage ../development/python-modules/aioamqp { };

  aioaseko = callPackage ../development/python-modules/aioaseko { };

  aioasuswrt = callPackage ../development/python-modules/aioasuswrt { };

  aioautomower = callPackage ../development/python-modules/aioautomower { };

  aioazuredevops = callPackage ../development/python-modules/aioazuredevops { };

  aiobafi6 = callPackage ../development/python-modules/aiobafi6 { };

  aioboto3 = callPackage ../development/python-modules/aioboto3 { };

  aioblescan = callPackage ../development/python-modules/aioblescan { };

  aiocache = callPackage ../development/python-modules/aiocache { };

  aiocoap = callPackage ../development/python-modules/aiocoap { };

  aiocomelit = callPackage ../development/python-modules/aiocomelit { };

  aioconsole = callPackage ../development/python-modules/aioconsole { };

  aiocontextvars = callPackage ../development/python-modules/aiocontextvars { };

  aiocsv = callPackage ../development/python-modules/aiocsv { };

  aiocurrencylayer = callPackage ../development/python-modules/aiocurrencylayer { };

  aiodhcpwatcher = callPackage ../development/python-modules/aiodhcpwatcher { };

  aiodiscover = callPackage ../development/python-modules/aiodiscover { };

  aiodns = callPackage ../development/python-modules/aiodns { };

  aiodocker = callPackage ../development/python-modules/aiodocker { };

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

  aioguardian = callPackage ../development/python-modules/aioguardian { };

  aiogithubapi = callPackage ../development/python-modules/aiogithubapi { };

  aiogram = callPackage ../development/python-modules/aiogram { };

  aiohappyeyeballs = callPackage ../development/python-modules/aiohappyeyeballs { };

  aioharmony = callPackage ../development/python-modules/aioharmony { };

  aiohomekit = callPackage ../development/python-modules/aiohomekit { };

  aiohttp = callPackage ../development/python-modules/aiohttp { };

  aiohttp-apispec = callPackage ../development/python-modules/aiohttp-apispec { };

  aiohttp-basicauth = callPackage ../development/python-modules/aiohttp-basicauth { };

  aiohttp-client-cache = callPackage ../development/python-modules/aiohttp-client-cache { };

  aiohttp-cors = callPackage ../development/python-modules/aiohttp-cors { };

  aiohttp-fast-url-dispatcher = callPackage ../development/python-modules/aiohttp-fast-url-dispatcher { };

  aiohttp-jinja2 = callPackage ../development/python-modules/aiohttp-jinja2 { };

  aiohttp-oauthlib = callPackage ../development/python-modules/aiohttp-oauthlib { };

  aiohttp-openmetrics = callPackage ../development/python-modules/aiohttp-openmetrics { };

  aiohttp-remotes = callPackage ../development/python-modules/aiohttp-remotes { };

  aiohttp-retry = callPackage ../development/python-modules/aiohttp-retry { };

  aiohttp-socks = callPackage ../development/python-modules/aiohttp-socks { };

  aiohttp-swagger = callPackage ../development/python-modules/aiohttp-swagger { };

  aiohttp-wsgi = callPackage ../development/python-modules/aiohttp-wsgi { };

  aiohttp-zlib-ng = callPackage ../development/python-modules/aiohttp-zlib-ng { };

  aioitertools = callPackage ../development/python-modules/aioitertools { };

  aiobiketrax = callPackage ../development/python-modules/aiobiketrax { };

  aiobotocore = callPackage ../development/python-modules/aiobotocore { };

  aiobroadlink = callPackage ../development/python-modules/aiobroadlink { };

  aiohue = callPackage ../development/python-modules/aiohue { };

  aiohwenergy = callPackage ../development/python-modules/aiohwenergy { };

  aioimaplib = callPackage ../development/python-modules/aioimaplib { };

  aioinflux = callPackage ../development/python-modules/aioinflux { };

  aiojobs = callPackage ../development/python-modules/aiojobs { };

  aiokafka = callPackage ../development/python-modules/aiokafka { };

  aiokef = callPackage ../development/python-modules/aiokef { };

  aiolookin = callPackage ../development/python-modules/aiolookin { };

  aiolifx = callPackage ../development/python-modules/aiolifx { };

  aiolifx-connection = callPackage ../development/python-modules/aiolifx-connection { };

  aiolifx-effects = callPackage ../development/python-modules/aiolifx-effects { };

  aiolifx-themes = callPackage ../development/python-modules/aiolifx-themes { };

  aiolimiter = callPackage ../development/python-modules/aiolimiter { };

  aiolip = callPackage ../development/python-modules/aiolip { };

  aiolivisi = callPackage ../development/python-modules/aiolivisi { };

  aiolyric = callPackage ../development/python-modules/aiolyric { };

  aiomisc = callPackage ../development/python-modules/aiomisc { };

  aiomisc-pytest = callPackage ../development/python-modules/aiomisc-pytest { };

  aiomodernforms = callPackage ../development/python-modules/aiomodernforms { };

  aiomqtt = callPackage ../development/python-modules/aiomqtt { };

  aiomultiprocess = callPackage ../development/python-modules/aiomultiprocess { };

  aiomusiccast = callPackage ../development/python-modules/aiomusiccast { };

  aiomysensors = callPackage ../development/python-modules/aiomysensors { };

  aiomysql = callPackage ../development/python-modules/aiomysql { };

  aionanoleaf = callPackage ../development/python-modules/aionanoleaf { };

  aionotion = callPackage ../development/python-modules/aionotion { };

  aiooncue = callPackage ../development/python-modules/aiooncue { };

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

  aiortm = callPackage ../development/python-modules/aiortm { };

  aiortsp = callPackage ../development/python-modules/aiortsp { };

  aioruckus = callPackage ../development/python-modules/aioruckus { };

  aiorun = callPackage ../development/python-modules/aiorun { };

  aioruuvigateway = callPackage ../development/python-modules/aioruuvigateway { };

  aiorwlock = callPackage ../development/python-modules/aiorwlock { };

  aiosasl = callPackage ../development/python-modules/aiosasl { };

  aiosql = callPackage ../development/python-modules/aiosql { };

  aiosenz = callPackage ../development/python-modules/aiosenz { };

  aioserial = callPackage ../development/python-modules/aioserial { };

  aioshelly = callPackage ../development/python-modules/aioshelly { };

  aioshutil = callPackage ../development/python-modules/aioshutil { };

  aioskybell = callPackage ../development/python-modules/aioskybell { };

  aiosignal = callPackage ../development/python-modules/aiosignal { };

  aioslimproto = callPackage ../development/python-modules/aioslimproto { };

  aiosmb = callPackage ../development/python-modules/aiosmb { };

  aiosmtpd = callPackage ../development/python-modules/aiosmtpd { };

  aiosmtplib = callPackage ../development/python-modules/aiosmtplib { };

  aiosomecomfort = callPackage ../development/python-modules/aiosomecomfort { };

  aiosqlite = callPackage ../development/python-modules/aiosqlite { };

  aiosteamist = callPackage ../development/python-modules/aiosteamist { };

  aiostream = callPackage ../development/python-modules/aiostream { };

  aioswitcher = callPackage ../development/python-modules/aioswitcher { };

  aiosyncthing = callPackage ../development/python-modules/aiosyncthing { };

  aiotankerkoenig = callPackage ../development/python-modules/aiotankerkoenig { };

  aiotractive = callPackage ../development/python-modules/aiotractive { };

  aiounifi = callPackage ../development/python-modules/aiounifi { };

  aiounittest = callPackage ../development/python-modules/aiounittest { };

  aiovlc = callPackage ../development/python-modules/aiovlc { };

  aiovodafone = callPackage ../development/python-modules/aiovodafone { };

  aiowatttime = callPackage ../development/python-modules/aiowatttime { };

  aiowaqi = callPackage ../development/python-modules/aiowaqi { };

  aioweenect = callPackage ../development/python-modules/aioweenect { };

  aiowebostv = callPackage ../development/python-modules/aiowebostv { };

  aiowinreg = callPackage ../development/python-modules/aiowinreg { };

  aiowithings = callPackage ../development/python-modules/aiowithings { };

  aioxmpp = callPackage ../development/python-modules/aioxmpp { };

  aioymaps = callPackage ../development/python-modules/aioymaps { };

  aiozeroconf = callPackage ../development/python-modules/aiozeroconf { };

  airium = callPackage ../development/python-modules/airium { };

  airly = callPackage ../development/python-modules/airly { };

  airthings-ble = callPackage ../development/python-modules/airthings-ble { };

  airthings-cloud = callPackage ../development/python-modules/airthings-cloud { };

  airtouch4pyapi = callPackage ../development/python-modules/airtouch4pyapi { };

  ajpy = callPackage ../development/python-modules/ajpy { };

  ajsonrpc = callPackage ../development/python-modules/ajsonrpc { };

  alabaster = callPackage ../development/python-modules/alabaster { };

  aladdin-connect = callPackage ../development/python-modules/aladdin-connect { };

  alarmdecoder = callPackage ../development/python-modules/alarmdecoder { };

  albumentations = callPackage ../development/python-modules/albumentations { };

  ale-py = callPackage ../development/python-modules/ale-py { };

  alectryon = callPackage ../development/python-modules/alectryon { };

  alembic = callPackage ../development/python-modules/alembic { };

  alexapy = callPackage ../development/python-modules/alexapy { };

  algebraic-data-types = callPackage ../development/python-modules/algebraic-data-types { };

  alive-progress = callPackage ../development/python-modules/alive-progress { };

  aliyun-python-sdk-cdn = callPackage ../development/python-modules/aliyun-python-sdk-cdn { };

  aliyun-python-sdk-config = callPackage ../development/python-modules/aliyun-python-sdk-config { };

  aliyun-python-sdk-core = callPackage ../development/python-modules/aliyun-python-sdk-core { };

  aliyun-python-sdk-dbfs = callPackage ../development/python-modules/aliyun-python-sdk-dbfs { };

  aliyun-python-sdk-iot = callPackage ../development/python-modules/aliyun-python-sdk-iot { };

  aliyun-python-sdk-kms = callPackage ../development/python-modules/aliyun-python-sdk-kms { };

  aliyun-python-sdk-sts = callPackage ../development/python-modules/aliyun-python-sdk-sts { };

  allpairspy = callPackage ../development/python-modules/allpairspy { };

  allure-behave = callPackage ../development/python-modules/allure-behave { };

  allure-python-commons = callPackage ../development/python-modules/allure-python-commons { };

  allure-python-commons-test = callPackage ../development/python-modules/allure-python-commons-test { };

  allure-pytest = callPackage ../development/python-modules/allure-pytest { };

  alpha-vantage = callPackage ../development/python-modules/alpha-vantage { };

  altair = callPackage ../development/python-modules/altair { };

  altgraph = callPackage ../development/python-modules/altgraph { };

  amarna = callPackage ../development/python-modules/amarna { };

  amazon-ion = callPackage ../development/python-modules/amazon-ion { };

  amazon-kclpy = callPackage ../development/python-modules/amazon-kclpy { };

  ambee = callPackage ../development/python-modules/ambee { };

  amberelectric = callPackage ../development/python-modules/amberelectric { };

  ambiclimate = callPackage ../development/python-modules/ambiclimate { };

  amcrest = callPackage ../development/python-modules/amcrest { };

  amiibo-py = callPackage ../development/python-modules/amiibo-py { };

  amply = callPackage ../development/python-modules/amply { };

  amqp = callPackage ../development/python-modules/amqp { };

  amqplib = callPackage ../development/python-modules/amqplib { };

  amqtt = callPackage ../development/python-modules/amqtt { };

  anchor-kr = callPackage ../development/python-modules/anchor-kr { };

  ancp-bids = callPackage ../development/python-modules/ancp-bids { };

  android-backup = callPackage ../development/python-modules/android-backup { };

  androidtv = callPackage ../development/python-modules/androidtv { };

  androidtvremote2 = callPackage ../development/python-modules/androidtvremote2 { };

  androguard = callPackage ../development/python-modules/androguard { };

  anel-pwrctrl-homeassistant = callPackage ../development/python-modules/anel-pwrctrl-homeassistant { };

  angr = callPackage ../development/python-modules/angr { };

  angrcli = callPackage ../development/python-modules/angrcli {
    inherit (pkgs) coreutils;
  };

  angrop = callPackage ../development/python-modules/angrop { };

  aniso8601 = callPackage ../development/python-modules/aniso8601 { };

  anitopy = callPackage ../development/python-modules/anitopy { };

  annexremote = callPackage ../development/python-modules/annexremote { };

  annotated-types = callPackage ../development/python-modules/annotated-types { };

  annoy = callPackage ../development/python-modules/annoy { };

  anonip = callPackage ../development/python-modules/anonip { };

  anova-wifi = callPackage ../development/python-modules/anova-wifi { };

  ansi2html = callPackage ../development/python-modules/ansi2html { };

  ansi2image = callPackage ../development/python-modules/ansi2image { };

  ansible = callPackage ../development/python-modules/ansible { };

  ansible-compat = callPackage ../development/python-modules/ansible-compat { };

  ansible-core = callPackage ../development/python-modules/ansible/core.nix { };

  ansible-kernel = callPackage ../development/python-modules/ansible-kernel { };

  ansible-pylibssh = callPackage ../development/python-modules/ansible-pylibssh { };

  ansible-runner = callPackage ../development/python-modules/ansible-runner { };

  ansible-vault-rw = callPackage ../development/python-modules/ansible-vault-rw { };

  ansi = callPackage ../development/python-modules/ansi { };

  ansicolor = callPackage ../development/python-modules/ansicolor { };

  ansicolors = callPackage ../development/python-modules/ansicolors { };

  ansiconv = callPackage ../development/python-modules/ansiconv { };

  ansimarkup = callPackage ../development/python-modules/ansimarkup { };

  ansiwrap = callPackage ../development/python-modules/ansiwrap { };

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

  anytree = callPackage ../development/python-modules/anytree {
    inherit (pkgs) graphviz;
  };

  anywidget = callPackage ../development/python-modules/anywidget { };

  aocd = callPackage ../development/python-modules/aocd { };

  aocd-example-parser = callPackage ../development/python-modules/aocd-example-parser { };

  apache-beam = callPackage ../development/python-modules/apache-beam { };

  apcaccess = callPackage ../development/python-modules/apcaccess { };

  apipkg = callPackage ../development/python-modules/apipkg { };

  apischema = callPackage ../development/python-modules/apischema { };

  apispec = callPackage ../development/python-modules/apispec { };

  apispec-webframeworks = callPackage ../development/python-modules/apispec-webframeworks { };

  apkinspector = callPackage ../development/python-modules/apkinspector { };

  apkit = callPackage ../development/python-modules/apkit { };

  aplpy = callPackage ../development/python-modules/aplpy { };

  app-model = callPackage ../development/python-modules/app-model { };

  appdirs = callPackage ../development/python-modules/appdirs { };

  apple-weatherkit = callPackage ../development/python-modules/apple-weatherkit { };

  applicationinsights = callPackage ../development/python-modules/applicationinsights { };

  appnope = callPackage ../development/python-modules/appnope { };

  apprise = callPackage ../development/python-modules/apprise { };

  approval-utilities = callPackage ../development/python-modules/approval-utilities { };

  approvaltests = callPackage ../development/python-modules/approvaltests { };

  apptools = callPackage ../development/python-modules/apptools { };

  appthreat-vulnerability-db = callPackage ../development/python-modules/appthreat-vulnerability-db { };

  apricot-select = callPackage ../development/python-modules/apricot-select { };

  aprslib = callPackage ../development/python-modules/aprslib { };

  apscheduler = callPackage ../development/python-modules/apscheduler { };

  apsw = callPackage ../development/python-modules/apsw { };

  apycula = callPackage ../development/python-modules/apycula { };

  aqipy-atmotech = callPackage ../development/python-modules/aqipy-atmotech { };

  aqualogic = callPackage ../development/python-modules/aqualogic { };

  arabic-reshaper = callPackage ../development/python-modules/arabic-reshaper { };

  aranet4 = callPackage ../development/python-modules/aranet4 { };

  arc4 = callPackage ../development/python-modules/arc4 { };

  arcam-fmj = callPackage ../development/python-modules/arcam-fmj { };

  archinfo = callPackage ../development/python-modules/archinfo { };

  archspec = callPackage ../development/python-modules/archspec { };

  area = callPackage ../development/python-modules/area { };

  arelle = callPackage ../development/python-modules/arelle {
    gui = true;
  };

  arelle-headless = callPackage ../development/python-modules/arelle {
    gui = false;
  };

  aresponses = callPackage ../development/python-modules/aresponses { };

  argcomplete = callPackage ../development/python-modules/argcomplete { };

  argh = callPackage ../development/python-modules/argh { };

  argilla = callPackage ../development/python-modules/argilla { };

  argon2-cffi = callPackage ../development/python-modules/argon2-cffi { };

  argon2-cffi-bindings = callPackage ../development/python-modules/argon2-cffi-bindings { };

  argostranslate = callPackage ../development/python-modules/argostranslate {
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  argos-translate-files = callPackage ../development/python-modules/argos-translate-files { };

  argparse-addons = callPackage ../development/python-modules/argparse-addons { };

  argparse-dataclass = callPackage ../development/python-modules/argparse-dataclass { };

  argparse-manpage = callPackage ../development/python-modules/argparse-manpage { };

  args = callPackage ../development/python-modules/args { };

  aria2p = callPackage ../development/python-modules/aria2p { };

  ariadne = callPackage ../development/python-modules/ariadne { };

  arpy = callPackage ../development/python-modules/arpy { };

  arnparse = callPackage ../development/python-modules/arnparse { };

  array-record = callPackage ../development/python-modules/array-record { };

  arrayqueues = callPackage ../development/python-modules/arrayqueues { };

  arris-tg2492lg = callPackage ../development/python-modules/arris-tg2492lg { };

  arrow = callPackage ../development/python-modules/arrow { };

  arsenic = callPackage ../development/python-modules/arsenic { };

  art = callPackage ../development/python-modules/art { };

  arviz = callPackage ../development/python-modules/arviz { };

  arxiv2bib = callPackage ../development/python-modules/arxiv2bib { };

  asana = callPackage ../development/python-modules/asana { };

  ascii-magic = callPackage ../development/python-modules/ascii-magic { };

  asciimatics = callPackage ../development/python-modules/asciimatics { };

  asciitree = callPackage ../development/python-modules/asciitree { };

  asdf = callPackage ../development/python-modules/asdf { };

  asdf-standard = callPackage ../development/python-modules/asdf-standard { };

  asdf-transform-schemas = callPackage ../development/python-modules/asdf-transform-schemas { };

  ase = callPackage ../development/python-modules/ase { };

  asf-search = callPackage ../development/python-modules/asf-search { };

  asgi-csrf = callPackage ../development/python-modules/asgi-csrf { };

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

  aspy-yaml = callPackage ../development/python-modules/aspy.yaml { };

  assay = callPackage ../development/python-modules/assay { };

  assertpy = callPackage ../development/python-modules/assertpy { };

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

  astropy-extension-helpers = callPackage ../development/python-modules/astropy-extension-helpers { };

  astroquery = callPackage ../development/python-modules/astroquery { };

  asttokens = callPackage ../development/python-modules/asttokens { };

  astunparse = callPackage ../development/python-modules/astunparse { };

  asyauth = callPackage ../development/python-modules/asyauth { };

  async-dns = callPackage ../development/python-modules/async-dns { };

  async-generator = callPackage ../development/python-modules/async-generator { };

  async-interrupt = callPackage ../development/python-modules/async-interrupt { };

  async-lru = callPackage ../development/python-modules/async-lru { };

  async-modbus = callPackage ../development/python-modules/async-modbus { };

  asyncclick = callPackage ../development/python-modules/asyncclick { };

  asynccmd = callPackage ../development/python-modules/asynccmd { };

  asyncinotify = callPackage ../development/python-modules/asyncinotify { };

  asyncio-dgram = callPackage ../development/python-modules/asyncio-dgram { };

  asyncio-mqtt = callPackage ../development/python-modules/asyncio-mqtt { };

  asyncio-rlock = callPackage ../development/python-modules/asyncio-rlock { };

  asyncmy = callPackage ../development/python-modules/asyncmy { };

  asyncio-throttle = callPackage ../development/python-modules/asyncio-throttle { };

  asyncpg = callPackage ../development/python-modules/asyncpg { };

  asyncserial = callPackage ../development/python-modules/asyncserial { };

  asyncsleepiq = callPackage ../development/python-modules/asyncsleepiq { };

  asyncssh = callPackage ../development/python-modules/asyncssh { };

  asyncstdlib = callPackage ../development/python-modules/asyncstdlib { };

  async-stagger = callPackage ../development/python-modules/async-stagger { };

  asynctest = callPackage ../development/python-modules/asynctest { };

  async-timeout = callPackage ../development/python-modules/async-timeout { };

  async-tkinter-loop = callPackage ../development/python-modules/async-tkinter-loop { };

  asyncua = callPackage ../development/python-modules/asyncua { };

  async-upnp-client = callPackage ../development/python-modules/async-upnp-client { };

  asyncwhois = callPackage ../development/python-modules/asyncwhois { };

  asysocks = callPackage ../development/python-modules/asysocks { };

  atc-ble = callPackage ../development/python-modules/atc-ble { };

  atenpdu = callPackage ../development/python-modules/atenpdu { };

  atlassian-python-api = callPackage ../development/python-modules/atlassian-python-api { };

  atom = callPackage ../development/python-modules/atom { };

  atomiclong = callPackage ../development/python-modules/atomiclong { };

  atomicwrites = callPackage ../development/python-modules/atomicwrites { };

  atomicwrites-homeassistant = callPackage ../development/python-modules/atomicwrites-homeassistant { };

  atomman = callPackage ../development/python-modules/atomman { };

  atpublic = callPackage ../development/python-modules/atpublic { };

  atsim-potentials = callPackage ../development/python-modules/atsim-potentials { };

  attrdict = callPackage ../development/python-modules/attrdict { };

  attrs = callPackage ../development/python-modules/attrs { };

  aubio = callPackage ../development/python-modules/aubio { };

  audible = callPackage ../development/python-modules/audible { };

  audio-metadata = callPackage ../development/python-modules/audio-metadata { };

  audioread = callPackage ../development/python-modules/audioread { };

  audiotools = callPackage ../development/python-modules/audiotools {
    inherit (pkgs.darwin.apple_sdk.frameworks) AudioToolbox AudioUnit CoreServices;
  };

  auditok = callPackage ../development/python-modules/auditok { };

  auditwheel = callPackage ../development/python-modules/auditwheel {
    inherit (pkgs) bzip2 gnutar patchelf unzip;
  };

  augeas = callPackage ../development/python-modules/augeas {
    inherit (pkgs) augeas;
  };

  augmax = callPackage ../development/python-modules/augmax { };

  auroranoaa = callPackage ../development/python-modules/auroranoaa { };

  aurorapy = callPackage ../development/python-modules/aurorapy { };

  autarco = callPackage ../development/python-modules/autarco { };

  auth0-python = callPackage ../development/python-modules/auth0-python { };

  authcaptureproxy = callPackage ../development/python-modules/authcaptureproxy { };

  authheaders = callPackage ../development/python-modules/authheaders { };

  authlib = callPackage ../development/python-modules/authlib { };

  authres = callPackage ../development/python-modules/authres { };

  autobahn = callPackage ../development/python-modules/autobahn { };

  autocommand = callPackage ../development/python-modules/autocommand { };

  autofaiss = callPackage ../development/python-modules/autofaiss { };

  autoflake = callPackage ../development/python-modules/autoflake { };

  autograd = callPackage ../development/python-modules/autograd { };

  autograd-gamma = callPackage ../development/python-modules/autograd-gamma { };

  autoit-ripper = callPackage ../development/python-modules/autoit-ripper { };

  autologging = callPackage ../development/python-modules/autologging { };

  automat = callPackage ../development/python-modules/automat { };

  automate-home = callPackage ../development/python-modules/automate-home { };

  automx2 = callPackage ../development/python-modules/automx2 { };

  autopage = callPackage ../development/python-modules/autopage { };

  autopep8 = callPackage ../development/python-modules/autopep8 { };

  autoslot = callPackage ../development/python-modules/autoslot { };

  avahi = toPythonModule (pkgs.avahi.override {
    inherit python;
    withPython = true;
  });

  av = callPackage ../development/python-modules/av { };

  avea = callPackage ../development/python-modules/avea { };

 avidtools = callPackage ../development/python-modules/avidtools { };

  avion = callPackage ../development/python-modules/avion { };

  avro3k = callPackage ../development/python-modules/avro3k { };

  avro = callPackage ../development/python-modules/avro { };

  avro-python3 = callPackage ../development/python-modules/avro-python3 { };

  aw-client = callPackage ../development/python-modules/aw-client { };

  aw-core = callPackage ../development/python-modules/aw-core { };

  awacs = callPackage ../development/python-modules/awacs { };

  awesome-slugify = callPackage ../development/python-modules/awesome-slugify { };

  awesomeversion = callPackage ../development/python-modules/awesomeversion { };

  awkward = callPackage ../development/python-modules/awkward { };

  awkward-cpp = callPackage ../development/python-modules/awkward-cpp {
    inherit (pkgs) cmake ninja;
  };

  aws-adfs = callPackage ../development/python-modules/aws-adfs { };

  aws-encryption-sdk = callPackage ../development/python-modules/aws-encryption-sdk { };

  aws-lambda-builders = callPackage ../development/python-modules/aws-lambda-builders { };

  aws-sam-translator = callPackage ../development/python-modules/aws-sam-translator { };

  aws-secretsmanager-caching = callPackage ../development/python-modules/aws-secretsmanager-caching { };

  aws-xray-sdk = callPackage ../development/python-modules/aws-xray-sdk { };

  awscrt = callPackage ../development/python-modules/awscrt {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation Security;
  };

  awsiotpythonsdk = callPackage ../development/python-modules/awsiotpythonsdk { };

  awsipranges = callPackage ../development/python-modules/awsipranges { };

  awslambdaric = callPackage ../development/python-modules/awslambdaric { };

  awswrangler = callPackage ../development/python-modules/awswrangler { };

  ax = callPackage ../development/python-modules/ax { };

  axis = callPackage ../development/python-modules/axis { };

  axisregistry = callPackage ../development/python-modules/axisregistry { };

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

  azure-functions-devops-build = callPackage ../development/python-modules/azure-functions-devops-build { };

  azure-graphrbac = callPackage ../development/python-modules/azure-graphrbac { };

  azure-identity = callPackage ../development/python-modules/azure-identity { };

  azure-keyvault = callPackage ../development/python-modules/azure-keyvault { };

  azure-keyvault-administration = callPackage ../development/python-modules/azure-keyvault-administration { };

  azure-keyvault-certificates = callPackage ../development/python-modules/azure-keyvault-certificates { };

  azure-keyvault-keys = callPackage ../development/python-modules/azure-keyvault-keys { };

  azure-keyvault-nspkg = callPackage ../development/python-modules/azure-keyvault-nspkg { };

  azure-keyvault-secrets = callPackage ../development/python-modules/azure-keyvault-secrets { };

  azure-loganalytics = callPackage ../development/python-modules/azure-loganalytics { };

  azure-mgmt-advisor = callPackage ../development/python-modules/azure-mgmt-advisor { };

  azure-mgmt-apimanagement = callPackage ../development/python-modules/azure-mgmt-apimanagement { };

  azure-mgmt-appconfiguration = callPackage ../development/python-modules/azure-mgmt-appconfiguration { };

  azure-mgmt-appcontainers = callPackage ../development/python-modules/azure-mgmt-appcontainers { };

  azure-mgmt-applicationinsights = callPackage ../development/python-modules/azure-mgmt-applicationinsights { };

  azure-mgmt-authorization = callPackage ../development/python-modules/azure-mgmt-authorization { };

  azure-mgmt-batchai = callPackage ../development/python-modules/azure-mgmt-batchai { };

  azure-mgmt-batch = callPackage ../development/python-modules/azure-mgmt-batch { };

  azure-mgmt-billing = callPackage ../development/python-modules/azure-mgmt-billing { };

  azure-mgmt-botservice = callPackage ../development/python-modules/azure-mgmt-botservice { };

  azure-mgmt-cdn = callPackage ../development/python-modules/azure-mgmt-cdn { };

  azure-mgmt-cognitiveservices = callPackage ../development/python-modules/azure-mgmt-cognitiveservices { };

  azure-mgmt-commerce = callPackage ../development/python-modules/azure-mgmt-commerce { };

  azure-mgmt-common = callPackage ../development/python-modules/azure-mgmt-common { };

  azure-mgmt-compute = callPackage ../development/python-modules/azure-mgmt-compute { };

  azure-mgmt-consumption = callPackage ../development/python-modules/azure-mgmt-consumption { };

  azure-mgmt-containerinstance = callPackage ../development/python-modules/azure-mgmt-containerinstance { };

  azure-mgmt-containerregistry = callPackage ../development/python-modules/azure-mgmt-containerregistry { };

  azure-mgmt-containerservice = callPackage ../development/python-modules/azure-mgmt-containerservice { };

  azure-mgmt-core = callPackage ../development/python-modules/azure-mgmt-core { };

  azure-mgmt-cosmosdb = callPackage ../development/python-modules/azure-mgmt-cosmosdb { };

  azure-mgmt-databoxedge = callPackage ../development/python-modules/azure-mgmt-databoxedge { };

  azure-mgmt-datafactory = callPackage ../development/python-modules/azure-mgmt-datafactory { };

  azure-mgmt-datalake-analytics = callPackage ../development/python-modules/azure-mgmt-datalake-analytics { };

  azure-mgmt-datalake-nspkg = callPackage ../development/python-modules/azure-mgmt-datalake-nspkg { };

  azure-mgmt-datalake-store = callPackage ../development/python-modules/azure-mgmt-datalake-store { };

  azure-mgmt-datamigration = callPackage ../development/python-modules/azure-mgmt-datamigration { };

  azure-mgmt-deploymentmanager = callPackage ../development/python-modules/azure-mgmt-deploymentmanager { };

  azure-mgmt-devspaces = callPackage ../development/python-modules/azure-mgmt-devspaces { };

  azure-mgmt-devtestlabs = callPackage ../development/python-modules/azure-mgmt-devtestlabs { };

  azure-mgmt-dns = callPackage ../development/python-modules/azure-mgmt-dns { };

  azure-mgmt-eventgrid = callPackage ../development/python-modules/azure-mgmt-eventgrid { };

  azure-mgmt-eventhub = callPackage ../development/python-modules/azure-mgmt-eventhub { };

  azure-mgmt-extendedlocation = callPackage ../development/python-modules/azure-mgmt-extendedlocation { };

  azure-mgmt-frontdoor = callPackage ../development/python-modules/azure-mgmt-frontdoor { };

  azure-mgmt-hanaonazure = callPackage ../development/python-modules/azure-mgmt-hanaonazure { };

  azure-mgmt-hdinsight = callPackage ../development/python-modules/azure-mgmt-hdinsight { };

  azure-mgmt-imagebuilder = callPackage ../development/python-modules/azure-mgmt-imagebuilder { };

  azure-mgmt-iotcentral = callPackage ../development/python-modules/azure-mgmt-iotcentral { };

  azure-mgmt-iothub = callPackage ../development/python-modules/azure-mgmt-iothub { };

  azure-mgmt-iothubprovisioningservices = callPackage ../development/python-modules/azure-mgmt-iothubprovisioningservices { };

  azure-mgmt-keyvault = callPackage ../development/python-modules/azure-mgmt-keyvault { };

  azure-mgmt-kusto = callPackage ../development/python-modules/azure-mgmt-kusto { };

  azure-mgmt-loganalytics = callPackage ../development/python-modules/azure-mgmt-loganalytics { };

  azure-mgmt-logic = callPackage ../development/python-modules/azure-mgmt-logic { };

  azure-mgmt-machinelearningcompute = callPackage ../development/python-modules/azure-mgmt-machinelearningcompute { };

  azure-mgmt-managedservices = callPackage ../development/python-modules/azure-mgmt-managedservices { };

  azure-mgmt-managementgroups = callPackage ../development/python-modules/azure-mgmt-managementgroups { };

  azure-mgmt-managementpartner = callPackage ../development/python-modules/azure-mgmt-managementpartner { };

  azure-mgmt-maps = callPackage ../development/python-modules/azure-mgmt-maps { };

  azure-mgmt-marketplaceordering = callPackage ../development/python-modules/azure-mgmt-marketplaceordering { };

  azure-mgmt-media = callPackage ../development/python-modules/azure-mgmt-media { };

  azure-mgmt-monitor = callPackage ../development/python-modules/azure-mgmt-monitor { };

  azure-mgmt-msi = callPackage ../development/python-modules/azure-mgmt-msi { };

  azure-mgmt-netapp = callPackage ../development/python-modules/azure-mgmt-netapp { };

  azure-mgmt-network = callPackage ../development/python-modules/azure-mgmt-network { };

  azure-mgmt-notificationhubs = callPackage ../development/python-modules/azure-mgmt-notificationhubs { };

  azure-mgmt-nspkg = callPackage ../development/python-modules/azure-mgmt-nspkg { };

  azure-mgmt-policyinsights = callPackage ../development/python-modules/azure-mgmt-policyinsights { };

  azure-mgmt-powerbiembedded = callPackage ../development/python-modules/azure-mgmt-powerbiembedded { };

  azure-mgmt-privatedns = callPackage ../development/python-modules/azure-mgmt-privatedns { };

  azure-mgmt-rdbms = callPackage ../development/python-modules/azure-mgmt-rdbms { };

  azure-mgmt-recoveryservicesbackup = callPackage ../development/python-modules/azure-mgmt-recoveryservicesbackup { };

  azure-mgmt-recoveryservices = callPackage ../development/python-modules/azure-mgmt-recoveryservices { };

  azure-mgmt-redhatopenshift = callPackage ../development/python-modules/azure-mgmt-redhatopenshift { };

  azure-mgmt-redis = callPackage ../development/python-modules/azure-mgmt-redis { };

  azure-mgmt-relay = callPackage ../development/python-modules/azure-mgmt-relay { };

  azure-mgmt-reservations = callPackage ../development/python-modules/azure-mgmt-reservations { };

  azure-mgmt-resource = callPackage ../development/python-modules/azure-mgmt-resource { };

  azure-mgmt-scheduler = callPackage ../development/python-modules/azure-mgmt-scheduler { };

  azure-mgmt-search = callPackage ../development/python-modules/azure-mgmt-search { };

  azure-mgmt-security = callPackage ../development/python-modules/azure-mgmt-security { };

  azure-mgmt-servicebus = callPackage ../development/python-modules/azure-mgmt-servicebus { };

  azure-mgmt-servicefabric = callPackage ../development/python-modules/azure-mgmt-servicefabric { };

  azure-mgmt-servicefabricmanagedclusters = callPackage ../development/python-modules/azure-mgmt-servicefabricmanagedclusters { };

  azure-mgmt-servicelinker = callPackage ../development/python-modules/azure-mgmt-servicelinker { };

  azure-mgmt-signalr = callPackage ../development/python-modules/azure-mgmt-signalr { };

  azure-mgmt-sql = callPackage ../development/python-modules/azure-mgmt-sql { };

  azure-mgmt-sqlvirtualmachine = callPackage ../development/python-modules/azure-mgmt-sqlvirtualmachine { };

  azure-mgmt-storage = callPackage ../development/python-modules/azure-mgmt-storage { };

  azure-mgmt-subscription = callPackage ../development/python-modules/azure-mgmt-subscription { };

  azure-mgmt-synapse = callPackage ../development/python-modules/azure-mgmt-synapse { };

  azure-mgmt-trafficmanager = callPackage ../development/python-modules/azure-mgmt-trafficmanager { };

  azure-mgmt-web = callPackage ../development/python-modules/azure-mgmt-web { };

  azure-monitor-ingestion = callPackage ../development/python-modules/azure-monitor-ingestion { };

  azure-multiapi-storage = callPackage ../development/python-modules/azure-multiapi-storage { };

  azure-nspkg = callPackage ../development/python-modules/azure-nspkg { };

  azure-servicebus = callPackage ../development/python-modules/azure-servicebus { };

  azure-servicefabric = callPackage ../development/python-modules/azure-servicefabric { };

  azure-servicemanagement-legacy = callPackage ../development/python-modules/azure-servicemanagement-legacy { };

  azure-storage-blob = callPackage ../development/python-modules/azure-storage-blob { };

  azure-storage-common = callPackage ../development/python-modules/azure-storage-common { };

  azure-storage-file = callPackage ../development/python-modules/azure-storage-file { };

  azure-storage-file-share = callPackage ../development/python-modules/azure-storage-file-share { };

  azure-storage-nspkg = callPackage ../development/python-modules/azure-storage-nspkg { };

  azure-storage-queue = callPackage ../development/python-modules/azure-storage-queue { };

  azure-synapse-accesscontrol = callPackage ../development/python-modules/azure-synapse-accesscontrol { };

  azure-synapse-artifacts = callPackage ../development/python-modules/azure-synapse-artifacts { };

  azure-synapse-managedprivateendpoints = callPackage ../development/python-modules/azure-synapse-managedprivateendpoints { };

  azure-synapse-spark = callPackage ../development/python-modules/azure-synapse-spark { };

  b2sdk = callPackage ../development/python-modules/b2sdk { };

  babel = callPackage ../development/python-modules/babel { };

  babelfish = callPackage ../development/python-modules/babelfish { };

  babelfont = callPackage ../development/python-modules/babelfont { };

  babelgladeextractor = callPackage ../development/python-modules/babelgladeextractor { };

  bambi = callPackage ../development/python-modules/bambi { };

  pad4pi = callPackage ../development/python-modules/pad4pi { };

  paddle-bfloat = callPackage ../development/python-modules/paddle-bfloat { };

  paddle2onnx = callPackage ../development/python-modules/paddle2onnx { };

  paddleocr = callPackage ../development/python-modules/paddleocr { };

  paddlepaddle = callPackage ../development/python-modules/paddlepaddle { };

  pueblo = callPackage ../development/python-modules/pueblo { };

  pulumi = callPackage ../development/python-modules/pulumi { inherit (pkgs) pulumi; };

  pulumi-aws = callPackage ../development/python-modules/pulumi-aws { };

  pulumi-aws-native = pkgs.pulumiPackages.pulumi-aws-native.sdks.python;

  pulumi-azure-native = pkgs.pulumiPackages.pulumi-azure-native.sdks.python;

  pulumi-command = pkgs.pulumiPackages.pulumi-command.sdks.python;

  pulumi-random = pkgs.pulumiPackages.pulumi-random.sdks.python;

  backcall = callPackage ../development/python-modules/backcall { };

  backoff = callPackage ../development/python-modules/backoff { };

  backports-cached-property = callPackage ../development/python-modules/backports-cached-property { };

  backports-datetime-fromisoformat = callPackage ../development/python-modules/backports-datetime-fromisoformat { };

  backports-entry-points-selectable = callPackage ../development/python-modules/backports-entry-points-selectable { };

  backports_shutil_get_terminal_size = callPackage ../development/python-modules/backports_shutil_get_terminal_size { };

  backports-shutil-which = callPackage ../development/python-modules/backports-shutil-which { };

  backports-strenum = callPackage ../development/python-modules/backports-strenum { };

  backports-zoneinfo = callPackage ../development/python-modules/backports-zoneinfo { };

  bacpypes = callPackage ../development/python-modules/bacpypes { };

  bagit = callPackage ../development/python-modules/bagit { };

  banal = callPackage ../development/python-modules/banal { };

  bandcamp-api = callPackage ../development/python-modules/bandcamp-api { };

  bandit = callPackage ../development/python-modules/bandit { };

  bangla = callPackage ../development/python-modules/bangla { };

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

  baseline = callPackage ../development/python-modules/baseline { };

  baselines = callPackage ../development/python-modules/baselines { };

  basemap = callPackage ../development/python-modules/basemap { };

  basemap-data = callPackage ../development/python-modules/basemap-data { };

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

  bcdoc = callPackage ../development/python-modules/bcdoc { };

  bcf = callPackage ../development/python-modules/bcf { };

  bcg = callPackage ../development/python-modules/bcg { };

  bch = callPackage ../development/python-modules/bch { };

  bcrypt = if stdenv.hostPlatform.system == "i686-linux" then
    callPackage ../development/python-modules/bcrypt/3.nix { }
  else
    callPackage ../development/python-modules/bcrypt { };

  bdffont = callPackage ../development/python-modules/bdffont { };

  beaker = callPackage ../development/python-modules/beaker { };

  before-after = callPackage ../development/python-modules/before-after { };

  beancount = callPackage ../development/python-modules/beancount { };

  beancount-black = callPackage ../development/python-modules/beancount-black { };

  beancount-parser = callPackage ../development/python-modules/beancount-parser { };

  beancount-docverif = callPackage ../development/python-modules/beancount-docverif { };

  beanstalkc = callPackage ../development/python-modules/beanstalkc { };

  beartype = callPackage ../development/python-modules/beartype { };

  beautiful-date = callPackage ../development/python-modules/beautiful-date { };

  beautifulsoup4 = callPackage ../development/python-modules/beautifulsoup4 { };

  beautifultable = callPackage ../development/python-modules/beautifultable { };

  beautysh = callPackage ../development/python-modules/beautysh { };

  bech32 = callPackage ../development/python-modules/bech32 { };

  behave = callPackage ../development/python-modules/behave { };

  bellows = callPackage ../development/python-modules/bellows { };

  bencode-py = callPackage ../development/python-modules/bencode-py { };

  bencoder = callPackage ../development/python-modules/bencoder { };

  beniget = callPackage ../development/python-modules/beniget { };

  bentoml = callPackage ../development/python-modules/bentoml { };

  bespon = callPackage ../development/python-modules/bespon { };

  betacode = callPackage ../development/python-modules/betacode { };

  betamax = callPackage ../development/python-modules/betamax { };

  betamax-matchers = callPackage ../development/python-modules/betamax-matchers { };

  betamax-serializers = callPackage ../development/python-modules/betamax-serializers { };

  betterproto = callPackage ../development/python-modules/betterproto { };

  beziers = callPackage ../development/python-modules/beziers { };

  bibtexparser = callPackage ../development/python-modules/bibtexparser { };

  bidict = callPackage ../development/python-modules/bidict { };

  bids-validator = callPackage ../development/python-modules/bids-validator { };

  biliass = callPackage ../development/python-modules/biliass { };

  billiard = callPackage ../development/python-modules/billiard { };

  bimmer-connected = callPackage ../development/python-modules/bimmer-connected { };

  binary = callPackage ../development/python-modules/binary { };

  binary2strings = callPackage ../development/python-modules/binary2strings { };

  binaryornot = callPackage ../development/python-modules/binaryornot { };

  bincopy = callPackage ../development/python-modules/bincopy { };

  binho-host-adapter = callPackage ../development/python-modules/binho-host-adapter { };

  binwalk = callPackage ../development/python-modules/binwalk { };

  binwalk-full = self.binwalk.override { visualizationSupport = true; };

  biopandas = callPackage ../development/python-modules/biopandas { };

  biopython = callPackage ../development/python-modules/biopython { };

  biplist = callPackage ../development/python-modules/biplist { };

  bip-utils = callPackage ../development/python-modules/bip-utils { };

  bip32 = callPackage ../development/python-modules/bip32 { };

  birch = callPackage ../development/python-modules/birch { };

  bitarray = callPackage ../development/python-modules/bitarray { };

  bitbox02 = callPackage ../development/python-modules/bitbox02 { };

  bitcoinlib = callPackage ../development/python-modules/bitcoinlib { };

  bitcoin-utils-fork-minimal = callPackage ../development/python-modules/bitcoin-utils-fork-minimal { };

  bitcoinrpc = callPackage ../development/python-modules/bitcoinrpc { };

  bite-parser = callPackage ../development/python-modules/bite-parser { };

  bitlist = callPackage ../development/python-modules/bitlist { };

  bitmath = callPackage ../development/python-modules/bitmath { };

  bitsandbytes = callPackage ../development/python-modules/bitsandbytes { };

  bitstring = callPackage ../development/python-modules/bitstring { };

  bitstruct = callPackage ../development/python-modules/bitstruct { };

  bitvavo-aio = callPackage ../development/python-modules/bitvavo-aio { };

  bizkaibus = callPackage ../development/python-modules/bizkaibus { };

  bjoern = callPackage ../development/python-modules/bjoern { };

  bkcharts = callPackage ../development/python-modules/bkcharts { };

  black = callPackage ../development/python-modules/black { };

  blackjax = callPackage ../development/python-modules/blackjax { };

  black-macchiato = callPackage ../development/python-modules/black-macchiato { };

  bleach = callPackage ../development/python-modules/bleach { };

  bleach-allowlist = callPackage ../development/python-modules/bleach-allowlist { };

  bleak = callPackage ../development/python-modules/bleak { };

  bleak-esphome = callPackage ../development/python-modules/bleak-esphome { };

  bleak-retry-connector = callPackage ../development/python-modules/bleak-retry-connector { };

  blebox-uniapi = callPackage ../development/python-modules/blebox-uniapi { };

  bless = callPackage ../development/python-modules/bless { };

  blessed = callPackage ../development/python-modules/blessed { };

  blessings = callPackage ../development/python-modules/blessings { };

  blinker = callPackage ../development/python-modules/blinker { };

  blinkpy = callPackage ../development/python-modules/blinkpy { };

  blinkstick = callPackage ../development/python-modules/blinkstick { };

  blis = callPackage ../development/python-modules/blis { };

  blobfile = callPackage ../development/python-modules/blobfile { };

  blockchain = callPackage ../development/python-modules/blockchain { };

  blockdiag = callPackage ../development/python-modules/blockdiag { };

  block-io = callPackage ../development/python-modules/block-io { };

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

  bluetooth-data-tools= callPackage ../development/python-modules/bluetooth-data-tools { };

  bluetooth-sensor-state-data = callPackage ../development/python-modules/bluetooth-sensor-state-data { };

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

  boltons = callPackage ../development/python-modules/boltons { };

  boltztrap2 = callPackage ../development/python-modules/boltztrap2 { };

  bond-api = callPackage ../development/python-modules/bond-api { };

  bond-async = callPackage ../development/python-modules/bond-async { };

  bonsai = callPackage ../development/python-modules/bonsai { };

  booleanoperations = callPackage ../development/python-modules/booleanoperations { };

  boolean-py = callPackage ../development/python-modules/boolean-py { };

  # Build boost for this specific Python version
  # TODO: use separate output for libboost_python.so
  boost = toPythonModule (pkgs.boost.override {
    inherit (self) python numpy;
    enablePython = true;
  });

  borb = callPackage ../development/python-modules/borb { };

  bork = callPackage ../development/python-modules/bork { };

  boschshcpy = callPackage ../development/python-modules/boschshcpy { };

  bottombar = callPackage ../development/python-modules/bottombar { };

  boost-histogram = callPackage ../development/python-modules/boost-histogram {
    inherit (pkgs) boost;
  };

  boto3 = callPackage ../development/python-modules/boto3 { };

  boto3-stubs = callPackage ../development/python-modules/boto3-stubs { };

  boto = callPackage ../development/python-modules/boto { };

  botocore = callPackage ../development/python-modules/botocore { };

  botocore-stubs = callPackage ../development/python-modules/botocore-stubs { };

  botorch = callPackage ../development/python-modules/botorch { };

  bottle = callPackage ../development/python-modules/bottle { };

  bottleneck = callPackage ../development/python-modules/bottleneck { };

  boxx = callPackage ../development/python-modules/boxx { };

  bpemb = callPackage ../development/python-modules/bpemb { };

  bpycv = callPackage ../development/python-modules/bpycv {};

  bpython = callPackage ../development/python-modules/bpython { };

  bqplot = callPackage ../development/python-modules/bqplot { };

  bqscales = callPackage ../development/python-modules/bqscales { };

  braceexpand = callPackage ../development/python-modules/braceexpand { };

  bracex = callPackage ../development/python-modules/bracex { };

  braintree = callPackage ../development/python-modules/braintree { };

  branca = callPackage ../development/python-modules/branca { };

  bravado-core = callPackage ../development/python-modules/bravado-core { };

  bravia-tv = callPackage ../development/python-modules/bravia-tv { };

  breathe = callPackage ../development/python-modules/breathe { };

  breezy = callPackage ../development/python-modules/breezy { };

  brelpy = callPackage ../development/python-modules/brelpy { };

  brian2 = callPackage ../development/python-modules/brian2 { };

  broadbean = callPackage ../development/python-modules/broadbean { };

  broadlink = callPackage ../development/python-modules/broadlink { };

  brother = callPackage ../development/python-modules/brother { };

  brother-ql = callPackage ../development/python-modules/brother-ql { };

  brotli = callPackage ../development/python-modules/brotli { };

  brotli-asgi = callPackage ../development/python-modules/brotli-asgi { };

  brotlicffi = callPackage ../development/python-modules/brotlicffi {
    inherit (pkgs) brotli;
  };

  brotlipy = callPackage ../development/python-modules/brotlipy { };

  brottsplatskartan = callPackage ../development/python-modules/brottsplatskartan { };

  browser-cookie3 = callPackage ../development/python-modules/browser-cookie3 { };

  brunt = callPackage ../development/python-modules/brunt { };

  bsddb3 = callPackage ../development/python-modules/bsddb3 { };

  bsdiff4 = callPackage ../development/python-modules/bsdiff4 { };

  bson = callPackage ../development/python-modules/bson { };

  bsuite = callPackage ../development/python-modules/bsuite { };

  btchip-python = callPackage ../development/python-modules/btchip-python { };

  btest = callPackage ../development/python-modules/btest { };

  bthome-ble = callPackage ../development/python-modules/bthome-ble { };

  bt-proximity = callPackage ../development/python-modules/bt-proximity { };

  btrees = callPackage ../development/python-modules/btrees { };

  btrfs = callPackage ../development/python-modules/btrfs { };

  btrfsutil = callPackage ../development/python-modules/btrfsutil { };

  btsmarthub-devicelist = callPackage ../development/python-modules/btsmarthub-devicelist { };

  btsocket = callPackage ../development/python-modules/btsocket { };

  bucketstore = callPackage ../development/python-modules/bucketstore { };

  bugsnag = callPackage ../development/python-modules/bugsnag { };

  bugwarrior = callPackage ../development/python-modules/bugwarrior { };

  bugz = callPackage ../development/python-modules/bugz { };

  bugzilla = callPackage ../development/python-modules/bugzilla { };

  buienradar = callPackage ../development/python-modules/buienradar { };

  build = callPackage ../development/python-modules/build { };

  buildcatrust = callPackage ../development/python-modules/buildcatrust { };

  bumps = callPackage ../development/python-modules/bumps { };

  bunch = callPackage ../development/python-modules/bunch { };

  bundlewrap = callPackage ../development/python-modules/bundlewrap { };

  busypie = callPackage ../development/python-modules/busypie { };

  bx-py-utils = callPackage ../development/python-modules/bx-py-utils { };

  bx-python = callPackage ../development/python-modules/bx-python { };

  bwapy = callPackage ../development/python-modules/bwapy { };

  bytecode = callPackage ../development/python-modules/bytecode { };

  bytewax = callPackage ../development/python-modules/bytewax { };

  bz2file = callPackage ../development/python-modules/bz2file { };

  cachecontrol = callPackage ../development/python-modules/cachecontrol { };

  cached-ipaddress = callPackage ../development/python-modules/cached-ipaddress { };

  cached-property = callPackage ../development/python-modules/cached-property { };

  cachelib = callPackage ../development/python-modules/cachelib { };

  cachetools = callPackage ../development/python-modules/cachetools { };

  cachey = callPackage ../development/python-modules/cachey { };

  cachier = callPackage ../development/python-modules/cachier { };

  cachy = callPackage ../development/python-modules/cachy { };

  cadquery = callPackage ../development/python-modules/cadquery {
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
  };

  caffe = toPythonModule (pkgs.caffe.override {
    pythonSupport = true;
    inherit (self) python numpy boost;
  });

  caffeWithCuda = toPythonModule (pkgs.caffeWithCuda.override {
    pythonSupport = true;
    inherit (self) python numpy boost;
  });

  caio = callPackage ../development/python-modules/caio { };

  cairocffi = callPackage ../development/python-modules/cairocffi { };

  cairosvg = callPackage ../development/python-modules/cairosvg { };

  caldav = callPackage ../development/python-modules/caldav { };

  calver = callPackage ../development/python-modules/calver { };

  callee = callPackage ../development/python-modules/callee { };

  calmjs = callPackage ../development/python-modules/calmjs { };

  calmjs-parse = callPackage ../development/python-modules/calmjs-parse { };

  calmjs-types = callPackage ../development/python-modules/calmjs-types { };

  calysto = callPackage ../development/python-modules/calysto { };

  calysto-scheme = callPackage ../development/python-modules/calysto-scheme { };

  camel-converter = callPackage ../development/python-modules/camel-converter { };

  can = callPackage ../development/python-modules/can { };

  canals = callPackage ../development/python-modules/canals { };

  canmatrix = callPackage ../development/python-modules/canmatrix { };

  canonicaljson = callPackage ../development/python-modules/canonicaljson { };

  canopen = callPackage ../development/python-modules/canopen { };

  cantools = callPackage ../development/python-modules/cantools { };

  camelot = callPackage ../development/python-modules/camelot { };

  capstone = callPackage ../development/python-modules/capstone {
    inherit (pkgs) capstone;
  };

  captcha = callPackage ../development/python-modules/captcha { };

  capturer = callPackage ../development/python-modules/capturer { };

  carbon = callPackage ../development/python-modules/carbon { };

  cart = callPackage ../development/python-modules/cart { };

  cartopy = callPackage ../development/python-modules/cartopy { };

  casa-formats-io = callPackage ../development/python-modules/casa-formats-io { };

  casbin = callPackage ../development/python-modules/casbin { };

  case = callPackage ../development/python-modules/case { };

  cashaddress = callPackage ../development/python-modules/cashaddress { };

  cassandra-driver = callPackage ../development/python-modules/cassandra-driver { };

  castepxbin = callPackage ../development/python-modules/castepxbin { };

  casttube = callPackage ../development/python-modules/casttube { };

  catalogue = callPackage ../development/python-modules/catalogue { };

  catboost = callPackage ../development/python-modules/catboost {
    catboost = pkgs.catboost.override {
      pythonSupport = true;
      python3Packages = self;
    };
  };

  catppuccin = callPackage ../development/python-modules/catppuccin { };

  cattrs = callPackage ../development/python-modules/cattrs { };

  cbeams = callPackage ../misc/cbeams { };

  cbor2 = callPackage ../development/python-modules/cbor2 { };

  cbor = callPackage ../development/python-modules/cbor { };

  cccolutils = callPackage ../development/python-modules/cccolutils { };

  cdcs = callPackage ../development/python-modules/cdcs { };

  celery = callPackage ../development/python-modules/celery { };

  celery-redbeat = callPackage ../development/python-modules/celery-redbeat { };

  celery-singleton = callPackage ../development/python-modules/celery-singleton { };

  celery-types = callPackage ../development/python-modules/celery-types { };

  cement = callPackage ../development/python-modules/cement { };

  cemm = callPackage ../development/python-modules/cemm { };

  censys = callPackage ../development/python-modules/censys { };

  cexprtk = callPackage ../development/python-modules/cexprtk { };

  coffea = callPackage ../development/python-modules/coffea { };

  cohere = callPackage ../development/python-modules/cohere { };

  coincurve = callPackage ../development/python-modules/coincurve {
    inherit (pkgs) secp256k1;
  };

  comicon = callPackage ../development/python-modules/comicon { };

  command-runner = callPackage ../development/python-modules/command-runner { };

  connect-box = callPackage ../development/python-modules/connect-box { };

  connection-pool = callPackage ../development/python-modules/connection-pool { };

  connio = callPackage ../development/python-modules/connio { };

  conway-polynomials = callPackage ../development/python-modules/conway-polynomials {};

  correctionlib = callPackage ../development/python-modules/correctionlib { };

  coqpit = callPackage ../development/python-modules/coqpit { };

  cepa = callPackage ../development/python-modules/cepa { };

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

  certifi = callPackage ../development/python-modules/certifi { };

  certipy = callPackage ../development/python-modules/certipy { };

  certipy-ad = callPackage ../development/python-modules/certipy-ad { };

  certomancer = callPackage ../development/python-modules/certomancer { };

  certvalidator = callPackage ../development/python-modules/certvalidator { };

  cf-xarray = callPackage ../development/python-modules/cf-xarray { };

  cffconvert = callPackage ../development/python-modules/cffconvert { };

  cffi = callPackage ../development/python-modules/cffi { };

  cffsubr = callPackage ../development/python-modules/cffsubr { };

  cfgv = callPackage ../development/python-modules/cfgv { };

  cfn-flip = callPackage ../development/python-modules/cfn-flip { };

  cfn-lint = callPackage ../development/python-modules/cfn-lint { };

  cfscrape = callPackage ../development/python-modules/cfscrape { };

  cftime = callPackage ../development/python-modules/cftime { };

  cgen = callPackage ../development/python-modules/cgen { };

  cgroup-utils = callPackage ../development/python-modules/cgroup-utils { };

  chacha20poly1305 = callPackage ../development/python-modules/chacha20poly1305 { };

  chacha20poly1305-reuseable = callPackage ../development/python-modules/chacha20poly1305-reuseable { };

  chai = callPackage ../development/python-modules/chai { };

  chainer = callPackage ../development/python-modules/chainer {
    inherit (pkgs.config) cudaSupport;
  };

  chainmap = callPackage ../development/python-modules/chainmap { };

  chainstream = callPackage ../development/python-modules/chainstream { };

  chalice = callPackage ../development/python-modules/chalice { };

  chameleon = callPackage ../development/python-modules/chameleon { };

  channels = callPackage ../development/python-modules/channels { };

  channels-redis = callPackage ../development/python-modules/channels-redis { };

  characteristic = callPackage ../development/python-modules/characteristic { };

  character-encoding-utils = callPackage ../development/python-modules/character-encoding-utils { };

  chardet = callPackage ../development/python-modules/chardet { };

  charset-normalizer = callPackage ../development/python-modules/charset-normalizer { };

  chart-studio = callPackage ../development/python-modules/chart-studio { };

  chat-downloader = callPackage ../development/python-modules/chat-downloader { };

  check-manifest = callPackage ../development/python-modules/check-manifest { };

  checkdmarc = callPackage ../development/python-modules/checkdmarc { };

  checksumdir = callPackage ../development/python-modules/checksumdir { };

  cheetah3 = callPackage ../development/python-modules/cheetah3 { };

  cheroot = callPackage ../development/python-modules/cheroot { };

  cherrypy = callPackage ../development/python-modules/cherrypy { };

  cherrypy-cors = callPackage ../development/python-modules/cherrypy-cors { };

  chess = callPackage ../development/python-modules/chess { };

  chevron = callPackage ../development/python-modules/chevron { };

  chex = callPackage ../development/python-modules/chex { };

  chiabip158 = throw "chiabip158 has been removed. see https://github.com/NixOS/nixpkgs/pull/270254";

  chiapos = throw "chiapos has been removed. see https://github.com/NixOS/nixpkgs/pull/270254";

  chiavdf = throw "chiavdf has been removed. see https://github.com/NixOS/nixpkgs/pull/270254";

  chia-rs = throw "chia-rs has been removed. see https://github.com/NixOS/nixpkgs/pull/270254";

  chirpstack-api = callPackage ../development/python-modules/chirpstack-api { };

  chispa = callPackage ../development/python-modules/chispa { };

  chroma-hnswlib = callPackage ../development/python-modules/chroma-hnswlib { };

  chromadb = callPackage ../development/python-modules/chromadb { };

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

  cirq-ft = callPackage ../development/python-modules/cirq-ft { };

  cirq-ionq = callPackage ../development/python-modules/cirq-ionq { };

  cirq-google = callPackage ../development/python-modules/cirq-google { };

  cirq-rigetti = callPackage ../development/python-modules/cirq-rigetti { };

  cirq-pasqal = callPackage ../development/python-modules/cirq-pasqal { };

  cirq-web = callPackage ../development/python-modules/cirq-web { };

  ciscoconfparse = callPackage ../development/python-modules/ciscoconfparse { };

  ciscomobilityexpress = callPackage ../development/python-modules/ciscomobilityexpress { };

  ciso8601 = callPackage ../development/python-modules/ciso8601 { };

  citeproc-py = callPackage ../development/python-modules/citeproc-py { };

  cjkwrap = callPackage ../development/python-modules/cjkwrap { };

  ckcc-protocol = callPackage ../development/python-modules/ckcc-protocol { };

  clarabel = callPackage ../development/python-modules/clarabel { };

  clarifai = callPackage ../development/python-modules/clarifai { };

  clarifai-grpc = callPackage ../development/python-modules/clarifai-grpc { };

  claripy = callPackage ../development/python-modules/claripy { };

  classify-imports = callPackage ../development/python-modules/classify-imports { };

  cld2-cffi = callPackage ../development/python-modules/cld2-cffi { };

  cle = callPackage ../development/python-modules/cle { };

  clean-fid = callPackage ../development/python-modules/clean-fid { };

  cleanlab = callPackage ../development/python-modules/cleanlab { };

  cleo = callPackage ../development/python-modules/cleo { };

  clevercsv = callPackage ../development/python-modules/clevercsv { };

  clf = callPackage ../development/python-modules/clf { };

  clip = callPackage ../development/python-modules/clip { };

  clip-anytorch = callPackage ../development/python-modules/clip-anytorch { };

  clr-loader = callPackage ../development/python-modules/clr-loader { };

  cock = callPackage ../development/python-modules/cock { };

  cobs = callPackage ../development/python-modules/cobs { };

  class-doc = callPackage ../development/python-modules/class-doc { };

  cliche = callPackage ../development/python-modules/cliche { };

  click = callPackage ../development/python-modules/click { };

  clickclick = callPackage ../development/python-modules/clickclick { };

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

  click-shell = callPackage ../development/python-modules/click-shell { };

  click-spinner = callPackage ../development/python-modules/click-spinner { };

  click-repl = callPackage ../development/python-modules/click-repl { };

  click-threading = callPackage ../development/python-modules/click-threading { };

  clickgen = callPackage ../development/python-modules/clickgen { };

  clickhouse-cityhash = callPackage ../development/python-modules/clickhouse-cityhash { };

  clickhouse-cli = callPackage ../development/python-modules/clickhouse-cli { };

  clickhouse-connect = callPackage ../development/python-modules/clickhouse-connect { };

  clickhouse-driver = callPackage ../development/python-modules/clickhouse-driver { };

  cliff = callPackage ../development/python-modules/cliff { };

  clifford = callPackage ../development/python-modules/clifford { };

  cligj = callPackage ../development/python-modules/cligj { };

  cli-helpers = callPackage ../development/python-modules/cli-helpers { };

  clikit = callPackage ../development/python-modules/clikit { };

  clint = callPackage ../development/python-modules/clint { };

  clintermission = callPackage ../development/python-modules/clintermission { };

  clize = callPackage ../development/python-modules/clize { };

  clldutils = callPackage ../development/python-modules/clldutils { };

  cloudflare = callPackage ../development/python-modules/cloudflare { };

  cloudpathlib = callPackage ../development/python-modules/cloudpathlib { };

  cloudpickle = callPackage ../development/python-modules/cloudpickle { };

  cloudscraper = callPackage ../development/python-modules/cloudscraper { };

  cloudsmith-api = callPackage ../development/python-modules/cloudsmith-api { };

  cloudsplaining = callPackage ../development/python-modules/cloudsplaining { };

  cloup = callPackage ../development/python-modules/cloup { };

  clustershell = callPackage ../development/python-modules/clustershell { };

  clvm = throw "clvm has been removed. see https://github.com/NixOS/nixpkgs/pull/270254";

  clvm-rs = throw "clvm-rs has been removed. see https://github.com/NixOS/nixpkgs/pull/270254";

  clvm-tools = throw "clvm-tools has been removed. see https://github.com/NixOS/nixpkgs/pull/270254";

  clvm-tools-rs = throw "clvm-tools-rs has been removed. see https://github.com/NixOS/nixpkgs/pull/270254";

  cma = callPackage ../development/python-modules/cma { };

  cmaes = callPackage ../development/python-modules/cmaes { };

  cmake = callPackage ../development/python-modules/cmake { inherit (pkgs) cmake; };

  cmarkgfm = callPackage ../development/python-modules/cmarkgfm { };

  cmd2 = callPackage ../development/python-modules/cmd2 { };

  cmd2-ext-test = callPackage ../development/python-modules/cmd2-ext-test { };

  cmdline = callPackage ../development/python-modules/cmdline { };

  cmdstanpy = callPackage ../development/python-modules/cmdstanpy { };

  cmigemo = callPackage ../development/python-modules/cmigemo {
    inherit (pkgs) cmigemo;
  };

  cmsis-pack-manager = callPackage ../development/python-modules/cmsis-pack-manager { };

  cmsis-svd = callPackage ../development/python-modules/cmsis-svd { };

  cnvkit = callPackage ../development/python-modules/cnvkit { };

  co2signal = callPackage ../development/python-modules/co2signal { };

  coapthon3 = callPackage ../development/python-modules/coapthon3 { };

  coconut = callPackage ../development/python-modules/coconut { };

  cocotb = callPackage ../development/python-modules/cocotb { };

  cocotb-bus = callPackage ../development/python-modules/cocotb-bus { };

  codecov = callPackage ../development/python-modules/codecov { };

  codepy = callPackage ../development/python-modules/codepy { };

  cogapp = callPackage ../development/python-modules/cogapp { };

  coinmetrics-api-client = callPackage ../development/python-modules/coinmetrics-api-client { };

  colanderalchemy = callPackage ../development/python-modules/colanderalchemy { };

  colander = callPackage ../development/python-modules/colander { };

  collections-extended = callPackage ../development/python-modules/collections-extended { };

  collidoscope = callPackage ../development/python-modules/collidoscope { };

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

  colorspacious = callPackage ../development/python-modules/colorspacious { };

  colorthief = callPackage ../development/python-modules/colorthief { };

  colorzero = callPackage ../development/python-modules/colorzero { };

  colour = callPackage ../development/python-modules/colour { };

  colout = callPackage ../development/python-modules/colout { };

  cometblue-lite = callPackage ../development/python-modules/cometblue-lite { };

  comm = callPackage ../development/python-modules/comm { };

  commandlines = callPackage ../development/python-modules/commandlines { };

  commandparse = callPackage ../development/python-modules/commandparse { };

  commentjson = callPackage ../development/python-modules/commentjson { };

  commoncode = callPackage ../development/python-modules/commoncode { };

  commonmark = callPackage ../development/python-modules/commonmark { };

  compiledb = callPackage ../development/python-modules/compiledb { };

  complycube = callPackage ../development/python-modules/complycube { };

  compreffor = callPackage ../development/python-modules/compreffor { };

  compressai = callPackage ../development/python-modules/compressai { };

  compressed-rtf = callPackage ../development/python-modules/compressed-rtf { };

  concurrent-log-handler = callPackage ../development/python-modules/concurrent-log-handler { };

  conda = callPackage ../development/python-modules/conda { };

  confection = callPackage ../development/python-modules/confection { };

  configargparse = callPackage ../development/python-modules/configargparse { };

  configclass = callPackage ../development/python-modules/configclass { };

  configobj = callPackage ../development/python-modules/configobj { };

  configparser = callPackage ../development/python-modules/configparser { };

  configshell = callPackage ../development/python-modules/configshell { };

  configupdater = callPackage ../development/python-modules/configupdater { };

  confluent-kafka = callPackage ../development/python-modules/confluent-kafka { };

  confuse = callPackage ../development/python-modules/confuse { };

  confight = callPackage ../development/python-modules/confight { };

  connexion = callPackage ../development/python-modules/connexion { };

  cons = callPackage ../development/python-modules/cons { };

  consonance = callPackage ../development/python-modules/consonance { };

  constantly = callPackage ../development/python-modules/constantly { };

  construct = callPackage ../development/python-modules/construct { };

  construct-classes = callPackage ../development/python-modules/construct-classes { };

  consul = callPackage ../development/python-modules/consul { };

  container-inspector = callPackage ../development/python-modules/container-inspector { };

  contexter = callPackage ../development/python-modules/contexter { };

  contextlib2 = callPackage ../development/python-modules/contextlib2 { };

  contexttimer = callPackage ../development/python-modules/contexttimer { };

  contourpy = callPackage ../development/python-modules/contourpy { };

  controku = callPackage ../development/python-modules/controku { };

  convertdate = callPackage ../development/python-modules/convertdate { };

  cookiecutter = callPackage ../development/python-modules/cookiecutter { };

  cookies = callPackage ../development/python-modules/cookies { };

  coordinates = callPackage ../development/python-modules/coordinates { };

  coreapi = callPackage ../development/python-modules/coreapi { };

  coredis = callPackage ../development/python-modules/coredis { };

  coreschema = callPackage ../development/python-modules/coreschema { };

  cornice = callPackage ../development/python-modules/cornice { };

  corsair-scan = callPackage ../development/python-modules/corsair-scan { };

  cose = callPackage ../development/python-modules/cose { };

  cot = callPackage ../development/python-modules/cot {
    qemu = pkgs.qemu;
  };

  courlan = callPackage ../development/python-modules/courlan { };

  cov-core = callPackage ../development/python-modules/cov-core { };

  coverage = callPackage ../development/python-modules/coverage { };

  coveralls = callPackage ../development/python-modules/coveralls { };

  cppe = callPackage ../development/python-modules/cppe {
    inherit (pkgs) cppe;
  };

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

  crcmod = callPackage ../development/python-modules/crcmod { };

  credstash = callPackage ../development/python-modules/credstash { };

  criticality-score = callPackage ../development/python-modules/criticality-score { };

  crocoddyl = toPythonModule (callPackage ../development/libraries/crocoddyl {
    pythonSupport = true;
    python3Packages = self;
  });

  cron-descriptor = callPackage ../development/python-modules/cron-descriptor { };

  croniter = callPackage ../development/python-modules/croniter { };

  cronsim = callPackage ../development/python-modules/cronsim { };

  crontab = callPackage ../development/python-modules/crontab { };

  crossplane = callPackage ../development/python-modules/crossplane { };

  crownstone-cloud = callPackage ../development/python-modules/crownstone-cloud { };

  crownstone-core = callPackage ../development/python-modules/crownstone-core { };

  crownstone-sse = callPackage ../development/python-modules/crownstone-sse { };

  crownstone-uart = callPackage ../development/python-modules/crownstone-uart { };

  cryptacular = callPackage ../development/python-modules/cryptacular { };

  cryptg = callPackage ../development/python-modules/cryptg { };

  cryptodatahub = callPackage ../development/python-modules/cryptodatahub { };

  cryptography = callPackage ../development/python-modules/cryptography {
    inherit (pkgs.darwin) libiconv;
    inherit (pkgs.darwin.apple_sdk.frameworks) Security;
  };

  cryptolyzer = callPackage ../development/python-modules/cryptolyzer { };

  cryptoparser = callPackage ../development/python-modules/cryptoparser { };

  crysp = callPackage ../development/python-modules/crysp { };

  crytic-compile = callPackage ../development/python-modules/crytic-compile { };

  cson  = callPackage ../development/python-modules/cson { };

  csrmesh  = callPackage ../development/python-modules/csrmesh { };

  cssbeautifier = callPackage ../development/python-modules/cssbeautifier { };

  csscompressor = callPackage ../development/python-modules/csscompressor { };

  cssmin = callPackage ../development/python-modules/cssmin { };

  css-html-js-minify = callPackage ../development/python-modules/css-html-js-minify { };

  css-inline = callPackage ../development/python-modules/css-inline {
    inherit (pkgs.darwin) libiconv;
    inherit (pkgs.darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };

  css-parser = callPackage ../development/python-modules/css-parser { };

  cssselect2 = callPackage ../development/python-modules/cssselect2 { };

  cssselect = callPackage ../development/python-modules/cssselect { };

  cssutils = callPackage ../development/python-modules/cssutils { };

  cstruct = callPackage ../development/python-modules/cstruct { };

  csvw = callPackage ../development/python-modules/csvw { };

  ctap-keyring-device = callPackage ../development/python-modules/ctap-keyring-device { };

  ctranslate2 = callPackage ../development/python-modules/ctranslate2 {
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  cu2qu = callPackage ../development/python-modules/cu2qu { };

  cucumber-tag-expressions = callPackage ../development/python-modules/cucumber-tag-expressions { };

  cufflinks = callPackage ../development/python-modules/cufflinks { };

  # cupy 12.2.0 possibly incompatible with cutensor 2.0 that comes with cudaPackages_12
  cupy = callPackage ../development/python-modules/cupy { cudaPackages = pkgs.cudaPackages_11; };

  curio = callPackage ../development/python-modules/curio { };

  curlify = callPackage ../development/python-modules/curlify { };

  curtsies = callPackage ../development/python-modules/curtsies { };

  curve25519-donna = callPackage ../development/python-modules/curve25519-donna { };

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

  cycler = callPackage ../development/python-modules/cycler { };

  cyclonedx-python-lib = callPackage ../development/python-modules/cyclonedx-python-lib { };

  cymem = callPackage ../development/python-modules/cymem { };

  cypari2 = callPackage ../development/python-modules/cypari2 { };

  cypherpunkpay = callPackage ../development/python-modules/cypherpunkpay { };

  cysignals = callPackage ../development/python-modules/cysignals { };

  cython = callPackage ../development/python-modules/cython { };

  cython_3 = self.cython.overridePythonAttrs (old: rec {
    version = "3.0.9";
    src = old.src.override {
      inherit version;
      hash = "sha256-otNU8FnR8FXTTPqmLFtovHisLOq2QHFI1H+1CM87pPM=";
    };
    patches = [ ];
  });

  cython-test-exception-raiser = callPackage ../development/python-modules/cython-test-exception-raiser { };

  cytoolz = callPackage ../development/python-modules/cytoolz { };

  dacite = callPackage ../development/python-modules/dacite { };

  daemonize = callPackage ../development/python-modules/daemonize { };

  daemonocle = callPackage ../development/python-modules/daemonocle { };

  daff = callPackage ../development/python-modules/daff { };

  daiquiri = callPackage ../development/python-modules/daiquiri { };

  dalle-mini = callPackage ../development/python-modules/dalle-mini { };

  daphne = callPackage ../development/python-modules/daphne { };

  daqp = callPackage ../development/python-modules/daqp { };

  darkdetect = callPackage ../development/python-modules/darkdetect { };

  dasbus = callPackage ../development/python-modules/dasbus { };

  dash = callPackage ../development/python-modules/dash { };

  dash-core-components = callPackage ../development/python-modules/dash-core-components { };

  dash-html-components = callPackage ../development/python-modules/dash-html-components { };

  dash-renderer = callPackage ../development/python-modules/dash-renderer { };

  dash-table = callPackage ../development/python-modules/dash-table { };

  dashing = callPackage ../development/python-modules/dashing { };

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

  databases = callPackage ../development/python-modules/databases { };

  databricks-cli = callPackage ../development/python-modules/databricks-cli { };

  databricks-connect = callPackage ../development/python-modules/databricks-connect { };

  databricks-sql-connector = callPackage ../development/python-modules/databricks-sql-connector { };

  dataclass-factory = callPackage ../development/python-modules/dataclass-factory { };

  dataclass-wizard = callPackage ../development/python-modules/dataclass-wizard { };

  dataclasses-json = callPackage ../development/python-modules/dataclasses-json { };

  dataclasses-serialization = callPackage ../development/python-modules/dataclasses-serialization { };

  datadiff = callPackage ../development/python-modules/datadiff { };

  datadog = callPackage ../development/python-modules/datadog { };

  datafusion = callPackage ../development/python-modules/datafusion {
    inherit (pkgs.darwin.apple_sdk.frameworks) Security SystemConfiguration;
  };

  datamodeldict = callPackage ../development/python-modules/datamodeldict { };

  datapoint = callPackage ../development/python-modules/datapoint { };

  dataprep-ml = callPackage ../development/python-modules/dataprep-ml { };

  dataproperty = callPackage ../development/python-modules/dataproperty { };

  dataset = callPackage ../development/python-modules/dataset { };

  datasets = callPackage ../development/python-modules/datasets { };

  datasette = callPackage ../development/python-modules/datasette { };

  datasette-publish-fly = callPackage ../development/python-modules/datasette-publish-fly { };

  datasette-template-sql = callPackage ../development/python-modules/datasette-template-sql { };

  datashader = callPackage ../development/python-modules/datashader { };

  datashape = callPackage ../development/python-modules/datashape { };

  datatable = callPackage ../development/python-modules/datatable { };

  datauri = callPackage ../development/python-modules/datauri { };

  datefinder = callPackage ../development/python-modules/datefinder { };

  dateparser = callPackage ../development/python-modules/dateparser { };

  datetime = callPackage ../development/python-modules/datetime { };

  dateutils = callPackage ../development/python-modules/dateutils { };

  datrie = callPackage ../development/python-modules/datrie { };

  dawg-python = callPackage ../development/python-modules/dawg-python { };

  dazl = callPackage ../development/python-modules/dazl { };

  dbf = callPackage ../development/python-modules/dbf { };

  dbfread = callPackage ../development/python-modules/dbfread { };

  dbglib = callPackage ../development/python-modules/dbglib { };

  dbt-bigquery = callPackage ../development/python-modules/dbt-bigquery { };

  dbt-core = callPackage ../development/python-modules/dbt-core { };

  dbt-extractor = callPackage ../development/python-modules/dbt-extractor { };

  dbt-postgres = callPackage ../development/python-modules/dbt-postgres { };

  dbt-redshift = callPackage ../development/python-modules/dbt-redshift { };

  dbt-semantic-interfaces = callPackage ../development/python-modules/dbt-semantic-interfaces { };

  dbt-snowflake = callPackage ../development/python-modules/dbt-snowflake { };

  dbus-client-gen = callPackage ../development/python-modules/dbus-client-gen { };

  dbus-deviation = callPackage ../development/python-modules/dbus-deviation { };

  dbus-fast = callPackage ../development/python-modules/dbus-fast { };

  dbus-next = callPackage ../development/python-modules/dbus-next { };

  dbus-python = callPackage ../development/python-modules/dbus-python {
    inherit (pkgs) dbus;
  };

  dbus-python-client-gen = callPackage ../development/python-modules/dbus-python-client-gen { };

  dbus-signature-pyparsing = callPackage ../development/python-modules/dbus-signature-pyparsing { };

  dbutils = callPackage ../development/python-modules/dbutils { };

  db-dtypes = callPackage ../development/python-modules/db-dtypes { };

  dcmstack = callPackage ../development/python-modules/dcmstack { };

  dctorch = callPackage ../development/python-modules/dctorch { };

  ddt = callPackage ../development/python-modules/ddt { };

  deal = callPackage ../development/python-modules/deal { };

  deal-solver = callPackage ../development/python-modules/deal-solver { };

  deap = callPackage ../development/python-modules/deap { };

  debian = callPackage ../development/python-modules/debian { };

  debianbts = callPackage ../development/python-modules/debianbts { };

  debian-inspector = callPackage ../development/python-modules/debian-inspector { };

  debtcollector = callPackage ../development/python-modules/debtcollector { };

  debts = callPackage ../development/python-modules/debts { };

  debugpy = callPackage ../development/python-modules/debugpy { };

  debuglater = callPackage ../development/python-modules/debuglater { };

  decli = callPackage ../development/python-modules/decli { };

  decorator = callPackage ../development/python-modules/decorator { };

  decopatch = callPackage ../development/python-modules/decopatch { };

  deebot-client = callPackage ../development/python-modules/deebot-client { };

  deemix = callPackage ../development/python-modules/deemix { };

  deep-chainmap = callPackage ../development/python-modules/deep-chainmap { };

  deepdiff = callPackage ../development/python-modules/deepdiff { };

  deepdish = callPackage ../development/python-modules/deepdish { };

  deepl = callPackage ../development/python-modules/deepl { };

  deepmerge = callPackage ../development/python-modules/deepmerge { };

  deeptoolsintervals = callPackage ../development/python-modules/deeptoolsintervals { };

  deepwave = callPackage ../development/python-modules/deepwave { };

  deep-translator = callPackage ../development/python-modules/deep-translator { };

  deezer-py = callPackage ../development/python-modules/deezer-py { };

  deezer-python = callPackage ../development/python-modules/deezer-python { };

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

  deluge-client = callPackage ../development/python-modules/deluge-client { };

  demes = callPackage ../development/python-modules/demes { };

  demesdraw = callPackage ../development/python-modules/demesdraw { };

  demetriek = callPackage ../development/python-modules/demetriek { };

  demjson3 = callPackage ../development/python-modules/demjson3 { };

  demoji = callPackage ../development/python-modules/demoji { };

  dendropy = callPackage ../development/python-modules/dendropy { };

  denonavr = callPackage ../development/python-modules/denonavr { };

  dep-logic = callPackage ../development/python-modules/dep-logic { };

  dependency-injector = callPackage ../development/python-modules/dependency-injector { };

  deploykit = callPackage ../development/python-modules/deploykit { };

  deprecat = callPackage ../development/python-modules/deprecat { };

  deprecated = callPackage ../development/python-modules/deprecated { };

  deprecation = callPackage ../development/python-modules/deprecation { };

  derpconf = callPackage ../development/python-modules/derpconf { };

  desktop-entry-lib = callPackage ../development/python-modules/desktop-entry-lib { };

  desktop-notifier = callPackage ../development/python-modules/desktop-notifier { };

  detect-secrets = callPackage ../development/python-modules/detect-secrets { };

  detectron2 = callPackage ../development/python-modules/detectron2 { };

  devialet = callPackage ../development/python-modules/devialet { };

  devito = callPackage ../development/python-modules/devito { };

  devolo-home-control-api = callPackage ../development/python-modules/devolo-home-control-api { };

  devolo-plc-api = callPackage ../development/python-modules/devolo-plc-api { };

  devpi-common = callPackage ../development/python-modules/devpi-common { };

  devtools = callPackage ../development/python-modules/devtools { };

  diagrams = callPackage ../development/python-modules/diagrams { };

  diceware = callPackage ../development/python-modules/diceware { };

  dicom2nifti = callPackage ../development/python-modules/dicom2nifti { };

  dicom-numpy = callPackage ../development/python-modules/dicom-numpy { };

  dicomweb-client = callPackage ../development/python-modules/dicomweb-client { };

  dict2xml = callPackage ../development/python-modules/dict2xml { };

  dictdiffer = callPackage ../development/python-modules/dictdiffer { };

  dictionaries = callPackage ../development/python-modules/dictionaries { };

  dicttoxml = callPackage ../development/python-modules/dicttoxml { };

  dicttoxml2 = callPackage ../development/python-modules/dicttoxml2 { };

  diff-cover = callPackage ../development/python-modules/diff-cover { };

  diff-match-patch = callPackage ../development/python-modules/diff-match-patch { };

  diffimg = callPackage ../development/python-modules/diffimg { };

  diffsync = callPackage ../development/python-modules/diffsync { };

  diffusers = callPackage ../development/python-modules/diffusers { };

  digital-ocean = callPackage ../development/python-modules/digitalocean { };

  digi-xbee = callPackage ../development/python-modules/digi-xbee { };

  dill = callPackage ../development/python-modules/dill { };

  dingz = callPackage ../development/python-modules/dingz { };

  dinghy = callPackage ../development/python-modules/dinghy { };

  diofant = callPackage ../development/python-modules/diofant { };

  dipy = callPackage ../development/python-modules/dipy { };

  directv = callPackage ../development/python-modules/directv { };

  dirigera = callPackage ../development/python-modules/dirigera { };

  dirty-equals = callPackage ../development/python-modules/dirty-equals { };

  dirtyjson = callPackage ../development/python-modules/dirtyjson { };

  discid = callPackage ../development/python-modules/discid { };

  discogs-client = callPackage ../development/python-modules/discogs-client { };

  discordpy = callPackage ../development/python-modules/discordpy { };

  discovery30303 = callPackage ../development/python-modules/discovery30303 { };

  diskcache = callPackage ../development/python-modules/diskcache { };

  dissect = callPackage ../development/python-modules/dissect { };

  dissect-btrfs = callPackage ../development/python-modules/dissect-btrfs { };

  dissect-cim = callPackage ../development/python-modules/dissect-cim { };

  dissect-clfs = callPackage ../development/python-modules/dissect-clfs { };

  dissect-cobaltstrike = callPackage ../development/python-modules/dissect-cobaltstrike { };

  dissect-cstruct = callPackage ../development/python-modules/dissect-cstruct { };

  dissect-fat = callPackage ../development/python-modules/dissect-fat { };

  dissect-ffs = callPackage ../development/python-modules/dissect-ffs { };

  dissect-esedb = callPackage ../development/python-modules/dissect-esedb { };

  dissect-etl = callPackage ../development/python-modules/dissect-etl { };

  dissect-eventlog = callPackage ../development/python-modules/dissect-eventlog { };

  dissect-evidence = callPackage ../development/python-modules/dissect-evidence { };

  dissect-executable = callPackage ../development/python-modules/dissect-executable { };

  dissect-extfs = callPackage ../development/python-modules/dissect-extfs { };

  dissect-hypervisor = callPackage ../development/python-modules/dissect-hypervisor { };

  dissect-jffs = callPackage ../development/python-modules/dissect-jffs { };

  dissect-ntfs = callPackage ../development/python-modules/dissect-ntfs { };

  dissect-ole = callPackage ../development/python-modules/dissect-ole { };

  dissect-regf = callPackage ../development/python-modules/dissect-regf { };

  dissect-shellitem = callPackage ../development/python-modules/dissect-shellitem { };

  dissect-squashfs = callPackage ../development/python-modules/dissect-squashfs { };

  dissect-sql = callPackage ../development/python-modules/dissect-sql { };

  dissect-target = callPackage ../development/python-modules/dissect-target { };

  dissect-thumbcache = callPackage ../development/python-modules/dissect-thumbcache { };

  dissect-util = callPackage ../development/python-modules/dissect-util { };

  dissect-vmfs = callPackage ../development/python-modules/dissect-vmfs { };

  dissect-volume = callPackage ../development/python-modules/dissect-volume { };

  dissect-xfs = callPackage ../development/python-modules/dissect-xfs { };

  dissononce = callPackage ../development/python-modules/dissononce { };

  distlib = callPackage ../development/python-modules/distlib { };

  distorm3 = callPackage ../development/python-modules/distorm3 { };

  distrax = callPackage ../development/python-modules/distrax { };

  distributed = callPackage ../development/python-modules/distributed { };

  distro = callPackage ../development/python-modules/distro { };

  distutils-extra = callPackage ../development/python-modules/distutils-extra { };

  # LTS in extended support phase
  django_3 = callPackage ../development/python-modules/django/3.nix { };

  # LTS with mainsteam support
  django = self.django_4;
  django_4 = callPackage ../development/python-modules/django/4.nix { };

  # Pre-release
  django_5 = callPackage ../development/python-modules/django/5.nix { };

  django-admin-datta = callPackage ../development/python-modules/django-admin-datta { };

  django-admin-sortable2 = callPackage ../development/python-modules/django-admin-sortable2 { };

  django-allauth = callPackage ../development/python-modules/django-allauth { };

  django-allauth-2fa = callPackage ../development/python-modules/django-allauth-2fa { };

  django-anymail = callPackage ../development/python-modules/django-anymail { };

  django-annoying = callPackage ../development/python-modules/django-annoying { };

  django-appconf = callPackage ../development/python-modules/django-appconf { };

  django-auditlog = callPackage ../development/python-modules/django-auditlog { };

  django-auth-ldap = callPackage ../development/python-modules/django-auth-ldap { };

  django-autocomplete-light = callPackage ../development/python-modules/django-autocomplete-light { };

  django-bootstrap3 = callPackage ../development/python-modules/django-bootstrap3 { };

  django-bootstrap4 = callPackage ../development/python-modules/django-bootstrap4 { };

  django-bootstrap5 = callPackage ../development/python-modules/django-bootstrap5 { };

  django-cachalot = callPackage ../development/python-modules/django-cachalot { };

  django-cache-url = callPackage ../development/python-modules/django-cache-url { };

  django-cacheops = callPackage ../development/python-modules/django-cacheops { };

  django-celery-beat = callPackage ../development/python-modules/django-celery-beat { };

  django-celery-email = callPackage ../development/python-modules/django-celery-email { };

  django-celery-results = callPackage ../development/python-modules/django-celery-results { };

  django-ckeditor = callPackage ../development/python-modules/django-ckeditor { };

  django-classy-tags = callPackage ../development/python-modules/django-classy-tags { };

  django-cleanup = callPackage ../development/python-modules/django-cleanup { };

  django-colorful = callPackage ../development/python-modules/django-colorful { };

  django-compressor = callPackage ../development/python-modules/django-compressor { };

  django-compression-middleware = callPackage ../development/python-modules/django-compression-middleware { };

  django-configurations = callPackage ../development/python-modules/django-configurations { };

  django-context-decorator = callPackage ../development/python-modules/django-context-decorator { };

  django-contrib-comments = callPackage ../development/python-modules/django-contrib-comments { };

  django-cors-headers = callPackage ../development/python-modules/django-cors-headers { };

  django-countries = callPackage ../development/python-modules/django-countries { };

  django-crispy-bootstrap4 = callPackage ../development/python-modules/django-crispy-bootstrap4 { };

  django-crispy-bootstrap5 = callPackage ../development/python-modules/django-crispy-bootstrap5 { };

  django-crispy-forms = callPackage ../development/python-modules/django-crispy-forms { };

  django-crontab = callPackage ../development/python-modules/django-crontab { };

  django-cryptography = callPackage ../development/python-modules/django-cryptography { };

  django-csp = callPackage ../development/python-modules/django-csp { };

  django-currentuser = callPackage ../development/python-modules/django-currentuser { };

  django-debug-toolbar = callPackage ../development/python-modules/django-debug-toolbar { };

  django-dynamic-preferences = callPackage ../development/python-modules/django-dynamic-preferences { };

  django-encrypted-model-fields = callPackage ../development/python-modules/django-encrypted-model-fields { };

  django-environ = callPackage ../development/python-modules/django-environ { };

  django-extensions = callPackage ../development/python-modules/django-extensions { };

  django-filter = callPackage ../development/python-modules/django-filter { };

  django-formtools = callPackage ../development/python-modules/django-formtools { };

  django-formset-js-improved = callPackage ../development/python-modules/django-formset-js-improved { };

  django-graphiql-debug-toolbar = callPackage ../development/python-modules/django-graphiql-debug-toolbar { };

  django-gravatar2 = callPackage ../development/python-modules/django-gravatar2 { };

  django-google-analytics-app = callPackage ../development/python-modules/django-google-analytics-app { };

  django-guardian = callPackage ../development/python-modules/django-guardian { };

  django-haystack = callPackage ../development/python-modules/django-haystack { };

  django-hcaptcha = callPackage ../development/python-modules/django-hcaptcha { };

  django-health-check = callPackage ../development/python-modules/django-health-check { };

  django-hierarkey = callPackage ../development/python-modules/django-hierarkey { };

  django-hijack = callPackage ../development/python-modules/django-hijack { };

  django-i18nfield = callPackage ../development/python-modules/django-i18nfield { };

  django-import-export = callPackage ../development/python-modules/django-import-export { };

  django-ipware = callPackage ../development/python-modules/django-ipware { };

  django-jinja = callPackage ../development/python-modules/django-jinja2 { };

  django-jquery-js = callPackage ../development/python-modules/django-jquery-js { };

  django-js-asset = callPackage ../development/python-modules/django-js-asset { };

  django-js-reverse = callPackage ../development/python-modules/django-js-reverse { };

  django-libsass = callPackage ../development/python-modules/django-libsass { };

  django-leaflet = callPackage ../development/python-modules/django-leaflet { };

  django-logentry-admin = callPackage ../development/python-modules/django-logentry-admin { };

  django-login-required-middleware = callPackage ../development/python-modules/django-login-required-middleware { };

  django-localflavor = callPackage ../development/python-modules/django-localflavor { };

  django-mailman3 = callPackage ../development/python-modules/django-mailman3 { };

  django-markup = callPackage ../development/python-modules/django-markup { };

  django-markdownx = callPackage ../development/python-modules/django-markdownx { };

  django-model-utils = callPackage ../development/python-modules/django-model-utils { };

  django-modelcluster = callPackage ../development/python-modules/django-modelcluster { };

  django-modeltranslation = callPackage ../development/python-modules/django-modeltranslation { };

  django-multiselectfield = callPackage ../development/python-modules/django-multiselectfield { };

  django-maintenance-mode = callPackage ../development/python-modules/django-maintenance-mode { };

  django-mdeditor = callPackage ../development/python-modules/django-mdeditor { };

  django-mptt = callPackage ../development/python-modules/django-mptt { };

  django-mysql = callPackage ../development/python-modules/django-mysql { };

  django-ninja = callPackage ../development/python-modules/django-ninja { };

  django-nose = callPackage ../development/python-modules/django-nose { };

  django-oauth-toolkit = callPackage ../development/python-modules/django-oauth-toolkit { };

  django-otp = callPackage ../development/python-modules/django-otp { };

  django-paintstore = callPackage ../development/python-modules/django-paintstore { };

  django-parler = callPackage ../development/python-modules/django-parler { };

  django-pattern-library = callPackage ../development/python-modules/django-pattern-library { };

  django-payments = callPackage ../development/python-modules/django-payments { };

  django-pglocks = callPackage ../development/python-modules/django-pglocks { };

  django-phonenumber-field = callPackage ../development/python-modules/django-phonenumber-field { };

  django-picklefield = callPackage ../development/python-modules/django-picklefield { };

  django-polymorphic = callPackage ../development/python-modules/django-polymorphic { };

  django-postgresql-netfields = callPackage ../development/python-modules/django-postgresql-netfields { };

  django-prometheus = callPackage ../development/python-modules/django-prometheus { };

  django-pwa = callPackage ../development/python-modules/django-pwa { };

  django-q = callPackage ../development/python-modules/django-q { };

  django-scheduler = callPackage ../development/python-modules/django-scheduler { };

  django-scim2 = callPackage ../development/python-modules/django-scim2 { };

  django-shortuuidfield = callPackage ../development/python-modules/django-shortuuidfield { };

  django-scopes = callPackage ../development/python-modules/django-scopes { };

  djangoql = callPackage ../development/python-modules/djangoql { };

  django-ranged-response = callPackage ../development/python-modules/django-ranged-response { };

  django-raster = callPackage ../development/python-modules/django-raster { };

  django-redis = callPackage ../development/python-modules/django-redis { };

  django-rest-auth = callPackage ../development/python-modules/django-rest-auth { };

  django-rest-polymorphic = callPackage ../development/python-modules/django-rest-polymorphic { };

  django-rest-registration = callPackage ../development/python-modules/django-rest-registration { };

  django-rosetta = callPackage ../development/python-modules/django-rosetta { };

  django-rq = callPackage ../development/python-modules/django-rq { };

  djangorestframework = callPackage ../development/python-modules/djangorestframework { };

  djangorestframework-dataclasses = callPackage ../development/python-modules/djangorestframework-dataclasses { };

  djangorestframework-camel-case = callPackage ../development/python-modules/djangorestframework-camel-case { };

  djangorestframework-guardian = callPackage ../development/python-modules/djangorestframework-guardian { };

  djangorestframework-guardian2 = callPackage ../development/python-modules/djangorestframework-guardian2 { };

  djangorestframework-recursive = callPackage ../development/python-modules/djangorestframework-recursive { };

  djangorestframework-simplejwt = callPackage ../development/python-modules/djangorestframework-simplejwt { };

  djangorestframework-stubs = callPackage ../development/python-modules/djangorestframework-stubs { };

  django-reversion = callPackage ../development/python-modules/django-reversion { };

  django-sekizai = callPackage ../development/python-modules/django-sekizai { };

  django-sesame = callPackage ../development/python-modules/django-sesame { };

  django-silk = callPackage ../development/python-modules/django-silk { };

  django-simple-captcha = callPackage ../development/python-modules/django-simple-captcha { };

  django-simple-history = callPackage ../development/python-modules/django-simple-history { };

  django-sites = callPackage ../development/python-modules/django-sites { };

  django-sr = callPackage ../development/python-modules/django-sr { };

  django-statici18n = callPackage ../development/python-modules/django-statici18n { };

  django-storages = callPackage ../development/python-modules/django-storages { };

  django-stubs = callPackage ../development/python-modules/django-stubs { };

  django-stubs-ext = callPackage ../development/python-modules/django-stubs-ext { };

  django-tables2 = callPackage ../development/python-modules/django-tables2 { };

  django-tagging = callPackage ../development/python-modules/django-tagging { };

  django-taggit = callPackage ../development/python-modules/django-taggit { };

  django-tastypie = callPackage ../development/python-modules/django-tastypie { };

  django-timezone-field = callPackage ../development/python-modules/django-timezone-field { };

  django-treebeard = callPackage ../development/python-modules/django-treebeard { };

  django-two-factor-auth = callPackage ../development/python-modules/django-two-factor-auth { };

  django-types = callPackage ../development/python-modules/django-types { };

  django-versatileimagefield = callPackage ../development/python-modules/django-versatileimagefield { };

  django-vite = callPackage ../development/python-modules/django-vite { };

  django-webpack-loader = callPackage ../development/python-modules/django-webpack-loader { };

  django-webpush = callPackage ../development/python-modules/django-webpush { };

  django-widget-tweaks = callPackage ../development/python-modules/django-widget-tweaks { };

  dj-database-url = callPackage ../development/python-modules/dj-database-url { };

  dj-email-url = callPackage ../development/python-modules/dj-email-url { };

  djmail = callPackage ../development/python-modules/djmail { };

  dj-rest-auth = callPackage ../development/python-modules/dj-rest-auth { };

  dj-search-url = callPackage ../development/python-modules/dj-search-url { };

  dj-static = callPackage ../development/python-modules/dj-static { };

  dkimpy = callPackage ../development/python-modules/dkimpy { };

  dlib = callPackage ../development/python-modules/dlib {
    inherit (pkgs) dlib;
  };

  dlinfo = callPackage ../development/python-modules/dlinfo { };

  dllogger = callPackage ../development/python-modules/dllogger { };

  dlms-cosem = callPackage ../development/python-modules/dlms-cosem { };

  dlx = callPackage ../development/python-modules/dlx { };

  dmenu-python = callPackage ../development/python-modules/dmenu { };

  dm-env = callPackage ../development/python-modules/dm-env { };

  dm-haiku = callPackage ../development/python-modules/dm-haiku { };

  dm-sonnet = callPackage ../development/python-modules/dm-sonnet { };

  dm-tree = callPackage ../development/python-modules/dm-tree {
    abseil-cpp = pkgs.abseil-cpp_202103.override {
      cxxStandard = "14";
    };
  };

  dnachisel = callPackage ../development/python-modules/dnachisel { };

  dnf-plugins-core = callPackage ../development/python-modules/dnf-plugins-core { };

  dnf4 = callPackage ../development/python-modules/dnf4 { };

  dnfile = callPackage ../development/python-modules/dnfile { };

  dnslib = callPackage ../development/python-modules/dnslib { };

  dnspython = callPackage ../development/python-modules/dnspython { };

  dns-lexicon = callPackage ../development/python-modules/dns-lexicon { };

  doc8 = callPackage ../development/python-modules/doc8 { };

  docformatter = callPackage ../development/python-modules/docformatter { };

  docker = callPackage ../development/python-modules/docker { };

  dockerfile-parse = callPackage ../development/python-modules/dockerfile-parse { };

  dockerpty = callPackage ../development/python-modules/dockerpty { };

  docker-pycreds = callPackage ../development/python-modules/docker-pycreds { };

  docker-py = callPackage ../development/python-modules/docker-py { };

  dockerspawner = callPackage ../development/python-modules/dockerspawner { };

  docloud = callPackage ../development/python-modules/docloud { };

  docstr-coverage = callPackage ../development/python-modules/docstr-coverage { };

  docstring-to-markdown = callPackage ../development/python-modules/docstring-to-markdown { };

  docstring-parser = callPackage ../development/python-modules/docstring-parser { };

  docopt = callPackage ../development/python-modules/docopt { };

  docopt-ng = callPackage ../development/python-modules/docopt-ng { };

  docplex = callPackage ../development/python-modules/docplex { };

  docrep = callPackage ../development/python-modules/docrep { };

  doctest-ignore-unicode = callPackage ../development/python-modules/doctest-ignore-unicode { };

  docutils = callPackage ../development/python-modules/docutils { };

  docx2python = callPackage ../development/python-modules/docx2python { };

  docx2txt = callPackage ../development/python-modules/docx2txt { };

  dodgy = callPackage ../development/python-modules/dodgy { };

  dogpile-cache = callPackage ../development/python-modules/dogpile-cache { };

  dogtag-pki = callPackage ../development/python-modules/dogtag-pki { };

  dogtail = callPackage ../development/python-modules/dogtail { };

  doit = callPackage ../development/python-modules/doit { };

  doit-py = callPackage ../development/python-modules/doit-py { };

  dokuwiki = callPackage ../development/python-modules/dokuwiki { };

  domeneshop = callPackage ../development/python-modules/domeneshop { };

  dominate = callPackage ../development/python-modules/dominate { };

  doorbirdpy = callPackage ../development/python-modules/doorbirdpy { };

  dopy = callPackage ../development/python-modules/dopy { };

  dotty-dict = callPackage ../development/python-modules/dotty-dict { };

  dot2tex = callPackage ../development/python-modules/dot2tex {
    inherit (pkgs) graphviz;
  };

  dotwiz = callPackage ../development/python-modules/dotwiz { };

  dotmap = callPackage ../development/python-modules/dotmap { };

  downloader-cli = callPackage ../development/python-modules/downloader-cli { };

  dparse = callPackage ../development/python-modules/dparse { };

  dparse2 = callPackage ../development/python-modules/dparse2 { };

  dpath = callPackage ../development/python-modules/dpath { };

  dpcontracts = callPackage ../development/python-modules/dpcontracts { };

  dpkt = callPackage ../development/python-modules/dpkt { };

  dploot = callPackage ../development/python-modules/dploot { };

  draftjs-exporter = callPackage ../development/python-modules/draftjs-exporter { };

  dragonfly = callPackage ../development/python-modules/dragonfly { };

  dramatiq = callPackage ../development/python-modules/dramatiq { };

  drawille = callPackage ../development/python-modules/drawille { };

  drawilleplot = callPackage ../development/python-modules/drawilleplot { };

  dremel3dpy = callPackage ../development/python-modules/dremel3dpy { };

  drf-jwt = callPackage ../development/python-modules/drf-jwt { };

  drf-nested-routers = callPackage ../development/python-modules/drf-nested-routers { };

  drf-spectacular = callPackage ../development/python-modules/drf-spectacular { };

  drf-spectacular-sidecar = callPackage ../development/python-modules/drf-spectacular-sidecar { };

  drf-ujson2 = callPackage ../development/python-modules/drf-ujson2 { };

  drf-writable-nested = callPackage ../development/python-modules/drf-writable-nested { };

  drf-yasg = callPackage ../development/python-modules/drf-yasg { };

  drivelib = callPackage ../development/python-modules/drivelib { };

  drms = callPackage ../development/python-modules/drms { };

  dronecan = callPackage ../development/python-modules/dronecan { };

  dropbox = callPackage ../development/python-modules/dropbox { };

  dropmqttapi = callPackage ../development/python-modules/dropmqttapi { };

  ds-store = callPackage ../development/python-modules/ds-store { };

  ds4drv = callPackage ../development/python-modules/ds4drv { };

  dsinternals = callPackage ../development/python-modules/dsinternals { };

  dsmr-parser = callPackage ../development/python-modules/dsmr-parser { };

  dsnap = callPackage ../development/python-modules/dsnap { };

  dtlssocket = callPackage ../development/python-modules/dtlssocket { };

  dtschema = callPackage ../development/python-modules/dtschema { };

  dtw-python = callPackage ../development/python-modules/dtw-python { };

  ducc0 = callPackage ../development/python-modules/ducc0 { };

  duckdb = callPackage ../development/python-modules/duckdb {
    inherit (pkgs) duckdb;
  };

  duckdb-engine = callPackage ../development/python-modules/duckdb-engine { };

  duckduckgo-search = callPackage ../development/python-modules/duckduckgo-search { };

  duct-py = callPackage ../development/python-modules/duct-py { };

  duden = callPackage ../development/python-modules/duden { };

  duecredit = callPackage ../development/python-modules/duecredit { };

  duet = callPackage ../development/python-modules/duet { };

  dufte = callPackage ../development/python-modules/dufte { };

  dugong = callPackage ../development/python-modules/dugong { };

  dulwich = callPackage ../development/python-modules/dulwich {
    inherit (pkgs) gnupg;
  };

  dunamai = callPackage ../development/python-modules/dunamai { };

  dungeon-eos = callPackage ../development/python-modules/dungeon-eos { };

  duo-client = callPackage ../development/python-modules/duo-client { };

  durus = callPackage ../development/python-modules/durus {  };

  dvc = callPackage ../development/python-modules/dvc {  };

  dvc-azure = callPackage ../development/python-modules/dvc-azure {  };

  dvc-data = callPackage ../development/python-modules/dvc-data {  };

  dvc-gdrive = callPackage ../development/python-modules/dvc-gdrive {  };

  dvc-gs = callPackage ../development/python-modules/dvc-gs { };

  dvc-hdfs = callPackage ../development/python-modules/dvc-hdfs {  };

  dvc-http = callPackage ../development/python-modules/dvc-http {  };

  dvc-objects = callPackage ../development/python-modules/dvc-objects {  };

  dvc-render = callPackage ../development/python-modules/dvc-render {  };

  dvc-s3 = callPackage ../development/python-modules/dvc-s3 { };

  dvc-ssh = callPackage ../development/python-modules/dvc-ssh { };

  dvc-studio-client = callPackage ../development/python-modules/dvc-studio-client {  };

  dvc-task = callPackage ../development/python-modules/dvc-task {  };

  dvclive = callPackage ../development/python-modules/dvclive {  };

  dwdwfsapi = callPackage ../development/python-modules/dwdwfsapi { };

  dyn = callPackage ../development/python-modules/dyn { };

  dynalite-devices = callPackage ../development/python-modules/dynalite-devices { };

  dynalite-panel = callPackage ../development/python-modules/dynalite-panel { };

  dynd = callPackage ../development/python-modules/dynd { };

  dsl2html = callPackage ../development/python-modules/dsl2html { };

  e3-core = callPackage ../development/python-modules/e3-core { };

  e3-testsuite = callPackage ../development/python-modules/e3-testsuite { };

  eagle100 = callPackage ../development/python-modules/eagle100 { };

  easydict = callPackage ../development/python-modules/easydict { };

  easyenergy = callPackage ../development/python-modules/easyenergy { };

  easygui = callPackage ../development/python-modules/easygui { };

  easyocr = callPackage ../development/python-modules/easyocr { };

  easyprocess = callPackage ../development/python-modules/easyprocess { };

  easy-thumbnails = callPackage ../development/python-modules/easy-thumbnails { };

  easywatch = callPackage ../development/python-modules/easywatch { };

  ebaysdk = callPackage ../development/python-modules/ebaysdk { };

  ebcdic = callPackage ../development/python-modules/ebcdic { };

  ebooklib = callPackage ../development/python-modules/ebooklib { };

  ec2instanceconnectcli = callPackage ../tools/virtualization/ec2instanceconnectcli { };

  eccodes = toPythonModule (pkgs.eccodes.override {
    enablePython = true;
    pythonPackages = self;
  });

  ecdsa = callPackage ../development/python-modules/ecdsa { };

  echo = callPackage ../development/python-modules/echo { };

  ecoaliface = callPackage ../development/python-modules/ecoaliface { };

  ecos = callPackage ../development/python-modules/ecos { };

  ecpy = callPackage ../development/python-modules/ecpy { };

  ecs-logging =  callPackage ../development/python-modules/ecs-logging { };

  ed25519 = callPackage ../development/python-modules/ed25519 { };

  ed25519-blake2b = callPackage ../development/python-modules/ed25519-blake2b { };

  edalize = callPackage ../development/python-modules/edalize { };

  editables = callPackage ../development/python-modules/editables { };

  editdistance = callPackage ../development/python-modules/editdistance { };

  editdistance-s = callPackage ../development/python-modules/editdistance-s { };

  editdistpy = callPackage ../development/python-modules/editdistpy { };

  editor = callPackage ../development/python-modules/editor { };

  editorconfig = callPackage ../development/python-modules/editorconfig { };

  edk2-pytool-library = callPackage ../development/python-modules/edk2-pytool-library { };

  edlib = callPackage ../development/python-modules/edlib {
    inherit (pkgs) edlib;
  };

  eduvpn-common = callPackage ../development/python-modules/eduvpn-common { };

  edward = callPackage ../development/python-modules/edward { };

  effdet = callPackage ../development/python-modules/effdet { };

  effect = callPackage ../development/python-modules/effect { };

  eggdeps = callPackage ../development/python-modules/eggdeps { };

  eigenpy = toPythonModule (callPackage ../development/python-modules/eigenpy { });

  einops = callPackage ../development/python-modules/einops { };

  eiswarnung = callPackage ../development/python-modules/eiswarnung { };

  elgato = callPackage ../development/python-modules/elgato { };

  elkm1-lib = callPackage ../development/python-modules/elkm1-lib { };

  elastic-apm = callPackage ../development/python-modules/elastic-apm { };

  elastic-transport = callPackage ../development/python-modules/elastic-transport { };

  elasticsearch = callPackage ../development/python-modules/elasticsearch { };

  elasticsearch8 = callPackage ../development/python-modules/elasticsearch8 { };

  elasticsearch-dsl = callPackage ../development/python-modules/elasticsearch-dsl { };

  elasticsearchdsl = self.elasticsearch-dsl;

  elegy = callPackage ../development/python-modules/elegy { };

  elementpath = callPackage ../development/python-modules/elementpath { };

  elevate = callPackage ../development/python-modules/elevate { };

  eliot = callPackage ../development/python-modules/eliot { };

  eliqonline = callPackage ../development/python-modules/eliqonline { };

  elmax = callPackage ../development/python-modules/elmax { };

  elmax-api = callPackage ../development/python-modules/elmax-api { };

  emailthreads = callPackage ../development/python-modules/emailthreads { };

  email-validator = callPackage ../development/python-modules/email-validator { };

  embedding-reader = callPackage ../development/python-modules/embedding-reader { };

  embrace = callPackage ../development/python-modules/embrace { };

  emborg = callPackage ../development/python-modules/emborg { };

  emcee = callPackage ../development/python-modules/emcee { };

  emv = callPackage ../development/python-modules/emv { };

  emoji = callPackage ../development/python-modules/emoji { };

  empty-files = callPackage ../development/python-modules/empty-files { };

  empy = callPackage ../development/python-modules/empy { };

  emulated-roku = callPackage ../development/python-modules/emulated-roku { };

  enaml = callPackage ../development/python-modules/enaml { };

  enamlx = callPackage ../development/python-modules/enamlx { };

  encodec = callPackage ../development/python-modules/encodec { };

  energyflip-client = callPackage ../development/python-modules/energyflip-client { };

  energyflow = callPackage ../development/python-modules/energyflow { };

  energyzero =  callPackage ../development/python-modules/energyzero { };

  enlighten = callPackage ../development/python-modules/enlighten { };

  enocean = callPackage ../development/python-modules/enocean { };

  enochecker-core = callPackage ../development/python-modules/enochecker-core { };

  enrich = callPackage ../development/python-modules/enrich { };

  entrance = callPackage ../development/python-modules/entrance {
    routerFeatures = false;
  };

  entrance-with-router-features = callPackage ../development/python-modules/entrance {
    routerFeatures = true;
  };

  entry-points-txt = callPackage ../development/python-modules/entry-points-txt { };

  entrypoint2 = callPackage ../development/python-modules/entrypoint2 { };

  entrypoints = callPackage ../development/python-modules/entrypoints { };

  enturclient = callPackage ../development/python-modules/enturclient { };

  enum34 = callPackage ../development/python-modules/enum34 { };

  enum-compat = callPackage ../development/python-modules/enum-compat { };

  env-canada = callPackage ../development/python-modules/env-canada { };

  environmental-override = callPackage ../development/python-modules/environmental-override { };

  environs = callPackage ../development/python-modules/environs { };

  envisage = callPackage ../development/python-modules/envisage { };

  envs = callPackage ../development/python-modules/envs { };

  envoy-reader = callPackage ../development/python-modules/envoy-reader { };

  envoy-utils = callPackage ../development/python-modules/envoy-utils { };

  enzyme = callPackage ../development/python-modules/enzyme { };

  epc = callPackage ../development/python-modules/epc { };

  ephem = callPackage ../development/python-modules/ephem { };

  ephemeral-port-reserve = callPackage ../development/python-modules/ephemeral-port-reserve { };

  epion = callPackage ../development/python-modules/epion { };

  epson-projector = callPackage ../development/python-modules/epson-projector { };

  equinox = callPackage ../development/python-modules/equinox { };

  eradicate = callPackage ../development/python-modules/eradicate { };

  es-client = callPackage ../development/python-modules/es-client { };

  esig = callPackage ../development/python-modules/esig { };

  espeak-phonemizer = callPackage ../development/python-modules/espeak-phonemizer { };

  esphome-dashboard-api = callPackage ../development/python-modules/esphome-dashboard-api { };

  esprima = callPackage ../development/python-modules/esprima { };

  escapism = callPackage ../development/python-modules/escapism { };

  essentials = callPackage ../development/python-modules/essentials { };

  essentials-openapi = callPackage ../development/python-modules/essentials-openapi { };

  etcd = callPackage ../development/python-modules/etcd { };

  etcd3 = callPackage ../development/python-modules/etcd3 {
    inherit (pkgs) etcd;
  };

  ete3 = callPackage ../development/python-modules/ete3 { };

  etelemetry = callPackage ../development/python-modules/etelemetry { };

  etebase = callPackage ../development/python-modules/etebase {
    inherit (pkgs.darwin.apple_sdk.frameworks) Security;
  };

  etebase-server = callPackage ../servers/etebase { };

  eternalegypt = callPackage ../development/python-modules/eternalegypt { };

  etesync = callPackage ../development/python-modules/etesync { };

  eth-abi = callPackage ../development/python-modules/eth-abi { };

  eth-account = callPackage ../development/python-modules/eth-account { };

  eth-hash = callPackage ../development/python-modules/eth-hash { };

  eth-keyfile = callPackage ../development/python-modules/eth-keyfile { };

  eth-keys = callPackage ../development/python-modules/eth-keys { };

  eth-rlp = callPackage ../development/python-modules/eth-rlp { };

  eth-typing = callPackage ../development/python-modules/eth-typing { };

  eth-utils = callPackage ../development/python-modules/eth-utils { };

  etils = callPackage ../development/python-modules/etils { };

  etuples = callPackage ../development/python-modules/etuples { };

  et-xmlfile = callPackage ../development/python-modules/et-xmlfile { };

  euclid3 = callPackage ../development/python-modules/euclid3 { };

  eufylife-ble-client = callPackage ../development/python-modules/eufylife-ble-client { };

  evaluate = callPackage ../development/python-modules/evaluate { };

  evdev = callPackage ../development/python-modules/evdev { };

  eve = callPackage ../development/python-modules/eve { };

  eventkit = callPackage ../development/python-modules/eventkit { };

  eventlet = callPackage ../development/python-modules/eventlet { };

  events = callPackage ../development/python-modules/events { };

  evernote = callPackage ../development/python-modules/evernote { };

  evohome-async = callPackage ../development/python-modules/evohome-async { };

  evtx = callPackage ../development/python-modules/evtx { };

  ewmh = callPackage ../development/python-modules/ewmh { };

  example-robot-data = toPythonModule (pkgs.example-robot-data.override {
    pythonSupport = true;
    python3Packages = self;
  });

  exdown = callPackage ../development/python-modules/exdown { };

  exceptiongroup = callPackage ../development/python-modules/exceptiongroup { };

  exchangelib = callPackage ../development/python-modules/exchangelib { };

  execnb = callPackage ../development/python-modules/execnb { };

  execnet = callPackage ../development/python-modules/execnet { };

  executing = callPackage ../development/python-modules/executing { };

  executor = callPackage ../development/python-modules/executor { };

  exif = callPackage ../development/python-modules/exif { };

  exifread = callPackage ../development/python-modules/exifread { };

  expandvars = callPackage ../development/python-modules/expandvars { };

  expects = callPackage ../development/python-modules/expects { };

  expecttest = callPackage ../development/python-modules/expecttest { };

  experiment-utilities = callPackage ../development/python-modules/experiment-utilities { };

  expiring-dict = callPackage ../development/python-modules/expiring-dict { };

  expiringdict = callPackage ../development/python-modules/expiringdict { };

  explorerscript = callPackage ../development/python-modules/explorerscript { };

  exrex = callPackage ../development/python-modules/exrex { };

  exitcode = callPackage ../development/python-modules/exitcode { };

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
      zstd;
  };

  extras = callPackage ../development/python-modules/extras { };

  extruct = callPackage ../development/python-modules/extruct { };

  eyed3 = callPackage ../development/python-modules/eyed3 { };

  ezdxf = callPackage ../development/python-modules/ezdxf { };

  ezyrb = callPackage ../development/python-modules/ezyrb { };

  f5-icontrol-rest = callPackage ../development/python-modules/f5-icontrol-rest { };

  f5-sdk = callPackage ../development/python-modules/f5-sdk { };

  f90nml = callPackage ../development/python-modules/f90nml { };

  fabric = callPackage ../development/python-modules/fabric { };

  faadelays = callPackage ../development/python-modules/faadelays { };

  fabulous = callPackage ../development/python-modules/fabulous { };

  facebook-sdk = callPackage ../development/python-modules/facebook-sdk { };

  face = callPackage ../development/python-modules/face { };

  facedancer = callPackage ../development/python-modules/facedancer { };

  face-recognition = callPackage ../development/python-modules/face-recognition { };

  facenet-pytorch = callPackage ../development/python-modules/facenet-pytorch { };

  face-recognition-models = callPackage ../development/python-modules/face-recognition/models.nix { };

  factory-boy = callPackage ../development/python-modules/factory-boy { };

  fairscale = callPackage ../development/python-modules/fairscale { };

  fairseq = callPackage ../development/python-modules/fairseq { };

  faiss = toPythonModule (pkgs.faiss.override {
    pythonSupport = true;
    pythonPackages = self;
  });

  fake-useragent = callPackage ../development/python-modules/fake-useragent { };

  faker = callPackage ../development/python-modules/faker { };

  fakeredis = callPackage ../development/python-modules/fakeredis { };

  falcon = callPackage ../development/python-modules/falcon { };

  faraday-agent-parameters-types = callPackage ../development/python-modules/faraday-agent-parameters-types { };

  faraday-plugins = callPackage ../development/python-modules/faraday-plugins { };

  farama-notifications = callPackage ../development/python-modules/farama-notifications { };

  farm-haystack = callPackage ../development/python-modules/farm-haystack { };

  fastai = callPackage ../development/python-modules/fastai { };

  fastapi = callPackage ../development/python-modules/fastapi { };

  fastapi-mail = callPackage ../development/python-modules/fastapi-mail { };

  fastapi-sso = callPackage ../development/python-modules/fastapi-sso { };

  fast-histogram = callPackage ../development/python-modules/fast-histogram { };

  fastavro = callPackage ../development/python-modules/fastavro { };

  fastbencode = callPackage ../development/python-modules/fastbencode { };

  fastcache = callPackage ../development/python-modules/fastcache { };

  fastcore = callPackage ../development/python-modules/fastcore { };

  fastdiff = callPackage ../development/python-modules/fastdiff { };

  fastdownload = callPackage ../development/python-modules/fastdownload { };

  fastdtw = callPackage ../development/python-modules/fastdtw { };

  fastecdsa = callPackage ../development/python-modules/fastecdsa { };

  fastembed = callPackage ../development/python-modules/fastembed { };

  fasteners = callPackage ../development/python-modules/fasteners { };

  fastentrypoints = callPackage ../development/python-modules/fastentrypoints { };

  faster-fifo = callPackage ../development/python-modules/faster-fifo { };

  faster-whisper = callPackage ../development/python-modules/faster-whisper { };

  fastimport = callPackage ../development/python-modules/fastimport { };

  fastjet = toPythonModule (pkgs.fastjet.override {
    withPython = true;
    inherit (self) python;
  });

  fastjsonschema = callPackage ../development/python-modules/fastjsonschema { };

  fastnlo-toolkit = toPythonModule (pkgs.fastnlo-toolkit.override {
    withPython = true;
    inherit (self) python;
  });

  fastnumbers = callPackage ../development/python-modules/fastnumbers { };

  fastpair = callPackage ../development/python-modules/fastpair { };

  fastparquet = callPackage ../development/python-modules/fastparquet { };

  fastpbkdf2 = callPackage ../development/python-modules/fastpbkdf2 { };

  fastprogress = callPackage ../development/python-modules/fastprogress { };

  fastrlock = callPackage ../development/python-modules/fastrlock { };

  fasttext = callPackage ../development/python-modules/fasttext { };

  fasttext-predict = callPackage ../development/python-modules/fasttext-predict { };

  faust-cchardet = callPackage ../development/python-modules/faust-cchardet { };

  favicon = callPackage ../development/python-modules/favicon { };

  fb-re2 = callPackage ../development/python-modules/fb-re2 { };

  fe25519 = callPackage ../development/python-modules/fe25519 { };

  feedfinder2 = callPackage ../development/python-modules/feedfinder2 { };

  feedgen = callPackage ../development/python-modules/feedgen { };

  feedgenerator = callPackage ../development/python-modules/feedgenerator {
    inherit (pkgs) glibcLocales;
  };

  feedparser = callPackage ../development/python-modules/feedparser { };

  fenics = callPackage ../development/python-modules/fenics {
    hdf5 = pkgs.hdf5_1_10;
  };

  ffcv = callPackage ../development/python-modules/ffcv { };

  ffmpeg-python = callPackage ../development/python-modules/ffmpeg-python { };

  ffmpeg-progress-yield = callPackage ../development/python-modules/ffmpeg-progress-yield { };

  ffmpy = callPackage ../development/python-modules/ffmpy { };

  fhir-py = callPackage ../development/python-modules/fhir-py { };

  fiblary3-fork = callPackage ../development/python-modules/fiblary3-fork { };

  fido2 = callPackage ../development/python-modules/fido2 { };

  fields = callPackage ../development/python-modules/fields { };

  file-read-backwards = callPackage ../development/python-modules/file-read-backwards { };

  filebrowser-safe = callPackage ../development/python-modules/filebrowser-safe { };

  filebytes = callPackage ../development/python-modules/filebytes { };

  filecheck = callPackage ../development/python-modules/filecheck { };

  filedepot = callPackage ../development/python-modules/filedepot { };

  filelock = callPackage ../development/python-modules/filelock { };

  filetype = callPackage ../development/python-modules/filetype { };

  filterpy = callPackage ../development/python-modules/filterpy { };

  finalfusion = callPackage ../development/python-modules/finalfusion { };

  findimports = callPackage ../development/python-modules/findimports { };

  find-libpython = callPackage ../development/python-modules/find-libpython { };

  findpython = callPackage ../development/python-modules/findpython { };

  fingerprints = callPackage ../development/python-modules/fingerprints { };

  finitude = callPackage ../development/python-modules/finitude { };

  fints = callPackage ../development/python-modules/fints { };

  finvizfinance = callPackage ../development/python-modules/finvizfinance { };

  fiona = callPackage ../development/python-modules/fiona { };

  fipy = callPackage ../development/python-modules/fipy { };

  fire = callPackage ../development/python-modules/fire { };

  firebase-messaging = callPackage ../development/python-modules/firebase-messaging { };

  fireflyalgorithm = callPackage ../development/python-modules/fireflyalgorithm { };

  firetv = callPackage ../development/python-modules/firetv { };

  first = callPackage ../development/python-modules/first { };

  fitbit = callPackage ../development/python-modules/fitbit { };

  fivem-api = callPackage ../development/python-modules/fivem-api { };

  fixerio = callPackage ../development/python-modules/fixerio { };

  fixtures = callPackage ../development/python-modules/fixtures { };

  fjaraskupan = callPackage ../development/python-modules/fjaraskupan { };

  flake8-blind-except = callPackage ../development/python-modules/flake8-blind-except { };

  flake8-bugbear = callPackage ../development/python-modules/flake8-bugbear { };

  flake8 = callPackage ../development/python-modules/flake8 { };

  flake8-length = callPackage ../development/python-modules/flake8-length { };

  flake8-debugger = callPackage ../development/python-modules/flake8-debugger { };

  flake8-docstrings = callPackage ../development/python-modules/flake8-docstrings { };

  flake8-future-import = callPackage ../development/python-modules/flake8-future-import { };

  flake8-import-order = callPackage ../development/python-modules/flake8-import-order { };

  flake8-polyfill = callPackage ../development/python-modules/flake8-polyfill { };

  flaky = callPackage ../development/python-modules/flaky { };

  flametree = callPackage ../development/python-modules/flametree { };

  flammkuchen = callPackage ../development/python-modules/flammkuchen { };

  flasgger = callPackage ../development/python-modules/flasgger { };

  flashtext = callPackage ../development/python-modules/flashtext { };

  flask-admin = callPackage ../development/python-modules/flask-admin { };

  flask-api = callPackage ../development/python-modules/flask-api { };

  flask-appbuilder = callPackage ../development/python-modules/flask-appbuilder { };

  flask-assets = callPackage ../development/python-modules/flask-assets { };

  flask-babel = callPackage ../development/python-modules/flask-babel { };

  flask-babelex = callPackage ../development/python-modules/flask-babelex { };

  flask-bcrypt = callPackage ../development/python-modules/flask-bcrypt { };

  flask-bootstrap = callPackage ../development/python-modules/flask-bootstrap { };

  flask-caching = callPackage ../development/python-modules/flask-caching { };

  flask = callPackage ../development/python-modules/flask { };

  flask-common = callPackage ../development/python-modules/flask-common { };

  flask-compress = callPackage ../development/python-modules/flask-compress { };

  flask-cors = callPackage ../development/python-modules/flask-cors { };

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

  flask-session = callPackage ../development/python-modules/flask-session { };

  flask-session-captcha = callPackage ../development/python-modules/flask-session-captcha { };

  flask-security-too = callPackage ../development/python-modules/flask-security-too { };

  flask-silk = callPackage ../development/python-modules/flask-silk { };

  flask-sock = callPackage ../development/python-modules/flask-sock { };

  flask-socketio = callPackage ../development/python-modules/flask-socketio { };

  flask-sockets = callPackage ../development/python-modules/flask-sockets { };

  flask-sqlalchemy = callPackage ../development/python-modules/flask-sqlalchemy { };

  flask-sslify = callPackage ../development/python-modules/flask-sslify { };

  flask-swagger = callPackage ../development/python-modules/flask-swagger { };

  flask-swagger-ui = callPackage ../development/python-modules/flask-swagger-ui { };

  flask-talisman = callPackage ../development/python-modules/flask-talisman { };

  flask-testing = callPackage ../development/python-modules/flask-testing { };

  flask-themes2 = callPackage ../development/python-modules/flask-themes2 { };

  flask-versioned = callPackage ../development/python-modules/flask-versioned { };

  flask-wtf = callPackage ../development/python-modules/flask-wtf { };

  flatbuffers = callPackage ../development/python-modules/flatbuffers {
    inherit (pkgs) flatbuffers;
  };

  flatdict = callPackage ../development/python-modules/flatdict { };

  flatten-dict = callPackage ../development/python-modules/flatten-dict { };

  flax = callPackage ../development/python-modules/flax { };

  fleep = callPackage ../development/python-modules/fleep { };

  flet = callPackage ../development/python-modules/flet { };

  flet-core = callPackage ../development/python-modules/flet-core { };

  flet-runtime = callPackage ../development/python-modules/flet-runtime { };

  flexmock = callPackage ../development/python-modules/flexmock { };

  flickrapi = callPackage ../development/python-modules/flickrapi { };

  flipr-api = callPackage ../development/python-modules/flipr-api { };

  flit = callPackage ../development/python-modules/flit { };

  flit-core = callPackage ../development/python-modules/flit-core { };

  flit-scm = callPackage ../development/python-modules/flit-scm { };

  floret = callPackage ../development/python-modules/floret { };

  flow-record = callPackage ../development/python-modules/flow-record { };

  flower = callPackage ../development/python-modules/flower { };

  flowlogs-reader = callPackage ../development/python-modules/flowlogs-reader { };

  fluent-logger = callPackage ../development/python-modules/fluent-logger { };

  flufl-bounce = callPackage ../development/python-modules/flufl/bounce.nix { };

  flufl-i18n = callPackage ../development/python-modules/flufl/i18n.nix { };

  flufl-lock = callPackage ../development/python-modules/flufl/lock.nix { };

  flux-led = callPackage ../development/python-modules/flux-led { };

  flyingsquid = callPackage ../development/python-modules/flyingsquid { };

  flynt = callPackage ../development/python-modules/flynt { };

  fn = callPackage ../development/python-modules/fn { };

  fnv-hash-fast = callPackage ../development/python-modules/fnv-hash-fast { };

  fnvhash = callPackage ../development/python-modules/fnvhash { };

  folium = callPackage ../development/python-modules/folium { };

  fontawesomefree = callPackage ../development/python-modules/fontawesomefree { };

  fontbakery = callPackage ../development/python-modules/fontbakery { };

  fontfeatures = callPackage ../development/python-modules/fontfeatures { };

  fontforge = toPythonModule (pkgs.fontforge.override {
    withPython = true;
    inherit python;
  });

  fontmath = callPackage ../development/python-modules/fontmath { };

  fontparts = callPackage ../development/python-modules/fontparts { };

  fontpens = callPackage ../development/python-modules/fontpens { };

  fonttools = callPackage ../development/python-modules/fonttools { };

  fontmake = callPackage ../development/python-modules/fontmake { };

  font-v = callPackage ../development/python-modules/font-v { };

  skia-pathops = callPackage ../development/python-modules/skia-pathops {
    inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices OpenGL;
  };

  oelint-parser = callPackage ../development/python-modules/oelint-parser { };

  openllm = callPackage ../development/python-modules/openllm {
    openai-triton = self.openai-triton-cuda;
  };

  openllm-client = callPackage ../development/python-modules/openllm-client { };

  openllm-core = callPackage ../development/python-modules/openllm-core { };

  openstep-plist = callPackage ../development/python-modules/openstep-plist { };

  glyphsets = callPackage ../development/python-modules/glyphsets { };

  glyphslib = callPackage ../development/python-modules/glyphslib { };

  glyphtools = callPackage ../development/python-modules/glyphtools { };

  foobot-async = callPackage ../development/python-modules/foobot-async { };

  foolscap = callPackage ../development/python-modules/foolscap { };

  forbiddenfruit = callPackage ../development/python-modules/forbiddenfruit { };

  fordpass = callPackage ../development/python-modules/fordpass { };

  forecast-solar = callPackage ../development/python-modules/forecast-solar { };

  formbox = callPackage ../development/python-modules/formbox { };

  formulae = callPackage ../development/python-modules/formulae { };

  fortiosapi = callPackage ../development/python-modules/fortiosapi { };

  formencode = callPackage ../development/python-modules/formencode { };

  formulaic = callPackage ../development/python-modules/formulaic { };

  foundationdb71 = callPackage ../servers/foundationdb/python.nix { foundationdb = pkgs.foundationdb71; };

  fountains = callPackage ../development/python-modules/fountains { };

  foxdot = callPackage ../development/python-modules/foxdot { };

  fpdf = callPackage ../development/python-modules/fpdf { };

  fpdf2 = callPackage ../development/python-modules/fpdf2 { };

  fpylll = callPackage ../development/python-modules/fpylll { };

  fpyutils = callPackage ../development/python-modules/fpyutils { };

  fqdn = callPackage ../development/python-modules/fqdn { };

  freebox-api = callPackage ../development/python-modules/freebox-api { };

  freetype-py = callPackage ../development/python-modules/freetype-py { };

  freezegun = callPackage ../development/python-modules/freezegun { };

  frelatage = callPackage ../development/python-modules/frelatage { };

  frida-python = callPackage ../development/python-modules/frida-python { };

  frigidaire = callPackage ../development/python-modules/frigidaire { };

  frilouz = callPackage ../development/python-modules/frilouz { };

  fritzconnection = callPackage ../development/python-modules/fritzconnection { };

  frozendict = callPackage ../development/python-modules/frozendict { };

  frozenlist = callPackage ../development/python-modules/frozenlist { };

  frozenlist2 = callPackage ../development/python-modules/frozenlist2 { };

  fs = callPackage ../development/python-modules/fs { };

  fs-s3fs = callPackage ../development/python-modules/fs-s3fs { };

  fschat = callPackage ../development/python-modules/fschat { };

  fsspec-xrootd = callPackage ../development/python-modules/fsspec-xrootd { };

  fsspec = callPackage ../development/python-modules/fsspec { };

  fst-pso = callPackage ../development/python-modules/fst-pso { };

  ftfy = callPackage ../development/python-modules/ftfy { };

  ftputil = callPackage ../development/python-modules/ftputil { };

  fugashi = callPackage ../development/python-modules/fugashi { };

  func-timeout = callPackage ../development/python-modules/func-timeout { };

  funcparserlib = callPackage ../development/python-modules/funcparserlib { };

  funcsigs = callPackage ../development/python-modules/funcsigs { };

  functiontrace = callPackage ../development/python-modules/functiontrace { };

  functools32 = callPackage ../development/python-modules/functools32 { };

  funcy = callPackage ../development/python-modules/funcy { };

  funsor = callPackage ../development/python-modules/funsor { };

  furl = callPackage ../development/python-modules/furl { };

  furo = callPackage ../development/python-modules/furo { };

  fuse = callPackage ../development/python-modules/fuse-python {
    inherit (pkgs) fuse;
  };

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

  g2pkk = callPackage ../development/python-modules/g2pkk { };

  galario = toPythonModule (pkgs.galario.override {
    enablePython = true;
    pythonPackages = self;
  });

  galois = callPackage ../development/python-modules/galois { };

  gamble = callPackage ../development/python-modules/gamble { };

  gaphas = callPackage ../development/python-modules/gaphas { };

  gardena-bluetooth = callPackage ../development/python-modules/gardena-bluetooth { };

  garminconnect-aio = callPackage ../development/python-modules/garminconnect-aio { };

  garminconnect = callPackage ../development/python-modules/garminconnect { };

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

  gbulb = callPackage ../development/python-modules/gbulb { };

  gcal-sync = callPackage ../development/python-modules/gcal-sync { };

  gcodepy = callPackage ../development/python-modules/gcodepy { };

  gcovr = callPackage ../development/python-modules/gcovr { };

  gcs-oauth2-boto-plugin = callPackage ../development/python-modules/gcs-oauth2-boto-plugin { };

  gcsa = callPackage ../development/python-modules/gcsa { };

  gcsfs = callPackage ../development/python-modules/gcsfs { };

  gdal = toPythonModule (pkgs.gdal.override { python3 = python; });

  gdata = callPackage ../development/python-modules/gdata { };

  gdcm = toPythonModule (pkgs.gdcm.override {
    inherit (self) python;
    enablePython = true;
  });

  gdown = callPackage ../development/python-modules/gdown { };

  ge25519 = callPackage ../development/python-modules/ge25519 { };

  geant4 = toPythonModule (pkgs.geant4.override {
    enablePython = true;
    python3 = python;
  });

  geeknote = callPackage ../development/python-modules/geeknote { };

  gehomesdk = callPackage ../development/python-modules/gehomesdk { };

  gekitchen = callPackage ../development/python-modules/gekitchen { };

  gekko = callPackage ../development/python-modules/gekko { };

  gemfileparser = callPackage ../development/python-modules/gemfileparser { };

  gemfileparser2 = callPackage ../development/python-modules/gemfileparser2 { };

  genanki = callPackage ../development/python-modules/genanki { };

  generic = callPackage ../development/python-modules/generic { };

  geniushub-client = callPackage ../development/python-modules/geniushub-client { };

  genome-collector = callPackage ../development/python-modules/genome-collector { };

  genpy = callPackage ../development/python-modules/genpy { };

  genshi = callPackage ../development/python-modules/genshi { };

  gensim = callPackage ../development/python-modules/gensim { };

  gentools = callPackage ../development/python-modules/gentools { };

  genzshcomp = callPackage ../development/python-modules/genzshcomp { };

  geoalchemy2 = callPackage ../development/python-modules/geoalchemy2 { };

  geocachingapi = callPackage ../development/python-modules/geocachingapi { };

  geographiclib = callPackage ../development/python-modules/geographiclib { };

  geoip2 = callPackage ../development/python-modules/geoip2 { };

  geoip = callPackage ../development/python-modules/geoip {
    libgeoip = pkgs.geoip;
  };

  geojson = callPackage ../development/python-modules/geojson { };

  geojson-client = callPackage ../development/python-modules/geojson-client { };

  geomet = callPackage ../development/python-modules/geomet { };

  geometric = callPackage ../development/python-modules/geometric { };

  geopandas = callPackage ../development/python-modules/geopandas { };

  geopy = callPackage ../development/python-modules/geopy { };

  georss-client = callPackage ../development/python-modules/georss-client { };

  georss-generic-client = callPackage ../development/python-modules/georss-generic-client { };

  georss-ign-sismologia-client = callPackage ../development/python-modules/georss-ign-sismologia-client { };

  georss-ingv-centro-nazionale-terremoti-client = callPackage ../development/python-modules/georss-ingv-centro-nazionale-terremoti-client { };

  georss-nrcan-earthquakes-client = callPackage ../development/python-modules/georss-nrcan-earthquakes-client { };

  georss-qld-bushfire-alert-client = callPackage ../development/python-modules/georss-qld-bushfire-alert-client { };

  georss-tfs-incidents-client = callPackage ../development/python-modules/georss-tfs-incidents-client { };

  georss-wa-dfes-client = callPackage ../development/python-modules/georss-wa-dfes-client { };

  gerbonara = callPackage ../development/python-modules/gerbonara { };

  getjump = callPackage ../development/python-modules/getjump { };

  getmac = callPackage ../development/python-modules/getmac { };

  getkey = callPackage ../development/python-modules/getkey { };

  get-video-properties = callPackage ../development/python-modules/get-video-properties { };

  gevent = callPackage ../development/python-modules/gevent { };

  geventhttpclient = callPackage ../development/python-modules/geventhttpclient { };

  gevent-socketio = callPackage ../development/python-modules/gevent-socketio { };

  gevent-websocket = callPackage ../development/python-modules/gevent-websocket { };

  gflags = callPackage ../development/python-modules/gflags { };

  gflanguages = callPackage ../development/python-modules/gflanguages { };

  ghapi = callPackage ../development/python-modules/ghapi { };

  ghdiff = callPackage ../development/python-modules/ghdiff { };

  ghp-import = callPackage ../development/python-modules/ghp-import { };

  ghrepo-stats = callPackage ../development/python-modules/ghrepo-stats { };

  gibberish-detector = callPackage ../development/python-modules/gibberish-detector { };

  gidgethub = callPackage ../development/python-modules/gidgethub { };

  gin-config = callPackage ../development/python-modules/gin-config { };

  gios = callPackage ../development/python-modules/gios { };

  gipc = callPackage ../development/python-modules/gipc { };

  gistyc = callPackage ../development/python-modules/gistyc { };

  git-annex-adapter =
    callPackage ../development/python-modules/git-annex-adapter { };

  git-filter-repo = callPackage ../development/python-modules/git-filter-repo { };

  git-revise = callPackage ../development/python-modules/git-revise { };

  git-sweep = callPackage ../development/python-modules/git-sweep { };

  git-url-parse = callPackage ../development/python-modules/git-url-parse { };

  gitdb = callPackage ../development/python-modules/gitdb { };

  githubkit = callPackage ../development/python-modules/githubkit { };

  github-to-sqlite = callPackage ../development/python-modules/github-to-sqlite { };

  github-webhook = callPackage ../development/python-modules/github-webhook { };

  github3-py = callPackage ../development/python-modules/github3-py { };

  gitignore-parser = callPackage ../development/python-modules/gitignore-parser { };

  gitlike-commands = callPackage ../development/python-modules/gitlike-commands { };

  gitpython = callPackage ../development/python-modules/gitpython { };

  glad =  callPackage ../development/python-modules/glad { };

  glad2 =  callPackage ../development/python-modules/glad2 { };

  glances-api = callPackage ../development/python-modules/glances-api { };

  glcontext = callPackage ../development/python-modules/glcontext { };

  glean-parser = callPackage ../development/python-modules/glean-parser { };

  glean-sdk = callPackage ../development/python-modules/glean-sdk {
    inherit (pkgs) lmdb;
  };

  glfw = callPackage ../development/python-modules/glfw { };

  glob2 = callPackage ../development/python-modules/glob2 { };

  globre = callPackage ../development/python-modules/globre { };

  globus-sdk = callPackage ../development/python-modules/globus-sdk { };

  glom = callPackage ../development/python-modules/glom { };

  glueviz = callPackage ../development/python-modules/glueviz { };

  glymur = callPackage ../development/python-modules/glymur { };

  gmpy2 = callPackage ../development/python-modules/gmpy2 { };

  gmpy = callPackage ../development/python-modules/gmpy { };

  gmsh = toPythonModule (callPackage ../applications/science/math/gmsh {
    enablePython = true;
  });

  gntp = callPackage ../development/python-modules/gntp { };

  gnureadline = callPackage ../development/python-modules/gnureadline { };

  goalzero = callPackage ../development/python-modules/goalzero { };

  gocardless-pro = callPackage ../development/python-modules/gocardless-pro { };

  goobook = callPackage ../development/python-modules/goobook { };

  goocalendar = callPackage ../development/python-modules/goocalendar { };

  goodwe = callPackage ../development/python-modules/goodwe { };

  google = callPackage ../development/python-modules/google { };

  google-ai-generativelanguage = callPackage ../development/python-modules/google-ai-generativelanguage { };

  google-api-core = callPackage ../development/python-modules/google-api-core { };

  google-api-python-client = callPackage ../development/python-modules/google-api-python-client { };

  googleapis-common-protos = callPackage ../development/python-modules/googleapis-common-protos { };

  google-auth = callPackage ../development/python-modules/google-auth { };

  google-auth-httplib2 = callPackage ../development/python-modules/google-auth-httplib2 { };

  google-auth-oauthlib = callPackage ../development/python-modules/google-auth-oauthlib { };

  google-cloud-access-context-manager = callPackage ../development/python-modules/google-cloud-access-context-manager { };

  google-cloud-appengine-logging = callPackage ../development/python-modules/google-cloud-appengine-logging { };

  google-cloud-artifact-registry = callPackage ../development/python-modules/google-cloud-artifact-registry { };

  google-cloud-asset = callPackage ../development/python-modules/google-cloud-asset { };

  google-cloud-audit-log = callPackage ../development/python-modules/google-cloud-audit-log { };

  google-cloud-automl = callPackage ../development/python-modules/google-cloud-automl { };

  google-cloud-bigquery = callPackage ../development/python-modules/google-cloud-bigquery { };

  google-cloud-bigquery-datatransfer = callPackage ../development/python-modules/google-cloud-bigquery-datatransfer { };

  google-cloud-bigquery-logging = callPackage ../development/python-modules/google-cloud-bigquery-logging { };

  google-cloud-bigquery-storage = callPackage ../development/python-modules/google-cloud-bigquery-storage { };

  google-cloud-bigtable = callPackage ../development/python-modules/google-cloud-bigtable { };

  google-cloud-compute = callPackage ../development/python-modules/google-cloud-compute { };

  google-cloud-container = callPackage ../development/python-modules/google-cloud-container { };

  google-cloud-core = callPackage ../development/python-modules/google-cloud-core { };

  google-cloud-datacatalog = callPackage ../development/python-modules/google-cloud-datacatalog { };

  google-cloud-dataproc = callPackage ../development/python-modules/google-cloud-dataproc { };

  google-cloud-datastore = callPackage ../development/python-modules/google-cloud-datastore { };

  google-cloud-dlp = callPackage ../development/python-modules/google-cloud-dlp { };

  google-cloud-dns = callPackage ../development/python-modules/google-cloud-dns { };

  google-cloud-error-reporting = callPackage ../development/python-modules/google-cloud-error-reporting { };

  google-cloud-firestore = callPackage ../development/python-modules/google-cloud-firestore { };

  google-cloud-iam = callPackage ../development/python-modules/google-cloud-iam { };

  google-cloud-iam-logging = callPackage ../development/python-modules/google-cloud-iam-logging { };

  google-cloud-iot = callPackage ../development/python-modules/google-cloud-iot { };

  google-cloud-kms = callPackage ../development/python-modules/google-cloud-kms { };

  google-cloud-language = callPackage ../development/python-modules/google-cloud-language { };

  google-cloud-logging = callPackage ../development/python-modules/google-cloud-logging { };

  google-cloud-monitoring = callPackage ../development/python-modules/google-cloud-monitoring { };

  google-cloud-netapp = callPackage ../development/python-modules/google-cloud-netapp { };

  google-cloud-org-policy = callPackage ../development/python-modules/google-cloud-org-policy { };

  google-cloud-os-config = callPackage ../development/python-modules/google-cloud-os-config { };

  google-cloud-pubsub = callPackage ../development/python-modules/google-cloud-pubsub { };

  google-cloud-redis = callPackage ../development/python-modules/google-cloud-redis { };

  google-cloud-resource-manager = callPackage ../development/python-modules/google-cloud-resource-manager { };

  google-cloud-runtimeconfig = callPackage ../development/python-modules/google-cloud-runtimeconfig { };

  google-cloud-secret-manager = callPackage ../development/python-modules/google-cloud-secret-manager { };

  google-cloud-securitycenter = callPackage ../development/python-modules/google-cloud-securitycenter { };

  google-cloud-shell = callPackage ../development/python-modules/google-cloud-shell { };

  google-cloud-spanner = callPackage ../development/python-modules/google-cloud-spanner { };

  google-cloud-speech = callPackage ../development/python-modules/google-cloud-speech { };

  google-cloud-storage = callPackage ../development/python-modules/google-cloud-storage { };

  google-cloud-tasks = callPackage ../development/python-modules/google-cloud-tasks { };

  google-cloud-testutils = callPackage ../development/python-modules/google-cloud-testutils { };

  google-cloud-texttospeech = callPackage ../development/python-modules/google-cloud-texttospeech { };

  google-cloud-trace = callPackage ../development/python-modules/google-cloud-trace { };

  google-cloud-translate = callPackage ../development/python-modules/google-cloud-translate { };

  google-cloud-videointelligence = callPackage ../development/python-modules/google-cloud-videointelligence { };

  google-cloud-vision = callPackage ../development/python-modules/google-cloud-vision { };

  google-cloud-vpc-access = callPackage ../development/python-modules/google-cloud-vpc-access { };

  google-cloud-webrisk = callPackage ../development/python-modules/google-cloud-webrisk { };

  google-cloud-websecurityscanner = callPackage ../development/python-modules/google-cloud-websecurityscanner { };

  google-cloud-workflows = callPackage ../development/python-modules/google-cloud-workflows { };

  google-cloud-workstations = callPackage ../development/python-modules/google-cloud-workstations { };

  google-compute-engine = callPackage ../tools/virtualization/google-compute-engine { };

  google-crc32c = callPackage ../development/python-modules/google-crc32c {
    inherit (pkgs) crc32c;
  };

  google-generativeai = callPackage ../development/python-modules/google-generativeai { };

  google-i18n-address = callPackage ../development/python-modules/google-i18n-address { };

  google-nest-sdm = callPackage ../development/python-modules/google-nest-sdm { };

  googlemaps = callPackage ../development/python-modules/googlemaps { };

  google-pasta = callPackage ../development/python-modules/google-pasta { };

  google-re2 = callPackage ../development/python-modules/google-re2 { };

  google-reauth = callPackage ../development/python-modules/google-reauth { };

  google-resumable-media = callPackage ../development/python-modules/google-resumable-media { };

  google-search-results = callPackage ../development/python-modules/google-search-results { };

  googletrans = callPackage ../development/python-modules/googletrans { };

  gotailwind = callPackage ../development/python-modules/gotailwind { };

  gotenberg-client = callPackage ../development/python-modules/gotenberg-client { };

  gorilla = callPackage ../development/python-modules/gorilla { };

  govee-ble = callPackage ../development/python-modules/govee-ble { };

  govee-led-wez = callPackage ../development/python-modules/govee-led-wez { };

  govee-local-api = callPackage ../development/python-modules/govee-local-api { };

  goveelights = callPackage ../development/python-modules/goveelights { };

  gpapi = callPackage ../development/python-modules/gpapi { };

  gpaw = callPackage ../development/python-modules/gpaw { };

  gpib-ctypes = callPackage ../development/python-modules/gpib-ctypes { };

  gpiozero = callPackage ../development/python-modules/gpiozero { };

  gplaycli = callPackage ../development/python-modules/gplaycli { };

  gpgme = toPythonModule (pkgs.gpgme.override {
    pythonSupport = true;
    python3 = python;
  });

  gphoto2 = callPackage ../development/python-modules/gphoto2 { };

  gprof2dot = callPackage ../development/python-modules/gprof2dot {
    inherit (pkgs) graphviz;
  };

  gps3 = callPackage ../development/python-modules/gps3 { };

  gpsoauth = callPackage ../development/python-modules/gpsoauth { };

  gpuctypes = callPackage ../development/python-modules/gpuctypes { };

  gpustat = callPackage ../development/python-modules/gpustat { };

  gpxpy = callPackage ../development/python-modules/gpxpy { };

  gpy = callPackage ../development/python-modules/gpy { };

  gpytorch = callPackage ../development/python-modules/gpytorch { };

  gpt-2-simple = callPackage ../development/python-modules/gpt-2-simple { };

  gptcache = callPackage ../development/python-modules/gptcache { };

  gql = callPackage ../development/python-modules/gql { };

  grad-cam = callPackage ../development/python-modules/grad-cam { };

  gradient = callPackage ../development/python-modules/gradient { };

  gradient-utils = callPackage ../development/python-modules/gradient-utils { };

  gradient-statsd = callPackage ../development/python-modules/gradient-statsd { };

  gradio = callPackage ../development/python-modules/gradio { };

  gradio-client = callPackage ../development/python-modules/gradio/client.nix { };

  gradio-pdf = callPackage ../development/python-modules/gradio-pdf { };

  grafanalib = callPackage ../development/python-modules/grafanalib/default.nix { };

  grammalecte = callPackage ../development/python-modules/grammalecte { };

  grandalf = callPackage ../development/python-modules/grandalf { };

  grapheme = callPackage ../development/python-modules/grapheme { };

  graphite-web = callPackage ../development/python-modules/graphite-web { };

  graphene = callPackage ../development/python-modules/graphene { };

  graphene-django = callPackage ../development/python-modules/graphene-django { };

  graphlib-backport = callPackage ../development/python-modules/graphlib-backport { };

  graphqlclient= callPackage ../development/python-modules/graphqlclient { };

  graphql-core = callPackage ../development/python-modules/graphql-core { };

  graphql-relay = callPackage ../development/python-modules/graphql-relay { };

  graphql-server-core = callPackage ../development/python-modules/graphql-server-core { };

  graphql-subscription-manager = callPackage ../development/python-modules/graphql-subscription-manager { };

  graph-tool = callPackage ../development/python-modules/graph-tool { };

  graphtage = callPackage ../development/python-modules/graphtage { };

  graphviz = callPackage ../development/python-modules/graphviz { };

  grappelli-safe = callPackage ../development/python-modules/grappelli-safe { };

  graspologic = callPackage ../development/python-modules/graspologic { };

  greatfet = callPackage ../development/python-modules/greatfet { };

  greeclimate = callPackage ../development/python-modules/greeclimate { };

  green = callPackage ../development/python-modules/green { };

  greeneye-monitor = callPackage ../development/python-modules/greeneye-monitor { };

  # built-in for pypi
  greenlet = if isPyPy then null else callPackage ../development/python-modules/greenlet { };

  grequests = callPackage ../development/python-modules/grequests { };

  gremlinpython = callPackage ../development/python-modules/gremlinpython { };

  greynoise = callPackage ../development/python-modules/greynoise { };

  growattserver = callPackage ../development/python-modules/growattserver { };

  gridnet = callPackage ../development/python-modules/gridnet { };

  griffe = callPackage ../development/python-modules/griffe { };

  grip = callPackage ../development/python-modules/grip { };

  groestlcoin-hash = callPackage ../development/python-modules/groestlcoin-hash { };

  grpc-google-iam-v1 = callPackage ../development/python-modules/grpc-google-iam-v1 { };

  grpc-interceptor = callPackage ../development/python-modules/grpc-interceptor { };

  grpcio = callPackage ../development/python-modules/grpcio { };

  grpcio-channelz = callPackage ../development/python-modules/grpcio-channelz { };

  grpcio-gcp = callPackage ../development/python-modules/grpcio-gcp { };

  grpcio-health-checking = callPackage ../development/python-modules/grpcio-health-checking { };

  grpcio-reflection = callPackage ../development/python-modules/grpcio-reflection { };

  grpcio-status = callPackage ../development/python-modules/grpcio-status { };

  grpcio-tools = callPackage ../development/python-modules/grpcio-tools { };

  grpcio-testing = callPackage ../development/python-modules/grpcio-testing { };

  grpclib = callPackage ../development/python-modules/grpclib { };

  gruut = callPackage ../development/python-modules/gruut { };

  gruut-ipa = callPackage ../development/python-modules/gruut-ipa {
    inherit (pkgs) espeak;
  };

  gsd = callPackage ../development/python-modules/gsd { };

  gsm0338 = callPackage ../development/python-modules/gsm0338 { };

  gspread = callPackage ../development/python-modules/gspread { };

  gssapi = callPackage ../development/python-modules/gssapi {
    inherit (pkgs) krb5;
    inherit (pkgs.darwin.apple_sdk.frameworks) GSS;
  };

  gst-python = callPackage ../development/python-modules/gst-python {
    # inherit (pkgs) meson won't work because it won't be spliced
    inherit (pkgs.buildPackages) meson;
  };

  gtfs-realtime-bindings = callPackage ../development/python-modules/gtfs-realtime-bindings { };

  gto = callPackage ../development/python-modules/gto { };

  gtts = callPackage ../development/python-modules/gtts { };

  gtts-token = callPackage ../development/python-modules/gtts-token { };

  guessit = callPackage ../development/python-modules/guessit { };

  guestfs = callPackage ../development/python-modules/guestfs {
    qemu = pkgs.qemu;
  };

  gudhi = callPackage ../development/python-modules/gudhi { };

  guidance = callPackage ../development/python-modules/guidance { };

  gumath = callPackage ../development/python-modules/gumath { };

  gunicorn = callPackage ../development/python-modules/gunicorn { };

  guppy3 = callPackage ../development/python-modules/guppy3 { };

  gurobipy = if stdenv.hostPlatform.isDarwin then
    callPackage ../development/python-modules/gurobipy/darwin.nix { }
  else if stdenv.hostPlatform.system == "x86_64-linux" then
    callPackage ../development/python-modules/gurobipy/linux.nix { }
  else
    throw "gurobipy not yet supported on ${stdenv.hostPlatform.system}";

  guzzle-sphinx-theme = callPackage ../development/python-modules/guzzle-sphinx-theme { };

  gvm-tools = callPackage ../development/python-modules/gvm-tools { };

  gviz-api = callPackage ../development/python-modules/gviz-api { };

  gym = callPackage ../development/python-modules/gym { };

  gym-notices = callPackage ../development/python-modules/gym-notices { };

  gymnasium = callPackage ../development/python-modules/gymnasium { };

  gyp = callPackage ../development/python-modules/gyp { };

  h11 = callPackage ../development/python-modules/h11 { };

  h2 = callPackage ../development/python-modules/h2 { };

  h3 = callPackage ../development/python-modules/h3 {
    inherit (pkgs) h3;
  };

  h5io = callPackage ../development/python-modules/h5io { };

  h5netcdf = callPackage ../development/python-modules/h5netcdf { };

  h5py = callPackage ../development/python-modules/h5py { };

  h5py-mpi = self.h5py.override {
    hdf5 = pkgs.hdf5-mpi;
  };

  habanero = callPackage ../development/python-modules/habanero { };

  habluetooth = callPackage ../development/python-modules/habluetooth { };

  habitipy = callPackage ../development/python-modules/habitipy { };

  hachoir = callPackage ../development/python-modules/hachoir { };

  hacking = callPackage ../development/python-modules/hacking { };

  hdate = callPackage ../development/python-modules/hdate { };

  hdf5plugin = callPackage ../development/python-modules/hdf5plugin { };

  ha-ffmpeg = callPackage ../development/python-modules/ha-ffmpeg { };

  ha-mqtt-discoverable = callPackage ../development/python-modules/ha-mqtt-discoverable { };

  ha-philipsjs = callPackage ../development/python-modules/ha-philipsjs{ };

  hahomematic = callPackage ../development/python-modules/hahomematic { };

  halo = callPackage ../development/python-modules/halo { };

  halohome = callPackage ../development/python-modules/halohome { };

  handout = callPackage ../development/python-modules/handout { };

  hap-python = callPackage ../development/python-modules/hap-python { };

  hass-nabucasa = callPackage ../development/python-modules/hass-nabucasa { };

  hassil = callPackage ../development/python-modules/hassil { };

  hatasmota = callPackage ../development/python-modules/hatasmota { };

  hatchling = callPackage ../development/python-modules/hatchling { };

  hatch-fancy-pypi-readme = callPackage ../development/python-modules/hatch-fancy-pypi-readme { };

  hatch-jupyter-builder = callPackage ../development/python-modules/hatch-jupyter-builder { };

  hatch-vcs = callPackage ../development/python-modules/hatch-vcs { };

  hatch-nodejs-version = callPackage ../development/python-modules/hatch-nodejs-version { };

  hatch-requirements-txt = callPackage ../development/python-modules/hatch-requirements-txt { };

  haversine = callPackage ../development/python-modules/haversine { };

  hawkauthlib = callPackage ../development/python-modules/hawkauthlib { };

  hcloud = callPackage ../development/python-modules/hcloud { };

  hcs-utils = callPackage ../development/python-modules/hcs-utils { };

  hdbscan = callPackage ../development/python-modules/hdbscan { };

  hdfs = callPackage ../development/python-modules/hdfs { };

  hdmedians = callPackage ../development/python-modules/hdmedians { };

  headerparser = callPackage ../development/python-modules/headerparser { };

  heapdict = callPackage ../development/python-modules/heapdict { };

  heatshrink2 = callPackage ../development/python-modules/heatshrink2 { };

  heatzypy = callPackage ../development/python-modules/heatzypy { };

  help2man = callPackage ../development/python-modules/help2man { };

  helpdev = callPackage ../development/python-modules/helpdev { };

  helper = callPackage ../development/python-modules/helper { };

  hepmc3 = toPythonModule (pkgs.hepmc3.override {
    inherit python;
  });

  hepunits = callPackage ../development/python-modules/hepunits { };

  here-routing = callPackage ../development/python-modules/here-routing { };

  here-transit = callPackage ../development/python-modules/here-transit { };

  herepy = callPackage ../development/python-modules/herepy { };

  hetzner = callPackage ../development/python-modules/hetzner { };

  heudiconv = callPackage ../development/python-modules/heudiconv { };

  hexbytes = callPackage ../development/python-modules/hexbytes { };

  hexdump = callPackage ../development/python-modules/hexdump { };

  hfst = callPackage ../development/python-modules/hfst { };

  hg-commitsigs = callPackage ../development/python-modules/hg-commitsigs { };

  hg-evolve = callPackage ../development/python-modules/hg-evolve { };

  hg-git = callPackage ../development/python-modules/hg-git { };

  hickle = callPackage ../development/python-modules/hickle { };

  highdicom = callPackage ../development/python-modules/highdicom { };

  hid = callPackage ../development/python-modules/hid {
    inherit (pkgs) hidapi;
  };

  hidapi = callPackage ../development/python-modules/hidapi {
    inherit (pkgs) udev libusb1;
  };

  hid-parser = callPackage ../development/python-modules/hid-parser { };

  hieroglyph = callPackage ../development/python-modules/hieroglyph { };

  hijri-converter = callPackage ../development/python-modules/hijri-converter { };

  hikvision = callPackage ../development/python-modules/hikvision { };

  hiredis = callPackage ../development/python-modules/hiredis { };

  hiro = callPackage ../development/python-modules/hiro { };

  hishel = callPackage ../development/python-modules/hishel { };

  hist = callPackage ../development/python-modules/hist { };

  histoprint = callPackage ../development/python-modules/histoprint { };

  hiyapyco = callPackage ../development/python-modules/hiyapyco { };

  hjson = callPackage ../development/python-modules/hjson { };

  hkavr = callPackage ../development/python-modules/hkavr { };

  hkdf = callPackage ../development/python-modules/hkdf { };

  hledger-utils = callPackage ../development/python-modules/hledger-utils { };

  hlk-sw16 = callPackage ../development/python-modules/hlk-sw16 { };

  hnswlib = callPackage ../development/python-modules/hnswlib {
    inherit (pkgs) hnswlib;
  };

  hmmlearn = callPackage ../development/python-modules/hmmlearn { };

  hocr-tools = callPackage ../development/python-modules/hocr-tools { };

  hole = callPackage ../development/python-modules/hole { };

  holidays = callPackage ../development/python-modules/holidays { };

  hologram = callPackage ../development/python-modules/hologram { };

  holoviews = callPackage ../development/python-modules/holoviews { };

  home-assistant-bluetooth = callPackage ../development/python-modules/home-assistant-bluetooth { };

  homeassistant-bring-api = callPackage ../development/python-modules/homeassistant-bring-api { };

  home-assistant-chip-clusters = callPackage ../development/python-modules/home-assistant-chip-clusters { };

  home-assistant-chip-core = callPackage ../development/python-modules/home-assistant-chip-core { };

  homeassistant-stubs = callPackage ../servers/home-assistant/stubs.nix { };

  homeconnect = callPackage ../development/python-modules/homeconnect { };

  homematicip = callPackage ../development/python-modules/homematicip { };

  homepluscontrol = callPackage ../development/python-modules/homepluscontrol { };

  hoomd-blue = toPythonModule (callPackage ../development/python-modules/hoomd-blue {
    inherit python;
  });

  hopcroftkarp = callPackage ../development/python-modules/hopcroftkarp { };

  horizon-eda = callPackage ../development/python-modules/horizon-eda {
    inherit (pkgs) horizon-eda mesa;
  };

  howdoi = callPackage ../development/python-modules/howdoi { };

  hpack = callPackage ../development/python-modules/hpack { };

  hpccm = callPackage ../development/python-modules/hpccm { };

  hpp-fcl = toPythonModule (pkgs.hpp-fcl.override {
    pythonSupport = true;
    python3Packages = self;
  });

  hs-dbus-signature = callPackage ../development/python-modules/hs-dbus-signature { };

  hsaudiotag3k = callPackage ../development/python-modules/hsaudiotag3k { };

  hsluv = callPackage ../development/python-modules/hsluv { };

  hstspreload = callPackage ../development/python-modules/hstspreload { };

  html2image = callPackage ../development/python-modules/html2image { };

  html2text = callPackage ../development/python-modules/html2text { };

  html5lib = callPackage ../development/python-modules/html5lib { };

  html5tagger = callPackage ../development/python-modules/html5tagger { };

  html5-parser = callPackage ../development/python-modules/html5-parser { };

  htmldate = callPackage ../development/python-modules/htmldate { };

  htmllaundry = callPackage ../development/python-modules/htmllaundry { };

  htmllistparse = callPackage ../development/python-modules/htmllistparse { };

  htmlmin = callPackage ../development/python-modules/htmlmin { };

  html-sanitizer = callPackage ../development/python-modules/html-sanitizer { };

  html-tag-names = callPackage ../development/python-modules/html-tag-names { };

  html-text = callPackage ../development/python-modules/html-text { };

  html-void-elements = callPackage ../development/python-modules/html-void-elements { };

  htseq = callPackage ../development/python-modules/htseq { };

  httmock = callPackage ../development/python-modules/httmock { };

  httpagentparser = callPackage ../development/python-modules/httpagentparser { };

  httpauth = callPackage ../development/python-modules/httpauth { };

  httpbin = callPackage ../development/python-modules/httpbin { };

  httpcore = callPackage ../development/python-modules/httpcore { };

  httpie = callPackage ../development/python-modules/httpie { };

  http-ece = callPackage ../development/python-modules/http-ece { };

  httpie-ntlm = callPackage ../development/python-modules/httpie-ntlm { };

  httplib2 = callPackage ../development/python-modules/httplib2 { };

  http-message-signatures = callPackage ../development/python-modules/http-message-signatures { };

  http-parser = callPackage ../development/python-modules/http-parser { };

  http-sf = callPackage ../development/python-modules/http-sf { };

  http-sfv = callPackage ../development/python-modules/http-sfv { };

  httpretty = callPackage ../development/python-modules/httpretty { };

  httpserver = callPackage ../development/python-modules/httpserver { };

  httpsig = callPackage ../development/python-modules/httpsig { };

  httptools = callPackage ../development/python-modules/httptools { };

  httpx = callPackage ../development/python-modules/httpx { };

  httpx-auth = callPackage ../development/python-modules/httpx-auth { };

  httpx-ntlm = callPackage ../development/python-modules/httpx-ntlm { };

  httpx-socks = callPackage ../development/python-modules/httpx-socks { };

  huawei-lte-api = callPackage ../development/python-modules/huawei-lte-api { };

  huey = callPackage ../development/python-modules/huey { };

  hug = callPackage ../development/python-modules/hug { };

  huggingface-hub = callPackage ../development/python-modules/huggingface-hub { };

  huisbaasje-client = callPackage ../development/python-modules/huisbaasje-client { };

  humanfriendly = callPackage ../development/python-modules/humanfriendly { };

  humanize = callPackage ../development/python-modules/humanize { };

  human-readable = callPackage ../development/python-modules/human-readable { };

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

  hydra-check = callPackage ../development/python-modules/hydra-check { };

  hydrawiser = callPackage ../development/python-modules/hydrawiser { };

  hydrus-api = callPackage ../development/python-modules/hydrus-api { };

  hypchat = callPackage ../development/python-modules/hypchat { };

  hypercorn = callPackage ../development/python-modules/hypercorn { };

  hyperframe = callPackage ../development/python-modules/hyperframe { };

  hyperscan = callPackage ../development/python-modules/hyperscan { };

  hyperion-py = callPackage ../development/python-modules/hyperion-py { };

  hyperlink = callPackage ../development/python-modules/hyperlink { };

  hyperopt = callPackage ../development/python-modules/hyperopt { };

  hyperpyyaml = callPackage ../development/python-modules/hyperpyyaml { };

  hypothesis-auto = callPackage ../development/python-modules/hypothesis-auto { };

  hypothesis = callPackage ../development/python-modules/hypothesis { };

  hypothesmith = callPackage ../development/python-modules/hypothesmith { };

  hyppo = callPackage ../development/python-modules/hyppo { };

  hyrule = callPackage ../development/python-modules/hyrule { };

  i2c-tools = callPackage ../development/python-modules/i2c-tools {
    inherit (pkgs) i2c-tools;
  };

  i2csense = callPackage ../development/python-modules/i2csense { };

  i3ipc = callPackage ../development/python-modules/i3ipc { };

  i3-py = callPackage ../development/python-modules/i3-py { };

  iammeter = callPackage ../development/python-modules/iammeter { };

  iapws = callPackage ../development/python-modules/iapws { };

  iaqualink = callPackage ../development/python-modules/iaqualink { };

  ibeacon-ble = callPackage ../development/python-modules/ibeacon-ble { };

  ibis = callPackage ../development/python-modules/ibis { };

  ibis-framework = callPackage ../development/python-modules/ibis-framework { };

  ibm-cloud-sdk-core = callPackage ../development/python-modules/ibm-cloud-sdk-core { };

  ibm-watson = callPackage ../development/python-modules/ibm-watson { };

  ical = callPackage ../development/python-modules/ical { };

  icalendar = callPackage ../development/python-modules/icalendar { };

  icalevents = callPackage ../development/python-modules/icalevents { };

  icecream = callPackage ../development/python-modules/icecream { };

  iceportal = callPackage ../development/python-modules/iceportal { };

  icmplib = callPackage ../development/python-modules/icmplib { };

  icnsutil = callPackage ../development/python-modules/icnsutil { };

  ics = callPackage ../development/python-modules/ics { };

  idasen = callPackage ../development/python-modules/idasen { };

  icoextract = callPackage ../development/python-modules/icoextract { };

  icontract = callPackage ../development/python-modules/icontract { };

  id = callPackage ../development/python-modules/id { };

  identify = callPackage ../development/python-modules/identify { };

  idna = callPackage ../development/python-modules/idna { };

  idna-ssl = callPackage ../development/python-modules/idna-ssl { };

  ifaddr = callPackage ../development/python-modules/ifaddr { };

  ifconfig-parser = callPackage ../development/python-modules/ifconfig-parser { };

  ifcopenshell = callPackage ../development/python-modules/ifcopenshell { };

  ignite = callPackage ../development/python-modules/ignite { };

  igraph = callPackage ../development/python-modules/igraph {
    inherit (pkgs) igraph;
  };

  ihm = callPackage ../development/python-modules/ihm { };

  iisignature = callPackage ../development/python-modules/iisignature { };

  ijson = callPackage ../development/python-modules/ijson { };

  ilua = callPackage ../development/python-modules/ilua { };

  imagecodecs-lite = callPackage ../development/python-modules/imagecodecs-lite { };

  imagecorruptions = callPackage ../development/python-modules/imagecorruptions { };

  imagededup = callPackage ../development/python-modules/imagededup { };

  imagehash = callPackage ../development/python-modules/imagehash { };

  imageio = callPackage ../development/python-modules/imageio { };

  imageio-ffmpeg = callPackage ../development/python-modules/imageio-ffmpeg { };

  image-diff = callPackage ../development/python-modules/image-diff { };

  image-go-nord = callPackage ../development/python-modules/image-go-nord { };

  imagesize = callPackage ../development/python-modules/imagesize { };

  imantics = callPackage ../development/python-modules/imantics { };

  imapclient = callPackage ../development/python-modules/imapclient { };

  imaplib2 = callPackage ../development/python-modules/imaplib2 { };

  imap-tools = callPackage ../development/python-modules/imap-tools { };

  imbalanced-learn = callPackage ../development/python-modules/imbalanced-learn { };

  img2pdf = callPackage ../development/python-modules/img2pdf { };

  imgdiff = callPackage ../development/python-modules/imgdiff { };

  imgsize = callPackage ../development/python-modules/imgsize { };

  imgtool = callPackage ../development/python-modules/imgtool { };

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
    inherit (pkgs) libjpeg libpng libtiff libwebp;
  };

  imutils = callPackage ../development/python-modules/imutils { };

  in-n-out = callPackage ../development/python-modules/in-n-out { };

  in-place = callPackage ../development/python-modules/in-place { };

  incomfort-client = callPackage ../development/python-modules/incomfort-client { };

  incremental = callPackage ../development/python-modules/incremental { };

  indexed-bzip2 = callPackage ../development/python-modules/indexed-bzip2 { };

  indexed-gzip = callPackage ../development/python-modules/indexed-gzip { inherit (pkgs) zlib; };

  indexed-zstd = callPackage ../development/python-modules/indexed-zstd { inherit (pkgs) zstd; };

  infinity = callPackage ../development/python-modules/infinity { };

  inflect = callPackage ../development/python-modules/inflect { };

  inflection = callPackage ../development/python-modules/inflection { };

  influxdb = callPackage ../development/python-modules/influxdb { };

  influxdb-client = callPackage ../development/python-modules/influxdb-client { };

  inform = callPackage ../development/python-modules/inform { };

  iniconfig = callPackage ../development/python-modules/iniconfig { };

  inifile = callPackage ../development/python-modules/inifile { };

  iniparse = callPackage ../development/python-modules/iniparse { };

  injector = callPackage ../development/python-modules/injector { };

  inkbird-ble = callPackage ../development/python-modules/inkbird-ble { };

  inkex = callPackage ../development/python-modules/inkex { };

  inlinestyler = callPackage ../development/python-modules/inlinestyler { };

  inotify = callPackage ../development/python-modules/inotify { };

  inotify-simple = callPackage ../development/python-modules/inotify-simple { };

  inotifyrecursive = callPackage ../development/python-modules/inotifyrecursive { };

  inquirer = callPackage ../development/python-modules/inquirer { };

  inquirerpy = callPackage ../development/python-modules/inquirerpy { };

  inscriptis = callPackage ../development/python-modules/inscriptis { };

  insegel = callPackage ../development/python-modules/insegel { };

  insightface = callPackage ../development/python-modules/insightface { };

  installer = callPackage ../development/python-modules/installer { };

  insteon-frontend-home-assistant = callPackage ../development/python-modules/insteon-frontend-home-assistant { };

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

  intervaltree = callPackage ../development/python-modules/intervaltree { };

  into-dbus-python = callPackage ../development/python-modules/into-dbus-python { };

  invisible-watermark = callPackage ../development/python-modules/invisible-watermark { };

  invocations = callPackage ../development/python-modules/invocations { };

  invoke = callPackage ../development/python-modules/invoke { };

  iocsearcher = callPackage ../development/python-modules/iocsearcher { };

  iodata = callPackage ../development/python-modules/iodata { };

  iocapture = callPackage ../development/python-modules/iocapture { };

  iocextract = callPackage ../development/python-modules/iocextract { };

  ionhash = callPackage ../development/python-modules/ionhash { };

  ionoscloud = callPackage ../development/python-modules/ionoscloud { };

  iopath = callPackage ../development/python-modules/iopath { };

  iotawattpy = callPackage ../development/python-modules/iotawattpy { };

  iowait = callPackage ../development/python-modules/iowait { };

  ipadic = callPackage ../development/python-modules/ipadic { };

  ipaddr = callPackage ../development/python-modules/ipaddr { };

  ipdb = callPackage ../development/python-modules/ipdb { };

  ipdbplugin = callPackage ../development/python-modules/ipdbplugin { };

  ipfshttpclient = callPackage ../development/python-modules/ipfshttpclient { };

  i-pi = callPackage ../development/python-modules/i-pi { };

  iptools = callPackage ../development/python-modules/iptools { };

  ipwhl = callPackage ../development/python-modules/ipwhl { };

  ipwhois = callPackage ../development/python-modules/ipwhois { };

  ipy = callPackage ../development/python-modules/ipy { };

  ipycanvas = callPackage ../development/python-modules/ipycanvas { };

  ipydatawidgets = callPackage ../development/python-modules/ipydatawidgets { };

  ipynbname = callPackage ../development/python-modules/ipynbname { };

  ipyniivue = callPackage ../development/python-modules/ipyniivue { };

  ipykernel = callPackage ../development/python-modules/ipykernel { };

  ipymarkup = callPackage ../development/python-modules/ipymarkup { };

  ipympl = callPackage ../development/python-modules/ipympl { };

  ipyparallel = callPackage ../development/python-modules/ipyparallel { };

  ipytablewidgets = callPackage ../development/python-modules/ipytablewidgets { };

  ipython-genutils = callPackage ../development/python-modules/ipython-genutils { };

  ipython = callPackage ../development/python-modules/ipython { };

  ipython-sql = callPackage ../development/python-modules/ipython-sql { };

  ipyvue = callPackage ../development/python-modules/ipyvue { };

  ipyvuetify = callPackage ../development/python-modules/ipyvuetify { };

  ipywidgets = callPackage ../development/python-modules/ipywidgets { };

  ipyxact = callPackage ../development/python-modules/ipyxact { };

  irc = callPackage ../development/python-modules/irc { };

  ircrobots = callPackage ../development/python-modules/ircrobots { };

  ircstates = callPackage ../development/python-modules/ircstates { };

  irctokens = callPackage ../development/python-modules/irctokens { };

  isbnlib = callPackage ../development/python-modules/isbnlib { };

  islpy = callPackage ../development/python-modules/islpy { };

  iso3166 = callPackage ../development/python-modules/iso3166 { };

  ismartgate = callPackage ../development/python-modules/ismartgate { };

  iso-639 = callPackage ../development/python-modules/iso-639 { };

  iso4217 = callPackage ../development/python-modules/iso4217 { };

  iso8601 = callPackage ../development/python-modules/iso8601 { };

  isodate = callPackage ../development/python-modules/isodate { };

  isoduration = callPackage ../development/python-modules/isoduration { };

  isort = callPackage ../development/python-modules/isort { };

  isosurfaces = callPackage ../development/python-modules/isosurfaces { };

  isounidecode = callPackage ../development/python-modules/isounidecode { };

  isoweek = callPackage ../development/python-modules/isoweek { };

  itanium-demangler = callPackage ../development/python-modules/itanium-demangler { };

  itemadapter = callPackage ../development/python-modules/itemadapter { };

  itemdb = callPackage ../development/python-modules/itemdb { };

  itemloaders = callPackage ../development/python-modules/itemloaders { };

  iteration-utilities = callPackage ../development/python-modules/iteration-utilities { };

  iterative-telemetry = callPackage ../development/python-modules/iterative-telemetry { };

  iterm2 = callPackage ../development/python-modules/iterm2 { };

  itsdangerous = callPackage ../development/python-modules/itsdangerous { };

  itunespy = callPackage ../development/python-modules/itunespy { };

  itypes = callPackage ../development/python-modules/itypes { };

  iwlib = callPackage ../development/python-modules/iwlib { };

  j2cli = callPackage ../development/python-modules/j2cli { };

  jaconv = callPackage ../development/python-modules/jaconv { };

  jaeger-client = callPackage ../development/python-modules/jaeger-client { };

  jamo = callPackage ../development/python-modules/jamo { };

  janus = callPackage ../development/python-modules/janus { };

  jaraco-abode = callPackage ../development/python-modules/jaraco-abode { };

  jaraco-classes = callPackage ../development/python-modules/jaraco-classes { };

  jaraco-collections = callPackage ../development/python-modules/jaraco-collections { };

  jaraco-email = callPackage ../development/python-modules/jaraco-email { };

  jaraco-context = callPackage ../development/python-modules/jaraco-context { };

  jaraco-functools = callPackage ../development/python-modules/jaraco-functools { };

  jaraco-itertools = callPackage ../development/python-modules/jaraco-itertools { };

  jaraco-logging = callPackage ../development/python-modules/jaraco-logging { };

  jaraco-net = callPackage ../development/python-modules/jaraco-net { };

  jaraco-stream = callPackage ../development/python-modules/jaraco-stream { };

  jaraco-test = callPackage ../development/python-modules/jaraco-test { };

  jaraco-text = callPackage ../development/python-modules/jaraco-text { };

  jarowinkler = callPackage ../development/python-modules/jarowinkler { };

  javaobj-py3 = callPackage ../development/python-modules/javaobj-py3 { };

  javaproperties = callPackage ../development/python-modules/javaproperties { };

  jax = callPackage ../development/python-modules/jax { };

  jax-jumpy = callPackage ../development/python-modules/jax-jumpy { };

  jaxlib-bin = callPackage ../development/python-modules/jaxlib/bin.nix {
    inherit (pkgs.config) cudaSupport;
  };

  jaxlib-build = callPackage ../development/python-modules/jaxlib rec {
    inherit (pkgs.darwin) cctools;
    # Some platforms don't have `cudaSupport` defined, hence the need for 'or false'.
    inherit (pkgs.config) cudaSupport;
    IOKit = pkgs.darwin.apple_sdk_11_0.IOKit;
  };

  jaxlib = self.jaxlib-build;

  jaxlibWithCuda = self.jaxlib-build.override {
    cudaSupport = true;
  };

  jaxlibWithoutCuda = self.jaxlib-build.override {
    cudaSupport = false;
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

  jenkinsapi = callPackage ../development/python-modules/jenkinsapi { };

  jenkins-job-builder = callPackage ../development/python-modules/jenkins-job-builder { };

  jieba = callPackage ../development/python-modules/jieba { };

  jinja2 = callPackage ../development/python-modules/jinja2 { };

  jinja2-ansible-filters = callPackage ../development/python-modules/jinja2-ansible-filters { };

  jinja2-git = callPackage ../development/python-modules/jinja2-git { };

  jinja2-pluralize = callPackage ../development/python-modules/jinja2-pluralize { };

  jinja2-time = callPackage ../development/python-modules/jinja2-time { };

  jira = callPackage ../development/python-modules/jira { };

  jishaku = callPackage ../development/python-modules/jishaku { };

  jiwer = callPackage ../development/python-modules/jiwer { };

  jmespath = callPackage ../development/python-modules/jmespath { };

  jmp = callPackage ../development/python-modules/jmp { };

  joblib = callPackage ../development/python-modules/joblib { };

  johnnycanencrypt = callPackage ../development/python-modules/johnnycanencrypt {
    inherit (pkgs.darwin.apple_sdk.frameworks) PCSC;
  };

  josepy = callPackage ../development/python-modules/josepy { };

  joserfc = callPackage ../development/python-modules/joserfc { };

  journalwatch = callPackage ../tools/system/journalwatch {
    inherit (self) systemd pytest;
  };

  jplephem = callPackage ../development/python-modules/jplephem { };

  jproperties = callPackage ../development/python-modules/jproperties { };

  jpylyzer = callPackage ../development/python-modules/jpylyzer { };

  jpype1 = callPackage ../development/python-modules/jpype1 { };

  jq = callPackage ../development/python-modules/jq {
    inherit (pkgs) jq;
  };

  js2py = callPackage ../development/python-modules/js2py { };

  jsbeautifier = callPackage ../development/python-modules/jsbeautifier { };

  jschema-to-python = callPackage ../development/python-modules/jschema-to-python { };

  jsmin = callPackage ../development/python-modules/jsmin { };

  json5 = callPackage ../development/python-modules/json5 { };

  jsonargparse = callPackage ../development/python-modules/jsonargparse { };

  jsonconversion = callPackage ../development/python-modules/jsonconversion { };

  jsondate = callPackage ../development/python-modules/jsondate { };

  jsondiff = callPackage ../development/python-modules/jsondiff { };

  jsonfield = callPackage ../development/python-modules/jsonfield { };

  jsonlines = callPackage ../development/python-modules/jsonlines { };

  json-logging = callPackage ../development/python-modules/json-logging { };

  jsonmerge = callPackage ../development/python-modules/jsonmerge { };

  json-home-client = callPackage ../development/python-modules/json-home-client { };

  json-merge-patch = callPackage ../development/python-modules/json-merge-patch { };

  json-schema-for-humans = callPackage ../development/python-modules/json-schema-for-humans { };

  json-stream = callPackage ../development/python-modules/json-stream { };

  json-stream-rs-tokenizer = callPackage ../development/python-modules/json-stream-rs-tokenizer { };

  jsonable = callPackage ../development/python-modules/jsonable { };

  jsonformatter = callPackage ../development/python-modules/jsonformatter { };

  jsonnet = buildPythonPackage { inherit (pkgs.jsonnet) name src; };

  jsonpatch = callPackage ../development/python-modules/jsonpatch { };

  jsonpath = callPackage ../development/python-modules/jsonpath { };

  jsonpath-rw = callPackage ../development/python-modules/jsonpath-rw { };

  jsonpath-ng = callPackage ../development/python-modules/jsonpath-ng { };

  jsonpickle = callPackage ../development/python-modules/jsonpickle { };

  jsonpointer = callPackage ../development/python-modules/jsonpointer { };

  jsonref = callPackage ../development/python-modules/jsonref { };

  json-rpc = callPackage ../development/python-modules/json-rpc { };

  jsonrpc-async = callPackage ../development/python-modules/jsonrpc-async { };

  jsonrpc-base = callPackage ../development/python-modules/jsonrpc-base { };

  jsonrpclib-pelix = callPackage ../development/python-modules/jsonrpclib-pelix { };

  jsonrpc-websocket = callPackage ../development/python-modules/jsonrpc-websocket { };

  jsons = callPackage ../development/python-modules/jsons { };

  jsonschema = callPackage ../development/python-modules/jsonschema { };

  jsonschema-path = callPackage ../development/python-modules/jsonschema-path { };

  jsonschema-spec = callPackage ../development/python-modules/jsonschema-spec { };

  jsonschema-specifications = callPackage ../development/python-modules/jsonschema-specifications { };

  jsonstreams = callPackage ../development/python-modules/jsonstreams { };

  json-tricks = callPackage ../development/python-modules/json-tricks { };

  jstyleson = callPackage ../development/python-modules/jstyleson { };

  jug = callPackage ../development/python-modules/jug { };

  julius = callPackage ../development/python-modules/julius { };

  junitparser = callPackage ../development/python-modules/junitparser { };

  junit2html = callPackage ../development/python-modules/junit2html { };

  junit-xml = callPackage ../development/python-modules/junit-xml { };

  junos-eznc = callPackage ../development/python-modules/junos-eznc { };

  jupyter = callPackage ../development/python-modules/jupyter { };

  jupyter-book = callPackage ../development/python-modules/jupyter-book { };

  jupyter-c-kernel = callPackage ../development/python-modules/jupyter-c-kernel { };

  jupyter-cache = callPackage ../development/python-modules/jupyter-cache { };

  jupyter-client = callPackage ../development/python-modules/jupyter-client { };

  jupyter-collaboration = callPackage ../development/python-modules/jupyter-collaboration { };

  jupyter-contrib-core = callPackage ../development/python-modules/jupyter-contrib-core { };

  jupyter-contrib-nbextensions = callPackage ../development/python-modules/jupyter-contrib-nbextensions { };

  jupyter-console = callPackage ../development/python-modules/jupyter-console { };

  jupyter-core = callPackage ../development/python-modules/jupyter-core { };

  jupyter-events = callPackage ../development/python-modules/jupyter-events { };

  jupyter-highlight-selected-word = callPackage ../development/python-modules/jupyter-highlight-selected-word { };

  jupyter-lsp = callPackage ../development/python-modules/jupyter-lsp { };

  jupyter-nbextensions-configurator = callPackage ../development/python-modules/jupyter-nbextensions-configurator { };

  jupyter-server = callPackage ../development/python-modules/jupyter-server { };

  jupyter-server-fileid = callPackage ../development/python-modules/jupyter-server-fileid { };

  jupyter-server-terminals = callPackage ../development/python-modules/jupyter-server-terminals { };

  jupyter-ui-poll = callPackage ../development/python-modules/jupyter-ui-poll { };

  jupyter-ydoc = callPackage ../development/python-modules/jupyter-ydoc { };

  jupyterhub = callPackage ../development/python-modules/jupyterhub { };

  jupyterhub-ldapauthenticator = callPackage ../development/python-modules/jupyterhub-ldapauthenticator { };

  jupyterhub-systemdspawner = callPackage ../development/python-modules/jupyterhub-systemdspawner { };

  jupyterhub-tmpauthenticator = callPackage ../development/python-modules/jupyterhub-tmpauthenticator { };

  jupyterlab = callPackage ../development/python-modules/jupyterlab { };

  jupyterlab-git = callPackage ../development/python-modules/jupyterlab-git { };

  jupyterlab-pygments = callPackage ../development/python-modules/jupyterlab-pygments { };

  jupyterlab-server = callPackage ../development/python-modules/jupyterlab-server { };

  jupyterlab-widgets = callPackage ../development/python-modules/jupyterlab-widgets { };

  jupyterlab-lsp = callPackage ../development/python-modules/jupyterlab-lsp { };

  jupyter-packaging = callPackage ../development/python-modules/jupyter-packaging { };

  jupyter-repo2docker = callPackage ../development/python-modules/jupyter-repo2docker {
    pkgs-docker = pkgs.docker;
  };

  jupyter-server-mathjax = callPackage ../development/python-modules/jupyter-server-mathjax { };

  jupyter-sphinx = callPackage ../development/python-modules/jupyter-sphinx { };

  jupyter-telemetry = callPackage ../development/python-modules/jupyter-telemetry { };

  jupytext = callPackage ../development/python-modules/jupytext { };

  justbackoff = callPackage ../development/python-modules/justbackoff { };

  justbases = callPackage ../development/python-modules/justbases { };

  justbytes = callPackage ../development/python-modules/justbytes { };

  justext = callPackage ../development/python-modules/justext { };

  justnimbus = callPackage ../development/python-modules/justnimbus { };

  jwcrypto = callPackage ../development/python-modules/jwcrypto { };

  jwt = callPackage ../development/python-modules/jwt { };

  jxmlease = callPackage ../development/python-modules/jxmlease { };

  k-diffusion = callPackage ../development/python-modules/k-diffusion { };

  k5test = callPackage ../development/python-modules/k5test {
    inherit (pkgs) krb5 findutils;
  };

  kaa-base = callPackage ../development/python-modules/kaa-base { };

  kaa-metadata = callPackage ../development/python-modules/kaa-metadata { };

  kafka-python = callPackage ../development/python-modules/kafka-python { };

  kaggle = callPackage ../development/python-modules/kaggle { };

  kaitaistruct = callPackage ../development/python-modules/kaitaistruct { };

  kajiki = callPackage ../development/python-modules/kajiki { };

  kaldi-active-grammar = callPackage ../development/python-modules/kaldi-active-grammar { };

  kanidm = callPackage ../development/python-modules/kanidm { };

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

  keba-kecontact = callPackage ../development/python-modules/keba-kecontact { };

  keep = callPackage ../development/python-modules/keep { };

  keepalive = callPackage ../development/python-modules/keepalive { };

  keepkey-agent = callPackage ../development/python-modules/keepkey-agent { };

  keepkey = callPackage ../development/python-modules/keepkey { };

  kegtron-ble = callPackage ../development/python-modules/kegtron-ble { };

  keras-applications = callPackage ../development/python-modules/keras-applications { };

  keras = callPackage ../development/python-modules/keras { };

  keras-preprocessing = callPackage ../development/python-modules/keras-preprocessing { };

  kerberos = callPackage ../development/python-modules/kerberos { };

  keyboard = callPackage ../development/python-modules/keyboard { };

  keyring = callPackage ../development/python-modules/keyring { };

  keyring-pass = callPackage ../development/python-modules/keyring-pass { };

  keyrings-cryptfile = callPackage ../development/python-modules/keyrings-cryptfile { };

  keyrings-google-artifactregistry-auth = callPackage ../development/python-modules/keyrings-google-artifactregistry-auth { };

  keyrings-alt = callPackage ../development/python-modules/keyrings-alt { };

  keystone-engine = callPackage ../development/python-modules/keystone-engine { };

  keyrings-passwordstore = callPackage ../development/python-modules/keyrings-passwordstore { };

  keystoneauth1 = callPackage ../development/python-modules/keystoneauth1 { };

  keyutils = callPackage ../development/python-modules/keyutils {
    inherit (pkgs) keyutils;
  };

  khanaa = callPackage ../development/python-modules/khanaa {};

  kicad = toPythonModule (pkgs.kicad.override {
    python3 = python;
  }).src;

  kinparse = callPackage ../development/python-modules/kinparse { };

  kiss-headers = callPackage ../development/python-modules/kiss-headers { };

  kitchen = callPackage ../development/python-modules/kitchen { };

  kivy = callPackage ../development/python-modules/kivy {
    inherit (pkgs) mesa;
    inherit (pkgs.darwin.apple_sdk.frameworks) Accelerate ApplicationServices AVFoundation;
  };

  kivy-garden = callPackage ../development/python-modules/kivy-garden { };

  kiwiki-client = callPackage ../development/python-modules/kiwiki-client { };

  kiwisolver = callPackage ../development/python-modules/kiwisolver { };

  klaus = callPackage ../development/python-modules/klaus { };

  klein = callPackage ../development/python-modules/klein { };

  kmapper = callPackage ../development/python-modules/kmapper { };

  kml2geojson = callPackage ../development/python-modules/kml2geojson { };

  kmsxx = toPythonModule (pkgs.kmsxx.override {
    withPython = true;
  });

  knack = callPackage ../development/python-modules/knack { };

  kneed = callPackage ../development/python-modules/kneed { };

  knx-frontend = callPackage ../development/python-modules/knx-frontend { };

  kombu = callPackage ../development/python-modules/kombu { };

  konnected = callPackage ../development/python-modules/konnected { };

  kotsu = callPackage ../development/python-modules/kotsu { };

  korean-lunar-calendar = callPackage ../development/python-modules/korean-lunar-calendar { };

  kornia = callPackage ../development/python-modules/kornia { };

  krakenex = callPackage ../development/python-modules/krakenex { };

  krfzf-py = callPackage ../development/python-modules/krfzf-py { };

  kubernetes = callPackage ../development/python-modules/kubernetes { };

  kurbopy = callPackage ../development/python-modules/kurbopy { };

  l18n = callPackage ../development/python-modules/l18n { };

  labelbox = callPackage ../development/python-modules/labelbox { };

  labgrid = callPackage ../development/python-modules/labgrid { };

  labmath = callPackage ../development/python-modules/labmath { };

  laces = callPackage ../development/python-modules/laces { };

  lacuscore = callPackage ../development/python-modules/lacuscore { };

  lakeside = callPackage ../development/python-modules/lakeside { };

  langchain = callPackage ../development/python-modules/langchain { };

  langchain-community = callPackage ../development/python-modules/langchain-community { };

  langchain-core = callPackage ../development/python-modules/langchain-core { };

  langchain-text-splitters = callPackage ../development/python-modules/langchain-text-splitters { };

  langcodes = callPackage ../development/python-modules/langcodes { };

  langdetect = callPackage ../development/python-modules/langdetect { };

  langid = callPackage ../development/python-modules/langid { };

  langsmith = callPackage ../development/python-modules/langsmith { };

  language-data = callPackage ../development/python-modules/language-data { };

  language-tags = callPackage ../development/python-modules/language-tags { };

  lanms-neo = callPackage ../development/python-modules/lanms-neo { };

  lark = callPackage ../development/python-modules/lark { };

  laspy = callPackage ../development/python-modules/laspy { };

  laszip = callPackage ../development/python-modules/laszip {
    inherit (pkgs) cmake ninja;
  };

  latex2mathml = callPackage ../development/python-modules/latex2mathml { };

  latexcodec = callPackage ../development/python-modules/latexcodec { };

  latexify-py = callPackage ../development/python-modules/latexify-py { };

  launchpadlib = callPackage ../development/python-modules/launchpadlib { };

  laundrify-aio = callPackage ../development/python-modules/laundrify-aio { };

  layoutparser = callPackage ../development/python-modules/layoutparser { };

  lazr-config = callPackage ../development/python-modules/lazr/config.nix { };

  lazr-delegates = callPackage ../development/python-modules/lazr/delegates.nix { };

  lazr-restfulclient = callPackage ../development/python-modules/lazr-restfulclient { };

  lazr-uri = callPackage ../development/python-modules/lazr-uri { };

  lazy = callPackage ../development/python-modules/lazy { };

  lazy-import = callPackage ../development/python-modules/lazy-import { };

  lazy-imports = callPackage ../development/python-modules/lazy-imports { };

  lazy-loader = callPackage ../development/python-modules/lazy-loader { };

  lazy-object-proxy = callPackage ../development/python-modules/lazy-object-proxy { };

  lc7001 = callPackage ../development/python-modules/lc7001 { };

  lcd-i2c = callPackage ../development/python-modules/lcd-i2c { };

  lcgit = callPackage ../development/python-modules/lcgit { };

  lcov-cobertura = callPackage ../development/python-modules/lcov-cobertura { };

  ld2410-ble = callPackage ../development/python-modules/ld2410-ble { };

  ldap3 = callPackage ../development/python-modules/ldap3 { };

  ldapdomaindump = callPackage ../development/python-modules/ldapdomaindump { };

  ldappool = callPackage ../development/python-modules/ldappool { };

  ldaptor = callPackage ../development/python-modules/ldaptor { };

  ldfparser = callPackage ../development/python-modules/ldfparser { };

  leather = callPackage ../development/python-modules/leather { };

  leb128 = callPackage ../development/python-modules/leb128 { };

  led-ble = callPackage ../development/python-modules/led-ble { };

  ledger = (toPythonModule (pkgs.ledger.override {
    usePython = true;
    python3 = python;
  })).py;

  ledger-agent = callPackage ../development/python-modules/ledger-agent { };

  ledger-bitcoin = callPackage ../development/python-modules/ledger-bitcoin { };

  ledgerblue = callPackage ../development/python-modules/ledgerblue { };

  ledgercomm = callPackage ../development/python-modules/ledgercomm { };

  ledgerwallet = callPackage ../development/python-modules/ledgerwallet {
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit;
  };

  leidenalg = callPackage ../development/python-modules/leidenalg {
    igraph-c = pkgs.igraph;
  };

  leveldb = callPackage ../development/python-modules/leveldb { };

  levenshtein = callPackage ../development/python-modules/levenshtein { };

  lexid = callPackage ../development/python-modules/lexid { };

  lexilang = callPackage ../development/python-modules/lexilang { };

  lhapdf = toPythonModule (pkgs.lhapdf.override {
    inherit python;
  });

  libagent = callPackage ../development/python-modules/libagent { };

  pa-ringbuffer = callPackage ../development/python-modules/pa-ringbuffer { };

  libais = callPackage ../development/python-modules/libais { };

  libarchive-c = callPackage ../development/python-modules/libarchive-c {
    inherit (pkgs) libarchive;
  };

  libarcus = callPackage ../development/python-modules/libarcus {
    protobuf = pkgs.protobuf_21;
  };

  libasyncns = callPackage ../development/python-modules/libasyncns {
    inherit (pkgs) libasyncns;
  };

  libclang = callPackage ../development/python-modules/libclang { };

  libcloud = callPackage ../development/python-modules/libcloud { };

  libcomps = lib.pipe pkgs.libcomps [
    toPythonModule
    (p: p.overrideAttrs (super: { meta = super.meta // { outputsToInstall = [ "py" ]; }; }))
    (p: p.override { inherit python; })
    (p: p.py)
  ];

  libcst = callPackage ../development/python-modules/libcst { };

  libdnf = lib.pipe pkgs.libdnf [
    toPythonModule
    (p: p.overrideAttrs (super: { meta = super.meta // { outputsToInstall = [ "py" ]; }; }))
    (p: p.override { inherit python; })
    (p: p.py)
  ];

  libevdev = callPackage ../development/python-modules/libevdev { };

  libfdt = toPythonModule (pkgs.dtc.override {
    inherit python;
    pythonSupport = true;
  });

  libfive = toPythonModule (pkgs.libfive.override {
    inherit python;
  });

  libgpiod = callPackage ../development/python-modules/libgpiod {
    inherit (pkgs) libgpiod;
  };

  libgpuarray = callPackage ../development/python-modules/libgpuarray {
    clblas = pkgs.clblas.override { inherit (self) boost; };
    inherit (pkgs.config) cudaSupport;
  };

  libiio = (toPythonModule (pkgs.libiio.override {
    pythonSupport = true;
    inherit python;
  })).python;

  libkeepass = callPackage ../development/python-modules/libkeepass { };

  libknot = callPackage ../development/python-modules/libknot { };

  liblarch = callPackage ../development/python-modules/liblarch { };

  liblzfse = callPackage ../development/python-modules/liblzfse {
    inherit (pkgs) lzfse;
  };

  libmodulemd = lib.pipe pkgs.libmodulemd [
    toPythonModule
    (p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ]; # The package always builds python3 bindings
          broken = (super.meta.broken or false) || !isPy3k;
        };
      }))
    (p: p.override { python3 = python; })
    (p: p.py)
  ];

  libmr = callPackage ../development/python-modules/libmr { };

  libnacl = callPackage ../development/python-modules/libnacl {
    inherit (pkgs) libsodium;
  };

  libpcap = callPackage ../development/python-modules/libpcap {
    pkgsLibpcap = pkgs.libpcap; # Needs the C library
  };

  libpurecool = callPackage ../development/python-modules/libpurecool { };

  libpyfoscam = callPackage ../development/python-modules/libpyfoscam { };

  libpyvivotek = callPackage ../development/python-modules/libpyvivotek { };

  libpwquality = lib.pipe pkgs.libpwquality [
    toPythonModule
    (p: p.overrideAttrs (super: { meta = super.meta // { outputsToInstall = [ "py" ]; }; }))
    (p: p.override { enablePython = true; inherit python; })
    (p: p.py)
  ];

  libredwg = toPythonModule (pkgs.libredwg.override {
    enablePython = true;
    inherit (self) python libxml2;
  });

  librepo = lib.pipe pkgs.librepo [
    toPythonModule
    (p: p.overrideAttrs (super: { meta = super.meta // { outputsToInstall = [ "py" ]; }; }))
    (p: p.override { inherit python; })
    (p: p.py)
  ];

  librespot = callPackage ../development/python-modules/librespot { };

  libretranslate = callPackage ../development/python-modules/libretranslate { };

  librosa = callPackage ../development/python-modules/librosa { };

  librouteros = callPackage ../development/python-modules/librouteros { };

  libsass = callPackage ../development/python-modules/libsass {
    inherit (pkgs) libsass;
  };

  libsavitar = callPackage ../development/python-modules/libsavitar { };


  libsixel = callPackage ../development/python-modules/libsixel {
    inherit (pkgs) libsixel;
  };

  libselinux = lib.pipe pkgs.libselinux [
    toPythonModule
    (p:
      p.overrideAttrs (super: {
        meta = super.meta // {
          outputsToInstall = [ "py" ];
          broken = super.meta.broken or isPy27;
        };
      }))
    (p:
      p.override {
        enablePython = true;
        python3 = python;
      })
    (p: p.py)
  ];

  libsoundtouch = callPackage ../development/python-modules/libsoundtouch { };

  libthumbor = callPackage ../development/python-modules/libthumbor { };

  libtmux = callPackage ../development/python-modules/libtmux { };

  libtorrent-rasterbar = (toPythonModule (pkgs.libtorrent-rasterbar.override { inherit python; })).python;

  libusb1 = callPackage ../development/python-modules/libusb1 {
    inherit (pkgs) libusb1;
  };

  libusbsio = callPackage ../development/python-modules/libusbsio {
    inherit (pkgs) libusbsio;
  };

  libversion = callPackage ../development/python-modules/libversion {
    inherit (pkgs) libversion;
  };

  libvirt = callPackage ../development/python-modules/libvirt {
    inherit (pkgs) libvirt;
  };

  libxml2 = (toPythonModule (pkgs.libxml2.override {
    pythonSupport = true;
    inherit python;
  })).py;

  libxslt = (toPythonModule (pkgs.libxslt.override {
    pythonSupport = true;
    inherit (self) python libxml2;
  })).py;

  liccheck = callPackage ../development/python-modules/liccheck { };

  license-expression = callPackage ../development/python-modules/license-expression { };

  lief = (toPythonModule (pkgs.lief.override {
    inherit python;
  })).py;

  life360 = callPackage ../development/python-modules/life360 { };

  lifelines = callPackage ../development/python-modules/lifelines { };

  lightgbm = callPackage ../development/python-modules/lightgbm { };

  lightning-utilities  = callPackage ../development/python-modules/lightning-utilities { };

  lightparam = callPackage ../development/python-modules/lightparam { };

  lightwave = callPackage ../development/python-modules/lightwave { };

  lightwave2 = callPackage ../development/python-modules/lightwave2 { };

  lima = callPackage ../development/python-modules/lima { };

  lime = callPackage ../development/python-modules/lime { };

  limiter= callPackage ../development/python-modules/limiter { };

  limitlessled = callPackage ../development/python-modules/limitlessled { };

  limits = callPackage ../development/python-modules/limits { };

  limnoria = callPackage ../development/python-modules/limnoria { };

  linear-garage-door = callPackage ../development/python-modules/linear-garage-door { };

  linear-operator = callPackage ../development/python-modules/linear-operator { };

  linecache2 = callPackage ../development/python-modules/linecache2 { };

  lineedit = callPackage ../development/python-modules/lineedit { };

  line-profiler = callPackage ../development/python-modules/line-profiler { };

  linetable = callPackage ../development/python-modules/linetable { };

  lingua = callPackage ../development/python-modules/lingua { };

  linien-client = callPackage ../development/python-modules/linien-client { };

  linien-common = callPackage ../development/python-modules/linien-common { };

  linkify-it-py = callPackage ../development/python-modules/linkify-it-py { };

  linknlink = callPackage ../development/python-modules/linknlink { };

  linode-api = callPackage ../development/python-modules/linode-api { };

  linode = callPackage ../development/python-modules/linode { };

  linuxfd = callPackage ../development/python-modules/linuxfd { };

  lion-pytorch = callPackage ../development/python-modules/lion-pytorch { };

  liquidctl = callPackage ../development/python-modules/liquidctl { };

  lirc = toPythonModule (pkgs.lirc.override {
    python3 = python;
  });

  lit = callPackage ../development/python-modules/lit { };

  litellm = callPackage ../development/python-modules/litellm { };

  litemapy = callPackage ../development/python-modules/litemapy { };

  littleutils = callPackage ../development/python-modules/littleutils { };

  livelossplot = callPackage ../development/python-modules/livelossplot { };

  livereload = callPackage ../development/python-modules/livereload { };

  lizard = callPackage ../development/python-modules/lizard { };

  llama-index = callPackage ../development/python-modules/llama-index { };

  llama-index-agent-openai = callPackage ../development/python-modules/llama-index-agent-openai { };

  llama-index-cli = callPackage ../development/python-modules/llama-index-cli { };

  llama-index-core = callPackage ../development/python-modules/llama-index-core { };

  llama-index-embeddings-gemini = callPackage ../development/python-modules/llama-index-embeddings-gemini { };

  llama-index-embeddings-google = callPackage ../development/python-modules/llama-index-embeddings-google { };

  llama-index-embeddings-openai = callPackage ../development/python-modules/llama-index-embeddings-openai { };

  llama-index-indices-managed-llama-cloud = callPackage ../development/python-modules/llama-index-indices-managed-llama-cloud { };

  llama-index-legacy = callPackage ../development/python-modules/llama-index-legacy { };

  llama-index-llms-openai = callPackage ../development/python-modules/llama-index-llms-openai { };

  llama-index-multi-modal-llms-openai = callPackage ../development/python-modules/llama-index-multi-modal-llms-openai { };

  llama-index-program-openai = callPackage ../development/python-modules/llama-index-program-openai { };

  llama-index-question-gen-openai = callPackage ../development/python-modules/llama-index-question-gen-openai { };

  llama-index-readers-file = callPackage ../development/python-modules/llama-index-readers-file { };

  llama-index-readers-json = callPackage ../development/python-modules/llama-index-readers-json { };

  llama-index-readers-llama-parse = callPackage ../development/python-modules/llama-index-readers-llama-parse { };

  llama-index-readers-weather = callPackage ../development/python-modules/llama-index-readers-weather { };

  llama-index-vector-stores-chroma = callPackage ../development/python-modules/llama-index-vector-stores-chroma { };

  llama-parse = callPackage ../development/python-modules/llama-parse { };

  llamaindex-py-client = callPackage ../development/python-modules/llamaindex-py-client { };

  llfuse = callPackage ../development/python-modules/llfuse {
    inherit (pkgs) fuse;
  };

  llm = callPackage ../development/python-modules/llm { };

  llvmlite = callPackage ../development/python-modules/llvmlite {
    # llvmlite always requires a specific version of llvm.
    llvm = pkgs.llvm_14;
  };

  lmcloud = callPackage ../development/python-modules/lmcloud { };

  lmdb = callPackage ../development/python-modules/lmdb {
    inherit (pkgs) lmdb;
  };

  lmfit = callPackage ../development/python-modules/lmfit { };

  lml = callPackage ../development/python-modules/lml { };

  lmnotify = callPackage ../development/python-modules/lmnotify { };

  lmtpd = callPackage ../development/python-modules/lmtpd { };

  lnkparse3 = callPackage ../development/python-modules/lnkparse3 { };

  loca = callPackage ../development/python-modules/loca { };

  localimport = callPackage ../development/python-modules/localimport { };

  localstack = callPackage ../development/python-modules/localstack { };

  localstack-client = callPackage ../development/python-modules/localstack-client { };

  localstack-ext = callPackage ../development/python-modules/localstack-ext { };

  localzone = callPackage ../development/python-modules/localzone { };

  locationsharinglib = callPackage ../development/python-modules/locationsharinglib { };

  locket = callPackage ../development/python-modules/locket { };

  lockfile = callPackage ../development/python-modules/lockfile { };

  log-symbols = callPackage ../development/python-modules/log-symbols { };

  logbook = callPackage ../development/python-modules/logbook { };

  logfury = callPackage ../development/python-modules/logfury { };

  logging-journald = callPackage ../development/python-modules/logging-journald { };

  logi-circle = callPackage ../development/python-modules/logi-circle { };

  logical-unification = callPackage ../development/python-modules/logical-unification { };

  logilab-common = callPackage ../development/python-modules/logilab/common.nix { };

  logilab-constraint = callPackage ../development/python-modules/logilab/constraint.nix { };

  logmatic-python = callPackage ../development/python-modules/logmatic-python { };

  logster = callPackage ../development/python-modules/logster { };

  loguru = callPackage ../development/python-modules/loguru { };

  logutils = callPackage ../development/python-modules/logutils {
    redis-server = pkgs.redis;
  };

  logzero = callPackage ../development/python-modules/logzero { };

  lomond = callPackage ../development/python-modules/lomond { };

  loopy = callPackage ../development/python-modules/loopy { };

  looseversion = callPackage ../development/python-modules/looseversion { };

  loqedapi = callPackage ../development/python-modules/loqedapi { };

  losant-rest = callPackage ../development/python-modules/losant-rest { };

  lpc-checksum = callPackage ../development/python-modules/lpc-checksum { };

  lrcalc-python = callPackage ../development/python-modules/lrcalc-python { };

  lru-dict = callPackage ../development/python-modules/lru-dict { };

  lsassy = callPackage ../development/python-modules/lsassy { };

  lsprotocol = callPackage ../development/python-modules/lsprotocol { };

  ltpycld2 = callPackage ../development/python-modules/ltpycld2 { };

  lttng = callPackage ../development/python-modules/lttng { };

  luddite = callPackage ../development/python-modules/luddite { };

  luftdaten = callPackage ../development/python-modules/luftdaten { };

  luhn = callPackage ../development/python-modules/luhn { };

  lunarcalendar = callPackage ../development/python-modules/lunarcalendar { };

  luqum = callPackage ../development/python-modules/luqum { };

  luxor = callPackage ../development/python-modules/luxor { };

  luxtronik = callPackage ../development/python-modules/luxtronik { };

  lupa = callPackage ../development/python-modules/lupa { };

  lupupy = callPackage ../development/python-modules/lupupy { };

  lxmf= callPackage ../development/python-modules/lxmf { };

  lxml = callPackage ../development/python-modules/lxml {
    inherit (pkgs) libxml2 libxslt zlib;
  };

  lxml-stubs = callPackage ../development/python-modules/lxml-stubs { };

  lyricwikia = callPackage ../development/python-modules/lyricwikia { };

  lz4 = callPackage ../development/python-modules/lz4 { };

  lzallright = callPackage ../development/python-modules/lzallright { };

  lzstring = callPackage ../development/python-modules/lzstring { };

  m2crypto = callPackage ../development/python-modules/m2crypto { };

  m2r = callPackage ../development/python-modules/m2r { };

  m3u8 = callPackage ../development/python-modules/m3u8 { };

  mac-alias = callPackage ../development/python-modules/mac-alias { };

  mac-vendor-lookup = callPackage ../development/python-modules/mac-vendor-lookup { };

  macaddress = callPackage ../development/python-modules/macaddress{ };

  macfsevents = callPackage ../development/python-modules/macfsevents {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation CoreServices;
  };

  macropy = callPackage ../development/python-modules/macropy { };

  maestral = callPackage ../development/python-modules/maestral { };

  magic = callPackage ../development/python-modules/magic { };

  magicgui = callPackage ../development/python-modules/magicgui { };

  magic-filter = callPackage ../development/python-modules/magic-filter { };

  magic-wormhole = callPackage ../development/python-modules/magic-wormhole { };

  magic-wormhole-mailbox-server = callPackage ../development/python-modules/magic-wormhole-mailbox-server { };

  magic-wormhole-transit-relay = callPackage ../development/python-modules/magic-wormhole-transit-relay { };

  magika = callPackage ../development/python-modules/magika { };

  mahotas = callPackage ../development/python-modules/mahotas { };

  mailcap-fix = callPackage ../development/python-modules/mailcap-fix { };

  mailchecker = callPackage ../development/python-modules/mailchecker { };

  mailchimp = callPackage ../development/python-modules/mailchimp { };

  mailmanclient = callPackage ../development/python-modules/mailmanclient { };

  rtfde = callPackage ../development/python-modules/rtfde { };

  rtfunicode = callPackage ../development/python-modules/rtfunicode { };

  rtmixer = callPackage ../development/python-modules/rtmixer { };

  regress = callPackage ../development/python-modules/regress { };

  mail-parser = callPackage ../development/python-modules/mail-parser { };

  makefun = callPackage ../development/python-modules/makefun { };

  mailsuite = callPackage ../development/python-modules/mailsuite { };

  maison = callPackage ../development/python-modules/maison { };

  mako = callPackage ../development/python-modules/mako { };

  malduck = callPackage ../development/python-modules/malduck { };

  managesieve = callPackage ../development/python-modules/managesieve { };

  mando = callPackage ../development/python-modules/mando { };

  mandown = callPackage ../development/python-modules/mandown { };

  manhole = callPackage ../development/python-modules/manhole { };

  manimpango = callPackage ../development/python-modules/manimpango {
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit;
  };

  manifest-ml = callPackage ../development/python-modules/manifest-ml { };

  manifestoo = callPackage ../development/python-modules/manifestoo { };

  manifestoo-core = callPackage ../development/python-modules/manifestoo-core { };

  manifestparser = callPackage ../development/python-modules/marionette-harness/manifestparser.nix { };

  manuel = callPackage ../development/python-modules/manuel { };

  manuf = callPackage ../development/python-modules/manuf { };

  mapbox = callPackage ../development/python-modules/mapbox { };

  mapbox-earcut = callPackage ../development/python-modules/mapbox-earcut { };

  mariadb = callPackage ../development/python-modules/mariadb { };

  marimo = callPackage ../development/python-modules/marimo { };

  marisa = callPackage ../development/python-modules/marisa {
    inherit (pkgs) marisa;
  };

  marisa-trie = callPackage ../development/python-modules/marisa-trie { };

  markdown2 = callPackage ../development/python-modules/markdown2 { };

  markdown = callPackage ../development/python-modules/markdown { };

  markdown-include = callPackage ../development/python-modules/markdown-include { };

  markdown-it-py = callPackage ../development/python-modules/markdown-it-py { };

  markdown-macros = callPackage ../development/python-modules/markdown-macros { };

  markdownify  = callPackage ../development/python-modules/markdownify { };

  markupsafe = callPackage ../development/python-modules/markupsafe { };

  markuppy = callPackage ../development/python-modules/markuppy { };

  markups = callPackage ../development/python-modules/markups { };

  marshmallow = callPackage ../development/python-modules/marshmallow { };

  marshmallow-dataclass = callPackage ../development/python-modules/marshmallow-dataclass { };

  marshmallow-enum = callPackage ../development/python-modules/marshmallow-enum { };

  marshmallow-oneofschema = callPackage ../development/python-modules/marshmallow-oneofschema { };

  marshmallow-polyfield = callPackage ../development/python-modules/marshmallow-polyfield { };

  marshmallow-sqlalchemy = callPackage ../development/python-modules/marshmallow-sqlalchemy { };

  mashumaro = callPackage ../development/python-modules/mashumaro { };

  masky = callPackage ../development/python-modules/masky { };

  mastodon-py = callPackage ../development/python-modules/mastodon-py { };

  mat2 = callPackage ../development/python-modules/mat2 { };

  material-color-utilities = callPackage ../development/python-modules/material-color-utilities { };

  matchpy = callPackage ../development/python-modules/matchpy { };

  mathlibtools = callPackage ../development/python-modules/mathlibtools { };

  matlink-gpapi = callPackage ../development/python-modules/matlink-gpapi { };

  matplotlib = callPackage ../development/python-modules/matplotlib {
    stdenv = if stdenv.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
    ghostscript = pkgs.ghostscript_headless;
  };

  matplotlib-inline = callPackage ../development/python-modules/matplotlib-inline { };

  matplotlib-sixel = callPackage ../development/python-modules/matplotlib-sixel { };

  matplotx = callPackage ../development/python-modules/matplotx { };

  matrix-api-async = callPackage ../development/python-modules/matrix-api-async { };

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
    inherit (self) buildPythonPackage pythonOlder pythonAtLeast pyface pygments numpy packaging vtk traitsui envisage apptools pyqt5;
  };

  mayim = callPackage ../development/python-modules/mayim { };

  mbddns = callPackage ../development/python-modules/mbddns { };

  mbstrdecoder = callPackage ../development/python-modules/mbstrdecoder { };

  mccabe = callPackage ../development/python-modules/mccabe { };

  mcstatus = callPackage ../development/python-modules/mcstatus { };

  mcuuid = callPackage ../development/python-modules/mcuuid { };

  md-toc = callPackage ../development/python-modules/md-toc { };

  mdx-truly-sane-lists = callPackage ../development/python-modules/mdx-truly-sane-lists { };

  md2gemini = callPackage ../development/python-modules/md2gemini { };

  mdformat = callPackage ../development/python-modules/mdformat { };
  mdformat-admon = callPackage ../development/python-modules/mdformat-admon { };
  mdformat-beautysh = callPackage ../development/python-modules/mdformat-beautysh { };
  mdformat-footnote = callPackage ../development/python-modules/mdformat-footnote { };
  mdformat-frontmatter = callPackage ../development/python-modules/mdformat-frontmatter { };
  mdformat-gfm = callPackage ../development/python-modules/mdformat-gfm { };
  mdformat-mkdocs = callPackage ../development/python-modules/mdformat-mkdocs { };
  mdformat-nix-alejandra = callPackage ../development/python-modules/mdformat-nix-alejandra { };
  mdformat-simple-breaks = callPackage ../development/python-modules/mdformat-simple-breaks { };
  mdformat-tables = callPackage ../development/python-modules/mdformat-tables { };
  mdformat-toc = callPackage ../development/python-modules/mdformat-toc { };

  mdit-py-plugins = callPackage ../development/python-modules/mdit-py-plugins { };

  mdtraj = callPackage ../development/python-modules/mdtraj { };

  mdurl = callPackage ../development/python-modules/mdurl { };

  mdutils = callPackage ../development/python-modules/mdutils { };

  mdp = callPackage ../development/python-modules/mdp { };

  measurement = callPackage ../development/python-modules/measurement { };

  meater-python = callPackage ../development/python-modules/meater-python { };

  mecab-python3 = callPackage ../development/python-modules/mecab-python3 { };

  mechanicalsoup = callPackage ../development/python-modules/mechanicalsoup { };

  mechanize = callPackage ../development/python-modules/mechanize { };

  mediafile = callPackage ../development/python-modules/mediafile { };

  mediafire-dl = callPackage ../development/python-modules/mediafire-dl { };

  mediapy = callPackage ../development/python-modules/mediapy { };

  medpy = callPackage ../development/python-modules/medpy { };

  meeko = callPackage ../development/python-modules/meeko { };

  meep = callPackage ../development/python-modules/meep { };

  meilisearch = callPackage ../development/python-modules/meilisearch { };

  meinheld = callPackage ../development/python-modules/meinheld { };

  meld3 = callPackage ../development/python-modules/meld3 { };

  memestra = callPackage ../development/python-modules/memestra { };

  memory-allocator = callPackage ../development/python-modules/memory-allocator { };

  memory-profiler = callPackage ../development/python-modules/memory-profiler { };

  meraki = callPackage ../development/python-modules/meraki { };

  mercadopago = callPackage ../development/python-modules/mercadopago { };

  mercantile = callPackage ../development/python-modules/mercantile { };

  mercurial = toPythonModule (pkgs.mercurial.override {
    python3Packages = self;
  });

  merge3 = callPackage ../development/python-modules/merge3 { };

  mergedb = callPackage ../development/python-modules/mergedb { };

  mergedeep = callPackage ../development/python-modules/mergedeep { };

  mergedict = callPackage ../development/python-modules/mergedict { };

  merkletools = callPackage ../development/python-modules/merkletools { };

  meross-iot = callPackage ../development/python-modules/meross-iot { };

  mesa = callPackage ../development/python-modules/mesa { };

  meshcat = callPackage ../development/python-modules/meshcat { };

  meshio = callPackage ../development/python-modules/meshio { };

  meshlabxml = callPackage ../development/python-modules/meshlabxml { };

  meshtastic = callPackage ../development/python-modules/meshtastic { };

  meson = toPythonModule ((pkgs.meson.override { python3 = python; }).overridePythonAttrs
    (oldAttrs: { # We do not want the setup hook in Python packages because the build is performed differently.
      setupHook = null;
    }));

  mesonpep517 = callPackage ../development/python-modules/mesonpep517 { };

  meson-python = callPackage ../development/python-modules/meson-python {
    inherit (pkgs) ninja;
  };

  messagebird = callPackage ../development/python-modules/messagebird { };

  metakernel = callPackage ../development/python-modules/metakernel { };

  metar = callPackage ../development/python-modules/metar { };

  metawear = callPackage ../development/python-modules/metawear { };

  meteoalertapi = callPackage ../development/python-modules/meteoalertapi { };

  meteocalc = callPackage ../development/python-modules/meteocalc { };

  meteofrance-api = callPackage ../development/python-modules/meteofrance-api { };

  mezzanine = callPackage ../development/python-modules/mezzanine { };

  mf2py = callPackage ../development/python-modules/mf2py { };

  mhcflurry = callPackage ../development/python-modules/mhcflurry { };

  mhcgnomes = callPackage ../development/python-modules/mhcgnomes { };

  miauth = callPackage ../development/python-modules/miauth { };

  micawber = callPackage ../development/python-modules/micawber { };

  microdata = callPackage ../development/python-modules/microdata { };

  microsoft-kiota-abstractions = callPackage ../development/python-modules/microsoft-kiota-abstractions { };

  microsoft-kiota-authentication-azure = callPackage ../development/python-modules/microsoft-kiota-authentication-azure { };

  microsoft-kiota-http = callPackage ../development/python-modules/microsoft-kiota-http { };

  microsoft-kiota-serialization-json = callPackage ../development/python-modules/microsoft-kiota-serialization-json { };

  microsoft-kiota-serialization-text = callPackage ../development/python-modules/microsoft-kiota-serialization-text { };

  midiutil = callPackage ../development/python-modules/midiutil { };

  mido = callPackage ../development/python-modules/mido { };

  migen = callPackage ../development/python-modules/migen { };

  mike = callPackage ../development/python-modules/mike { };

  milc = callPackage ../development/python-modules/milc { };

  milksnake = callPackage ../development/python-modules/milksnake { };

  mill-local = callPackage ../development/python-modules/mill-local { };

  millheater = callPackage ../development/python-modules/millheater { };

  mindsdb-evaluator = callPackage ../development/python-modules/mindsdb-evaluator { };

  minexr = callPackage ../development/python-modules/minexr { };

  miniaudio = callPackage ../development/python-modules/miniaudio {
    inherit (pkgs) miniaudio;
    inherit (pkgs.darwin.apple_sdk.frameworks) AudioToolbox CoreAudio;
  };

  minichain = callPackage ../development/python-modules/minichain { };

  minidb = callPackage ../development/python-modules/minidb { };

  minidump = callPackage ../development/python-modules/minidump { };

  miniful = callPackage ../development/python-modules/miniful { };

  minikanren = callPackage ../development/python-modules/minikanren { };

  minikerberos = callPackage ../development/python-modules/minikerberos { };

  minimal-snowplow-tracker = callPackage ../development/python-modules/minimal-snowplow-tracker { };

  minimock = callPackage ../development/python-modules/minimock { };

  mininet-python = (toPythonModule (pkgs.mininet.override {
    python3 = python;
  })).py;

  minio = callPackage ../development/python-modules/minio { };

  miniupnpc = callPackage ../development/python-modules/miniupnpc {
    inherit (pkgs.darwin) cctools;
  };

  mip = callPackage ../development/python-modules/mip { };

  mir-eval = callPackage ../development/python-modules/mir-eval { };

  mirakuru = callPackage ../development/python-modules/mirakuru { };

  misaka = callPackage ../development/python-modules/misaka { };

  misoc = callPackage ../development/python-modules/misoc { };

  mistletoe = callPackage ../development/python-modules/mistletoe { };

  mistune = callPackage ../development/python-modules/mistune { };

  mitmproxy = callPackage ../development/python-modules/mitmproxy { };

  mitmproxy-macos = callPackage ../development/python-modules/mitmproxy-macos { };

  mitmproxy-rs = callPackage ../development/python-modules/mitmproxy-rs { };

  mitogen = callPackage ../development/python-modules/mitogen { };

  mixins = callPackage ../development/python-modules/mixins { };

  mixpanel = callPackage ../development/python-modules/mixpanel { };

  mizani = callPackage ../development/python-modules/mizani { };

  mkdocs = callPackage ../development/python-modules/mkdocs { };
  mkdocs-autorefs = callPackage ../development/python-modules/mkdocs-autorefs { };
  mkdocs-drawio-exporter = callPackage ../development/python-modules/mkdocs-drawio-exporter { };
  mkdocs-exclude = callPackage ../development/python-modules/mkdocs-exclude { };
  mkdocs-jupyter = callPackage ../development/python-modules/mkdocs-jupyter { };
  mkdocs-gitlab = callPackage ../development/python-modules/mkdocs-gitlab-plugin { };
  mkdocs-git-authors-plugin = callPackage ../development/python-modules/mkdocs-git-authors-plugin { };
  mkdocs-git-revision-date-localized-plugin = callPackage ../development/python-modules/mkdocs-git-revision-date-localized-plugin { };
  mkdocs-linkcheck = callPackage ../development/python-modules/mkdocs-linkcheck { };
  mkdocs-macros = callPackage ../development/python-modules/mkdocs-macros { };
  mkdocs-material = callPackage ../development/python-modules/mkdocs-material { };
  mkdocs-material-extensions = callPackage ../development/python-modules/mkdocs-material/mkdocs-material-extensions.nix { };
  mkdocs-minify-plugin = callPackage ../development/python-modules/mkdocs-minify-plugin { };
  mkdocs-redirects = callPackage ../development/python-modules/mkdocs-redirects { };
  mkdocs-redoc-tag = callPackage ../development/python-modules/mkdocs-redoc-tag { };
  mkdocs-simple-hooks = callPackage ../development/python-modules/mkdocs-simple-hooks { };
  mkdocs-swagger-ui-tag = callPackage ../development/python-modules/mkdocs-swagger-ui-tag { };

  mkdocstrings = callPackage ../development/python-modules/mkdocstrings { };

  mkdocstrings-python = callPackage ../development/python-modules/mkdocstrings-python { };

  mkdocs-mermaid2-plugin = callPackage ../development/python-modules/mkdocs-mermaid2-plugin { };

  mkl-service = callPackage ../development/python-modules/mkl-service { };

  ml-collections = callPackage ../development/python-modules/ml-collections { };

  ml-dtypes = callPackage ../development/python-modules/ml-dtypes { };

  mlflow = callPackage ../development/python-modules/mlflow { };

  mlrose = callPackage ../development/python-modules/mlrose { };

  mlx = callPackage ../development/python-modules/mlx { };

  mlxtend = callPackage ../development/python-modules/mlxtend { };

  mlt = toPythonModule (pkgs.mlt.override {
    python3 = python;
    enablePython = true;
  });

  mmcif-pdbx = callPackage ../development/python-modules/mmcif-pdbx { };

  mmcv = callPackage ../development/python-modules/mmcv { };

  mmengine = callPackage ../development/python-modules/mmengine { };

  mmh3 = callPackage ../development/python-modules/mmh3 { };

  mmpython = callPackage ../development/python-modules/mmpython { };

  mmtf-python = callPackage ../development/python-modules/mmtf-python { };

  mnemonic = callPackage ../development/python-modules/mnemonic { };

  mne-python = callPackage ../development/python-modules/mne-python { };

  mnist = callPackage ../development/python-modules/mnist { };

  moat-ble = callPackage ../development/python-modules/moat-ble { };

  mobi = callPackage ../development/python-modules/mobi { };

  mobly = callPackage ../development/python-modules/mobly { };

  mocket = callPackage ../development/python-modules/mocket {
    redis-server = pkgs.redis;
  };

  mock = callPackage ../development/python-modules/mock { };

  mockfs = callPackage ../development/python-modules/mockfs { };

  mockito = callPackage ../development/python-modules/mockito { };

  mock-open = callPackage ../development/python-modules/mock-open { };

  mock-services = callPackage ../development/python-modules/mock-services { };

  mock-ssh-server = callPackage ../development/python-modules/mock-ssh-server { };

  mockupdb = callPackage ../development/python-modules/mockupdb { };

  moddb = callPackage ../development/python-modules/moddb { };

  model-bakery = callPackage ../development/python-modules/model-bakery { };

  modelcif = callPackage ../development/python-modules/modelcif { };

  modeled = callPackage ../development/python-modules/modeled { };

  moderngl = callPackage ../development/python-modules/moderngl { };

  moderngl-window = callPackage ../development/python-modules/moderngl-window { };

  modestmaps = callPackage ../development/python-modules/modestmaps { };

  mohawk = callPackage ../development/python-modules/mohawk { };

  molecule = callPackage ../development/python-modules/molecule { };

  molecule-plugins = callPackage ../development/python-modules/molecule/plugins.nix { };

  monai = callPackage ../development/python-modules/monai { };

  monai-deploy = callPackage ../development/python-modules/monai-deploy { };

  monero = callPackage ../development/python-modules/monero { };

  mongomock = callPackage ../development/python-modules/mongomock { };

  mongodict = callPackage ../development/python-modules/mongodict { };

  mongoengine = callPackage ../development/python-modules/mongoengine { };

  mongoquery = callPackage ../development/python-modules/mongoquery { };

  monitorcontrol = callPackage ../development/python-modules/monitorcontrol { };

  monkeyhex = callPackage ../development/python-modules/monkeyhex { };

  monosat = pkgs.monosat.python {
    inherit buildPythonPackage;
    inherit (self) cython pytestCheckHook;
  };

  monotonic = callPackage ../development/python-modules/monotonic { };

  monty = callPackage ../development/python-modules/monty { };

  moonraker-api = callPackage ../development/python-modules/moonraker-api { };

  mopeka-iot-ble = callPackage ../development/python-modules/mopeka-iot-ble { };

  more-itertools = callPackage ../development/python-modules/more-itertools { };

  more-properties = callPackage ../development/python-modules/more-properties { };

  moreorless = callPackage ../development/python-modules/moreorless { };

  moretools = callPackage ../development/python-modules/moretools { };

  morfessor = callPackage ../development/python-modules/morfessor { };

  morphys = callPackage ../development/python-modules/morphys { };

  mortgage = callPackage ../development/python-modules/mortgage { };

  motmetrics = callPackage ../development/python-modules/motmetrics { };

  motionblinds = callPackage ../development/python-modules/motionblinds { };

  motioneye-client = callPackage ../development/python-modules/motioneye-client { };

  moto = callPackage ../development/python-modules/moto { };

  motor = callPackage ../development/python-modules/motor { };

  mouseinfo = callPackage ../development/python-modules/mouseinfo { };

  moviepy = callPackage ../development/python-modules/moviepy { };

  mox3 = callPackage ../development/python-modules/mox3 { };

  mpd2 = callPackage ../development/python-modules/mpd2 { };

  mpi4py = callPackage ../development/python-modules/mpi4py { };

  mpldatacursor = callPackage ../development/python-modules/mpldatacursor { };

  mplfinance = callPackage ../development/python-modules/mplfinance { };

  mplhep = callPackage ../development/python-modules/mplhep { };

  mplhep-data = callPackage ../development/python-modules/mplhep-data { };

  mplleaflet = callPackage ../development/python-modules/mplleaflet { };

  mpl-scatter-density = callPackage ../development/python-modules/mpl-scatter-density { };

  mpmath = callPackage ../development/python-modules/mpmath { };

  mpris-server = callPackage ../development/python-modules/mpris-server { };

  mpv = callPackage ../development/python-modules/mpv {
    inherit (pkgs) mpv;
  };

  mpyq = callPackage ../development/python-modules/mpyq { };

  mrjob = callPackage ../development/python-modules/mrjob { };

  mrsqm = callPackage ../development/python-modules/mrsqm { };

  ms-active-directory = callPackage ../development/python-modules/ms-active-directory { };

  ms-cv = callPackage ../development/python-modules/ms-cv { };

  msal = callPackage ../development/python-modules/msal { };

  msal-extensions = callPackage ../development/python-modules/msal-extensions { };

  mscerts = callPackage ../development/python-modules/mscerts { };

  msgpack = callPackage ../development/python-modules/msgpack { };

  msgpack-numpy = callPackage ../development/python-modules/msgpack-numpy { };

  msg-parser = callPackage ../development/python-modules/msg-parser { };

  msgspec = callPackage ../development/python-modules/msgspec { };

  msldap = callPackage ../development/python-modules/msldap { };

  msoffcrypto-tool = callPackage ../development/python-modules/msoffcrypto-tool { };

  msprime = callPackage ../development/python-modules/msprime { };

  mss = callPackage ../development/python-modules/mss { };

  msrestazure = callPackage ../development/python-modules/msrestazure { };

  msrest = callPackage ../development/python-modules/msrest { };

  mt-940 = callPackage ../development/python-modules/mt-940 { };

  mullvad-api = callPackage ../development/python-modules/mullvad-api { };

  mullvad-closest = callPackage ../development/python-modules/mullvad-closest { };

  mulpyplexer = callPackage ../development/python-modules/mulpyplexer { };

  multidict = callPackage ../development/python-modules/multidict { };

  multi-key-dict = callPackage ../development/python-modules/multi-key-dict { };

  multimethod = callPackage ../development/python-modules/multimethod { };

  multipledispatch = callPackage ../development/python-modules/multipledispatch { };

  multiprocess = callPackage ../development/python-modules/multiprocess { };

  multiset = callPackage ../development/python-modules/multiset { };

  multitasking = callPackage ../development/python-modules/multitasking { };

  munch = callPackage ../development/python-modules/munch { };

  mung = callPackage ../development/python-modules/mung { };

  munkres = callPackage ../development/python-modules/munkres { };

  murmurhash = callPackage ../development/python-modules/murmurhash { };

  muscima = callPackage ../development/python-modules/muscima { };

  musicbrainzngs = callPackage ../development/python-modules/musicbrainzngs { };

  music-tag = callPackage ../development/python-modules/music-tag { };

  mutag = callPackage ../development/python-modules/mutag { };

  mutagen = callPackage ../development/python-modules/mutagen { };

  mutatormath = callPackage ../development/python-modules/mutatormath { };

  mutesync = callPackage ../development/python-modules/mutesync { };

  mutf8 = callPackage ../development/python-modules/mutf8 { };

  mujoco = callPackage ../development/python-modules/mujoco {
    inherit (pkgs) mujoco;
  };

  mujson = callPackage ../development/python-modules/mujson { };

  mwcli = callPackage ../development/python-modules/mwcli { };

  mwclient = callPackage ../development/python-modules/mwclient { };

  mwdblib = callPackage ../development/python-modules/mwdblib { };

  mwoauth = callPackage ../development/python-modules/mwoauth { };

  mwparserfromhell = callPackage ../development/python-modules/mwparserfromhell { };

  mwtypes = callPackage ../development/python-modules/mwtypes { };

  mwxml = callPackage ../development/python-modules/mwxml { };

  mxnet = callPackage ../development/python-modules/mxnet { };

  myfitnesspal = callPackage ../development/python-modules/myfitnesspal { };

  mygpoclient = callPackage ../development/python-modules/mygpoclient { };

  myhdl = callPackage ../development/python-modules/myhdl {
    inherit (pkgs) ghdl verilog;
  };

  myhome = callPackage ../development/python-modules/myhome { };

  myjwt = callPackage ../development/python-modules/myjwt { };

  mypy = callPackage ../development/python-modules/mypy { };

  mypy-boto3-builder = callPackage ../development/python-modules/mypy-boto3-builder { };

  inherit (callPackage ../development/python-modules/mypy-boto3 { })

    mypy-boto3-accessanalyzer

    mypy-boto3-account

    mypy-boto3-acm

    mypy-boto3-acm-pca

    mypy-boto3-alexaforbusiness

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

    mypy-boto3-backupstorage

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

    mypy-boto3-gamesparks

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

    mypy-boto3-honeycode

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

    mypy-boto3-iot-roborunner

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

    mypy-boto3-macie

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

    mypy-boto3-mobile

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

  mypy-extensions = callPackage ../development/python-modules/mypy/extensions.nix { };

  mypy-protobuf = callPackage ../development/python-modules/mypy-protobuf { };

  mysqlclient = callPackage ../development/python-modules/mysqlclient { };

  mysql-connector = callPackage ../development/python-modules/mysql-connector { };

  myst-docutils = callPackage ../development/python-modules/myst-docutils { };

  myst-nb = callPackage ../development/python-modules/myst-nb { };

  myst-parser = callPackage ../development/python-modules/myst-parser { };

  myuplink = callPackage ../development/python-modules/myuplink { };

  n3fit = callPackage ../development/python-modules/n3fit { };

  nad-receiver = callPackage ../development/python-modules/nad-receiver { };

  nagiosplugin = callPackage ../development/python-modules/nagiosplugin { };

  namedlist = callPackage ../development/python-modules/namedlist { };

  nameparser = callPackage ../development/python-modules/nameparser { };

  names = callPackage ../development/python-modules/names { };

  name-that-hash = callPackage ../development/python-modules/name-that-hash { };

  nameko = callPackage ../development/python-modules/nameko { };

  nampa = callPackage ../development/python-modules/nampa { };

  nanoid = callPackage ../development/python-modules/nanoid { };

  nanoleaf = callPackage ../development/python-modules/nanoleaf { };

  navec = callPackage ../development/python-modules/navec { };

  natasha = callPackage ../development/python-modules/natasha { };

  nomadnet = callPackage ../development/python-modules/nomadnet { };

  nox = callPackage ../development/python-modules/nox { };

  nanomsg-python = callPackage ../development/python-modules/nanomsg-python {
    inherit (pkgs) nanomsg;
  };

  nanotime = callPackage ../development/python-modules/nanotime { };

  napalm = callPackage ../development/python-modules/napalm { };

  napalm-hp-procurve = callPackage ../development/python-modules/napalm/hp-procurve.nix { };

  napari = callPackage ../development/python-modules/napari {
    inherit (pkgs.libsForQt5) mkDerivationWith wrapQtAppsHook;
  };

  napari-console = callPackage ../development/python-modules/napari-console { };

  napari-npe2 = callPackage ../development/python-modules/napari-npe2 { };

  napari-plugin-engine = callPackage ../development/python-modules/napari-plugin-engine { };

  napari-svg = callPackage ../development/python-modules/napari-svg { };

  nasdaq-data-link = callPackage ../development/python-modules/nasdaq-data-link { };

  nats-py = callPackage ../development/python-modules/nats-py { };

  nats-python = callPackage ../development/python-modules/nats-python { };

  natsort = callPackage ../development/python-modules/natsort { };

  naturalsort = callPackage ../development/python-modules/naturalsort { };

  nbclassic = callPackage ../development/python-modules/nbclassic { };

  nbclient = callPackage ../development/python-modules/nbclient { };

  nbconflux = callPackage ../development/python-modules/nbconflux { };

  nbconvert = callPackage ../development/python-modules/nbconvert { };

  nbdev = callPackage ../development/python-modules/nbdev { };

  nbdime = callPackage ../development/python-modules/nbdime { };

  nbexec = callPackage ../development/python-modules/nbexec { };

  nbformat = callPackage ../development/python-modules/nbformat { };

  nbmerge = callPackage ../development/python-modules/nbmerge { };

  nbsmoke = callPackage ../development/python-modules/nbsmoke { };

  nbsphinx = callPackage ../development/python-modules/nbsphinx { };

  nbtlib = callPackage ../development/python-modules/nbtlib { };

  nbval = callPackage ../development/python-modules/nbval { };

  nbxmpp = callPackage ../development/python-modules/nbxmpp { };

  nc-dnsapi = callPackage ../development/python-modules/nc-dnsapi { };

  ncclient = callPackage ../development/python-modules/ncclient { };

  nclib = callPackage ../development/python-modules/nclib { };

  ndeflib = callPackage ../development/python-modules/ndeflib { };

  ndg-httpsclient = callPackage ../development/python-modules/ndg-httpsclient { };

  ndindex = callPackage ../development/python-modules/ndindex { };

  ndjson = callPackage ../development/python-modules/ndjson { };

  ndms2-client = callPackage ../development/python-modules/ndms2-client { };

  ndspy = callPackage ../development/python-modules/ndspy { };

  ndtypes = callPackage ../development/python-modules/ndtypes { };

  nengo = callPackage ../development/python-modules/nengo { };

  neo = callPackage ../development/python-modules/neo { };

  neo4j = callPackage ../development/python-modules/neo4j { };

  neoteroi-mkdocs = callPackage ../development/python-modules/neoteroi-mkdocs { };

  nessclient = callPackage ../development/python-modules/nessclient { };

  nest = toPythonModule(pkgs.nest-mpi.override { withPython = true; python3 = python; });

  nest-asyncio = callPackage ../development/python-modules/nest-asyncio { };

  nested-lookup = callPackage ../development/python-modules/nested-lookup { };

  nestedtext = callPackage ../development/python-modules/nestedtext { };

  netaddr = callPackage ../development/python-modules/netaddr { };

  netapp-lib = callPackage ../development/python-modules/netapp-lib { };

  netapp-ontap = callPackage ../development/python-modules/netapp-ontap { };

  netcdf4 = callPackage ../development/python-modules/netcdf4 { };

  netdata = callPackage ../development/python-modules/netdata { };

  netdisco = callPackage ../development/python-modules/netdisco { };

  nethsm = callPackage ../development/python-modules/nethsm { };

  netifaces = callPackage ../development/python-modules/netifaces { };

  netmiko = callPackage ../development/python-modules/netmiko { };

  netio = callPackage ../development/python-modules/netio { };

  nettigo-air-monitor = callPackage ../development/python-modules/nettigo-air-monitor { };

  netutils = callPackage ../development/python-modules/netutils { };

  networkx = callPackage ../development/python-modules/networkx { };

  neuron-full = pkgs.neuron-full.override { python3 = python; };

  neuronpy = python.pkgs.toPythonModule neuron-full;

  nevow = callPackage ../development/python-modules/nevow { };

  newversion = callPackage ../development/python-modules/newversion { };

  newick = callPackage ../development/python-modules/newick { };

  nexia = callPackage ../development/python-modules/nexia { };

  nextcloudmonitor = callPackage ../development/python-modules/nextcloudmonitor { };

  nextcord = callPackage ../development/python-modules/nextcord { };

  nextdns = callPackage ../development/python-modules/nextdns { };

  nfcpy = callPackage ../development/python-modules/nfcpy { };

  nftables = toPythonModule (pkgs.nftables.override {
    python3 = python;
    withPython = true;
  });

  nh3 = callPackage ../development/python-modules/nh3 { };

  niaaml = callPackage ../development/python-modules/niaaml { };

  nianet = callPackage ../development/python-modules/nianet { };

  niaarm = callPackage ../development/python-modules/niaarm { };

  niaclass = callPackage ../development/python-modules/niaclass { };

  niapy = callPackage ../development/python-modules/niapy { };

  nibabel = callPackage ../development/python-modules/nibabel { };

  nibe = callPackage ../development/python-modules/nibe { };

  nidaqmx = callPackage ../development/python-modules/nidaqmx { };

  nikola = callPackage ../development/python-modules/nikola { };

  niko-home-control = callPackage ../development/python-modules/niko-home-control { };

  nilearn = callPackage ../development/python-modules/nilearn { };

  niluclient = callPackage ../development/python-modules/niluclient { };

  nimfa = callPackage ../development/python-modules/nimfa { };

  nine = callPackage ../development/python-modules/nine { };

  ninebot-ble = callPackage ../development/python-modules/ninebot-ble { };

  ninja = callPackage ../development/python-modules/ninja { inherit (pkgs) ninja; };

  nipreps-versions = callPackage ../development/python-modules/nipreps-versions { };

  nipy = callPackage ../development/python-modules/nipy { };

  nipype = callPackage ../development/python-modules/nipype {
    inherit (pkgs) which;
  };

  nitime = callPackage ../development/python-modules/nitime { };

  nitpick = callPackage ../applications/version-management/nitpick { };

  nitransforms = callPackage ../development/python-modules/nitransforms { };

  niworkflows = callPackage ../development/python-modules/niworkflows { };

  nix-kernel = callPackage ../development/python-modules/nix-kernel {
    inherit (pkgs) nix;
  };

  nixpkgs = callPackage ../development/python-modules/nixpkgs { };

  nixpkgs-pytools = callPackage ../development/python-modules/nixpkgs-pytools { };

  nix-prefetch-github = callPackage ../development/python-modules/nix-prefetch-github { };

  nkdfu = callPackage ../development/python-modules/nkdfu { };

  nlpcloud = callPackage ../development/python-modules/nlpcloud { };

  nltk = callPackage ../development/python-modules/nltk { };

  nnpdf = toPythonModule (pkgs.nnpdf.override {
    python3 = python;
  });

  nmapthon2 = callPackage ../development/python-modules/nmapthon2 { };

  amaranth-boards = callPackage ../development/python-modules/amaranth-boards { };

  amaranth = callPackage ../development/python-modules/amaranth { };

  amaranth-soc = callPackage ../development/python-modules/amaranth-soc { };

  nocasedict = callPackage ../development/python-modules/nocasedict { };

  nocaselist = callPackage ../development/python-modules/nocaselist { };

  nocturne = callPackage ../development/python-modules/nocturne { };

  nodeenv = callPackage ../development/python-modules/nodeenv { };

  nodepy-runtime = callPackage ../development/python-modules/nodepy-runtime { };

  node-semver = callPackage ../development/python-modules/node-semver { };

  noise = callPackage ../development/python-modules/noise { };

  noiseprotocol = callPackage ../development/python-modules/noiseprotocol { };

  norfair = callPackage ../development/python-modules/norfair { };

  normality = callPackage ../development/python-modules/normality { };

  nose = callPackage ../development/python-modules/nose { };

  nose2 = callPackage ../development/python-modules/nose2 { };

  nose3 = callPackage ../development/python-modules/nose3 { };

  nose-cov = callPackage ../development/python-modules/nose-cov { };

  nose-cprof = callPackage ../development/python-modules/nose-cprof { };

  nose-exclude = callPackage ../development/python-modules/nose-exclude { };

  nose-timer = callPackage ../development/python-modules/nose-timer { };

  nosejs = callPackage ../development/python-modules/nosejs { };

  nose-pattern-exclude = callPackage ../development/python-modules/nose-pattern-exclude { };

  nose-randomly = callPackage ../development/python-modules/nose-randomly { };

  nose-warnings-filters = callPackage ../development/python-modules/nose-warnings-filters { };

  nosexcover = callPackage ../development/python-modules/nosexcover { };

  notebook = callPackage ../development/python-modules/notebook { };

  notebook-shim = callPackage ../development/python-modules/notebook-shim { };

  notedown = callPackage ../development/python-modules/notedown { };

  notifications-android-tv = callPackage ../development/python-modules/notifications-android-tv { };

  notifications-python-client = callPackage ../development/python-modules/notifications-python-client { };

  notify-events = callPackage ../development/python-modules/notify-events { };

  notify-py = callPackage ../development/python-modules/notify-py { };

  notify2 = callPackage ../development/python-modules/notify2 { };

  notion-client = callPackage ../development/python-modules/notion-client { };

  notmuch = callPackage ../development/python-modules/notmuch {
    inherit (pkgs) notmuch;
  };

  notmuch2 = callPackage ../development/python-modules/notmuch2 {
    inherit (pkgs) notmuch;
  };

  nototools = callPackage ../development/python-modules/nototools { };

  notus-scanner = callPackage ../development/python-modules/notus-scanner { };

  nplusone = callPackage ../development/python-modules/nplusone { };

  nptyping  = callPackage ../development/python-modules/nptyping { };

  npyscreen = callPackage ../development/python-modules/npyscreen { };

  nsapi = callPackage ../development/python-modules/nsapi { };

  ntc-templates = callPackage ../development/python-modules/ntc-templates { };

  ntplib = callPackage ../development/python-modules/ntplib { };

  nuitka = callPackage ../development/python-modules/nuitka { };

  nuheat = callPackage ../development/python-modules/nuheat { };

  nulltype = callPackage ../development/python-modules/nulltype { };

  num2words = callPackage ../development/python-modules/num2words { };

  numba = callPackage ../development/python-modules/numba {
    inherit (pkgs.config) cudaSupport;
  };

  numbaWithCuda = self.numba.override {
    cudaSupport = true;
  };

  numba-scipy = callPackage ../development/python-modules/numba-scipy { };

  numcodecs = callPackage ../development/python-modules/numcodecs { };

  numdifftools = callPackage ../development/python-modules/numdifftools { };

  numericalunits = callPackage ../development/python-modules/numericalunits { };

  numexpr = callPackage ../development/python-modules/numexpr { };

  numpydoc = callPackage ../development/python-modules/numpydoc { };

  numpy = callPackage ../development/python-modules/numpy { };

  numpy-stl = callPackage ../development/python-modules/numpy-stl { };

  numpyro = callPackage ../development/python-modules/numpyro { };

  nunavut = callPackage ../development/python-modules/nunavut { };

  nutils = callPackage ../development/python-modules/nutils { };

  nvchecker = callPackage ../development/python-modules/nvchecker { };

  nvdlib = callPackage ../development/python-modules/nvdlib { };

  nvidia-ml-py = callPackage ../development/python-modules/nvidia-ml-py { };

  nsz = callPackage ../development/python-modules/nsz { };

  nxt-python = callPackage ../development/python-modules/nxt-python { };

  python-ndn = callPackage ../development/python-modules/python-ndn { };

  python-nvd3 = callPackage ../development/python-modules/python-nvd3 { };

  python-secp256k1-cardano = callPackage ../development/python-modules/python-secp256k1-cardano { };

  python-tds = callPackage ../development/python-modules/python-tds { };

  python-yate = callPackage ../development/python-modules/python-yate { };

  python-youtube = callPackage ../development/python-modules/python-youtube { };

  py-aosmith = callPackage ../development/python-modules/py-aosmith { };

  py-deprecate = callPackage ../development/python-modules/py-deprecate { };

  py-ecc = callPackage ../development/python-modules/py-ecc { };

  py-eth-sig-utils = callPackage ../development/python-modules/py-eth-sig-utils { };

  py-expression-eval = callPackage ../development/python-modules/py-expression-eval { };

  py-radix-sr = callPackage ../development/python-modules/py-radix-sr { };

  nwdiag = callPackage ../development/python-modules/nwdiag { };

  oasatelematics = callPackage ../development/python-modules/oasatelematics { };

  oath = callPackage ../development/python-modules/oath { };

  oauth2 = callPackage ../development/python-modules/oauth2 { };

  oauth2client = callPackage ../development/python-modules/oauth2client { };

  oauth = callPackage ../development/python-modules/oauth { };

  oauthenticator = callPackage ../development/python-modules/oauthenticator { };

  oauthlib = callPackage ../development/python-modules/oauthlib { };

  obfsproxy = callPackage ../development/python-modules/obfsproxy { };

  objax = callPackage ../development/python-modules/objax { };

  objsize = callPackage ../development/python-modules/objsize { };

  objgraph = callPackage ../development/python-modules/objgraph {
    # requires both the graphviz package and python package
    graphvizPkgs = pkgs.graphviz;
  };

  obspy = callPackage ../development/python-modules/obspy { };

  oca-port = callPackage ../development/python-modules/oca-port { };

  ochre = callPackage ../development/python-modules/ochre { };

  oci = callPackage ../development/python-modules/oci { };

  ocifs = callPackage ../development/python-modules/ocifs { };

  ocrmypdf = callPackage ../development/python-modules/ocrmypdf {
    tesseract = pkgs.tesseract5;
  };

  od = callPackage ../development/python-modules/od { };

  odfpy = callPackage ../development/python-modules/odfpy { };

  odp-amsterdam = callPackage ../development/python-modules/odp-amsterdam { };

  offtrac = callPackage ../development/python-modules/offtrac { };

  ofxclient = callPackage ../development/python-modules/ofxclient { };

  ofxhome = callPackage ../development/python-modules/ofxhome { };

  ofxparse = callPackage ../development/python-modules/ofxparse { };

  ofxtools = callPackage ../development/python-modules/ofxtools { };

  oemthermostat = callPackage ../development/python-modules/oemthermostat { };

  okonomiyaki = callPackage ../development/python-modules/okonomiyaki { };

  okta = callPackage ../development/python-modules/okta { };

  oldest-supported-numpy = callPackage ../development/python-modules/oldest-supported-numpy { };

  olefile = callPackage ../development/python-modules/olefile { };

  oletools = callPackage ../development/python-modules/oletools { };

  ollama = callPackage ../development/python-modules/ollama { };

  omegaconf = callPackage ../development/python-modules/omegaconf { };

  omemo-dr = callPackage ../development/python-modules/omemo-dr { };

  ome-zarr = callPackage ../development/python-modules/ome-zarr { };

  omnikinverter = callPackage ../development/python-modules/omnikinverter { };

  omnilogic = callPackage ../development/python-modules/omnilogic { };

  omorfi = callPackage ../development/python-modules/omorfi { };

  omrdatasettools = callPackage ../development/python-modules/omrdatasettools { };

  ondilo = callPackage ../development/python-modules/ondilo { };

  onetimepass = callPackage ../development/python-modules/onetimepass { };

  onkyo-eiscp = callPackage ../development/python-modules/onkyo-eiscp { };

  online-judge-api-client = callPackage ../development/python-modules/online-judge-api-client { };

  online-judge-tools = callPackage ../development/python-modules/online-judge-tools { };

  onlykey-solo-python = callPackage ../development/python-modules/onlykey-solo-python { };

  onnx = callPackage ../development/python-modules/onnx {
    abseil-cpp = pkgs.abseil-cpp_202301;
  };

  onnxconverter-common = callPackage ../development/python-modules/onnxconverter-common {
    inherit (pkgs) protobuf;
  };

  onnxmltools = callPackage ../development/python-modules/onnxmltools { };

  onnxruntime = callPackage ../development/python-modules/onnxruntime {
    onnxruntime = pkgs.onnxruntime.override {
      python3Packages = self;
      pythonSupport = true;
    };
  };

  onnxruntime-tools = callPackage ../development/python-modules/onnxruntime-tools { };

  onvif-zeep = callPackage ../development/python-modules/onvif-zeep { };

  onvif-zeep-async = callPackage ../development/python-modules/onvif-zeep-async { };

  oocsi = callPackage ../development/python-modules/oocsi { };

  opcua-widgets = callPackage ../development/python-modules/opcua-widgets { };

  open-clip-torch = callPackage ../development/python-modules/open-clip-torch { };

  open-garage = callPackage ../development/python-modules/open-garage { };

  open-interpreter = callPackage ../development/python-modules/open-interpreter { };

  open-meteo = callPackage ../development/python-modules/open-meteo { };

  openai-triton = callPackage ../development/python-modules/openai-triton {
    llvm = pkgs.openai-triton-llvm;
    cudaPackages = pkgs.cudaPackages_12_1;
  };

  openai-triton-cuda = self.openai-triton.override {
    cudaSupport = true;
  };

  openai-triton-no-cuda = self.openai-triton.override {
    cudaSupport = false;
  };

  openai-triton-bin = callPackage ../development/python-modules/openai-triton/bin.nix { };

  openai-whisper = callPackage ../development/python-modules/openai-whisper { };

  openant = callPackage ../development/python-modules/openant { };

  openapi-schema-validator = callPackage ../development/python-modules/openapi-schema-validator { };

  openapi-spec-validator = callPackage ../development/python-modules/openapi-spec-validator { };

  openapi3 = callPackage ../development/python-modules/openapi3 { };

  openbabel-bindings = callPackage ../development/python-modules/openbabel-bindings {
      openbabel = callPackage ../development/libraries/openbabel { inherit (self) python; };
  };

  opencensus = callPackage ../development/python-modules/opencensus { };

  opencensus-context = callPackage ../development/python-modules/opencensus-context { };

  opencensus-ext-azure = callPackage ../development/python-modules/opencensus-ext-azure { };

  opencontainers = callPackage ../development/python-modules/opencontainers { };

  opencv4 = toPythonModule (pkgs.opencv4.override {
    enablePython = true;
    pythonPackages = self;
  });

  openerz-api = callPackage ../development/python-modules/openerz-api { };

  openevsewifi = callPackage ../development/python-modules/openevsewifi { };

  openhomedevice = callPackage ../development/python-modules/openhomedevice { };

  openidc-client = callPackage ../development/python-modules/openidc-client { };

  openmm = toPythonModule (pkgs.openmm.override {
    python3Packages = self;
    enablePython = true;
  });

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

  openstackdocstheme = callPackage ../development/python-modules/openstackdocstheme { };

  openstacksdk = callPackage ../development/python-modules/openstacksdk { };

  opentimestamps = callPackage ../development/python-modules/opentimestamps { };

  opentelemetry-api = callPackage ../development/python-modules/opentelemetry-api { };

  opentelemetry-exporter-otlp = callPackage ../development/python-modules/opentelemetry-exporter-otlp { };

  opentelemetry-exporter-otlp-proto-common = callPackage ../development/python-modules/opentelemetry-exporter-otlp-proto-common { };

  opentelemetry-exporter-otlp-proto-grpc = callPackage ../development/python-modules/opentelemetry-exporter-otlp-proto-grpc { };

  opentelemetry-exporter-otlp-proto-http = callPackage ../development/python-modules/opentelemetry-exporter-otlp-proto-http { };

  opentelemetry-exporter-prometheus = callPackage ../development/python-modules/opentelemetry-exporter-prometheus { };

  opentelemetry-instrumentation = callPackage ../development/python-modules/opentelemetry-instrumentation { };

  opentelemetry-instrumentation-aiohttp-client = callPackage ../development/python-modules/opentelemetry-instrumentation-aiohttp-client { };

  opentelemetry-instrumentation-asgi = callPackage ../development/python-modules/opentelemetry-instrumentation-asgi { };

  opentelemetry-instrumentation-django = callPackage ../development/python-modules/opentelemetry-instrumentation-django { };

  opentelemetry-instrumentation-fastapi = callPackage ../development/python-modules/opentelemetry-instrumentation-fastapi { };

  opentelemetry-instrumentation-flask = callPackage ../development/python-modules/opentelemetry-instrumentation-flask { };

  opentelemetry-instrumentation-grpc = callPackage ../development/python-modules/opentelemetry-instrumentation-grpc { };

  opentelemetry-instrumentation-wsgi = callPackage ../development/python-modules/opentelemetry-instrumentation-wsgi { };

  opentelemetry-proto = callPackage ../development/python-modules/opentelemetry-proto { };

  opentelemetry-semantic-conventions = callPackage ../development/python-modules/opentelemetry-semantic-conventions { };

  opentelemetry-sdk = callPackage ../development/python-modules/opentelemetry-sdk { };

  opentelemetry-test-utils = callPackage ../development/python-modules/opentelemetry-test-utils { };

  opentelemetry-util-http = callPackage ../development/python-modules/opentelemetry-util-http { };

  openturns = toPythonModule (pkgs.openturns.override {
    python3Packages = self;
    enablePython = true;
  });

  opentracing = callPackage ../development/python-modules/opentracing { };

  opentsne = callPackage ../development/python-modules/opentsne { };

  opentypespec = callPackage ../development/python-modules/opentypespec { };

  openvino = callPackage ../development/python-modules/openvino {
    openvino-native = pkgs.openvino.override {
      inherit python;
    };
  };

  openwebifpy = callPackage ../development/python-modules/openwebifpy { };

  openwrt-luci-rpc = callPackage ../development/python-modules/openwrt-luci-rpc { };

  openwrt-ubus-rpc = callPackage ../development/python-modules/openwrt-ubus-rpc { };

  opower = callPackage ../development/python-modules/opower { };

  opsdroid-get-image-size = callPackage ../development/python-modules/opsdroid-get-image-size { };

  opt-einsum = callPackage ../development/python-modules/opt-einsum { };

  optax = callPackage ../development/python-modules/optax { };

  optimum = callPackage ../development/python-modules/optimum { };

  optuna = callPackage ../development/python-modules/optuna { };

  opuslib = callPackage ../development/python-modules/opuslib { };

  opytimark = callPackage ../development/python-modules/opytimark { };

  oracledb = callPackage ../development/python-modules/oracledb { };

  oralb-ble = callPackage ../development/python-modules/oralb-ble { };

  orange3 = callPackage ../development/python-modules/orange3 { };

  orange-canvas-core = callPackage ../development/python-modules/orange-canvas-core { };

  orange-widget-base = callPackage ../development/python-modules/orange-widget-base { };

  oras = callPackage ../development/python-modules/oras { };

  orbax-checkpoint = callPackage ../development/python-modules/orbax-checkpoint { };

  orderedmultidict = callPackage ../development/python-modules/orderedmultidict { };

  ordered-set = callPackage ../development/python-modules/ordered-set { };

  orderedset = callPackage ../development/python-modules/orderedset { };

  orgparse = callPackage ../development/python-modules/orgparse { };

  orjson = callPackage ../development/python-modules/orjson { };

  orm = callPackage ../development/python-modules/orm { };

  ormar = callPackage ../development/python-modules/ormar { };

  ortools = (toPythonModule (pkgs.or-tools.override { inherit (self) python; })).python;

  orvibo = callPackage ../development/python-modules/orvibo { };

  os-service-types = callPackage ../development/python-modules/os-service-types { };

  osc = callPackage ../development/python-modules/osc { };

  osc-diagram = callPackage ../development/python-modules/osc-diagram { };

  osc-lib = callPackage ../development/python-modules/osc-lib { };

  osc-sdk-python = callPackage ../development/python-modules/osc-sdk-python { };

  oscpy = callPackage ../development/python-modules/oscpy { };

  oscrypto = callPackage ../development/python-modules/oscrypto { };

  oscscreen = callPackage ../development/python-modules/oscscreen { };

  oset = callPackage ../development/python-modules/oset { };

  osmnx = callPackage ../development/python-modules/osmnx { };

  osmpythontools = callPackage ../development/python-modules/osmpythontools { };

  oslo-concurrency = callPackage ../development/python-modules/oslo-concurrency { };

  oslo-config = callPackage ../development/python-modules/oslo-config { };

  oslo-context = callPackage ../development/python-modules/oslo-context { };

  oslo-db = callPackage ../development/python-modules/oslo-db { };

  oslo-i18n = callPackage ../development/python-modules/oslo-i18n { };

  oslo-log = callPackage ../development/python-modules/oslo-log { };

  oslo-serialization = callPackage ../development/python-modules/oslo-serialization { };

  oslo-utils = callPackage ../development/python-modules/oslo-utils { };

  oslotest = callPackage ../development/python-modules/oslotest { };

  ospd = callPackage ../development/python-modules/ospd { };

  osqp = callPackage ../development/python-modules/osqp { };

  oss2 = callPackage ../development/python-modules/oss2 { };

  ossfs = callPackage ../development/python-modules/ossfs { };

  ots-python = callPackage ../development/python-modules/ots-python { };

  outcome = callPackage ../development/python-modules/outcome { };

  ovh = callPackage ../development/python-modules/ovh { };

  ovmfvartool = callPackage ../development/python-modules/ovmfvartool { };

  ovoenergy = callPackage ../development/python-modules/ovoenergy { };

  owslib = callPackage ../development/python-modules/owslib { };

  oyaml = callPackage ../development/python-modules/oyaml { };

  p1monitor = callPackage ../development/python-modules/p1monitor { };

  packageurl-python = callPackage ../development/python-modules/packageurl-python { };

  packaging = callPackage ../development/python-modules/packaging { };

  packbits = callPackage ../development/python-modules/packbits { };

  packet-python = callPackage ../development/python-modules/packet-python { };

  packvers = callPackage ../development/python-modules/packvers { };

  pagelabels = callPackage ../development/python-modules/pagelabels { };

  paginate = callPackage ../development/python-modules/paginate { };

  paho-mqtt = callPackage ../development/python-modules/paho-mqtt { };

  palace = callPackage ../development/python-modules/palace { };

  palettable = callPackage ../development/python-modules/palettable { };

  pallets-sphinx-themes = callPackage ../development/python-modules/pallets-sphinx-themes { };

  python-docs-theme = callPackage ../development/python-modules/python-docs-theme { };

  pamela = callPackage ../development/python-modules/pamela { };

  pamqp = callPackage ../development/python-modules/pamqp { };

  panacotta = callPackage ../development/python-modules/panacotta { };

  panasonic-viera = callPackage ../development/python-modules/panasonic-viera { };

  pandas = callPackage ../development/python-modules/pandas {
    inherit (pkgs.darwin) adv_cmds;
  };

  pandas-datareader = callPackage ../development/python-modules/pandas-datareader { };

  pandoc-attributes = callPackage ../development/python-modules/pandoc-attributes { };

  pandoc-xnos = callPackage ../development/python-modules/pandoc-xnos { };

  pandocfilters = callPackage ../development/python-modules/pandocfilters { };

  panel = callPackage ../development/python-modules/panel { };

  panflute = callPackage ../development/python-modules/panflute { };

  papermill = callPackage ../development/python-modules/papermill { };

  openpaperwork-core = callPackage ../applications/office/paperwork/openpaperwork-core.nix { };
  openpaperwork-gtk = callPackage ../applications/office/paperwork/openpaperwork-gtk.nix { };
  paperwork-backend = callPackage ../applications/office/paperwork/paperwork-backend.nix { };
  paperwork-shell = callPackage ../applications/office/paperwork/paperwork-shell.nix { };

  papis = callPackage ../development/python-modules/papis { };

  papis-python-rofi = callPackage ../development/python-modules/papis-python-rofi { };

  para = callPackage ../development/python-modules/para { };

  param = callPackage ../development/python-modules/param { };

  parameter-expansion-patched = callPackage ../development/python-modules/parameter-expansion-patched { };

  parameterized = callPackage ../development/python-modules/parameterized { };

  parametrize-from-file = callPackage ../development/python-modules/parametrize-from-file { };

  paramiko = callPackage ../development/python-modules/paramiko { };

  paramz = callPackage ../development/python-modules/paramz { };

  paranoid-crypto = callPackage ../development/python-modules/paranoid-crypto { };

  parfive = callPackage ../development/python-modules/parfive { };

  parquet = callPackage ../development/python-modules/parquet { };

  parse = callPackage ../development/python-modules/parse { };

  parsedatetime = callPackage ../development/python-modules/parsedatetime { };

  parsedmarc = callPackage ../development/python-modules/parsedmarc { };

  parsel = callPackage ../development/python-modules/parsel { };

  parse-type = callPackage ../development/python-modules/parse-type { };

  parsimonious = callPackage ../development/python-modules/parsimonious { };

  parsley = callPackage ../development/python-modules/parsley { };

  parso = callPackage ../development/python-modules/parso { };

  parsy = callPackage ../development/python-modules/parsy { };

  partd = callPackage ../development/python-modules/partd { };

  parts = callPackage ../development/python-modules/parts { };

  particle = callPackage ../development/python-modules/particle { };

  parver = callPackage ../development/python-modules/parver { };
  arpeggio = callPackage ../development/python-modules/arpeggio { };

  pasimple = callPackage ../development/python-modules/pasimple { };

  passlib = callPackage ../development/python-modules/passlib { };

  paste = callPackage ../development/python-modules/paste { };

  pastedeploy = callPackage ../development/python-modules/pastedeploy { };

  pastel = callPackage ../development/python-modules/pastel { };

  pastescript = callPackage ../development/python-modules/pastescript { };

  patator = callPackage ../development/python-modules/patator { };

  patch = callPackage ../development/python-modules/patch { };

  patch-ng = callPackage ../development/python-modules/patch-ng { };

  path = callPackage ../development/python-modules/path { };

  path-and-address = callPackage ../development/python-modules/path-and-address { };

  pathable = callPackage ../development/python-modules/pathable { };

  pathlib2 = callPackage ../development/python-modules/pathlib2 { };

  pathlib = callPackage ../development/python-modules/pathlib { };

  pathlib-abc = callPackage ../development/python-modules/pathlib-abc { };

  pathos = callPackage ../development/python-modules/pathos { };

  pathspec = callPackage ../development/python-modules/pathspec { };

  pathtools = callPackage ../development/python-modules/pathtools { };

  pathvalidate = callPackage ../development/python-modules/pathvalidate { };

  pathy = callPackage ../development/python-modules/pathy { };

  patiencediff = callPackage ../development/python-modules/patiencediff { };

  patool = callPackage ../development/python-modules/patool { };

  patsy = callPackage ../development/python-modules/patsy { };

  patrowl4py = callPackage ../development/python-modules/patrowl4py { };

  paver = callPackage ../development/python-modules/paver { };

  paypal-checkout-serversdk = callPackage ../development/python-modules/paypal-checkout-serversdk { };

  paypalhttp = callPackage ../development/python-modules/paypalhttp { };

  paypalrestsdk = callPackage ../development/python-modules/paypalrestsdk { };

  pbkdf2 = callPackage ../development/python-modules/pbkdf2 { };

  pbr = callPackage ../development/python-modules/pbr { };

  pc-ble-driver-py = toPythonModule (callPackage ../development/python-modules/pc-ble-driver-py { });

  pcapy-ng = callPackage ../development/python-modules/pcapy-ng {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  pcbnewtransition = callPackage ../development/python-modules/pcbnewtransition { };

  pcodedmp = callPackage ../development/python-modules/pcodedmp { };

  pcpp = callPackage ../development/python-modules/pcpp { };

  pdb2pqr = callPackage ../development/python-modules/pdb2pqr { };

  pdbfixer = callPackage ../development/python-modules/pdbfixer { };

  pdf2docx = callPackage ../development/python-modules/pdf2docx { };

  pdf2image = callPackage ../development/python-modules/pdf2image { };

  pdfkit = callPackage ../development/python-modules/pdfkit { };

  pdfminer-six = callPackage ../development/python-modules/pdfminer-six { };

  pdfplumber = callPackage ../development/python-modules/pdfplumber { };

  pdfrw = callPackage ../development/python-modules/pdfrw { };

  pdfrw2 = callPackage ../development/python-modules/pdfrw2 { };

  pdftotext = callPackage ../development/python-modules/pdftotext { };

  pdfx = callPackage ../development/python-modules/pdfx { };

  pdm-backend = callPackage ../development/python-modules/pdm-backend { };

  pdm-pep517 = callPackage ../development/python-modules/pdm-pep517 { };

  pdoc = callPackage ../development/python-modules/pdoc { };

  pdoc-pyo3-sample-library = callPackage ../development/python-modules/pdoc-pyo3-sample-library { };

  pdoc3 = callPackage ../development/python-modules/pdoc3 { };

  peaqevcore = callPackage ../development/python-modules/peaqevcore { };

  pegen = callPackage ../development/python-modules/pegen { };

  pebble = callPackage ../development/python-modules/pebble { };

  pecan = callPackage ../development/python-modules/pecan { };

  peco = callPackage ../development/python-modules/peco { };

  peewee = callPackage ../development/python-modules/peewee { };

  peewee-migrate = callPackage ../development/python-modules/peewee-migrate { };

  pefile = callPackage ../development/python-modules/pefile { };

  peft = callPackage ../development/python-modules/peft { };

  pelican = callPackage ../development/python-modules/pelican {
    inherit (pkgs) glibcLocales git;
  };

  pem = callPackage ../development/python-modules/pem { };

  pendulum = callPackage ../development/python-modules/pendulum { };

  pep440 = callPackage ../development/python-modules/pep440 { };

  pep517 = callPackage ../development/python-modules/pep517 { };

  pep8 = callPackage ../development/python-modules/pep8 { };

  pep8-naming = callPackage ../development/python-modules/pep8-naming { };

  peppercorn = callPackage ../development/python-modules/peppercorn { };

  percol = callPackage ../development/python-modules/percol { };

  perfplot = callPackage ../development/python-modules/perfplot { };

  periodictable = callPackage ../development/python-modules/periodictable { };

  periodiq = callPackage ../development/python-modules/periodiq { };

  permissionedforms = callPackage ../development/python-modules/permissionedforms { };

  persim = callPackage ../development/python-modules/persim { };

  persist-queue = callPackage ../development/python-modules/persist-queue { };

  persistent = callPackage ../development/python-modules/persistent { };

  persisting-theory = callPackage ../development/python-modules/persisting-theory { };

  pescea = callPackage ../development/python-modules/pescea { };

  pex = callPackage ../development/python-modules/pex { };

  pexif = callPackage ../development/python-modules/pexif { };

  pexpect = callPackage ../development/python-modules/pexpect { };

  pfzy = callPackage ../development/python-modules/pfzy { };

  ping3 = callPackage ../development/python-modules/ping3 { };

  pins = callPackage ../development/python-modules/pins { };

  pg8000 = callPackage ../development/python-modules/pg8000 { };

  pgcli = callPackage ../development/python-modules/pgcli { };

  pglast = callPackage ../development/python-modules/pglast { };

  pgpdump = callPackage ../development/python-modules/pgpdump { };

  pgpy = callPackage ../development/python-modules/pgpy { };

  pgsanity = callPackage ../development/python-modules/pgsanity { };

  pgspecial = callPackage ../development/python-modules/pgspecial { };

  pgvector = callPackage ../development/python-modules/pgvector { };

  phe = callPackage ../development/python-modules/phe { };

  phik = callPackage ../development/python-modules/phik { };

  phone-modem = callPackage ../development/python-modules/phone-modem { };

  phonenumbers = callPackage ../development/python-modules/phonenumbers { };

  pkgutil-resolve-name = callPackage ../development/python-modules/pkgutil-resolve-name { };

  pkg-about = callPackage ../development/python-modules/pkg-about { };

  micloud = callPackage ../development/python-modules/micloud { };

  mqtt2influxdb = callPackage ../development/python-modules/mqtt2influxdb { };

  msgraph-core = callPackage ../development/python-modules/msgraph-core { };

  multipart = callPackage ../development/python-modules/multipart { };

  netmap = callPackage ../development/python-modules/netmap { };

  onetimepad = callPackage ../development/python-modules/onetimepad { };

  openai = callPackage ../development/python-modules/openai { };

  openaiauth = callPackage ../development/python-modules/openaiauth { };

  openapi-core = callPackage ../development/python-modules/openapi-core { };

  openusd = callPackage ../development/python-modules/openusd {
    alembic = pkgs.alembic;
  };

  outlines = callPackage ../development/python-modules/outlines { };

  overly = callPackage ../development/python-modules/overly { };

  overpy = callPackage ../development/python-modules/overpy { };

  overrides = callPackage ../development/python-modules/overrides { };

  pandas-stubs = callPackage ../development/python-modules/pandas-stubs { };

  pdunehd = callPackage ../development/python-modules/pdunehd { };

  pencompy = callPackage ../development/python-modules/pencompy { };

  pgmpy = callPackage ../development/python-modules/pgmpy { };

  phonopy = callPackage ../development/python-modules/phonopy { };

  pixcat = callPackage ../development/python-modules/pixcat { };

  pinecone-client = callPackage ../development/python-modules/pinecone-client { };

  psrpcore = callPackage ../development/python-modules/psrpcore { };

  pybars3 = callPackage ../development/python-modules/pybars3 { };

  pymeta3 = callPackage ../development/python-modules/pymeta3 { };

  pypemicro = callPackage ../development/python-modules/pypemicro { };

  pyprecice = callPackage ../development/python-modules/pyprecice { };

  pyprobables = callPackage ../development/python-modules/pyprobables { };

  pyproject-api = callPackage ../development/python-modules/pyproject-api { };

  pyproject-hooks = callPackage ../development/python-modules/pyproject-hooks { };

  pypsrp = callPackage ../development/python-modules/pypsrp { };

  phpserialize = callPackage ../development/python-modules/phpserialize { };

  phx-class-registry = callPackage ../development/python-modules/phx-class-registry { };

  pi1wire = callPackage ../development/python-modules/pi1wire { };

  piano-transcription-inference = callPackage ../development/python-modules/piano-transcription-inference { };

  piccata = callPackage ../development/python-modules/piccata { };

  pick = callPackage ../development/python-modules/pick { };

  pickleshare = callPackage ../development/python-modules/pickleshare { };

  picobox = callPackage ../development/python-modules/picobox { };

  picos = callPackage ../development/python-modules/picos { };

  picosvg = callPackage ../development/python-modules/picosvg { };

  piccolo-theme = callPackage ../development/python-modules/piccolo-theme { };

  pid = callPackage ../development/python-modules/pid { };

  piep = callPackage ../development/python-modules/piep { };

  piexif = callPackage ../development/python-modules/piexif { };

  pijuice = callPackage ../development/python-modules/pijuice { };

  pika = callPackage ../development/python-modules/pika { };

  pika-pool = callPackage ../development/python-modules/pika-pool { };

  pikepdf = callPackage ../development/python-modules/pikepdf { };

  pilkit = callPackage ../development/python-modules/pilkit { };

  pillowfight = callPackage ../development/python-modules/pillowfight { };

  pillow = callPackage ../development/python-modules/pillow {
    inherit (pkgs) freetype libjpeg zlib libtiff libwebp tcl lcms2 tk;
    inherit (pkgs.xorg) libX11 libxcb;
  };

  pillow-heif = callPackage ../development/python-modules/pillow-heif { };

  pillow-jpls = callPackage ../development/python-modules/pillow-jpls { };

  pillow-simd = callPackage ../development/python-modules/pillow-simd {
      inherit (pkgs) freetype libjpeg zlib libtiff libwebp tcl lcms2 tk;
      inherit (pkgs.xorg) libX11;
  };

  pims = callPackage ../development/python-modules/pims { };

  pinboard = callPackage ../development/python-modules/pinboard { };

  pinocchio = toPythonModule (pkgs.pinocchio.override {
    pythonSupport = true;
    python3Packages = self;
  });

  pint = callPackage ../development/python-modules/pint { };

  pint-pandas = callPackage ../development/python-modules/pint-pandas { };

  pip = callPackage ../development/python-modules/pip { };

  pipdate = callPackage ../development/python-modules/pipdate { };

  pipdeptree = callPackage ../development/python-modules/pipdeptree { };

  pipenv-poetry-migrate = callPackage ../development/python-modules/pipenv-poetry-migrate { };

  piper-phonemize = callPackage ../development/python-modules/piper-phonemize {
    onnxruntime-native = pkgs.onnxruntime;
    piper-phonemize-native = pkgs.piper-phonemize;
  };

  pip-api = callPackage ../development/python-modules/pip-api { };

  pip-tools = callPackage ../development/python-modules/pip-tools { };

  pip-requirements-parser = callPackage ../development/python-modules/pip-requirements-parser { };

  pipx = callPackage ../development/python-modules/pipx { };

  pivy = callPackage ../development/python-modules/pivy {
    inherit (pkgs.qt5) qtbase qmake;
    inherit (pkgs.libsForQt5) soqt;
  };

  pixelmatch = callPackage ../development/python-modules/pixelmatch { };

  pixel-font-builder = callPackage ../development/python-modules/pixel-font-builder { };

  pixel-ring = callPackage ../development/python-modules/pixel-ring { };

  pjsua2 = (toPythonModule (pkgs.pjsip.override {
    pythonSupport = true;
    python3 = self.python;
  })).py;

  pkce = callPackage ../development/python-modules/pkce { };

  pkgconfig = callPackage ../development/python-modules/pkgconfig { };

  pkginfo = callPackage ../development/python-modules/pkginfo { };

  pkginfo2 = callPackage ../development/python-modules/pkginfo2 { };

  pkuseg = callPackage ../development/python-modules/pkuseg { };

  playwright = callPackage ../development/python-modules/playwright { };

  playwright-stealth = callPackage ../development/python-modules/playwright-stealth { };

  playwrightcapture = callPackage ../development/python-modules/playwrightcapture { };

  pmsensor = callPackage ../development/python-modules/pmsensor { };

  ppdeep = callPackage ../development/python-modules/ppdeep { };

  prodict = callPackage ../development/python-modules/prodict { };

  prometheus-pandas = callPackage ../development/python-modules/prometheus-pandas { };

  prophet = callPackage ../development/python-modules/prophet { };

  propka = callPackage ../development/python-modules/propka { };

  proxy-tools = callPackage ../development/python-modules/proxy-tools { };

  proxy-db = callPackage ../development/python-modules/proxy-db { };

  py-nextbusnext = callPackage ../development/python-modules/py-nextbusnext { };

  py65 = callPackage ../development/python-modules/py65 { };

  pyaehw4a1 = callPackage ../development/python-modules/pyaehw4a1 { };

  pyatag = callPackage ../development/python-modules/pyatag { };

  pyatem = callPackage ../development/python-modules/pyatem { };

  pyatome = callPackage ../development/python-modules/pyatome { };

  pycketcasts = callPackage ../development/python-modules/pycketcasts { };

  pycomposefile = callPackage ../development/python-modules/pycomposefile { };
  pycontrol4 = callPackage ../development/python-modules/pycontrol4 { };

  pycookiecheat = callPackage ../development/python-modules/pycookiecheat { };

  pycoolmasternet-async = callPackage ../development/python-modules/pycoolmasternet-async { };

  pycrdt = callPackage ../development/python-modules/pycrdt { };

  pycrdt-websocket = callPackage ../development/python-modules/pycrdt-websocket { };

  pyfibaro = callPackage ../development/python-modules/pyfibaro { };

  pyfireservicerota = callPackage ../development/python-modules/pyfireservicerota { };

  pyflexit = callPackage ../development/python-modules/pyflexit { };

  pyflick = callPackage ../development/python-modules/pyflick { };

  pyfluidsynth = callPackage ../development/python-modules/pyfluidsynth { };

  pyformlang = callPackage ../development/python-modules/pyformlang { };

  pyfreedompro = callPackage ../development/python-modules/pyfreedompro { };

  pygments-style-github = callPackage ../development/python-modules/pygments-style-github { };

  pygnmi = callPackage ../development/python-modules/pygnmi { };

  pygount = callPackage ../development/python-modules/pygount { };

  pygti = callPackage ../development/python-modules/pygti { };

  pyheck = callPackage ../development/python-modules/pyheck { };

  pyheos = callPackage ../development/python-modules/pyheos { };

  pyhepmc = callPackage ../development/python-modules/pyhepmc { };

  pyhiveapi = callPackage ../development/python-modules/pyhiveapi { };

  pyhumps = callPackage ../development/python-modules/pyhumps { };

  pyinstaller-versionfile = callPackage ../development/python-modules/pyinstaller-versionfile { };

  pyisemail = callPackage ../development/python-modules/pyisemail { };

  pyisy = callPackage ../development/python-modules/pyisy { };

  pyixapi = callPackage ../development/python-modules/pyixapi { };

  pykrakenapi = callPackage ../development/python-modules/pykrakenapi { };

  pylddwrap = callPackage ../development/python-modules/pylddwrap { };

  pyngo = callPackage ../development/python-modules/pyngo { };

  pyngrok = callPackage ../development/python-modules/pyngrok { };

  pynitrokey = callPackage ../development/python-modules/pynitrokey { };

  pynndescent = callPackage ../development/python-modules/pynndescent { };

  pynobo = callPackage ../development/python-modules/pynobo { };

  pynose = callPackage ../development/python-modules/pynose { };

  pynuki = callPackage ../development/python-modules/pynuki { };

  pynut2 = callPackage ../development/python-modules/pynut2 { };

  pynws = callPackage ../development/python-modules/pynws { };

  pynx584 = callPackage ../development/python-modules/pynx584 { };

  pyorthanc = callPackage ../development/python-modules/pyorthanc { };

  pyoutbreaksnearme = callPackage ../development/python-modules/pyoutbreaksnearme { };

  pyoverkiz = callPackage ../development/python-modules/pyoverkiz { };

  pyownet = callPackage ../development/python-modules/pyownet { };

  pypoint = callPackage ../development/python-modules/pypoint { };

  pypoolstation = callPackage ../development/python-modules/pypoolstation { };

  pyrdfa3 = callPackage ../development/python-modules/pyrdfa3 { };

  pyre-extensions = callPackage ../development/python-modules/pyre-extensions { };

  pyrender = callPackage ../development/python-modules/pyrender { };

  pyrevolve = callPackage ../development/python-modules/pyrevolve { };

  pyrfxtrx = callPackage ../development/python-modules/pyrfxtrx { };

  pyrogram = callPackage ../development/python-modules/pyrogram { };

  pysabnzbd = callPackage ../development/python-modules/pysabnzbd { };

  pysbd = callPackage ../development/python-modules/pysbd { };

  pysequoia = callPackage ../development/python-modules/pysequoia { };

  pyschemes = callPackage ../development/python-modules/pyschemes { };

  pyschlage = callPackage ../development/python-modules/pyschlage { };

  pyshark = callPackage ../development/python-modules/pyshark { };

  pysiaalarm = callPackage ../development/python-modules/pysiaalarm { };

  pysimplesoap = callPackage ../development/python-modules/pysimplesoap { };

  pyskyqhub = callPackage ../development/python-modules/pyskyqhub { };

  pyskyqremote = callPackage ../development/python-modules/pyskyqremote { };

  pysolcast = callPackage ../development/python-modules/pysolcast { };

  pysubs2 = callPackage ../development/python-modules/pysubs2 { };

  pysuez = callPackage ../development/python-modules/pysuez { };

  pysqlitecipher = callPackage ../development/python-modules/pysqlitecipher { };

  pysyncthru = callPackage ../development/python-modules/pysyncthru { };

  pytest-mockito = callPackage ../development/python-modules/pytest-mockito { };

  pytest-pudb = callPackage ../development/python-modules/pytest-pudb { };

  pytlv = callPackage ../development/python-modules/pytlv { };

  python-codon-tables = callPackage ../development/python-modules/python-codon-tables { };

  python-creole = callPackage ../development/python-modules/python-creole { };

  python-crfsuite = callPackage ../development/python-modules/python-crfsuite { };

  python-csxcad = callPackage ../development/python-modules/python-csxcad { };

  python-djvulibre = callPackage ../development/python-modules/python-djvulibre { };

  python-ecobee-api = callPackage ../development/python-modules/python-ecobee-api { };

  python-flirt = callPackage ../development/python-modules/python-flirt { };

  python-fullykiosk = callPackage ../development/python-modules/python-fullykiosk { };

  python-fx = callPackage ../development/python-modules/python-fx { };

  python-glanceclient = callPackage ../development/python-modules/python-glanceclient { };

  python-google-nest = callPackage ../development/python-modules/python-google-nest { };

  python-heatclient = callPackage ../development/python-modules/python-heatclient { };

  python-hl7 = callPackage ../development/python-modules/python-hl7 { };

  python-ipmi = callPackage ../development/python-modules/python-ipmi { };

  python-ipware = callPackage ../development/python-modules/python-ipware { };

  python-ironicclient = callPackage ../development/python-modules/python-ironicclient { };

  python-izone = callPackage ../development/python-modules/python-izone { };

  python-juicenet = callPackage ../development/python-modules/python-juicenet { };

  python-kasa = callPackage ../development/python-modules/python-kasa { };

  python-keycloak = callPackage ../development/python-modules/python-keycloak { };

  python-keystoneclient = callPackage ../development/python-modules/python-keystoneclient { };

  python-lsp-black = callPackage ../development/python-modules/python-lsp-black { };

  python-mbedtls = callPackage ../development/python-modules/python-mbedtls { };

  python-memcached = callPackage ../development/python-modules/python-memcached {
    inherit (pkgs) memcached;
  };

  python-otbr-api = callPackage ../development/python-modules/python-otbr-api { };

  python-openems = callPackage ../development/python-modules/python-openems { };

  python-opensky = callPackage ../development/python-modules/python-opensky { };

  python-owasp-zap-v2-4 = callPackage ../development/python-modules/python-owasp-zap-v2-4 { };

  python-pptx = callPackage ../development/python-modules/python-pptx { };

  python-songpal = callPackage ../development/python-modules/python-songpal { };

  python-swiftclient = callPackage ../development/python-modules/python-swiftclient { };

  python-tado = callPackage ../development/python-modules/python-tado { };

  python-idzip = callPackage ../development/python-modules/python-idzip { };

  pythonfinder = callPackage ../development/python-modules/pythonfinder { };

  pytomorrowio = callPackage ../development/python-modules/pytomorrowio { };

  pyuca = callPackage ../development/python-modules/pyuca { };

  pyunpack = callPackage ../development/python-modules/pyunpack { };

  pyutil = callPackage ../development/python-modules/pyutil { };

  pyzbar = callPackage ../development/python-modules/pyzbar { };

  pyzipper = callPackage ../development/python-modules/pyzipper { };

  pkutils = callPackage ../development/python-modules/pkutils { };

  plac = callPackage ../development/python-modules/plac { };

  plaid-python = callPackage ../development/python-modules/plaid-python { };

  plantuml = callPackage ../development/python-modules/plantuml { };

  plantuml-markdown = callPackage ../development/python-modules/plantuml-markdown {
    inherit (pkgs) plantuml;
  };

  plaster = callPackage ../development/python-modules/plaster { };

  plaster-pastedeploy = callPackage ../development/python-modules/plaster-pastedeploy { };

  platformdirs = callPackage ../development/python-modules/platformdirs { };

  playsound = callPackage ../development/python-modules/playsound { };

  plexapi = callPackage ../development/python-modules/plexapi { };

  plexauth = callPackage ../development/python-modules/plexauth { };

  plexwebsocket = callPackage ../development/python-modules/plexwebsocket { };

  plfit = toPythonModule (pkgs.plfit.override {
    inherit (self) python;
  });

  plone-testing = callPackage ../development/python-modules/plone-testing { };

  plotext = callPackage ../development/python-modules/plotext { };

  plotly = callPackage ../development/python-modules/plotly { };

  plotnine = callPackage ../development/python-modules/plotnine { };

  pluggy = callPackage ../development/python-modules/pluggy { };

  plugincode = callPackage ../development/python-modules/plugincode { };

  pluginbase = callPackage ../development/python-modules/pluginbase { };

  plugnplay = callPackage ../development/python-modules/plugnplay { };

  plugwise = callPackage ../development/python-modules/plugwise { };

  plum-py = callPackage ../development/python-modules/plum-py { };

  plumbum = callPackage ../development/python-modules/plumbum { };

  pluthon = callPackage ../development/python-modules/pluthon { };

  plux = callPackage ../development/python-modules/plux { };

  ply = callPackage ../development/python-modules/ply { };

  plyer = callPackage ../development/python-modules/plyer { };

  plyfile = callPackage ../development/python-modules/plyfile { };

  plyplus = callPackage ../development/python-modules/plyplus { };

  plyvel = callPackage ../development/python-modules/plyvel { };

  pmw = callPackage ../development/python-modules/pmw { };

  pmdarima = callPackage ../development/python-modules/pmdarima { };

  pmdsky-debug-py = callPackage ../development/python-modules/pmdsky-debug-py { };

  pnglatex = callPackage ../development/python-modules/pnglatex { };

  pocket = callPackage ../development/python-modules/pocket { };

  podcastparser = callPackage ../development/python-modules/podcastparser { };

  podcats = callPackage ../development/python-modules/podcats { };

  podman = callPackage ../development/python-modules/podman { };

  poetry-core = callPackage ../development/python-modules/poetry-core { };

  poetry-dynamic-versioning = callPackage ../development/python-modules/poetry-dynamic-versioning { };

  poetry-semver = callPackage ../development/python-modules/poetry-semver { };

  polars = callPackage ../development/python-modules/polars { };

  polarizationsolver = callPackage ../development/python-modules/polarizationsolver { };

  polling = callPackage ../development/python-modules/polling { };

  polib = callPackage ../development/python-modules/polib { };

  policy-sentry = callPackage ../development/python-modules/policy-sentry { };

  policyuniverse = callPackage ../development/python-modules/policyuniverse { };

  polyline = callPackage ../development/python-modules/polyline { };

  polygon3 = callPackage ../development/python-modules/polygon3 { };

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

  portalocker = callPackage ../development/python-modules/portalocker { };

  portend = callPackage ../development/python-modules/portend { };

  port-for = callPackage ../development/python-modules/port-for { };

  portpicker = callPackage ../development/python-modules/portpicker { };

  posix-ipc = callPackage ../development/python-modules/posix-ipc { };

  posthog = callPackage ../development/python-modules/posthog { };

  pot = callPackage ../development/python-modules/pot { };

  potentials = callPackage ../development/python-modules/potentials { };

  potr = callPackage ../development/python-modules/potr { };

  power = callPackage ../development/python-modules/power { };

  powerline = callPackage ../development/python-modules/powerline { };

  powerline-mem-segment = callPackage ../development/python-modules/powerline-mem-segment { };

  pox = callPackage ../development/python-modules/pox { };

  poyo = callPackage ../development/python-modules/poyo { };

  ppft = callPackage ../development/python-modules/ppft { };

  pplpy = callPackage ../development/python-modules/pplpy { };

  pprintpp = callPackage ../development/python-modules/pprintpp { };

  pproxy = callPackage ../development/python-modules/pproxy { };

  ppscore = callPackage ../development/python-modules/ppscore { };

  pq = callPackage ../development/python-modules/pq { };

  prance = callPackage ../development/python-modules/prance { };

  prawcore = callPackage ../development/python-modules/prawcore { };

  praw = callPackage ../development/python-modules/praw { };

  prayer-times-calculator = callPackage ../development/python-modules/prayer-times-calculator { };

  precis-i18n = callPackage ../development/python-modules/precis-i18n { };

  prefixed = callPackage ../development/python-modules/prefixed { };

  pre-commit-hooks = callPackage ../development/python-modules/pre-commit-hooks { };

  preggy = callPackage ../development/python-modules/preggy { };

  premailer = callPackage ../development/python-modules/premailer { };

  preprocess-cancellation = callPackage ../development/python-modules/preprocess-cancellation { };

  preshed = callPackage ../development/python-modules/preshed { };

  pretend = callPackage ../development/python-modules/pretend { };

  prettytable = callPackage ../development/python-modules/prettytable { };

  primecountpy = callPackage ../development/python-modules/primecountpy { };

  primepy = callPackage ../development/python-modules/primepy { };

  primer3 = callPackage ../development/python-modules/primer3 { };

  priority = callPackage ../development/python-modules/priority { };

  prisma = callPackage ../development/python-modules/prisma { };

  prison = callPackage ../development/python-modules/prison { };

  proboscis = callPackage ../development/python-modules/proboscis { };

  process-tests = callPackage ../development/python-modules/process-tests { };

  procmon-parser = callPackage ../development/python-modules/procmon-parser { };

  proglog = callPackage ../development/python-modules/proglog { };

  progressbar2 = callPackage ../development/python-modules/progressbar2 { };

  progressbar33 = callPackage ../development/python-modules/progressbar33 { };

  progressbar = callPackage ../development/python-modules/progressbar { };

  progress = callPackage ../development/python-modules/progress { };

  prometheus-api-client = callPackage ../development/python-modules/prometheus-api-client { };

  prometheus-client = callPackage ../development/python-modules/prometheus-client { };

  prometheus-flask-exporter = callPackage ../development/python-modules/prometheus-flask-exporter { };

  prometrix = callPackage ../development/python-modules/prometrix { };

  promise = callPackage ../development/python-modules/promise { };

  prompt-toolkit = callPackage ../development/python-modules/prompt-toolkit { };

  prompthub-py = callPackage ../development/python-modules/prompthub-py { };

  property-manager = callPackage ../development/python-modules/property-manager { };

  protego = callPackage ../development/python-modules/protego { };

  proto-plus = callPackage ../development/python-modules/proto-plus { };

  # Protobuf 4.x
  protobuf = callPackage ../development/python-modules/protobuf {
    # If a protobuf upgrade causes many Python packages to fail, please pin it here to the previous version.
    protobuf = pkgs.protobuf;
  };

  # Protobuf 3.x
  protobuf3 = callPackage ../development/python-modules/protobuf/3.nix {
    protobuf = pkgs.protobuf3_20;
  };

  protobuf3-to-dict = callPackage ../development/python-modules/protobuf3-to-dict { };

  proton-client = callPackage ../development/python-modules/proton-client { };

  proton-core = callPackage ../development/python-modules/proton-core { };

  proton-keyring-linux = callPackage ../development/python-modules/proton-keyring-linux { };

  proton-keyring-linux-secretservice = callPackage ../development/python-modules/proton-keyring-linux-secretservice { };

  proton-vpn-api-core = callPackage ../development/python-modules/proton-vpn-api-core { };

  proton-vpn-connection = callPackage ../development/python-modules/proton-vpn-connection { };

  proton-vpn-killswitch = callPackage ../development/python-modules/proton-vpn-killswitch { };

  proton-vpn-killswitch-network-manager = callPackage ../development/python-modules/proton-vpn-killswitch-network-manager { };

  proton-vpn-logger = callPackage ../development/python-modules/proton-vpn-logger { };

  proton-vpn-network-manager = callPackage ../development/python-modules/proton-vpn-network-manager { };

  proton-vpn-network-manager-openvpn = callPackage ../development/python-modules/proton-vpn-network-manager-openvpn { };

  proton-vpn-session = callPackage ../development/python-modules/proton-vpn-session { };

  protonup-ng = callPackage ../development/python-modules/protonup-ng { };

  protonvpn-nm-lib = callPackage ../development/python-modules/protonvpn-nm-lib {
    pkgs-systemd = pkgs.systemd;
  };

  prov = callPackage ../development/python-modules/prov { };

  prox-tv = callPackage ../development/python-modules/prox-tv { };

  proxmoxer = callPackage ../development/python-modules/proxmoxer { };

  proxy-py = callPackage ../development/python-modules/proxy-py { };

  psautohint = callPackage ../development/python-modules/psautohint { };

  pscript = callPackage ../development/python-modules/pscript { };

  psd-tools = callPackage ../development/python-modules/psd-tools { };

  psutil = callPackage ../development/python-modules/psutil {
    stdenv = if pkgs.stdenv.isDarwin then pkgs.overrideSDK pkgs.stdenv "11.0" else pkgs.stdenv;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation IOKit;
  };

  psutil-home-assistant = callPackage ../development/python-modules/psutil-home-assistant { };

  psychrolib = callPackage ../development/python-modules/psychrolib { };

  psycopg = callPackage ../development/python-modules/psycopg { };

  psycopg2 = callPackage ../development/python-modules/psycopg2 { };

  psycopg2cffi = callPackage ../development/python-modules/psycopg2cffi { };

  psygnal = callPackage ../development/python-modules/psygnal { };

  ptable = callPackage ../development/python-modules/ptable { };

  ptest = callPackage ../development/python-modules/ptest { };

  ptpython = callPackage ../development/python-modules/ptpython { };

  ptyprocess = callPackage ../development/python-modules/ptyprocess { };

  publicsuffix2 = callPackage ../development/python-modules/publicsuffix2 { };

  publicsuffix = callPackage ../development/python-modules/publicsuffix { };

  publicsuffixlist = callPackage ../development/python-modules/publicsuffixlist { };

  pubnub = callPackage ../development/python-modules/pubnub { };

  pubnubsub-handler = callPackage ../development/python-modules/pubnubsub-handler { };

  pudb = callPackage ../development/python-modules/pudb { };

  pulp = callPackage ../development/python-modules/pulp { };

  pulsar-client = callPackage ../development/python-modules/pulsar-client { };

  pulsectl-asyncio = callPackage ../development/python-modules/pulsectl-asyncio { };

  pulsectl = callPackage ../development/python-modules/pulsectl { };

  pure-cdb = callPackage ../development/python-modules/pure-cdb { };

  pure-eval = callPackage ../development/python-modules/pure-eval { };

  pure-pcapy3 = callPackage ../development/python-modules/pure-pcapy3 { };

  purepng = callPackage ../development/python-modules/purepng { };

  pure-protobuf = callPackage ../development/python-modules/pure-protobuf { };

  pure-python-adb = callPackage ../development/python-modules/pure-python-adb { };

  pure-python-adb-homeassistant = callPackage ../development/python-modules/pure-python-adb-homeassistant { };

  puremagic = callPackage ../development/python-modules/puremagic { };

  purl = callPackage ../development/python-modules/purl { };

  push-receiver = callPackage ../development/python-modules/push-receiver { };

  pushbullet-py = callPackage ../development/python-modules/pushbullet-py { };

  pushover-complete = callPackage ../development/python-modules/pushover-complete { };

  pvextractor = callPackage ../development/python-modules/pvextractor { };

  pvlib = callPackage ../development/python-modules/pvlib { };

  pvo = callPackage ../development/python-modules/pvo { };

  pweave = callPackage ../development/python-modules/pweave { };

  pwlf = callPackage ../development/python-modules/pwlf { };

  pwntools = callPackage ../development/python-modules/pwntools {
    debugger = pkgs.gdb;
  };

  pxml = callPackage ../development/python-modules/pxml { };

  py-air-control = callPackage ../development/python-modules/py-air-control { };

  py-air-control-exporter = callPackage ../development/python-modules/py-air-control-exporter { };

  py-bip39-bindings = callPackage ../development/python-modules/py-bip39-bindings { };

  py-dmidecode = callPackage ../development/python-modules/py-dmidecode { };

  py-dormakaba-dkey = callPackage ../development/python-modules/py-dormakaba-dkey { };

  py-nightscout = callPackage ../development/python-modules/py-nightscout { };

  py-partiql-parser = callPackage ../development/python-modules/py-partiql-parser { };

  py-pdf-parser = callPackage ../development/python-modules/py-pdf-parser { };

  py-serializable = callPackage ../development/python-modules/py-serializable { };

  py-synologydsm-api = callPackage ../development/python-modules/py-synologydsm-api { };

  py-sneakers = callPackage ../development/python-modules/py-sneakers { };

  py-sr25519-bindings = callPackage ../development/python-modules/py-sr25519-bindings { };

  py-tes = callPackage ../development/python-modules/py-tes { };

  py-ubjson = callPackage ../development/python-modules/py-ubjson { };

  py-zabbix = callPackage ../development/python-modules/py-zabbix { };

  py17track = callPackage ../development/python-modules/py17track { };

  py2bit = callPackage ../development/python-modules/py2bit { };

  py3buddy = toPythonModule (callPackage ../development/python-modules/py3buddy { });

  py3exiv2 = callPackage ../development/python-modules/py3exiv2 { };

  py3langid = callPackage ../development/python-modules/py3langid { };

  py3nvml = callPackage ../development/python-modules/py3nvml { };

  py3rijndael = callPackage ../development/python-modules/py3rijndael { };

  py3status = callPackage ../development/python-modules/py3status { };

  py3to2 = callPackage ../development/python-modules/3to2 { };

  py4j = callPackage ../development/python-modules/py4j { };

  pyacaia-async = callPackage ../development/python-modules/pyacaia-async { };

  pyacoustid = callPackage ../development/python-modules/pyacoustid { };

  pyads = callPackage ../development/python-modules/pyads { };

  pyaes = callPackage ../development/python-modules/pyaes { };

  pyaftership = callPackage ../development/python-modules/pyaftership { };

  pyahocorasick = callPackage ../development/python-modules/pyahocorasick { };

  pyairnow = callPackage ../development/python-modules/pyairnow { };

  pyairvisual = callPackage ../development/python-modules/pyairvisual { };

  pyalgotrade = callPackage ../development/python-modules/pyalgotrade { };

  pyamg = callPackage ../development/python-modules/pyamg { };

  pyaml = callPackage ../development/python-modules/pyaml { };

  pyannotate = callPackage ../development/python-modules/pyannotate { };

  pyannote-audio = callPackage ../development/python-modules/pyannote-audio { };

  pyannote-pipeline = callPackage ../development/python-modules/pyannote-pipeline { };

  pyannote-metrics = callPackage ../development/python-modules/pyannote-metrics { };

  pyannote-database = callPackage ../development/python-modules/pyannote-database { };

  pyannote-core = callPackage ../development/python-modules/pyannote-core { };

  pyarlo = callPackage ../development/python-modules/pyarlo { };

  pyarr = callPackage ../development/python-modules/pyarr { };

  pyarrow = callPackage ../development/python-modules/pyarrow {
    inherit (pkgs) arrow-cpp cmake;
  };

  pyarrow-hotfix = callPackage ../development/python-modules/pyarrow-hotfix { };

  pyasn = callPackage ../development/python-modules/pyasn { };

  pyasn1 = callPackage ../development/python-modules/pyasn1 { };

  pyasn1-modules = callPackage ../development/python-modules/pyasn1-modules { };

  pyasuswrt = callPackage ../development/python-modules/pyasuswrt { };

  pyasyncore = callPackage ../development/python-modules/pyasyncore { };

  pyathena = callPackage ../development/python-modules/pyathena { };

  pyatmo = callPackage ../development/python-modules/pyatmo { };

  pyatspi = callPackage ../development/python-modules/pyatspi { };

  pyatv = callPackage ../development/python-modules/pyatv { };

  pyaudio = callPackage ../development/python-modules/pyaudio { };

  pyaussiebb = callPackage ../development/python-modules/pyaussiebb { };

  pyautogui = callPackage ../development/python-modules/pyautogui { };

  pyavm = callPackage ../development/python-modules/pyavm { };

  pyaxmlparser = callPackage ../development/python-modules/pyaxmlparser { };

  pybalboa = callPackage ../development/python-modules/pybalboa { };

  pybase64 = callPackage ../development/python-modules/pybase64 { };

  pybids = callPackage ../development/python-modules/pybids { };

  pybigwig = callPackage ../development/python-modules/pybigwig { };

  pybind11 = callPackage ../development/python-modules/pybind11 { };

  pybindgen = callPackage ../development/python-modules/pybindgen { };

  pyblackbird = callPackage ../development/python-modules/pyblackbird { };

  pybloom-live = callPackage ../development/python-modules/pybloom-live { };

  pybluez = callPackage ../development/python-modules/pybluez {
    inherit (pkgs) bluez;
  };

  pybotvac = callPackage ../development/python-modules/pybotvac { };

  pybox2d = callPackage ../development/python-modules/pybox2d { };

  pybravia = callPackage ../development/python-modules/pybravia { };

  pybrowsers = callPackage ../development/python-modules/pybrowsers { };

  pybrowserid = callPackage ../development/python-modules/pybrowserid { };

  pybtex = callPackage ../development/python-modules/pybtex { };

  pybtex-docutils = callPackage ../development/python-modules/pybtex-docutils { };

  pybullet = callPackage ../development/python-modules/pybullet { };

  pycairo = callPackage ../development/python-modules/pycairo {
    inherit (pkgs.buildPackages) meson;
  };

  py = callPackage ../development/python-modules/py { };

  pycangjie = callPackage ../development/python-modules/pycangjie { };

  pycapnp = callPackage ../development/python-modules/pycapnp { };

  pycaption = callPackage ../development/python-modules/pycaption { };

  pycares = callPackage ../development/python-modules/pycares { };

  pycarwings2 = callPackage ../development/python-modules/pycarwings2 { };

  pycatch22 = callPackage ../development/python-modules/pycatch22 { };

  pycategories = callPackage ../development/python-modules/pycategories { };

  pycddl = callPackage ../development/python-modules/pycddl { };

  pycdio = callPackage ../development/python-modules/pycdio { };

  pycec = callPackage ../development/python-modules/pycec { };

  pycep-parser = callPackage ../development/python-modules/pycep-parser { };

  pycfdns = callPackage ../development/python-modules/pycfdns { };

  pycflow2dot = callPackage ../development/python-modules/pycflow2dot {
    inherit (pkgs) graphviz;
  };

  pycfmodel = callPackage ../development/python-modules/pycfmodel { };

  pychannels = callPackage ../development/python-modules/pychannels { };

  pychart = callPackage ../development/python-modules/pychart { };

  pychm = callPackage ../development/python-modules/pychm { };

  pychromecast = callPackage ../development/python-modules/pychromecast { };

  pyclimacell = callPackage ../development/python-modules/pyclimacell { };

  pyclip = callPackage ../development/python-modules/pyclip { };

  pyclipper = callPackage ../development/python-modules/pyclipper { };

  pycm = callPackage ../development/python-modules/pycm { };

  pycmarkgfm = callPackage ../development/python-modules/pycmarkgfm { };

  pycocotools = callPackage ../development/python-modules/pycocotools { };

  pycodestyle = callPackage ../development/python-modules/pycodestyle { };

  pycognito = callPackage ../development/python-modules/pycognito { };

  pycoin = callPackage ../development/python-modules/pycoin { };

  pycollada = callPackage ../development/python-modules/pycollada { };

  pycomfoconnect = callPackage ../development/python-modules/pycomfoconnect { };

  pycontracts = callPackage ../development/python-modules/pycontracts { };

  pycosat = callPackage ../development/python-modules/pycosat { };

  pycotap = callPackage ../development/python-modules/pycotap { };

  pycountry = callPackage ../development/python-modules/pycountry { };

  pycparser = callPackage ../development/python-modules/pycparser { };

  py-canary = callPackage ../development/python-modules/py-canary { };

  py-cid = callPackage ../development/python-modules/py-cid { };

  py-cpuinfo = callPackage ../development/python-modules/py-cpuinfo { };

  pycardano = callPackage ../development/python-modules/pycardano { };

  pycrc = callPackage ../development/python-modules/pycrc { };

  pycritty = callPackage ../development/python-modules/pycritty { };

  pycron = callPackage ../development/python-modules/pycron { };

  pycrypto = callPackage ../development/python-modules/pycrypto { };

  pycryptodome = callPackage ../development/python-modules/pycryptodome { };

  pycryptodomex = callPackage ../development/python-modules/pycryptodomex { };

  pycsdr = callPackage ../development/python-modules/pycsdr { };

  pyct = callPackage ../development/python-modules/pyct { };

  pyctr = callPackage ../development/python-modules/pyctr { };

  pycuda = callPackage ../development/python-modules/pycuda {
    inherit (pkgs.stdenv) mkDerivation;
  };

  pycups = callPackage ../development/python-modules/pycups { };

  pycurl = callPackage ../development/python-modules/pycurl { };

  pycxx = callPackage ../development/python-modules/pycxx { };

  pycyphal = callPackage ../development/python-modules/pycyphal { };

  pydaikin = callPackage ../development/python-modules/pydaikin { };

  pydal = callPackage ../development/python-modules/pydal { };

  pydanfossair = callPackage ../development/python-modules/pydanfossair { };

  pydantic = callPackage ../development/python-modules/pydantic { };

  pydantic_1 = callPackage ../development/python-modules/pydantic/1.nix { };

  pydantic-compat = callPackage ../development/python-modules/pydantic-compat { };

  pydantic-core = callPackage ../development/python-modules/pydantic-core { };

  pydantic-extra-types = callPackage ../development/python-modules/pydantic-extra-types { };

  pydantic-scim = callPackage ../development/python-modules/pydantic-scim { };

  pydantic-settings = callPackage ../development/python-modules/pydantic-settings { };

  pydash = callPackage ../development/python-modules/pydash { };

  pydata-google-auth = callPackage ../development/python-modules/pydata-google-auth { };

  pydata-sphinx-theme = callPackage ../development/python-modules/pydata-sphinx-theme { };

  pydateinfer = callPackage ../development/python-modules/pydateinfer { };

  pydbus = callPackage ../development/python-modules/pydbus { };

  pydeck = callPackage ../development/python-modules/pydeck { };

  pydeconz = callPackage ../development/python-modules/pydeconz { };

  pydelijn = callPackage ../development/python-modules/pydelijn { };

  pydenticon = callPackage ../development/python-modules/pydenticon { };

  pydeps = callPackage ../development/python-modules/pydeps {
    inherit (pkgs) graphviz;
  };

  pydes = callPackage ../development/python-modules/pydes { };

  py-desmume = callPackage ../development/python-modules/py-desmume {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  pydevccu = callPackage ../development/python-modules/pydevccu { };

  pydevd = callPackage ../development/python-modules/pydevd { };

  pydevtool = callPackage ../development/python-modules/pydevtool { };

  pydexcom = callPackage ../development/python-modules/pydexcom { };

  pydicom = callPackage ../development/python-modules/pydicom { };

  pydicom-seg = callPackage ../development/python-modules/pydicom-seg { };

  pydigiham = callPackage ../development/python-modules/pydigiham { };

  pydiscourse = callPackage ../development/python-modules/pydiscourse { };

  pydiscovergy = callPackage ../development/python-modules/pydiscovergy { };

  pydispatcher = callPackage ../development/python-modules/pydispatcher { };

  pydmd = callPackage ../development/python-modules/pydmd { };

  pydns = callPackage ../development/python-modules/py3dns { };

  pydocstyle = callPackage ../development/python-modules/pydocstyle { };

  pydocumentdb = callPackage ../development/python-modules/pydocumentdb { };

  pydoods = callPackage ../development/python-modules/pydoods { };

  pydoe = callPackage ../development/python-modules/pydoe { };

  pydot = callPackage ../development/python-modules/pydot {
    inherit (pkgs) graphviz;
  };

  pydrawise = callPackage ../development/python-modules/pydrawise { };

  pydrive2 = callPackage ../development/python-modules/pydrive2 { };

  pydroid-ipcam = callPackage ../development/python-modules/pydroid-ipcam  { };

  pydruid = callPackage ../development/python-modules/pydruid { };

  pydsdl = callPackage ../development/python-modules/pydsdl { };

  pydub = callPackage ../development/python-modules/pydub { };

  pyduke-energy = callPackage ../development/python-modules/pyduke-energy { };

  pyduotecno = callPackage ../development/python-modules/pyduotecno { };

  pydy = callPackage ../development/python-modules/pydy { };

  pydyf = callPackage ../development/python-modules/pydyf { };

  pyebus = callPackage ../development/python-modules/pyebus { };

  pyechonest = callPackage ../development/python-modules/pyechonest { };

  pyeclib = callPackage ../development/python-modules/pyeclib { };

  pyecoforest = callPackage ../development/python-modules/pyecoforest { };

  pyeconet = callPackage ../development/python-modules/pyeconet { };

  pyecowitt = callPackage ../development/python-modules/pyecowitt { };

  pyedimax = callPackage ../development/python-modules/pyedimax { };

  pyee = callPackage ../development/python-modules/pyee { };

  pyefergy = callPackage ../development/python-modules/pyefergy { };

  pyeight = callPackage ../development/python-modules/pyeight { };

  pyelftools = callPackage ../development/python-modules/pyelftools { };

  pyemby = callPackage ../development/python-modules/pyemby { };

  pyemd = callPackage ../development/python-modules/pyemd { };

  pyemvue = callPackage ../development/python-modules/pyemvue { };

  pyenchant = callPackage ../development/python-modules/pyenchant {
    inherit (pkgs) enchant2;
  };

  pyenphase = callPackage ../development/python-modules/pyenphase { };

  pyenvisalink = callPackage ../development/python-modules/pyenvisalink { };

  pyephember = callPackage ../development/python-modules/pyephember { };

  pyepsg = callPackage ../development/python-modules/pyepsg { };

  pyerfa = callPackage ../development/python-modules/pyerfa { };

  pyevmasm = callPackage ../development/python-modules/pyevmasm { };

  pyevilgenius = callPackage ../development/python-modules/pyevilgenius { };

  pyexcel = callPackage ../development/python-modules/pyexcel { };

  pyexcel-io = callPackage ../development/python-modules/pyexcel-io { };

  pyexcel-ods = callPackage ../development/python-modules/pyexcel-ods { };

  pyexcel-xls = callPackage ../development/python-modules/pyexcel-xls { };

  pyexiftool = callPackage ../development/python-modules/pyexiftool { };

  pyexploitdb = callPackage ../development/python-modules/pyexploitdb { };

  pyezviz = callPackage ../development/python-modules/pyezviz { };

  pyface = callPackage ../development/python-modules/pyface { };

  pyfaidx = callPackage ../development/python-modules/pyfaidx { };

  pyfakefs = callPackage ../development/python-modules/pyfakefs { };

  pyfakewebcam = callPackage ../development/python-modules/pyfakewebcam { };

  pyfantom = callPackage ../development/python-modules/pyfantom { };

  pyfcm = callPackage ../development/python-modules/pyfcm { };

  pyfftw = callPackage ../development/python-modules/pyfftw { };

  pyfido = callPackage ../development/python-modules/pyfido { };

  pyfiglet = callPackage ../development/python-modules/pyfiglet { };

  pyfnip = callPackage ../development/python-modules/pyfnip { };

  pyflakes = callPackage ../development/python-modules/pyflakes { };

  pyflic = callPackage ../development/python-modules/pyflic { };

  pyflume = callPackage ../development/python-modules/pyflume { };

  pyfma = callPackage ../development/python-modules/pyfma { };

  pyfribidi = callPackage ../development/python-modules/pyfribidi { };

  pyfritzhome = callPackage ../development/python-modules/pyfritzhome { };

  pyfronius = callPackage ../development/python-modules/pyfronius { };

  pyftdi = callPackage ../development/python-modules/pyftdi { };

  pyftgl = callPackage ../development/python-modules/pyftgl { };

  pyftpdlib = callPackage ../development/python-modules/pyftpdlib { };

  pyfttt = callPackage ../development/python-modules/pyfttt { };

  pyfume = callPackage ../development/python-modules/pyfume { };

  pyfuse3 = callPackage ../development/python-modules/pyfuse3 { };

  pyfxa = callPackage ../development/python-modules/pyfxa { };

  pyfzf = callPackage ../development/python-modules/pyfzf {
    inherit (pkgs) fzf;
  };

  pygal = callPackage ../development/python-modules/pygal { };

  pygame = callPackage ../development/python-modules/pygame {
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit;
    SDL2_image = pkgs.SDL2_image_2_0;
  };

  pygame-sdl2 = callPackage ../development/python-modules/pygame-sdl2 { };

  pygame-gui = callPackage ../development/python-modules/pygame-gui { };

  pygatt = callPackage ../development/python-modules/pygatt { };

  pygccxml = callPackage ../development/python-modules/pygccxml { };

  pygdbmi = callPackage ../development/python-modules/pygdbmi { };

  pygeoip = callPackage ../development/python-modules/pygeoip { };

  pygeos = callPackage ../development/python-modules/pygeos { };

  pygetwindow = callPackage ../development/python-modules/pygetwindow { };

  pygit2 = callPackage ../development/python-modules/pygit2 { };

  pygitguardian = callPackage ../development/python-modules/pygitguardian { };

  pygithub = callPackage ../development/python-modules/pygithub { };

  pyglet = callPackage ../development/python-modules/pyglet { };

  pyglm = callPackage ../development/python-modules/pyglm { };

  pygls = callPackage ../development/python-modules/pygls { };

  pygltflib = callPackage ../development/python-modules/pygltflib { };

  pygmars = callPackage ../development/python-modules/pygmars { };

  pygments-better-html = callPackage ../development/python-modules/pygments-better-html { };

  pygments = callPackage ../development/python-modules/pygments { };

  pygments-markdown-lexer = callPackage ../development/python-modules/pygments-markdown-lexer { };

  pygmo = callPackage ../development/python-modules/pygmo { };

  pygmt = callPackage ../development/python-modules/pygmt { };

  pygobject3 = callPackage ../development/python-modules/pygobject/3.nix {
    # inherit (pkgs) meson won't work because it won't be spliced
    inherit (pkgs.buildPackages) meson;
  };

  pygobject-stubs = callPackage ../development/python-modules/pygobject-stubs { };

  pygogo = callPackage ../development/python-modules/pygogo { };

  pygpgme = callPackage ../development/python-modules/pygpgme { };

  pygraphviz = callPackage ../development/python-modules/pygraphviz {
    inherit (pkgs) graphviz;
  };

  pygreat = callPackage ../development/python-modules/pygreat { };

  pygrok = callPackage ../development/python-modules/pygrok { };

  pygsl = callPackage ../development/python-modules/pygsl {
    inherit (pkgs) gsl swig;
  };

  pygtfs = callPackage ../development/python-modules/pygtfs { };

  pygtail = callPackage ../development/python-modules/pygtail { };

  pygtkspellcheck = callPackage ../development/python-modules/pygtkspellcheck { };

  pygtrie = callPackage ../development/python-modules/pygtrie { };

  pyhamcrest = callPackage ../development/python-modules/pyhamcrest { };

  pyhanko = callPackage ../development/python-modules/pyhanko { };

  pyhanko-certvalidator = callPackage ../development/python-modules/pyhanko-certvalidator { };

  pyhaversion = callPackage ../development/python-modules/pyhaversion { };

  pyhcl = callPackage ../development/python-modules/pyhcl { };

  pyhocon = callPackage ../development/python-modules/pyhocon { };

  pyhomematic = callPackage ../development/python-modules/pyhomematic { };

  pyhomepilot = callPackage ../development/python-modules/pyhomepilot { };

  pyhomeworks = callPackage ../development/python-modules/pyhomeworks { };

  pyheif = callPackage ../development/python-modules/pyheif { };

  pyi2cflash = callPackage ../development/python-modules/pyi2cflash { };

  pyialarm = callPackage ../development/python-modules/pyialarm { };

  pyicloud = callPackage ../development/python-modules/pyicloud { };

  pyicu = callPackage ../development/python-modules/pyicu { };

  pyimpfuzzy = callPackage ../development/python-modules/pyimpfuzzy {
    inherit (pkgs) ssdeep;
  };

  pyinotify = callPackage ../development/python-modules/pyinotify { };

  pyinputevent = callPackage ../development/python-modules/pyinputevent { };

  pyinsteon = callPackage ../development/python-modules/pyinsteon { };

  pyinstrument = callPackage ../development/python-modules/pyinstrument { };

  pyintesishome = callPackage ../development/python-modules/pyintesishome { };

  pyipma = callPackage ../development/python-modules/pyipma { };

  pyipp = callPackage ../development/python-modules/pyipp { };

  pyipv8 = callPackage ../development/python-modules/pyipv8 { };

  pyiqvia = callPackage ../development/python-modules/pyiqvia { };

  pyisbn = callPackage ../development/python-modules/pyisbn { };

  pyjet = callPackage ../development/python-modules/pyjet { };

  pyjks = callPackage ../development/python-modules/pyjks { };

  pyjnius = callPackage ../development/python-modules/pyjnius { };

  pyjsparser = callPackage ../development/python-modules/pyjsparser { };

  pyjwkest = callPackage ../development/python-modules/pyjwkest { };

  pyjwt = callPackage ../development/python-modules/pyjwt { };

  pykakasi = callPackage ../development/python-modules/pykakasi { };

  pykaleidescape = callPackage ../development/python-modules/pykaleidescape { };

  pykalman = callPackage ../development/python-modules/pykalman { };

  pykdl = callPackage ../development/python-modules/pykdl { };

  pykdtree = callPackage ../development/python-modules/pykdtree {
    inherit (pkgs.llvmPackages) openmp;
  };

  pykeepass = callPackage ../development/python-modules/pykeepass { };

  pykerberos = callPackage ../development/python-modules/pykerberos { };

  pykeyatome = callPackage ../development/python-modules/pykeyatome { };

  pykira = callPackage ../development/python-modules/pykira { };

  pykka = callPackage ../development/python-modules/pykka { };

  pykmtronic = callPackage ../development/python-modules/pykmtronic { };

  pykodi = callPackage ../development/python-modules/pykodi { };

  pykoplenti = callPackage ../development/python-modules/pykoplenti { };

  pykostalpiko = callPackage ../development/python-modules/pykostalpiko { };

  pykulersky = callPackage ../development/python-modules/pykulersky { };

  pykwalify = callPackage ../development/python-modules/pykwalify { };

  pykwb = callPackage ../development/python-modules/pykwb { };

  pylacrosse = callPackage ../development/python-modules/pylacrosse { };

  pylacus = callPackage ../development/python-modules/pylacus { };

  pylama = callPackage ../development/python-modules/pylama { };

  pylast = callPackage ../development/python-modules/pylast { };

  pylatex = callPackage ../development/python-modules/pylatex { };

  pylatexenc = callPackage ../development/python-modules/pylatexenc { };

  pylaunches = callPackage ../development/python-modules/pylaunches { };

  pyld = callPackage ../development/python-modules/pyld { };

  pyleri = callPackage ../development/python-modules/pyleri { };

  pylev = callPackage ../development/python-modules/pylev { };

  pylgnetcast = callPackage ../development/python-modules/pylgnetcast { };

  pylibacl = callPackage ../development/python-modules/pylibacl { };

  pylibconfig2 = callPackage ../development/python-modules/pylibconfig2 { };

  pylibdmtx = callPackage ../development/python-modules/pylibdmtx { };

  pylibftdi = callPackage ../development/python-modules/pylibftdi {
    inherit (pkgs) libusb1;
  };

  pylibjpeg = callPackage ../development/python-modules/pylibjpeg { };

  pylibjpeg-libjpeg = callPackage ../development/python-modules/pylibjpeg-libjpeg { };

  pyliblo = callPackage ../development/python-modules/pyliblo { };

  pylibmc = callPackage ../development/python-modules/pylibmc { };

  pylink-square = callPackage ../development/python-modules/pylink-square { };

  pylint = callPackage ../development/python-modules/pylint { };

  pylint-celery = callPackage ../development/python-modules/pylint-celery { };

  pylint-django = callPackage ../development/python-modules/pylint-django { };

  pylint-flask = callPackage ../development/python-modules/pylint-flask { };

  pylint-plugin-utils = callPackage ../development/python-modules/pylint-plugin-utils { };

  pylint-venv = callPackage ../development/python-modules/pylint-venv { };

  pylion = callPackage ../development/python-modules/pylion { };

  pylitterbot = callPackage ../development/python-modules/pylitterbot { };

  py-libzfs = callPackage ../development/python-modules/py-libzfs { };

  py-lru-cache = callPackage ../development/python-modules/py-lru-cache { };

  pylnk3 = callPackage ../development/python-modules/pylnk3 { };

  pylru = callPackage ../development/python-modules/pylru { };

  pylsqpack = callPackage ../development/python-modules/pylsqpack { };

  pyls-flake8 = callPackage ../development/python-modules/pyls-flake8 { };

  pyls-isort = callPackage ../development/python-modules/pyls-isort { };

  pyls-memestra = callPackage ../development/python-modules/pyls-memestra { };

  pyls-spyder = callPackage ../development/python-modules/pyls-spyder { };

  pylsp-mypy = callPackage ../development/python-modules/pylsp-mypy { };

  pylsp-rope = callPackage ../development/python-modules/pylsp-rope { };

  pylpsd = callPackage ../development/python-modules/pylpsd { };

  pylti = callPackage ../development/python-modules/pylti { };

  pylutron = callPackage ../development/python-modules/pylutron { };

  pylutron-caseta = callPackage ../development/python-modules/pylutron-caseta { };

  pylyrics = callPackage ../development/python-modules/pylyrics { };

  pylxd = callPackage ../development/python-modules/pylxd { };

  pylzma = callPackage ../development/python-modules/pylzma { };

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

  pymdstat = callPackage ../development/python-modules/pymdstat { };

  pymdown-extensions = callPackage ../development/python-modules/pymdown-extensions { };

  pymediainfo = callPackage ../development/python-modules/pymediainfo { };

  pymediaroom = callPackage ../development/python-modules/pymediaroom { };

  pymedio = callPackage ../development/python-modules/pymedio { };

  pymeeus = callPackage ../development/python-modules/pymeeus { };

  pymelcloud = callPackage ../development/python-modules/pymelcloud { };

  pymemcache = callPackage ../development/python-modules/pymemcache { };

  pymemoize = callPackage ../development/python-modules/pymemoize { };

  pyment = callPackage ../development/python-modules/pyment { };

  pymetar = callPackage ../development/python-modules/pymetar { };

  pymeteireann = callPackage ../development/python-modules/pymeteireann { };

  pymeteoclimatic = callPackage ../development/python-modules/pymeteoclimatic { };

  pymetno = callPackage ../development/python-modules/pymetno { };

  pymicrobot = callPackage ../development/python-modules/pymicrobot { };

  pymiele = callPackage ../development/python-modules/pymiele { };

  pymilter = callPackage ../development/python-modules/pymilter { };

  pymilvus = callPackage ../development/python-modules/pymilvus { };

  pymitv = callPackage ../development/python-modules/pymitv { };

  pymfy = callPackage ../development/python-modules/pymfy { };

  pymodbus = callPackage ../development/python-modules/pymodbus { };

  pymongo = callPackage ../development/python-modules/pymongo { };

  pymongo-inmemory = callPackage ../development/python-modules/pymongo-inmemory { };

  pymoo = callPackage ../development/python-modules/pymoo { };

  pymorphy2 = callPackage ../development/python-modules/pymorphy2 { };

  pymorphy2-dicts-ru = callPackage ../development/python-modules/pymorphy2/dicts-ru.nix { };

  pymorphy3 = callPackage ../development/python-modules/pymorphy3 { };

  pymorphy3-dicts-ru = callPackage ../development/python-modules/pymorphy3/dicts-ru.nix { };

  pymorphy3-dicts-uk = callPackage ../development/python-modules/pymorphy3/dicts-uk.nix { };

  pympler = callPackage ../development/python-modules/pympler { };

  pymsgbox = callPackage ../development/python-modules/pymsgbox { };

  pymsteams = callPackage ../development/python-modules/pymsteams { };

  py-multiaddr = callPackage ../development/python-modules/py-multiaddr { };

  py-multibase = callPackage ../development/python-modules/py-multibase { };

  py-multicodec = callPackage ../development/python-modules/py-multicodec { };

  py-multihash = callPackage ../development/python-modules/py-multihash { };

  pymumble = callPackage ../development/python-modules/pymumble { };

  pymunk = callPackage ../development/python-modules/pymunk {
    inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices;
  };

  pymupdf = callPackage ../development/python-modules/pymupdf { };

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

  pync = callPackage ../development/python-modules/pync {
    inherit (pkgs) which;
  };

  pynello = callPackage ../development/python-modules/pynello { };

  pynest2d = callPackage ../development/python-modules/pynest2d { };

  pynetbox = callPackage ../development/python-modules/pynetbox { };

  pynetdicom = callPackage ../development/python-modules/pynetdicom { };

  pynetgear = callPackage ../development/python-modules/pynetgear { };

  pynina = callPackage ../development/python-modules/pynina { };

  pynisher = callPackage ../development/python-modules/pynisher { };

  pynmea2 = callPackage ../development/python-modules/pynmea2 { };

  pynput = callPackage ../development/python-modules/pynput { };

  pynrrd = callPackage ../development/python-modules/pynrrd { };

  pynvim = callPackage ../development/python-modules/pynvim { };

  pynvim-pp = callPackage ../development/python-modules/pynvim-pp { };

  pynvml = callPackage ../development/python-modules/pynvml { };

  pynzb = callPackage ../development/python-modules/pynzb { };

  pyobihai = callPackage ../development/python-modules/pyobihai { };

  pyocd = callPackage ../development/python-modules/pyocd { };

  pyocd-pemicro = callPackage ../development/python-modules/pyocd-pemicro { };

  pyocr = callPackage ../development/python-modules/pyocr {
    tesseract = pkgs.tesseract4;
  };

  pyoctoprintapi = callPackage ../development/python-modules/pyoctoprintapi { };

  pyodbc = callPackage ../development/python-modules/pyodbc { };

  pyogg = callPackage ../development/python-modules/pyogg { };

  pyombi = callPackage ../development/python-modules/pyombi { };

  pyomo = callPackage ../development/python-modules/pyomo { };

  pypng = callPackage ../development/python-modules/pypng { };

  phonemizer = callPackage ../development/python-modules/phonemizer { };

  pyopencl = callPackage ../development/python-modules/pyopencl {
    mesa_drivers = pkgs.mesa.drivers;
  };

  pyopengl = callPackage ../development/python-modules/pyopengl { };

  pyopengl-accelerate = callPackage ../development/python-modules/pyopengl-accelerate { };

  pyopenssl = callPackage ../development/python-modules/pyopenssl { };

  pyopenuv = callPackage ../development/python-modules/pyopenuv { };

  pyopnsense = callPackage ../development/python-modules/pyopnsense { };

  pyoppleio = callPackage ../development/python-modules/pyoppleio { };

  pyosf = callPackage ../development/python-modules/pyosf { };

  pyosmium = callPackage ../development/python-modules/pyosmium {
    inherit (pkgs) lz4;
  };

  pyosohotwaterapi = callPackage ../development/python-modules/pyosohotwaterapi { };

  pyotgw = callPackage ../development/python-modules/pyotgw { };

  pyotp = callPackage ../development/python-modules/pyotp { };

  pyowm = callPackage ../development/python-modules/pyowm { };

  pypamtest = toPythonModule (pkgs.libpam-wrapper.override {
    enablePython = true;
    inherit python;
  });

  pypandoc = callPackage ../development/python-modules/pypandoc { };

  pyparser = callPackage ../development/python-modules/pyparser { };

  pyparsing = callPackage ../development/python-modules/pyparsing { };

  pyparted = callPackage ../development/python-modules/pyparted { };

  pypass = callPackage ../development/python-modules/pypass { };

  pypblib = callPackage ../development/python-modules/pypblib { };

  pypca = callPackage ../development/python-modules/pypca { };

  pypcap = callPackage ../development/python-modules/pypcap {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  pypck = callPackage ../development/python-modules/pypck { };

  pypdf = callPackage ../development/python-modules/pypdf { };

  pypdf2 = callPackage ../development/python-modules/pypdf2 { };

  pypdf3 = callPackage ../development/python-modules/pypdf3 { };

  pypeg2 = callPackage ../development/python-modules/pypeg2 { };

  pyperclip = callPackage ../development/python-modules/pyperclip { };

  pyperscan = callPackage ../development/python-modules/pyperscan { };

  pyperf = callPackage ../development/python-modules/pyperf { };

  pyphen = callPackage ../development/python-modules/pyphen { };

  pyphotonfile = callPackage ../development/python-modules/pyphotonfile { };

  pypika = callPackage ../development/python-modules/pypika { };

  pypillowfight = callPackage ../development/python-modules/pypillowfight { };

  pypinyin = callPackage ../development/python-modules/pypinyin { };

  pypiserver = callPackage ../development/python-modules/pypiserver { };

  pypitoken = callPackage ../development/python-modules/pypitoken { };

  pyplaato  = callPackage ../development/python-modules/pyplaato { };

  pyplatec = callPackage ../development/python-modules/pyplatec { };

  pyppeteer = callPackage ../development/python-modules/pyppeteer { };

  pypresence = callPackage ../development/python-modules/pypresence { };

  pyprind = callPackage ../development/python-modules/pyprind { };

  pyprof2calltree = callPackage ../development/python-modules/pyprof2calltree { };

  pyproj = callPackage ../development/python-modules/pyproj { };

  pyproject-metadata = callPackage ../development/python-modules/pyproject-metadata { };

  pyprosegur = callPackage ../development/python-modules/pyprosegur { };

  pyprusalink = callPackage ../development/python-modules/pyprusalink { };

  pyptlib = callPackage ../development/python-modules/pyptlib { };

  pypubsub = callPackage ../development/python-modules/pypubsub { };

  pypugjs = callPackage ../development/python-modules/pypugjs { };

  pypykatz = callPackage ../development/python-modules/pypykatz { };

  pypytools = callPackage ../development/python-modules/pypytools { };

  pyqldb = callPackage ../development/python-modules/pyqldb { };

  pyqrcode = callPackage ../development/python-modules/pyqrcode { };

  pyqt-builder = callPackage ../development/python-modules/pyqt-builder { };

  pyqt5 = callPackage ../development/python-modules/pyqt/5.x.nix { };

  pyqt5-stubs = callPackage ../development/python-modules/pyqt5-stubs { };

  pyqt5-sip = callPackage ../development/python-modules/pyqt/sip.nix { };

  pyqt5-multimedia = self.pyqt5.override {
    withMultimedia = true;
  };

  /*
    `pyqt5-webkit` should not be used by python libraries in
    pkgs/development/python-modules/*. Putting this attribute in
    `propagatedBuildInputs` may cause collisions.
  */
  pyqt5-webkit = self.pyqt5.override {
    withWebKit = true;
  };

  pyqt6 = callPackage ../development/python-modules/pyqt/6.x.nix { };

  pyqt6-charts = callPackage ../development/python-modules/pyqt6-charts { };

  pyqt6-sip = callPackage ../development/python-modules/pyqt/pyqt6-sip.nix { };

  pyqt6-webengine = callPackage ../development/python-modules/pyqt6-webengine { };

  pyqt3d = pkgs.libsForQt5.callPackage ../development/python-modules/pyqt3d {
    inherit (self) buildPythonPackage pyqt5 pyqt-builder python pythonOlder
      setuptools sip;
  };

  pyqtchart = pkgs.libsForQt5.callPackage ../development/python-modules/pyqtchart {
    inherit (self) buildPythonPackage pyqt5 pyqt-builder python pythonOlder
      setuptools sip;
  };

  pyqtdatavisualization = pkgs.libsForQt5.callPackage ../development/python-modules/pyqtdatavisualization {
    inherit (self) buildPythonPackage pyqt5 pyqt-builder python pythonOlder
      setuptools sip;
  };

  pyqtgraph = callPackage ../development/python-modules/pyqtgraph { };

  pyqtwebengine = pkgs.libsForQt5.callPackage ../development/python-modules/pyqtwebengine {
    pythonPackages = self;
  };

  pyquery = callPackage ../development/python-modules/pyquery { };

  pyquaternion = callPackage ../development/python-modules/pyquaternion { };

  pyquil = callPackage ../development/python-modules/pyquil { };

  pyqvrpro = callPackage ../development/python-modules/pyqvrpro { };

  pyqwikswitch = callPackage ../development/python-modules/pyqwikswitch { };

  pyrabbit2 = callPackage ../development/python-modules/pyrabbit2 { };

  pyrad = callPackage ../development/python-modules/pyrad { };

  pyradiomics = callPackage ../development/python-modules/pyradiomics { };

  pyradios = callPackage ../development/python-modules/pyradios { };

  pyrainbird = callPackage ../development/python-modules/pyrainbird { };

  pyramid-beaker = callPackage ../development/python-modules/pyramid-beaker { };

  pyramid = callPackage ../development/python-modules/pyramid { };

  pyramid-chameleon = callPackage ../development/python-modules/pyramid-chameleon { };

  pyramid-exclog = callPackage ../development/python-modules/pyramid-exclog { };

  pyramid-jinja2 = callPackage ../development/python-modules/pyramid-jinja2 { };

  pyramid-mako = callPackage ../development/python-modules/pyramid-mako { };

  pyramid-multiauth = callPackage ../development/python-modules/pyramid-multiauth { };

  pyrate-limiter = callPackage ../development/python-modules/pyrate-limiter { };

  pyreaderwriterlock = callPackage ../development/python-modules/pyreaderwriterlock { };

  pyreadstat = callPackage ../development/python-modules/pyreadstat {
    inherit (pkgs.darwin) libiconv;
  };

  pyrealsense2 = toPythonModule (pkgs.librealsense.override {
    enablePython = true;
    pythonPackages = self;
  });

  pyrealsense2WithCuda = toPythonModule (pkgs.librealsenseWithCuda.override {
    cudaSupport = true;
    enablePython = true;
    pythonPackages = self;
  });

  pyrealsense2WithoutCuda = toPythonModule (pkgs.librealsenseWithoutCuda.override {
    enablePython = true;
    pythonPackages = self;
  });

  pyrect = callPackage ../development/python-modules/pyrect { };

  pyregion = callPackage ../development/python-modules/pyregion { };

  pyric = callPackage ../development/python-modules/pyric { };

  pyrisco = callPackage ../development/python-modules/pyrisco { };

  pyrituals = callPackage ../development/python-modules/pyrituals { };

  pyrfc3339 = callPackage ../development/python-modules/pyrfc3339 { };

  pyrmvtransport = callPackage ../development/python-modules/pyrmvtransport { };

  pyro4 = callPackage ../development/python-modules/pyro4 { };

  pyro5 = callPackage ../development/python-modules/pyro5 { };

  pyroma = callPackage ../development/python-modules/pyroma { };

  pyro-api = callPackage ../development/python-modules/pyro-api { };

  pyro-ppl = callPackage ../development/python-modules/pyro-ppl { };

  pyroute2 = callPackage ../development/python-modules/pyroute2 { };

  pyrr = callPackage ../development/python-modules/pyrr { };

  pyrsistent = callPackage ../development/python-modules/pyrsistent { };

  pyrss2gen = callPackage ../development/python-modules/pyrss2gen { };

  pyrtlsdr = callPackage ../development/python-modules/pyrtlsdr { };

  pysaj = callPackage ../development/python-modules/pysaj { };

  pysam = callPackage ../development/python-modules/pysam { };

  pysaml2 = callPackage ../development/python-modules/pysaml2 {
    inherit (pkgs) xmlsec;
  };

  pysatochip = callPackage ../development/python-modules/pysatochip { };

  pysc2 = callPackage ../development/python-modules/pysc2 { };

  pyscard = callPackage ../development/python-modules/pyscard {
    inherit (pkgs.darwin.apple_sdk.frameworks) PCSC;
  };

  pyscaffold = callPackage ../development/python-modules/pyscaffold { };

  pyscaffoldext-cookiecutter = callPackage ../development/python-modules/pyscaffoldext-cookiecutter { };

  pyscaffoldext-custom-extension = callPackage ../development/python-modules/pyscaffoldext-custom-extension { };

  pyscaffoldext-django = callPackage ../development/python-modules/pyscaffoldext-django { };

  pyscaffoldext-dsproject = callPackage ../development/python-modules/pyscaffoldext-dsproject { };

  pyscaffoldext-markdown = callPackage ../development/python-modules/pyscaffoldext-markdown { };

  pyscaffoldext-travis = callPackage ../development/python-modules/pyscaffoldext-travis { };

  pyscf = callPackage ../development/python-modules/pyscf { };

  pyschedule = callPackage ../development/python-modules/pyschedule { };

  pyscreenshot = callPackage ../development/python-modules/pyscreenshot { };

  pyscreeze = callPackage ../development/python-modules/pyscreeze { };

  py-scrypt = callPackage ../development/python-modules/py-scrypt { };

  pyscrypt = callPackage ../development/python-modules/pyscrypt { };

  pyscss = callPackage ../development/python-modules/pyscss { };

  pysdcp = callPackage ../development/python-modules/pysdcp { };

  pysdl2 = callPackage ../development/python-modules/pysdl2 { };

  pysearpc = toPythonModule (pkgs.libsearpc.override {
    python3 = self.python;
  });

  pysecuritas = callPackage ../development/python-modules/pysecuritas { };

  pysendfile = callPackage ../development/python-modules/pysendfile { };

  pysensibo = callPackage ../development/python-modules/pysensibo { };

  pysensors = callPackage ../development/python-modules/pysensors { };

  pyserial-asyncio = callPackage ../development/python-modules/pyserial-asyncio { };

  pyserial-asyncio-fast = callPackage ../development/python-modules/pyserial-asyncio-fast { };

  pyserial = callPackage ../development/python-modules/pyserial { };

  pysftp = callPackage ../development/python-modules/pysftp { };

  pyshp = callPackage ../development/python-modules/pyshp { };

  pyside2-tools = toPythonModule (callPackage ../development/python-modules/pyside2-tools {
    inherit (pkgs) cmake qt5;
  });

  pyside2 = toPythonModule (callPackage ../development/python-modules/pyside2 {
    inherit (pkgs) cmake ninja qt5;
  });

  pyside6 = toPythonModule (callPackage ../development/python-modules/pyside6 {
    inherit (pkgs) cmake ninja;
  });

  pysigma = callPackage ../development/python-modules/pysigma { };

  pysigma-backend-elasticsearch = callPackage ../development/python-modules/pysigma-backend-elasticsearch { };

  pysigma-backend-opensearch = callPackage ../development/python-modules/pysigma-backend-opensearch { };

  pysigma-backend-qradar = callPackage ../development/python-modules/pysigma-backend-qradar { };

  pysigma-backend-splunk = callPackage ../development/python-modules/pysigma-backend-splunk { };

  pysigma-backend-sqlite = callPackage ../development/python-modules/pysigma-backend-sqlite { };

  pysigma-backend-insightidr = callPackage ../development/python-modules/pysigma-backend-insightidr { };

  pysigma-pipeline-crowdstrike = callPackage ../development/python-modules/pysigma-pipeline-crowdstrike { };

  pysigma-pipeline-sysmon = callPackage ../development/python-modules/pysigma-pipeline-sysmon { };

  pysigma-pipeline-windows = callPackage ../development/python-modules/pysigma-pipeline-windows { };

  pysignalclirestapi = callPackage ../development/python-modules/pysignalclirestapi { };

  pysigset = callPackage ../development/python-modules/pysigset { };

  pysim = callPackage ../development/python-modules/pysim { };

  pysimplegui = callPackage ../development/python-modules/pysimplegui { };

  pysingleton = callPackage ../development/python-modules/pysingleton { };

  pyslim = callPackage ../development/python-modules/pyslim { };

  pyslurm = callPackage ../development/python-modules/pyslurm {
    inherit (pkgs) slurm;
  };

  pysma = callPackage ../development/python-modules/pysma { };

  pysmappee = callPackage ../development/python-modules/pysmappee { };

  pysmart = callPackage ../development/python-modules/pysmart { };

  pysmartapp = callPackage ../development/python-modules/pysmartapp { };

  pysmartdl = callPackage ../development/python-modules/pysmartdl { };

  pysmartthings = callPackage ../development/python-modules/pysmartthings { };

  pysmb = callPackage ../development/python-modules/pysmb { };

  pysmbc = callPackage ../development/python-modules/pysmbc { };

  pysmf = callPackage ../development/python-modules/pysmf { };

  pysmi = callPackage ../development/python-modules/pysmi { };

  pysmi-lextudio = callPackage ../development/python-modules/pysmi-lextudio { };

  pysml = callPackage ../development/python-modules/pysml { };

  pysmt = callPackage ../development/python-modules/pysmt { };

  pysnmp = callPackage ../development/python-modules/pysnmp { };

  pysnmpcrypto = callPackage ../development/python-modules/pysnmpcrypto { };

  pysnmp-lextudio = callPackage ../development/python-modules/pysnmp-lextudio { };

  pysnmp-pyasn1 = callPackage ../development/python-modules/pysnmp-pyasn1 { };

  pysnmp-pysmi = callPackage ../development/python-modules/pysnmp-pysmi { };

  pysnmplib = callPackage ../development/python-modules/pysnmplib { };

  pysnooper = callPackage ../development/python-modules/pysnooper { };

  pysnooz = callPackage ../development/python-modules/pysnooz { };

  pysnow = callPackage ../development/python-modules/pysnow { };

  pysocks = callPackage ../development/python-modules/pysocks { };

  pysol-cards = callPackage ../development/python-modules/pysol-cards { };

  pysolr = callPackage ../development/python-modules/pysolr { };

  pysoma = callPackage ../development/python-modules/pysoma { };

  py-sonic = callPackage ../development/python-modules/py-sonic { };

  pysonos = callPackage ../development/python-modules/pysonos { };

  pysoundfile = self.soundfile; # Alias added 23-06-2019

  pyspark = callPackage ../development/python-modules/pyspark { };

  pyspcwebgw = callPackage ../development/python-modules/pyspcwebgw { };

  pyspellchecker = callPackage ../development/python-modules/pyspellchecker { };

  pyspf = callPackage ../development/python-modules/pyspf { };

  pyspice = callPackage ../development/python-modules/pyspice { };

  pyspiflash = callPackage ../development/python-modules/pyspiflash { };

  pyspinel = callPackage ../development/python-modules/pyspinel { };

  pyspnego = callPackage ../development/python-modules/pyspnego { };

  pysptk = callPackage ../development/python-modules/pysptk { };

  pyspx = callPackage ../development/python-modules/pyspx { };

  pysqlcipher3 = callPackage ../development/python-modules/pysqlcipher3 {
    inherit (pkgs) sqlcipher;
  };

  pysqueezebox = callPackage ../development/python-modules/pysqueezebox { };

  pysrim = callPackage ../development/python-modules/pysrim { };

  pysrt = callPackage ../development/python-modules/pysrt { };

  pyssim = callPackage ../development/python-modules/pyssim { };

  pystache = callPackage ../development/python-modules/pystache { };

  pystardict = callPackage ../development/python-modules/pystardict { };

  pystatgrab = callPackage ../development/python-modules/pystatgrab { };

  pystemd = callPackage ../development/python-modules/pystemd {
    inherit (pkgs) systemd;
  };

  pystemmer = callPackage ../development/python-modules/pystemmer { };

  pystray = callPackage ../development/python-modules/pystray { };

  py-stringmatching = callPackage ../development/python-modules/py-stringmatching { };

  pysvg-py3 = callPackage ../development/python-modules/pysvg-py3 { };

  pysvn = callPackage ../development/python-modules/pysvn {
    inherit (pkgs) bash subversion apr aprutil expat neon openssl;
  };

  pyswitchbee = callPackage ../development/python-modules/pyswitchbee { };

  pyswitchbot = callPackage ../development/python-modules/pyswitchbot { };

  pysychonaut = callPackage ../development/python-modules/pysychonaut { };

  pysyncobj = callPackage ../development/python-modules/pysyncobj { };

  pytabix = callPackage ../development/python-modules/pytabix { };

  pytablewriter = callPackage ../development/python-modules/pytablewriter { };

  pytado = callPackage ../development/python-modules/pytado { };

  pytaglib = callPackage ../development/python-modules/pytaglib { };

  pytankerkoenig = callPackage ../development/python-modules/pytankerkoenig { };

  pytap2 = callPackage ../development/python-modules/pytap2 { };

  pytapo = callPackage ../development/python-modules/pytapo { };

  pytautulli = callPackage ../development/python-modules/pytautulli { };

  pyte = callPackage ../development/python-modules/pyte { };

  pytedee-async = callPackage ../development/python-modules/pytedee-async { };

  pytenable = callPackage ../development/python-modules/pytenable { };

  pytensor = callPackage ../development/python-modules/pytensor { };

  pytelegrambotapi = callPackage ../development/python-modules/pyTelegramBotAPI { };

  pytesseract = callPackage ../development/python-modules/pytesseract { };

  pytest = callPackage ../development/python-modules/pytest { };

  pytest_7 = callPackage ../development/python-modules/pytest/7.nix { };

  pytest-aio = callPackage ../development/python-modules/pytest-aio { };

  pytest-aiohttp = callPackage ../development/python-modules/pytest-aiohttp { };

  pytest-annotate = callPackage ../development/python-modules/pytest-annotate { };

  pytest-ansible = callPackage ../development/python-modules/pytest-ansible { };

  pytest-arraydiff = callPackage ../development/python-modules/pytest-arraydiff { };

  pytest-astropy = callPackage ../development/python-modules/pytest-astropy { };

  pytest-astropy-header = callPackage ../development/python-modules/pytest-astropy-header { };

  pytest-asyncio = callPackage ../development/python-modules/pytest-asyncio { };

  pytest-asyncio_0_21 = pytest-asyncio.overridePythonAttrs (old: rec {
    version = "0.21.1";
    src = pkgs.fetchFromGitHub {
      owner = "pytest-dev";
      repo = "pytest-asyncio";
      rev = "refs/tags/v${version}";
      hash = "sha256-Wpo8MpCPGiXrckT2x5/yBYtGlzso/L2urG7yGc7SPkA=";
    };
  });

  pytest-bdd = callPackage ../development/python-modules/pytest-bdd { };

  pytest-benchmark = callPackage ../development/python-modules/pytest-benchmark { };

  pytest-black = callPackage ../development/python-modules/pytest-black { };

  pytest-cache = self.pytestcache; # added 2021-01-04
  pytestcache = callPackage ../development/python-modules/pytestcache { };

  pytest-base-url = callPackage ../development/python-modules/pytest-base-url { };

  pytest-cases = callPackage ../development/python-modules/pytest-cases{ };

  pytest-catchlog = callPackage ../development/python-modules/pytest-catchlog { };

  pytest-celery = callPackage ../development/python-modules/pytest-celery { };

  pytest-check = callPackage ../development/python-modules/pytest-check { };

  pytest-cid = callPackage ../development/python-modules/pytest-cid { };

  pytest-click = callPackage ../development/python-modules/pytest-click { };

  pytest-console-scripts = callPackage ../development/python-modules/pytest-console-scripts { };

  pytest-cov = callPackage ../development/python-modules/pytest-cov { };

  pytest-cram = callPackage ../development/python-modules/pytest-cram { };

  pytest-datadir = callPackage ../development/python-modules/pytest-datadir { };

  pytest-datafiles = callPackage ../development/python-modules/pytest-datafiles { };

  pytest-dependency = callPackage ../development/python-modules/pytest-dependency { };

  pytest-describe = callPackage ../development/python-modules/pytest-describe { };

  pytest-django = callPackage ../development/python-modules/pytest-django { };

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

  pytest-golden = callPackage ../development/python-modules/pytest-golden { };

  pytest-grpc = callPackage ../development/python-modules/pytest-grpc { };

  pytest-harvest = callPackage ../development/python-modules/pytest-harvest { };

  pytest-helpers-namespace = callPackage ../development/python-modules/pytest-helpers-namespace { };

  pytest-html = callPackage ../development/python-modules/pytest-html { };

  pytest-httpbin = callPackage ../development/python-modules/pytest-httpbin { };

  pytest-httpserver = callPackage ../development/python-modules/pytest-httpserver { };

  pytest-httpx = callPackage ../development/python-modules/pytest-httpx { };

  pytest-image-diff = callPackage ../development/python-modules/pytest-image-diff { };

  pytest-instafail = callPackage ../development/python-modules/pytest-instafail { };

  pytest-isort = callPackage ../development/python-modules/pytest-isort { };

  pytest-json-report = callPackage ../development/python-modules/pytest-json-report { };

  pytest-jupyter = callPackage ../development/python-modules/pytest-jupyter { };

  pytest-lazy-fixture = callPackage ../development/python-modules/pytest-lazy-fixture { };

  pytest-localserver = callPackage ../development/python-modules/pytest-localserver { };

  pytest-logdog = callPackage ../development/python-modules/pytest-logdog { };

  pytest-md-report = callPackage ../development/python-modules/pytest-md-report { };

  pytest-metadata = callPackage ../development/python-modules/pytest-metadata { };

  pytest-mock = callPackage ../development/python-modules/pytest-mock { };

  pytest-mockservers = callPackage ../development/python-modules/pytest-mockservers { };

  pytest-mpl = callPackage ../development/python-modules/pytest-mpl { };

  pytest-mypy = callPackage ../development/python-modules/pytest-mypy { };

  pytest-mypy-plugins = callPackage ../development/python-modules/pytest-mypy-plugins { };

  pytest-notebook = callPackage ../development/python-modules/pytest-notebook { };

  pytest-openfiles = callPackage ../development/python-modules/pytest-openfiles { };

  pytest-order = callPackage ../development/python-modules/pytest-order { };

  pytest-param-files = callPackage ../development/python-modules/pytest-param-files { };

  pytest-parallel = callPackage ../development/python-modules/pytest-parallel { };

  pytest-playwright = callPackage ../development/python-modules/pytest-playwright {};

  pytest-plt = callPackage ../development/python-modules/pytest-plt { };

  pytest-postgresql = callPackage ../development/python-modules/pytest-postgresql { };

  pytest-pylint = callPackage ../development/python-modules/pytest-pylint { };

  pytest-pytestrail = callPackage ../development/python-modules/pytest-pytestrail { };

  pytest-qt = callPackage ../development/python-modules/pytest-qt { };

  pytest-quickcheck = callPackage ../development/python-modules/pytest-quickcheck { };

  pytest-raises = callPackage ../development/python-modules/pytest-raises { };

  pytest-raisesregexp = callPackage ../development/python-modules/pytest-raisesregexp { };

  pytest-raisin = callPackage ../development/python-modules/pytest-raisin { };

  pytest-randomly = callPackage ../development/python-modules/pytest-randomly { };

  pytest-reverse = callPackage ../development/python-modules/pytest-reverse { };

  pytest-random-order = callPackage ../development/python-modules/pytest-random-order { };

  pytest-recording = callPackage ../development/python-modules/pytest-recording { };

  pytest-regressions = callPackage ../development/python-modules/pytest-regressions { };

  pytest-relaxed = callPackage ../development/python-modules/pytest-relaxed { };

  pytest-remotedata = callPackage ../development/python-modules/pytest-remotedata { };

  pytest-repeat = callPackage ../development/python-modules/pytest-repeat { };

  pytest-rerunfailures = callPackage ../development/python-modules/pytest-rerunfailures { };

  pytest-resource-path = callPackage ../development/python-modules/pytest-resource-path { };

  pytest-runner = callPackage ../development/python-modules/pytest-runner { };

  pytest-server-fixtures = callPackage ../development/python-modules/pytest-server-fixtures { };

  pytest-services = callPackage ../development/python-modules/pytest-services { };

  pytest-snapshot = callPackage ../development/python-modules/pytest-snapshot { };

  pytest-shutil = callPackage ../development/python-modules/pytest-shutil { };

  pytest-spec = callPackage ../development/python-modules/pytest-spec { };

  python-status = callPackage ../development/python-modules/python-status { };

  python-string-utils = callPackage ../development/python-modules/python-string-utils { };

  pytest-socket = callPackage ../development/python-modules/pytest-socket { };

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

  pytest-unordered = callPackage ../development/python-modules/pytest-unordered { };

  pytest-vcr = callPackage ../development/python-modules/pytest-vcr { };

  pytest-virtualenv = callPackage ../development/python-modules/pytest-virtualenv { };

  pytest-voluptuous = callPackage ../development/python-modules/pytest-voluptuous { };

  pytest-warnings = callPackage ../development/python-modules/pytest-warnings { };

  pytest-watch = callPackage ../development/python-modules/pytest-watch { };

  pytest-xdist = callPackage ../development/python-modules/pytest-xdist { };

  pytest-xprocess = callPackage ../development/python-modules/pytest-xprocess { };

  pytest-xvfb = callPackage ../development/python-modules/pytest-xvfb { };

  python3-application = callPackage ../development/python-modules/python3-application { };

  python3-eventlib = callPackage ../development/python-modules/python3-eventlib { };

  python3-gnutls = callPackage ../development/python-modules/python3-gnutls { };

  python3-openid = callPackage ../development/python-modules/python3-openid { };

  python-arango = callPackage ../development/python-modules/python-arango { };

  python-awair = callPackage ../development/python-modules/python-awair { };

  python3-saml = callPackage ../development/python-modules/python3-saml { };

  python-axolotl = callPackage ../development/python-modules/python-axolotl { };

  python-axolotl-curve25519 = callPackage ../development/python-modules/python-axolotl-curve25519 { };

  python-barcode = callPackage ../development/python-modules/python-barcode { };

  python-baseconv = callPackage ../development/python-modules/python-baseconv { };

  python-benedict = callPackage ../development/python-modules/python-benedict { };

  python-bidi = callPackage ../development/python-modules/python-bidi { };

  python-binance = callPackage ../development/python-modules/python-binance { };

  python-box = callPackage ../development/python-modules/python-box { };

  python-bring-api = callPackage ../development/python-modules/python-bring-api { };

  python-bsblan = callPackage ../development/python-modules/python-bsblan { };

  python-cinderclient = callPackage ../development/python-modules/python-cinderclient { };

  python-constraint = callPackage ../development/python-modules/python-constraint { };

  python-crontab = callPackage ../development/python-modules/python-crontab { };

  python-ctags3 = callPackage ../development/python-modules/python-ctags3 { };

  python-daemon = callPackage ../development/python-modules/python-daemon { };

  python-datemath = callPackage ../development/python-modules/python-datemath { };

  python-dateutil = callPackage ../development/python-modules/python-dateutil { };

  python-dbusmock = callPackage ../development/python-modules/python-dbusmock { };

  python-decouple = callPackage ../development/python-modules/python-decouple { };

  pythondialog = callPackage ../development/python-modules/pythondialog { };

  python-didl-lite = callPackage ../development/python-modules/python-didl-lite { };

  python-docx = callPackage ../development/python-modules/python-docx { };

  python-doi = callPackage ../development/python-modules/python-doi { };

  python-dotenv = callPackage ../development/python-modules/python-dotenv { };

  python-editor = callPackage ../development/python-modules/python-editor { };

  python-family-hub-local = callPackage ../development/python-modules/python-family-hub-local { };

  python-fsutil = callPackage ../development/python-modules/python-fsutil { };

  pythonefl = callPackage ../development/python-modules/python-efl { };

  pythonegardia = callPackage ../development/python-modules/pythonegardia { };

  python-engineio = callPackage ../development/python-modules/python-engineio { };

  python-etcd = callPackage ../development/python-modules/python-etcd { };

  python-ethtool = callPackage ../development/python-modules/python-ethtool { };

  python-ev3dev2 = callPackage ../development/python-modules/python-ev3dev2 { };

  python-fedora = callPackage ../development/python-modules/python-fedora { };

  python-fontconfig = callPackage ../development/python-modules/python-fontconfig { };

  python-frontmatter = callPackage ../development/python-modules/python-frontmatter { };

  python-gammu = callPackage ../development/python-modules/python-gammu { };

  python-gitlab = callPackage ../development/python-modules/python-gitlab { };

  python-gnupg = callPackage ../development/python-modules/python-gnupg { };

  python-gvm = callPackage ../development/python-modules/python-gvm { };

  python-hglib = callPackage ../development/python-modules/python-hglib { };

  python-homewizard-energy = callPackage ../development/python-modules/python-homewizard-energy { };

  python-hosts = callPackage ../development/python-modules/python-hosts { };

  python-hpilo = callPackage ../development/python-modules/python-hpilo { };

  python-http-client = callPackage ../development/python-modules/python-http-client { };

  python-i18n = callPackage ../development/python-modules/python-i18n { };

  pythonix = callPackage ../development/python-modules/pythonix {
    nix = pkgs.nixVersions.nix_2_3;
    meson = pkgs.meson.override { python3 = self.python; };
  };

  python-jenkins = callPackage ../development/python-modules/python-jenkins { };

  python-jose = callPackage ../development/python-modules/python-jose { };

  python-json-logger = callPackage ../development/python-modules/python-json-logger { };

  python-jsonrpc-server = callPackage ../development/python-modules/python-jsonrpc-server { };

  python-ldap = callPackage ../development/python-modules/python-ldap {
    inherit (pkgs) openldap cyrus_sasl;
  };

  python-ldap-test = callPackage ../development/python-modules/python-ldap-test { };

  python-libnmap = callPackage ../development/python-modules/python-libnmap { };

  python-linux-procfs = callPackage ../development/python-modules/python-linux-procfs { };

  python-logstash = callPackage ../development/python-modules/python-logstash { };

  python-louvain = callPackage ../development/python-modules/python-louvain { };

  python-lsp-jsonrpc = callPackage ../development/python-modules/python-lsp-jsonrpc { };

  python-lsp-ruff = callPackage ../development/python-modules/python-lsp-ruff { };

  python-lsp-server = callPackage ../development/python-modules/python-lsp-server { };

  python-ly = callPackage ../development/python-modules/python-ly { };

  python-lzf = callPackage ../development/python-modules/python-lzf { };

  python-lzo = callPackage ../development/python-modules/python-lzo {
    inherit (pkgs) lzo;
  };

  python-magic = callPackage ../development/python-modules/python-magic { };

  python-manilaclient = callPackage ../development/python-modules/python-manilaclient { };

  python-mapnik = callPackage ../development/python-modules/python-mapnik rec {
    inherit (pkgs) pkg-config cairo icu libjpeg libpng libtiff libwebp proj zlib;
    boost = pkgs.boost182.override {
      enablePython = true;
      inherit python;
    };
    harfbuzz = pkgs.harfbuzz.override {
      withIcu = true;
    };
    mapnik = pkgs.mapnik.override {
      inherit boost harfbuzz;
    };
  };

  python-markdown-math = callPackage ../development/python-modules/python-markdown-math { };

  python-matter-server = callPackage ../development/python-modules/python-matter-server { };

  python-miio = callPackage ../development/python-modules/python-miio { };

  python-mimeparse = callPackage ../development/python-modules/python-mimeparse { };

  python-mnist = callPackage ../development/python-modules/python-mnist { };

  python-mpv-jsonipc = callPackage ../development/python-modules/python-mpv-jsonipc { };

  python-multipart = callPackage ../development/python-modules/python-multipart { };

  python-musicpd = callPackage ../development/python-modules/python-musicpd { };

  python-mystrom = callPackage ../development/python-modules/python-mystrom { };

  python-nest = callPackage ../development/python-modules/python-nest { };

  pythonnet = callPackage ../development/python-modules/pythonnet { };

  python-nmap = callPackage ../development/python-modules/python-nmap { };

  python-nomad = callPackage ../development/python-modules/python-nomad { };

  python-novaclient = callPackage ../development/python-modules/python-novaclient { };

  python-oauth2 = callPackage ../development/python-modules/python-oauth2 { };

  pythonocc-core = toPythonModule (callPackage ../development/python-modules/pythonocc-core {
    inherit (pkgs) fontconfig rapidjson;
    inherit (pkgs.xorg) libX11 libXi libXmu libXext;
    inherit (pkgs.darwin.apple_sdk.frameworks) Cocoa;
  });

  python-olm = callPackage ../development/python-modules/python-olm { };

  python-on-whales = callPackage ../development/python-modules/python-on-whales { };

  python-opendata-transport = callPackage ../development/python-modules/python-opendata-transport { };

  python-openstackclient = callPackage ../development/python-modules/python-openstackclient { };

  python-openzwave = callPackage ../development/python-modules/python-openzwave { };

  python-osc = callPackage ../development/python-modules/python-osc { };

  python-packer = callPackage ../development/python-modules/python-packer { };

  python-pae = callPackage ../development/python-modules/python-pae { };

  python-pam = callPackage ../development/python-modules/python-pam {
    inherit (pkgs) pam;
  };

  python-periphery = callPackage ../development/python-modules/python-periphery { };

  python-picnic-api = callPackage ../development/python-modules/python-picnic-api { };

  python-pidfile = callPackage ../development/python-modules/python-pidfile { };

  python-pipedrive = callPackage ../development/python-modules/python-pipedrive { };

  python-pkcs11 = callPackage ../development/python-modules/python-pkcs11 { };

  python-prctl = callPackage ../development/python-modules/python-prctl { };

  python-ptrace = callPackage ../development/python-modules/python-ptrace { };

  python-rapidjson = callPackage ../development/python-modules/python-rapidjson { };

  python-rabbitair = callPackage ../development/python-modules/python-rabbitair { };

  python-redis-lock = callPackage ../development/python-modules/python-redis-lock { };

  python-registry = callPackage ../development/python-modules/python-registry { };

  python-roborock = callPackage ../development/python-modules/python-roborock { };

  python-rtmidi = callPackage ../development/python-modules/python-rtmidi {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreAudio CoreMIDI CoreServices Foundation;
  };

  python-sat = callPackage ../development/python-modules/python-sat { };

  python-simple-hipchat = callPackage ../development/python-modules/python-simple-hipchat { };

  python-slugify = callPackage ../development/python-modules/python-slugify { };

  python-smarttub = callPackage ../development/python-modules/python-smarttub { };

  python-snap7 = callPackage ../development/python-modules/python-snap7 {
    inherit (pkgs) snap7;
  };

  python-snappy = callPackage ../development/python-modules/python-snappy {
    inherit (pkgs) snappy;
  };

  python-socketio = callPackage ../development/python-modules/python-socketio { };

  python-socks = callPackage ../development/python-modules/python-socks { };

  python-sql = callPackage ../development/python-modules/python-sql { };

  python-stdnum = callPackage ../development/python-modules/python-stdnum { };

  python-technove = callPackage ../development/python-modules/python-technove { };

  python-telegram = callPackage ../development/python-modules/python-telegram { };

  python-telegram-bot = callPackage ../development/python-modules/python-telegram-bot { };

  python-toolbox = callPackage ../development/python-modules/python-toolbox { };

  python-trovo = callPackage ../development/python-modules/python-trovo { };

  python-twitch-client = callPackage ../development/python-modules/python-twitch-client { };

  python-twitter = callPackage ../development/python-modules/python-twitter { };

  python-u2flib-host = callPackage ../development/python-modules/python-u2flib-host { };

  python-u2flib-server = callPackage ../development/python-modules/python-u2flib-server { };

  python-uinput = callPackage ../development/python-modules/python-uinput { };

  python-ulid = callPackage ../development/python-modules/python-ulid { };

  python-unshare = callPackage ../development/python-modules/python-unshare { };

  python-utils = callPackage ../development/python-modules/python-utils { };

  python-vagrant = callPackage ../development/python-modules/python-vagrant { };

  python-velbus = callPackage ../development/python-modules/python-velbus { };

  python-vipaccess = callPackage ../development/python-modules/python-vipaccess { };

  python-vlc = callPackage ../development/python-modules/python-vlc { };

  python-whois = callPackage ../development/python-modules/python-whois { };

  python-wifi = callPackage ../development/python-modules/python-wifi { };

  python-wink = callPackage ../development/python-modules/python-wink { };

  python-xmp-toolkit = callPackage ../development/python-modules/python-xmp-toolkit { };

  python-xz = callPackage ../development/python-modules/python-xz { };

  python-zbar = callPackage ../development/python-modules/python-zbar { };

  pythran = callPackage ../development/python-modules/pythran {
    inherit (pkgs.llvmPackages) openmp;
  };

  pyeapi = callPackage ../development/python-modules/pyeapi { };

  pyeverlights = callPackage ../development/python-modules/pyeverlights { };

  pyinfra = callPackage ../development/python-modules/pyinfra { };

  pytibber = callPackage ../development/python-modules/pytibber { };

  pytile = callPackage ../development/python-modules/pytile { };

  pytimeparse = callPackage ../development/python-modules/pytimeparse { };

  pytimeparse2 = callPackage ../development/python-modules/pytimeparse2 { };

  pytikz-allefeld = callPackage ../development/python-modules/pytikz-allefeld { };

  pytm = callPackage ../development/python-modules/pytm { };

  pytmx = callPackage ../development/python-modules/pytmx { };

  pytomlpp = callPackage ../development/python-modules/pytomlpp { };

  pytoolconfig = callPackage ../development/python-modules/pytoolconfig { };

  pytools = callPackage ../development/python-modules/pytools { };

  pytorch-lightning = callPackage ../development/python-modules/pytorch-lightning { };

  pytorch-metric-learning = callPackage ../development/python-modules/pytorch-metric-learning { };

  pytorch-msssim = callPackage ../development/python-modules/pytorch-msssim { };

  pytorch-pfn-extras = callPackage ../development/python-modules/pytorch-pfn-extras { };

  pytraccar = callPackage ../development/python-modules/pytraccar { };

  pytradfri = callPackage ../development/python-modules/pytradfri { };

  pytrafikverket = callPackage ../development/python-modules/pytrafikverket { };

  pytransportnsw = callPackage ../development/python-modules/pytransportnsw { };

  pytransportnswv2 = callPackage ../development/python-modules/pytransportnswv2 { };

  pytrends = callPackage ../development/python-modules/pytrends { };

  pytricia = callPackage ../development/python-modules/pytricia { };

  pytrydan = callPackage ../development/python-modules/pytrydan { };

  pyttsx3 = callPackage ../development/python-modules/pyttsx3 { };

  pytube = callPackage ../development/python-modules/pytube { };

  pytun = callPackage ../development/python-modules/pytun { };

  pyturbojpeg = callPackage ../development/python-modules/pyturbojpeg { };

  pytweening = callPackage ../development/python-modules/pytweening { };

  pytz = callPackage ../development/python-modules/pytz { };

  pytz-deprecation-shim = callPackage ../development/python-modules/pytz-deprecation-shim { };

  pytzdata = callPackage ../development/python-modules/pytzdata { };

  pyu2f = callPackage ../development/python-modules/pyu2f { };

  pyudev = callPackage ../development/python-modules/pyudev {
    inherit (pkgs) udev;
  };

  pyunbound = toPythonModule (callPackage ../tools/networking/unbound/python.nix { });

  pyunifi = callPackage ../development/python-modules/pyunifi { };

  pyunifiprotect = callPackage ../development/python-modules/pyunifiprotect { };

  pyupdate = callPackage ../development/python-modules/pyupdate { };

  pyupgrade = callPackage ../development/python-modules/pyupgrade { };

  pyuptimerobot = callPackage ../development/python-modules/pyuptimerobot { };

  pyusb = callPackage ../development/python-modules/pyusb {
    inherit (pkgs) libusb1;
  };

  pyuseragents = callPackage ../development/python-modules/pyuseragents { };

  pyutilib = callPackage ../development/python-modules/pyutilib { };

  pyuv = callPackage ../development/python-modules/pyuv { };

  py-vapid = callPackage ../development/python-modules/py-vapid { };

  pyvcd = callPackage ../development/python-modules/pyvcd { };

  pyvera = callPackage ../development/python-modules/pyvera { };

  pyverilog = callPackage ../development/python-modules/pyverilog { };

  pyversasense = callPackage ../development/python-modules/pyversasense { };

  pyvesync = callPackage ../development/python-modules/pyvesync { };

  pyvex = callPackage ../development/python-modules/pyvex { };

  pyvicare = callPackage ../development/python-modules/pyvicare { };

  pyvirtualdisplay = callPackage ../development/python-modules/pyvirtualdisplay { };

  pyvis = callPackage ../development/python-modules/pyvis { };

  pyvisa = callPackage ../development/python-modules/pyvisa { };

  pyvisa-py = callPackage ../development/python-modules/pyvisa-py { };

  pyvisa-sim = callPackage ../development/python-modules/pyvisa-sim { };

  pyvista = callPackage ../development/python-modules/pyvista { };

  pyviz-comms = callPackage ../development/python-modules/pyviz-comms { };

  pyvizio = callPackage ../development/python-modules/pyvizio { };

  pyvips = callPackage ../development/python-modules/pyvips {
    inherit (pkgs) vips glib;
  };

  pyvlx = callPackage ../development/python-modules/pyvlx { };

  pyvmomi = callPackage ../development/python-modules/pyvmomi { };

  pyvo = callPackage ../development/python-modules/pyvo { };

  pyvolumio = callPackage ../development/python-modules/pyvolumio { };

  pyvoro = callPackage ../development/python-modules/pyvoro { };

  pywal = callPackage ../development/python-modules/pywal { };

  pywatchman = callPackage ../development/python-modules/pywatchman { };

  pywaterkotte = callPackage ../development/python-modules/pywaterkotte { };

  pywavelets = callPackage ../development/python-modules/pywavelets { };

  pywayland = callPackage ../development/python-modules/pywayland { };

  pywaze = callPackage ../development/python-modules/pywaze { };

  pywbem = callPackage ../development/python-modules/pywbem {
    inherit (pkgs) libxml2;
  };

  pyweatherflowrest = callPackage ../development/python-modules/pyweatherflowrest { };

  pyweatherflowudp = callPackage ../development/python-modules/pyweatherflowudp { };

  pywebpush = callPackage ../development/python-modules/pywebpush { };

  pywebview = callPackage ../development/python-modules/pywebview { };

  pywemo = callPackage ../development/python-modules/pywemo { };

  pywerview = callPackage ../development/python-modules/pywerview { };

  pywfa = callPackage ../development/python-modules/pywfa { };

  pywilight = callPackage ../development/python-modules/pywilight { };

  pywinrm = callPackage ../development/python-modules/pywinrm { };

  pywizlight = callPackage ../development/python-modules/pywizlight { };

  pywlroots = callPackage ../development/python-modules/pywlroots {
    wlroots = pkgs.wlroots_0_16;
  };

  pyws66i = callPackage ../development/python-modules/pyws66i { };

  pyxattr = callPackage ../development/python-modules/pyxattr { };

  pyxlsb = callPackage ../development/python-modules/pyxlsb { };

  pyworld = callPackage ../development/python-modules/pyworld { };

  pyx = callPackage ../development/python-modules/pyx { };

  pyxbe = callPackage ../development/python-modules/pyxbe { };

  pyxdg = callPackage ../development/python-modules/pyxdg { };

  pyxeoma = callPackage ../development/python-modules/pyxeoma { };

  pyxiaomigateway = callPackage ../development/python-modules/pyxiaomigateway { };

  pyxl3 = callPackage ../development/python-modules/pyxl3 { };

  pyxnat = callPackage ../development/python-modules/pyxnat { };

  pyyaml = callPackage ../development/python-modules/pyyaml { };

  pyyaml-env-tag = callPackage ../development/python-modules/pyyaml-env-tag { };

  pyyaml-include = callPackage ../development/python-modules/pyyaml-include { };

  pyyardian = callPackage ../development/python-modules/pyyardian { };

  pyzabbix = callPackage ../development/python-modules/pyzabbix { };

  pyzerproc = callPackage ../development/python-modules/pyzerproc { };

  pyzmq = callPackage ../development/python-modules/pyzmq { };

  pyzufall = callPackage ../development/python-modules/pyzufall { };

  qbittorrent-api = callPackage ../development/python-modules/qbittorrent-api { };

  qasync = callPackage ../development/python-modules/qasync { };

  qcelemental = callPackage ../development/python-modules/qcelemental { };

  qcengine = callPackage ../development/python-modules/qcengine { };

  qcodes = callPackage ../development/python-modules/qcodes { };

  qcodes-contrib-drivers = callPackage ../development/python-modules/qcodes-contrib-drivers { };

  qcs-api-client = callPackage ../development/python-modules/qcs-api-client { };

  qcs-sdk-python = callPackage ../development/python-modules/qcs-sdk-python { };

  qdarkstyle = callPackage ../development/python-modules/qdarkstyle { };

  qdldl = callPackage ../development/python-modules/qdldl { };

  qdrant-client = callPackage ../development/python-modules/qdrant-client { };

  qds-sdk = callPackage ../development/python-modules/qds-sdk { };

  qgrid = callPackage ../development/python-modules/qgrid { };

  qemu = callPackage ../development/python-modules/qemu {
    qemu = pkgs.qemu;
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

  qnap-qsw = callPackage ../development/python-modules/qnap-qsw{ };

  qnapstats = callPackage ../development/python-modules/qnapstats { };

  qpageview = callPackage ../development/python-modules/qpageview { };

  qpsolvers = callPackage ../development/python-modules/qpsolvers { };

  qrcode = callPackage ../development/python-modules/qrcode { };

  qreactor = callPackage ../development/python-modules/qreactor { };

  qscintilla-qt5 = pkgs.libsForQt5.callPackage ../development/python-modules/qscintilla-qt5 {
    pythonPackages = self;
  };

  qscintilla = self.qscintilla-qt5;

  qstylizer = callPackage ../development/python-modules/qstylizer { };

  qt-material = callPackage ../development/python-modules/qt-material { };

  qt5reactor = callPackage ../development/python-modules/qt5reactor { };

  qt6 = pkgs.qt6.override {
    python3 = self.python;
  };

  qtawesome = callPackage ../development/python-modules/qtawesome { };

  qtconsole = callPackage ../development/python-modules/qtconsole { };

  qtile = callPackage ../development/python-modules/qtile {
    wlroots = pkgs.wlroots_0_16;
  };
  qtile-extras = callPackage ../development/python-modules/qtile-extras { };

  qtpy = callPackage ../development/python-modules/qtpy { };

  quadprog = callPackage ../development/python-modules/quadprog { };

  qualysclient = callPackage ../development/python-modules/qualysclient { };

  quamash = callPackage ../development/python-modules/quamash { };

  quandl = callPackage ../development/python-modules/quandl { };

  quantities = callPackage ../development/python-modules/quantities { };

  quantiphy = callPackage ../development/python-modules/quantiphy { };

  quantile-python = callPackage ../development/python-modules/quantile-python { };

  quantiphy-eval = callPackage ../development/python-modules/quantiphy-eval { };

  quantum-gateway = callPackage ../development/python-modules/quantum-gateway { };

  quantulum3 = callPackage ../development/python-modules/quantulum3 { };

  quart = callPackage ../development/python-modules/quart { };

  quart-cors = callPackage ../development/python-modules/quart-cors { };

  quaternion = callPackage ../development/python-modules/quaternion { };

  qudida = callPackage ../development/python-modules/qudida { };

  querystring-parser = callPackage ../development/python-modules/querystring-parser { };

  questionary = callPackage ../development/python-modules/questionary { };

  queuelib = callPackage ../development/python-modules/queuelib { };

  quil = callPackage ../development/python-modules/quil { };

  qutip = callPackage ../development/python-modules/qutip { };

  qmk-dotty-dict = callPackage ../development/python-modules/qmk-dotty-dict { };

  r2pipe = callPackage ../development/python-modules/r2pipe { };

  rachiopy = callPackage ../development/python-modules/rachiopy { };

  radicale-infcloud = callPackage ../development/python-modules/radicale-infcloud {
    radicale = pkgs.radicale.override { python3 = python; };
  };

  radian = callPackage ../development/python-modules/radian { };

  radio-beam = callPackage ../development/python-modules/radio-beam { };

  radios = callPackage ../development/python-modules/radios { };

  radiotherm = callPackage ../development/python-modules/radiotherm { };

  radish-bdd = callPackage ../development/python-modules/radish-bdd { };

  radon = callPackage ../development/python-modules/radon { };

  railroad-diagrams = callPackage ../development/python-modules/railroad-diagrams { };

  rainbowstream = callPackage ../development/python-modules/rainbowstream { };

  raincloudy = callPackage ../development/python-modules/raincloudy { };

  ramlfications = callPackage ../development/python-modules/ramlfications { };

  random2 = callPackage ../development/python-modules/random2 { };

  range-typed-integers = callPackage ../development/python-modules/range-typed-integers { };

  rangehttpserver = callPackage ../development/python-modules/rangehttpserver { };

  rangeparser = callPackage ../development/python-modules/rangeparser { };

  rank-bm25 = callPackage ../development/python-modules/rank-bm25 { };

  rapidfuzz = callPackage ../development/python-modules/rapidfuzz { };

  rapidfuzz-capi = callPackage ../development/python-modules/rapidfuzz-capi { };

  rapidgzip = callPackage ../development/python-modules/rapidgzip { inherit (pkgs) nasm; };

  rapt-ble = callPackage ../development/python-modules/rapt-ble { };

  rarfile = callPackage ../development/python-modules/rarfile {
    inherit (pkgs) libarchive;
  };

  rasterio = callPackage ../development/python-modules/rasterio { };

  ratarmountcore = callPackage ../development/python-modules/ratarmountcore { inherit (pkgs) zstd; };

  ratarmount = callPackage ../development/python-modules/ratarmount { };

  ratelim = callPackage ../development/python-modules/ratelim { };

  ratelimit = callPackage ../development/python-modules/ratelimit { };

  rauth = callPackage ../development/python-modules/rauth { };

  raven = callPackage ../development/python-modules/raven { };

  rawkit = callPackage ../development/python-modules/rawkit { };

  ray = callPackage ../development/python-modules/ray { };

  razdel = callPackage ../development/python-modules/razdel { };

  rbtools = callPackage ../development/python-modules/rbtools { };

  rchitect = callPackage ../development/python-modules/rchitect { };

  rcssmin = callPackage ../development/python-modules/rcssmin { };

  rdflib = callPackage ../development/python-modules/rdflib { };

  rdkit = callPackage ../development/python-modules/rdkit {
    boost = pkgs.boost182.override {
      enablePython = true;
      inherit python;
    };
  };

  re-assert = callPackage ../development/python-modules/re-assert { };

  readability-lxml = callPackage ../development/python-modules/readability-lxml { };

  readabilipy = callPackage ../development/python-modules/readabilipy { };

  readchar = callPackage ../development/python-modules/readchar { };

  readlike = callPackage ../development/python-modules/readlike { };

  readmdict = callPackage ../development/python-modules/readmdict { };

  readme = callPackage ../development/python-modules/readme { };

  readme-renderer = callPackage ../development/python-modules/readme-renderer { };

  readthedocs-sphinx-ext = callPackage ../development/python-modules/readthedocs-sphinx-ext { };

  reactivex = callPackage ../development/python-modules/reactivex { };

  rebulk = callPackage ../development/python-modules/rebulk { };

  recipe-scrapers = callPackage ../development/python-modules/recipe-scrapers { };

  recline = callPackage ../development/python-modules/recline { };

  recoll = toPythonModule (pkgs.recoll.override {
    python3Packages = self;
  });

  recommonmark = callPackage ../development/python-modules/recommonmark { };

  reconplogger = callPackage ../development/python-modules/reconplogger { };

  recordlinkage = callPackage ../development/python-modules/recordlinkage { };

  recurring-ical-events = callPackage ../development/python-modules/recurring-ical-events { };

  recursive-pth-loader = toPythonModule (callPackage ../development/python-modules/recursive-pth-loader { });

  red-black-tree-mod = callPackage ../development/python-modules/red-black-tree-mod { };

  redbaron = callPackage ../development/python-modules/redbaron { };

  redis = callPackage ../development/python-modules/redis { };

  redis-om = callPackage ../development/python-modules/redis-om { };

  redshift-connector = callPackage ../development/python-modules/redshift-connector { };

  reedsolo = callPackage ../development/python-modules/reedsolo { };

  referencing = callPackage ../development/python-modules/referencing { };

  refery = callPackage ../development/python-modules/refery { };

  reflink = callPackage ../development/python-modules/reflink { };

  regenmaschine = callPackage ../development/python-modules/regenmaschine { };

  regex = callPackage ../development/python-modules/regex { };

  regional = callPackage ../development/python-modules/regional { };

  reikna = callPackage ../development/python-modules/reikna { };

  related = callPackage ../development/python-modules/related { };

  relatorio = callPackage ../development/python-modules/relatorio { };

  releases = callPackage ../development/python-modules/releases { };

  remarshal = callPackage ../development/python-modules/remarshal { };

  remi = callPackage ../development/python-modules/remi { };

  remote-pdb = callPackage ../development/python-modules/remote-pdb { };

  remotezip = callPackage ../development/python-modules/remotezip { };

  renault-api = callPackage ../development/python-modules/renault-api { };

  rencode = callPackage ../development/python-modules/rencode { };

  renson-endura-delta = callPackage ../development/python-modules/renson-endura-delta { };

  reorder-python-imports = callPackage ../development/python-modules/reorder-python-imports { };

  reolink = callPackage ../development/python-modules/reolink { };

  reolink-aio = callPackage ../development/python-modules/reolink-aio { };

  reparser = callPackage ../development/python-modules/reparser { };

  repath = callPackage ../development/python-modules/repath { };

  repeated-test = callPackage ../development/python-modules/repeated-test { };

  repocheck = callPackage ../development/python-modules/repocheck { };

  reportengine = callPackage ../development/python-modules/reportengine { };

  reportlab = callPackage ../development/python-modules/reportlab { };

  repoze-lru = callPackage ../development/python-modules/repoze-lru { };

  repoze-sphinx-autointerface = callPackage ../development/python-modules/repoze-sphinx-autointerface { };

  repoze-who = callPackage ../development/python-modules/repoze-who { };

  reproject = callPackage ../development/python-modules/reproject { };

  reprshed = callPackage ../development/python-modules/reprshed { };

  reptor = callPackage ../development/python-modules/reptor { };

  reqif = callPackage ../development/python-modules/reqif { };

  requests-aws4auth = callPackage ../development/python-modules/requests-aws4auth { };

  requests-cache = callPackage ../development/python-modules/requests-cache { };

  requests-credssp = callPackage ../development/python-modules/requests-credssp { };

  requests-gssapi = callPackage ../development/python-modules/requests-gssapi { };

  requests-hawk = callPackage ../development/python-modules/requests-hawk { };

  requests = callPackage ../development/python-modules/requests { };

  requests-download = callPackage ../development/python-modules/requests-download { };

  requestsexceptions = callPackage ../development/python-modules/requestsexceptions { };

  requests-file = callPackage ../development/python-modules/requests-file { };

  requests-futures = callPackage ../development/python-modules/requests-futures { };

  requests-http-signature = callPackage ../development/python-modules/requests-http-signature { };

  requests-kerberos = callPackage ../development/python-modules/requests-kerberos { };

  requests-mock = callPackage ../development/python-modules/requests-mock { };

  requests-ntlm = callPackage ../development/python-modules/requests-ntlm { };

  requests-oauthlib = callPackage ../development/python-modules/requests-oauthlib { };

  requests-pkcs12 = callPackage ../development/python-modules/requests-pkcs12 { };

  requests-ratelimiter = callPackage ../development/python-modules/requests-ratelimiter { };

  requests-toolbelt = callPackage ../development/python-modules/requests-toolbelt { };

  requests-unixsocket = callPackage ../development/python-modules/requests-unixsocket { };

  requests-wsgi-adapter = callPackage ../development/python-modules/requests-wsgi-adapter { };

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

  retry = callPackage ../development/python-modules/retry { };

  retry-decorator = callPackage ../development/python-modules/retry-decorator { };

  retrying = callPackage ../development/python-modules/retrying { };

  returns = callPackage ../development/python-modules/returns { };

  reuse = callPackage ../development/python-modules/reuse { };

  rfc3339 = callPackage ../development/python-modules/rfc3339 { };

  rfc3339-validator = callPackage ../development/python-modules/rfc3339-validator { };

  rfc3986 = callPackage ../development/python-modules/rfc3986 { };

  rfc3986-validator = callPackage ../development/python-modules/rfc3986-validator { };

  rfc3987 = callPackage ../development/python-modules/rfc3987 { };

  rfc6555 = callPackage ../development/python-modules/rfc6555 { };

  rfc7464 = callPackage ../development/python-modules/rfc7464 { };

  rfcat = callPackage ../development/python-modules/rfcat { };

  rflink = callPackage ../development/python-modules/rflink { };

  rich = callPackage ../development/python-modules/rich { };

  rich-argparse = callPackage ../development/python-modules/rich-argparse { };

  rich-argparse-plus = callPackage ../development/python-modules/rich-argparse-plus { };

  rich-click = callPackage ../development/python-modules/rich-click { };

  rich-pixels = callPackage ../development/python-modules/rich-pixels { };

  rich-rst = callPackage ../development/python-modules/rich-rst { };

  ring-doorbell = callPackage ../development/python-modules/ring-doorbell { };

  ripe-atlas-cousteau = callPackage ../development/python-modules/ripe-atlas-cousteau { };

  ripe-atlas-sagan = callPackage ../development/python-modules/ripe-atlas-sagan { };

  riprova = callPackage ../development/python-modules/riprova { };

  ripser = callPackage ../development/python-modules/ripser { };

  riscof = callPackage ../development/python-modules/riscof { };

  riscv-config = callPackage ../development/python-modules/riscv-config { };

  riscv-isac = callPackage ../development/python-modules/riscv-isac { };

  rising = callPackage ../development/python-modules/rising { };

  ritassist = callPackage ../development/python-modules/ritassist { };

  rivet = toPythonModule (pkgs.rivet.override {
    python3 = python;
  });

  rjpl = callPackage ../development/python-modules/rjpl { };

  rjsmin = callPackage ../development/python-modules/rjsmin { };

  rki-covid-parser = callPackage ../development/python-modules/rki-covid-parser { };

  rkm-codes = callPackage ../development/python-modules/rkm-codes { };

  rlax = callPackage ../development/python-modules/rlax { };

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

  robot-detection = callPackage ../development/python-modules/robot-detection { };

  robotframework = callPackage ../development/python-modules/robotframework { };

  robotframework-databaselibrary = callPackage ../development/python-modules/robotframework-databaselibrary { };

  robotframework-excellib = callPackage ../development/python-modules/robotframework-excellib { };

  robotframework-pythonlibcore = callPackage ../development/python-modules/robotframework-pythonlibcore { };

  robotframework-requests = callPackage ../development/python-modules/robotframework-requests { };

  robotframework-selenium2library = callPackage ../development/python-modules/robotframework-selenium2library { };

  robotframework-seleniumlibrary = callPackage ../development/python-modules/robotframework-seleniumlibrary { };

  robotframework-sshlibrary = callPackage ../development/python-modules/robotframework-sshlibrary { };

  robotframework-tools = callPackage ../development/python-modules/robotframework-tools { };

  robotstatuschecker = callPackage ../development/python-modules/robotstatuschecker { };

  robotsuite = callPackage ../development/python-modules/robotsuite { };

  rocket-errbot = callPackage ../development/python-modules/rocket-errbot { };

  roku = callPackage ../development/python-modules/roku { };

  rokuecp = callPackage ../development/python-modules/rokuecp { };

  rollbar = callPackage ../development/python-modules/rollbar { };

  roman = callPackage ../development/python-modules/roman { };

  roombapy = callPackage ../development/python-modules/roombapy { };

  roonapi = callPackage ../development/python-modules/roonapi { };

  ronin = callPackage ../development/python-modules/ronin { };

  rope = callPackage ../development/python-modules/rope { };

  ropgadget = callPackage ../development/python-modules/ropgadget { };

  ropper = callPackage ../development/python-modules/ropper { };

  rotary-embedding-torch = callPackage ../development/python-modules/rotary-embedding-torch { };

  rouge-score = callPackage ../development/python-modules/rouge-score { };

  routeros-api = callPackage ../development/python-modules/routeros-api { };

  routes = callPackage ../development/python-modules/routes { };

  rova = callPackage ../development/python-modules/rova { };

  rpcq = callPackage ../development/python-modules/rpcq { };

  rpdb = callPackage ../development/python-modules/rpdb { };

  rpds-py = callPackage ../development/python-modules/rpds-py { };

  rpi-bad-power = callPackage ../development/python-modules/rpi-bad-power { };

  rpi-gpio = callPackage ../development/python-modules/rpi-gpio { };

  rpi-gpio2 = callPackage ../development/python-modules/rpi-gpio2 { };

  rplcd = callPackage ../development/python-modules/rplcd { };

  rply = callPackage ../development/python-modules/rply { };

  rpm = toPythonModule (pkgs.rpm.override {
    inherit python;
  });

  rpmfile = callPackage ../development/python-modules/rpmfile { };

  rpmfluff = callPackage ../development/python-modules/rpmfluff { };

  rpy2 = callPackage ../development/python-modules/rpy2 { };

  rpyc = callPackage ../development/python-modules/rpyc { };

  rpyc4 = callPackage ../development/python-modules/rpyc4 { };

  rq = callPackage ../development/python-modules/rq {
    redis-server = pkgs.redis;
  };

  rsa = callPackage ../development/python-modules/rsa { };

  rsskey = callPackage ../development/python-modules/rsskey { };

  rst2ansi = callPackage ../development/python-modules/rst2ansi { };

  rst2pdf = callPackage ../development/python-modules/rst2pdf { };

  rstcheck = callPackage ../development/python-modules/rstcheck { };

  rstcheck-core = callPackage ../development/python-modules/rstcheck-core { };

  rstr = callPackage ../development/python-modules/rstr { };

  rtmidi-python = callPackage ../development/python-modules/rtmidi-python {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreAudio CoreMIDI CoreServices;
  };

  rtoml = callPackage ../development/python-modules/rtoml { };

  rtp = callPackage ../development/python-modules/rtp { };

  rtree = callPackage ../development/python-modules/rtree {
    inherit (pkgs) libspatialindex;
  };

  rtslib = callPackage ../development/python-modules/rtslib { };

  rtsp-to-webrtc = callPackage ../development/python-modules/rtsp-to-webrtc { };

  ruamel-base = callPackage ../development/python-modules/ruamel-base { };

  ruamel-yaml = callPackage ../development/python-modules/ruamel-yaml { };

  ruamel-yaml-clib = callPackage ../development/python-modules/ruamel-yaml-clib { };

  rubymarshal = callPackage ../development/python-modules/rubymarshal { };

  ruffus = callPackage ../development/python-modules/ruffus { };

  rules = callPackage ../development/python-modules/rules { };

  runs = callPackage ../development/python-modules/runs { };

  ruuvitag-ble = callPackage ../development/python-modules/ruuvitag-ble { };

  ruyaml = callPackage ../development/python-modules/ruyaml { };

  rx = callPackage ../development/python-modules/rx { };

  rxv = callPackage ../development/python-modules/rxv { };

  rzpipe = callPackage ../development/python-modules/rzpipe { };

  s2clientprotocol = callPackage ../development/python-modules/s2clientprotocol { };

  s3fs = callPackage ../development/python-modules/s3fs { };

  s3transfer = callPackage ../development/python-modules/s3transfer { };

  s3-credentials = callPackage ../development/python-modules/s3-credentials { };

  sabctools = callPackage ../development/python-modules/sabctools { };

  sabyenc3 = callPackage ../development/python-modules/sabyenc3 { };

  sabyenc = callPackage ../development/python-modules/sabyenc { };

  sacn = callPackage ../development/python-modules/sacn { };

  sacrebleu = callPackage ../development/python-modules/sacrebleu { };

  sacremoses = callPackage ../development/python-modules/sacremoses { };

  safe = callPackage ../development/python-modules/safe { };

  safe-pysha3 = callPackage ../development/python-modules/safe-pysha3 { };

  safeio = callPackage ../development/python-modules/safeio { };

  safetensors = callPackage ../development/python-modules/safetensors { };

  safety = callPackage ../development/python-modules/safety { };

  safety-schemas = callPackage ../development/python-modules/safety-schemas { };

  sagemaker = callPackage ../development/python-modules/sagemaker { };

  salmon-mail = callPackage ../development/python-modules/salmon-mail { };

  sane = callPackage ../development/python-modules/sane {
    inherit (pkgs) sane-backends;
  };

  saneyaml = callPackage ../development/python-modules/saneyaml { };

  sampledata = callPackage ../development/python-modules/sampledata { };

  samplerate = callPackage ../development/python-modules/samplerate {
    inherit (pkgs) libsamplerate;
  };

  samsungctl = callPackage ../development/python-modules/samsungctl { };

  samsungtvws = callPackage ../development/python-modules/samsungtvws { };

  sanic = callPackage ../development/python-modules/sanic {
    # Don't pass any `sanic` to avoid dependency loops.  `sanic-testing`
    # has special logic to disable tests when this is the case.
    sanic-testing = self.sanic-testing.override { sanic = null; };
  };

  sanic-auth = callPackage ../development/python-modules/sanic-auth { };

  sanic-routing = callPackage ../development/python-modules/sanic-routing { };

  sanic-testing = callPackage ../development/python-modules/sanic-testing { };

  sansio-multipart = callPackage ../development/python-modules/sansio-multipart { };

  sarif-om = callPackage ../development/python-modules/sarif-om { };

  sarge = callPackage ../development/python-modules/sarge { };

  sasmodels = callPackage ../development/python-modules/sasmodels { };

  scales = callPackage ../development/python-modules/scales { };

  scancode-toolkit = callPackage ../development/python-modules/scancode-toolkit { };

  scapy = callPackage ../development/python-modules/scapy {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  schedule = callPackage ../development/python-modules/schedule { };

  schema = callPackage ../development/python-modules/schema { };

  schemainspect = callPackage ../development/python-modules/schemainspect { };

  schema-salad = callPackage ../development/python-modules/schema-salad { };

  schemdraw = callPackage ../development/python-modules/schemdraw { };

  schiene = callPackage ../development/python-modules/schiene { };

  schwifty = callPackage ../development/python-modules/schwifty { };

  scim2-filter-parser = callPackage ../development/python-modules/scim2-filter-parser { };

  scikit-bio = callPackage ../development/python-modules/scikit-bio { };

  scikit-build = callPackage ../development/python-modules/scikit-build { };

  scikit-build-core = callPackage ../development/python-modules/scikit-build-core { };

  scikit-fmm = callPackage ../development/python-modules/scikit-fmm { };

  scikit-fuzzy = callPackage ../development/python-modules/scikit-fuzzy { };

  scikit-hep-testdata = callPackage ../development/python-modules/scikit-hep-testdata { };

  scikit-image = callPackage ../development/python-modules/scikit-image { };

  scikit-learn = callPackage ../development/python-modules/scikit-learn {
    inherit (pkgs) gfortran glibcLocales;
  };

  scikit-learn-extra = callPackage ../development/python-modules/scikit-learn-extra { };

  scikit-misc = callPackage ../development/python-modules/scikit-misc { };

  scikit-optimize = callPackage ../development/python-modules/scikit-optimize { };

  scikit-posthocs = callPackage ../development/python-modules/scikit-posthocs { };

  scikit-rf = callPackage ../development/python-modules/scikit-rf { };

  scikits-odes = callPackage ../development/python-modules/scikits-odes { };

  scikits-samplerate = callPackage ../development/python-modules/scikits-samplerate {
    inherit (pkgs) libsamplerate;
  };

  scikit-tda = callPackage ../development/python-modules/scikit-tda { };

  scipy = callPackage ../development/python-modules/scipy { };

  scmrepo = callPackage ../development/python-modules/scmrepo { };

  scour = callPackage ../development/python-modules/scour { };

  scooby = callPackage ../development/python-modules/scooby { };

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

  scikit-survival = callPackage ../development/python-modules/scikit-survival { };

  scs = callPackage ../development/python-modules/scs {
    inherit (pkgs.darwin.apple_sdk.frameworks) Accelerate;
  };

  sdds = callPackage ../development/python-modules/sdds { };

  sdkmanager = callPackage ../development/python-modules/sdkmanager { };

  sdnotify = callPackage ../development/python-modules/sdnotify { };

  seaborn = callPackage ../development/python-modules/seaborn { };

  seabreeze = callPackage ../development/python-modules/seabreeze { };

  seaserv = toPythonModule (pkgs.seafile-server.override {
    python3 = self.python;
  });

  seasonal = callPackage ../development/python-modules/seasonal { };

  seatconnect = callPackage ../development/python-modules/seatconnect { };

  seccomp = callPackage ../development/python-modules/seccomp { };

  secp256k1 = callPackage ../development/python-modules/secp256k1 {
    inherit (pkgs) secp256k1;
  };

  secretstorage = callPackage ../development/python-modules/secretstorage { };

  secure = callPackage ../development/python-modules/secure { };

  securesystemslib = callPackage ../development/python-modules/securesystemslib { };

  securetar = callPackage ../development/python-modules/securetar { };

  sectools = callPackage ../development/python-modules/sectools { };

  seedir = callPackage ../development/python-modules/seedir { };

  seekpath = callPackage ../development/python-modules/seekpath { };

  segments = callPackage ../development/python-modules/segments { };

  segno = callPackage ../development/python-modules/segno { };

  segyio = toPythonModule (callPackage ../development/python-modules/segyio {
    inherit (pkgs) cmake ninja;
  });

  selectors2 = callPackage ../development/python-modules/selectors2 { };

  selenium = callPackage ../development/python-modules/selenium { };

  selenium-wire = callPackage ../development/python-modules/selenium-wire { };

  semantic-version = callPackage ../development/python-modules/semantic-version { };

  semaphore-bot = callPackage ../development/python-modules/semaphore-bot { };

  semver = callPackage ../development/python-modules/semver { };

  send2trash = callPackage ../development/python-modules/send2trash { };

  sendgrid = callPackage ../development/python-modules/sendgrid { };

  sense-energy = callPackage ../development/python-modules/sense-energy { };

  sensirion-ble = callPackage ../development/python-modules/sensirion-ble { };

  sensor-state-data = callPackage ../development/python-modules/sensor-state-data { };

  sensorpro-ble = callPackage ../development/python-modules/sensorpro-ble { };

  sensorpush-ble = callPackage ../development/python-modules/sensorpush-ble { };

  sentencepiece = callPackage ../development/python-modules/sentencepiece {
    inherit (pkgs) sentencepiece;
  };

  sentence-splitter = callPackage ../development/python-modules/sentence-splitter { };

  sentence-transformers = callPackage ../development/python-modules/sentence-transformers { };

  sentinel = callPackage ../development/python-modules/sentinel { };

  sentinels = callPackage ../development/python-modules/sentinels { };

  sentry-sdk = callPackage ../development/python-modules/sentry-sdk { };

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

  setproctitle = callPackage ../development/python-modules/setproctitle { };

  setupmeta = callPackage ../development/python-modules/setupmeta { };

  setuptools-changelog-shortener = callPackage ../development/python-modules/setuptools-changelog-shortener { };

  setuptools-declarative-requirements = callPackage ../development/python-modules/setuptools-declarative-requirements { };

  setuptools_dso = callPackage ../development/python-modules/setuptools_dso { };

  setuptools-generate = callPackage ../development/python-modules/setuptools-generate { };

  setuptools-gettext = callPackage ../development/python-modules/setuptools-gettext { };

  setuptools-git = callPackage ../development/python-modules/setuptools-git { };

  setuptools-git-versioning = callPackage ../development/python-modules/setuptools-git-versioning { };

  setuptools-lint = callPackage ../development/python-modules/setuptools-lint { };

  setuptools-odoo = callPackage ../development/python-modules/setuptools-odoo { };

  setuptools-rust = callPackage ../development/python-modules/setuptools-rust { };

  setuptools-scm = callPackage ../development/python-modules/setuptools-scm { };

  setuptools-scm-git-archive = callPackage ../development/python-modules/setuptools-scm-git-archive { };

  setuptools-trial = callPackage ../development/python-modules/setuptools-trial { };

  seventeentrack = callPackage ../development/python-modules/seventeentrack { };

  sexpdata = callPackage ../development/python-modules/sexpdata { };

  sfepy = callPackage ../development/python-modules/sfepy { };

  sfrbox-api = callPackage ../development/python-modules/sfrbox-api { };

  sgmllib3k = callPackage ../development/python-modules/sgmllib3k { };

  sgp4 = callPackage ../development/python-modules/sgp4 { };

  shamir-mnemonic = callPackage ../development/python-modules/shamir-mnemonic { };

  shap = callPackage ../development/python-modules/shap { };

  shapely = callPackage ../development/python-modules/shapely { };

  shapely_1_8 = callPackage ../development/python-modules/shapely/1.8.nix { };

  shaperglot = callPackage ../development/python-modules/shaperglot { };

  sharedmem = callPackage ../development/python-modules/sharedmem { };

  sharkiq = callPackage ../development/python-modules/sharkiq { };

  sharp-aquos-rc = callPackage ../development/python-modules/sharp-aquos-rc { };

  shazamio = callPackage ../development/python-modules/shazamio { };

  sh = callPackage ../development/python-modules/sh { };

  shlib = callPackage ../development/python-modules/shlib { };

  shellescape = callPackage ../development/python-modules/shellescape { };

  shellingham = callPackage ../development/python-modules/shellingham { };

  shiboken2 = toPythonModule (callPackage ../development/python-modules/shiboken2 {
    inherit (pkgs) cmake llvmPackages_15 qt5;
  });

  shiboken6 = toPythonModule (callPackage ../development/python-modules/shiboken6 {
    inherit (pkgs) cmake llvmPackages;
  });

  shippai = callPackage ../development/python-modules/shippai { };

  shiv = callPackage ../development/python-modules/shiv { };

  shodan = callPackage ../development/python-modules/shodan { };

  shortuuid = callPackage ../development/python-modules/shortuuid { };

  shouldbe = callPackage ../development/python-modules/shouldbe { };

  should-dsl = callPackage ../development/python-modules/should-dsl { };

  show-in-file-manager = callPackage ../development/python-modules/show-in-file-manager { };

  showit = callPackage ../development/python-modules/showit { };

  shtab = callPackage ../development/python-modules/shtab { };

  shutilwhich = callPackage ../development/python-modules/shutilwhich { };

  sievelib = callPackage ../development/python-modules/sievelib { };

  signalslot = callPackage ../development/python-modules/signalslot { };

  signedjson = callPackage ../development/python-modules/signedjson { };

  signxml = callPackage ../development/python-modules/signxml { };

  sigrok = callPackage ../development/python-modules/sigrok { };

  sigstore = callPackage ../development/python-modules/sigstore { };

  sigstore-protobuf-specs = callPackage ../development/python-modules/sigstore-protobuf-specs { };

  sigstore-rekor-types = callPackage ../development/python-modules/sigstore-rekor-types { };

  sigtools = callPackage ../development/python-modules/sigtools { };

  simanneal = callPackage ../development/python-modules/simanneal { };

  simber = callPackage ../development/python-modules/simber { };

  simple-term-menu = callPackage ../development/python-modules/simple-term-menu { };

  simpleaudio = callPackage ../development/python-modules/simpleaudio { };

  simplebayes = callPackage ../development/python-modules/simplebayes { };

  simpleeval = callPackage ../development/python-modules/simpleeval { };

  simplefix = callPackage ../development/python-modules/simplefix { };

  simplegeneric = callPackage ../development/python-modules/simplegeneric { };

  simplehound = callPackage ../development/python-modules/simplehound { };

  simpleitk = callPackage ../development/python-modules/simpleitk {
    inherit (pkgs) simpleitk;
  };

  simplejson = callPackage ../development/python-modules/simplejson { };

  simplekml = callPackage ../development/python-modules/simplekml { };

  simplekv = callPackage ../development/python-modules/simplekv { };

  simplemma = callPackage ../development/python-modules/simplemma { };

  simplenote = callPackage ../development/python-modules/simplenote { };

  simplepush = callPackage ../development/python-modules/simplepush { };

  simplesat = callPackage ../development/python-modules/simplesat { };

  simple-dftd3 = callPackage ../development/libraries/science/chemistry/simple-dftd3/python.nix {
    inherit (pkgs) simple-dftd3;
  };

  simple-di = callPackage ../development/python-modules/simple-di { };

  simple-rest-client = callPackage ../development/python-modules/simple-rest-client { };

  simple-rlp = callPackage ../development/python-modules/simple-rlp { };

  simple-salesforce = callPackage ../development/python-modules/simple-salesforce { };

  simple-websocket = callPackage ../development/python-modules/simple-websocket { };

  simple-websocket-server = callPackage ../development/python-modules/simple-websocket-server { };

  simplisafe-python = callPackage ../development/python-modules/simplisafe-python { };

  simpful = callPackage ../development/python-modules/simpful { };

  simpy = callPackage ../development/python-modules/simpy { };

  single-source = callPackage ../development/python-modules/single-source { };

  single-version = callPackage ../development/python-modules/single-version { };

  signify = callPackage ../development/python-modules/signify { };

  siobrultech-protocols = callPackage ../development/python-modules/siobrultech-protocols { };

  siosocks = callPackage ../development/python-modules/siosocks { };

  sip = callPackage ../development/python-modules/sip { };

  sip4 = callPackage ../development/python-modules/sip/4.x.nix { };

  sipyco = callPackage ../development/python-modules/sipyco { };

  sisyphus-control = callPackage ../development/python-modules/sisyphus-control { };

  siuba = callPackage ../development/python-modules/siuba { };

  six = callPackage ../development/python-modules/six { };

  sjcl = callPackage ../development/python-modules/sjcl { };

  skein = callPackage ../development/python-modules/skein { };

  skidl = callPackage ../development/python-modules/skidl { };

  skl2onnx = callPackage ../development/python-modules/skl2onnx { };

  sklearn-deap = callPackage ../development/python-modules/sklearn-deap { };

  skodaconnect = callPackage ../development/python-modules/skodaconnect { };

  skorch = callPackage ../development/python-modules/skorch { };

  skrl = callPackage ../development/python-modules/skrl { };

  skybellpy = callPackage ../development/python-modules/skybellpy { };

  skyfield = callPackage ../development/python-modules/skyfield { };

  skytemple-dtef = callPackage ../development/python-modules/skytemple-dtef { };

  skytemple-eventserver = callPackage ../development/python-modules/skytemple-eventserver { };

  skytemple-files = callPackage ../development/python-modules/skytemple-files { };

  skytemple-icons = callPackage ../development/python-modules/skytemple-icons { };

  skytemple-rust = callPackage ../development/python-modules/skytemple-rust {
    inherit (pkgs.darwin.apple_sdk.frameworks) Foundation;
  };

  skytemple-ssb-debugger = callPackage ../development/python-modules/skytemple-ssb-debugger { };

  skytemple-ssb-emulator = callPackage ../development/python-modules/skytemple-ssb-emulator { };

  slack-bolt = callPackage ../development/python-modules/slack-bolt { };

  slack-sdk = callPackage ../development/python-modules/slack-sdk { };

  slackclient = callPackage ../development/python-modules/slackclient { };

  sleekxmpp = callPackage ../development/python-modules/sleekxmpp { };

  sleepyq = callPackage ../development/python-modules/sleepyq { };

  slicedimage = callPackage ../development/python-modules/slicedimage { };

  slicer = callPackage ../development/python-modules/slicer { };

  slicerator = callPackage ../development/python-modules/slicerator { };

  slither-analyzer = callPackage ../development/python-modules/slither-analyzer { };

  slimit = callPackage ../development/python-modules/slimit { };

  slixmpp = callPackage ../development/python-modules/slixmpp {
    inherit (pkgs) gnupg;
  };

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

  smpplib = callPackage ../development/python-modules/smpplib { };

  smpp-pdu = callPackage ../development/python-modules/smpp.pdu { };

  smtpdfix = callPackage ../development/python-modules/smtpdfix { };

  snack = toPythonModule (pkgs.newt.override {
    inherit (self) python;
  });

  snakemake-executor-plugin-cluster-generic = callPackage ../development/python-modules/snakemake-executor-plugin-cluster-generic { };

  snakemake-interface-common = callPackage ../development/python-modules/snakemake-interface-common { };

  snakemake-interface-executor-plugins = callPackage ../development/python-modules/snakemake-interface-executor-plugins { };

  snakemake-interface-storage-plugins = callPackage ../development/python-modules/snakemake-interface-storage-plugins { };

  snakebite = callPackage ../development/python-modules/snakebite { };

  snakeviz = callPackage ../development/python-modules/snakeviz { };

  snapcast = callPackage ../development/python-modules/snapcast { };

  snapshottest = callPackage ../development/python-modules/snapshottest { };

  snaptime = callPackage ../development/python-modules/snaptime { };

  sniffio = callPackage ../development/python-modules/sniffio { };

  snitun = callPackage ../development/python-modules/snitun { };

  snorkel = callPackage ../development/python-modules/snorkel { };

  snowballstemmer = callPackage ../development/python-modules/snowballstemmer { };

  snowflake-connector-python = callPackage ../development/python-modules/snowflake-connector-python { };

  snowflake-sqlalchemy = callPackage ../development/python-modules/snowflake-sqlalchemy { };

  snscrape = callPackage ../development/python-modules/snscrape { };

  snuggs = callPackage ../development/python-modules/snuggs { };

  soapysdr = toPythonModule (pkgs.soapysdr.override {
    inherit (self) python;
    usePython = true;
  });

  soapysdr-with-plugins = toPythonModule (pkgs.soapysdr-with-plugins.override {
    inherit (self) python;
    usePython = true;
  });

  socketio-client = callPackage ../development/python-modules/socketio-client { };

  social-auth-app-django = callPackage ../development/python-modules/social-auth-app-django { };

  social-auth-core = callPackage ../development/python-modules/social-auth-core { };

  socialscan = callPackage ../development/python-modules/socialscan { };

  socid-extractor =  callPackage ../development/python-modules/socid-extractor { };

  sockio = callPackage ../development/python-modules/sockio { };

  sockjs = callPackage ../development/python-modules/sockjs { };

  sockjs-tornado = callPackage ../development/python-modules/sockjs-tornado { };

  socksio = callPackage ../development/python-modules/socksio { };

  socksipy-branch = callPackage ../development/python-modules/socksipy-branch { };

  soco = callPackage ../development/python-modules/soco { };

  softlayer = callPackage ../development/python-modules/softlayer { };

  solaredge = callPackage ../development/python-modules/solaredge { };

  solax = callPackage ../development/python-modules/solax { };

  solc-select = callPackage ../development/python-modules/solc-select { };

  solo-python = disabledIf (!pythonAtLeast "3.6") (callPackage ../development/python-modules/solo-python { });

  somajo = callPackage ../development/python-modules/somajo { };

  somfy-mylink-synergy = callPackage ../development/python-modules/somfy-mylink-synergy { };

  sonarr = callPackage ../development/python-modules/sonarr { };

  sonos-websocket = callPackage ../development/python-modules/sonos-websocket { };

  sopel = callPackage ../development/python-modules/sopel { };

  sorl-thumbnail = callPackage ../development/python-modules/sorl-thumbnail { };

  sortedcollections = callPackage ../development/python-modules/sortedcollections { };

  sortedcontainers = callPackage ../development/python-modules/sortedcontainers { };

  soundcloud-v2 = callPackage ../development/python-modules/soundcloud-v2 { };

  sounddevice = callPackage ../development/python-modules/sounddevice { };

  soundfile = callPackage ../development/python-modules/soundfile { };

  soupsieve = callPackage ../development/python-modules/soupsieve { };

  sourmash = callPackage ../development/python-modules/sourmash { };

  soxr = callPackage ../development/python-modules/soxr {
    libsoxr = pkgs.soxr;
  };

  spacy = callPackage ../development/python-modules/spacy { };

  spacy-alignments = callPackage ../development/python-modules/spacy-alignments { };

  spacy-legacy = callPackage ../development/python-modules/spacy/legacy.nix { };

  spacy-loggers = callPackage ../development/python-modules/spacy-loggers { };

  spacy-lookups-data = callPackage ../development/python-modules/spacy/lookups-data.nix { };

  spacy_models = callPackage ../development/python-modules/spacy/models.nix {
      inherit (pkgs) jq;
  };

  spacy-pkuseg = callPackage ../development/python-modules/spacy-pkuseg { };

  spacy-transformers = callPackage ../development/python-modules/spacy-transformers { };

  spake2 = callPackage ../development/python-modules/spake2 { };

  spark-parser = callPackage ../development/python-modules/spark-parser { };

  sparklines = callPackage ../development/python-modules/sparklines { };

  sparqlwrapper = callPackage ../development/python-modules/sparqlwrapper { };

  sparse = callPackage ../development/python-modules/sparse { };

  spatial-image = callPackage ../development/python-modules/spatial-image { };

  spdx-tools = callPackage ../development/python-modules/spdx-tools { };

  speaklater = callPackage ../development/python-modules/speaklater { };

  speaklater3 = callPackage ../development/python-modules/speaklater3 { };

  spectral-cube = callPackage ../development/python-modules/spectral-cube { };

  speechbrain = callPackage ../development/python-modules/speechbrain { };

  speechrecognition = callPackage ../development/python-modules/speechrecognition { };

  speedtest-cli = callPackage ../development/python-modules/speedtest-cli { };

  speg = callPackage ../development/python-modules/speg { };

  spglib = callPackage ../development/python-modules/spglib { };

  sphfile = callPackage ../development/python-modules/sphfile { };

  spiderpy = callPackage ../development/python-modules/spiderpy { };

  spinners = callPackage ../development/python-modules/spinners { };

  sphinx-automodapi = callPackage ../development/python-modules/sphinx-automodapi {
    graphviz = pkgs.graphviz;
  };

  sphinx-better-theme = callPackage ../development/python-modules/sphinx-better-theme { };

  sphinx-book-theme = callPackage ../development/python-modules/sphinx-book-theme { };

  sphinx-codeautolink = callPackage ../development/python-modules/sphinx-codeautolink { };

  sphinx-comments = callPackage ../development/python-modules/sphinx-comments { };

  sphinx-design = callPackage ../development/python-modules/sphinx-design { };

  sphinx-external-toc = callPackage ../development/python-modules/sphinx-external-toc { };

  sphinx-fortran = callPackage ../development/python-modules/sphinx-fortran { };

  sphinx-hoverxref = callPackage ../development/python-modules/sphinx-hoverxref { };

  sphinx-intl = callPackage ../development/python-modules/sphinx-intl { };

  sphinx-jupyterbook-latex = callPackage ../development/python-modules/sphinx-jupyterbook-latex { };

  sphinx-multitoc-numbering = callPackage ../development/python-modules/sphinx-multitoc-numbering { };

  sphinx-notfound-page = callPackage ../development/python-modules/sphinx-notfound-page { };

  sphinx-pytest = callPackage ../development/python-modules/sphinx-pytest { };

  sphinx-prompt = callPackage ../development/python-modules/sphinx-prompt { };

  sphinx-sitemap = callPackage ../development/python-modules/sphinx-sitemap { };

  sphinx-thebe = callPackage ../development/python-modules/sphinx-thebe { };

  sphinx-tabs = callPackage ../development/python-modules/sphinx-tabs { };

  sphinx-togglebutton = callPackage ../development/python-modules/sphinx-togglebutton { };

  sphinxcontrib-actdiag = callPackage ../development/python-modules/sphinxcontrib-actdiag { };

  sphinxcontrib-apidoc = callPackage ../development/python-modules/sphinxcontrib-apidoc { };

  sphinxcontrib-applehelp = callPackage ../development/python-modules/sphinxcontrib-applehelp { };

  sphinxcontrib-asyncio = callPackage ../development/python-modules/sphinxcontrib-asyncio { };

  sphinx-autoapi = callPackage ../development/python-modules/sphinx-autoapi { };

  sphinxcontrib-bayesnet = callPackage ../development/python-modules/sphinxcontrib-bayesnet { };

  sphinxcontrib-bibtex = callPackage ../development/python-modules/sphinxcontrib-bibtex { };

  sphinxcontrib-blockdiag = callPackage ../development/python-modules/sphinxcontrib-blockdiag { };

  sphinxcontrib-confluencebuilder = callPackage ../development/python-modules/sphinxcontrib-confluencebuilder { };

  sphinxcontrib-devhelp = callPackage ../development/python-modules/sphinxcontrib-devhelp { };

  sphinxcontrib-excel-table = callPackage ../development/python-modules/sphinxcontrib-excel-table { };

  sphinxcontrib-fulltoc = callPackage ../development/python-modules/sphinxcontrib-fulltoc { };

  sphinxcontrib-htmlhelp = callPackage ../development/python-modules/sphinxcontrib-htmlhelp { };

  sphinxcontrib-httpdomain = callPackage ../development/python-modules/sphinxcontrib-httpdomain { };

  sphinxcontrib-jquery = callPackage ../development/python-modules/sphinxcontrib-jquery { };

  sphinxcontrib-jsmath = callPackage ../development/python-modules/sphinxcontrib-jsmath { };

  sphinxcontrib-katex = callPackage ../development/python-modules/sphinxcontrib-katex { };

  sphinxcontrib-mscgen = callPackage ../development/python-modules/sphinxcontrib-mscgen {
    inherit (pkgs) mscgen;
  };

  sphinxcontrib-log-cabinet = callPackage ../development/python-modules/sphinxcontrib-log-cabinet { };

  sphinxcontrib-nwdiag = callPackage ../development/python-modules/sphinxcontrib-nwdiag { };

  sphinxcontrib-newsfeed = callPackage ../development/python-modules/sphinxcontrib-newsfeed { };

  sphinxcontrib-openapi = callPackage ../development/python-modules/sphinxcontrib-openapi { };

  sphinxcontrib-plantuml = callPackage ../development/python-modules/sphinxcontrib-plantuml {
    inherit (pkgs) plantuml;
  };

  sphinxcontrib-programoutput = callPackage ../development/python-modules/sphinxcontrib-programoutput { };

  sphinxcontrib-qthelp = callPackage ../development/python-modules/sphinxcontrib-qthelp { };

  sphinxcontrib-serializinghtml = callPackage ../development/python-modules/sphinxcontrib-serializinghtml { };

  sphinxcontrib-seqdiag = callPackage ../development/python-modules/sphinxcontrib-seqdiag { };

  sphinxcontrib-spelling = callPackage ../development/python-modules/sphinxcontrib-spelling { };

  sphinxcontrib-tikz = callPackage ../development/python-modules/sphinxcontrib-tikz { };

  sphinxcontrib-wavedrom = callPackage ../development/python-modules/sphinxcontrib-wavedrom { };

  sphinxcontrib-websupport = callPackage ../development/python-modules/sphinxcontrib-websupport { };

  sphinxcontrib-youtube = callPackage ../development/python-modules/sphinxcontrib-youtube { };

  sphinx = callPackage ../development/python-modules/sphinx { };

  sphinx-argparse = callPackage ../development/python-modules/sphinx-argparse { };

  sphinx-autobuild = callPackage ../development/python-modules/sphinx-autobuild { };

  sphinx-autodoc-typehints = callPackage ../development/python-modules/sphinx-autodoc-typehints { };

  sphinx-basic-ng = callPackage ../development/python-modules/sphinx-basic-ng { };

  sphinx-copybutton = callPackage ../development/python-modules/sphinx-copybutton { };

  sphinxemoji = callPackage ../development/python-modules/sphinxemoji { };

  sphinx-inline-tabs = callPackage ../development/python-modules/sphinx-inline-tabs { };

  sphinx-issues = callPackage ../development/python-modules/sphinx-issues { };

  sphinx-jinja = callPackage ../development/python-modules/sphinx-jinja { };

  sphinx-markdown-parser = callPackage ../development/python-modules/sphinx-markdown-parser { };

  sphinx-markdown-tables = callPackage ../development/python-modules/sphinx-markdown-tables { };

  sphinx-material = callPackage ../development/python-modules/sphinx-material { };

  sphinx-mdinclude = callPackage ../development/python-modules/sphinx-mdinclude { };

  sphinx-rtd-theme = callPackage ../development/python-modules/sphinx-rtd-theme { };

  sphinx-serve = callPackage ../development/python-modules/sphinx-serve { };

  sphinx-testing = callPackage ../development/python-modules/sphinx-testing { };

  sphinx-version-warning = callPackage ../development/python-modules/sphinx-version-warning { };

  sphinxext-opengraph = callPackage ../development/python-modules/sphinxext-opengraph { };

  spidev = callPackage ../development/python-modules/spidev { };

  splinter = callPackage ../development/python-modules/splinter { };

  spotipy = callPackage ../development/python-modules/spotipy { };

  spsdk = callPackage ../development/python-modules/spsdk { };

  spur = callPackage ../development/python-modules/spur { };

  spyder = callPackage ../development/python-modules/spyder { };

  spyder-kernels = callPackage ../development/python-modules/spyder-kernels { };

  spyse-python = callPackage ../development/python-modules/spyse-python { };

  spython = callPackage ../development/python-modules/spython { };

  sqids = callPackage ../development/python-modules/sqids { };

  sqlalchemy = callPackage ../development/python-modules/sqlalchemy { };

  sqlalchemy_1_4 = callPackage ../development/python-modules/sqlalchemy/1_4.nix { };

  sqlalchemy-citext = callPackage ../development/python-modules/sqlalchemy-citext { };

  sqlalchemy-continuum = callPackage ../development/python-modules/sqlalchemy-continuum { };

  sqlalchemy-i18n = callPackage ../development/python-modules/sqlalchemy-i18n { };

  sqlalchemy-jsonfield = callPackage ../development/python-modules/sqlalchemy-jsonfield { };

  sqlalchemy-migrate = callPackage ../development/python-modules/sqlalchemy-migrate { };

  sqlalchemy-mixins = callPackage ../development/python-modules/sqlalchemy-mixins { };

  sqlalchemy-utils = callPackage ../development/python-modules/sqlalchemy-utils { };

  sqlalchemy-views = callPackage ../development/python-modules/sqlalchemy-views { };

  sqlbag = callPackage ../development/python-modules/sqlbag { };

  sqlglot = callPackage ../development/python-modules/sqlglot { };

  sqlitedict = callPackage ../development/python-modules/sqlitedict { };

  sqlite-migrate = callPackage ../development/python-modules/sqlite-migrate { };

  sqlite-fts4 = callPackage ../development/python-modules/sqlite-fts4 { };

  sqlite-utils = callPackage ../development/python-modules/sqlite-utils { };

  sqlmap = callPackage ../development/python-modules/sqlmap { };

  sqlmodel = callPackage ../development/python-modules/sqlmodel { };

  sqlobject = callPackage ../development/python-modules/sqlobject { };

  sqlparse = callPackage ../development/python-modules/sqlparse { };

  sqlsoup = callPackage ../development/python-modules/sqlsoup { };

  sqltrie = callPackage ../development/python-modules/sqltrie { };

  squarify = callPackage ../development/python-modules/squarify { };

  sre-yield = callPackage ../development/python-modules/sre-yield { };

  srp = callPackage ../development/python-modules/srp { };

  srpenergy = callPackage ../development/python-modules/srpenergy { };

  srptools = callPackage ../development/python-modules/srptools { };

  srsly = callPackage ../development/python-modules/srsly { };

  srt = callPackage ../development/python-modules/srt { };

  srvlookup = callPackage ../development/python-modules/srvlookup { };

  ssdeep = callPackage ../development/python-modules/ssdeep {
    inherit (pkgs) ssdeep;
  };

  ssdp = callPackage ../development/python-modules/ssdp { };

  ssdpy = callPackage ../development/python-modules/ssdpy { };

  sseclient = callPackage ../development/python-modules/sseclient { };

  sseclient-py = callPackage ../development/python-modules/sseclient-py { };

  sshfs = callPackage ../development/python-modules/sshfs { };

  sshpubkeys = callPackage ../development/python-modules/sshpubkeys { };

  sshtunnel = callPackage ../development/python-modules/sshtunnel { };

  sslib = callPackage ../development/python-modules/sslib { };

  stack-data = callPackage ../development/python-modules/stack-data { };

  stanio = callPackage ../development/python-modules/stanio { };

  stanza = callPackage ../development/python-modules/stanza { };

  starlette = callPackage ../development/python-modules/starlette { };

  starlette-wtf = callPackage ../development/python-modules/starlette-wtf { };

  starkbank-ecdsa = callPackage ../development/python-modules/starkbank-ecdsa { };

  starline = callPackage ../development/python-modules/starline { };

  stashy = callPackage ../development/python-modules/stashy { };

  static3 = callPackage ../development/python-modules/static3 { };

  staticmap = callPackage ../development/python-modules/staticmap { };

  staticjinja = callPackage ../development/python-modules/staticjinja { };

  statistics = callPackage ../development/python-modules/statistics { };

  statmake = callPackage ../development/python-modules/statmake { };

  statsd = callPackage ../development/python-modules/statsd { };

  statsmodels = callPackage ../development/python-modules/statsmodels { };

  std-uritemplate = callPackage ../development/python-modules/std-uritemplate { };

  std2 = callPackage ../development/python-modules/std2 { };

  stdiomask = callPackage ../development/python-modules/stdiomask { };

  stdlib-list = callPackage ../development/python-modules/stdlib-list { };

  stdlibs = callPackage ../development/python-modules/stdlibs { };

  steamodd = callPackage ../development/python-modules/steamodd { };

  steamship = callPackage ../development/python-modules/steamship { };

  stem = callPackage ../development/python-modules/stem { };

  stemming = callPackage ../development/python-modules/stemming { };

  stestr = callPackage ../development/python-modules/stestr { };

  stevedore = callPackage ../development/python-modules/stevedore { };

  stickytape = callPackage ../development/python-modules/stickytape { };

  stim = callPackage ../development/python-modules/stim { };

  stix2-patterns = callPackage ../development/python-modules/stix2-patterns { };

  stm32loader = callPackage ../development/python-modules/stm32loader { };

  stone = callPackage ../development/python-modules/stone { };

  stookalert = callPackage ../development/python-modules/stookalert { };

  stopit = callPackage ../development/python-modules/stopit { };

  stransi = callPackage ../development/python-modules/stransi { };

  strategies = callPackage ../development/python-modules/strategies { };

  stravalib = callPackage ../development/python-modules/stravalib { };

  strawberry-graphql = callPackage ../development/python-modules/strawberry-graphql { };

  strct = callPackage ../development/python-modules/strct { };

  streamdeck = callPackage ../development/python-modules/streamdeck { };

  streaming-form-data = callPackage ../development/python-modules/streaming-form-data { };

  streamlabswater = callPackage ../development/python-modules/streamlabswater { };

  streamlit = callPackage ../development/python-modules/streamlit { };

  streamz = callPackage ../development/python-modules/streamz { };

  strenum =  callPackage ../development/python-modules/strenum { };

  strict-rfc3339 = callPackage ../development/python-modules/strict-rfc3339 { };

  strictyaml = callPackage ../development/python-modules/strictyaml { };

  stringbrewer = callPackage ../development/python-modules/stringbrewer { };

  stringcase = callPackage ../development/python-modules/stringcase { };

  stringly = callPackage ../development/python-modules/stringly { };

  stringparser = callPackage ../development/python-modules/stringparser { };

  stripe = callPackage ../development/python-modules/stripe { };

  striprtf = callPackage ../development/python-modules/striprtf { };

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

  subprocess-tee = callPackage ../development/python-modules/subprocess-tee { };

  subunit = callPackage ../development/python-modules/subunit {
    inherit (pkgs) subunit cppunit check;
  };

  subunit2sql = callPackage ../development/python-modules/subunit2sql { };

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

  sumo = callPackage ../development/python-modules/sumo { };

  sumtypes = callPackage ../development/python-modules/sumtypes { };

  summarytools = callPackage ../development/python-modules/summarytools { };

  sunpy = callPackage ../development/python-modules/sunpy { };

  sunwatcher = callPackage ../development/python-modules/sunwatcher { };

  sunweg = callPackage ../development/python-modules/sunweg { };

  supervise-api = callPackage ../development/python-modules/supervise-api { };

  supervisor = callPackage ../development/python-modules/supervisor { };

  superqt = callPackage ../development/python-modules/superqt { };

  sure = callPackage ../development/python-modules/sure { };

  surepy = callPackage ../development/python-modules/surepy { };

  surt = callPackage ../development/python-modules/surt { };

  survey = callPackage ../development/python-modules/survey { };

  svg2tikz = callPackage ../development/python-modules/svg2tikz { };

  svglib = callPackage ../development/python-modules/svglib { };

  svg-path = callPackage ../development/python-modules/svg-path { };

  svg-py = callPackage ../development/python-modules/svg-py { };

  svgelements = callPackage ../development/python-modules/svgelements { };

  svgutils = callPackage ../development/python-modules/svgutils { };

  svgwrite = callPackage ../development/python-modules/svgwrite { };

  sv-ttk = callPackage ../development/python-modules/sv-ttk { };

  swagger-spec-validator = callPackage ../development/python-modules/swagger-spec-validator { };

  swagger-ui-bundle = callPackage ../development/python-modules/swagger-ui-bundle { };

  switchbot-api = callPackage ../development/python-modules/switchbot-api { };

  swift = callPackage ../development/python-modules/swift { };

  swisshydrodata = callPackage ../development/python-modules/swisshydrodata { };

  swspotify = callPackage ../development/python-modules/swspotify { };

  sybil = callPackage ../development/python-modules/sybil { };

  symengine = callPackage ../development/python-modules/symengine {
    inherit (pkgs) symengine;
  };

  sympy = callPackage ../development/python-modules/sympy { };

  symspellpy = callPackage ../development/python-modules/symspellpy { };

  syncedlyrics = callPackage ../development/python-modules/syncedlyrics { };

  syncer = callPackage ../development/python-modules/syncer { };

  synergy = callPackage ../development/python-modules/synergy { };

  synologydsm-api = callPackage ../development/python-modules/synologydsm-api { };

  syslog-rfc5424-formatter = callPackage ../development/python-modules/syslog-rfc5424-formatter { };

  systembridge = callPackage ../development/python-modules/systembridge { };

  systembridgeconnector = callPackage ../development/python-modules/systembridgeconnector { };

  systembridgemodels = callPackage ../development/python-modules/systembridgemodels { };

  systemd = callPackage ../development/python-modules/systemd {
    inherit (pkgs) systemd;
  };

  sysv-ipc = callPackage ../development/python-modules/sysv-ipc { };

  syrupy = callPackage ../development/python-modules/syrupy { };

  tabcmd = callPackage ../development/python-modules/tabcmd { };

  tableaudocumentapi = callPackage ../development/python-modules/tableaudocumentapi { };

  tableauserverclient = callPackage ../development/python-modules/tableauserverclient { };

  tabledata = callPackage ../development/python-modules/tabledata { };

  tables = callPackage ../development/python-modules/tables { };

  tablib = callPackage ../development/python-modules/tablib { };

  tabula-py = callPackage ../development/python-modules/tabula-py { };

  tabulate = callPackage ../development/python-modules/tabulate { };

  tabview = callPackage ../development/python-modules/tabview { };

  taco = toPythonModule (pkgs.taco.override {
    inherit (self) python;
    enablePython = true;
  });

  tadasets = callPackage ../development/python-modules/tadasets { };

  tag-expressions = callPackage ../development/python-modules/tag-expressions { };

  tago = callPackage ../development/python-modules/tago { };

  tagoio-sdk = callPackage ../development/python-modules/tagoio-sdk { };

  tahoma-api = callPackage ../development/python-modules/tahoma-api { };

  tailer = callPackage ../development/python-modules/tailer { };

  tailscale = callPackage ../development/python-modules/tailscale { };

  takethetime = callPackage ../development/python-modules/takethetime { };

  tank-utility = callPackage ../development/python-modules/tank-utility { };

  tappy = callPackage ../development/python-modules/tappy { };

  tasklib = callPackage ../development/python-modules/tasklib { };

  taskw = callPackage ../development/python-modules/taskw { };

  tatsu = callPackage ../development/python-modules/tatsu { };

  taxi = callPackage ../development/python-modules/taxi { };

  tbats = callPackage ../development/python-modules/tbats { };

  tblib = callPackage ../development/python-modules/tblib { };

  tblite = callPackage ../development/libraries/science/chemistry/tblite/python.nix {
    inherit (pkgs) tblite meson simple-dftd3;
  };

  tbm-utils = callPackage ../development/python-modules/tbm-utils { };

  tcolorpy = callPackage ../development/python-modules/tcolorpy { };

  tcxparser = callPackage ../development/python-modules/tcxparser { };

  tcxreader = callPackage ../development/python-modules/tcxreader { };

  tdir = callPackage ../development/python-modules/tdir { };

  teamcity-messages = callPackage ../development/python-modules/teamcity-messages { };

  telegram = callPackage ../development/python-modules/telegram { };

  telegraph = callPackage ../development/python-modules/telegraph { };

  telepath = callPackage ../development/python-modules/telepath { };

  telethon = callPackage ../development/python-modules/telethon {
    inherit (pkgs) openssl;
  };

  telethon-session-sqlalchemy = callPackage ../development/python-modules/telethon-session-sqlalchemy { };

  teletype = callPackage ../development/python-modules/teletype { };

  telfhash = callPackage ../development/python-modules/telfhash { };

  telegram-text = callPackage ../development/python-modules/telegram-text { };

  temescal = callPackage ../development/python-modules/temescal { };

  temperusb = callPackage ../development/python-modules/temperusb { };

  tempest = callPackage ../development/python-modules/tempest { };

  tempita = callPackage ../development/python-modules/tempita { };

  templateflow = callPackage ../development/python-modules/templateflow { };

  tempora = callPackage ../development/python-modules/tempora { };

  tenacity = callPackage ../development/python-modules/tenacity { };

  tencentcloud-sdk-python = callPackage ../development/python-modules/tencentcloud-sdk-python { };

  tensorboard-data-server = callPackage ../development/python-modules/tensorboard-data-server { };

  tensorboard-plugin-profile = callPackage ../development/python-modules/tensorboard-plugin-profile { };

  tensorboard-plugin-wit = callPackage ../development/python-modules/tensorboard-plugin-wit { };

  tensorboard = callPackage ../development/python-modules/tensorboard { };

  tensorboardx = callPackage ../development/python-modules/tensorboardx { };

  tensordict = callPackage ../development/python-modules/tensordict { };

  tensorflow-bin = callPackage ../development/python-modules/tensorflow/bin.nix {
    inherit (pkgs.config) cudaSupport;
  };

  tensorflow-build = let
    compat = rec {
      protobufTF = pkgs.protobuf_21.override {
        abseil-cpp = pkgs.abseil-cpp_202301;
      };
      grpcTF = (pkgs.grpc.overrideAttrs (
        oldAttrs: rec {
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
        })
      ).override {
        protobuf = protobufTF;
      };
      protobuf-pythonTF = self.protobuf.override {
        protobuf = protobufTF;
      };
      grpcioTF = self.grpcio.override {
        protobuf = protobufTF;
        grpc = grpcTF;
      };
      tensorboard-plugin-profileTF = self.tensorboard-plugin-profile.override {
        protobuf = protobuf-pythonTF;
      };
      tensorboardTF = self.tensorboard.override {
        grpcio = grpcioTF;
        protobuf = protobuf-pythonTF;
        tensorboard-plugin-profile = tensorboard-plugin-profileTF;
      };
    };
  in
  callPackage ../development/python-modules/tensorflow {
    inherit (pkgs.darwin) cctools;
    inherit (pkgs.config) cudaSupport;
    inherit (pkgs.darwin.apple_sdk.frameworks) Foundation Security;
    flatbuffers-core = pkgs.flatbuffers;
    flatbuffers-python = self.flatbuffers;
    protobuf-core = compat.protobufTF;
    protobuf-python = compat.protobuf-pythonTF;
    grpc = compat.grpcTF;
    grpcio = compat.grpcioTF;
    tensorboard = compat.tensorboardTF;
    abseil-cpp = pkgs.abseil-cpp_202301;

    # Tensorflow 2.13 doesn't support gcc13:
    # https://github.com/tensorflow/tensorflow/issues/61289
    #
    # We use the nixpkgs' default libstdc++ to stay compatible with other
    # python modules
    stdenv = pkgs.stdenvAdapters.useLibsFrom stdenv pkgs.gcc12Stdenv;
  };

  tensorflow-datasets = callPackage ../development/python-modules/tensorflow-datasets { };

  tensorflow-estimator-bin = callPackage ../development/python-modules/tensorflow-estimator/bin.nix { };

  tensorflow-metadata = callPackage ../development/python-modules/tensorflow-metadata { };

  tensorflow-probability = callPackage ../development/python-modules/tensorflow-probability {
    inherit (pkgs.darwin) cctools;
  };

  tensorflow = self.tensorflow-build;

  tensorflowWithCuda = self.tensorflow.override {
    cudaSupport = true;
  };

  tensorflowWithoutCuda = self.tensorflow.override {
    cudaSupport = false;
  };

  tensorly = callPackage ../development/python-modules/tensorly { };

  tensorrt = callPackage ../development/python-modules/tensorrt { cudaPackages = pkgs.cudaPackages_11; };

  tensorstore = callPackage ../development/python-modules/tensorstore { };

  tellduslive = callPackage ../development/python-modules/tellduslive { };

  termcolor = callPackage ../development/python-modules/termcolor { };

  termgraph = callPackage ../development/python-modules/termgraph { };

  terminado = callPackage ../development/python-modules/terminado { };

  terminaltables = callPackage ../development/python-modules/terminaltables { };

  termplotlib = callPackage ../development/python-modules/termplotlib { };

  termstyle = callPackage ../development/python-modules/termstyle { };

  tern = callPackage ../development/python-modules/tern { };

  tesla-fleet-api = callPackage ../development/python-modules/tesla-fleet-api { };

  tesla-powerwall = callPackage ../development/python-modules/tesla-powerwall { };

  tesla-wall-connector = callPackage ../development/python-modules/tesla-wall-connector { };

  teslajsonpy = callPackage ../development/python-modules/teslajsonpy { };

  tess = callPackage ../development/python-modules/tess { };

  tesserocr = callPackage ../development/python-modules/tesserocr { };

  testcontainers = callPackage ../development/python-modules/testcontainers { };

  testfixtures = callPackage ../development/python-modules/testfixtures { };

  texsoup = callPackage ../development/python-modules/texsoup { };

  textfsm = callPackage ../development/python-modules/textfsm { };

  textile = callPackage ../development/python-modules/textile { };

  textparser = callPackage ../development/python-modules/textparser { };

  textual = callPackage ../development/python-modules/textual { };

  textual-dev = callPackage ../development/python-modules/textual-dev { };

  textual-universal-directorytree = callPackage ../development/python-modules/textual-universal-directorytree { };

  testbook = callPackage ../development/python-modules/testbook { };

  testing-common-database = callPackage ../development/python-modules/testing-common-database { };

  testing-postgresql = callPackage ../development/python-modules/testing-postgresql { };

  testpath = callPackage ../development/python-modules/testpath { };

  testrail-api = callPackage ../development/python-modules/testrail-api { };

  testrepository = callPackage ../development/python-modules/testrepository { };

  testresources = callPackage ../development/python-modules/testresources { };

  testscenarios = callPackage ../development/python-modules/testscenarios { };

  testtools = callPackage ../development/python-modules/testtools { };

  test-tube = callPackage ../development/python-modules/test-tube { };

  textdistance = callPackage ../development/python-modules/textdistance { };

  textacy = callPackage ../development/python-modules/textacy { };

  textnets = callPackage ../development/python-modules/textnets {
    en_core_web_sm = spacy_models.en_core_web_sm;
  };

  texttable = callPackage ../development/python-modules/texttable { };

  text-unidecode = callPackage ../development/python-modules/text-unidecode { };

  textwrap3 = callPackage ../development/python-modules/textwrap3 { };

  textx = callPackage ../development/python-modules/textx { };

  tf2onnx = callPackage ../development/python-modules/tf2onnx { };

  tflearn = callPackage ../development/python-modules/tflearn { };

  tftpy = callPackage ../development/python-modules/tftpy { };

  tgcrypto = callPackage ../development/python-modules/tgcrypto { };

  theano-pymc = callPackage ../development/python-modules/theano-pymc { };

  theano = callPackage ../development/python-modules/theano rec {
    inherit (pkgs.config) cudaSupport;
    cudnnSupport = cudaSupport;
  };

  theanoWithCuda = self.theano.override {
    cudaSupport = true;
    cudnnSupport = true;
  };

  theanoWithoutCuda = self.theano.override {
    cudaSupport = false;
    cudnnSupport = false;
  };

  thefuzz = callPackage ../development/python-modules/thefuzz { };

  thelogrus = callPackage ../development/python-modules/thelogrus { };

  thermobeacon-ble = callPackage ../development/python-modules/thermobeacon-ble { };

  thermopro-ble = callPackage ../development/python-modules/thermopro-ble { };

  thespian = callPackage ../development/python-modules/thespian { };

  thinc = callPackage ../development/python-modules/thinc {
    inherit (pkgs.darwin.apple_sdk.frameworks) Accelerate CoreFoundation CoreGraphics CoreVideo;
  };

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

  tkinter = callPackage ../development/python-modules/tkinter {
    py = python.override { x11Support=true; };
  };

  tidalapi = callPackage ../development/python-modules/tidalapi { };

  tidyexc = callPackage ../development/python-modules/tidyexc { };

  tidylib = callPackage ../development/python-modules/pytidylib { };

  tifffile = callPackage ../development/python-modules/tifffile { };

  tika = callPackage ../development/python-modules/tika { };

  tika-client = callPackage ../development/python-modules/tika-client { };

  tiktoken = callPackage ../development/python-modules/tiktoken { };

  tikzplotlib = callPackage ../development/python-modules/tikzplotlib { };

  tiledb = callPackage ../development/python-modules/tiledb {
    inherit (pkgs) tiledb;
  };

  tilequant = callPackage ../development/python-modules/tilequant { };

  tiler = callPackage ../development/python-modules/tiler { };

  tilestache = callPackage ../development/python-modules/tilestache { };

  tilt-ble = callPackage ../development/python-modules/tilt-ble { };

  timeago = callPackage ../development/python-modules/timeago { };

  timecop = callPackage ../development/python-modules/timecop { };

  timelib = callPackage ../development/python-modules/timelib { };

  time-machine = callPackage ../development/python-modules/time-machine { };

  timeout-decorator = callPackage ../development/python-modules/timeout-decorator { };

  timeslot = callPackage ../development/python-modules/timeslot { };

  timetagger = callPackage ../development/python-modules/timetagger { };

  timezonefinder = callPackage ../development/python-modules/timezonefinder { };

  timm = callPackage ../development/python-modules/timm { };

  tiny-cuda-nn = toPythonModule (pkgs.tiny-cuda-nn.override {
    cudaPackages = self.torch.cudaPackages;
    python3Packages = self;
    pythonSupport = true;
  });

  tiny-proxy = callPackage ../development/python-modules/tiny-proxy { };

  tinycss2 = callPackage ../development/python-modules/tinycss2 { };

  tinycss = callPackage ../development/python-modules/tinycss { };

  tinydb = callPackage ../development/python-modules/tinydb { };

  tinygrad = callPackage ../development/python-modules/tinygrad { };

  tinyobjloader-py = callPackage ../development/python-modules/tinyobjloader-py { };

  tinyrecord = callPackage ../development/python-modules/tinyrecord { };

  tinysegmenter = callPackage ../development/python-modules/tinysegmenter { };

  tissue = callPackage ../development/python-modules/tissue { };

  titlecase = callPackage ../development/python-modules/titlecase { };

  tld = callPackage ../development/python-modules/tld { };

  tlds = callPackage ../development/python-modules/tlds { };

  tldextract = callPackage ../development/python-modules/tldextract { };

  tlsh = callPackage ../development/python-modules/tlsh { };

  tlslite-ng = callPackage ../development/python-modules/tlslite-ng { };

  tls-client = callPackage ../development/python-modules/tls-client { };

  tls-parser = callPackage ../development/python-modules/tls-parser { };

  tlv8 = callPackage ../development/python-modules/tlv8 { };

  tmb = callPackage ../development/python-modules/tmb { };

  todoist = callPackage ../development/python-modules/todoist { };

  todoist-api-python = callPackage ../development/python-modules/todoist-api-python { };

  toggl-cli = callPackage ../development/python-modules/toggl-cli { };

  token-bucket = callPackage ../development/python-modules/token-bucket { };

  tokenizers = callPackage ../development/python-modules/tokenizers {
    inherit (pkgs.darwin.apple_sdk.frameworks) Security;
  };

  tokenize-rt = toPythonModule (callPackage ../development/python-modules/tokenize-rt { });

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

  torch = callPackage ../development/python-modules/torch {
    inherit (pkgs.darwin.apple_sdk.frameworks) Accelerate CoreServices;
    inherit (pkgs.darwin) libobjc;
  };

  torch-audiomentations = callPackage ../development/python-modules/torch-audiomentations { };

  torch-pitch-shift = callPackage ../development/python-modules/torch-pitch-shift { };

  torch-bin = callPackage ../development/python-modules/torch/bin.nix {
    openai-triton = self.openai-triton-bin;
  };

  torchWithCuda = self.torch.override {
    openai-triton = self.openai-triton-cuda;
    cudaSupport = true;
    rocmSupport = false;
  };

  torchWithoutCuda = self.torch.override {
    cudaSupport = false;
  };

  torchWithRocm = self.torch.override {
    openai-triton = self.openai-triton-no-cuda;
    rocmSupport = true;
    cudaSupport = false;
  };

  torchWithoutRocm = self.torch.override {
    rocmSupport = false;
  };

  torch-tb-profiler = callPackage ../development/python-modules/torch-tb-profiler/default.nix { };

  torchaudio = callPackage ../development/python-modules/torchaudio { };

  torchaudio-bin = callPackage ../development/python-modules/torchaudio/bin.nix {
    cudaPackages = pkgs.cudaPackages_12;
  };

  torchdiffeq = callPackage ../development/python-modules/torchdiffeq { };

  torchgpipe = callPackage ../development/python-modules/torchgpipe { };

  torchmetrics = callPackage ../development/python-modules/torchmetrics { };

  torchio = callPackage ../development/python-modules/torchio { };

  torchinfo = callPackage ../development/python-modules/torchinfo { };

  torchlibrosa = callPackage ../development/python-modules/torchlibrosa { };

  torchrl = callPackage ../development/python-modules/torchrl { };

  torchsde = callPackage ../development/python-modules/torchsde { };

  torchvision = callPackage ../development/python-modules/torchvision { };

  torchvision-bin = callPackage ../development/python-modules/torchvision/bin.nix {
    cudaPackages = pkgs.cudaPackages_12;
  };

  tornado = callPackage ../development/python-modules/tornado { };

  # Used by circus and grab-site, 2020-08-29
  tornado_4 = callPackage ../development/python-modules/tornado/4.nix { };

  # Used by streamlit, 2021-01-29
  tornado_5 = callPackage ../development/python-modules/tornado/5.nix { };

  torpy = callPackage ../development/python-modules/torpy { };

  torrent-parser = callPackage ../development/python-modules/torrent-parser { };

  torrequest = callPackage ../development/python-modules/torrequest { };

  total-connect-client = callPackage ../development/python-modules/total-connect-client { };

  towncrier = callPackage ../development/python-modules/towncrier {
    inherit (pkgs) git;
  };

  tox = callPackage ../development/python-modules/tox { };

  tplink-omada-client = callPackage ../development/python-modules/tplink-omada-client { };

  tpm2-pytss = callPackage ../development/python-modules/tpm2-pytss { };

  tqdm = callPackage ../development/python-modules/tqdm { };

  traceback2 = callPackage ../development/python-modules/traceback2 { };

  tracerite = callPackage ../development/python-modules/tracerite { };

  tracing = callPackage ../development/python-modules/tracing { };

  trackpy = callPackage ../development/python-modules/trackpy { };

  trafilatura = callPackage ../development/python-modules/trafilatura { };

  trailrunner = callPackage ../development/python-modules/trailrunner {};

  trainer = callPackage ../development/python-modules/trainer {};

  traitlets = callPackage ../development/python-modules/traitlets { };

  traits = callPackage ../development/python-modules/traits { };

  traitsui = callPackage ../development/python-modules/traitsui { };

  traittypes = callPackage ../development/python-modules/traittypes { };

  trampoline = callPackage ../development/python-modules/trampoline { };

  transaction = callPackage ../development/python-modules/transaction { };

  transformers = callPackage ../development/python-modules/transformers { };

  transforms3d = callPackage ../development/python-modules/transforms3d { };

  transitions = callPackage ../development/python-modules/transitions { };

  translatehtml = callPackage ../development/python-modules/translatehtml { };

  translatepy = callPackage ../development/python-modules/translatepy { };

  translationstring = callPackage ../development/python-modules/translationstring { };

  translitcodec = callPackage ../development/python-modules/translitcodec { };

  transmission-rpc = callPackage ../development/python-modules/transmission-rpc { };

  transmissionrpc = callPackage ../development/python-modules/transmissionrpc { };

  trectools = callPackage ../development/python-modules/trectools { };

  tree-sitter = callPackage ../development/python-modules/tree-sitter { };

  treelib = callPackage ../development/python-modules/treelib { };

  treelog = callPackage ../development/python-modules/treelog { };

  treeo = callPackage ../development/python-modules/treeo { };

  treex = callPackage ../development/python-modules/treex { };

  treq = callPackage ../development/python-modules/treq { };

  trezor-agent = callPackage ../development/python-modules/trezor-agent {
    pinentry = pkgs.pinentry-curses;
  };

  trezor = callPackage ../development/python-modules/trezor { };

  trfl = callPackage ../development/python-modules/trfl { };

  trimesh = callPackage ../development/python-modules/trimesh { };

  trino-python-client = callPackage ../development/python-modules/trino-python-client { };

  trio = callPackage ../development/python-modules/trio {
    inherit (pkgs) coreutils;
  };

  trio-asyncio = callPackage ../development/python-modules/trio-asyncio { };

  trio-websocket = callPackage ../development/python-modules/trio-websocket { };

  tritonclient = callPackage ../development/python-modules/tritonclient { };

  troposphere = callPackage ../development/python-modules/troposphere { };

  trove-classifiers = callPackage ../development/python-modules/trove-classifiers { };

  trueskill = callPackage ../development/python-modules/trueskill { };

  trustme = callPackage ../development/python-modules/trustme { };

  truststore = callPackage ../development/python-modules/truststore { };

  trytond = callPackage ../development/python-modules/trytond { };

  tsfresh = callPackage ../development/python-modules/tsfresh { };

  tskit = callPackage ../development/python-modules/tskit { };

  ttach = callPackage ../development/python-modules/ttach { };

  ttls = callPackage ../development/python-modules/ttls { };

  ttn-client = callPackage ../development/python-modules/ttn-client { };

  ttp = callPackage ../development/python-modules/ttp { };

  ttp-templates = callPackage ../development/python-modules/ttp-templates { };

  ttstokenizer = callPackage ../development/python-modules/ttstokenizer { };

  tubes = callPackage ../development/python-modules/tubes { };

  tuf = callPackage ../development/python-modules/tuf { };

  tunigo = callPackage ../development/python-modules/tunigo { };

  tubeup = callPackage ../development/python-modules/tubeup { };

  turnt = callPackage ../development/python-modules/turnt { };

  tuya-device-sharing-sdk = callPackage ../development/python-modules/tuya-device-sharing-sdk { };

  tuya-iot-py-sdk = callPackage ../development/python-modules/tuya-iot-py-sdk { };

  tuyaha = callPackage ../development/python-modules/tuyaha { };

  tvdb-api = callPackage ../development/python-modules/tvdb-api { };

  tweedledum = callPackage ../development/python-modules/tweedledum { };

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

  twitter-common-collections = callPackage ../development/python-modules/twitter-common-collections { };

  twitter-common-confluence = callPackage ../development/python-modules/twitter-common-confluence { };

  twitter-common-dirutil = callPackage ../development/python-modules/twitter-common-dirutil { };

  twitter-common-lang = callPackage ../development/python-modules/twitter-common-lang { };

  twitter-common-log = callPackage ../development/python-modules/twitter-common-log { };

  twitter-common-options = callPackage ../development/python-modules/twitter-common-options { };

  twitterapi = callPackage ../development/python-modules/twitterapi { };

  twofish = callPackage ../development/python-modules/twofish { };

  txaio = callPackage ../development/python-modules/txaio { };

  txamqp = callPackage ../development/python-modules/txamqp { };

  txdbus = callPackage ../development/python-modules/txdbus { };

  txgithub = callPackage ../development/python-modules/txgithub { };

  txi2p-tahoe = callPackage ../development/python-modules/txi2p-tahoe { };

  txredisapi = callPackage ../development/python-modules/txredisapi { };

  txrequests = callPackage ../development/python-modules/txrequests { };

  txtai = callPackage ../development/python-modules/txtai { };

  txtorcon = callPackage ../development/python-modules/txtorcon { };

  txzmq = callPackage ../development/python-modules/txzmq { };

  typechecks = callPackage ../development/python-modules/typechecks { };

  typecode = callPackage ../development/python-modules/typecode { };

  typecode-libmagic = callPackage ../development/python-modules/typecode/libmagic.nix {
    inherit (pkgs) file zlib;
  };

  typed-ast = callPackage ../development/python-modules/typed-ast { };

  typed-settings = callPackage ../development/python-modules/typed-settings { };

  typeguard = callPackage ../development/python-modules/typeguard { };

  typepy = callPackage ../development/python-modules/typepy { };

  typer = callPackage ../development/python-modules/typer { };

  type-infer = callPackage ../development/python-modules/type-infer { };

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

  types-dateutil = callPackage ../development/python-modules/types-dateutil { };

  types-decorator = callPackage ../development/python-modules/types-decorator { };

  types-deprecated = callPackage ../development/python-modules/types-deprecated { };

  types-docopt = callPackage ../development/python-modules/types-docopt { };

  types-docutils = callPackage ../development/python-modules/types-docutils { };

  types-enum34 = callPackage ../development/python-modules/types-enum34 { };

  types-freezegun = callPackage ../development/python-modules/types-freezegun { };

  types-futures = callPackage ../development/python-modules/types-futures { };

  types-html5lib = callPackage ../development/python-modules/types-html5lib { };

  types-ipaddress = callPackage ../development/python-modules/types-ipaddress { };

  types-lxml = callPackage ../development/python-modules/types-lxml { };

  types-markdown = callPackage ../development/python-modules/types-markdown { };

  types-mock = callPackage ../development/python-modules/types-mock { };

  types-pillow = callPackage ../development/python-modules/types-pillow { };

  types-protobuf = callPackage ../development/python-modules/types-protobuf { };

  types-psutil = callPackage ../development/python-modules/types-psutil { };

  types-psycopg2 = callPackage ../development/python-modules/types-psycopg2 { };

  types-pyopenssl = callPackage ../development/python-modules/types-pyopenssl { };

  types-python-dateutil = callPackage ../development/python-modules/types-python-dateutil { };

  types-pytz = callPackage ../development/python-modules/types-pytz { };

  types-pyyaml = callPackage ../development/python-modules/types-pyyaml { };

  types-redis = callPackage ../development/python-modules/types-redis { };

  types-retry = callPackage ../development/python-modules/types-retry { };

  types-requests = callPackage ../development/python-modules/types-requests { };

  types-s3transfer = callPackage ../development/python-modules/types-s3transfer { };

  types-setuptools = callPackage ../development/python-modules/types-setuptools { };

  types-tabulate = callPackage ../development/python-modules/types-tabulate { };

  types-toml = callPackage ../development/python-modules/types-toml { };

  types-tqdm = callPackage ../development/python-modules/types-tqdm { };

  types-typed-ast = callPackage ../development/python-modules/types-typed-ast { };

  types-ujson = callPackage ../development/python-modules/types-ujson { };

  types-urllib3 = callPackage ../development/python-modules/types-urllib3 { };

  typesentry = callPackage ../development/python-modules/typesentry { };

  typeshed-client = callPackage ../development/python-modules/typeshed-client { };

  typesystem = callPackage ../development/python-modules/typesystem { };

  typical = callPackage ../development/python-modules/typical { };

  typing = null;

  typing-extensions = callPackage ../development/python-modules/typing-extensions { };

  typing-inspect = callPackage ../development/python-modules/typing-inspect { };

  typish = callPackage ../development/python-modules/typish { };

  typogrify = callPackage ../development/python-modules/typogrify { };

  tzdata = callPackage ../development/python-modules/tzdata { };

  tzlocal = callPackage ../development/python-modules/tzlocal { };

  rustworkx = callPackage ../development/python-modules/rustworkx { };

  uamqp = callPackage ../development/python-modules/uamqp {
    inherit (pkgs.darwin.apple_sdk.frameworks) CFNetwork CoreFoundation Security;
  };

  ua-parser = callPackage ../development/python-modules/ua-parser { };

  uarray = callPackage ../development/python-modules/uarray { };

  uasiren = callPackage ../development/python-modules/uasiren { };

  ubelt = callPackage ../development/python-modules/ubelt { };

  uc-micro-py = callPackage ../development/python-modules/uc-micro-py { };

  ucsmsdk = callPackage ../development/python-modules/ucsmsdk { };

  udatetime = callPackage ../development/python-modules/udatetime { };

  ueberzug = callPackage ../development/python-modules/ueberzug {
    inherit (pkgs.xorg) libX11 libXext;
  };

  ufmt = callPackage ../development/python-modules/ufmt { };

  ufo2ft = callPackage ../development/python-modules/ufo2ft { };

  ufolib2 = callPackage ../development/python-modules/ufolib2 { };

  ufolint = callPackage ../development/python-modules/ufolint { };

  ufonormalizer = callPackage ../development/python-modules/ufonormalizer { };

  ufoprocessor = callPackage ../development/python-modules/ufoprocessor { };

  ueagle = callPackage ../development/python-modules/ueagle { };

  uharfbuzz = callPackage ../development/python-modules/uharfbuzz {
    inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices;
  };

  uhi = callPackage ../development/python-modules/uhi { };

  ujson = callPackage ../development/python-modules/ujson { };

  ukkonen = callPackage ../development/python-modules/ukkonen { };

  ukpostcodeparser = callPackage ../development/python-modules/ukpostcodeparser { };

  ulid-transform = callPackage ../development/python-modules/ulid-transform { };

  ultraheat-api = callPackage ../development/python-modules/ultraheat-api { };

  umalqurra = callPackage ../development/python-modules/umalqurra { };

  umap-learn = callPackage ../development/python-modules/umap-learn { };

  umodbus = callPackage ../development/python-modules/umodbus { };

  u-msgpack-python = callPackage ../development/python-modules/u-msgpack-python { };

  unasync = callPackage ../development/python-modules/unasync { };

  uncertainties = callPackage ../development/python-modules/uncertainties { };

  uncompyle6 = callPackage ../development/python-modules/uncompyle6 { };

  undefined = callPackage ../development/python-modules/undefined { };

  unearth = callPackage ../development/python-modules/unearth { };

  unicodecsv = callPackage ../development/python-modules/unicodecsv { };

  unicodedata2 = callPackage ../development/python-modules/unicodedata2 { };

  unicode-rbnf = callPackage ../development/python-modules/unicode-rbnf { };

  unicode-slugify = callPackage ../development/python-modules/unicode-slugify { };

  unicorn = callPackage ../development/python-modules/unicorn {
    unicorn-emu = pkgs.unicorn;
  };

  unicurses = callPackage ../development/python-modules/unicurses { };

  unicrypto = callPackage ../development/python-modules/unicrypto { };

  unidata-blocks = callPackage ../development/python-modules/unidata-blocks { };

  unidecode = callPackage ../development/python-modules/unidecode { };

  unidic = callPackage ../development/python-modules/unidic { };

  unidic-lite = callPackage ../development/python-modules/unidic-lite { };

  unidiff = callPackage ../development/python-modules/unidiff { };

  unifi = callPackage ../development/python-modules/unifi { };

  unifi-discovery = callPackage ../development/python-modules/unifi-discovery { };

  unify = callPackage ../development/python-modules/unify { };

  unifiled = callPackage ../development/python-modules/unifiled { };

  unique-log-filter = callPackage ../development/python-modules/unique-log-filter { };

  units = callPackage ../development/python-modules/units { };

  unittest-data-provider = callPackage ../development/python-modules/unittest-data-provider { };

  unittest-xml-reporting = callPackage ../development/python-modules/unittest-xml-reporting { };

  univers = callPackage ../development/python-modules/univers { };

  universal-pathlib = callPackage ../development/python-modules/universal-pathlib { };

  universal-silabs-flasher = callPackage ../development/python-modules/universal-silabs-flasher { };

  unix-ar = callPackage ../development/python-modules/unix-ar { };

  unpaddedbase64 = callPackage ../development/python-modules/unpaddedbase64 { };

  unrardll = callPackage ../development/python-modules/unrardll { };

  unrpa = callPackage ../development/python-modules/unrpa { };

  unstructured = callPackage ../development/python-modules/unstructured { };

  unstructured-api-tools = callPackage ../development/python-modules/unstructured-api-tools { };

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

  upnpy = callPackage ../development/python-modules/upnpy { };

  uproot = callPackage ../development/python-modules/uproot { };

  uptime = callPackage ../development/python-modules/uptime { };

  uptime-kuma-api = callPackage ../development/python-modules/uptime-kuma-api { };

  uptime-kuma-monitor = callPackage ../development/python-modules/uptime-kuma-monitor { };

  uqbar = callPackage ../development/python-modules/uqbar { };

  uranium = callPackage ../development/python-modules/uranium { };

  uritemplate = callPackage ../development/python-modules/uritemplate { };

  uri-template = callPackage ../development/python-modules/uri-template { };

  uritools = callPackage ../development/python-modules/uritools { };

  url-normalize = callPackage ../development/python-modules/url-normalize { };

  urlextract = callPackage ../development/python-modules/urlextract { };

  urlgrabber = callPackage ../development/python-modules/urlgrabber { };

  urllib3 = callPackage ../development/python-modules/urllib3 { };

  urlman = callPackage ../development/python-modules/urlman { };

  urlpy = callPackage ../development/python-modules/urlpy { };

  urwid = callPackage ../development/python-modules/urwid { };

  urwidgets = callPackage ../development/python-modules/urwidgets { };

  urwidtrees = callPackage ../development/python-modules/urwidtrees { };

  urwid-readline = callPackage ../development/python-modules/urwid-readline { };

  urwid-mitmproxy = callPackage ../development/python-modules/urwid-mitmproxy { };

  usb-devices = callPackage ../development/python-modules/usb-devices { };

  usbrelay-py = callPackage ../os-specific/linux/usbrelay/python.nix { };

  usbtmc = callPackage ../development/python-modules/usbtmc { };

  us = callPackage ../development/python-modules/us { };

  user-agents = callPackage ../development/python-modules/user-agents { };

  userpath = callPackage ../development/python-modules/userpath { };

  ush = callPackage ../development/python-modules/ush { };

  usort = callPackage ../development/python-modules/usort { };

  utils = callPackage ../development/python-modules/utils { };

  uuid = callPackage ../development/python-modules/uuid { };

  uvcclient = callPackage ../development/python-modules/uvcclient { };

  uvicorn = callPackage ../development/python-modules/uvicorn { };

  uvloop = callPackage ../development/python-modules/uvloop {
    inherit (pkgs.darwin.apple_sdk.frameworks) ApplicationServices CoreServices;
  };

  vaa = callPackage ../development/python-modules/vaa { };

  vacuum-map-parser-base = callPackage ../development/python-modules/vacuum-map-parser-base { };

  vacuum-map-parser-roborock = callPackage ../development/python-modules/vacuum-map-parser-roborock { };

  validate-email = callPackage ../development/python-modules/validate-email { };

  validators = callPackage ../development/python-modules/validators { };

  validobj = callPackage ../development/python-modules/validobj { };

  validphys2 = callPackage ../development/python-modules/validphys2 { };

  vallox-websocket-api = callPackage ../development/python-modules/vallox-websocket-api { };

  vapoursynth = callPackage ../development/python-modules/vapoursynth {
    inherit (pkgs) vapoursynth;
  };

  variants = callPackage ../development/python-modules/variants { };

  varint = callPackage ../development/python-modules/varint { };

  vat-moss = callPackage ../development/python-modules/vat-moss { };

  vcard = callPackage ../development/python-modules/vcard { };

  vcrpy = callPackage ../development/python-modules/vcrpy { };

  vcver = callPackage ../development/python-modules/vcver { };

  vcversioner = callPackage ../development/python-modules/vcversioner { };

  vdf = callPackage ../development/python-modules/vdf { };

  vdirsyncer = callPackage ../development/python-modules/vdirsyncer { };

  vector = callPackage ../development/python-modules/vector { };

  vehicle = callPackage ../development/python-modules/vehicle { };

  vega = callPackage ../development/python-modules/vega { };

  vega-datasets = callPackage ../development/python-modules/vega-datasets { };

  venstarcolortouch = callPackage ../development/python-modules/venstarcolortouch { };

  venusian = callPackage ../development/python-modules/venusian { };

  velbus-aio = callPackage ../development/python-modules/velbus-aio { };

  verboselogs = callPackage ../development/python-modules/verboselogs { };

  verlib2 = callPackage ../development/python-modules/verlib2 { };

  versioneer = callPackage ../development/python-modules/versioneer { };

  versionfinder = callPackage ../development/python-modules/versionfinder { };

  versioningit = callPackage ../development/python-modules/versioningit { };

  versiontag = callPackage ../development/python-modules/versiontag { };

  versiontools = callPackage ../development/python-modules/versiontools { };

  verspec = callPackage ../development/python-modules/verspec { };

  vertica-python = callPackage ../development/python-modules/vertica-python { };

  veryprettytable = callPackage ../development/python-modules/veryprettytable { };

  vg = callPackage ../development/python-modules/vg { };

  vharfbuzz = callPackage ../development/python-modules/vharfbuzz { };

  videocr = callPackage ../development/python-modules/videocr { };

  vidstab = callPackage ../development/python-modules/vidstab { };

  viennarna = toPythonModule pkgs.viennarna;

  viewstate = callPackage ../development/python-modules/viewstate { };

  vilfo-api-client = callPackage ../development/python-modules/vilfo-api-client { };

  vina = callPackage ../applications/science/chemistry/autodock-vina/python-bindings.nix { };

  vincenty = callPackage ../development/python-modules/vincenty { };

  vine = callPackage ../development/python-modules/vine { };

  virt-firmware = callPackage ../development/python-modules/virt-firmware { };

  virtkey = callPackage ../development/python-modules/virtkey { };

  virtualenv = callPackage ../development/python-modules/virtualenv { };

  virtualenv-clone = callPackage ../development/python-modules/virtualenv-clone { };

  virtualenvwrapper = callPackage ../development/python-modules/virtualenvwrapper { };

  visitor = callPackage ../development/python-modules/visitor { };

  vispy = callPackage ../development/python-modules/vispy { };

  vivisect = callPackage ../development/python-modules/vivisect {
    inherit (pkgs.libsForQt5) wrapQtAppsHook;
  };

  viv-utils = callPackage ../development/python-modules/viv-utils { };

  vllm = callPackage ../development/python-modules/vllm { };

  vmprof = callPackage ../development/python-modules/vmprof { };

  vncdo = callPackage ../development/python-modules/vncdo { };

  vobject = callPackage ../development/python-modules/vobject { };

  volatile = callPackage ../development/python-modules/volatile { };

  volkszaehler = callPackage ../development/python-modules/volkszaehler { };

  voluptuous = callPackage ../development/python-modules/voluptuous { };

  voluptuous-serialize = callPackage ../development/python-modules/voluptuous-serialize { };

  voluptuous-stubs = callPackage ../development/python-modules/voluptuous-stubs { };

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

  vtk = toPythonModule (pkgs.vtk_9.override {
    inherit python;
    enablePython = true;
  });

  vulcan-api = callPackage ../development/python-modules/vulcan-api { };

  vultr = callPackage ../development/python-modules/vultr { };

  vulture = callPackage ../development/python-modules/vulture { };

  vxi11 = callPackage ../development/python-modules/vxi11 { };

  vyper = callPackage ../development/compilers/vyper { };

  w1thermsensor = callPackage ../development/python-modules/w1thermsensor { };

  w3lib = callPackage ../development/python-modules/w3lib { };

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

  warble = callPackage ../development/python-modules/warble { };

  warcio = callPackage ../development/python-modules/warcio { };

  ward = callPackage ../development/python-modules/ward { };

  warlock = callPackage ../development/python-modules/warlock { };

  warrant = callPackage ../development/python-modules/warrant { };

  warrant-lite = callPackage ../development/python-modules/warrant-lite { };

  waqiasync = callPackage ../development/python-modules/waqiasync { };

  wasabi = callPackage ../development/python-modules/wasabi { };

  wasserstein = callPackage ../development/python-modules/wasserstein { };

  wasmerPackages = pkgs.recurseIntoAttrs (callPackage ../development/python-modules/wasmer { });
  inherit (self.wasmerPackages) wasmer wasmer-compiler-cranelift wasmer-compiler-llvm wasmer-compiler-singlepass;

  watchdog = callPackage ../development/python-modules/watchdog {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
  };

  watchdog-gevent = callPackage ../development/python-modules/watchdog-gevent { };

  watchfiles = callPackage ../development/python-modules/watchfiles {
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
  };

  watchgod = callPackage ../development/python-modules/watchgod { };

  waterfurnace = callPackage ../development/python-modules/waterfurnace { };

  watermark = callPackage ../development/python-modules/watermark { };

  wavedrom = callPackage ../development/python-modules/wavedrom { };

  wavefile = callPackage ../development/python-modules/wavefile { };

  wavinsentio = callPackage ../development/python-modules/wavinsentio { };

  wazeroutecalculator = callPackage ../development/python-modules/wazeroutecalculator { };

  wcag-contrast-ratio = callPackage ../development/python-modules/wcag-contrast-ratio { };

  wcmatch = callPackage ../development/python-modules/wcmatch { };

  wcwidth = callPackage ../development/python-modules/wcwidth { };

  weasel = callPackage ../development/python-modules/weasel { };

  weasyprint = callPackage ../development/python-modules/weasyprint { };

  weaviate-client = callPackage ../development/python-modules/weaviate-client { };

  web3 = callPackage ../development/python-modules/web3 { };

  webargs = callPackage ../development/python-modules/webargs { };

  webassets = callPackage ../development/python-modules/webassets { };

  webauthn = callPackage ../development/python-modules/webauthn { };

  web = callPackage ../development/python-modules/web { };

  web-cache = callPackage ../development/python-modules/web-cache { };

  webcolors = callPackage ../development/python-modules/webcolors { };

  webdataset = callPackage ../development/python-modules/webdataset { };

  webdav4 = callPackage ../development/python-modules/webdav4 { };

  webdavclient3 = callPackage ../development/python-modules/webdavclient3 { };

  webdriver-manager = callPackage ../development/python-modules/webdriver-manager { };

  webencodings = callPackage ../development/python-modules/webencodings { };

  webexteamssdk = callPackage ../development/python-modules/webexteamssdk { };

  webhelpers = callPackage ../development/python-modules/webhelpers { };

  webob = callPackage ../development/python-modules/webob { };

  weboob = callPackage ../development/python-modules/weboob { };

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

  werkzeug = callPackage ../development/python-modules/werkzeug { };

  west = callPackage ../development/python-modules/west { };

  wfuzz = callPackage ../development/python-modules/wfuzz { };

  wget = callPackage ../development/python-modules/wget { };

  whatthepatch = callPackage ../development/python-modules/whatthepatch { };

  wheel = callPackage ../development/python-modules/wheel { };

  wheel-filename = callPackage ../development/python-modules/wheel-filename { };

  wheel-inspect = callPackage ../development/python-modules/wheel-inspect { };

  wheezy-captcha = callPackage ../development/python-modules/wheezy-captcha { };

  wheezy-template = callPackage ../development/python-modules/wheezy-template { };

  whenever = callPackage ../development/python-modules/whenever { };

  whichcraft = callPackage ../development/python-modules/whichcraft { };

  whirlpool-sixth-sense = callPackage ../development/python-modules/whirlpool-sixth-sense { };

  whisper = callPackage ../development/python-modules/whisper { };

  whispers = callPackage ../development/python-modules/whispers { };

  whitenoise = callPackage ../development/python-modules/whitenoise { };

  whodap = callPackage ../development/python-modules/whodap { };

  whois = callPackage ../development/python-modules/whois { };

  whois-api = callPackage ../development/python-modules/whois-api { };

  whoisdomain = callPackage ../development/python-modules/whoisdomain { };

  whoosh = callPackage ../development/python-modules/whoosh { };

  widgetsnbextension = callPackage ../development/python-modules/widgetsnbextension { };

  widlparser = callPackage ../development/python-modules/widlparser { };

  wiffi = callPackage ../development/python-modules/wiffi { };

  wifi = callPackage ../development/python-modules/wifi { };

  wikipedia = callPackage ../development/python-modules/wikipedia { };

  wikipedia2vec = callPackage ../development/python-modules/wikipedia2vec { };

  wikipedia-api = callPackage ../development/python-modules/wikipedia-api { };

  wikitextparser = callPackage ../development/python-modules/wikitextparser { };

  willow = callPackage ../development/python-modules/willow { };

  winacl = callPackage ../development/python-modules/winacl { };

  winsspi = callPackage ../development/python-modules/winsspi { };

  withings-api = callPackage ../development/python-modules/withings-api { };

  withings-sync = callPackage ../development/python-modules/withings-sync { };

  wktutils = callPackage ../development/python-modules/wktutils { };

  wled = callPackage ../development/python-modules/wled { };

  wn = callPackage ../development/python-modules/wn { };

  woob = callPackage ../development/python-modules/woob { };

  woodblock = callPackage ../development/python-modules/woodblock { };

  wordcloud = callPackage ../development/python-modules/wordcloud { };

  wordfreq = callPackage ../development/python-modules/wordfreq { };

  worldengine = callPackage ../development/python-modules/worldengine { };

  wrapio = callPackage ../development/python-modules/wrapio { };

  wrapt = callPackage ../development/python-modules/wrapt { };

  wrf-python = callPackage ../development/python-modules/wrf-python { };

  ws4py = callPackage ../development/python-modules/ws4py { };

  wsdiscovery = callPackage ../development/python-modules/wsdiscovery { };

  wsgi-intercept = callPackage ../development/python-modules/wsgi-intercept { };

  wsgidav = callPackage ../development/python-modules/wsgidav { };

  wsgiprox = callPackage ../development/python-modules/wsgiprox { };

  wsgiproxy2 = callPackage ../development/python-modules/wsgiproxy2 { };

  wsgitools = callPackage ../development/python-modules/wsgitools { };

  wsme = callPackage ../development/python-modules/wsme { };

  wsnsimpy = callPackage ../development/python-modules/wsnsimpy { };

  wsproto = callPackage ../development/python-modules/wsproto { };

  wtforms = callPackage ../development/python-modules/wtforms { };

  wtforms-bootstrap5 = callPackage ../development/python-modules/wtforms-bootstrap5 { };

  wunsen = callPackage ../development/python-modules/wunsen { };

  wtf-peewee = callPackage ../development/python-modules/wtf-peewee { };

  wurlitzer = callPackage ../development/python-modules/wurlitzer { };

  wxpython = callPackage ../development/python-modules/wxpython/4.2.nix {
    wxGTK = pkgs.wxGTK32.override {
      withWebKit = true;
    };
    inherit (pkgs) mesa;
  };

  wyoming = callPackage ../development/python-modules/wyoming { };

  x-wr-timezone = callPackage ../development/python-modules/x-wr-timezone { };

  x11-hash = callPackage ../development/python-modules/x11-hash { };

  x256 = callPackage ../development/python-modules/x256 { };

  xapian = callPackage ../development/python-modules/xapian {
    inherit (pkgs) xapian;
  };

  xapp = callPackage ../development/python-modules/xapp {
    inherit (pkgs.buildPackages) meson;
    inherit (pkgs) gtk3 gobject-introspection polkit;
    inherit (pkgs.cinnamon) xapp;
  };

  xarray = callPackage ../development/python-modules/xarray { };

  xarray-dataclasses = callPackage ../development/python-modules/xarray-dataclasses { };

  xarray-einstats = callPackage ../development/python-modules/xarray-einstats { };

  xattr = callPackage ../development/python-modules/xattr { };

  xbox-webapi = callPackage ../development/python-modules/xbox-webapi { };

  xboxapi = callPackage ../development/python-modules/xboxapi { };

  xcffib = callPackage ../development/python-modules/xcffib { };

  xdg = callPackage ../development/python-modules/xdg { };

  xdg-base-dirs = callPackage ../development/python-modules/xdg-base-dirs { };

  xdis = callPackage ../development/python-modules/xdis { };

  xdoctest = callPackage ../development/python-modules/xdoctest { };

  xdot = callPackage ../development/python-modules/xdot {
    inherit (pkgs) graphviz;
  };

  xformers = callPackage ../development/python-modules/xformers { };

  xgboost = callPackage ../development/python-modules/xgboost {
    inherit (pkgs) xgboost;
  };

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

  xml2rfc = callPackage ../development/python-modules/xml2rfc { };

  xmldiff = callPackage ../development/python-modules/xmldiff { };

  xmljson = callPackage ../development/python-modules/xmljson { };

  xmlschema = callPackage ../development/python-modules/xmlschema { };

  xmlsec = callPackage ../development/python-modules/xmlsec {
    inherit (pkgs) libxslt libxml2 libtool pkg-config xmlsec;
  };

  xmltodict = callPackage ../development/python-modules/xmltodict { };

  xml-marshaller = callPackage ../development/python-modules/xml-marshaller { };

  xmod = callPackage ../development/python-modules/xmod { };

  xmodem = callPackage ../development/python-modules/xmodem { };

  xnatpy = callPackage ../development/python-modules/xnatpy { };

  xnd = callPackage ../development/python-modules/xnd { };

  xpath-expressions = callPackage ../development/python-modules/xpath-expressions { };

  xpybutil = callPackage ../development/python-modules/xpybutil { };

  xrootd = callPackage ../development/python-modules/xrootd {
    inherit (pkgs) xrootd;
  };

  xsdata = callPackage ../development/python-modules/xsdata { };

  xstatic-asciinema-player = callPackage ../development/python-modules/xstatic-asciinema-player { };

  xstatic-bootbox = callPackage ../development/python-modules/xstatic-bootbox { };

  xstatic-bootstrap = callPackage ../development/python-modules/xstatic-bootstrap { };

  xstatic = callPackage ../development/python-modules/xstatic { };

  xstatic-font-awesome = callPackage ../development/python-modules/xstatic-font-awesome { };

  xstatic-jquery = callPackage ../development/python-modules/xstatic-jquery { };

  xstatic-jquery-file-upload = callPackage ../development/python-modules/xstatic-jquery-file-upload { };

  xstatic-jquery-ui = callPackage ../development/python-modules/xstatic-jquery-ui { };

  xstatic-pygments = callPackage ../development/python-modules/xstatic-pygments { };

  xtensor-python = callPackage ../development/python-modules/xtensor-python { };

  xvfbwrapper = callPackage ../development/python-modules/xvfbwrapper {
    inherit (pkgs.xorg) xorgserver;
  };

  xxhash = callPackage ../development/python-modules/xxhash { };

  xdxf2html = callPackage ../development/python-modules/xdxf2html { };

  xyzservices = callPackage ../development/python-modules/xyzservices { };

  y-py = callPackage ../development/python-modules/y-py { };

  yabadaba = callPackage ../development/python-modules/yabadaba { };

  yahooweather = callPackage ../development/python-modules/yahooweather { };

  yalesmartalarmclient = callPackage ../development/python-modules/yalesmartalarmclient { };

  yalexs = callPackage ../development/python-modules/yalexs { };

  yalexs-ble = callPackage ../development/python-modules/yalexs-ble { };

  yamale = callPackage ../development/python-modules/yamale { };

  yamlfix = callPackage ../development/python-modules/yamlfix { };

  yamllint = callPackage ../development/python-modules/yamllint { };

  yamlloader = callPackage ../development/python-modules/yamlloader { };

  yamlordereddictloader = callPackage ../development/python-modules/yamlordereddictloader { };

  yanc = callPackage ../development/python-modules/yanc { };

  yangson = callPackage ../development/python-modules/yangson { };

  yapf = callPackage ../development/python-modules/yapf { };

  yappi = callPackage ../development/python-modules/yappi { };

  yapsy = callPackage ../development/python-modules/yapsy { };

  yara-python = callPackage ../development/python-modules/yara-python { };

  yaramod = callPackage ../development/python-modules/yaramod { };

  yarg = callPackage ../development/python-modules/yarg { };

  yargy = callPackage ../development/python-modules/yargy { };

  yark = callPackage ../development/python-modules/yark { };

  yarl = callPackage ../development/python-modules/yarl { };

  yasi = callPackage ../development/python-modules/yasi { };

  yaspin = callPackage ../development/python-modules/yaspin { };

  yaswfp = callPackage ../development/python-modules/yaswfp { };

  yattag = callPackage ../development/python-modules/yattag { };

  yacs = callPackage ../development/python-modules/yacs { };

  ydiff = callPackage ../development/python-modules/ydiff { };

  yeelight = callPackage ../development/python-modules/yeelight { };

  yfinance = callPackage ../development/python-modules/yfinance { };

  yoda = toPythonModule (pkgs.yoda.override { inherit python; });

  yolink-api = callPackage ../development/python-modules/yolink-api { };

  yosys = toPythonModule (pkgs.yosys.override {
    python3 = python;
  });

  youless-api = callPackage ../development/python-modules/youless-api { };

  youseedee = callPackage ../development/python-modules/youseedee { };

  youtokentome = callPackage ../development/python-modules/youtokentome { };

  youtube-dl = callPackage ../tools/misc/youtube-dl { };

  youtube-dl-light = callPackage ../tools/misc/youtube-dl {
    ffmpegSupport = false;
  };

  youtubeaio = callPackage ../development/python-modules/youtubeaio { };

  yoyo-migrations = callPackage ../development/python-modules/yoyo-migrations { };

  yt-dlp = callPackage ../tools/misc/yt-dlp {
    ffmpeg = pkgs.ffmpeg-headless;
  };

  yt-dlp-light = callPackage ../tools/misc/yt-dlp {
    atomicparsleySupport = false;
    ffmpegSupport = false;
    rtmpSupport = false;
  };

  youtube-search = callPackage ../development/python-modules/youtube-search { };

  youtube-search-python = callPackage ../development/python-modules/youtube-search-python { };

  youtube-transcript-api = callPackage ../development/python-modules/youtube-transcript-api { };

  yowsup = callPackage ../development/python-modules/yowsup { };

  ypy-websocket = callPackage ../development/python-modules/ypy-websocket { };

  yq = callPackage ../development/python-modules/yq {
    inherit (pkgs) jq;
  };

  yte = callPackage ../development/python-modules/yte { };

  ytmusicapi = callPackage ../development/python-modules/ytmusicapi { };

  yubico = callPackage ../development/python-modules/yubico { };

  yubico-client = callPackage ../development/python-modules/yubico-client { };

  z3c-checkversions = callPackage ../development/python-modules/z3c-checkversions { };

  z3-solver = (toPythonModule ((pkgs.z3.override {
    inherit python;
  }).overrideAttrs (_: {
    pname = "z3-solver";
  }))).python;

  zadnegoale = callPackage ../development/python-modules/zadnegoale { };

  zamg = callPackage ../development/python-modules/zamg { };

  zarr = callPackage ../development/python-modules/zarr { };

  zc-buildout = callPackage ../development/python-modules/buildout { };

  zc-lockfile = callPackage ../development/python-modules/zc-lockfile { };

  zcbor = callPackage ../development/python-modules/zcbor { };

  zconfig = callPackage ../development/python-modules/zconfig { };

  zcs = callPackage ../development/python-modules/zcs { };

  zdaemon = callPackage ../development/python-modules/zdaemon { };

  zeek = (toPythonModule (pkgs.zeek.broker.override {
    python3 = python;
  })).py;

  zeep = callPackage ../development/python-modules/zeep { };

  zeitgeist = (toPythonModule (pkgs.zeitgeist.override {
    python3 = python;
  })).py;

  zephyr-python-api = callPackage ../development/python-modules/zephyr-python-api { };

  zeroc-ice = callPackage ../development/python-modules/zeroc-ice { };

  zeroconf = callPackage ../development/python-modules/zeroconf { };

  zerorpc = callPackage ../development/python-modules/zerorpc { };

  zetup = callPackage ../development/python-modules/zetup { };

  zeversolarlocal = callPackage ../development/python-modules/zeversolarlocal { };

  zfec = callPackage ../development/python-modules/zfec { };

  zha-quirks = callPackage ../development/python-modules/zha-quirks { };

  ziafont = callPackage ../development/python-modules/ziafont { };

  ziamath = callPackage ../development/python-modules/ziamath { };

  zict = callPackage ../development/python-modules/zict { };

  zigpy = callPackage ../development/python-modules/zigpy { };

  zigpy-cc = callPackage ../development/python-modules/zigpy-cc { };

  zigpy-deconz = callPackage ../development/python-modules/zigpy-deconz { };

  zigpy-xbee = callPackage ../development/python-modules/zigpy-xbee { };

  zigpy-zigate = callPackage ../development/python-modules/zigpy-zigate { };

  zigpy-znp = callPackage ../development/python-modules/zigpy-znp { };

  zimports = callPackage ../development/python-modules/zimports { };

  zipfile2 = callPackage ../development/python-modules/zipfile2 { };

  zipp = callPackage ../development/python-modules/zipp { };

  zipstream = callPackage ../development/python-modules/zipstream { };

  zipstream-ng = callPackage ../development/python-modules/zipstream-ng { };

  zlib-ng = callPackage ../development/python-modules/zlib-ng {
    inherit (pkgs) zlib-ng;
  };

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

  zope-interface = callPackage ../development/python-modules/zope-interface { };

  zope-lifecycleevent = callPackage ../development/python-modules/zope-lifecycleevent { };

  zope-location = callPackage ../development/python-modules/zope-location { };

  zope-proxy = callPackage ../development/python-modules/zope-proxy { };

  zope-schema = callPackage ../development/python-modules/zope-schema { };

  zope-size = callPackage ../development/python-modules/zope-size { };

  zope-testbrowser = callPackage ../development/python-modules/zope-testbrowser { };

  zope-testing = callPackage ../development/python-modules/zope-testing { };

  zope-testrunner = callPackage ../development/python-modules/zope-testrunner { };

  zopfli = callPackage ../development/python-modules/zopfli {
    inherit (pkgs) zopfli;
  };

  zstandard = callPackage ../development/python-modules/zstandard { };

  zstd = callPackage ../development/python-modules/zstd {
    inherit (pkgs) zstd;
  };

  zulip = callPackage ../development/python-modules/zulip { };

  zwave-me-ws = callPackage ../development/python-modules/zwave-me-ws { };

  zwave-js-server-python = callPackage ../development/python-modules/zwave-js-server-python { };

  zxcvbn = callPackage ../development/python-modules/zxcvbn { };

  zxing-cpp = callPackage ../development/python-modules/zxing-cpp {
    libzxing-cpp = pkgs.zxing-cpp;
  };
}
