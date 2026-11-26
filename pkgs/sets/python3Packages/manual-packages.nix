# This file contains the Python packages set.
# Each attribute is a Python library or a helper function.
# Python packages that do not need to be available for each interpreter version do not belong in this packages set.
# Examples are Python-based cli tools.
#
# For more details, please see the Python section in the Nixpkgs manual.

self: super: with self; {

  bootstrap = lib.recurseIntoAttrs {
    flit-core = toPythonModule (callPackage ./non-by-name/bootstrap/flit-core { });
    installer = toPythonModule (
      callPackage ./non-by-name/bootstrap/installer { inherit (bootstrap) flit-core; }
    );
    build = toPythonModule (
      callPackage ./non-by-name/bootstrap/build {
        inherit (bootstrap) flit-core installer;
      }
    );
    packaging = toPythonModule (
      callPackage ./non-by-name/bootstrap/packaging {
        inherit (bootstrap) flit-core installer;
      }
    );
  };

  setuptools = callPackage ./non-by-name/setuptools { };

  setuptools_80 = callPackage ./non-by-name/setuptools/80.nix { };

  # by_regex ensures inherit statements are sorted after the (first) attribute name that is inherited.
  # keep-sorted start block=yes newline_separated=yes by_regex=["(?:inherit\\s+\\([^)]+\\)\\n?\\s*)?(.+)"]
  a2a-sdk = callPackage ./non-by-name/a2a-sdk { };

  a2wsgi = callPackage ./non-by-name/a2wsgi { };

  aafigure = callPackage ./non-by-name/aafigure { };

  aardwolf = callPackage ./non-by-name/aardwolf { };

  about-time = callPackage ./non-by-name/about-time { };

  absl-py = callPackage ./non-by-name/absl-py { };

  accelerate = callPackage ./non-by-name/accelerate { };

  accessible-pygments = callPackage ./non-by-name/accessible-pygments { };

  accupy = callPackage ./non-by-name/accupy { };

  accuweather = callPackage ./non-by-name/accuweather { };

  acme = callPackage ./non-by-name/acme { };

  acme-tiny = callPackage ./non-by-name/acme-tiny { };

  acquire = callPackage ./non-by-name/acquire { };

  acres = callPackage ./non-by-name/acres { };

  actdiag = callPackage ./non-by-name/actdiag { };

  actron-neo-api = callPackage ./non-by-name/actron-neo-api { };

  acunetix = callPackage ./non-by-name/acunetix { };

  adafruit-board-toolkit = callPackage ./non-by-name/adafruit-board-toolkit { };

  adafruit-io = callPackage ./non-by-name/adafruit-io { };

  adafruit-platformdetect = callPackage ./non-by-name/adafruit-platformdetect { };

  adafruit-pureio = callPackage ./non-by-name/adafruit-pureio { };

  adal = callPackage ./non-by-name/adal { };

  adax = callPackage ./non-by-name/adax { };

  adax-local = callPackage ./non-by-name/adax-local { };

  adb-enhanced = callPackage ./non-by-name/adb-enhanced { };

  adb-homeassistant = callPackage ./non-by-name/adb-homeassistant { };

  adb-shell = callPackage ./non-by-name/adb-shell { };

  adbc-driver-flightsql = callPackage ./non-by-name/adbc-driver-flightsql { };

  adbc-driver-manager = callPackage ./non-by-name/adbc-driver-manager { };

  adbc-driver-postgresql = callPackage ./non-by-name/adbc-driver-postgresql { };

  adbc-driver-sqlite = callPackage ./non-by-name/adbc-driver-sqlite { };

  adblock = callPackage ./non-by-name/adblock { };

  adbutils = callPackage ./non-by-name/adbutils { };

  add-trailing-comma = callPackage ./non-by-name/add-trailing-comma { };

  addict = callPackage ./non-by-name/addict { };

  adext = callPackage ./non-by-name/adext { };

  adguardhome = callPackage ./non-by-name/adguardhome { };

  adios2 = toPythonModule (
    pkgs.adios2.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  adjusttext = callPackage ./non-by-name/adjusttext { };

  adlfs = callPackage ./non-by-name/adlfs { };

  adsbcot = callPackage ./non-by-name/adsbcot { };

  advantage-air = callPackage ./non-by-name/advantage-air { };

  advent-of-code-data = callPackage ./non-by-name/advent-of-code-data { };

  aeidon = callPackage ./non-by-name/aeidon { };

  aemet-opendata = callPackage ./non-by-name/aemet-opendata { };

  aenum = callPackage ./non-by-name/aenum { };

  aerosandbox = callPackage ./non-by-name/aerosandbox { };

  aerosmart-modbus = callPackage ./non-by-name/aerosmart-modbus { };

  aesedb = callPackage ./non-by-name/aesedb { };

  aetcd = callPackage ./non-by-name/aetcd { };

  afdko = callPackage ./non-by-name/afdko { };

  affine = callPackage ./non-by-name/affine { };

  affinegap = callPackage ./non-by-name/affinegap { };

  affinegaps = callPackage ./non-by-name/affinegaps { };

  afsapi = callPackage ./non-by-name/afsapi { };

  agate = callPackage ./non-by-name/agate { };

  agate-dbf = callPackage ./non-by-name/agate-dbf { };

  agate-excel = callPackage ./non-by-name/agate-excel { };

  agate-sql = callPackage ./non-by-name/agate-sql { };

  agent-client-protocol = callPackage ./non-by-name/agent-client-protocol { };

  agent-py = callPackage ./non-by-name/agent-py { };

  agentic-threat-hunting-framework = callPackage ./non-by-name/agentic-threat-hunting-framework { };

  aggdraw = callPackage ./non-by-name/aggdraw { };

  aggregate6 = callPackage ./non-by-name/aggregate6 { };

  ago = callPackage ./non-by-name/ago { };

  ahocorapy = callPackage ./non-by-name/ahocorapy { };

  ahocorasick-rs = callPackage ./non-by-name/ahocorasick-rs { };

  ai-edge-litert = callPackage ./non-by-name/ai-edge-litert {
    openvino-native = pkgs.openvino;
  };

  aigpy = callPackage ./non-by-name/aigpy { };

  aio-geojson-client = callPackage ./non-by-name/aio-geojson-client { };

  aio-geojson-generic-client = callPackage ./non-by-name/aio-geojson-generic-client { };

  aio-geojson-geonetnz-quakes = callPackage ./non-by-name/aio-geojson-geonetnz-quakes { };

  aio-geojson-geonetnz-volcano = callPackage ./non-by-name/aio-geojson-geonetnz-volcano { };

  aio-geojson-nsw-rfs-incidents = callPackage ./non-by-name/aio-geojson-nsw-rfs-incidents { };

  aio-geojson-usgs-earthquakes = callPackage ./non-by-name/aio-geojson-usgs-earthquakes { };

  aio-georss-client = callPackage ./non-by-name/aio-georss-client { };

  aio-georss-gdacs = callPackage ./non-by-name/aio-georss-gdacs { };

  aio-ownet = callPackage ./non-by-name/aio-ownet { };

  aio-pika = callPackage ./non-by-name/aio-pika { };

  aio-wattwaechter = callPackage ./non-by-name/aio-wattwaechter { };

  aioabrp = callPackage ./non-by-name/aioabrp { };

  aioacaia = callPackage ./non-by-name/aioacaia { };

  aioairctrl = callPackage ./non-by-name/aioairctrl { };

  aioairq = callPackage ./non-by-name/aioairq { };

  aioairzone = callPackage ./non-by-name/aioairzone { };

  aioairzone-cloud = callPackage ./non-by-name/aioairzone-cloud { };

  aioamazondevices = callPackage ./non-by-name/aioamazondevices { };

  aioambient = callPackage ./non-by-name/aioambient { };

  aioamqp = callPackage ./non-by-name/aioamqp { };

  aioanylist = callPackage ./non-by-name/aioanylist { };

  aioapcaccess = callPackage ./non-by-name/aioapcaccess { };

  aioapns = callPackage ./non-by-name/aioapns { };

  aioaquacell = callPackage ./non-by-name/aioaquacell { };

  aioaquarite = callPackage ./non-by-name/aioaquarite { };

  aioaseko = callPackage ./non-by-name/aioaseko { };

  aioasuswrt = callPackage ./non-by-name/aioasuswrt { };

  aioaudiobookshelf = callPackage ./non-by-name/aioaudiobookshelf { };

  aioautomower = callPackage ./non-by-name/aioautomower { };

  aioaxlevpp = callPackage ./non-by-name/aioaxlevpp { };

  aioazuredevops = callPackage ./non-by-name/aioazuredevops { };

  aiobafi6 = callPackage ./non-by-name/aiobafi6 { };

  aiobiketrax = callPackage ./non-by-name/aiobiketrax { };

  aioblescan = callPackage ./non-by-name/aioblescan { };

  aioboto3 = callPackage ./non-by-name/aioboto3 { };

  aiobotocore = callPackage ./non-by-name/aiobotocore { };

  aiobroadlink = callPackage ./non-by-name/aiobroadlink { };

  aiobtclientapi = callPackage ./non-by-name/aiobtclientapi { };

  aiobtclientrpc = callPackage ./non-by-name/aiobtclientrpc { };

  aiocache = callPackage ./non-by-name/aiocache { };

  aiocentriconnect = callPackage ./non-by-name/aiocentriconnect { };

  aiocmd = callPackage ./non-by-name/aiocmd { };

  aiocoap = callPackage ./non-by-name/aiocoap { };

  aiocomelit = callPackage ./non-by-name/aiocomelit { };

  aioconsole = callPackage ./non-by-name/aioconsole { };

  aiocontextvars = callPackage ./non-by-name/aiocontextvars { };

  aiocron = callPackage ./non-by-name/aiocron { };

  aiocsv = callPackage ./non-by-name/aiocsv { };

  aiocurrencylayer = callPackage ./non-by-name/aiocurrencylayer { };

  aiodhcpwatcher = callPackage ./non-by-name/aiodhcpwatcher { };

  aiodiscover = callPackage ./non-by-name/aiodiscover { };

  aiodns = callPackage ./non-by-name/aiodns { };

  aiodocker = callPackage ./non-by-name/aiodocker { };

  aiodukeenergy = callPackage ./non-by-name/aiodukeenergy { };

  aioeafm = callPackage ./non-by-name/aioeafm { };

  aioeagle = callPackage ./non-by-name/aioeagle { };

  aioecosmart = callPackage ./non-by-name/aioecosmart { };

  aioecowitt = callPackage ./non-by-name/aioecowitt { };

  aioelectricitymaps = callPackage ./non-by-name/aioelectricitymaps { };

  aioemonitor = callPackage ./non-by-name/aioemonitor { };

  aioesphomeapi = callPackage ./non-by-name/aioesphomeapi { };

  aioextensions = callPackage ./non-by-name/aioextensions { };

  aiofarmad = callPackage ./non-by-name/aiofarmad { };

  aiofile = callPackage ./non-by-name/aiofile { };

  aiofiles = callPackage ./non-by-name/aiofiles { };

  aioflo = callPackage ./non-by-name/aioflo { };

  aioftp = callPackage ./non-by-name/aioftp { };

  aioghost = callPackage ./non-by-name/aioghost { };

  aiogithubapi = callPackage ./non-by-name/aiogithubapi { };

  aiogram = callPackage ./non-by-name/aiogram { };

  aioguardian = callPackage ./non-by-name/aioguardian { };

  aiohappyeyeballs = callPackage ./non-by-name/aiohappyeyeballs { };

  aioharmanluxury = callPackage ./non-by-name/aioharmanluxury { };

  aioharmony = callPackage ./non-by-name/aioharmony { };

  aiohasupervisor = callPackage ./non-by-name/aiohasupervisor { };

  aiohomeconnect = callPackage ./non-by-name/aiohomeconnect { };

  aiohomekit = callPackage ./non-by-name/aiohomekit { };

  aiohomematic = callPackage ./non-by-name/aiohomematic { };

  aiohomematic-config = callPackage ./non-by-name/aiohomematic-config { };

  aiohomematic-test-support = callPackage ./non-by-name/aiohomematic-test-support { };

  aiohortos = callPackage ./non-by-name/aiohortos { };

  aiohpprinter = callPackage ./non-by-name/aiohpprinter { };

  aiohttp = callPackage ./non-by-name/aiohttp { };

  aiohttp-apispec = callPackage ./non-by-name/aiohttp-apispec { };

  aiohttp-asgi-connector = callPackage ./non-by-name/aiohttp-asgi-connector { };

  aiohttp-asyncmdnsresolver = callPackage ./non-by-name/aiohttp-asyncmdnsresolver { };

  aiohttp-basicauth = callPackage ./non-by-name/aiohttp-basicauth { };

  aiohttp-client-cache = callPackage ./non-by-name/aiohttp-client-cache { };

  aiohttp-cors = callPackage ./non-by-name/aiohttp-cors { };

  aiohttp-fast-zlib = callPackage ./non-by-name/aiohttp-fast-zlib { };

  aiohttp-jinja2 = callPackage ./non-by-name/aiohttp-jinja2 { };

  aiohttp-middlewares = callPackage ./non-by-name/aiohttp-middlewares { };

  aiohttp-oauthlib = callPackage ./non-by-name/aiohttp-oauthlib { };

  aiohttp-openmetrics = callPackage ./non-by-name/aiohttp-openmetrics { };

  aiohttp-remotes = callPackage ./non-by-name/aiohttp-remotes { };

  aiohttp-retry = callPackage ./non-by-name/aiohttp-retry { };

  aiohttp-session = callPackage ./non-by-name/aiohttp-session { };

  aiohttp-socks = callPackage ./non-by-name/aiohttp-socks { };

  aiohttp-sse = callPackage ./non-by-name/aiohttp-sse { };

  aiohttp-sse-client = callPackage ./non-by-name/aiohttp-sse-client { };

  aiohttp-sse-client2 = callPackage ./non-by-name/aiohttp-sse-client2 { };

  aiohttp-swagger = callPackage ./non-by-name/aiohttp-swagger { };

  aiohttp-utils = callPackage ./non-by-name/aiohttp-utils { };

  aiohttp-wsgi = callPackage ./non-by-name/aiohttp-wsgi { };

  aiohue = callPackage ./non-by-name/aiohue { };

  aiohwenergy = callPackage ./non-by-name/aiohwenergy { };

  aioice = callPackage ./non-by-name/aioice { };

  aioimaplib = callPackage ./non-by-name/aioimaplib { };

  aioimmich = callPackage ./non-by-name/aioimmich { };

  aioindiallsky = callPackage ./non-by-name/aioindiallsky { };

  aiointercept = callPackage ./non-by-name/aiointercept { };

  aioipp = callPackage ./non-by-name/aioipp { };

  aioitertools = callPackage ./non-by-name/aioitertools { };

  aiojellyfin = callPackage ./non-by-name/aiojellyfin { };

  aiojobs = callPackage ./non-by-name/aiojobs { };

  aiokafka = callPackage ./non-by-name/aiokafka { };

  aiokarakeep = callPackage ./non-by-name/aiokarakeep { };

  aiokef = callPackage ./non-by-name/aiokef { };

  aiokem = callPackage ./non-by-name/aiokem { };

  aiolibrenms = callPackage ./non-by-name/aiolibrenms { };

  aiolibresync = callPackage ./non-by-name/aiolibresync { };

  aiolichess = callPackage ./non-by-name/aiolichess { };

  aiolifx = callPackage ./non-by-name/aiolifx { };

  aiolifx-connection = callPackage ./non-by-name/aiolifx-connection { };

  aiolifx-effects = callPackage ./non-by-name/aiolifx-effects { };

  aiolifx-themes = callPackage ./non-by-name/aiolifx-themes { };

  aiolimiter = callPackage ./non-by-name/aiolimiter { };

  aiolookin = callPackage ./non-by-name/aiolookin { };

  aiolyric = callPackage ./non-by-name/aiolyric { };

  aiomcache = callPackage ./non-by-name/aiomcache { };

  aiomealie = callPackage ./non-by-name/aiomealie { };

  aiomelcloudhome = callPackage ./non-by-name/aiomelcloudhome { };

  aiomisc = callPackage ./non-by-name/aiomisc { };

  aiomisc-pytest = callPackage ./non-by-name/aiomisc-pytest { };

  aiomodernforms = callPackage ./non-by-name/aiomodernforms { };

  aiomqtt = callPackage ./non-by-name/aiomqtt { };

  aiomultiprocess = callPackage ./non-by-name/aiomultiprocess { };

  aiomusiccast = callPackage ./non-by-name/aiomusiccast { };

  aiomysql = callPackage ./non-by-name/aiomysql { };

  aionanoleaf = callPackage ./non-by-name/aionanoleaf { };

  aionanoleaf2 = callPackage ./non-by-name/aionanoleaf2 { };

  aionatureremo = callPackage ./non-by-name/aionatureremo { };

  aionotion = callPackage ./non-by-name/aionotion { };

  aiontfy = callPackage ./non-by-name/aiontfy { };

  aionut = callPackage ./non-by-name/aionut { };

  aiooncue = callPackage ./non-by-name/aiooncue { };

  aioonkyo = callPackage ./non-by-name/aioonkyo { };

  aioopenexchangerates = callPackage ./non-by-name/aioopenexchangerates { };

  aioopenssl = callPackage ./non-by-name/aioopenssl { };

  aiooss2 = callPackage ./non-by-name/aiooss2 { };

  aiooui = callPackage ./non-by-name/aiooui { };

  aiopegelonline = callPackage ./non-by-name/aiopegelonline { };

  aiopg = callPackage ./non-by-name/aiopg { };

  aiopinboard = callPackage ./non-by-name/aiopinboard { };

  aiopnsense = callPackage ./non-by-name/aiopnsense { };

  aiopowerwall = callPackage ./non-by-name/aiopowerwall { };

  aioprocessing = callPackage ./non-by-name/aioprocessing { };

  aioprometheus = callPackage ./non-by-name/aioprometheus { };

  aioptdevices = callPackage ./non-by-name/aioptdevices { };

  aiopulse = callPackage ./non-by-name/aiopulse { };

  aiopulsegrow = callPackage ./non-by-name/aiopulsegrow { };

  aiopurpleair = callPackage ./non-by-name/aiopurpleair { };

  aiopvapi = callPackage ./non-by-name/aiopvapi { };

  aiopvpc = callPackage ./non-by-name/aiopvpc { };

  aiopyarr = callPackage ./non-by-name/aiopyarr { };

  aiopylgtv = callPackage ./non-by-name/aiopylgtv { };

  aioqsw = callPackage ./non-by-name/aioqsw { };

  aioquic = callPackage ./non-by-name/aioquic { };

  aioquic_1_2 = callPackage ./non-by-name/aioquic_1_2 { };

  aioraven = callPackage ./non-by-name/aioraven { };

  aiorecollect = callPackage ./non-by-name/aiorecollect { };

  aioredis = callPackage ./non-by-name/aioredis { };

  aioresponses = callPackage ./non-by-name/aioresponses { };

  aioridwell = callPackage ./non-by-name/aioridwell { };

  aiormq = callPackage ./non-by-name/aiormq { };

  aiorpcx = callPackage ./non-by-name/aiorpcx { };

  aiortc = callPackage ./non-by-name/aiortc { };

  aiortm = callPackage ./non-by-name/aiortm { };

  aiortsp = callPackage ./non-by-name/aiortsp { };

  aioruckus = callPackage ./non-by-name/aioruckus { };

  aiorun = callPackage ./non-by-name/aiorun { };

  aiorussound = callPackage ./non-by-name/aiorussound { };

  aioruuvigateway = callPackage ./non-by-name/aioruuvigateway { };

  aiorwlock = callPackage ./non-by-name/aiorwlock { };

  aiosaj = callPackage ./non-by-name/aiosaj { };

  aiosendspin = callPackage ./non-by-name/aiosendspin { };

  aiosendspin-mpris = callPackage ./non-by-name/aiosendspin-mpris { };

  aioserial = callPackage ./non-by-name/aioserial { };

  aioshelly = callPackage ./non-by-name/aioshelly { };

  aiosignal = callPackage ./non-by-name/aiosignal { };

  aioskybell = callPackage ./non-by-name/aioskybell { };

  aioslimproto = callPackage ./non-by-name/aioslimproto { };

  aiosmb = callPackage ./non-by-name/aiosmb { };

  aiosmtpd = callPackage ./non-by-name/aiosmtpd { };

  aiosmtplib = callPackage ./non-by-name/aiosmtplib { };

  aiosolaredge = callPackage ./non-by-name/aiosolaredge { };

  aiosomecomfort = callPackage ./non-by-name/aiosomecomfort { };

  aiosonic = callPackage ./non-by-name/aiosonic { };

  aiosonos = callPackage ./non-by-name/aiosonos { };

  aiospinel = callPackage ./non-by-name/aiospinel { };

  aiosql = callPackage ./non-by-name/aiosql { };

  aiosqlite = callPackage ./non-by-name/aiosqlite { };

  aiosseclient = callPackage ./non-by-name/aiosseclient { };

  aiosteamist = callPackage ./non-by-name/aiosteamist { };

  aiostream = callPackage ./non-by-name/aiostream { };

  aiostreammagic = callPackage ./non-by-name/aiostreammagic { };

  aioswitcher = callPackage ./non-by-name/aioswitcher { };

  aiosyncthing = callPackage ./non-by-name/aiosyncthing { };

  aiotankerkoenig = callPackage ./non-by-name/aiotankerkoenig { };

  aiotarfile = callPackage ./non-by-name/aiotarfile { };

  aiotedee = callPackage ./non-by-name/aiotedee { };

  aiothreads = callPackage ./non-by-name/aiothreads { };

  aiothreema = callPackage ./non-by-name/aiothreema { };

  aiotools = callPackage ./non-by-name/aiotools { };

  aiotractive = callPackage ./non-by-name/aiotractive { };

  aiounifi = callPackage ./non-by-name/aiounifi { };

  aiounittest = callPackage ./non-by-name/aiounittest { };

  aiousbwatcher = callPackage ./non-by-name/aiousbwatcher { };

  aiovban = callPackage ./non-by-name/aiovban { };

  aiovban-pyaudio = callPackage ./non-by-name/aiovban-pyaudio { };

  aiovitesy = callPackage ./non-by-name/aiovitesy { };

  aiovlc = callPackage ./non-by-name/aiovlc { };

  aiovodafone = callPackage ./non-by-name/aiovodafone { };

  aiowaqi = callPackage ./non-by-name/aiowaqi { };

  aiowatttime = callPackage ./non-by-name/aiowatttime { };

  aiowebdav2 = callPackage ./non-by-name/aiowebdav2 { };

  aiowebostv = callPackage ./non-by-name/aiowebostv { };

  aioweenect = callPackage ./non-by-name/aioweenect { };

  aiowinreg = callPackage ./non-by-name/aiowinreg { };

  aiowithings = callPackage ./non-by-name/aiowithings { };

  aiowmi = callPackage ./non-by-name/aiowmi { };

  aioymaps = callPackage ./non-by-name/aioymaps { };

  aiozeroconf = callPackage ./non-by-name/aiozeroconf { };

  aiozoneinfo = callPackage ./non-by-name/aiozoneinfo { };

  aircot = callPackage ./non-by-name/aircot { };

  airgradient = callPackage ./non-by-name/airgradient { };

  airium = callPackage ./non-by-name/airium { };

  airly = callPackage ./non-by-name/airly { };

  airos = callPackage ./non-by-name/airos { };

  airpatrol = callPackage ./non-by-name/airpatrol { };

  airportsdata = callPackage ./non-by-name/airportsdata { };

  airthings-ble = callPackage ./non-by-name/airthings-ble { };

  airthings-cloud = callPackage ./non-by-name/airthings-cloud { };

  airtouch4pyapi = callPackage ./non-by-name/airtouch4pyapi { };

  airtouch5py = callPackage ./non-by-name/airtouch5py { };

  aiscot = callPackage ./non-by-name/aiscot { };

  aistore = callPackage ./non-by-name/aistore { };

  aistudio-sdk = callPackage ./non-by-name/aistudio-sdk { };

  ajpy = callPackage ./non-by-name/ajpy { };

  ajsonrpc = callPackage ./non-by-name/ajsonrpc { };

  alabaster = callPackage ./non-by-name/alabaster { };

  aladdin-connect = callPackage ./non-by-name/aladdin-connect { };

  alarmdecoder = callPackage ./non-by-name/alarmdecoder { };

  albucore = callPackage ./non-by-name/albucore { };

  albumentationsx = callPackage ./non-by-name/albumentationsx { };

  ale-py = callPackage ./non-by-name/ale-py { };

  alectryon = callPackage ./non-by-name/alectryon { };

  alembic = callPackage ./non-by-name/alembic { };

  alexapy = callPackage ./non-by-name/alexapy { };

  algebraic-data-types = callPackage ./non-by-name/algebraic-data-types { };

  alibabacloud-actiontrail20200706 = callPackage ./non-by-name/alibabacloud-actiontrail20200706 { };

  alibabacloud-credentials = callPackage ./non-by-name/alibabacloud-credentials { };

  alibabacloud-credentials-api = callPackage ./non-by-name/alibabacloud-credentials-api { };

  alibabacloud-cs20151215 = callPackage ./non-by-name/alibabacloud-cs20151215 { };

  alibabacloud-darabonba-array = callPackage ./non-by-name/alibabacloud-darabonba-array { };

  alibabacloud-darabonba-encode-util =
    callPackage ./non-by-name/alibabacloud-darabonba-encode-util
      { };

  alibabacloud-darabonba-map = callPackage ./non-by-name/alibabacloud-darabonba-map { };

  alibabacloud-darabonba-signature-util =
    callPackage ./non-by-name/alibabacloud-darabonba-signature-util
      { };

  alibabacloud-darabonba-string = callPackage ./non-by-name/alibabacloud-darabonba-string { };

  alibabacloud-darabonba-time = callPackage ./non-by-name/alibabacloud-darabonba-time { };

  alibabacloud-ecs20140526 = callPackage ./non-by-name/alibabacloud-ecs20140526 { };

  alibabacloud-endpoint-util = callPackage ./non-by-name/alibabacloud-endpoint-util { };

  alibabacloud-gateway-oss = callPackage ./non-by-name/alibabacloud-gateway-oss { };

  alibabacloud-gateway-oss-util = callPackage ./non-by-name/alibabacloud-gateway-oss-util { };

  alibabacloud-gateway-pop = callPackage ./non-by-name/alibabacloud-gateway-pop { };

  alibabacloud-gateway-sls = callPackage ./non-by-name/alibabacloud-gateway-sls { };

  alibabacloud-gateway-sls-util = callPackage ./non-by-name/alibabacloud-gateway-sls-util { };

  alibabacloud-gateway-spi = callPackage ./non-by-name/alibabacloud-gateway-spi { };

  alibabacloud-openapi-util = callPackage ./non-by-name/alibabacloud-openapi-util { };

  alibabacloud-oss-util = callPackage ./non-by-name/alibabacloud-oss-util { };

  alibabacloud-oss20190517 = callPackage ./non-by-name/alibabacloud-oss20190517 { };

  alibabacloud-ram20150501 = callPackage ./non-by-name/alibabacloud-ram20150501 { };

  alibabacloud-rds20140815 = callPackage ./non-by-name/alibabacloud-rds20140815 { };

  alibabacloud-sas20181203 = callPackage ./non-by-name/alibabacloud-sas20181203 { };

  alibabacloud-sls20201230 = callPackage ./non-by-name/alibabacloud-sls20201230 { };

  alibabacloud-sts20150401 = callPackage ./non-by-name/alibabacloud-sts20150401 { };

  alibabacloud-tea = callPackage ./non-by-name/alibabacloud-tea { };

  alibabacloud-tea-openapi = callPackage ./non-by-name/alibabacloud-tea-openapi { };

  alibabacloud-tea-util = callPackage ./non-by-name/alibabacloud-tea-util { };

  alibabacloud-tea-xml = callPackage ./non-by-name/alibabacloud-tea-xml { };

  alibabacloud-vpc20160428 = callPackage ./non-by-name/alibabacloud-vpc20160428 { };

  aligator = callPackage ./non-by-name/aligator { inherit (pkgs) aligator; };

  alive-progress = callPackage ./non-by-name/alive-progress { };

  aliyun-log-fastpb = callPackage ./non-by-name/aliyun-log-fastpb { };

  inherit (callPackage ./non-by-name/aliyun-python-sdk { })
    aliyun-python-sdk-actiontrail
    aliyun-python-sdk-adb
    aliyun-python-sdk-adcp
    aliyun-python-sdk-address-purification
    aliyun-python-sdk-aicontent
    aliyun-python-sdk-aigen
    aliyun-python-sdk-aimath
    aliyun-python-sdk-aimiaobi
    aliyun-python-sdk-aipodcast
    aliyun-python-sdk-airec
    aliyun-python-sdk-airticketopen
    aliyun-python-sdk-alb
    aliyun-python-sdk-alidns
    aliyun-python-sdk-alikafka
    aliyun-python-sdk-alimt
    aliyun-python-sdk-alinlp
    aliyun-python-sdk-amqp-open
    aliyun-python-sdk-antiddos-public
    aliyun-python-sdk-anytrans
    aliyun-python-sdk-apds
    aliyun-python-sdk-appstream-center
    aliyun-python-sdk-aps
    aliyun-python-sdk-arms
    aliyun-python-sdk-avatar
    aliyun-python-sdk-bailianchatbot
    aliyun-python-sdk-beian
    aliyun-python-sdk-bpstudio
    aliyun-python-sdk-brain-industrial
    aliyun-python-sdk-brinekingdom
    aliyun-python-sdk-bssopenapi
    aliyun-python-sdk-btripopen
    aliyun-python-sdk-buss
    aliyun-python-sdk-cams
    aliyun-python-sdk-captcha
    aliyun-python-sdk-cassandra
    aliyun-python-sdk-cbn
    aliyun-python-sdk-cc5g
    aliyun-python-sdk-ccc
    aliyun-python-sdk-cciotgw
    aliyun-python-sdk-cdn
    aliyun-python-sdk-cdrs
    aliyun-python-sdk-ciomarketpop
    aliyun-python-sdk-clickhouse
    aliyun-python-sdk-cloudapi
    aliyun-python-sdk-cloudauth
    aliyun-python-sdk-cloudauth-console
    aliyun-python-sdk-cloudesl
    aliyun-python-sdk-cloudphone
    aliyun-python-sdk-cloud-siem
    aliyun-python-sdk-cms
    aliyun-python-sdk-codeup
    aliyun-python-sdk-companyreg
    aliyun-python-sdk-computenest
    aliyun-python-sdk-computenestsupplier
    aliyun-python-sdk-config
    aliyun-python-sdk-csas
    aliyun-python-sdk-das
    aliyun-python-sdk-dashdeviceconsole
    aliyun-python-sdk-dataphin-public
    aliyun-python-sdk-dataworks-public
    aliyun-python-sdk-dbfs
    aliyun-python-sdk-dbs
    aliyun-python-sdk-dcdn
    aliyun-python-sdk-ddosbgp
    aliyun-python-sdk-ddoscoo
    aliyun-python-sdk-ddosdiversion
    aliyun-python-sdk-dds
    aliyun-python-sdk-devops-rdc
    aliyun-python-sdk-dfs
    aliyun-python-sdk-dg
    aliyun-python-sdk-dms
    aliyun-python-sdk-dms-dg
    aliyun-python-sdk-dms-enterprise
    aliyun-python-sdk-documentautoml
    aliyun-python-sdk-domain
    aliyun-python-sdk-drds
    aliyun-python-sdk-dt-oc-info
    aliyun-python-sdk-dts
    aliyun-python-sdk-dybaseapi
    aliyun-python-sdk-dyplsapi
    aliyun-python-sdk-dypnsapi
    aliyun-python-sdk-dypnsapi-intl
    aliyun-python-sdk-dysmsapi
    aliyun-python-sdk-dytnsapi
    aliyun-python-sdk-dyvmsapi
    aliyun-python-sdk-eais
    aliyun-python-sdk-eas
    aliyun-python-sdk-ebs
    aliyun-python-sdk-ecd
    aliyun-python-sdk-eci
    aliyun-python-sdk-ecs
    aliyun-python-sdk-ecs-workbench
    aliyun-python-sdk-edas
    aliyun-python-sdk-eds-user
    aliyun-python-sdk-eduinterpreting
    aliyun-python-sdk-eflo
    aliyun-python-sdk-eflo-controller
    aliyun-python-sdk-ehpc
    aliyun-python-sdk-ehpcinstant
    aliyun-python-sdk-eiam
    aliyun-python-sdk-eipanycast
    aliyun-python-sdk-elasticsearch
    aliyun-python-sdk-emas-appmonitor
    aliyun-python-sdk-emr
    aliyun-python-sdk-emrstudio
    aliyun-python-sdk-ens
    aliyun-python-sdk-esa
    aliyun-python-sdk-ess
    aliyun-python-sdk-es-serverless
    aliyun-python-sdk-et-industry-openapi
    aliyun-python-sdk-eventbridge
    aliyun-python-sdk-facebody
    aliyun-python-sdk-fnf
    aliyun-python-sdk-foas
    aliyun-python-sdk-ft
    aliyun-python-sdk-ga
    aliyun-python-sdk-gdb
    aliyun-python-sdk-geoip
    aliyun-python-sdk-governance
    aliyun-python-sdk-gpdb
    aliyun-python-sdk-grace
    aliyun-python-sdk-green
    aliyun-python-sdk-gwlb
    aliyun-python-sdk-hbase
    aliyun-python-sdk-hbr
    aliyun-python-sdk-hcs-mgw
    aliyun-python-sdk-hitsdb
    aliyun-python-sdk-ice
    aliyun-python-sdk-idaas-doraemon
    aliyun-python-sdk-imageaudit
    aliyun-python-sdk-imageenhan
    aliyun-python-sdk-imageprocess
    aliyun-python-sdk-imagerecog
    aliyun-python-sdk-imageseg
    aliyun-python-sdk-imarketing
    aliyun-python-sdk-imgsearch
    aliyun-python-sdk-imm
    aliyun-python-sdk-intlmarket
    aliyun-python-sdk-iot
    aliyun-python-sdk-iotcc
    aliyun-python-sdk-iqs
    aliyun-python-sdk-itag
    aliyun-python-sdk-ivision
    aliyun-python-sdk-kms
    aliyun-python-sdk-lingmou
    aliyun-python-sdk-linkvisual
    aliyun-python-sdk-linkwan
    aliyun-python-sdk-live
    aliyun-python-sdk-ltl
    aliyun-python-sdk-lto
    aliyun-python-sdk-market
    aliyun-python-sdk-marketplaceintl
    aliyun-python-sdk-maxcompute
    aliyun-python-sdk-mns-open
    aliyun-python-sdk-moguan-sdk
    aliyun-python-sdk-msccommonquery
    aliyun-python-sdk-mse
    aliyun-python-sdk-mseap
    aliyun-python-sdk-mts
    aliyun-python-sdk-nas
    aliyun-python-sdk-nis
    aliyun-python-sdk-nlb
    aliyun-python-sdk-nlp-automl
    aliyun-python-sdk-objectdet
    aliyun-python-sdk-oceanbasepro
    aliyun-python-sdk-ocr
    aliyun-python-sdk-ocs
    aliyun-python-sdk-oms
    aliyun-python-sdk-ons
    aliyun-python-sdk-onsmqtt
    aliyun-python-sdk-oos
    aliyun-python-sdk-openanalytics-open
    aliyun-python-sdk-openitag
    aliyun-python-sdk-opensearch
    aliyun-python-sdk-osssddp
    aliyun-python-sdk-outboundbot
    aliyun-python-sdk-pai-dsw
    aliyun-python-sdk-paielasticdatasetaccelerator
    aliyun-python-sdk-paifeaturestore
    aliyun-python-sdk-pairecservice
    aliyun-python-sdk-polardb
    aliyun-python-sdk-polardbx
    aliyun-python-sdk-privatelink
    aliyun-python-sdk-push
    aliyun-python-sdk-pvtz
    aliyun-python-sdk-qianzhou
    aliyun-python-sdk-qualitycheck
    aliyun-python-sdk-quickbi-public
    aliyun-python-sdk-quotas
    aliyun-python-sdk-ram
    aliyun-python-sdk-rds
    aliyun-python-sdk-rds-data
    aliyun-python-sdk-reid-cloud
    aliyun-python-sdk-resourcecenter
    aliyun-python-sdk-resourcemanager
    aliyun-python-sdk-resourcesharing
    aliyun-python-sdk-retailcloud
    aliyun-python-sdk-r-kvstore
    aliyun-python-sdk-ros
    aliyun-python-sdk-rsimganalys
    aliyun-python-sdk-rtc
    aliyun-python-sdk-sae
    aliyun-python-sdk-safconsole
    aliyun-python-sdk-sas
    aliyun-python-sdk-sasti
    aliyun-python-sdk-scdn
    aliyun-python-sdk-schedulerx2
    aliyun-python-sdk-schedulerx3
    aliyun-python-sdk-scsp
    aliyun-python-sdk-sddp
    aliyun-python-sdk-selectdb
    aliyun-python-sdk-sgw
    aliyun-python-sdk-slb
    aliyun-python-sdk-sls
    aliyun-python-sdk-smartag
    aliyun-python-sdk-smartsales
    aliyun-python-sdk-smc
    aliyun-python-sdk-snsuapi
    aliyun-python-sdk-sophonsoar
    aliyun-python-sdk-sts
    aliyun-python-sdk-swas-open
    aliyun-python-sdk-tag
    aliyun-python-sdk-threedvision
    aliyun-python-sdk-tingwu
    aliyun-python-sdk-unimkt
    aliyun-python-sdk-ververica
    aliyun-python-sdk-viapi
    aliyun-python-sdk-viapi-oxs-cross
    aliyun-python-sdk-viapi-regen
    aliyun-python-sdk-videoenhan
    aliyun-python-sdk-videorecog
    aliyun-python-sdk-videoseg
    aliyun-python-sdk-vod
    aliyun-python-sdk-voicenavigator
    aliyun-python-sdk-vpc
    aliyun-python-sdk-vpcpeer
    aliyun-python-sdk-vs
    aliyun-python-sdk-waf-openapi
    aliyun-python-sdk-websitebuild
    aliyun-python-sdk-wfts
    aliyun-python-sdk-workbench-ide
    aliyun-python-sdk-workorder
    aliyun-python-sdk-wss
    aliyun-python-sdk-xtrace
    ;

  aliyun-python-sdk-core = callPackage ./non-by-name/aliyun-python-sdk-core { };

  allantools = callPackage ./non-by-name/allantools { };

  allpairspy = callPackage ./non-by-name/allpairspy { };

  allure-behave = callPackage ./non-by-name/allure-behave { };

  allure-pytest = callPackage ./non-by-name/allure-pytest { };

  allure-python-commons = callPackage ./non-by-name/allure-python-commons { };

  allure-python-commons-test = callPackage ./non-by-name/allure-python-commons-test { };

  alpha-vantage = callPackage ./non-by-name/alpha-vantage { };

  alphaessopenapi = callPackage ./non-by-name/alphaessopenapi { };

  alphashape = callPackage ./non-by-name/alphashape { };

  altair = callPackage ./non-by-name/altair { };

  altcha = callPackage ./non-by-name/altcha { };

  altgraph = callPackage ./non-by-name/altgraph { };

  altruistclient = callPackage ./non-by-name/altruistclient { };

  amaranth = callPackage ./non-by-name/amaranth { };

  amaranth-boards = callPackage ./non-by-name/amaranth-boards { };

  amaranth-soc = callPackage ./non-by-name/amaranth-soc { };

  amarna = callPackage ./non-by-name/amarna { };

  amazon-ion = callPackage ./non-by-name/amazon-ion { };

  amberelectric = callPackage ./non-by-name/amberelectric { };

  amcrest = callPackage ./non-by-name/amcrest { };

  amd-aiter = callPackage ./non-by-name/amd-aiter { };

  amd-quark = callPackage ./non-by-name/amd-quark { };

  amdsmi = toPythonModule (
    pkgs.rocmPackages.amdsmi.override {
      inherit python;
    }
  );

  ament-package = callPackage ./non-by-name/ament-package { };

  amplitude-analytics = callPackage ./non-by-name/amplitude-analytics { };

  amply = callPackage ./non-by-name/amply { };

  amqp = callPackage ./non-by-name/amqp { };

  amshan = callPackage ./non-by-name/amshan { };

  anchor-kr = callPackage ./non-by-name/anchor-kr { };

  ancpbids = callPackage ./non-by-name/ancpbids { };

  androguard = callPackage ./non-by-name/androguard { };

  android-backup = callPackage ./non-by-name/android-backup { };

  androidtv = callPackage ./non-by-name/androidtv { };

  androidtvremote2 = callPackage ./non-by-name/androidtvremote2 { };

  anel-pwrctrl-homeassistant = callPackage ./non-by-name/anel-pwrctrl-homeassistant { };

  angr = callPackage ./non-by-name/angr { };

  angr-data = callPackage ./non-by-name/angr-data { };

  angrcli = callPackage ./non-by-name/angrcli { inherit (pkgs) coreutils; };

  angrop = callPackage ./non-by-name/angrop { };

  aniso8601 = callPackage ./non-by-name/aniso8601 { };

  anitopy = callPackage ./non-by-name/anitopy { };

  anki-audio = callPackage ./non-by-name/anki-audio { };

  anki-mac-helper = callPackage ./non-by-name/anki-mac-helper {
    inherit (pkgs) swift;
  };

  anndata = callPackage ./non-by-name/anndata { };

  annexremote = callPackage ./non-by-name/annexremote { };

  annotated-doc = callPackage ./non-by-name/annotated-doc { };

  annotated-types = callPackage ./non-by-name/annotated-types { };

  annotatedyaml = callPackage ./non-by-name/annotatedyaml { };

  annoy = callPackage ./non-by-name/annoy { };

  anonip = callPackage ./non-by-name/anonip { };

  anonymizeip = callPackage ./non-by-name/anonymizeip { };

  anova-wifi = callPackage ./non-by-name/anova-wifi { };

  ansi = callPackage ./non-by-name/ansi { };

  ansi2html = callPackage ./non-by-name/ansi2html { };

  ansi2image = callPackage ./non-by-name/ansi2image { };

  ansible = callPackage ./non-by-name/ansible { };

  ansible-builder = callPackage ./non-by-name/ansible-builder {
    inherit (pkgs) podman;
  };

  ansible-compat = callPackage ./non-by-name/ansible-compat { };

  ansible-core = callPackage ./non-by-name/ansible/core.nix { };

  ansible-kernel = callPackage ./non-by-name/ansible-kernel { };

  ansible-pylibssh = callPackage ./non-by-name/ansible-pylibssh { };

  ansible-runner = callPackage ./non-by-name/ansible-runner { };

  ansible-vault = callPackage ./non-by-name/ansible-vault { };

  ansicolor = callPackage ./non-by-name/ansicolor { };

  ansicolors = callPackage ./non-by-name/ansicolors { };

  ansimarkup = callPackage ./non-by-name/ansimarkup { };

  ansitable = callPackage ./non-by-name/ansitable { };

  anthemav = callPackage ./non-by-name/anthemav { };

  anthropic = callPackage ./non-by-name/anthropic { };

  antlr4-python3-runtime = callPackage ./non-by-name/antlr4-python3-runtime {
    inherit (pkgs) antlr4;
  };

  anyascii = callPackage ./non-by-name/anyascii { };

  anybadge = callPackage ./non-by-name/anybadge { };

  anyconfig = callPackage ./non-by-name/anyconfig { };

  anyio = callPackage ./non-by-name/anyio { };

  anyqt = callPackage ./non-by-name/anyqt { };

  anysqlite = callPackage ./non-by-name/anysqlite { };

  anytree = callPackage ./non-by-name/anytree { inherit (pkgs) graphviz; };

  anywidget = callPackage ./non-by-name/anywidget { };

  aocd-example-parser = callPackage ./non-by-name/aocd-example-parser { };

  aodhclient = callPackage ./non-by-name/aodhclient { };

  apache-beam = callPackage ./non-by-name/apache-beam { };

  apache-tvm-ffi = callPackage ./non-by-name/apache-tvm-ffi { };

  apcaccess = callPackage ./non-by-name/apcaccess { };

  apex = callPackage ./non-by-name/apex { };

  apeye = callPackage ./non-by-name/apeye { };

  apeye-core = callPackage ./non-by-name/apeye-core { };

  apiflask = callPackage ./non-by-name/apiflask { };

  apify-fingerprint-datapoints = callPackage ./non-by-name/apify-fingerprint-datapoints { };

  apipkg = callPackage ./non-by-name/apipkg { };

  apischema = callPackage ./non-by-name/apischema { };

  apispec = callPackage ./non-by-name/apispec { };

  apispec-webframeworks = callPackage ./non-by-name/apispec-webframeworks { };

  apkinspector = callPackage ./non-by-name/apkinspector { };

  apksigcopier = callPackage ./non-by-name/apksigcopier { };

  apksigtool = callPackage ./non-by-name/apksigtool { };

  aplpy = callPackage ./non-by-name/aplpy { };

  apollo-fpga = callPackage ./non-by-name/apollo-fpga { };

  app-model = callPackage ./non-by-name/app-model { };

  appdirs = callPackage ./non-by-name/appdirs { };

  appimage = callPackage ./non-by-name/appimage { };

  appium-python-client = callPackage ./non-by-name/appium-python-client { };

  apple-compress = callPackage ./non-by-name/apple-compress { };

  apple-weatherkit = callPackage ./non-by-name/apple-weatherkit { };

  applicationinsights = callPackage ./non-by-name/applicationinsights { };

  appnope = callPackage ./non-by-name/appnope { };

  apprise = callPackage ./non-by-name/apprise { };

  approval-utilities = callPackage ./non-by-name/approval-utilities { };

  approvaltests = callPackage ./non-by-name/approvaltests { };

  appthreat-vulnerability-db = callPackage ./non-by-name/appthreat-vulnerability-db { };

  apptools = callPackage ./non-by-name/apptools { };

  apricot-select = callPackage ./non-by-name/apricot-select { };

  aprslib = callPackage ./non-by-name/aprslib { };

  apscheduler = callPackage ./non-by-name/apscheduler { };

  apsw = callPackage ./non-by-name/apsw { };

  apswutils = callPackage ./non-by-name/apswutils { };

  apsystems-ez1 = callPackage ./non-by-name/apsystems-ez1 { };

  apt-repo = callPackage ./non-by-name/apt-repo { };

  apted = callPackage ./non-by-name/apted { };

  apycula = callPackage ./non-by-name/apycula { };

  apykuma = callPackage ./non-by-name/apykuma { };

  aqipy-atmotech = callPackage ./non-by-name/aqipy-atmotech { };

  aqualogic = callPackage ./non-by-name/aqualogic { };

  ar = callPackage ./non-by-name/ar { };

  arabic-reshaper = callPackage ./non-by-name/arabic-reshaper { };

  aranet4 = callPackage ./non-by-name/aranet4 { };

  arc4 = callPackage ./non-by-name/arc4 { };

  arcam-fmj = callPackage ./non-by-name/arcam-fmj { };

  arch = callPackage ./non-by-name/arch { };

  archinfo = callPackage ./non-by-name/archinfo { };

  archspec = callPackage ./non-by-name/archspec { };

  area = callPackage ./non-by-name/area { };

  arelle-release = callPackage ./non-by-name/arelle-release { };

  aresponses = callPackage ./non-by-name/aresponses { };

  argcomplete = callPackage ./non-by-name/argcomplete { };

  argh = callPackage ./non-by-name/argh { };

  argilla = callPackage ./non-by-name/argilla { };

  argon2-cffi = callPackage ./non-by-name/argon2-cffi { };

  argon2-cffi-bindings = callPackage ./non-by-name/argon2-cffi-bindings { };

  argos-translate-files = callPackage ./non-by-name/argos-translate-files { };

  argostranslate = callPackage ./non-by-name/argostranslate {
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  argparse-addons = callPackage ./non-by-name/argparse-addons { };

  argparse-dataclass = callPackage ./non-by-name/argparse-dataclass { };

  argparse-manpage = callPackage ./non-by-name/argparse-manpage { };

  args = callPackage ./non-by-name/args { };

  aria2p = callPackage ./non-by-name/aria2p { };

  ariadne = callPackage ./non-by-name/ariadne { };

  arpeggio = callPackage ./non-by-name/arpeggio { };

  arpy = callPackage ./non-by-name/arpy { };

  array-api-compat = callPackage ./non-by-name/array-api-compat { };

  array-api-strict = callPackage ./non-by-name/array-api-strict { };

  array-record = callPackage ./non-by-name/array-record { };

  arrayqueues = callPackage ./non-by-name/arrayqueues { };

  arris-tg2492lg = callPackage ./non-by-name/arris-tg2492lg { };

  arro3-compute = (callPackage ./non-by-name/arro3 { }).arro3-compute;

  arro3-core = (callPackage ./non-by-name/arro3 { }).arro3-core;

  arro3-io = (callPackage ./non-by-name/arro3 { }).arro3-io;

  arrow = callPackage ./non-by-name/arrow { };

  arsenic = callPackage ./non-by-name/arsenic { };

  art = callPackage ./non-by-name/art { };

  arviz = callPackage ./non-by-name/arviz { };

  arviz-base = callPackage ./non-by-name/arviz-base { };

  arviz-plots = callPackage ./non-by-name/arviz-plots { };

  arviz-stats = callPackage ./non-by-name/arviz-stats { };

  arwn-client = callPackage ./non-by-name/arwn-client { };

  arxiv = callPackage ./non-by-name/arxiv { };

  arxiv2bib = callPackage ./non-by-name/arxiv2bib { };

  asana = callPackage ./non-by-name/asana { };

  ascii-magic = callPackage ./non-by-name/ascii-magic { };

  asciimatics = callPackage ./non-by-name/asciimatics { };

  asciitree = callPackage ./non-by-name/asciitree { };

  asdf = callPackage ./non-by-name/asdf { };

  asdf-astropy = callPackage ./non-by-name/asdf-astropy { };

  asdf-coordinates-schemas = callPackage ./non-by-name/asdf-coordinates-schemas { };

  asdf-standard = callPackage ./non-by-name/asdf-standard { };

  asdf-transform-schemas = callPackage ./non-by-name/asdf-transform-schemas { };

  asdf-wcs-schemas = callPackage ./non-by-name/asdf-wcs-schemas { };

  ase = callPackage ./non-by-name/ase { };

  asf-search = callPackage ./non-by-name/asf-search { };

  asgi-csrf = callPackage ./non-by-name/asgi-csrf { };

  asgi-lifespan = callPackage ./non-by-name/asgi-lifespan { };

  asgi-logger = callPackage ./non-by-name/asgi-logger { };

  asgineer = callPackage ./non-by-name/asgineer { };

  asgiref = callPackage ./non-by-name/asgiref { };

  asks = callPackage ./non-by-name/asks { };

  asn1 = callPackage ./non-by-name/asn1 { };

  asn1ate = callPackage ./non-by-name/asn1ate { };

  asn1crypto = callPackage ./non-by-name/asn1crypto { };

  asn1tools = callPackage ./non-by-name/asn1tools { };

  asndb = callPackage ./non-by-name/asndb { };

  aspectlib = callPackage ./non-by-name/aspectlib { };

  aspell-python-py3 = callPackage ./non-by-name/aspell-python-py3 { };

  assay = callPackage ./non-by-name/assay { };

  assertpy = callPackage ./non-by-name/assertpy { };

  asserts = callPackage ./non-by-name/asserts { };

  ast-grep-cli = callPackage ./non-by-name/ast-grep-cli { };

  ast-grep-py = callPackage ./non-by-name/ast-grep-py { };

  ast-serialize = callPackage ./non-by-name/ast-serialize { };

  asterisk-mbox = callPackage ./non-by-name/asterisk-mbox { };

  asteroid-filterbanks = callPackage ./non-by-name/asteroid-filterbanks { };

  asteval = callPackage ./non-by-name/asteval { };

  astor = callPackage ./non-by-name/astor { };

  astral = callPackage ./non-by-name/astral { };

  astroid = callPackage ./non-by-name/astroid { };

  astropy = callPackage ./non-by-name/astropy { };

  astropy-healpix = callPackage ./non-by-name/astropy-healpix { };

  astropy-helpers = callPackage ./non-by-name/astropy-helpers { };

  astropy-iers-data = callPackage ./non-by-name/astropy-iers-data { };

  astroquery = callPackage ./non-by-name/astroquery { };

  asttokens = callPackage ./non-by-name/asttokens { };

  astunparse = callPackage ./non-by-name/astunparse { };

  asusrouter = callPackage ./non-by-name/asusrouter { };

  asyauth = callPackage ./non-by-name/asyauth { };

  async-cache = callPackage ./non-by-name/async-cache { };

  async-generator = callPackage ./non-by-name/async-generator { };

  async-geotiff = callPackage ./non-by-name/async-geotiff { };

  async-interrupt = callPackage ./non-by-name/async-interrupt { };

  async-lru = callPackage ./non-by-name/async-lru { };

  async-modbus = callPackage ./non-by-name/async-modbus { };

  async-stagger = callPackage ./non-by-name/async-stagger { };

  async-tiff = callPackage ./non-by-name/async-tiff { };

  async-timeout = callPackage ./non-by-name/async-timeout { };

  async-tkinter-loop = callPackage ./non-by-name/async-tkinter-loop { };

  async-upnp-client = callPackage ./non-by-name/async-upnp-client { };

  asyncarve = callPackage ./non-by-name/asyncarve { };

  asyncclick = callPackage ./non-by-name/asyncclick { };

  asynccmd = callPackage ./non-by-name/asynccmd { };

  asyncer = callPackage ./non-by-name/asyncer { };

  asynch = callPackage ./non-by-name/asynch { };

  asyncinotify = callPackage ./non-by-name/asyncinotify { };

  asyncio-dgram = callPackage ./non-by-name/asyncio-dgram { };

  asyncio-rlock = callPackage ./non-by-name/asyncio-rlock { };

  asyncio-throttle = callPackage ./non-by-name/asyncio-throttle { };

  asyncmy = callPackage ./non-by-name/asyncmy { };

  asyncpg = callPackage ./non-by-name/asyncpg { };

  asyncpraw = callPackage ./non-by-name/asyncpraw { };

  asyncprawcore = callPackage ./non-by-name/asyncprawcore { };

  asyncpysupla = callPackage ./non-by-name/asyncpysupla { };

  asyncserial = callPackage ./non-by-name/asyncserial { };

  asyncsleepiq = callPackage ./non-by-name/asyncsleepiq { };

  asyncssh = callPackage ./non-by-name/asyncssh { };

  asyncstdlib = callPackage ./non-by-name/asyncstdlib { };

  asynctest = callPackage ./non-by-name/asynctest { };

  asyncua = callPackage ./non-by-name/asyncua { };

  asyncudp = callPackage ./non-by-name/asyncudp { };

  asyncwhois = callPackage ./non-by-name/asyncwhois { };

  asysocks = callPackage ./non-by-name/asysocks { };

  atc-ble = callPackage ./non-by-name/atc-ble { };

  atlassian-python-api = callPackage ./non-by-name/atlassian-python-api { };

  atom = callPackage ./non-by-name/atom { };

  atomiclong = callPackage ./non-by-name/atomiclong { };

  atomicwrites = callPackage ./non-by-name/atomicwrites { };

  atomicwrites-homeassistant = callPackage ./non-by-name/atomicwrites-homeassistant { };

  atomman = callPackage ./non-by-name/atomman { };

  atopile = callPackage ./non-by-name/atopile { };

  atopile-easyeda2kicad = callPackage ./non-by-name/atopile-easyeda2kicad { };

  atopile-kicad-python = callPackage ./non-by-name/atopile-kicad-python { };

  atproto = callPackage ./non-by-name/atproto { };

  atpublic = callPackage ./non-by-name/atpublic { };

  atsim-potentials = callPackage ./non-by-name/atsim-potentials { };

  attacut = callPackage ./non-by-name/attacut { };

  attn-gym = callPackage ./non-by-name/attn-gym { };

  attr = callPackage ./non-by-name/attr { };

  attrdict = callPackage ./non-by-name/attrdict { };

  attrs = callPackage ./non-by-name/attrs { };

  attrs-strict = callPackage ./non-by-name/attrs-strict { };

  aubio-ledfx = callPackage ./non-by-name/aubio-ledfx { };

  audible = callPackage ./non-by-name/audible { };

  audio-hotplug = callPackage ./non-by-name/audio-hotplug { };

  audioop-lts = if pythonAtLeast "3.13" then callPackage ./non-by-name/audioop-lts { } else null;

  audioread = callPackage ./non-by-name/audioread { };

  audiotools = callPackage ./non-by-name/audiotools { };

  audit = toPythonModule (
    pkgs.audit.override {
      python3Packages = self;
    }
  );

  auditok = callPackage ./non-by-name/auditok { };

  auditwheel = callPackage ./non-by-name/auditwheel {
    inherit (pkgs)
      bzip2
      gnutar
      patchelf
      unzip
      ;
  };

  augmax = callPackage ./non-by-name/augmax { };

  auroranoaa = callPackage ./non-by-name/auroranoaa { };

  aurorapy = callPackage ./non-by-name/aurorapy { };

  autarco = callPackage ./non-by-name/autarco { };

  auth0-python = callPackage ./non-by-name/auth0-python { };

  authcaptureproxy = callPackage ./non-by-name/authcaptureproxy { };

  authheaders = callPackage ./non-by-name/authheaders { };

  authlib = callPackage ./non-by-name/authlib { };

  authres = callPackage ./non-by-name/authres { };

  auto-lazy-imports = callPackage ./non-by-name/auto-lazy-imports { };

  autobahn = callPackage ./non-by-name/autobahn { };

  autobean = callPackage ./non-by-name/autobean { };

  autocommand = callPackage ./non-by-name/autocommand { };

  autodocsumm = callPackage ./non-by-name/autodocsumm { };

  autofaiss = callPackage ./non-by-name/autofaiss { };

  autoflake = callPackage ./non-by-name/autoflake { };

  autograd = callPackage ./non-by-name/autograd { };

  autograd-gamma = callPackage ./non-by-name/autograd-gamma { };

  autoit-ripper = callPackage ./non-by-name/autoit-ripper { };

  autologging = callPackage ./non-by-name/autologging { };

  automat = callPackage ./non-by-name/automat { };

  automate-home = callPackage ./non-by-name/automate-home { };

  automower-ble = callPackage ./non-by-name/automower-ble { };

  automx2 = callPackage ./non-by-name/automx2 { };

  autopage = callPackage ./non-by-name/autopage { };

  autopep8 = callPackage ./non-by-name/autopep8 { };

  autopxd2 = callPackage ./non-by-name/autopxd2 { };

  autoskope-client = callPackage ./non-by-name/autoskope-client { };

  autoslot = callPackage ./non-by-name/autoslot { };

  av = callPackage ./non-by-name/av { };

  avahi = toPythonModule (
    pkgs.avahi.override {
      inherit python;
      withPython = true;
    }
  );

  avea = callPackage ./non-by-name/avea { };

  avidtools = callPackage ./non-by-name/avidtools { };

  avro = callPackage ./non-by-name/avro { };

  avro-python3 = callPackage ./non-by-name/avro-python3 { };

  avwx-engine = callPackage ./non-by-name/avwx-engine { };

  aw-client = callPackage ./non-by-name/aw-client { };

  aw-core = callPackage ./non-by-name/aw-core { };

  awacs = callPackage ./non-by-name/awacs { };

  awesomeversion = callPackage ./non-by-name/awesomeversion { };

  awkward = callPackage ./non-by-name/awkward { };

  awkward-cpp = callPackage ./non-by-name/awkward-cpp { inherit (pkgs) cmake ninja; };

  awkward-pandas = callPackage ./non-by-name/awkward-pandas { };

  aws-adfs = callPackage ./non-by-name/aws-adfs { };

  aws-encryption-sdk = callPackage ./non-by-name/aws-encryption-sdk { };

  aws-error-utils = callPackage ./non-by-name/aws-error-utils { };

  aws-lambda-builders = callPackage ./non-by-name/aws-lambda-builders { };

  aws-request-signer = callPackage ./non-by-name/aws-request-signer { };

  aws-sam-translator = callPackage ./non-by-name/aws-sam-translator { };

  aws-secretsmanager-caching = callPackage ./non-by-name/aws-secretsmanager-caching { };

  aws-sso-lib = callPackage ./non-by-name/aws-sso-lib { };

  aws-xray-sdk = callPackage ./non-by-name/aws-xray-sdk { };

  awscrt = callPackage ./non-by-name/awscrt { };

  awsiotpythonsdk = callPackage ./non-by-name/awsiotpythonsdk { };

  awsiotsdk = callPackage ./non-by-name/awsiotsdk { };

  awsipranges = callPackage ./non-by-name/awsipranges { };

  awslambdaric = callPackage ./non-by-name/awslambdaric { };

  awswrangler = callPackage ./non-by-name/awswrangler { };

  ax-platform = callPackage ./non-by-name/ax-platform { };

  axis = callPackage ./non-by-name/axis { };

  axisregistry = callPackage ./non-by-name/axisregistry { };

  ayla-iot-unofficial = callPackage ./non-by-name/ayla-iot-unofficial { };

  azure-ai-agents = callPackage ./non-by-name/azure-ai-agents { };

  azure-ai-contentsafety = callPackage ./non-by-name/azure-ai-contentsafety { };

  azure-ai-documentintelligence = callPackage ./non-by-name/azure-ai-documentintelligence { };

  azure-ai-projects = callPackage ./non-by-name/azure-ai-projects { };

  azure-ai-vision-imageanalysis = callPackage ./non-by-name/azure-ai-vision-imageanalysis { };

  azure-appconfiguration = callPackage ./non-by-name/azure-appconfiguration { };

  azure-applicationinsights = callPackage ./non-by-name/azure-applicationinsights { };

  azure-batch = callPackage ./non-by-name/azure-batch { };

  azure-common = callPackage ./non-by-name/azure-common { };

  azure-containerregistry = callPackage ./non-by-name/azure-containerregistry { };

  azure-core = callPackage ./non-by-name/azure-core { };

  azure-cosmos = callPackage ./non-by-name/azure-cosmos { };

  azure-cosmosdb-nspkg = callPackage ./non-by-name/azure-cosmosdb-nspkg { };

  azure-cosmosdb-table = callPackage ./non-by-name/azure-cosmosdb-table { };

  azure-data-tables = callPackage ./non-by-name/azure-data-tables { };

  azure-datalake-store = callPackage ./non-by-name/azure-datalake-store { };

  azure-eventgrid = callPackage ./non-by-name/azure-eventgrid { };

  azure-eventhub = callPackage ./non-by-name/azure-eventhub { };

  azure-graphrbac = callPackage ./non-by-name/azure-graphrbac { };

  azure-identity = callPackage ./non-by-name/azure-identity { };

  azure-iot-device = callPackage ./non-by-name/azure-iot-device { };

  azure-keyvault = callPackage ./non-by-name/azure-keyvault { };

  azure-keyvault-administration = callPackage ./non-by-name/azure-keyvault-administration { };

  azure-keyvault-certificates = callPackage ./non-by-name/azure-keyvault-certificates { };

  azure-keyvault-keys = callPackage ./non-by-name/azure-keyvault-keys { };

  azure-keyvault-nspkg = callPackage ./non-by-name/azure-keyvault-nspkg { };

  azure-keyvault-secrets = callPackage ./non-by-name/azure-keyvault-secrets { };

  azure-keyvault-securitydomain = callPackage ./non-by-name/azure-keyvault-securitydomain { };

  azure-kusto-data = callPackage ./non-by-name/azure-kusto-data { };

  azure-kusto-ingest = callPackage ./non-by-name/azure-kusto-ingest { };

  azure-loganalytics = callPackage ./non-by-name/azure-loganalytics { };

  azure-mgmt-advisor = callPackage ./non-by-name/azure-mgmt-advisor { };

  azure-mgmt-apimanagement = callPackage ./non-by-name/azure-mgmt-apimanagement { };

  azure-mgmt-appconfiguration = callPackage ./non-by-name/azure-mgmt-appconfiguration { };

  azure-mgmt-appcontainers = callPackage ./non-by-name/azure-mgmt-appcontainers { };

  azure-mgmt-applicationinsights = callPackage ./non-by-name/azure-mgmt-applicationinsights { };

  azure-mgmt-authorization = callPackage ./non-by-name/azure-mgmt-authorization { };

  azure-mgmt-automation = callPackage ./non-by-name/azure-mgmt-automation { };

  azure-mgmt-batch = callPackage ./non-by-name/azure-mgmt-batch { };

  azure-mgmt-batchai = callPackage ./non-by-name/azure-mgmt-batchai { };

  azure-mgmt-billing = callPackage ./non-by-name/azure-mgmt-billing { };

  azure-mgmt-botservice = callPackage ./non-by-name/azure-mgmt-botservice { };

  azure-mgmt-cdn = callPackage ./non-by-name/azure-mgmt-cdn { };

  azure-mgmt-cognitiveservices = callPackage ./non-by-name/azure-mgmt-cognitiveservices { };

  azure-mgmt-commerce = callPackage ./non-by-name/azure-mgmt-commerce { };

  azure-mgmt-common = callPackage ./non-by-name/azure-mgmt-common { };

  azure-mgmt-compute = callPackage ./non-by-name/azure-mgmt-compute { };

  azure-mgmt-consumption = callPackage ./non-by-name/azure-mgmt-consumption { };

  azure-mgmt-containerinstance = callPackage ./non-by-name/azure-mgmt-containerinstance { };

  azure-mgmt-containerregistry = callPackage ./non-by-name/azure-mgmt-containerregistry { };

  azure-mgmt-containerregistrytasks = callPackage ./non-by-name/azure-mgmt-containerregistrytasks { };

  azure-mgmt-containerservice = callPackage ./non-by-name/azure-mgmt-containerservice { };

  azure-mgmt-core = callPackage ./non-by-name/azure-mgmt-core { };

  azure-mgmt-cosmosdb = callPackage ./non-by-name/azure-mgmt-cosmosdb { };

  azure-mgmt-dashboard = callPackage ./non-by-name/azure-mgmt-dashboard { };

  azure-mgmt-databoxedge = callPackage ./non-by-name/azure-mgmt-databoxedge { };

  azure-mgmt-databricks = callPackage ./non-by-name/azure-mgmt-databricks { };

  azure-mgmt-datafactory = callPackage ./non-by-name/azure-mgmt-datafactory { };

  azure-mgmt-datalake-analytics = callPackage ./non-by-name/azure-mgmt-datalake-analytics { };

  azure-mgmt-datalake-nspkg = callPackage ./non-by-name/azure-mgmt-datalake-nspkg { };

  azure-mgmt-datalake-store = callPackage ./non-by-name/azure-mgmt-datalake-store { };

  azure-mgmt-datamigration = callPackage ./non-by-name/azure-mgmt-datamigration { };

  azure-mgmt-deploymentmanager = callPackage ./non-by-name/azure-mgmt-deploymentmanager { };

  azure-mgmt-devspaces = callPackage ./non-by-name/azure-mgmt-devspaces { };

  azure-mgmt-devtestlabs = callPackage ./non-by-name/azure-mgmt-devtestlabs { };

  azure-mgmt-dns = callPackage ./non-by-name/azure-mgmt-dns { };

  azure-mgmt-domainregistration = callPackage ./non-by-name/azure-mgmt-domainregistration { };

  azure-mgmt-eventgrid = callPackage ./non-by-name/azure-mgmt-eventgrid { };

  azure-mgmt-eventhub = callPackage ./non-by-name/azure-mgmt-eventhub { };

  azure-mgmt-extendedlocation = callPackage ./non-by-name/azure-mgmt-extendedlocation { };

  azure-mgmt-frontdoor = callPackage ./non-by-name/azure-mgmt-frontdoor { };

  azure-mgmt-hanaonazure = callPackage ./non-by-name/azure-mgmt-hanaonazure { };

  azure-mgmt-hdinsight = callPackage ./non-by-name/azure-mgmt-hdinsight { };

  azure-mgmt-hybridcompute = callPackage ./non-by-name/azure-mgmt-hybridcompute { };

  azure-mgmt-imagebuilder = callPackage ./non-by-name/azure-mgmt-imagebuilder { };

  azure-mgmt-iotcentral = callPackage ./non-by-name/azure-mgmt-iotcentral { };

  azure-mgmt-iothub = callPackage ./non-by-name/azure-mgmt-iothub { };

  azure-mgmt-iothubprovisioningservices =
    callPackage ./non-by-name/azure-mgmt-iothubprovisioningservices
      { };

  azure-mgmt-keyvault = callPackage ./non-by-name/azure-mgmt-keyvault { };

  azure-mgmt-kusto = callPackage ./non-by-name/azure-mgmt-kusto { };

  azure-mgmt-loganalytics = callPackage ./non-by-name/azure-mgmt-loganalytics { };

  azure-mgmt-logic = callPackage ./non-by-name/azure-mgmt-logic { };

  azure-mgmt-machinelearningcompute = callPackage ./non-by-name/azure-mgmt-machinelearningcompute { };

  azure-mgmt-managedservices = callPackage ./non-by-name/azure-mgmt-managedservices { };

  azure-mgmt-managementgroups = callPackage ./non-by-name/azure-mgmt-managementgroups { };

  azure-mgmt-managementpartner = callPackage ./non-by-name/azure-mgmt-managementpartner { };

  azure-mgmt-maps = callPackage ./non-by-name/azure-mgmt-maps { };

  azure-mgmt-marketplaceordering = callPackage ./non-by-name/azure-mgmt-marketplaceordering { };

  azure-mgmt-media = callPackage ./non-by-name/azure-mgmt-media { };

  azure-mgmt-monitor = callPackage ./non-by-name/azure-mgmt-monitor { };

  azure-mgmt-msi = callPackage ./non-by-name/azure-mgmt-msi { };

  azure-mgmt-mysqlflexibleservers = callPackage ./non-by-name/azure-mgmt-mysqlflexibleservers { };

  azure-mgmt-netapp = callPackage ./non-by-name/azure-mgmt-netapp { };

  azure-mgmt-network = callPackage ./non-by-name/azure-mgmt-network { };

  azure-mgmt-notificationhubs = callPackage ./non-by-name/azure-mgmt-notificationhubs { };

  azure-mgmt-nspkg = callPackage ./non-by-name/azure-mgmt-nspkg { };

  azure-mgmt-policyinsights = callPackage ./non-by-name/azure-mgmt-policyinsights { };

  azure-mgmt-postgresqlflexibleservers =
    callPackage ./non-by-name/azure-mgmt-postgresqlflexibleservers
      { };

  azure-mgmt-powerbiembedded = callPackage ./non-by-name/azure-mgmt-powerbiembedded { };

  azure-mgmt-privatedns = callPackage ./non-by-name/azure-mgmt-privatedns { };

  azure-mgmt-rdbms = callPackage ./non-by-name/azure-mgmt-rdbms { };

  azure-mgmt-recoveryservices = callPackage ./non-by-name/azure-mgmt-recoveryservices { };

  azure-mgmt-recoveryservicesbackup = callPackage ./non-by-name/azure-mgmt-recoveryservicesbackup { };

  azure-mgmt-recoveryservicesbackup-passivestamp =
    callPackage ./non-by-name/azure-mgmt-recoveryservicesbackup-passivestamp
      { };

  azure-mgmt-redhatopenshift = callPackage ./non-by-name/azure-mgmt-redhatopenshift { };

  azure-mgmt-redis = callPackage ./non-by-name/azure-mgmt-redis { };

  azure-mgmt-relay = callPackage ./non-by-name/azure-mgmt-relay { };

  azure-mgmt-reservations = callPackage ./non-by-name/azure-mgmt-reservations { };

  azure-mgmt-resource = callPackage ./non-by-name/azure-mgmt-resource { };

  azure-mgmt-resource-deployments = callPackage ./non-by-name/azure-mgmt-resource-deployments { };

  azure-mgmt-resource-deploymentscripts =
    callPackage ./non-by-name/azure-mgmt-resource-deploymentscripts
      { };

  azure-mgmt-resource-deploymentstacks =
    callPackage ./non-by-name/azure-mgmt-resource-deploymentstacks
      { };

  azure-mgmt-resource-subscriptions = callPackage ./non-by-name/azure-mgmt-resource-subscriptions { };

  azure-mgmt-resource-templatespecs = callPackage ./non-by-name/azure-mgmt-resource-templatespecs { };

  azure-mgmt-scheduler = callPackage ./non-by-name/azure-mgmt-scheduler { };

  azure-mgmt-search = callPackage ./non-by-name/azure-mgmt-search { };

  azure-mgmt-security = callPackage ./non-by-name/azure-mgmt-security { };

  azure-mgmt-servicebus = callPackage ./non-by-name/azure-mgmt-servicebus { };

  azure-mgmt-servicefabric = callPackage ./non-by-name/azure-mgmt-servicefabric { };

  azure-mgmt-servicefabricmanagedclusters =
    callPackage ./non-by-name/azure-mgmt-servicefabricmanagedclusters
      { };

  azure-mgmt-servicelinker = callPackage ./non-by-name/azure-mgmt-servicelinker { };

  azure-mgmt-signalr = callPackage ./non-by-name/azure-mgmt-signalr { };

  azure-mgmt-sql = callPackage ./non-by-name/azure-mgmt-sql { };

  azure-mgmt-sqlvirtualmachine = callPackage ./non-by-name/azure-mgmt-sqlvirtualmachine { };

  azure-mgmt-storage = callPackage ./non-by-name/azure-mgmt-storage { };

  azure-mgmt-subscription = callPackage ./non-by-name/azure-mgmt-subscription { };

  azure-mgmt-synapse = callPackage ./non-by-name/azure-mgmt-synapse { };

  azure-mgmt-trafficmanager = callPackage ./non-by-name/azure-mgmt-trafficmanager { };

  azure-mgmt-web = callPackage ./non-by-name/azure-mgmt-web { };

  azure-monitor-ingestion = callPackage ./non-by-name/azure-monitor-ingestion { };

  azure-monitor-query = callPackage ./non-by-name/azure-monitor-query { };

  azure-multiapi-storage = callPackage ./non-by-name/azure-multiapi-storage { };

  azure-nspkg = callPackage ./non-by-name/azure-nspkg { };

  azure-search-documents = callPackage ./non-by-name/azure-search-documents { };

  azure-servicebus = callPackage ./non-by-name/azure-servicebus { };

  azure-servicefabric = callPackage ./non-by-name/azure-servicefabric { };

  azure-servicemanagement-legacy = callPackage ./non-by-name/azure-servicemanagement-legacy { };

  azure-storage-blob = callPackage ./non-by-name/azure-storage-blob { };

  azure-storage-common = callPackage ./non-by-name/azure-storage-common { };

  azure-storage-file = callPackage ./non-by-name/azure-storage-file { };

  azure-storage-file-datalake = callPackage ./non-by-name/azure-storage-file-datalake { };

  azure-storage-file-share = callPackage ./non-by-name/azure-storage-file-share { };

  azure-storage-nspkg = callPackage ./non-by-name/azure-storage-nspkg { };

  azure-storage-queue = callPackage ./non-by-name/azure-storage-queue { };

  azure-synapse-accesscontrol = callPackage ./non-by-name/azure-synapse-accesscontrol { };

  azure-synapse-artifacts = callPackage ./non-by-name/azure-synapse-artifacts { };

  azure-synapse-managedprivateendpoints =
    callPackage ./non-by-name/azure-synapse-managedprivateendpoints
      { };

  azure-synapse-spark = callPackage ./non-by-name/azure-synapse-spark { };

  b2sdk = callPackage ./non-by-name/b2sdk { };

  babel = callPackage ./non-by-name/babel { };

  babelfish = callPackage ./non-by-name/babelfish { };

  babelfont = callPackage ./non-by-name/babelfont { };

  babelgladeextractor = callPackage ./non-by-name/babelgladeextractor { };

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

  backcall = callPackage ./non-by-name/backcall { };

  backoff = callPackage ./non-by-name/backoff { };

  backports-asyncio-runner =
    if pythonAtLeast "3.12" then null else callPackage ./non-by-name/backports-asyncio-runner { };

  backports-datetime-fromisoformat = callPackage ./non-by-name/backports-datetime-fromisoformat { };

  backports-entry-points-selectable = callPackage ./non-by-name/backports-entry-points-selectable { };

  backports-shutil-which = callPackage ./non-by-name/backports-shutil-which { };

  backports-strenum =
    if pythonAtLeast "3.11" then null else callPackage ./non-by-name/backports-strenum { };

  backports-tarfile = callPackage ./non-by-name/backports-tarfile { };

  backports-zstd =
    if pythonAtLeast "3.14" then
      null
    else
      callPackage ./non-by-name/backports-zstd {
        inherit (pkgs) zstd;
      };

  backrefs = callPackage ./non-by-name/backrefs { };

  backtesting = callPackage ./non-by-name/backtesting { };

  bacpypes = callPackage ./non-by-name/bacpypes { };

  bacpypes3 = callPackage ./non-by-name/bacpypes3 { };

  badauth = callPackage ./non-by-name/badauth { };

  badges = callPackage ./non-by-name/badges { };

  badldap = callPackage ./non-by-name/badldap { };

  badsecrets = callPackage ./non-by-name/badsecrets { };

  bagit = callPackage ./non-by-name/bagit { };

  bahttext = callPackage ./non-by-name/bahttext { };

  baidu-aip = callPackage ./non-by-name/baidu-aip { };

  baize = callPackage ./non-by-name/baize { };

  bambi = callPackage ./non-by-name/bambi { };

  banal = callPackage ./non-by-name/banal { };

  bandcamp-api = callPackage ./non-by-name/bandcamp-api { };

  bandcamp-async-api = callPackage ./non-by-name/bandcamp-async-api { };

  bandit = callPackage ./non-by-name/bandit { };

  bangla = callPackage ./non-by-name/bangla { };

  banks = callPackage ./non-by-name/banks { };

  bap = callPackage ./non-by-name/bap {
    inherit (pkgs.ocaml-ng.ocamlPackages_4_14) bap;
  };

  barectf = callPackage ./non-by-name/barectf { };

  baron = callPackage ./non-by-name/baron { };

  base2048 = callPackage ./non-by-name/base2048 { };

  base36 = callPackage ./non-by-name/base36 { };

  base58 = callPackage ./non-by-name/base58 { };

  base58check = callPackage ./non-by-name/base58check { };

  base64io = callPackage ./non-by-name/base64io { };

  baseline = callPackage ./non-by-name/baseline { };

  baselines = callPackage ./non-by-name/baselines { };

  basemap = callPackage ./non-by-name/basemap { };

  basemap-data = callPackage ./non-by-name/basemap-data { };

  basemap-data-hires = callPackage ./non-by-name/basemap-data-hires { };

  bases = callPackage ./non-by-name/bases { };

  bash-kernel = callPackage ./non-by-name/bash-kernel { };

  bashlex = callPackage ./non-by-name/bashlex { };

  basiciw = callPackage ./non-by-name/basiciw { };

  batchgenerators = callPackage ./non-by-name/batchgenerators { };

  batchspawner = callPackage ./non-by-name/batchspawner { };

  batinfo = callPackage ./non-by-name/batinfo { };

  baycomp = callPackage ./non-by-name/baycomp { };

  bayesian-optimization = callPackage ./non-by-name/bayesian-optimization { };

  bayespy = callPackage ./non-by-name/bayespy { };

  bbox = callPackage ./non-by-name/bbox { };

  bbpb = callPackage ./non-by-name/bbpb { };

  bc-detect-secrets = callPackage ./non-by-name/bc-detect-secrets { };

  bc-jsonpath-ng = callPackage ./non-by-name/bc-jsonpath-ng { };

  bc-python-hcl2 = callPackage ./non-by-name/bc-python-hcl2 { };

  bcc = toPythonModule (pkgs.bcc.override { python3Packages = self; });

  bcdoc = callPackage ./non-by-name/bcdoc { };

  bce-python-sdk = callPackage ./non-by-name/bce-python-sdk { };

  bcf = callPackage ./non-by-name/bcf { };

  bcg = callPackage ./non-by-name/bcg { };

  bch = callPackage ./non-by-name/bch { };

  bcrypt =
    if stdenv.hostPlatform.system == "i686-linux" then
      callPackage ./non-by-name/bcrypt/3.nix { }
    else
      callPackage ./non-by-name/bcrypt { };

  bdffont = callPackage ./non-by-name/bdffont { };

  beacontools = callPackage ./non-by-name/beacontools { };

  beaker = callPackage ./non-by-name/beaker { };

  beancount = callPackage ./non-by-name/beancount { };

  beancount-black = callPackage ./non-by-name/beancount-black { };

  beancount-docverif = callPackage ./non-by-name/beancount-docverif { };

  beancount-parser = callPackage ./non-by-name/beancount-parser { };

  beancount-periodic = callPackage ./non-by-name/beancount-periodic { };

  beancount-plugin-utils = callPackage ./non-by-name/beancount-plugin-utils { };

  beancount_2 = callPackage ./non-by-name/beancount/2.nix { };

  beangulp = callPackage ./non-by-name/beangulp { };

  beanhub-cli = callPackage ./non-by-name/beanhub-cli { };

  beanhub-extract = callPackage ./non-by-name/beanhub-extract { };

  beanhub-forms = callPackage ./non-by-name/beanhub-forms { };

  beanhub-import = callPackage ./non-by-name/beanhub-import { };

  beanhub-inbox = callPackage ./non-by-name/beanhub-inbox { };

  beanquery = callPackage ./non-by-name/beanquery { };

  beanstalkc = callPackage ./non-by-name/beanstalkc { };

  beartype = callPackage ./non-by-name/beartype { };

  beat-this = callPackage ./non-by-name/beat-this { };

  beaupy = callPackage ./non-by-name/beaupy { };

  beautiful-date = callPackage ./non-by-name/beautiful-date { };

  beautifulsoup4 = callPackage ./non-by-name/beautifulsoup4 { };

  beautifultable = callPackage ./non-by-name/beautifultable { };

  beautysh = callPackage ./non-by-name/beautysh { };

  bech32 = callPackage ./non-by-name/bech32 { };

  beetcamp = callPackage ./non-by-name/beetcamp { };

  beets = callPackage ./non-by-name/beets {
    inherit (pkgs) chromaprint;
  };

  beets-alternatives = callPackage ./non-by-name/beets-alternatives { };

  beets-audible = callPackage ./non-by-name/beets-audible { };

  beets-copyartifacts = callPackage ./non-by-name/beets-copyartifacts { };

  beets-filetote = callPackage ./non-by-name/beets-filetote { };

  beets-importreplace = callPackage ./non-by-name/beets-importreplace { };

  beets-minimal = beets.override {
    disableAllPlugins = true;
  };

  beets-ytimport = callPackage ./non-by-name/beets-ytimport { };

  before-after = callPackage ./non-by-name/before-after { };

  behave = callPackage ./non-by-name/behave { };

  bellows = callPackage ./non-by-name/bellows { };

  bencode-py = callPackage ./non-by-name/bencode-py { };

  bencoder = callPackage ./non-by-name/bencoder { };

  bencodetools = callPackage ./non-by-name/bencodetools {
    bencodetools = pkgs.bencodetools;
  };

  beniget = callPackage ./non-by-name/beniget { };

  benqprojector = callPackage ./non-by-name/benqprojector { };

  bentoml = callPackage ./non-by-name/bentoml { };

  berkeleydb = callPackage ./non-by-name/berkeleydb { };

  besen = callPackage ./non-by-name/besen { };

  bespon = callPackage ./non-by-name/bespon { };

  betacode = callPackage ./non-by-name/betacode { };

  betamax = callPackage ./non-by-name/betamax { };

  betamax-matchers = callPackage ./non-by-name/betamax-matchers { };

  betamax-serializers = callPackage ./non-by-name/betamax-serializers { };

  better-exceptions = callPackage ./non-by-name/better-exceptions { };

  better-optimize = callPackage ./non-by-name/better-optimize { };

  betterproto = callPackage ./non-by-name/betterproto { };

  betterproto-rust-codec = callPackage ./non-by-name/betterproto-rust-codec { };

  bezier = callPackage ./non-by-name/bezier { };

  beziers = callPackage ./non-by-name/beziers { };

  bgutil-ytdlp-pot-provider = callPackage ./non-by-name/bgutil-ytdlp-pot-provider { };

  bhopengraph = callPackage ./non-by-name/bhopengraph { };

  bibtexparser = callPackage ./non-by-name/bibtexparser { };

  bibtexparser_2 = callPackage ./non-by-name/bibtexparser/2.nix { };

  bidict = callPackage ./non-by-name/bidict { };

  bids-validator = callPackage ./non-by-name/bids-validator { };

  bidsschematools = callPackage ./non-by-name/bidsschematools { };

  biliass = callPackage ./non-by-name/biliass { };

  billiard = callPackage ./non-by-name/billiard { };

  binance-connector = callPackage ./non-by-name/binance-connector { };

  binary = callPackage ./non-by-name/binary { };

  binary2strings = callPackage ./non-by-name/binary2strings { };

  binaryornot = callPackage ./non-by-name/binaryornot { };

  bincopy = callPackage ./non-by-name/bincopy { };

  bindep = callPackage ./non-by-name/bindep { };

  binho-host-adapter = callPackage ./non-by-name/binho-host-adapter { };

  binsync = callPackage ./non-by-name/binsync { };

  binwalk3 = callPackage ./non-by-name/binwalk3 { };

  biocframe = callPackage ./non-by-name/biocframe { };

  biocommons-seqrepo = callPackage ./non-by-name/biocommons-seqrepo { };

  biocutils = callPackage ./non-by-name/biocutils { };

  biom-format = callPackage ./non-by-name/biom-format { };

  biopandas = callPackage ./non-by-name/biopandas { };

  biopython = callPackage ./non-by-name/biopython { };

  biosppy = callPackage ./non-by-name/biosppy { };

  biothings-client = callPackage ./non-by-name/biothings-client { };

  bioutils = callPackage ./non-by-name/bioutils { };

  bip-utils = callPackage ./non-by-name/bip-utils { };

  bip32 = callPackage ./non-by-name/bip32 { };

  biplist = callPackage ./non-by-name/biplist { };

  birch = callPackage ./non-by-name/birch { };

  bitarray = callPackage ./non-by-name/bitarray { };

  bitbox02 = callPackage ./non-by-name/bitbox02 { };

  bitcoin-utils-fork-minimal = callPackage ./non-by-name/bitcoin-utils-fork-minimal { };

  bitcoinrpc = callPackage ./non-by-name/bitcoinrpc { };

  bite-parser = callPackage ./non-by-name/bite-parser { };

  bitlist = callPackage ./non-by-name/bitlist { };

  bitmath = callPackage ./non-by-name/bitmath { };

  bitsandbytes = callPackage ./non-by-name/bitsandbytes { };

  bitstring = callPackage ./non-by-name/bitstring { };

  bitstruct = callPackage ./non-by-name/bitstruct { };

  bittensor = callPackage ./non-by-name/bittensor { };

  bittensor-core = callPackage ./non-by-name/bittensor-core { };

  bitvavo-aio = callPackage ./non-by-name/bitvavo-aio { };

  bitvector-for-humans = callPackage ./non-by-name/bitvector-for-humans { };

  bitvis-protobuf = callPackage ./non-by-name/bitvis-protobuf { };

  bizkaibus = callPackage ./non-by-name/bizkaibus { };

  bk7231tools = callPackage ./non-by-name/bk7231tools { };

  black = callPackage ./non-by-name/black { };

  black-macchiato = callPackage ./non-by-name/black-macchiato { };

  blacken-docs = callPackage ./non-by-name/blacken-docs { };

  blackjax = callPackage ./non-by-name/blackjax { };

  blackrenderer = callPackage ./non-by-name/blackrenderer { };

  blake3 = callPackage ./non-by-name/blake3 { };

  blastdns = callPackage ./non-by-name/blastdns { };

  blasthttp = callPackage ./non-by-name/blasthttp { };

  ble-serial = callPackage ./non-by-name/ble-serial { };

  bleach = callPackage ./non-by-name/bleach { };

  bleach-allowlist = callPackage ./non-by-name/bleach-allowlist { };

  bleak = callPackage ./non-by-name/bleak { };

  bleak-esphome = callPackage ./non-by-name/bleak-esphome { };

  bleak-retry-connector = callPackage ./non-by-name/bleak-retry-connector { };

  bleak-smlight = callPackage ./non-by-name/bleak-smlight { };

  blebox-uniapi = callPackage ./non-by-name/blebox-uniapi { };

  bless = callPackage ./non-by-name/bless { };

  blessed = callPackage ./non-by-name/blessed { };

  blinker = callPackage ./non-by-name/blinker { };

  blinkpy = callPackage ./non-by-name/blinkpy { };

  blinkstick = callPackage ./non-by-name/blinkstick { };

  blis = callPackage ./non-by-name/blis { };

  blivet = callPackage ./non-by-name/blivet { };

  blobfile = callPackage ./non-by-name/blobfile { };

  block-io = callPackage ./non-by-name/block-io { };

  blockbuster = callPackage ./non-by-name/blockbuster { };

  blockchain = callPackage ./non-by-name/blockchain { };

  blockdiag = callPackage ./non-by-name/blockdiag { };

  blockfrost-python = callPackage ./non-by-name/blockfrost-python { };

  blocksat-cli = callPackage ./non-by-name/blocksat-cli { };

  bloodhound = callPackage ./non-by-name/bloodhound { };

  bloodyad = callPackage ./non-by-name/bloodyad { };

  blosc2 = callPackage ./non-by-name/blosc2 { };

  bluecurrent-api = callPackage ./non-by-name/bluecurrent-api { };

  bluemaestro-ble = callPackage ./non-by-name/bluemaestro-ble { };

  bluepy = callPackage ./non-by-name/bluepy { };

  bluepy-devices = callPackage ./non-by-name/bluepy-devices { };

  bluetooth-adapters = callPackage ./non-by-name/bluetooth-adapters { };

  bluetooth-auto-recovery = callPackage ./non-by-name/bluetooth-auto-recovery { };

  bluetooth-data-tools = callPackage ./non-by-name/bluetooth-data-tools { };

  bluetooth-sensor-state-data = callPackage ./non-by-name/bluetooth-sensor-state-data { };

  bluetti-modbus = callPackage ./non-by-name/bluetti-modbus { };

  bluezero = callPackage ./non-by-name/bluezero { };

  blurhash = callPackage ./non-by-name/blurhash { };

  blurhash-python = callPackage ./non-by-name/blurhash-python { };

  bme280spi = callPackage ./non-by-name/bme280spi { };

  bme680 = callPackage ./non-by-name/bme680 { };

  bnnumerizer = callPackage ./non-by-name/bnnumerizer { };

  bnunicodenormalizer = callPackage ./non-by-name/bnunicodenormalizer { };

  boa-api = callPackage ./non-by-name/boa-api { };

  bodhi-client = callPackage ./non-by-name/bodhi-client { };

  boilerpy3 = callPackage ./non-by-name/boilerpy3 { };

  bokeh = callPackage ./non-by-name/bokeh { };

  bokeh-sampledata = callPackage ./non-by-name/bokeh-sampledata { };

  boltons = callPackage ./non-by-name/boltons { };

  boltztrap2 = callPackage ./non-by-name/boltztrap2 { };

  bond-api = callPackage ./non-by-name/bond-api { };

  bond-async = callPackage ./non-by-name/bond-async { };

  bonsai = callPackage ./non-by-name/bonsai { };

  boolean-py = callPackage ./non-by-name/boolean-py { };

  booleanoperations = callPackage ./non-by-name/booleanoperations { };

  # Build boost for this specific Python version
  # TODO: use separate output for libboost_python.so
  boost = toPythonModule (
    pkgs.boost.override {
      inherit (self) python numpy;
      enablePython = true;
    }
  );

  boost-histogram = callPackage ./non-by-name/boost-histogram {
    inherit (pkgs) boost;
  };

  borb = callPackage ./non-by-name/borb { };

  borb_2 = callPackage ./non-by-name/borb/2.nix { };

  bork = callPackage ./non-by-name/bork { };

  bosch-alarm-mode2 = callPackage ./non-by-name/bosch-alarm-mode2 { };

  bosch-shc-camera-client = callPackage ./non-by-name/bosch-shc-camera-client { };

  boschshcpy = callPackage ./non-by-name/boschshcpy { };

  bot-safe-agents = callPackage ./non-by-name/bot-safe-agents { };

  botan3 = callPackage ./non-by-name/botan3 { inherit (pkgs) botan3; };

  boto3 = callPackage ./non-by-name/boto3 { };

  boto3-stubs = callPackage ./non-by-name/boto3-stubs { };

  botocore = callPackage ./non-by-name/botocore { };

  botocore-stubs = callPackage ./non-by-name/botocore-stubs { };

  botorch = callPackage ./non-by-name/botorch { };

  bottle = callPackage ./non-by-name/bottle { };

  bottleneck = callPackage ./non-by-name/bottleneck { };

  bottombar = callPackage ./non-by-name/bottombar { };

  bpemb = callPackage ./non-by-name/bpemb { };

  bpylist2 = callPackage ./non-by-name/bpylist2 { };

  bpython = callPackage ./non-by-name/bpython { };

  bqplot = callPackage ./non-by-name/bqplot { };

  bqscales = callPackage ./non-by-name/bqscales { };

  braceexpand = callPackage ./non-by-name/braceexpand { };

  bracex = callPackage ./non-by-name/bracex { };

  brainflow = callPackage ./non-by-name/brainflow { inherit (pkgs) brainflow; };

  braintree = callPackage ./non-by-name/braintree { };

  branca = callPackage ./non-by-name/branca { };

  braq = callPackage ./non-by-name/braq { };

  bravado-core = callPackage ./non-by-name/bravado-core { };

  bravia-tv = callPackage ./non-by-name/bravia-tv { };

  brax = callPackage ./non-by-name/brax { };

  breathe = callPackage ./non-by-name/breathe { };

  breezy = callPackage ./non-by-name/breezy { };

  brei = callPackage ./non-by-name/brei { };

  brelpy = callPackage ./non-by-name/brelpy { };

  brevo-python = callPackage ./non-by-name/brevo-python { };

  brian2 = callPackage ./non-by-name/brian2 { };

  bring-api = callPackage ./non-by-name/bring-api { };

  broadbean = callPackage ./non-by-name/broadbean { };

  broadlink = callPackage ./non-by-name/broadlink { };

  broadlink-async = callPackage ./non-by-name/broadlink-async { };

  brother = callPackage ./non-by-name/brother { };

  brother-ql-next = callPackage ./non-by-name/brother-ql-next { };

  brotli = callPackage ./non-by-name/brotli {
    inherit (pkgs) brotli;
  };

  brotli-asgi = callPackage ./non-by-name/brotli-asgi { };

  brotlicffi = callPackage ./non-by-name/brotlicffi { inherit (pkgs) brotli; };

  brotlipy = callPackage ./non-by-name/brotlipy { };

  brottsplatskartan = callPackage ./non-by-name/brottsplatskartan { };

  browser-cookie3 = callPackage ./non-by-name/browser-cookie3 { };

  browserforge = callPackage ./non-by-name/browserforge { };

  brunt = callPackage ./non-by-name/brunt { };

  bsdiff4 = callPackage ./non-by-name/bsdiff4 { };

  bson = callPackage ./non-by-name/bson { };

  bsuite = callPackage ./non-by-name/bsuite { };

  bt-decode = callPackage ./non-by-name/bt-decode { };

  bt-proximity = callPackage ./non-by-name/bt-proximity { };

  btchip-python = callPackage ./non-by-name/btchip-python { };

  btest = callPackage ./non-by-name/btest { };

  bthome-ble = callPackage ./non-by-name/bthome-ble { };

  bthomehub5-devicelist = callPackage ./non-by-name/bthomehub5-devicelist { };

  btlewrap = callPackage ./non-by-name/btlewrap { };

  btrees = callPackage ./non-by-name/btrees { };

  btrfs = callPackage ./non-by-name/btrfs { };

  btrfsutil = callPackage ./non-by-name/btrfsutil { };

  btrsync = callPackage ./non-by-name/btrsync { };

  btsmarthub-devicelist = callPackage ./non-by-name/btsmarthub-devicelist { };

  btsocket = callPackage ./non-by-name/btsocket { };

  bubop = callPackage ./non-by-name/bubop { };

  bucketstore = callPackage ./non-by-name/bucketstore { };

  bugsnag = callPackage ./non-by-name/bugsnag { };

  bugwarrior = callPackage ./non-by-name/bugwarrior { };

  buienradar = callPackage ./non-by-name/buienradar { };

  build = callPackage ./non-by-name/build { };

  buildcatrust = callPackage ./non-by-name/buildcatrust { };

  buildstream-plugins = callPackage ./non-by-name/buildstream-plugins { };

  buildstream-plugins-community = callPackage ./non-by-name/buildstream-plugins-community { };

  bumble = callPackage ./non-by-name/bumble { };

  bump-my-version = callPackage ./non-by-name/bump-my-version { };

  bump2version = callPackage ./non-by-name/bump2version { };

  bumps = callPackage ./non-by-name/bumps { };

  bundlewrap = callPackage ./non-by-name/bundlewrap { };

  bundlewrap-keepass = callPackage ./non-by-name/bundlewrap-keepass { };

  bundlewrap-pass = callPackage ./non-by-name/bundlewrap-pass { };

  bundlewrap-teamvault = callPackage ./non-by-name/bundlewrap-teamvault { };

  burner-redis = callPackage ./non-by-name/burner-redis { };

  busylight-core = callPackage ./non-by-name/busylight-core { };

  busylight-for-humans = callPackage ./non-by-name/busylight-for-humans { };

  busypie = callPackage ./non-by-name/busypie { };

  bwapy = callPackage ./non-by-name/bwapy { };

  bx-py-utils = callPackage ./non-by-name/bx-py-utils { };

  bx-python = callPackage ./non-by-name/bx-python { };

  bytecode = callPackage ./non-by-name/bytecode { };

  bytesize = toPythonModule (pkgs.libbytesize.override { python3Packages = self; });

  bytestruct = callPackage ./non-by-name/bytestruct { };

  bytewax = callPackage ./non-by-name/bytewax { };

  cache = callPackage ./non-by-name/cache { };

  cachecontrol = callPackage ./non-by-name/cachecontrol { };

  cached-ipaddress = callPackage ./non-by-name/cached-ipaddress { };

  cached-property = callPackage ./non-by-name/cached-property { };

  cachelib = callPackage ./non-by-name/cachelib { };

  cachetools = callPackage ./non-by-name/cachetools { };

  cachey = callPackage ./non-by-name/cachey { };

  cachier = callPackage ./non-by-name/cachier { };

  cachy = callPackage ./non-by-name/cachy { };

  cadwyn = callPackage ./non-by-name/cadwyn { };

  caffe = toPythonModule (
    pkgs.caffe.override {
      pythonSupport = true;
      inherit (self) python numpy boost;
    }
  );

  caido-schema-proxy = callPackage ./non-by-name/caido-schema-proxy { };

  caido-sdk-client = callPackage ./non-by-name/caido-sdk-client { };

  caido-server-auth = callPackage ./non-by-name/caido-server-auth { };

  caio = callPackage ./non-by-name/caio { };

  cairocffi = callPackage ./non-by-name/cairocffi { };

  cairosvg = callPackage ./non-by-name/cairosvg { };

  caldav = callPackage ./non-by-name/caldav { };

  calendaring-config = callPackage ./non-by-name/calendaring-config { };

  callee = callPackage ./non-by-name/callee { };

  calmjs = callPackage ./non-by-name/calmjs { };

  calmjs-parse = callPackage ./non-by-name/calmjs-parse { };

  calmjs-types = callPackage ./non-by-name/calmjs-types { };

  calmsize = callPackage ./non-by-name/calmsize { };

  calver = callPackage ./non-by-name/calver { };

  calysto = callPackage ./non-by-name/calysto { };

  camel-converter = callPackage ./non-by-name/camel-converter { };

  camelot = callPackage ./non-by-name/camelot { };

  can-isotp = callPackage ./non-by-name/can-isotp { };

  canals = callPackage ./non-by-name/canals { };

  canmatrix = callPackage ./non-by-name/canmatrix { };

  canonical-sphinx-extensions = callPackage ./non-by-name/canonical-sphinx-extensions { };

  canonicaljson = callPackage ./non-by-name/canonicaljson { };

  canopen = callPackage ./non-by-name/canopen { };

  cantools = callPackage ./non-by-name/cantools { };

  capstone = callPackage ./non-by-name/capstone { inherit (pkgs) capstone; };

  capstone_4 = callPackage ./non-by-name/capstone/4.nix {
    inherit (pkgs) capstone_4;
  };

  captcha = callPackage ./non-by-name/captcha { };

  captum = callPackage ./non-by-name/captum { };

  capturer = callPackage ./non-by-name/capturer { };

  carbon = callPackage ./non-by-name/carbon { };

  cardano-tools = callPackage ./non-by-name/cardano-tools { };

  cardimpose = callPackage ./non-by-name/cardimpose { };

  cart = callPackage ./non-by-name/cart { };

  cartopy = callPackage ./non-by-name/cartopy { };

  casa-formats-io = callPackage ./non-by-name/casa-formats-io { };

  casaconfig = callPackage ./non-by-name/casaconfig { };

  casadi = toPythonModule (
    pkgs.casadi.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  casatasks = callPackage ./non-by-name/casatasks { };

  casatools = callPackage ./non-by-name/casatools { };

  case-converter = callPackage ./non-by-name/case-converter { };

  cashaddress = callPackage ./non-by-name/cashaddress { };

  cashews = callPackage ./non-by-name/cashews { };

  cassandra-driver = callPackage ./non-by-name/cassandra-driver { };

  castepxbin = callPackage ./non-by-name/castepxbin { };

  casttube = callPackage ./non-by-name/casttube { };

  catalogue = callPackage ./non-by-name/catalogue { };

  catalyst = toPythonModule (
    pkgs.catalyst.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  catboost = callPackage ./non-by-name/catboost {
    catboost = pkgs.catboost.override {
      pythonSupport = true;
      python3Packages = self;
    };
  };

  categorical-distance = callPackage ./non-by-name/categorical-distance { };

  category-encoders = callPackage ./non-by-name/category-encoders { };

  catkin-pkg = callPackage ./non-by-name/catkin-pkg { };

  catppuccin = callPackage ./non-by-name/catppuccin { };

  cattrs = callPackage ./non-by-name/cattrs { };

  causal-conv1d = callPackage ./non-by-name/causal-conv1d { };

  cbor = callPackage ./non-by-name/cbor { };

  cbor2 = callPackage ./non-by-name/cbor2 { };

  cbor2WithoutCExtensions = callPackage ./non-by-name/cbor2 {
    withCExtensions = false;
  };

  cccolutils = callPackage ./non-by-name/cccolutils { krb5-c = pkgs.krb5; };

  cdcs = callPackage ./non-by-name/cdcs { };

  cddlparser = callPackage ./non-by-name/cddlparser { };

  cdxj-indexer = callPackage ./non-by-name/cdxj-indexer { };

  cec = callPackage ./non-by-name/cec { };

  cel-python = callPackage ./non-by-name/cel-python { };

  celery = callPackage ./non-by-name/celery { };

  celery-batches = callPackage ./non-by-name/celery-batches { };

  celery-redbeat = callPackage ./non-by-name/celery-redbeat { };

  celery-singleton = callPackage ./non-by-name/celery-singleton { };

  celery-types = callPackage ./non-by-name/celery-types { };

  cement = callPackage ./non-by-name/cement { };

  cemm = callPackage ./non-by-name/cemm { };

  censys = callPackage ./non-by-name/censys { };

  cerberus = callPackage ./non-by-name/cerberus { };

  cert-chain-resolver = callPackage ./non-by-name/cert-chain-resolver { };

  certauth = callPackage ./non-by-name/certauth { };

  certbot = callPackage ./non-by-name/certbot { };

  certbot-dns-cloudflare = callPackage ./non-by-name/certbot-dns-cloudflare { };

  certbot-dns-google = callPackage ./non-by-name/certbot-dns-google { };

  certbot-dns-inwx = callPackage ./non-by-name/certbot-dns-inwx { };

  certbot-dns-ovh = callPackage ./non-by-name/certbot-dns-ovh { };

  certbot-dns-rfc2136 = callPackage ./non-by-name/certbot-dns-rfc2136 { };

  certbot-dns-route53 = callPackage ./non-by-name/certbot-dns-route53 { };

  certbot-dns-wedos = callPackage ./non-by-name/certbot-dns-wedos { };

  certbot-nginx = callPackage ./non-by-name/certbot-nginx { };

  certifi = callPackage ./non-by-name/certifi { };

  certihound = callPackage ./non-by-name/certihound { };

  certipy = callPackage ./non-by-name/certipy { };

  certipy-ad = callPackage ./non-by-name/certipy-ad { };

  certomancer = callPackage ./non-by-name/certomancer { };

  certvalidator = callPackage ./non-by-name/certvalidator { };

  cexprtk = callPackage ./non-by-name/cexprtk { };

  cf-xarray = callPackage ./non-by-name/cf-xarray { };

  cffconvert = callPackage ./non-by-name/cffconvert { };

  cffi = if isPyPy then null else callPackage ./non-by-name/cffi { };

  cffsubr = callPackage ./non-by-name/cffsubr { };

  cfgv = callPackage ./non-by-name/cfgv { };

  cflib = callPackage ./non-by-name/cflib { };

  cfn-flip = callPackage ./non-by-name/cfn-flip { };

  cfn-lint = callPackage ./non-by-name/cfn-lint { };

  cfscrape = callPackage ./non-by-name/cfscrape { };

  cftime = callPackage ./non-by-name/cftime { };

  cgal = callPackage ./non-by-name/cgal { inherit (pkgs) cgal; };

  cgen = callPackage ./non-by-name/cgen { };

  cgroup-utils = callPackage ./non-by-name/cgroup-utils { };

  chacha20poly1305 = callPackage ./non-by-name/chacha20poly1305 { };

  chacha20poly1305-reuseable = callPackage ./non-by-name/chacha20poly1305-reuseable { };

  chainmap = callPackage ./non-by-name/chainmap { };

  chainstream = callPackage ./non-by-name/chainstream { };

  chalice = callPackage ./non-by-name/chalice { };

  chameleon = callPackage ./non-by-name/chameleon { };

  changelog-chug = callPackage ./non-by-name/changelog-chug { };

  channels = callPackage ./non-by-name/channels { };

  channels-redis = callPackage ./non-by-name/channels-redis { };

  character-encoding-utils = callPackage ./non-by-name/character-encoding-utils { };

  chardet = callPackage ./non-by-name/chardet { };

  chardet_5 = callPackage ./non-by-name/chardet/5.nix { };

  charset-normalizer = callPackage ./non-by-name/charset-normalizer { };

  chat-downloader = callPackage ./non-by-name/chat-downloader { };

  chatlas = callPackage ./non-by-name/chatlas { };

  check-manifest = callPackage ./non-by-name/check-manifest { };

  checkdmarc = callPackage ./non-by-name/checkdmarc { };

  checkpoint-schedules = callPackage ./non-by-name/checkpoint-schedules { };

  checksumdir = callPackage ./non-by-name/checksumdir { };

  chefiq-ble = callPackage ./non-by-name/chefiq-ble { };

  cheroot = callPackage ./non-by-name/cheroot { };

  cherrypy = callPackage ./non-by-name/cherrypy { };

  cherrypy-cors = callPackage ./non-by-name/cherrypy-cors { };

  chess = callPackage ./non-by-name/chess { };

  chess-com-api = callPackage ./non-by-name/chess-com-api { };

  chevron = callPackage ./non-by-name/chevron { };

  chex = callPackage ./non-by-name/chex { };

  chipwhisperer = callPackage ./non-by-name/chipwhisperer { };

  chirpstack-api = callPackage ./non-by-name/chirpstack-api { };

  chispa = callPackage ./non-by-name/chispa { };

  choreographer = callPackage ./non-by-name/choreographer { };

  chroma-hnswlib = callPackage ./non-by-name/chroma-hnswlib { };

  chromadb = callPackage ./non-by-name/chromadb { zstd-c = pkgs.zstd; };

  ci-info = callPackage ./non-by-name/ci-info { };

  ci-py = callPackage ./non-by-name/ci-py { };

  cielo-connect-api = callPackage ./non-by-name/cielo-connect-api { };

  cinemagoer = callPackage ./non-by-name/cinemagoer { };

  circuit-webhook = callPackage ./non-by-name/circuit-webhook { };

  circuitbreaker = callPackage ./non-by-name/circuitbreaker { };

  circus = callPackage ./non-by-name/circus { };

  cirq = callPackage ./non-by-name/cirq { };

  cirq-aqt = callPackage ./non-by-name/cirq-aqt { };

  cirq-core = callPackage ./non-by-name/cirq-core { };

  cirq-google = callPackage ./non-by-name/cirq-google { };

  cirq-ionq = callPackage ./non-by-name/cirq-ionq { };

  cirq-pasqal = callPackage ./non-by-name/cirq-pasqal { };

  cirq-web = callPackage ./non-by-name/cirq-web { };

  ciscoconfparse2 = callPackage ./non-by-name/ciscoconfparse2 { };

  ciscomobilityexpress = callPackage ./non-by-name/ciscomobilityexpress { };

  ciso8601 = callPackage ./non-by-name/ciso8601 { };

  citeproc-py = callPackage ./non-by-name/citeproc-py { };

  citeproc-py-styles = callPackage ./non-by-name/citeproc-py-styles { };

  cjkwrap = callPackage ./non-by-name/cjkwrap { };

  ckcc-protocol = callPackage ./non-by-name/ckcc-protocol { };

  ckzg = callPackage ./non-by-name/ckzg {
    inherit (pkgs) clang;
  };

  clang = callPackage ./non-by-name/clang { };

  clarabel = callPackage ./non-by-name/clarabel { };

  clarifai = callPackage ./non-by-name/clarifai { };

  clarifai-grpc = callPackage ./non-by-name/clarifai-grpc { };

  clarifai-protocol = callPackage ./non-by-name/clarifai-protocol { };

  classify-imports = callPackage ./non-by-name/classify-imports { };

  claude-agent-sdk = callPackage ./non-by-name/claude-agent-sdk { };

  cle = callPackage ./non-by-name/cle { };

  clean-fid = callPackage ./non-by-name/clean-fid { };

  cleanit = callPackage ./non-by-name/cleanit { };

  cleanlab = callPackage ./non-by-name/cleanlab { };

  cleanvision = callPackage ./non-by-name/cleanvision { };

  clearpasspy = callPackage ./non-by-name/clearpasspy { };

  cleo = callPackage ./non-by-name/cleo { };

  clevercsv = callPackage ./non-by-name/clevercsv { };

  clf = callPackage ./non-by-name/clf { };

  cli-helpers = callPackage ./non-by-name/cli-helpers { };

  cli-ui = callPackage ./non-by-name/cli-ui { };

  cliche = callPackage ./non-by-name/cliche { };

  click = callPackage ./non-by-name/click { };

  click-aliases = callPackage ./non-by-name/click-aliases { };

  click-command-tree = callPackage ./non-by-name/click-command-tree { };

  click-completion = callPackage ./non-by-name/click-completion { };

  click-configfile = callPackage ./non-by-name/click-configfile { };

  click-datetime = callPackage ./non-by-name/click-datetime { };

  click-default-group = callPackage ./non-by-name/click-default-group { };

  click-didyoumean = callPackage ./non-by-name/click-didyoumean { };

  click-help-colors = callPackage ./non-by-name/click-help-colors { };

  click-log = callPackage ./non-by-name/click-log { };

  click-odoo = callPackage ./non-by-name/click-odoo { };

  click-odoo-contrib = callPackage ./non-by-name/click-odoo-contrib { };

  click-option-group = callPackage ./non-by-name/click-option-group { };

  click-plugins = callPackage ./non-by-name/click-plugins { };

  click-repl = callPackage ./non-by-name/click-repl { };

  click-shell = callPackage ./non-by-name/click-shell { };

  click-spinner = callPackage ./non-by-name/click-spinner { };

  click-threading = callPackage ./non-by-name/click-threading { };

  clickclick = callPackage ./non-by-name/clickclick { };

  clickdc = callPackage ./non-by-name/clickdc { };

  clickgen = callPackage ./non-by-name/clickgen { };

  clickhouse-cityhash = callPackage ./non-by-name/clickhouse-cityhash { };

  clickhouse-cli = callPackage ./non-by-name/clickhouse-cli { };

  clickhouse-connect = callPackage ./non-by-name/clickhouse-connect { };

  clickhouse-driver = callPackage ./non-by-name/clickhouse-driver { };

  clickhouse-sqlalchemy = callPackage ./non-by-name/clickhouse-sqlalchemy { };

  cliff = callPackage ./non-by-name/cliff { };

  clifford = callPackage ./non-by-name/clifford { };

  cligj = callPackage ./non-by-name/cligj { };

  clikit = callPackage ./non-by-name/clikit { };

  clingo = toPythonModule (
    pkgs.clingo.override {
      inherit python;
      withPython = true;
    }
  );

  clint = callPackage ./non-by-name/clint { };

  clintermission = callPackage ./non-by-name/clintermission { };

  clip = callPackage ./non-by-name/clip { };

  clip-anytorch = callPackage ./non-by-name/clip-anytorch { };

  clipman = callPackage ./non-by-name/clipman { };

  clize = callPackage ./non-by-name/clize { };

  clldutils = callPackage ./non-by-name/clldutils { };

  cloudcheck = callPackage ./non-by-name/cloudcheck { };

  cloudevents = callPackage ./non-by-name/cloudevents { };

  cloudflare = callPackage ./non-by-name/cloudflare { };

  cloudpathlib = callPackage ./non-by-name/cloudpathlib { };

  cloudpickle = callPackage ./non-by-name/cloudpickle { };

  cloudscraper = callPackage ./non-by-name/cloudscraper { };

  cloudsmith-api = callPackage ./non-by-name/cloudsmith-api { };

  cloudsplaining = callPackage ./non-by-name/cloudsplaining { };

  cloup = callPackage ./non-by-name/cloup { };

  clr-loader = callPackage ./non-by-name/clr-loader { };

  cltk = callPackage ./non-by-name/cltk { };

  clu = callPackage ./non-by-name/clu { };

  clustershell = callPackage ./non-by-name/clustershell { };

  clx-sdk-xms = callPackage ./non-by-name/clx-sdk-xms { };

  cma = callPackage ./non-by-name/cma { };

  cmaes = callPackage ./non-by-name/cmaes { };

  cmake = callPackage ./non-by-name/cmake { inherit (pkgs) cmake; };

  cmake-build-extension = callPackage ./non-by-name/cmake-build-extension { };

  cmake-parser = callPackage ./non-by-name/cmake-parser { };

  cmarkgfm = callPackage ./non-by-name/cmarkgfm { };

  cmd2 = callPackage ./non-by-name/cmd2 { };

  cmd2-ext-test = callPackage ./non-by-name/cmd2-ext-test { };

  cmd2_3 = callPackage ./non-by-name/cmd2_3 { };

  cmdline = callPackage ./non-by-name/cmdline { };

  cmdstanpy = callPackage ./non-by-name/cmdstanpy { };

  cmigemo = callPackage ./non-by-name/cmigemo { inherit (pkgs) cmigemo; };

  cmsdials = callPackage ./non-by-name/cmsdials { };

  cmsis-pack-manager = callPackage ./non-by-name/cmsis-pack-manager { };

  cmsis-svd = callPackage ./non-by-name/cmsis-svd { };

  cmudict = callPackage ./non-by-name/cmudict { };

  cnvkit = callPackage ./non-by-name/cnvkit { };

  co2signal = callPackage ./non-by-name/co2signal { };

  coal = callPackage ./non-by-name/coal { inherit (pkgs) coal; };

  coapthon3 = callPackage ./non-by-name/coapthon3 { };

  cobble = callPackage ./non-by-name/cobble { };

  cobs = callPackage ./non-by-name/cobs { };

  cock = callPackage ./non-by-name/cock { };

  coconut = callPackage ./non-by-name/coconut { };

  cocotb = callPackage ./non-by-name/cocotb { };

  cocotb-bus = callPackage ./non-by-name/cocotb-bus { };

  codecarbon = callPackage ./non-by-name/codecarbon { };

  codepy = callPackage ./non-by-name/codepy { };

  coffea = callPackage ./non-by-name/coffea { };

  cogapp = callPackage ./non-by-name/cogapp { };

  cohere = callPackage ./non-by-name/cohere { };

  coiled = callPackage ./non-by-name/coiled { };

  coinbase-advanced-py = callPackage ./non-by-name/coinbase-advanced-py { };

  coincidence = callPackage ./non-by-name/coincidence { };

  coincurve = callPackage ./non-by-name/coincurve { inherit (pkgs) secp256k1; };

  coinmetrics-api-client = callPackage ./non-by-name/coinmetrics-api-client { };

  colander = callPackage ./non-by-name/colander { };

  colanderalchemy = callPackage ./non-by-name/colanderalchemy { };

  colbert-ai = callPackage ./non-by-name/colbert-ai { };

  colcon = callPackage ./non-by-name/colcon { };

  colcon-argcomplete = callPackage ./non-by-name/colcon-argcomplete { };

  colcon-bash = callPackage ./non-by-name/colcon-bash { };

  colcon-cargo = callPackage ./non-by-name/colcon-cargo { };

  colcon-cd = callPackage ./non-by-name/colcon-cd { };

  colcon-coveragepy-result = callPackage ./non-by-name/colcon-coveragepy-result { };

  colcon-defaults = callPackage ./non-by-name/colcon-defaults { };

  colcon-devtools = callPackage ./non-by-name/colcon-devtools { };

  colcon-ed = callPackage ./non-by-name/colcon-ed { };

  colcon-hardware-acceleration = callPackage ./non-by-name/colcon-hardware-acceleration { };

  colcon-installed-package-information =
    callPackage ./non-by-name/colcon-installed-package-information
      { };

  colcon-library-path = callPackage ./non-by-name/colcon-library-path { };

  colcon-metadata = callPackage ./non-by-name/colcon-metadata { };

  colcon-mixin = callPackage ./non-by-name/colcon-mixin { };

  colcon-notification = callPackage ./non-by-name/colcon-notification { };

  colcon-output = callPackage ./non-by-name/colcon-output { };

  colcon-package-information = callPackage ./non-by-name/colcon-package-information { };

  colcon-package-selection = callPackage ./non-by-name/colcon-package-selection { };

  colcon-parallel-executor = callPackage ./non-by-name/colcon-parallel-executor { };

  colcon-python-setup-py = callPackage ./non-by-name/colcon-python-setup-py { };

  colcon-recursive-crawl = callPackage ./non-by-name/colcon-recursive-crawl { };

  colcon-ros-domain-id-coordinator = callPackage ./non-by-name/colcon-ros-domain-id-coordinator { };

  colcon-test-result = callPackage ./non-by-name/colcon-test-result { };

  colcon-zsh = callPackage ./non-by-name/colcon-zsh { };

  collections-extended = callPackage ./non-by-name/collections-extended { };

  collidoscope = callPackage ./non-by-name/collidoscope { };

  color-matcher = callPackage ./non-by-name/color-matcher { };

  color-operations = callPackage ./non-by-name/color-operations { };

  color-parser-py = callPackage ./non-by-name/color-parser-py { };

  coloraide = callPackage ./non-by-name/coloraide { };

  colorama = callPackage ./non-by-name/colorama { };

  colorcet = callPackage ./non-by-name/colorcet { };

  colorclass = callPackage ./non-by-name/colorclass { };

  colored = callPackage ./non-by-name/colored { };

  colored-traceback = callPackage ./non-by-name/colored-traceback { };

  coloredlogs = callPackage ./non-by-name/coloredlogs { };

  colorful = callPackage ./non-by-name/colorful { };

  colorlog = callPackage ./non-by-name/colorlog { };

  colorlover = callPackage ./non-by-name/colorlover { };

  colormath = callPackage ./non-by-name/colormath { };

  colormath2 = callPackage ./non-by-name/colormath2 { };

  colorscript = callPackage ./non-by-name/colorscript { };

  colorspacious = callPackage ./non-by-name/colorspacious { };

  colorthief = callPackage ./non-by-name/colorthief { };

  colorzero = callPackage ./non-by-name/colorzero { };

  colour = callPackage ./non-by-name/colour { };

  colout = callPackage ./non-by-name/colout { };

  columnize = callPackage ./non-by-name/columnize { };

  comet-ml = callPackage ./non-by-name/comet-ml { };

  cometblue-lite = callPackage ./non-by-name/cometblue-lite { };

  cometx = callPackage ./non-by-name/cometx { };

  comfy-aimdo = callPackage ./non-by-name/comfy-aimdo { };

  comfy-angle = callPackage ./non-by-name/comfy-angle { };

  comfy-kitchen = callPackage ./non-by-name/comfy-kitchen { };

  comfyui-embedded-docs = callPackage ./non-by-name/comfyui-embedded-docs { };

  comfyui-frontend-package = callPackage ./non-by-name/comfyui-frontend-package { };

  comfyui-manager = callPackage ./non-by-name/comfyui-manager { };

  comfyui-workflow-templates = callPackage ./non-by-name/comfyui-workflow-templates { };

  comfyui-workflow-templates-core = callPackage ./non-by-name/comfyui-workflow-templates-core { };

  comfyui-workflow-templates-json = callPackage ./non-by-name/comfyui-workflow-templates-json { };

  comfyui-workflow-templates-media-api =
    callPackage ./non-by-name/comfyui-workflow-templates-media-api
      { };

  comfyui-workflow-templates-media-assets-01 =
    callPackage ./non-by-name/comfyui-workflow-templates-media-assets-01
      { };

  comfyui-workflow-templates-media-assets-02 =
    callPackage ./non-by-name/comfyui-workflow-templates-media-assets-02
      { };

  comfyui-workflow-templates-media-image =
    callPackage ./non-by-name/comfyui-workflow-templates-media-image
      { };

  comfyui-workflow-templates-media-other =
    callPackage ./non-by-name/comfyui-workflow-templates-media-other
      { };

  comfyui-workflow-templates-media-video =
    callPackage ./non-by-name/comfyui-workflow-templates-media-video
      { };

  comicapi = callPackage ./non-by-name/comicapi { };

  comicon = callPackage ./non-by-name/comicon { };

  comm = callPackage ./non-by-name/comm { };

  command-runner = callPackage ./non-by-name/command-runner { };

  commandlines = callPackage ./non-by-name/commandlines { };

  commandparse = callPackage ./non-by-name/commandparse { };

  commentjson = callPackage ./non-by-name/commentjson { };

  commoncode = callPackage ./non-by-name/commoncode { };

  commonmark = callPackage ./non-by-name/commonmark { };

  commonregex = callPackage ./non-by-name/commonregex { };

  compit-inext-api = callPackage ./non-by-name/compit-inext-api { };

  compliance-trestle = callPackage ./non-by-name/compliance-trestle { };

  complycube = callPackage ./non-by-name/complycube { };

  compreffor = callPackage ./non-by-name/compreffor { };

  compressai = callPackage ./non-by-name/compressai { };

  compressed-rtf = callPackage ./non-by-name/compressed-rtf { };

  compressed-tensors = callPackage ./non-by-name/compressed-tensors { };

  concord232 = callPackage ./non-by-name/concord232 { };

  concurrent-log-handler = callPackage ./non-by-name/concurrent-log-handler { };

  conda = callPackage ./non-by-name/conda { };

  conda-inject = callPackage ./non-by-name/conda-inject { };

  conda-libmamba-solver = callPackage ./non-by-name/conda-libmamba-solver { };

  conda-package-handling = callPackage ./non-by-name/conda-package-handling { };

  conda-package-streaming = callPackage ./non-by-name/conda-package-streaming { };

  condense-json = callPackage ./non-by-name/condense-json { };

  conduit = callPackage ./non-by-name/conduit { };

  conduit-mpi = callPackage ./non-by-name/conduit { mpiSupport = true; };

  confection = callPackage ./non-by-name/confection { };

  configargparse = callPackage ./non-by-name/configargparse { };

  configclass = callPackage ./non-by-name/configclass { };

  confight = callPackage ./non-by-name/confight { };

  configobj = callPackage ./non-by-name/configobj { };

  configparser = callPackage ./non-by-name/configparser { };

  configshell-fb = callPackage ./non-by-name/configshell-fb { };

  configupdater = callPackage ./non-by-name/configupdater { };

  confluent-kafka = callPackage ./non-by-name/confluent-kafka { };

  confusable-homoglyphs = callPackage ./non-by-name/confusable-homoglyphs { };

  confuse = callPackage ./non-by-name/confuse { };

  conjure-python-client = callPackage ./non-by-name/conjure-python-client { };

  connect-box = callPackage ./non-by-name/connect-box { };

  connect-box3 = callPackage ./non-by-name/connect-box3 { };

  connected-components-3d = callPackage ./non-by-name/connected-components-3d { };

  connection-pool = callPackage ./non-by-name/connection-pool { };

  connectrpc = callPackage ./non-by-name/connectrpc { };

  connexion = callPackage ./non-by-name/connexion { };

  connio = callPackage ./non-by-name/connio { };

  cons = callPackage ./non-by-name/cons { };

  consolekit = callPackage ./non-by-name/consolekit { };

  consonance = callPackage ./non-by-name/consonance { };

  constantdict = callPackage ./non-by-name/constantdict { };

  constantly = callPackage ./non-by-name/constantly { };

  construct = callPackage ./non-by-name/construct { };

  construct-classes = callPackage ./non-by-name/construct-classes { };

  construct-typing = callPackage ./non-by-name/construct-typing { };

  consul = callPackage ./non-by-name/consul { };

  container-inspector = callPackage ./non-by-name/container-inspector { };

  contexter = callPackage ./non-by-name/contexter { };

  contextlib2 = callPackage ./non-by-name/contextlib2 { };

  contexttimer = callPackage ./non-by-name/contexttimer { };

  contourpy = callPackage ./non-by-name/contourpy { };

  controku = callPackage ./non-by-name/controku { };

  control = callPackage ./non-by-name/control { };

  convertdate = callPackage ./non-by-name/convertdate { };

  convertertools = callPackage ./non-by-name/convertertools { };

  conway-polynomials = callPackage ./non-by-name/conway-polynomials { };

  cookidoo-api = callPackage ./non-by-name/cookidoo-api { };

  cookiecutter = callPackage ./non-by-name/cookiecutter { };

  cookies = callPackage ./non-by-name/cookies { };

  coolname = callPackage ./non-by-name/coolname { };

  coordinates = callPackage ./non-by-name/coordinates { };

  copier = callPackage ./non-by-name/copier { };

  copier-template-tester = callPackage ./non-by-name/copier-template-tester { };

  copr = callPackage ./non-by-name/copr { };

  copykitten = callPackage ./non-by-name/copykitten { };

  coq-tools = callPackage ./non-by-name/coq-tools { };

  coqpit = callPackage ./non-by-name/coqpit { };

  corallium = callPackage ./non-by-name/corallium { };

  coreapi = callPackage ./non-by-name/coreapi { };

  coredis = callPackage ./non-by-name/coredis { };

  coreschema = callPackage ./non-by-name/coreschema { };

  corner = callPackage ./non-by-name/corner { };

  cornice = callPackage ./non-by-name/cornice { };

  correctionlib = callPackage ./non-by-name/correctionlib { };

  corsair-scan = callPackage ./non-by-name/corsair-scan { };

  cose = callPackage ./non-by-name/cose { };

  cot = callPackage ./non-by-name/cot { inherit (pkgs) qemu; };

  country-list = callPackage ./non-by-name/country-list { };

  countryguess = callPackage ./non-by-name/countryguess { };

  countryinfo = callPackage ./non-by-name/countryinfo { };

  courlan = callPackage ./non-by-name/courlan { };

  covdefaults = callPackage ./non-by-name/covdefaults { };

  coverage = callPackage ./non-by-name/coverage { };

  coveralls = callPackage ./non-by-name/coveralls { };

  cpace = callPackage ./non-by-name/cpace { };

  cpe = callPackage ./non-by-name/cpe { };

  cpe-search = callPackage ./non-by-name/cpe-search { };

  cppe = callPackage ./non-by-name/cppe { inherit (pkgs) cppe; };

  cppheaderparser = callPackage ./non-by-name/cppheaderparser { };

  cppimport = callPackage ./non-by-name/cppimport { };

  cppy = callPackage ./non-by-name/cppy { };

  cpufeature = callPackage ./non-by-name/cpufeature { };

  cpyparsing = callPackage ./non-by-name/cpyparsing { };

  cram = callPackage ./non-by-name/cram { };

  cramjam = callPackage ./non-by-name/cramjam {
    inherit (pkgs) zstd;
  };

  crashtest = callPackage ./non-by-name/crashtest { };

  crate = callPackage ./non-by-name/crate { };

  crawl4ai = callPackage ./non-by-name/crawl4ai { };

  crayons = callPackage ./non-by-name/crayons { };

  crc = callPackage ./non-by-name/crc { };

  crc16 = callPackage ./non-by-name/crc16 { };

  crc32c = callPackage ./non-by-name/crc32c { };

  crccheck = callPackage ./non-by-name/crccheck { };

  crcelk = callPackage ./non-by-name/crcelk { };

  crcmod = callPackage ./non-by-name/crcmod { };

  credstash = callPackage ./non-by-name/credstash { };

  credsweeper = callPackage ./non-by-name/credsweeper { };

  crewai = callPackage ./non-by-name/crewai { };

  crewai-cli = callPackage ./non-by-name/crewai-cli { };

  crewai-core = callPackage ./non-by-name/crewai-core { };

  crispy-bootstrap3 = callPackage ./non-by-name/crispy-bootstrap3 { };

  crispy-bootstrap4 = callPackage ./non-by-name/crispy-bootstrap4 { };

  crispy-bootstrap5 = callPackage ./non-by-name/crispy-bootstrap5 { };

  crochet = callPackage ./non-by-name/crochet { };

  crocoddyl = callPackage ./non-by-name/crocoddyl { inherit (pkgs) crocoddyl; };

  cron-converter = callPackage ./non-by-name/cron-converter { };

  cron-descriptor = callPackage ./non-by-name/cron-descriptor { };

  croniter = callPackage ./non-by-name/croniter { };

  cronsim = callPackage ./non-by-name/cronsim { };

  cross-web = callPackage ./non-by-name/cross-web { };

  crossandra = callPackage ./non-by-name/crossandra { };

  crossplane = callPackage ./non-by-name/crossplane { };

  crowdstrike-falconpy = callPackage ./non-by-name/crowdstrike-falconpy { };

  crownstone-cloud = callPackage ./non-by-name/crownstone-cloud { };

  crownstone-core = callPackage ./non-by-name/crownstone-core { };

  crownstone-sse = callPackage ./non-by-name/crownstone-sse { };

  crownstone-uart = callPackage ./non-by-name/crownstone-uart { };

  crypt4gh = callPackage ./non-by-name/crypt4gh { };

  cryptg = callPackage ./non-by-name/cryptg { };

  cryptodatahub = callPackage ./non-by-name/cryptodatahub { };

  cryptography = callPackage ./non-by-name/cryptography { };

  cryptolyzer = callPackage ./non-by-name/cryptolyzer { };

  cryptomobile = callPackage ./non-by-name/cryptomobile { };

  cryptoparser = callPackage ./non-by-name/cryptoparser { };

  crysp = callPackage ./non-by-name/crysp { };

  crytic-compile = callPackage ./non-by-name/crytic-compile { };

  cs50 = callPackage ./non-by-name/cs50 { };

  csaf-tool = callPackage ./non-by-name/csaf-tool { };

  csaps = callPackage ./non-by-name/csaps { };

  cson = callPackage ./non-by-name/cson { };

  csrmesh = callPackage ./non-by-name/csrmesh { };

  css-html-js-minify = callPackage ./non-by-name/css-html-js-minify { };

  css-inline = callPackage ./non-by-name/css-inline { };

  css-parser = callPackage ./non-by-name/css-parser { };

  cssbeautifier = callPackage ./non-by-name/cssbeautifier { };

  csscompressor = callPackage ./non-by-name/csscompressor { };

  cssmin = callPackage ./non-by-name/cssmin { };

  cssselect = callPackage ./non-by-name/cssselect { };

  cssselect2 = callPackage ./non-by-name/cssselect2 { };

  cssutils = callPackage ./non-by-name/cssutils { };

  cstruct = callPackage ./non-by-name/cstruct { };

  csv2md = callPackage ./non-by-name/csv2md { };

  csvw = callPackage ./non-by-name/csvw { };

  ct3 = callPackage ./non-by-name/ct3 { };

  ctap-keyring-device = callPackage ./non-by-name/ctap-keyring-device { };

  ctranslate2 = callPackage ./non-by-name/ctranslate2 {
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  ctypesgen = callPackage ./non-by-name/ctypesgen { };

  cu2qu = callPackage ./non-by-name/cu2qu { };

  cucumber-expressions = callPackage ./non-by-name/cucumber-expressions { };

  cucumber-tag-expressions = callPackage ./non-by-name/cucumber-tag-expressions { };

  cuda-bindings = callPackage ./non-by-name/cuda-bindings { };

  cuda-cccl = callPackage ./non-by-name/cuda-cccl { };

  cuda-core = callPackage ./non-by-name/cuda-core { };

  cuda-pathfinder = callPackage ./non-by-name/cuda-pathfinder { };

  cuda-tile = callPackage ./non-by-name/cuda-tile { };

  cupti-python = callPackage ./non-by-name/cupti-python { };

  cupy = callPackage ./non-by-name/cupy { };

  curated-tokenizers = callPackage ./non-by-name/curated-tokenizers { };

  curated-transformers = callPackage ./non-by-name/curated-transformers { };

  curio = callPackage ./non-by-name/curio { };

  curio-compat = callPackage ./non-by-name/curio-compat { };

  curl-cffi = callPackage ./non-by-name/curl-cffi { };

  curlify = callPackage ./non-by-name/curlify { };

  curtsies = callPackage ./non-by-name/curtsies { };

  curvefitgui = callPackage ./non-by-name/curvefitgui { };

  custom-json-diff = callPackage ./non-by-name/custom-json-diff { };

  customtkinter = callPackage ./non-by-name/customtkinter { };

  cut-cross-entropy = callPackage ./non-by-name/cut-cross-entropy { };

  cutie = callPackage ./non-by-name/cutie { };

  cutlass = callPackage ./non-by-name/cutlass { };

  cv2-enumerate-cameras = callPackage ./non-by-name/cv2-enumerate-cameras { };

  cvelib = callPackage ./non-by-name/cvelib { };

  cvss = callPackage ./non-by-name/cvss { };

  cvxopt = callPackage ./non-by-name/cvxopt { };

  cvxpy = callPackage ./non-by-name/cvxpy { };

  cwcwidth = callPackage ./non-by-name/cwcwidth { };

  cwl-upgrader = callPackage ./non-by-name/cwl-upgrader { };

  cwl-utils = callPackage ./non-by-name/cwl-utils { };

  cwlformat = callPackage ./non-by-name/cwlformat { };

  cwsandbox = callPackage ./non-by-name/cwsandbox { };

  cx-freeze = callPackage ./non-by-name/cx-freeze { };

  cx-logging = callPackage ./non-by-name/cx-logging { };

  cx-oracle = callPackage ./non-by-name/cx-oracle { };

  cxx = callPackage ./non-by-name/cxx { };

  cxxfilt = callPackage ./non-by-name/cxxfilt { };

  cxxheaderparser = callPackage ./non-by-name/cxxheaderparser { };

  cybox = callPackage ./non-by-name/cybox { };

  cyclebane = callPackage ./non-by-name/cyclebane { };

  cycler = callPackage ./non-by-name/cycler { };

  cyclonedds-python = callPackage ./non-by-name/cyclonedds-python { };

  cyclonedx-python-lib = callPackage ./non-by-name/cyclonedx-python-lib { };

  cyclopts = callPackage ./non-by-name/cyclopts { };

  cyipopt = callPackage ./non-by-name/cyipopt { };

  cymem = callPackage ./non-by-name/cymem { };

  cymruwhois = callPackage ./non-by-name/cymruwhois { };

  cynthion = callPackage ./non-by-name/cynthion { };

  cypari = callPackage ./non-by-name/cypari { };

  cypari2 = callPackage ./non-by-name/cypari2 { };

  cyrtranslit = callPackage ./non-by-name/cyrtranslit { };

  cyscale = callPackage ./non-by-name/cyscale { };

  cysignals = callPackage ./non-by-name/cysignals { };

  cython = callPackage ./non-by-name/cython { };

  cython-test-exception-raiser = callPackage ./non-by-name/cython-test-exception-raiser { };

  cython_0 = callPackage ./non-by-name/cython/0.nix { };

  cython_3_2 = callPackage ./non-by-name/cython/3_2.nix { };

  cytoolz = callPackage ./non-by-name/cytoolz { };

  cyvcf2 = callPackage ./non-by-name/cyvcf2 { };

  cyvest = callPackage ./non-by-name/cyvest { };

  dacite = callPackage ./non-by-name/dacite { };

  daemonize = callPackage ./non-by-name/daemonize { };

  daemonocle = callPackage ./non-by-name/daemonocle { };

  daff = callPackage ./non-by-name/daff { };

  daft = callPackage ./non-by-name/daft { inherit (pkgs) zstd; };

  dahlia = callPackage ./non-by-name/dahlia { };

  daiquiri = callPackage ./non-by-name/daiquiri { };

  daltonlens = callPackage ./non-by-name/daltonlens { };

  daphne = callPackage ./non-by-name/daphne { };

  daqp = callPackage ./non-by-name/daqp { };

  darabonba-core = callPackage ./non-by-name/darabonba-core { };

  darkdetect = callPackage ./non-by-name/darkdetect { };

  dartsim = toPythonModule (
    pkgs.dartsim.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  dasbus = callPackage ./non-by-name/dasbus { };

  dash = callPackage ./non-by-name/dash { };

  dash-bootstrap-components = callPackage ./non-by-name/dash-bootstrap-components { };

  dash-bootstrap-templates = callPackage ./non-by-name/dash-bootstrap-templates { };

  dash-core-components = callPackage ./non-by-name/dash-core-components { };

  dash-html-components = callPackage ./non-by-name/dash-html-components { };

  dash-table = callPackage ./non-by-name/dash-table { };

  dashing = callPackage ./non-by-name/dashing { };

  dashscope = callPackage ./non-by-name/dashscope { };

  dask = callPackage ./non-by-name/dask { };

  dask-awkward = callPackage ./non-by-name/dask-awkward { };

  dask-gateway = callPackage ./non-by-name/dask-gateway { };

  dask-gateway-server = callPackage ./non-by-name/dask-gateway-server { };

  dask-glm = callPackage ./non-by-name/dask-glm { };

  dask-histogram = callPackage ./non-by-name/dask-histogram { };

  dask-image = callPackage ./non-by-name/dask-image { };

  dask-jobqueue = callPackage ./non-by-name/dask-jobqueue { };

  dask-ml = callPackage ./non-by-name/dask-ml { };

  dask-mpi = callPackage ./non-by-name/dask-mpi { };

  data-grand-lyon-ha = callPackage ./non-by-name/data-grand-lyon-ha { };

  data-password-entropy = callPackage ./non-by-name/data-password-entropy { };

  databackend = callPackage ./non-by-name/databackend { };

  databases = callPackage ./non-by-name/databases { };

  databricks-connect = callPackage ./non-by-name/databricks-connect { };

  databricks-sdk = callPackage ./non-by-name/databricks-sdk { };

  databricks-sql-connector = callPackage ./non-by-name/databricks-sql-connector { };

  dataclass-csv = callPackage ./non-by-name/dataclass-csv { };

  dataclass-factory = callPackage ./non-by-name/dataclass-factory { };

  dataclass-wizard = callPackage ./non-by-name/dataclass-wizard { };

  dataclasses-json = callPackage ./non-by-name/dataclasses-json { };

  dataconf = callPackage ./non-by-name/dataconf { };

  datadiff = callPackage ./non-by-name/datadiff { };

  datadog = callPackage ./non-by-name/datadog { };

  datafusion = callPackage ./non-by-name/datafusion {
    protoc = pkgs.protobuf;
  };

  datalab-capsule = callPackage ./non-by-name/datalab-capsule { };

  datalab-platform = callPackage ./non-by-name/datalab-platform { };

  datalad = callPackage ./non-by-name/datalad { };

  datalad-gooey = callPackage ./non-by-name/datalad-gooey { };

  datalad-next = callPackage ./non-by-name/datalad-next { };

  datamodel-code-generator = callPackage ./non-by-name/datamodel-code-generator { };

  datamodeldict = callPackage ./non-by-name/datamodeldict { };

  datapoint = callPackage ./non-by-name/datapoint { };

  dataproperty = callPackage ./non-by-name/dataproperty { };

  datasalad = callPackage ./non-by-name/datasalad { };

  dataset = callPackage ./non-by-name/dataset { };

  datasets = callPackage ./non-by-name/datasets { };

  datasets_3 = callPackage ./non-by-name/datasets/3.nix { };

  datasette = callPackage ./non-by-name/datasette { };

  datasette-publish-fly = callPackage ./non-by-name/datasette-publish-fly { };

  datasette-template-sql = callPackage ./non-by-name/datasette-template-sql { };

  datashader = callPackage ./non-by-name/datashader { };

  datasketch = callPackage ./non-by-name/datasketch { };

  datastar-py = callPackage ./non-by-name/datastar-py { };

  datefinder = callPackage ./non-by-name/datefinder { };

  dateparser = callPackage ./non-by-name/dateparser { };

  datetime = callPackage ./non-by-name/datetime { };

  dateutils = callPackage ./non-by-name/dateutils { };

  datrie = callPackage ./non-by-name/datrie { };

  dawg-python = callPackage ./non-by-name/dawg-python { };

  dawg2-python = callPackage ./non-by-name/dawg2-python { };

  dazl = callPackage ./non-by-name/dazl { };

  db-dtypes = callPackage ./non-by-name/db-dtypes { };

  dbf = callPackage ./non-by-name/dbf { };

  dbfread = callPackage ./non-by-name/dbfread { };

  dbglib = callPackage ./non-by-name/dbglib { };

  dbgpu = callPackage ./non-by-name/dbgpu { };

  dbt-adapters = callPackage ./non-by-name/dbt-adapters { };

  dbt-bigquery = callPackage ./non-by-name/dbt-bigquery { };

  dbt-common = callPackage ./non-by-name/dbt-common { };

  dbt-core = callPackage ./non-by-name/dbt-core { };

  dbt-extractor = callPackage ./non-by-name/dbt-extractor { };

  dbt-postgres = callPackage ./non-by-name/dbt-postgres { };

  dbt-protos = callPackage ./non-by-name/dbt-protos { };

  dbt-redshift = callPackage ./non-by-name/dbt-redshift { };

  dbt-semantic-interfaces = callPackage ./non-by-name/dbt-semantic-interfaces { };

  dbt-snowflake = callPackage ./non-by-name/dbt-snowflake { };

  dbt-tests-adapter = callPackage ./non-by-name/dbt-tests-adapter { };

  dbus-client-gen = callPackage ./non-by-name/dbus-client-gen { };

  dbus-deviation = callPackage ./non-by-name/dbus-deviation { };

  dbus-fast = callPackage ./non-by-name/dbus-fast { };

  dbus-next = callPackage ./non-by-name/dbus-next { };

  dbus-python = callPackage ./non-by-name/dbus-python { inherit (pkgs) dbus; };

  dbus-python-client-gen = callPackage ./non-by-name/dbus-python-client-gen { };

  dbus-signature-pyparsing = callPackage ./non-by-name/dbus-signature-pyparsing { };

  dbutils = callPackage ./non-by-name/dbutils { };

  dcmstack = callPackage ./non-by-name/dcmstack { };

  dctorch = callPackage ./non-by-name/dctorch { };

  ddgs = callPackage ./non-by-name/ddgs { };

  ddt = callPackage ./non-by-name/ddt { };

  deal = callPackage ./non-by-name/deal { };

  deal-solver = callPackage ./non-by-name/deal-solver { };

  deap = callPackage ./non-by-name/deap { };

  debian-inspector = callPackage ./non-by-name/debian-inspector { };

  debianbts = callPackage ./non-by-name/debianbts { };

  debtcollector = callPackage ./non-by-name/debtcollector { };

  debts = callPackage ./non-by-name/debts { };

  debuglater = callPackage ./non-by-name/debuglater { };

  debugpy = callPackage ./non-by-name/debugpy { };

  decli = callPackage ./non-by-name/decli { };

  declib = callPackage ./non-by-name/declib { };

  declinate = callPackage ./non-by-name/declinate { };

  decopatch = callPackage ./non-by-name/decopatch { };

  decora-wifi = callPackage ./non-by-name/decora-wifi { };

  decorator = callPackage ./non-by-name/decorator { };

  dedupe = callPackage ./non-by-name/dedupe { };

  dedupe-levenshtein-search = callPackage ./non-by-name/dedupe-levenshtein-search { };

  deebot-client = callPackage ./non-by-name/deebot-client { };

  deemix = callPackage ./non-by-name/deemix { };

  deep-chainmap = callPackage ./non-by-name/deep-chainmap { };

  deep-ep = callPackage ./non-by-name/deep-ep { };

  deep-gemm = callPackage ./non-by-name/deep-gemm { };

  deep-translator = callPackage ./non-by-name/deep-translator { };

  deepdiff = callPackage ./non-by-name/deepdiff { };

  deepdish = callPackage ./non-by-name/deepdish { };

  deepface = callPackage ./non-by-name/deepface { };

  deepl = callPackage ./non-by-name/deepl { };

  deepmerge = callPackage ./non-by-name/deepmerge { };

  deepsearch-toolkit = callPackage ./non-by-name/deepsearch-toolkit { };

  deepspeed = callPackage ./non-by-name/deepspeed { };

  deeptoolsintervals = callPackage ./non-by-name/deeptoolsintervals { };

  deepwave = callPackage ./non-by-name/deepwave { };

  deezer-py = callPackage ./non-by-name/deezer-py { };

  deezer-python = callPackage ./non-by-name/deezer-python { };

  defang = callPackage ./non-by-name/defang { };

  defcon = callPackage ./non-by-name/defcon { };

  defeatbeta-api = callPackage ./non-by-name/defeatbeta-api { };

  deform = callPackage ./non-by-name/deform { };

  defusedcsv = callPackage ./non-by-name/defusedcsv { };

  defusedxml = callPackage ./non-by-name/defusedxml { };

  dehinter = callPackage ./non-by-name/dehinter { };

  deid = callPackage ./non-by-name/deid { };

  dek = callPackage ./non-by-name/dek { };

  delegator-py = callPackage ./non-by-name/delegator-py { };

  delorean = callPackage ./non-by-name/delorean { };

  deltachat = callPackage ./non-by-name/deltachat { };

  deltachat-rpc-client = callPackage ./non-by-name/deltachat-rpc-client { };

  deltachat2 = callPackage ./non-by-name/deltachat2 { };

  deltalake = callPackage ./non-by-name/deltalake { inherit (pkgs) zstd; };

  deluge-client = callPackage ./non-by-name/deluge-client { };

  demes = callPackage ./non-by-name/demes { };

  demesdraw = callPackage ./non-by-name/demesdraw { };

  demetriek = callPackage ./non-by-name/demetriek { };

  demjson3 = callPackage ./non-by-name/demjson3 { };

  demoji = callPackage ./non-by-name/demoji { };

  dendropy = callPackage ./non-by-name/dendropy { };

  denon-rs232 = callPackage ./non-by-name/denon-rs232 { };

  denonavr = callPackage ./non-by-name/denonavr { };

  dep-logic = callPackage ./non-by-name/dep-logic { };

  dependency-groups = callPackage ./non-by-name/dependency-groups { };

  dependency-injector = callPackage ./non-by-name/dependency-injector { };

  deploykit = callPackage ./non-by-name/deploykit { };

  deprecated = callPackage ./non-by-name/deprecated { };

  deprecation = callPackage ./non-by-name/deprecation { };

  deprecation-alias = callPackage ./non-by-name/deprecation-alias { };

  deptry = callPackage ./non-by-name/deptry { };

  depyf = callPackage ./non-by-name/depyf { };

  derivative = callPackage ./non-by-name/derivative { };

  desktop-entry-lib = callPackage ./non-by-name/desktop-entry-lib { };

  desktop-notifier = callPackage ./non-by-name/desktop-notifier { };

  detect-secrets = callPackage ./non-by-name/detect-secrets { };

  developer-disk-image = callPackage ./non-by-name/developer-disk-image { };

  devgoldyutils = callPackage ./non-by-name/devgoldyutils { };

  devialet = callPackage ./non-by-name/devialet { };

  devito = callPackage ./non-by-name/devito { };

  devolo-home-control-api = callPackage ./non-by-name/devolo-home-control-api { };

  devolo-plc-api = callPackage ./non-by-name/devolo-plc-api { };

  devpi-common = callPackage ./non-by-name/devpi-common { };

  devpi-ldap = callPackage ./non-by-name/devpi-ldap { };

  devpi-server = callPackage ../../by-name/de/devpi-server/unwrapped.nix { };

  devpi-web = callPackage ./non-by-name/devpi-web { };

  devtools = callPackage ./non-by-name/devtools { };

  dextrace = callPackage ./non-by-name/dextrace { };

  dfdiskcache = callPackage ./non-by-name/dfdiskcache { };

  dfir-ntfs = callPackage ./non-by-name/dfir_ntfs { };

  dftd4 = callPackage ../../by-name/df/dftd4/python.nix {
    inherit (pkgs) dftd4;
  };

  diagrams = callPackage ./non-by-name/diagrams { };

  diceware = callPackage ./non-by-name/diceware { };

  dicom-numpy = callPackage ./non-by-name/dicom-numpy { };

  dicom2nifti = callPackage ./non-by-name/dicom2nifti { };

  dicomweb-client = callPackage ./non-by-name/dicomweb-client { };

  dict2css = callPackage ./non-by-name/dict2css { };

  dict2xml = callPackage ./non-by-name/dict2xml { };

  dictdiffer = callPackage ./non-by-name/dictdiffer { };

  dicttoxml = callPackage ./non-by-name/dicttoxml { };

  dicttoxml2 = callPackage ./non-by-name/dicttoxml2 { };

  diff-cover = callPackage ./non-by-name/diff-cover { };

  diff-match-patch = callPackage ./non-by-name/diff-match-patch { };

  diffenator2 = callPackage ./non-by-name/diffenator2 { };

  diffimg = callPackage ./non-by-name/diffimg { };

  diffsync = callPackage ./non-by-name/diffsync { };

  diffusers = callPackage ./non-by-name/diffusers { };

  digi-xbee = callPackage ./non-by-name/digi-xbee { };

  dill = callPackage ./non-by-name/dill { };

  dinghy = callPackage ./non-by-name/dinghy { };

  dingz = callPackage ./non-by-name/dingz { };

  dio-chacon-wifi-api = callPackage ./non-by-name/dio-chacon-wifi-api { };

  diofant = callPackage ./non-by-name/diofant { };

  dipy = callPackage ./non-by-name/dipy { };

  directv = callPackage ./non-by-name/directv { };

  dirigera = callPackage ./non-by-name/dirigera { };

  dirsearch = callPackage ./non-by-name/dirsearch { };

  dirty-equals = callPackage ./non-by-name/dirty-equals { };

  dirtyjson = callPackage ./non-by-name/dirtyjson { };

  discid = callPackage ./non-by-name/discid { };

  discogs-client = callPackage ./non-by-name/discogs-client { };

  discord-webhook = callPackage ./non-by-name/discord-webhook { };

  discordpy = callPackage ./non-by-name/discordpy { };

  discovery30303 = callPackage ./non-by-name/discovery30303 { };

  discum = callPackage ./non-by-name/discum { };

  diskcache = callPackage ./non-by-name/diskcache { };

  diskcache-community = callPackage ./non-by-name/diskcache-community { };

  diskcache-stubs = callPackage ./non-by-name/diskcache-stubs { };

  disnake = callPackage ./non-by-name/disnake { };

  disposable-email-domains = callPackage ./non-by-name/disposable-email-domains { };

  dissect = callPackage ./non-by-name/dissect { };

  dissect-apfs = callPackage ./non-by-name/dissect-apfs { };

  dissect-archive = callPackage ./non-by-name/dissect-archive { };

  dissect-btrfs = callPackage ./non-by-name/dissect-btrfs { };

  dissect-cim = callPackage ./non-by-name/dissect-cim { };

  dissect-clfs = callPackage ./non-by-name/dissect-clfs { };

  dissect-cobaltstrike = callPackage ./non-by-name/dissect-cobaltstrike { };

  dissect-cramfs = callPackage ./non-by-name/dissect-cramfs { };

  dissect-cstruct = callPackage ./non-by-name/dissect-cstruct { };

  dissect-database = callPackage ./non-by-name/dissect-database { };

  dissect-esedb = callPackage ./non-by-name/dissect-esedb { };

  dissect-etl = callPackage ./non-by-name/dissect-etl { };

  dissect-eventlog = callPackage ./non-by-name/dissect-eventlog { };

  dissect-evidence = callPackage ./non-by-name/dissect-evidence { };

  dissect-executable = callPackage ./non-by-name/dissect-executable { };

  dissect-extfs = callPackage ./non-by-name/dissect-extfs { };

  dissect-fat = callPackage ./non-by-name/dissect-fat { };

  dissect-ffs = callPackage ./non-by-name/dissect-ffs { };

  dissect-fve = callPackage ./non-by-name/dissect-fve { };

  dissect-hypervisor = callPackage ./non-by-name/dissect-hypervisor { };

  dissect-jffs = callPackage ./non-by-name/dissect-jffs { };

  dissect-ntfs = callPackage ./non-by-name/dissect-ntfs { };

  dissect-ole = callPackage ./non-by-name/dissect-ole { };

  dissect-qnxfs = callPackage ./non-by-name/dissect-qnxfs { };

  dissect-regf = callPackage ./non-by-name/dissect-regf { };

  dissect-shellitem = callPackage ./non-by-name/dissect-shellitem { };

  dissect-sql = callPackage ./non-by-name/dissect-sql { };

  dissect-squashfs = callPackage ./non-by-name/dissect-squashfs { };

  dissect-target = callPackage ./non-by-name/dissect-target { };

  dissect-thumbcache = callPackage ./non-by-name/dissect-thumbcache { };

  dissect-util = callPackage ./non-by-name/dissect-util { };

  dissect-vmfs = callPackage ./non-by-name/dissect-vmfs { };

  dissect-volume = callPackage ./non-by-name/dissect-volume { };

  dissect-xfs = callPackage ./non-by-name/dissect-xfs { };

  dissononce = callPackage ./non-by-name/dissononce { };

  dist-meta = callPackage ./non-by-name/dist-meta { };

  distlib = callPackage ./non-by-name/distlib { };

  distorm3 = callPackage ./non-by-name/distorm3 { };

  distrax = callPackage ./non-by-name/distrax { };

  distributed = callPackage ./non-by-name/distributed { };

  distro = callPackage ./non-by-name/distro { };

  distro-info = callPackage ./non-by-name/distro-info { };

  distutils = if pythonOlder "3.12" then null else callPackage ./non-by-name/distutils { };

  distutils-extra = callPackage ./non-by-name/distutils-extra { };

  distutils_80 = if pythonOlder "3.12" then null else callPackage ./non-by-name/distutils/80.nix { };

  dj-database-url = callPackage ./non-by-name/dj-database-url { };

  dj-email-url = callPackage ./non-by-name/dj-email-url { };

  dj-rest-auth = callPackage ./non-by-name/dj-rest-auth { };

  dj-search-url = callPackage ./non-by-name/dj-search-url { };

  dj-static = callPackage ./non-by-name/dj-static { };

  # LTS with mainsteam support
  django = self.django_5;

  django-admin-sortable2 = callPackage ./non-by-name/django-admin-sortable2 { };

  django-agnocomplete = callPackage ./non-by-name/django-agnocomplete { };

  django-allauth = callPackage ./non-by-name/django-allauth { };

  django-annoying = callPackage ./non-by-name/django-annoying { };

  django-anymail = callPackage ./non-by-name/django-anymail { };

  django-app-helper = callPackage ./non-by-name/django-app-helper { };

  django-appconf = callPackage ./non-by-name/django-appconf { };

  django-apscheduler = callPackage ./non-by-name/django-apscheduler { };

  django-async-backend = callPackage ./non-by-name/django-async-backend { };

  django-auditlog = callPackage ./non-by-name/django-auditlog { };

  django-auth-ldap = callPackage ./non-by-name/django-auth-ldap {
    inherit (pkgs) openldap;
  };

  django-autocomplete-light = callPackage ./non-by-name/django-autocomplete-light { };

  django-autoslug = callPackage ./non-by-name/django-autoslug { };

  django-axes = callPackage ./non-by-name/django-axes { };

  django-bootstrap3 = callPackage ./non-by-name/django-bootstrap3 { };

  django-bootstrap4 = callPackage ./non-by-name/django-bootstrap4 { };

  django-bootstrap5 = callPackage ./non-by-name/django-bootstrap5 { };

  django-cachalot = callPackage ./non-by-name/django-cachalot { };

  django-cache-memoize = callPackage ./non-by-name/django-cache-memoize { };

  django-cache-url = callPackage ./non-by-name/django-cache-url { };

  django-cacheops = callPackage ./non-by-name/django-cacheops { };

  django-celery-beat = callPackage ./non-by-name/django-celery-beat { };

  django-celery-email = callPackage ./non-by-name/django-celery-email { };

  django-celery-results = callPackage ./non-by-name/django-celery-results { };

  django-choices-field = callPackage ./non-by-name/django-choices-field { };

  django-ckeditor = callPackage ./non-by-name/django-ckeditor { };

  django-classy-tags = callPackage ./non-by-name/django-classy-tags { };

  django-cleanup = callPackage ./non-by-name/django-cleanup { };

  django-cms = callPackage ./non-by-name/django-cms { };

  django-colorful = callPackage ./non-by-name/django-colorful { };

  django-compression-middleware = callPackage ./non-by-name/django-compression-middleware { };

  django-compressor = callPackage ./non-by-name/django-compressor { };

  django-configurations = callPackage ./non-by-name/django-configurations { };

  django-context-decorator = callPackage ./non-by-name/django-context-decorator { };

  django-contrib-comments = callPackage ./non-by-name/django-contrib-comments { };

  django-cors-headers = callPackage ./non-by-name/django-cors-headers { };

  django-countries = callPackage ./non-by-name/django-countries { };

  django-crispy-forms = callPackage ./non-by-name/django-crispy-forms { };

  django-crossdomainmedia = callPackage ./non-by-name/django-crossdomainmedia { };

  django-csp = callPackage ./non-by-name/django-csp { };

  django-cte = callPackage ./non-by-name/django-cte { };

  django-currentuser = callPackage ./non-by-name/django-currentuser { };

  django-dbbackup = callPackage ./non-by-name/django-dbbackup { };

  django-debug-toolbar = callPackage ./non-by-name/django-debug-toolbar { };

  django-dynamic-preferences = callPackage ./non-by-name/django-dynamic-preferences { };

  django-elasticsearch-dsl = callPackage ./non-by-name/django-elasticsearch-dsl { };

  django-embed-video = callPackage ./non-by-name/django-embed-video { };

  django-encrypted-model-fields = callPackage ./non-by-name/django-encrypted-model-fields { };

  django-environ = callPackage ./non-by-name/django-environ { };

  django-error-report-2 = callPackage ./non-by-name/django-error-report-2 { };

  django-extended-makemessages = callPackage ./non-by-name/django-extended-makemessages { };

  django-extensions = callPackage ./non-by-name/django-extensions { };

  django-filer = callPackage ./non-by-name/django-filer { };

  django-filingcabinet = callPackage ./non-by-name/django-filingcabinet { };

  django-filter = callPackage ./non-by-name/django-filter { };

  django-flags = callPackage ./non-by-name/django-flags { };

  django-formset-js-improved = callPackage ./non-by-name/django-formset-js-improved { };

  django-formtools = callPackage ./non-by-name/django-formtools { };

  django-fsm = callPackage ./non-by-name/django-fsm { };

  django-fsm-2 = callPackage ./non-by-name/django-fsm-2 { };

  django-google-analytics-app = callPackage ./non-by-name/django-google-analytics-app { };

  django-graphiql-debug-toolbar = callPackage ./non-by-name/django-graphiql-debug-toolbar { };

  django-gravatar2 = callPackage ./non-by-name/django-gravatar2 { };

  django-guardian = callPackage ./non-by-name/django-guardian { };

  django-haystack = callPackage ./non-by-name/django-haystack { };

  django-hcaptcha = callPackage ./non-by-name/django-hcaptcha { };

  django-health-check = callPackage ./non-by-name/django-health-check { };

  django-hierarkey = callPackage ./non-by-name/django-hierarkey { };

  django-hijack = callPackage ./non-by-name/django-hijack { };

  django-htmx = callPackage ./non-by-name/django-htmx { };

  django-i18nfield = callPackage ./non-by-name/django-i18nfield { };

  django-ical = callPackage ./non-by-name/django-ical { };

  django-import-export = callPackage ./non-by-name/django-import-export { };

  django-ipware = callPackage ./non-by-name/django-ipware { };

  django-jinja = callPackage ./non-by-name/django-jinja { };

  django-jquery-js = callPackage ./non-by-name/django-jquery-js { };

  django-js-asset = callPackage ./non-by-name/django-js-asset { };

  django-js-reverse = callPackage ./non-by-name/django-js-reverse { };

  django-json-widget = callPackage ./non-by-name/django-json-widget { };

  django-lasuite = callPackage ./non-by-name/django-lasuite { };

  django-leaflet = callPackage ./non-by-name/django-leaflet { };

  django-libsass = callPackage ./non-by-name/django-libsass { };

  django-localflavor = callPackage ./non-by-name/django-localflavor { };

  django-logentry-admin = callPackage ./non-by-name/django-logentry-admin { };

  django-login-required-middleware = callPackage ./non-by-name/django-login-required-middleware { };

  django-ltree = callPackage ./non-by-name/django-ltree { };

  django-mailbox = callPackage ./non-by-name/django-mailbox { };

  django-mailman3 = callPackage ./non-by-name/django-mailman3 { };

  django-maintenance-mode = callPackage ./non-by-name/django-maintenance-mode { };

  django-markdownify = callPackage ./non-by-name/django-markdownify { };

  django-markdownx = callPackage ./non-by-name/django-markdownx { };

  django-markup = callPackage ./non-by-name/django-markup { };

  django-mcp-server = callPackage ./non-by-name/django-mcp-server { };

  django-mfa3 = callPackage ./non-by-name/django-mfa3 { };

  django-minify-html = callPackage ./non-by-name/django-minify-html { };

  django-model-utils = callPackage ./non-by-name/django-model-utils { };

  django-modelcluster = callPackage ./non-by-name/django-modelcluster { };

  django-modeltranslation = callPackage ./non-by-name/django-modeltranslation { };

  django-money = callPackage ./non-by-name/django-money { };

  django-mptt = callPackage ./non-by-name/django-mptt { };

  django-multiselectfield = callPackage ./non-by-name/django-multiselectfield { };

  django-ninja = callPackage ./non-by-name/django-ninja { };

  django-ninja-cursor-pagination = callPackage ./non-by-name/django-ninja-cursor-pagination { };

  django-oauth-toolkit = callPackage ./non-by-name/django-oauth-toolkit { };

  django-oauth-toolkit_2 = callPackage ./non-by-name/django-oauth-toolkit/2.nix { };

  django-organizations = callPackage ./non-by-name/django-organizations { };

  django-otp = callPackage ./non-by-name/django-otp { };

  django-otp-webauthn = callPackage ./non-by-name/django-otp-webauthn { };

  django-paintstore = callPackage ./non-by-name/django-paintstore { };

  django-parler = callPackage ./non-by-name/django-parler { };

  django-pattern-library = callPackage ./non-by-name/django-pattern-library { };

  django-payments = callPackage ./non-by-name/django-payments { };

  django-pgactivity = callPackage ./non-by-name/django-pgactivity { };

  django-pghistory = callPackage ./non-by-name/django-pghistory { };

  django-pglock = callPackage ./non-by-name/django-pglock { };

  django-pglocks = callPackage ./non-by-name/django-pglocks { };

  django-pgpubsub = callPackage ./non-by-name/django-pgpubsub { };

  django-pgtrigger = callPackage ./non-by-name/django-pgtrigger { };

  django-pgware = callPackage ./non-by-name/django-pgware { };

  django-phonenumber-field = callPackage ./non-by-name/django-phonenumber-field { };

  django-picklefield = callPackage ./non-by-name/django-picklefield { };

  django-polymorphic = callPackage ./non-by-name/django-polymorphic { };

  django-postgres-extra = callPackage ./non-by-name/django-postgres-extra { };

  django-postgres-partition = callPackage ./non-by-name/django-postgres-partition { };

  django-postgresql-netfields = callPackage ./non-by-name/django-postgresql-netfields { };

  django-probes = callPackage ./non-by-name/django-probes { };

  django-prometheus = callPackage ./non-by-name/django-prometheus { };

  django-pwa = callPackage ./non-by-name/django-pwa { };

  django-pydantic-field = callPackage ./non-by-name/django-pydantic-field { };

  django-q2 = callPackage ./non-by-name/django-q2 { };

  django-querytagger = callPackage ./non-by-name/django-querytagger { };

  django-ranged-response = callPackage ./non-by-name/django-ranged-response { };

  django-raster = callPackage ./non-by-name/django-raster { };

  django-ratelimit = callPackage ./non-by-name/django-ratelimit { };

  django-recurrence = callPackage ./non-by-name/django-recurrence { };

  django-redis = callPackage ./non-by-name/django-redis { };

  django-registration = callPackage ./non-by-name/django-registration { };

  django-rest-auth = callPackage ./non-by-name/django-rest-auth { };

  django-rest-knox = callPackage ./non-by-name/django-rest-knox { };

  django-rest-polymorphic = callPackage ./non-by-name/django-rest-polymorphic { };

  django-rest-registration = callPackage ./non-by-name/django-rest-registration { };

  django-reversion = callPackage ./non-by-name/django-reversion { };

  django-rich = callPackage ./non-by-name/django-rich { };

  django-rosetta = callPackage ./non-by-name/django-rosetta { };

  django-rq = callPackage ./non-by-name/django-rq { };

  django-scheduler = callPackage ./non-by-name/django-scheduler { };

  django-scim2 = callPackage ./non-by-name/django-scim2 { };

  django-scopes = callPackage ./non-by-name/django-scopes { };

  django-sekizai = callPackage ./non-by-name/django-sekizai { };

  django-sesame = callPackage ./non-by-name/django-sesame { };

  django-shortuuidfield = callPackage ./non-by-name/django-shortuuidfield { };

  django-silk = callPackage ./non-by-name/django-silk { };

  django-simple-captcha = callPackage ./non-by-name/django-simple-captcha { };

  django-simple-history = callPackage ./non-by-name/django-simple-history { };

  django-sites = callPackage ./non-by-name/django-sites { };

  django-soft-delete = callPackage ./non-by-name/django-soft-delete { };

  django-split-settings = callPackage ./non-by-name/django-split-settings { };

  django-sql-utils = callPackage ./non-by-name/django-sql-utils { };

  django-sslserver = callPackage ./non-by-name/django-sslserver { };

  django-statici18n = callPackage ./non-by-name/django-statici18n { };

  django-stdimage = callPackage ./non-by-name/django-stdimage { };

  django-storages = callPackage ./non-by-name/django-storages { };

  django-structlog = callPackage ./non-by-name/django-structlog { };

  django-stubs = callPackage ./non-by-name/django-stubs { };

  django-stubs-ext = callPackage ./non-by-name/django-stubs-ext { };

  django-tables2 = callPackage ./non-by-name/django-tables2 { };

  django-tagging = callPackage ./non-by-name/django-tagging { };

  django-taggit = callPackage ./non-by-name/django-taggit { };

  django-tasks = callPackage ./non-by-name/django-tasks { };

  django-tastypie = callPackage ./non-by-name/django-tastypie { };

  django-tenants = callPackage ./non-by-name/django-tenants { };

  django-test-migrations = callPackage ./non-by-name/django-test-migrations { };

  django-timezone-field = callPackage ./non-by-name/django-timezone-field { };

  django-tinymce = callPackage ./non-by-name/django-tinymce { };

  django-tree-queries = callPackage ./non-by-name/django-tree-queries { };

  django-treebeard = callPackage ./non-by-name/django-treebeard { };

  django-treenode = callPackage ./non-by-name/django-treenode { };

  django-two-factor-auth = callPackage ./non-by-name/django-two-factor-auth { };

  django-types = callPackage ./non-by-name/django-types { };

  django-user-sessions = callPackage ./non-by-name/django-user-sessions { };

  django-valkey = callPackage ./non-by-name/django-valkey { };

  django-vcache = callPackage ./non-by-name/django-vcache { };

  django-versatileimagefield = callPackage ./non-by-name/django-versatileimagefield { };

  django-vite = callPackage ./non-by-name/django-vite { };

  django-vpg = callPackage ./non-by-name/django-vpg { };

  django-vtasks = callPackage ./non-by-name/django-vtasks { };

  django-waffle = callPackage ./non-by-name/django-waffle { };

  django-weasyprint = callPackage ./non-by-name/django-weasyprint { };

  django-webpack-loader = callPackage ./non-by-name/django-webpack-loader { };

  django-webpush = callPackage ./non-by-name/django-webpush { };

  django-widget-tweaks = callPackage ./non-by-name/django-widget-tweaks { };

  django-xforwardedfor-middleware = callPackage ./non-by-name/django-xforwardedfor-middleware { };

  # LTS in extended support phase
  django_5 = callPackage ./non-by-name/django/5.nix { };

  django_6 = callPackage ./non-by-name/django/6.nix { };

  django_6_0 = callPackage ./non-by-name/django/6_0.nix { };

  djangocms-admin-style = callPackage ./non-by-name/djangocms-admin-style { };

  djangocms-alias = callPackage ./non-by-name/djangocms-alias { };

  djangocms-text-ckeditor = callPackage ./non-by-name/djangocms-text-ckeditor { };

  djangoql = callPackage ./non-by-name/djangoql { };

  djangorestframework = callPackage ./non-by-name/djangorestframework { };

  djangorestframework-api-key = callPackage ./non-by-name/djangorestframework-api-key { };

  djangorestframework-camel-case = callPackage ./non-by-name/djangorestframework-camel-case { };

  djangorestframework-csv = callPackage ./non-by-name/djangorestframework-csv { };

  djangorestframework-dataclasses = callPackage ./non-by-name/djangorestframework-dataclasses { };

  djangorestframework-guardian = callPackage ./non-by-name/djangorestframework-guardian { };

  djangorestframework-jsonp = callPackage ./non-by-name/djangorestframework-jsonp { };

  djangorestframework-recursive = callPackage ./non-by-name/djangorestframework-recursive { };

  djangorestframework-simplejwt = callPackage ./non-by-name/djangorestframework-simplejwt { };

  djangorestframework-stubs = callPackage ./non-by-name/djangorestframework-stubs { };

  djangorestframework_3_17 = callPackage ./non-by-name/djangorestframework/3_17.nix { };

  djangosaml2 = callPackage ./non-by-name/djangosaml2 { };

  djmail = callPackage ./non-by-name/djmail { };

  djoser = callPackage ./non-by-name/djoser { };

  djvulibre-python = callPackage ./non-by-name/djvulibre-python { };

  dkimpy = callPackage ./non-by-name/dkimpy { };

  dlib = callPackage ./non-by-name/dlib { inherit (pkgs) dlib; };

  dlinfo = callPackage ./non-by-name/dlinfo { };

  dllist = callPackage ./non-by-name/dllist { };

  dllogger = callPackage ./non-by-name/dllogger { };

  dlms-cosem = callPackage ./non-by-name/dlms-cosem { };

  dlx = callPackage ./non-by-name/dlx { };

  dm-control = callPackage ./non-by-name/dm-control { };

  dm-env = callPackage ./non-by-name/dm-env { };

  dm-haiku = callPackage ./non-by-name/dm-haiku { };

  dm-sonnet = callPackage ./non-by-name/dm-sonnet { };

  dm-tree = callPackage ./non-by-name/dm-tree {
    inherit (pkgs) abseil-cpp;
  };

  dmenu-python = callPackage ./non-by-name/dmenu { };

  dmgbuild = callPackage ./non-by-name/dmgbuild { };

  dmsuite = callPackage ./non-by-name/dmsuite { };

  dmt-core = callPackage ./non-by-name/dmt-core { };

  dnachisel = callPackage ./non-by-name/dnachisel { };

  dncil = callPackage ./non-by-name/dncil { };

  dnf-plugins-core = callPackage ./non-by-name/dnf-plugins-core { };

  dnf4 = callPackage ./non-by-name/dnf4 { };

  dnfile = callPackage ./non-by-name/dnfile { };

  dns-lexicon = callPackage ./non-by-name/dns-lexicon { };

  dnsight = callPackage ./non-by-name/dnsight { };

  dnslib = callPackage ./non-by-name/dnslib { };

  dnspython = callPackage ./non-by-name/dnspython { };

  doc8 = callPackage ./non-by-name/doc8 { };

  docformatter = callPackage ./non-by-name/docformatter { };

  docker = callPackage ./non-by-name/docker { };

  docker-pycreds = callPackage ./non-by-name/docker-pycreds { };

  dockerfile-parse = callPackage ./non-by-name/dockerfile-parse { };

  dockerflow = callPackage ./non-by-name/dockerflow { };

  dockerpty = callPackage ./non-by-name/dockerpty { };

  dockerspawner = callPackage ./non-by-name/dockerspawner { };

  doclang = callPackage ./non-by-name/doclang { };

  docling = callPackage ./non-by-name/docling { };

  docling-core = callPackage ./non-by-name/docling-core { };

  docling-ibm-models = callPackage ./non-by-name/docling-ibm-models { };

  docling-jobkit = callPackage ./non-by-name/docling-jobkit { };

  docling-mcp = callPackage ./non-by-name/docling-mcp { };

  docling-parse = callPackage ./non-by-name/docling-parse {
    loguru-cpp = pkgs.loguru;
  };

  docling-serve = callPackage ./non-by-name/docling-serve { };

  docling-slim = callPackage ./non-by-name/docling-slim { };

  docloud = callPackage ./non-by-name/docloud { };

  docopt = callPackage ./non-by-name/docopt { };

  docopt-ng = callPackage ./non-by-name/docopt-ng { };

  docopt-subcommands = callPackage ./non-by-name/docopt-subcommands { };

  docplex = callPackage ./non-by-name/docplex { };

  docrep = callPackage ./non-by-name/docrep { };

  docstr-coverage = callPackage ./non-by-name/docstr-coverage { };

  docstring-parser = callPackage ./non-by-name/docstring-parser { };

  docstring-to-markdown = callPackage ./non-by-name/docstring-to-markdown { };

  docutils = callPackage ./non-by-name/docutils { };

  docutils-stubs = callPackage ./non-by-name/docutils-stubs { };

  docx2python = callPackage ./non-by-name/docx2python { };

  docx2txt = callPackage ./non-by-name/docx2txt { };

  dodgy = callPackage ./non-by-name/dodgy { };

  dogpile-cache = callPackage ./non-by-name/dogpile-cache { };

  dogtag-pki = callPackage ./non-by-name/dogtag-pki { };

  dogtail = callPackage ./non-by-name/dogtail { };

  dohq-artifactory = callPackage ./non-by-name/dohq-artifactory { };

  doit = callPackage ./non-by-name/doit { };

  doit-py = callPackage ./non-by-name/doit-py { };

  dokuwiki = callPackage ./non-by-name/dokuwiki { };

  dom-toml = callPackage ./non-by-name/dom-toml { };

  domdf-python-tools = callPackage ./non-by-name/domdf-python-tools { };

  domeneshop = callPackage ./non-by-name/domeneshop { };

  dominate = callPackage ./non-by-name/dominate { };

  donfig = callPackage ./non-by-name/donfig { };

  donut-shellcode = callPackage ./non-by-name/donut-shellcode { };

  doorbirdpy = callPackage ./non-by-name/doorbirdpy { };

  dopy = callPackage ./non-by-name/dopy { };

  dot2tex = callPackage ./non-by-name/dot2tex { inherit (pkgs) graphviz; };

  dotmap = callPackage ./non-by-name/dotmap { };

  dotty-dict = callPackage ./non-by-name/dotty-dict { };

  dotwiz = callPackage ./non-by-name/dotwiz { };

  doublemetaphone = callPackage ./non-by-name/doublemetaphone { };

  doubleratchet = callPackage ./non-by-name/doubleratchet { };

  doubles = callPackage ./non-by-name/doubles { };

  doujinshi-dl-nhentai = callPackage ./non-by-name/doujinshi-dl-nhentai { };

  dowhen = callPackage ./non-by-name/dowhen { };

  downloader-cli = callPackage ./non-by-name/downloader-cli { };

  doxmlparser = callPackage ./non-by-name/doxmlparser { };

  dpapi-ng = callPackage ./non-by-name/dpapi-ng { };

  dparse = callPackage ./non-by-name/dparse { };

  dparse2 = callPackage ./non-by-name/dparse2 { };

  dpath = callPackage ./non-by-name/dpath { };

  dpcontracts = callPackage ./non-by-name/dpcontracts { };

  dpkt = callPackage ./non-by-name/dpkt { };

  dploot = callPackage ./non-by-name/dploot { };

  draccus = callPackage ./non-by-name/draccus { };

  drafthorse = callPackage ./non-by-name/drafthorse { };

  draftjs-exporter = callPackage ./non-by-name/draftjs-exporter { };

  dragonfly2 = callPackage ./non-by-name/dragonfly2 { };

  dragonmapper = callPackage ./non-by-name/dragonmapper { };

  drain3 = callPackage ./non-by-name/drain3 { };

  dramatiq = callPackage ./non-by-name/dramatiq { };

  dramatiq-abort = callPackage ./non-by-name/dramatiq-abort { };

  dramatiq-eager-broker = callPackage ./non-by-name/dramatiq-eager-broker { };

  drawille = callPackage ./non-by-name/drawille { };

  drawilleplot = callPackage ./non-by-name/drawilleplot { };

  drawsvg = callPackage ./non-by-name/drawsvg { };

  dremel3dpy = callPackage ./non-by-name/dremel3dpy { };

  drf-extra-fields = callPackage ./non-by-name/drf-extra-fields { };

  drf-flex-fields = callPackage ./non-by-name/drf-flex-fields { };

  drf-jwt = callPackage ./non-by-name/drf-jwt { };

  drf-nested-routers = callPackage ./non-by-name/drf-nested-routers { };

  drf-orjson-renderer = callPackage ./non-by-name/drf-orjson-renderer { };

  drf-pydantic = callPackage ./non-by-name/drf-pydantic { };

  drf-spectacular = callPackage ./non-by-name/drf-spectacular { };

  drf-spectacular-sidecar = callPackage ./non-by-name/drf-spectacular-sidecar { };

  drf-standardized-errors = callPackage ./non-by-name/drf-standardized-errors { };

  drf-ujson2 = callPackage ./non-by-name/drf-ujson2 { };

  drf-writable-nested = callPackage ./non-by-name/drf-writable-nested { };

  drf-yasg = callPackage ./non-by-name/drf-yasg { };

  drivelib = callPackage ./non-by-name/drivelib { };

  drms = callPackage ./non-by-name/drms { };

  dronecan = callPackage ./non-by-name/dronecan { };

  dropbox = callPackage ./non-by-name/dropbox { };

  dropmqttapi = callPackage ./non-by-name/dropmqttapi { };

  ds-analysis-lib = callPackage ./non-by-name/ds-analysis-lib { };

  ds-reporting-lib = callPackage ./non-by-name/ds-reporting-lib { };

  ds-server-lib = callPackage ./non-by-name/ds-server-lib { };

  ds-store = callPackage ./non-by-name/ds-store { };

  ds-xbom-lib = callPackage ./non-by-name/ds-xbom-lib { };

  ds4drv = callPackage ./non-by-name/ds4drv { };

  dscribe = callPackage ./non-by-name/dscribe { };

  dsinternals = callPackage ./non-by-name/dsinternals { };

  dsl2html = callPackage ./non-by-name/dsl2html { };

  dsmr-parser = callPackage ./non-by-name/dsmr-parser { };

  dsnap = callPackage ./non-by-name/dsnap { };

  dspy = callPackage ./non-by-name/dspy { };

  dt8852 = callPackage ./non-by-name/dt8852 { };

  dtfabric = callPackage ./non-by-name/dtfabric { };

  dtlssocket = callPackage ./non-by-name/dtlssocket { };

  dtschema = callPackage ./non-by-name/dtschema { };

  dtw-python = callPackage ./non-by-name/dtw-python { };

  ducc0 = callPackage ./non-by-name/ducc0 { };

  duckdb = callPackage ./non-by-name/duckdb { inherit (pkgs) duckdb; };

  duckdb-engine = callPackage ./non-by-name/duckdb-engine { };

  duct = callPackage ./non-by-name/duct { };

  duden = callPackage ./non-by-name/duden { };

  duecredit = callPackage ./non-by-name/duecredit { };

  duet = callPackage ./non-by-name/duet { };

  dufte = callPackage ./non-by-name/dufte { };

  dulwich = callPackage ./non-by-name/dulwich { inherit (pkgs) gnupg; };

  dunamai = callPackage ./non-by-name/dunamai { };

  dungeon-eos = callPackage ./non-by-name/dungeon-eos { };

  duo-client = callPackage ./non-by-name/duo-client { };

  duration-parser = callPackage ./non-by-name/duration-parser { };

  durationpy = callPackage ./non-by-name/durationpy { };

  durus = callPackage ./non-by-name/durus { };

  dvc = callPackage ./non-by-name/dvc { };

  dvc-azure = callPackage ./non-by-name/dvc-azure { };

  dvc-data = callPackage ./non-by-name/dvc-data { };

  dvc-gdrive = callPackage ./non-by-name/dvc-gdrive { };

  dvc-gs = callPackage ./non-by-name/dvc-gs { };

  dvc-hdfs = callPackage ./non-by-name/dvc-hdfs { };

  dvc-http = callPackage ./non-by-name/dvc-http { };

  dvc-objects = callPackage ./non-by-name/dvc-objects { };

  dvc-oss = callPackage ./non-by-name/dvc-oss { };

  dvc-render = callPackage ./non-by-name/dvc-render { };

  dvc-s3 = callPackage ./non-by-name/dvc-s3 { };

  dvc-ssh = callPackage ./non-by-name/dvc-ssh { };

  dvc-studio-client = callPackage ./non-by-name/dvc-studio-client { };

  dvc-task = callPackage ./non-by-name/dvc-task { };

  dvc-webdav = callPackage ./non-by-name/dvc-webdav { };

  dvc-webhdfs = callPackage ./non-by-name/dvc-webhdfs { };

  dvclive = callPackage ./non-by-name/dvclive { };

  dwdwfsapi = callPackage ./non-by-name/dwdwfsapi { };

  dyn = callPackage ./non-by-name/dyn { };

  dynaconf = callPackage ./non-by-name/dynaconf { };

  dynalite-devices = callPackage ./non-by-name/dynalite-devices { };

  dynalite-panel = callPackage ./non-by-name/dynalite-panel { };

  e2b = callPackage ./non-by-name/e2b { };

  e2b-code-interpreter = callPackage ./non-by-name/e2b-code-interpreter { };

  e2b-dockerfile-utils = callPackage ./non-by-name/e2b-dockerfile-utils { };

  e3-core = callPackage ./non-by-name/e3-core { };

  e3nn = callPackage ./non-by-name/e3nn { };

  eagle100 = callPackage ./non-by-name/eagle100 { };

  earn-e-p1 = callPackage ./non-by-name/earn-e-p1 { };

  earth2studio = callPackage ./non-by-name/earth2studio { };

  easy-thumbnails = callPackage ./non-by-name/easy-thumbnails { };

  easydict = callPackage ./non-by-name/easydict { };

  easyenergy = callPackage ./non-by-name/easyenergy { };

  easygui = callPackage ./non-by-name/easygui { };

  easyocr = callPackage ./non-by-name/easyocr { };

  easyprocess = callPackage ./non-by-name/easyprocess { };

  easywatch = callPackage ./non-by-name/easywatch { };

  ebaysdk = callPackage ./non-by-name/ebaysdk { };

  ebcdic = callPackage ./non-by-name/ebcdic { };

  ebooklib = callPackage ./non-by-name/ebooklib { };

  ebusdpy = callPackage ./non-by-name/ebusdpy { };

  ec2-metadata = callPackage ./non-by-name/ec2-metadata { };

  ec2instanceconnectcli = callPackage ./non-by-name/ec2instanceconnectcli { };

  eccodes = toPythonModule (
    pkgs.eccodes.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  ecdsa = callPackage ./non-by-name/ecdsa { };

  echo = callPackage ./non-by-name/echo {
    inherit (pkgs) mesa;
  };

  ecoaliface = callPackage ./non-by-name/ecoaliface { };

  ecoji = callPackage ./non-by-name/ecoji { };

  ecos = callPackage ./non-by-name/ecos { };

  ecpy = callPackage ./non-by-name/ecpy { };

  ecs-logging = callPackage ./non-by-name/ecs-logging { };

  ed25519 = callPackage ./non-by-name/ed25519 { };

  ed25519-blake2b = callPackage ./non-by-name/ed25519-blake2b { };

  edalize = callPackage ./non-by-name/edalize { };

  edgartools = callPackage ./non-by-name/edgartools { };

  edge-tts = callPackage ./non-by-name/edge-tts { };

  editables = callPackage ./non-by-name/editables { };

  editdistance = callPackage ./non-by-name/editdistance { };

  editdistpy = callPackage ./non-by-name/editdistpy { };

  editor = callPackage ./non-by-name/editor { };

  editorconfig = callPackage ./non-by-name/editorconfig { };

  edk2-pytool-library = callPackage ./non-by-name/edk2-pytool-library { };

  edlib = callPackage ./non-by-name/edlib { inherit (pkgs) edlib; };

  eduvpn-common = callPackage ./non-by-name/eduvpn-common { };

  edward = callPackage ./non-by-name/edward { };

  effdet = callPackage ./non-by-name/effdet { };

  effect = callPackage ./non-by-name/effect { };

  egauge-async = callPackage ./non-by-name/egauge-async { };

  eggdeps = callPackage ./non-by-name/eggdeps { };

  eheimdigital = callPackage ./non-by-name/eheimdigital { };

  eigenpy = callPackage ./non-by-name/eigenpy { };

  einops = callPackage ./non-by-name/einops { };

  einx = callPackage ./non-by-name/einx { };

  eiswarnung = callPackage ./non-by-name/eiswarnung { };

  ekey-bionyxpy = callPackage ./non-by-name/ekey-bionyxpy { };

  elastic-apm = callPackage ./non-by-name/elastic-apm { };

  elastic-transport = callPackage ./non-by-name/elastic-transport { };

  elastic-transport_9 = callPackage ./non-by-name/elastic-transport/9.nix { };

  elasticsearch = callPackage ./non-by-name/elasticsearch { };

  elasticsearch-dsl = callPackage ./non-by-name/elasticsearch-dsl { };

  elasticsearch8 = callPackage ./non-by-name/elasticsearch8 { };

  elasticsearch9 = callPackage ./non-by-name/elasticsearch9 { };

  elasticsearchdsl = self.elasticsearch-dsl;

  electrickiwi-api = callPackage ./non-by-name/electrickiwi-api { };

  electrum-aionostr = callPackage ./non-by-name/electrum-aionostr { };

  electrum-ecc = callPackage ./non-by-name/electrum-ecc { };

  elementpath = callPackage ./non-by-name/elementpath { };

  elevate = callPackage ./non-by-name/elevate { };

  elevenlabs = callPackage ./non-by-name/elevenlabs { };

  elfdeps = toPythonModule (pkgs.elfdeps.override { python3Packages = self; });

  elgato = callPackage ./non-by-name/elgato { };

  eliot = callPackage ./non-by-name/eliot { };

  elkm1-lib = callPackage ./non-by-name/elkm1-lib { };

  elkoep-aio-mqtt = callPackage ./non-by-name/elkoep-aio-mqtt { };

  elmax = callPackage ./non-by-name/elmax { };

  elmax-api = callPackage ./non-by-name/elmax-api { };

  elvia = callPackage ./non-by-name/elvia { };

  email-validator = callPackage ./non-by-name/email-validator { };

  embedding-reader = callPackage ./non-by-name/embedding-reader { };

  emborg = callPackage ./non-by-name/emborg { };

  embrace = callPackage ./non-by-name/embrace { };

  embreex = callPackage ./non-by-name/embreex { };

  emcee = callPackage ./non-by-name/emcee { };

  emerge = callPackage ./non-by-name/emerge { };

  emmiai-noether = callPackage ./non-by-name/emmiai-noether { };

  emoji = callPackage ./non-by-name/emoji { };

  emoji-country-flag = callPackage ./non-by-name/emoji-country-flag { };

  emojis = callPackage ./non-by-name/emojis { };

  empty-files = callPackage ./non-by-name/empty-files { };

  empy = callPackage ./non-by-name/empy { };

  emsutil = callPackage ./non-by-name/emsutil { };

  emulated-roku = callPackage ./non-by-name/emulated-roku { };

  emv = callPackage ./non-by-name/emv { };

  enaml = callPackage ./non-by-name/enaml { };

  enamlx = callPackage ./non-by-name/enamlx { };

  encodec = callPackage ./non-by-name/encodec { };

  encutils = callPackage ./non-by-name/encutils { };

  energieleser = callPackage ./non-by-name/energieleser { };

  energyflip-api-client = callPackage ./non-by-name/energyflip-api-client { };

  energyflip-client = callPackage ./non-by-name/energyflip-client { };

  energyflow = callPackage ./non-by-name/energyflow { };

  energyid-webhooks = callPackage ./non-by-name/energyid-webhooks { };

  energyzero = callPackage ./non-by-name/energyzero { };

  enlighten = callPackage ./non-by-name/enlighten { };

  enocean-async = callPackage ./non-by-name/enocean-async { };

  enochecker-core = callPackage ./non-by-name/enochecker-core { };

  enrich = callPackage ./non-by-name/enrich { };

  enterpriseattack = callPackage ./non-by-name/enterpriseattack { };

  entrance = callPackage ./non-by-name/entrance { routerFeatures = false; };

  entrance-with-router-features = callPackage ./non-by-name/entrance {
    routerFeatures = true;
  };

  entry-points-txt = callPackage ./non-by-name/entry-points-txt { };

  entrypoint2 = callPackage ./non-by-name/entrypoint2 { };

  entrypoints = callPackage ./non-by-name/entrypoints { };

  entsoe-apy = callPackage ./non-by-name/entsoe-apy { };

  enturclient = callPackage ./non-by-name/enturclient { };

  enum-tools = callPackage ./non-by-name/enum-tools { };

  env-canada = callPackage ./non-by-name/env-canada { };

  environ-config = callPackage ./non-by-name/environ-config { };

  environmental-override = callPackage ./non-by-name/environmental-override { };

  environs = callPackage ./non-by-name/environs { };

  envisage = callPackage ./non-by-name/envisage { };

  envoy-data-plane = callPackage ./non-by-name/envoy-data-plane { };

  envoy-reader = callPackage ./non-by-name/envoy-reader { };

  envoy-utils = callPackage ./non-by-name/envoy-utils { };

  envs = callPackage ./non-by-name/envs { };

  enzyme = callPackage ./non-by-name/enzyme { };

  epaper-dithering = callPackage ./non-by-name/epaper-dithering { };

  epc = callPackage ./non-by-name/epc { };

  ephem = callPackage ./non-by-name/ephem { };

  ephemeral-port-reserve = callPackage ./non-by-name/ephemeral-port-reserve { };

  epicstore-api = callPackage ./non-by-name/epicstore-api { };

  epion = callPackage ./non-by-name/epion { };

  epitran = callPackage ./non-by-name/epitran { };

  epson-projector = callPackage ./non-by-name/epson-projector { };

  eq3btsmart = callPackage ./non-by-name/eq3btsmart { };

  equinox = callPackage ./non-by-name/equinox { };

  eradicate = callPackage ./non-by-name/eradicate { };

  error-helper = callPackage ./non-by-name/error-helper { };

  es-client = callPackage ./non-by-name/es-client { };

  es-client_8 = callPackage ./non-by-name/es-client/8.nix { };

  escapism = callPackage ./non-by-name/escapism { };

  eseries = callPackage ./non-by-name/eseries { };

  esios-api = callPackage ./non-by-name/esios-api { };

  esp-idf-size = callPackage ./non-by-name/esp-idf-size { };

  esp-pylib = callPackage ./non-by-name/esp-pylib { };

  espeak-phonemizer = callPackage ./non-by-name/espeak-phonemizer { };

  esper = callPackage ./non-by-name/esper { };

  esphome-dashboard-api = callPackage ./non-by-name/esphome-dashboard-api { };

  esphome-glyphsets = callPackage ./non-by-name/esphome-glyphsets { };

  esprima = callPackage ./non-by-name/esprima { };

  essent-dynamic-pricing = callPackage ./non-by-name/essent-dynamic-pricing { };

  essentials = callPackage ./non-by-name/essentials { };

  essentials-openapi = callPackage ./non-by-name/essentials-openapi { };

  et-xmlfile = callPackage ./non-by-name/et-xmlfile { };

  etcd = callPackage ./non-by-name/etcd { };

  etcd3 = callPackage ./non-by-name/etcd3 { inherit (pkgs) etcd; };

  ete3 = callPackage ./non-by-name/ete3 { };

  etebase = callPackage ./non-by-name/etebase { };

  etelemetry = callPackage ./non-by-name/etelemetry { };

  eternalegypt = callPackage ./non-by-name/eternalegypt { };

  etesync = callPackage ./non-by-name/etesync { };

  eth-abi = callPackage ./non-by-name/eth-abi { };

  eth-account = callPackage ./non-by-name/eth-account { };

  eth-bloom = callPackage ./non-by-name/eth-bloom { };

  eth-hash = callPackage ./non-by-name/eth-hash { };

  eth-keyfile = callPackage ./non-by-name/eth-keyfile { };

  eth-keys = callPackage ./non-by-name/eth-keys { };

  eth-rlp = callPackage ./non-by-name/eth-rlp { };

  eth-tester = callPackage ./non-by-name/eth-tester { };

  eth-typing = callPackage ./non-by-name/eth-typing { };

  eth-utils = callPackage ./non-by-name/eth-utils { };

  etherscan-python = callPackage ./non-by-name/etherscan-python { };

  ethtool = callPackage ./non-by-name/ethtool { };

  etils = callPackage ./non-by-name/etils { };

  etuples = callPackage ./non-by-name/etuples { };

  euclid3 = callPackage ./non-by-name/euclid3 { };

  eufylife-ble-client = callPackage ./non-by-name/eufylife-ble-client { };

  euporie = callPackage ./non-by-name/euporie { };

  eurotronic-cometblue-ha = callPackage ./non-by-name/eurotronic-cometblue-ha { };

  eval-type-backport = callPackage ./non-by-name/eval-type-backport { };

  evaluate = callPackage ./non-by-name/evaluate { };

  evdev = callPackage ./non-by-name/evdev { };

  eve = callPackage ./non-by-name/eve { };

  eventkit = callPackage ./non-by-name/eventkit { };

  eventlet = callPackage ./non-by-name/eventlet { };

  events = callPackage ./non-by-name/events { };

  everett = callPackage ./non-by-name/everett { };

  evohome-async = callPackage ./non-by-name/evohome-async { };

  evolutionhttp = callPackage ./non-by-name/evolutionhttp { };

  evosax = callPackage ./non-by-name/evosax { };

  evtx = callPackage ./non-by-name/evtx { };

  ewmh = callPackage ./non-by-name/ewmh { };

  ewmhlib = callPackage ./non-by-name/ewmhlib { };

  exa-py = callPackage ./non-by-name/exa-py { };

  example-robot-data = callPackage ./non-by-name/example-robot-data {
    inherit (pkgs) example-robot-data;
  };

  exceptiongroup = callPackage ./non-by-name/exceptiongroup { };

  exchangelib = callPackage ./non-by-name/exchangelib { };

  exdown = callPackage ./non-by-name/exdown { };

  execnb = callPackage ./non-by-name/execnb { };

  execnet = callPackage ./non-by-name/execnet { };

  executing = callPackage ./non-by-name/executing { };

  executor = callPackage ./non-by-name/executor { };

  executorch = callPackage ./non-by-name/executorch { };

  exif = callPackage ./non-by-name/exif { };

  exifread = callPackage ./non-by-name/exifread { };

  exitcode = callPackage ./non-by-name/exitcode { };

  exiv2 = callPackage ./non-by-name/exiv2 { inherit (pkgs) exiv2; };

  exllamav3 = callPackage ./non-by-name/exllamav3 { };

  expandvars = callPackage ./non-by-name/expandvars { };

  expects = callPackage ./non-by-name/expects { };

  expecttest = callPackage ./non-by-name/expecttest { };

  experiment-utilities = callPackage ./non-by-name/experiment-utilities { };

  expiring-dict = callPackage ./non-by-name/expiring-dict { };

  expiringdict = callPackage ./non-by-name/expiringdict { };

  explorerscript = callPackage ./non-by-name/explorerscript { };

  expression = callPackage ./non-by-name/expression { };

  exrex = callPackage ./non-by-name/exrex { };

  extension-helpers = callPackage ./non-by-name/extension-helpers { };

  extra-streamlit-components = callPackage ./non-by-name/extra-streamlit-components { };

  extract-msg = callPackage ./non-by-name/extract-msg { };

  extractcode = callPackage ./non-by-name/extractcode { };

  extractcode-7z = callPackage ./non-by-name/extractcode/7z.nix {
    inherit (pkgs) p7zip;
  };

  extractcode-libarchive = callPackage ./non-by-name/extractcode/libarchive.nix {
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

  extras = callPackage ./non-by-name/extras { };

  extruct = callPackage ./non-by-name/extruct { };

  eyed3 = callPackage ./non-by-name/eyed3 { };

  ezdxf = callPackage ./non-by-name/ezdxf { };

  ezodf = callPackage ./non-by-name/ezodf { };

  ezyrb = callPackage ./non-by-name/ezyrb { };

  f3d = toPythonModule (
    pkgs.f3d.override {
      withPythonBinding = true;
      python3Packages = self;
    }
  );

  f5-icontrol-rest = callPackage ./non-by-name/f5-icontrol-rest { };

  f5-sdk = callPackage ./non-by-name/f5-sdk { };

  f90nml = callPackage ./non-by-name/f90nml { };

  faadelays = callPackage ./non-by-name/faadelays { };

  fabio = callPackage ./non-by-name/fabio { };

  fabric = callPackage ./non-by-name/fabric { };

  fabulous = callPackage ./non-by-name/fabulous { };

  face = callPackage ./non-by-name/face { };

  face-recognition = callPackage ./non-by-name/face-recognition { };

  face-recognition-models = callPackage ./non-by-name/face-recognition/models.nix { };

  facebook-sdk = callPackage ./non-by-name/facebook-sdk { };

  facedancer = callPackage ./non-by-name/facedancer { };

  facenet-pytorch = callPackage ./non-by-name/facenet-pytorch { };

  factory-boy = callPackage ./non-by-name/factory-boy { };

  faicons = callPackage ./non-by-name/faicons { };

  fairscale = callPackage ./non-by-name/fairscale { };

  fairseq = callPackage ./non-by-name/fairseq { };

  faiss = callPackage ./non-by-name/faiss {
    faiss-build = pkgs.faiss.override {
      pythonSupport = true;
      python3Packages = self;
    };
  };

  faiss-cpu = callPackage ./non-by-name/faiss-cpu {
    faiss = self.faiss.override {
      faiss-build = pkgs.faiss.override {
        pythonSupport = true;
        python3Packages = self;
        cudaSupport = false;
      };
    };
  };

  fake-http-header = callPackage ./non-by-name/fake-http-header { };

  fake-useragent = callPackage ./non-by-name/fake-useragent { };

  faker = callPackage ./non-by-name/faker { };

  fakeredis = callPackage ./non-by-name/fakeredis { };

  falcon = callPackage ./non-by-name/falcon { };

  falcon-cors = callPackage ./non-by-name/falcon-cors { };

  faraday-agent-parameters-types = callPackage ./non-by-name/faraday-agent-parameters-types { };

  faraday-plugins = callPackage ./non-by-name/faraday-plugins { };

  farama-notifications = callPackage ./non-by-name/farama-notifications { };

  fast-array-utils = callPackage ./non-by-name/fast-array-utils { };

  fast-colorthief = callPackage ./non-by-name/fast-colorthief { };

  fast-hdbscan = callPackage ./non-by-name/fast-hdbscan { };

  fast-histogram = callPackage ./non-by-name/fast-histogram { };

  fast-query-parsers = callPackage ./non-by-name/fast-query-parsers { };

  fast-simplification = callPackage ./non-by-name/fast-simplification { };

  fastai = callPackage ./non-by-name/fastai { };

  fastapi = callPackage ./non-by-name/fastapi { };

  fastapi-cli = callPackage ./non-by-name/fastapi-cli { };

  fastapi-github-oidc = callPackage ./non-by-name/fastapi-github-oidc { };

  fastapi-mail = callPackage ./non-by-name/fastapi-mail { };

  fastapi-mcp = callPackage ./non-by-name/fastapi-mcp { };

  fastapi-pagination = callPackage ./non-by-name/fastapi-pagination { };

  fastapi-sso = callPackage ./non-by-name/fastapi-sso { };

  fastapi-versionizer = callPackage ./non-by-name/fastapi-versionizer { };

  fastavro = callPackage ./non-by-name/fastavro { };

  fastbencode = callPackage ./non-by-name/fastbencode { };

  fastcache = callPackage ./non-by-name/fastcache { };

  fastcan = callPackage ./non-by-name/fastcan { };

  fastcore = callPackage ./non-by-name/fastcore { };

  fastcrc = callPackage ./non-by-name/fastcrc { };

  fastdiff = callPackage ./non-by-name/fastdiff { };

  fastdotcom = callPackage ./non-by-name/fastdotcom { };

  fastdownload = callPackage ./non-by-name/fastdownload { };

  fastdtw = callPackage ./non-by-name/fastdtw { };

  fastecdsa = callPackage ./non-by-name/fastecdsa { };

  fastembed = callPackage ./non-by-name/fastembed { };

  fasteners = callPackage ./non-by-name/fasteners { };

  fastentrypoints = callPackage ./non-by-name/fastentrypoints { };

  faster-whisper = callPackage ./non-by-name/faster-whisper { };

  fastexcel = callPackage ./non-by-name/fastexcel { };

  fastgit = callPackage ./non-by-name/fastgit { };

  fastimport = callPackage ./non-by-name/fastimport { };

  fastjet = callPackage ./non-by-name/fastjet { };

  fastjsonschema = callPackage ./non-by-name/fastjsonschema { };

  fastlite = callPackage ./non-by-name/fastlite { };

  fastmcp = callPackage ./non-by-name/fastmcp { };

  fastmcp-slim = callPackage ./non-by-name/fastmcp-slim { };

  fastmri = callPackage ./non-by-name/fastmri { };

  fastnlo-toolkit = toPythonModule (
    pkgs.fastnlo-toolkit.override {
      withPython = true;
      inherit (self) python;
    }
  );

  fastnumbers = callPackage ./non-by-name/fastnumbers { };

  fastparquet = callPackage ./non-by-name/fastparquet { };

  fastpbkdf2 = callPackage ./non-by-name/fastpbkdf2 { };

  fastprogress = callPackage ./non-by-name/fastprogress { };

  fastremap = callPackage ./non-by-name/fastremap { };

  fastrlock = callPackage ./non-by-name/fastrlock { };

  fastspec = callPackage ./non-by-name/fastspec { };

  fasttext = callPackage ./non-by-name/fasttext { };

  fasttransform = callPackage ./non-by-name/fasttransform { };

  fasttransport = callPackage ./non-by-name/fasttransport { };

  fastuuid = callPackage ./non-by-name/fastuuid { };

  faust-cchardet = callPackage ./non-by-name/faust-cchardet { };

  fava = callPackage ./non-by-name/fava { };

  fava-dashboards = callPackage ./non-by-name/fava-dashboards { };

  fava-investor = callPackage ./non-by-name/fava-investor { };

  fava-portfolio-returns = callPackage ./non-by-name/fava-portfolio-returns { };

  favicon = callPackage ./non-by-name/favicon { };

  fdp-scan = callPackage ./non-by-name/fdp-scan { };

  fe25519 = callPackage ./non-by-name/fe25519 { };

  feather-format = callPackage ./non-by-name/feather-format { };

  fedora-messaging = callPackage ./non-by-name/fedora-messaging { };

  feedfinder2 = callPackage ./non-by-name/feedfinder2 { };

  feedgen = callPackage ./non-by-name/feedgen { };

  feedgenerator = callPackage ./non-by-name/feedgenerator { };

  feedparser = callPackage ./non-by-name/feedparser { };

  feedparser-sgmllib = callPackage ./non-by-name/feedparser-sgmllib { };

  fenics-basix = callPackage ./non-by-name/fenics-basix { };

  fenics-dolfinx = callPackage ./non-by-name/fenics-dolfinx { };

  fenics-ffcx = callPackage ./non-by-name/fenics-ffcx { };

  fenics-ufl = callPackage ./non-by-name/fenics-ufl { };

  ffcv = callPackage ./non-by-name/ffcv { };

  ffmpeg-normalize = callPackage ./non-by-name/ffmpeg-normalize { };

  ffmpeg-progress-yield = callPackage ./non-by-name/ffmpeg-progress-yield { };

  ffmpeg-python = callPackage ./non-by-name/ffmpeg-python { };

  ffmpy = callPackage ./non-by-name/ffmpy { };

  ffpyplayer = callPackage ./non-by-name/ffpyplayer { };

  fhirpy = callPackage ./non-by-name/fhirpy { };

  fiblary3-fork = callPackage ./non-by-name/fiblary3-fork { };

  fica = callPackage ./non-by-name/fica { };

  fickling = callPackage ./non-by-name/fickling { };

  fido2 = callPackage ./non-by-name/fido2 { };

  fields = callPackage ./non-by-name/fields { };

  file-read-backwards = callPackage ./non-by-name/file-read-backwards { };

  filebrowser-safe = callPackage ./non-by-name/filebrowser-safe { };

  filebytes = callPackage ./non-by-name/filebytes { };

  filecheck = callPackage ./non-by-name/filecheck { };

  filedate = callPackage ./non-by-name/filedate { };

  filedepot = callPackage ./non-by-name/filedepot { };

  filelock = callPackage ./non-by-name/filelock { };

  files-to-prompt = callPackage ./non-by-name/files-to-prompt { };

  fileseq = callPackage ./non-by-name/fileseq { };

  filetype = callPackage ./non-by-name/filetype { };

  filterpy = callPackage ./non-by-name/filterpy { };

  finalfusion = callPackage ./non-by-name/finalfusion { };

  find-libpython = callPackage ./non-by-name/find-libpython { };

  findimports = callPackage ./non-by-name/findimports { };

  findpython = callPackage ./non-by-name/findpython { };

  findspark = callPackage ./non-by-name/findspark { };

  finetuning-scheduler = callPackage ./non-by-name/finetuning-scheduler { };

  fing-agent-api = callPackage ./non-by-name/fing-agent-api { };

  fingerprints = callPackage ./non-by-name/fingerprints { };

  finitude = callPackage ./non-by-name/finitude { };

  fints = callPackage ./non-by-name/fints { };

  finufft = callPackage ./non-by-name/finufft {
    inherit (pkgs) finufft;
  };

  finvizfinance = callPackage ./non-by-name/finvizfinance { };

  fiona = callPackage ./non-by-name/fiona { };

  fipy = callPackage ./non-by-name/fipy { };

  fire = callPackage ./non-by-name/fire { };

  firebase-admin = callPackage ./non-by-name/firebase-admin { };

  firebase-messaging = callPackage ./non-by-name/firebase-messaging { };

  firecrawl-anydoc = callPackage ./non-by-name/firecrawl-anydoc { };

  firecrawl-py = callPackage ./non-by-name/firecrawl-py { };

  firedrake = callPackage ./non-by-name/firedrake { };

  firedrake-fiat = callPackage ./non-by-name/firedrake-fiat { };

  firedrake-ufl = callPackage ./non-by-name/firedrake-ufl { };

  fireflyalgorithm = callPackage ./non-by-name/fireflyalgorithm { };

  firetv = callPackage ./non-by-name/firetv { };

  fireworks-ai = callPackage ./non-by-name/fireworks-ai { };

  first = callPackage ./non-by-name/first { };

  fiscalyear = callPackage ./non-by-name/fiscalyear { };

  fish-audio-sdk = callPackage ./non-by-name/fish-audio-sdk { };

  fissix = callPackage ./non-by-name/fissix { };

  fitbit = callPackage ./non-by-name/fitbit { };

  fitbit-web-api = callPackage ./non-by-name/fitbit-web-api { };

  fitdecode = callPackage ./non-by-name/fitdecode { };

  fitfile = callPackage ./non-by-name/fitfile { };

  fitparse = callPackage ./non-by-name/fitparse { };

  fivem-api = callPackage ./non-by-name/fivem-api { };

  fixerio = callPackage ./non-by-name/fixerio { };

  fixtures = callPackage ./non-by-name/fixtures { };

  fjaraskupan = callPackage ./non-by-name/fjaraskupan { };

  fla-core = callPackage ./non-by-name/fla-core { };

  flake8 = callPackage ./non-by-name/flake8 { };

  flake8-blind-except = callPackage ./non-by-name/flake8-blind-except { };

  flake8-bugbear = callPackage ./non-by-name/flake8-bugbear { };

  flake8-class-newline = callPackage ./non-by-name/flake8-class-newline { };

  flake8-debugger = callPackage ./non-by-name/flake8-debugger { };

  flake8-deprecated = callPackage ./non-by-name/flake8-deprecated { };

  flake8-docstrings = callPackage ./non-by-name/flake8-docstrings { };

  flake8-import-order = callPackage ./non-by-name/flake8-import-order { };

  flake8-length = callPackage ./non-by-name/flake8-length { };

  flake8-polyfill = callPackage ./non-by-name/flake8-polyfill { };

  flake8-quotes = callPackage ./non-by-name/flake8-quotes { };

  flaky = callPackage ./non-by-name/flaky { };

  flametree = callPackage ./non-by-name/flametree { };

  flammkuchen = callPackage ./non-by-name/flammkuchen { };

  flare-capa = callPackage ./non-by-name/flare-capa { };

  flasgger = callPackage ./non-by-name/flasgger { };

  flash-attn = callPackage ./non-by-name/flash-attn { };

  flash-attn-3 = callPackage ./non-by-name/flash-attn-3 { };

  flash-attn-4 = callPackage ./non-by-name/flash-attn-4 { };

  flash-linear-attention = callPackage ./non-by-name/flash-linear-attention { };

  flash-mla = callPackage ./non-by-name/flash-mla { };

  flashinfer-cubin = callPackage ./non-by-name/flashinfer-cubin { };

  flashinfer-jit-cache = callPackage ./non-by-name/flashinfer-jit-cache { };

  flashinfer-python = callPackage ./non-by-name/flashinfer-python { };

  flashtext = callPackage ./non-by-name/flashtext { };

  flask = callPackage ./non-by-name/flask { };

  flask-admin = callPackage ./non-by-name/flask-admin { };

  flask-alembic = callPackage ./non-by-name/flask-alembic { };

  flask-allowed-hosts = callPackage ./non-by-name/flask-allowed-hosts { };

  flask-api = callPackage ./non-by-name/flask-api { };

  flask-appbuilder = callPackage ./non-by-name/flask-appbuilder { };

  flask-apscheduler = callPackage ./non-by-name/flask-apscheduler { };

  flask-assets = callPackage ./non-by-name/flask-assets { };

  flask-babel = callPackage ./non-by-name/flask-babel { };

  flask-bcrypt = callPackage ./non-by-name/flask-bcrypt { };

  flask-bootstrap = callPackage ./non-by-name/flask-bootstrap { };

  flask-caching = callPackage ./non-by-name/flask-caching { };

  flask-compress = callPackage ./non-by-name/flask-compress { };

  flask-cors = callPackage ./non-by-name/flask-cors { };

  flask-dance = callPackage ./non-by-name/flask-dance { };

  flask-dramatiq = callPackage ./non-by-name/flask-dramatiq { };

  flask-elastic = callPackage ./non-by-name/flask-elastic { };

  flask-expects-json = callPackage ./non-by-name/flask-expects-json { };

  flask-gravatar = callPackage ./non-by-name/flask-gravatar { };

  flask-httpauth = callPackage ./non-by-name/flask-httpauth { };

  flask-jwt-extended = callPackage ./non-by-name/flask-jwt-extended { };

  flask-ldap3-login = callPackage ./non-by-name/flask-ldap3-login { };

  flask-limiter = callPackage ./non-by-name/flask-limiter { };

  flask-login = callPackage ./non-by-name/flask-login { };

  flask-mail = callPackage ./non-by-name/flask-mail { };

  flask-mailman = callPackage ./non-by-name/flask-mailman { };

  flask-marshmallow = callPackage ./non-by-name/flask-marshmallow { };

  flask-migrate = callPackage ./non-by-name/flask-migrate { };

  flask-mongoengine = callPackage ./non-by-name/flask-mongoengine { };

  flask-mysqldb = callPackage ./non-by-name/flask-mysqldb { };

  flask-openid = callPackage ./non-by-name/flask-openid { };

  flask-paginate = callPackage ./non-by-name/flask-paginate { };

  flask-paranoid = callPackage ./non-by-name/flask-paranoid { };

  flask-principal = callPackage ./non-by-name/flask-principal { };

  flask-pymongo = callPackage ./non-by-name/flask-pymongo { };

  flask-restful = callPackage ./non-by-name/flask-restful { };

  flask-restx = callPackage ./non-by-name/flask-restx { };

  flask-reverse-proxy-fix = callPackage ./non-by-name/flask-reverse-proxy-fix { };

  flask-script = callPackage ./non-by-name/flask-script { };

  flask-seasurf = callPackage ./non-by-name/flask-seasurf { };

  flask-security = callPackage ./non-by-name/flask-security { };

  flask-session = callPackage ./non-by-name/flask-session { };

  flask-session-captcha = callPackage ./non-by-name/flask-session-captcha { };

  flask-session2 = callPackage ./non-by-name/flask-session2 { };

  flask-simpleldap = callPackage ./non-by-name/flask-simpleldap { };

  flask-sock = callPackage ./non-by-name/flask-sock { };

  flask-socketio = callPackage ./non-by-name/flask-socketio { };

  flask-sqlalchemy = callPackage ./non-by-name/flask-sqlalchemy { };

  flask-sqlalchemy-lite = callPackage ./non-by-name/flask-sqlalchemy-lite { };

  flask-sslify = callPackage ./non-by-name/flask-sslify { };

  flask-static-digest = callPackage ./non-by-name/flask-static-digest { };

  flask-swagger = callPackage ./non-by-name/flask-swagger { };

  flask-swagger-ui = callPackage ./non-by-name/flask-swagger-ui { };

  flask-talisman = callPackage ./non-by-name/flask-talisman { };

  flask-testing = callPackage ./non-by-name/flask-testing { };

  flask-themer = callPackage ./non-by-name/flask-themer { };

  flask-unsign = callPackage ./non-by-name/flask-unsign { };

  flask-webtest = callPackage ./non-by-name/flask-webtest { };

  flask-wtf = callPackage ./non-by-name/flask-wtf { };

  flask-wtforms-htmx = callPackage ./non-by-name/flask-wtforms-htmx { };

  flask-xml-rpc-re = callPackage ./non-by-name/flask-xml-rpc-re { };

  flatbencode = callPackage ./non-by-name/flatbencode { };

  flatbuffers = callPackage ./non-by-name/flatbuffers { inherit (pkgs) flatbuffers; };

  flatdict = callPackage ./non-by-name/flatdict { };

  flatlatex = callPackage ./non-by-name/flatlatex { };

  flatten-dict = callPackage ./non-by-name/flatten-dict { };

  flatten-json = callPackage ./non-by-name/flatten-json { };

  flax = callPackage ./non-by-name/flax { };

  flaxlib = callPackage ./non-by-name/flaxlib { };

  fleep = callPackage ./non-by-name/fleep { };

  flet = callPackage ./non-by-name/flet { };

  flet-cli = callPackage ./non-by-name/flet-cli { };

  flet-desktop = callPackage ./non-by-name/flet-desktop { };

  flet-web = callPackage ./non-by-name/flet-web { };

  flexcache = callPackage ./non-by-name/flexcache { };

  flexit-bacnet = callPackage ./non-by-name/flexit-bacnet { };

  flexit-modbus = callPackage ./non-by-name/flexit-modbus { };

  flexmock = callPackage ./non-by-name/flexmock { };

  flexparser = callPackage ./non-by-name/flexparser { };

  flightradarapi = callPackage ./non-by-name/flightradarapi { };

  flit = callPackage ./non-by-name/flit { };

  flit-core = callPackage ./non-by-name/flit-core { };

  flit-gettext = callPackage ./non-by-name/flit-gettext { };

  flit-scm = callPackage ./non-by-name/flit-scm { };

  floret = callPackage ./non-by-name/floret { };

  flow-it-api = callPackage ./non-by-name/flow-it-api { };

  flow-record = callPackage ./non-by-name/flow-record { };

  flower = callPackage ./non-by-name/flower { };

  flowjax = callPackage ./non-by-name/flowjax { };

  flowlogs-reader = callPackage ./non-by-name/flowlogs-reader { };

  flowmc = callPackage ./non-by-name/flowmc { };

  fluent-logger = callPackage ./non-by-name/fluent-logger { };

  fluent-pygments = callPackage ./non-by-name/python-fluent/fluent-pygments.nix { };

  fluent-runtime = callPackage ./non-by-name/python-fluent/fluent-runtime.nix { };

  fluent-syntax = callPackage ./non-by-name/python-fluent/fluent-syntax.nix { };

  flufl-bounce = callPackage ./non-by-name/flufl/bounce.nix { };

  flufl-i18n = callPackage ./non-by-name/flufl/i18n.nix { };

  flufl-lock = callPackage ./non-by-name/flufl/lock.nix { };

  fluss-api = callPackage ./non-by-name/fluss-api { };

  flux-led = callPackage ./non-by-name/flux-led { };

  flyingsquid = callPackage ./non-by-name/flyingsquid { };

  flynt = callPackage ./non-by-name/flynt { };

  fmpy = callPackage ./non-by-name/fmpy { };

  fnllm = callPackage ./non-by-name/fnllm { };

  fnv-hash-fast = callPackage ./non-by-name/fnv-hash-fast { };

  fnvhash = callPackage ./non-by-name/fnvhash { };

  folium = callPackage ./non-by-name/folium { };

  font-v = callPackage ./non-by-name/font-v { };

  fontawesomefree = callPackage ./non-by-name/fontawesomefree { };

  fontbakery = callPackage ./non-by-name/fontbakery { };

  fontfeatures = callPackage ./non-by-name/fontfeatures { };

  fontforge = toPythonModule (
    pkgs.fontforge.override {
      withPython = true;
      python3 = python;
    }
  );

  fontmake = callPackage ./non-by-name/fontmake { };

  fontmath = callPackage ./non-by-name/fontmath { };

  fontparts = callPackage ./non-by-name/fontparts { };

  fontpens = callPackage ./non-by-name/fontpens { };

  fonttools = callPackage ./non-by-name/fonttools { };

  foobot-async = callPackage ./non-by-name/foobot-async { };

  foolscap = callPackage ./non-by-name/foolscap { };

  forbiddenfruit = callPackage ./non-by-name/forbiddenfruit { };

  fordpass = callPackage ./non-by-name/fordpass { };

  forecast-solar = callPackage ./non-by-name/forecast-solar { };

  formatron = callPackage ./non-by-name/formatron { };

  formbox = callPackage ./non-by-name/formbox { };

  formencode = callPackage ./non-by-name/formencode { };

  formulae = callPackage ./non-by-name/formulae { };

  formulaic = callPackage ./non-by-name/formulaic { };

  formulas = callPackage ./non-by-name/formulas { };

  fortiosapi = callPackage ./non-by-name/fortiosapi { };

  fortune-python = callPackage ./non-by-name/fortune-python { };

  foss-flame = callPackage ./non-by-name/foss-flame { };

  foundationdb = callPackage ./non-by-name/foundationdb {
    inherit (pkgs) foundationdb;
  };

  foundrytools = callPackage ./non-by-name/foundrytools { };

  fountains = callPackage ./non-by-name/fountains { };

  foxdot = callPackage ./non-by-name/foxdot { };

  fpdf = callPackage ./non-by-name/fpdf { };

  fpdf2 = callPackage ./non-by-name/fpdf2 { };

  fpsample = callPackage ./non-by-name/fpsample { };

  fpylll = callPackage ./non-by-name/fpylll { };

  fpyutils = callPackage ./non-by-name/fpyutils { };

  fqdn = callPackage ./non-by-name/fqdn { };

  free-proxy = callPackage ./non-by-name/free-proxy { };

  freebox-api = callPackage ./non-by-name/freebox-api { };

  freenub = callPackage ./non-by-name/freenub { };

  freertos-gdb = callPackage ./non-by-name/freertos-gdb { };

  freesasa = callPackage ./non-by-name/freesasa { inherit (pkgs) freesasa; };

  freesms = callPackage ./non-by-name/freesms { };

  freetype-py = callPackage ./non-by-name/freetype-py { };

  freeze-core = callPackage ./non-by-name/freeze-core { };

  freezegun = callPackage ./non-by-name/freezegun { };

  frelatage = callPackage ./non-by-name/frelatage { };

  fressnapftracker = callPackage ./non-by-name/fressnapftracker { };

  freud-analysis = callPackage ./non-by-name/freud-analysis { };

  frictionless = callPackage ./non-by-name/frictionless { };

  frida-python = callPackage ./non-by-name/frida-python { };

  friendly-traceback = callPackage ./non-by-name/friendly-traceback { };

  frigidaire = callPackage ./non-by-name/frigidaire { };

  frilouz = callPackage ./non-by-name/frilouz { };

  fritzconnection = callPackage ./non-by-name/fritzconnection { };

  fronius-modbus = callPackage ./non-by-name/fronius-modbus { };

  fronius-solarapi = callPackage ./non-by-name/fronius-solarapi { };

  frozendict = callPackage ./non-by-name/frozendict { };

  frozenlist = callPackage ./non-by-name/frozenlist { };

  frozenlist2 = callPackage ./non-by-name/frozenlist2 { };

  fs = callPackage ./non-by-name/fs { };

  fs-s3fs = callPackage ./non-by-name/fs-s3fs { };

  fschat = callPackage ./non-by-name/fschat { };

  fslpy = callPackage ./non-by-name/fslpy { };

  fspath = callPackage ./non-by-name/fspath { };

  fsspec = callPackage ./non-by-name/fsspec { };

  fsspec-xrootd = callPackage ./non-by-name/fsspec-xrootd { };

  fst-pso = callPackage ./non-by-name/fst-pso { };

  ftfy = callPackage ./non-by-name/ftfy { };

  ftputil = callPackage ./non-by-name/ftputil { };

  fugashi = callPackage ./non-by-name/fugashi { };

  fullmoon = callPackage ./non-by-name/fullmoon { };

  fumis = callPackage ./non-by-name/fumis { };

  func-timeout = callPackage ./non-by-name/func-timeout { };

  funcparserlib = callPackage ./non-by-name/funcparserlib { };

  funcsigs = callPackage ./non-by-name/funcsigs { };

  functions-framework = callPackage ./non-by-name/functions-framework { };

  functiontrace = callPackage ./non-by-name/functiontrace { };

  funcy = callPackage ./non-by-name/funcy { };

  funk = callPackage ./non-by-name/funk { };

  funsor = callPackage ./non-by-name/funsor { };

  furl = callPackage ./non-by-name/furl { };

  furo = callPackage ./non-by-name/furo { };

  fusepy = callPackage ./non-by-name/fusepy { };

  future = callPackage ./non-by-name/future { };

  future-fstrings = callPackage ./non-by-name/future-fstrings { };

  future-typing = callPackage ./non-by-name/future-typing { };

  fuzzyfinder = callPackage ./non-by-name/fuzzyfinder { };

  fuzzytm = callPackage ./non-by-name/fuzzytm { };

  fuzzywuzzy = callPackage ./non-by-name/fuzzywuzzy { };

  fvcore = callPackage ./non-by-name/fvcore { };

  fx2 = callPackage ./non-by-name/fx2 { };

  fxrays = callPackage ./non-by-name/fxrays { };

  fyta-cli = callPackage ./non-by-name/fyta-cli { };

  g2pkk = callPackage ./non-by-name/g2pkk { };

  ga4gh = callPackage ./non-by-name/ga4gh { };

  galario = toPythonModule (
    pkgs.galario.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  galois = callPackage ./non-by-name/galois { };

  gamble = callPackage ./non-by-name/gamble { };

  gaphas = callPackage ./non-by-name/gaphas { };

  gardena-bluetooth = callPackage ./non-by-name/gardena-bluetooth { };

  garminconnect = callPackage ./non-by-name/garminconnect { };

  garminconnect-aio = callPackage ./non-by-name/garminconnect-aio { };

  gassist-text = callPackage ./non-by-name/gassist-text { };

  gast = callPackage ./non-by-name/gast { };

  gatt = callPackage ./non-by-name/gatt { };

  gattlib = callPackage ./non-by-name/gattlib {
    inherit (pkgs) bluez glib pkg-config;
  };

  gatus-api = callPackage ./non-by-name/gatus-api { };

  gawd = callPackage ./non-by-name/gawd { };

  gb-io = callPackage ./non-by-name/gb-io { };

  gbinder-python = callPackage ./non-by-name/gbinder-python { };

  gcal-sync = callPackage ./non-by-name/gcal-sync { };

  gcodepy = callPackage ./non-by-name/gcodepy { };

  gcp-storage-emulator = callPackage ./non-by-name/gcp-storage-emulator { };

  gcsa = callPackage ./non-by-name/gcsa { };

  gcsfs = callPackage ./non-by-name/gcsfs { };

  gdal = toPythonModule (pkgs.gdal.override { python3Packages = self; });

  gdata = callPackage ./non-by-name/gdata { };

  gdb-pt-dump = callPackage ./non-by-name/gdb-pt-dump { };

  gdcm = toPythonModule (
    pkgs.gdcm.override {
      inherit (self) python;
      enablePython = true;
    }
  );

  gdown = callPackage ./non-by-name/gdown { };

  gdsfactory = callPackage ./non-by-name/gdsfactory { };

  gdstk = callPackage ./non-by-name/gdstk { };

  ge25519 = callPackage ./non-by-name/ge25519 { };

  geant4 = toPythonModule (
    pkgs.geant4.override {
      enablePython = true;
      python3 = python;
    }
  );

  gehomesdk = callPackage ./non-by-name/gehomesdk { };

  gekitchen = callPackage ./non-by-name/gekitchen { };

  gekko = callPackage ./non-by-name/gekko { };

  gemfileparser = callPackage ./non-by-name/gemfileparser { };

  gemfileparser2 = callPackage ./non-by-name/gemfileparser2 { };

  gemmi = toPythonModule (
    pkgs.gemmi.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  genai-prices = callPackage ./non-by-name/genai-prices { };

  genanki = callPackage ./non-by-name/genanki { };

  general-sam = callPackage ./non-by-name/general-sam { };

  generic = callPackage ./non-by-name/generic { };

  genie-partner-sdk = callPackage ./non-by-name/genie-partner-sdk { };

  geniushub-client = callPackage ./non-by-name/geniushub-client { };

  genome-collector = callPackage ./non-by-name/genome-collector { };

  genpy = callPackage ./non-by-name/genpy { };

  genshi = callPackage ./non-by-name/genshi { };

  gensim = callPackage ./non-by-name/gensim { };

  genson = callPackage ./non-by-name/genson { };

  gentools = callPackage ./non-by-name/gentools { };

  genzshcomp = callPackage ./non-by-name/genzshcomp { };

  geoalchemy2 = callPackage ./non-by-name/geoalchemy2 { };

  geoarrow-c = callPackage ./non-by-name/geoarrow-c { };

  geoarrow-pandas = callPackage ./non-by-name/geoarrow-pandas { };

  geoarrow-pyarrow = callPackage ./non-by-name/geoarrow-pyarrow { };

  inherit (callPackage ./non-by-name/geoarrow-rust { })
    geoarrow-rust-core
    geoarrow-rust-io
    ;

  geoarrow-types = callPackage ./non-by-name/geoarrow-types { };

  geocachingapi = callPackage ./non-by-name/geocachingapi { };

  geocoder = callPackage ./non-by-name/geocoder { };

  geodatasets = callPackage ./non-by-name/geodatasets { };

  geographiclib = callPackage ./non-by-name/geographiclib { };

  geoip = callPackage ./non-by-name/geoip { libgeoip = pkgs.geoip; };

  geoip2 = callPackage ./non-by-name/geoip2 { };

  geojson = callPackage ./non-by-name/geojson { };

  geojson-client = callPackage ./non-by-name/geojson-client { };

  geojson-pydantic = callPackage ./non-by-name/geojson-pydantic { };

  geomet = callPackage ./non-by-name/geomet { };

  geometric = callPackage ./non-by-name/geometric { };

  geopandas = callPackage ./non-by-name/geopandas { };

  geoparquet = callPackage ./non-by-name/geoparquet { };

  geopy = callPackage ./non-by-name/geopy { };

  georss-client = callPackage ./non-by-name/georss-client { };

  georss-generic-client = callPackage ./non-by-name/georss-generic-client { };

  georss-ign-sismologia-client = callPackage ./non-by-name/georss-ign-sismologia-client { };

  georss-ingv-centro-nazionale-terremoti-client =
    callPackage ./non-by-name/georss-ingv-centro-nazionale-terremoti-client
      { };

  georss-nrcan-earthquakes-client = callPackage ./non-by-name/georss-nrcan-earthquakes-client { };

  georss-qld-bushfire-alert-client = callPackage ./non-by-name/georss-qld-bushfire-alert-client { };

  georss-tfs-incidents-client = callPackage ./non-by-name/georss-tfs-incidents-client { };

  georss-wa-dfes-client = callPackage ./non-by-name/georss-wa-dfes-client { };

  geotorch = callPackage ./non-by-name/geotorch { };

  gepa = callPackage ./non-by-name/gepa { };

  gerbonara = callPackage ./non-by-name/gerbonara { };

  get-video-properties = callPackage ./non-by-name/get-video-properties { };

  getch = callPackage ./non-by-name/getch { };

  getjump = callPackage ./non-by-name/getjump { };

  getkey = callPackage ./non-by-name/getkey { };

  getmac = callPackage ./non-by-name/getmac { };

  gevent = callPackage ./non-by-name/gevent { };

  gevent-eventemitter = callPackage ./non-by-name/gevent-eventemitter { };

  gevent-socketio = callPackage ./non-by-name/gevent-socketio { };

  gevent-websocket = callPackage ./non-by-name/gevent-websocket { };

  geventhttpclient = callPackage ./non-by-name/geventhttpclient { };

  gfal2-python = callPackage ./non-by-name/gfal2-python { };

  gfal2-util = callPackage ./non-by-name/gfal2-util { inherit (pkgs) xrootd; };

  gflags = callPackage ./non-by-name/gflags { };

  gflanguages = callPackage ./non-by-name/gflanguages { };

  gfmetadata = callPackage ./non-by-name/gfmetadata { };

  gfsubsets = callPackage ./non-by-name/gfsubsets { };

  gftools = callPackage ./non-by-name/gftools { };

  ggml-python = callPackage ./non-by-name/ggml-python { };

  gguf = callPackage ./non-by-name/gguf { };

  ghapi = callPackage ./non-by-name/ghapi { };

  ghdiff = callPackage ./non-by-name/ghdiff { };

  ghmap = callPackage ./non-by-name/ghmap { };

  ghome-foyer-api = callPackage ./non-by-name/ghome-foyer-api { };

  ghostscript = callPackage ./non-by-name/ghostscript { };

  ghp-import = callPackage ./non-by-name/ghp-import { };

  ghrepo-stats = callPackage ./non-by-name/ghrepo-stats { };

  gibberish-detector = callPackage ./non-by-name/gibberish-detector { };

  gidgethub = callPackage ./non-by-name/gidgethub { };

  gilknocker = callPackage ./non-by-name/gilknocker { };

  gin-config = callPackage ./non-by-name/gin-config { };

  gios = callPackage ./non-by-name/gios { };

  gipc = callPackage ./non-by-name/gipc { };

  git-annex-adapter = callPackage ./non-by-name/git-annex-adapter { };

  git-dummy = callPackage ./non-by-name/git-dummy { };

  git-filter-repo = callPackage ./non-by-name/git-filter-repo { };

  git-find-repos = callPackage ./non-by-name/git-find-repos { };

  git-revise = callPackage ./non-by-name/git-revise { };

  git-sweep = callPackage ./non-by-name/git-sweep { };

  git-url-parse = callPackage ./non-by-name/git-url-parse { };

  git-versioner = callPackage ./non-by-name/git-versioner { };

  gitdb = callPackage ./non-by-name/gitdb { };

  github-to-sqlite = callPackage ./non-by-name/github-to-sqlite { };

  github-webhook = callPackage ./non-by-name/github-webhook { };

  github3-py = callPackage ./non-by-name/github3-py { };

  githubkit = callPackage ./non-by-name/githubkit { };

  gitignore-parser = callPackage ./non-by-name/gitignore-parser { };

  gitingest = callPackage ./non-by-name/gitingest { };

  gitlike-commands = callPackage ./non-by-name/gitlike-commands { };

  gitpython = callPackage ./non-by-name/gitpython { };

  giturlparse = callPackage ./non-by-name/giturlparse { };

  glad = callPackage ./non-by-name/glad { };

  glad2 = callPackage ./non-by-name/glad2 { };

  glances-api = callPackage ./non-by-name/glances-api { };

  glcontext = callPackage ./non-by-name/glcontext { };

  glean-parser = callPackage ./non-by-name/glean-parser { };

  glean-sdk = callPackage ./non-by-name/glean-sdk { };

  glfw = callPackage ./non-by-name/glfw { };

  gliner = callPackage ./non-by-name/gliner { };

  glob2 = callPackage ./non-by-name/glob2 { };

  globus-sdk = callPackage ./non-by-name/globus-sdk { };

  glocaltokens = callPackage ./non-by-name/glocaltokens { };

  glom = callPackage ./non-by-name/glom { };

  glueviz = callPackage ./non-by-name/glueviz { };

  gluonts = callPackage ./non-by-name/gluonts { };

  glymur = callPackage ./non-by-name/glymur { };

  glyphsets = callPackage ./non-by-name/glyphsets { };

  glyphslib = callPackage ./non-by-name/glyphslib { };

  glyphtools = callPackage ./non-by-name/glyphtools { };

  gmpy = callPackage ./non-by-name/gmpy { };

  gmpy2 = callPackage ./non-by-name/gmpy2 { };

  gmqtt = callPackage ./non-by-name/gmqtt { };

  gmsh = toPythonModule (
    pkgs.gmsh.override {
      python3Packages = self;
      enablePython = true;
    }
  );

  gntp = callPackage ./non-by-name/gntp { };

  gnucash = toPythonModule (
    pkgs.gnucash.override {
      python3 = python;
    }
  );

  gnureadline = callPackage ./non-by-name/gnureadline { };

  go2rtc-client = callPackage ./non-by-name/go2rtc-client { };

  goalzero = callPackage ./non-by-name/goalzero { };

  gocardless-pro = callPackage ./non-by-name/gocardless-pro { };

  goocalendar = callPackage ./non-by-name/goocalendar { };

  goodwe = callPackage ./non-by-name/goodwe { };

  google = callPackage ./non-by-name/google { };

  google-ai-generativelanguage = callPackage ./non-by-name/google-ai-generativelanguage { };

  google-air-quality-api = callPackage ./non-by-name/google-air-quality-api { };

  google-api-core = callPackage ./non-by-name/google-api-core { };

  google-api-python-client = callPackage ./non-by-name/google-api-python-client { };

  google-auth = callPackage ./non-by-name/google-auth { };

  google-auth-httplib2 = callPackage ./non-by-name/google-auth-httplib2 { };

  google-auth-oauthlib = callPackage ./non-by-name/google-auth-oauthlib { };

  google-cloud-access-context-manager =
    callPackage ./non-by-name/google-cloud-access-context-manager
      { };

  google-cloud-appengine-logging = callPackage ./non-by-name/google-cloud-appengine-logging { };

  google-cloud-artifact-registry = callPackage ./non-by-name/google-cloud-artifact-registry { };

  google-cloud-asset = callPackage ./non-by-name/google-cloud-asset { };

  google-cloud-audit-log = callPackage ./non-by-name/google-cloud-audit-log { };

  google-cloud-automl = callPackage ./non-by-name/google-cloud-automl { };

  google-cloud-bigquery = callPackage ./non-by-name/google-cloud-bigquery { };

  google-cloud-bigquery-datatransfer =
    callPackage ./non-by-name/google-cloud-bigquery-datatransfer
      { };

  google-cloud-bigquery-logging = callPackage ./non-by-name/google-cloud-bigquery-logging { };

  google-cloud-bigquery-storage = callPackage ./non-by-name/google-cloud-bigquery-storage { };

  google-cloud-bigtable = callPackage ./non-by-name/google-cloud-bigtable { };

  google-cloud-compute = callPackage ./non-by-name/google-cloud-compute { };

  google-cloud-container = callPackage ./non-by-name/google-cloud-container { };

  google-cloud-core = callPackage ./non-by-name/google-cloud-core { };

  google-cloud-datacatalog = callPackage ./non-by-name/google-cloud-datacatalog { };

  google-cloud-dataproc = callPackage ./non-by-name/google-cloud-dataproc { };

  google-cloud-datastore = callPackage ./non-by-name/google-cloud-datastore { };

  google-cloud-dlp = callPackage ./non-by-name/google-cloud-dlp { };

  google-cloud-dns = callPackage ./non-by-name/google-cloud-dns { };

  google-cloud-error-reporting = callPackage ./non-by-name/google-cloud-error-reporting { };

  google-cloud-firestore = callPackage ./non-by-name/google-cloud-firestore { };

  google-cloud-iam = callPackage ./non-by-name/google-cloud-iam { };

  google-cloud-iam-logging = callPackage ./non-by-name/google-cloud-iam-logging { };

  google-cloud-kms = callPackage ./non-by-name/google-cloud-kms { };

  google-cloud-language = callPackage ./non-by-name/google-cloud-language { };

  google-cloud-logging = callPackage ./non-by-name/google-cloud-logging { };

  google-cloud-monitoring = callPackage ./non-by-name/google-cloud-monitoring { };

  google-cloud-netapp = callPackage ./non-by-name/google-cloud-netapp { };

  google-cloud-network-connectivity = callPackage ./non-by-name/google-cloud-network-connectivity { };

  google-cloud-org-policy = callPackage ./non-by-name/google-cloud-org-policy { };

  google-cloud-os-config = callPackage ./non-by-name/google-cloud-os-config { };

  google-cloud-pubsub = callPackage ./non-by-name/google-cloud-pubsub { };

  google-cloud-redis = callPackage ./non-by-name/google-cloud-redis { };

  google-cloud-resource-manager = callPackage ./non-by-name/google-cloud-resource-manager { };

  google-cloud-run = callPackage ./non-by-name/google-cloud-run { };

  google-cloud-runtimeconfig = callPackage ./non-by-name/google-cloud-runtimeconfig { };

  google-cloud-secret-manager = callPackage ./non-by-name/google-cloud-secret-manager { };

  google-cloud-securitycenter = callPackage ./non-by-name/google-cloud-securitycenter { };

  google-cloud-shell = callPackage ./non-by-name/google-cloud-shell { };

  google-cloud-spanner = callPackage ./non-by-name/google-cloud-spanner { };

  google-cloud-speech = callPackage ./non-by-name/google-cloud-speech { };

  google-cloud-storage = callPackage ./non-by-name/google-cloud-storage { };

  google-cloud-storage-control = callPackage ./non-by-name/google-cloud-storage-control { };

  google-cloud-tasks = callPackage ./non-by-name/google-cloud-tasks { };

  google-cloud-testutils = callPackage ./non-by-name/google-cloud-testutils { };

  google-cloud-texttospeech = callPackage ./non-by-name/google-cloud-texttospeech { };

  google-cloud-trace = callPackage ./non-by-name/google-cloud-trace { };

  google-cloud-translate = callPackage ./non-by-name/google-cloud-translate { };

  google-cloud-videointelligence = callPackage ./non-by-name/google-cloud-videointelligence { };

  google-cloud-vision = callPackage ./non-by-name/google-cloud-vision { };

  google-cloud-vpc-access = callPackage ./non-by-name/google-cloud-vpc-access { };

  google-cloud-webrisk = callPackage ./non-by-name/google-cloud-webrisk { };

  google-cloud-websecurityscanner = callPackage ./non-by-name/google-cloud-websecurityscanner { };

  google-cloud-workflows = callPackage ./non-by-name/google-cloud-workflows { };

  google-cloud-workstations = callPackage ./non-by-name/google-cloud-workstations { };

  google-compute-engine = callPackage ./non-by-name/google-compute-engine { };

  google-crc32c = callPackage ./non-by-name/google-crc32c { inherit (pkgs) crc32c; };

  google-genai = callPackage ./non-by-name/google-genai { };

  google-generativeai = callPackage ./non-by-name/google-generativeai { };

  google-geo-type = callPackage ./non-by-name/google-geo-type { };

  google-health-api = callPackage ./non-by-name/google-health-api { };

  google-i18n-address = callPackage ./non-by-name/google-i18n-address { };

  google-maps-routing = callPackage ./non-by-name/google-maps-routing { };

  google-nest-sdm = callPackage ./non-by-name/google-nest-sdm { };

  google-pasta = callPackage ./non-by-name/google-pasta { };

  google-photos-library-api = callPackage ./non-by-name/google-photos-library-api { };

  google-play-scraper = callPackage ./non-by-name/google-play-scraper { };

  google-re2 = callPackage ./non-by-name/google-re2 { };

  google-resumable-media = callPackage ./non-by-name/google-resumable-media { };

  google-search-results = callPackage ./non-by-name/google-search-results { };

  googleapis-common-protos = callPackage ./non-by-name/googleapis-common-protos { };

  googlemaps = callPackage ./non-by-name/googlemaps { };

  googletrans = callPackage ./non-by-name/googletrans { };

  googlewifiapi = callPackage ./non-by-name/googlewifiapi { };

  gophish = callPackage ./non-by-name/gophish { };

  gorilla = callPackage ./non-by-name/gorilla { };

  goslide-api = callPackage ./non-by-name/goslide-api { };

  gotailwind = callPackage ./non-by-name/gotailwind { };

  gotenberg-client = callPackage ./non-by-name/gotenberg-client { };

  gotify = callPackage ./non-by-name/gotify { };

  govee-ble = callPackage ./non-by-name/govee-ble { };

  govee-led-wez = callPackage ./non-by-name/govee-led-wez { };

  govee-local-api = callPackage ./non-by-name/govee-local-api { };

  goveelights = callPackage ./non-by-name/goveelights { };

  gower = callPackage ./non-by-name/gower { };

  gpaw = callPackage ./non-by-name/gpaw {
    inherit (pkgs) libxc;
  };

  gpg = callPackage ./non-by-name/gpg { inherit (pkgs) gpgme; };

  gphoto2 = callPackage ./non-by-name/gphoto2 { };

  gpib-ctypes = callPackage ./non-by-name/gpib-ctypes { };

  gpiod = callPackage ./non-by-name/gpiod { inherit (pkgs) libgpiod; };

  gpiodevice = callPackage ./non-by-name/gpiodevice { };

  gpiozero = callPackage ./non-by-name/gpiozero { };

  gprof2dot = callPackage ./non-by-name/gprof2dot { inherit (pkgs) graphviz; };

  gps3 = callPackage ./non-by-name/gps3 { };

  gpsoauth = callPackage ./non-by-name/gpsoauth { };

  gpt-2-simple = callPackage ./non-by-name/gpt-2-simple { };

  gptcache = callPackage ./non-by-name/gptcache { };

  gpuctypes = callPackage ./non-by-name/gpuctypes { };

  gpurir = callPackage ./non-by-name/gpurir { };

  gpustat = callPackage ./non-by-name/gpustat { };

  gputil = callPackage ./non-by-name/gputil { };

  gpxpy = callPackage ./non-by-name/gpxpy { };

  gpytorch = callPackage ./non-by-name/gpytorch { };

  gql = callPackage ./non-by-name/gql { };

  grad-cam = callPackage ./non-by-name/grad-cam { };

  gradient-statsd = callPackage ./non-by-name/gradient-statsd { };

  gradio = callPackage ./non-by-name/gradio { };

  gradio-client = callPackage ./non-by-name/gradio/client.nix {
    inherit (pkgs) jq;
  };

  gradio-pdf = callPackage ./non-by-name/gradio-pdf { };

  grafanalib = callPackage ./non-by-name/grafanalib/default.nix { };

  grain = callPackage ./non-by-name/grain { };

  grammalecte = callPackage ./non-by-name/grammalecte { };

  grandalf = callPackage ./non-by-name/grandalf { };

  grandstream-home-api = callPackage ./non-by-name/grandstream-home-api { };

  granian = callPackage ./non-by-name/granian { };

  graph-tool = callPackage ./non-by-name/graph-tool { inherit (pkgs) cgal; };

  graphemeu = callPackage ./non-by-name/graphemeu { };

  graphene = callPackage ./non-by-name/graphene { };

  graphene-django = callPackage ./non-by-name/graphene-django { };

  graphite-web = callPackage ./non-by-name/graphite-web { };

  graphlib-backport = callPackage ./non-by-name/graphlib-backport { };

  graphql-core = callPackage ./non-by-name/graphql-core { };

  graphql-relay = callPackage ./non-by-name/graphql-relay { };

  graphql-server-core = callPackage ./non-by-name/graphql-server-core { };

  graphql-subscription-manager = callPackage ./non-by-name/graphql-subscription-manager { };

  graphqlclient = callPackage ./non-by-name/graphqlclient { };

  graphrag = callPackage ./non-by-name/graphrag { };

  graphtage = callPackage ./non-by-name/graphtage { };

  graphviz = callPackage ./non-by-name/graphviz { };

  grappelli-safe = callPackage ./non-by-name/grappelli-safe { };

  graspologic = callPackage ./non-by-name/graspologic { };

  graspologic-native = callPackage ./non-by-name/graspologic-native { };

  great-expectations = callPackage ./non-by-name/great-expectations { };

  great-tables = callPackage ./non-by-name/great-tables { };

  greatfet = callPackage ./non-by-name/greatfet { };

  greeclimate = callPackage ./non-by-name/greeclimate { };

  greek-accentuation = callPackage ./non-by-name/greek-accentuation { };

  green = callPackage ./non-by-name/green { };

  greenback = callPackage ./non-by-name/greenback { };

  greencell-client = callPackage ./non-by-name/greencell-client { };

  greeneye-monitor = callPackage ./non-by-name/greeneye-monitor { };

  # built-in for pypi
  greenlet = if isPyPy then null else callPackage ./non-by-name/greenlet { };

  greenplanet-energy-api = callPackage ./non-by-name/greenplanet-energy-api { };

  gremlinpython = callPackage ./non-by-name/gremlinpython { };

  grep-ast = callPackage ./non-by-name/grep-ast { };

  grequests = callPackage ./non-by-name/grequests { };

  greynoise = callPackage ./non-by-name/greynoise { };

  gridnet = callPackage ./non-by-name/gridnet { };

  griffe = callPackage ./non-by-name/griffe { };

  griffecli = callPackage ./non-by-name/griffecli { };

  griffelib = callPackage ./non-by-name/griffelib { };

  grip = callPackage ./non-by-name/grip { };

  groestlcoin-hash = callPackage ./non-by-name/groestlcoin-hash { };

  groovy = callPackage ./non-by-name/groovy { };

  groq = callPackage ./non-by-name/groq { };

  growattserver = callPackage ./non-by-name/growattserver { };

  grpc-google-iam-v1 = callPackage ./non-by-name/grpc-google-iam-v1 { };

  grpc-interceptor = callPackage ./non-by-name/grpc-interceptor { };

  grpcio = callPackage ./non-by-name/grpcio { };

  grpcio-channelz = callPackage ./non-by-name/grpcio-channelz { };

  grpcio-gcp = callPackage ./non-by-name/grpcio-gcp { };

  grpcio-health-checking = callPackage ./non-by-name/grpcio-health-checking { };

  grpcio-reflection = callPackage ./non-by-name/grpcio-reflection { };

  grpcio-status = callPackage ./non-by-name/grpcio-status { };

  grpcio-testing = callPackage ./non-by-name/grpcio-testing { };

  grpcio-tools = callPackage ./non-by-name/grpcio-tools { };

  grpclib = callPackage ./non-by-name/grpclib { };

  gruut = callPackage ./non-by-name/gruut { };

  gruut-ipa = callPackage ./non-by-name/gruut-ipa { inherit (pkgs) espeak; };

  gsd = callPackage ./non-by-name/gsd { };

  gsm0338 = callPackage ./non-by-name/gsm0338 { };

  gspread = callPackage ./non-by-name/gspread { };

  gssapi = callPackage ./non-by-name/gssapi {
    krb5-c = pkgs.krb5;
  };

  gst-python = callPackage ./non-by-name/gst-python {
    # inherit (pkgs) meson won't work because it won't be spliced
    inherit (pkgs.buildPackages) meson;
  };

  gstools = callPackage ./non-by-name/gstools { };

  gstools-cython = callPackage ./non-by-name/gstools-cython { };

  gtfs-realtime-bindings = callPackage ./non-by-name/gtfs-realtime-bindings { };

  gtfs-station-stop = callPackage ./non-by-name/gtfs-station-stop { };

  gto = callPackage ./non-by-name/gto { };

  gtts = callPackage ./non-by-name/gtts { };

  gtts-token = callPackage ./non-by-name/gtts-token { };

  gudhi = callPackage ./non-by-name/gudhi { inherit (pkgs) cgal; };

  guessit = callPackage ./non-by-name/guessit { };

  guestfs = toPythonModule (
    pkgs.libguestfs.override {
      python3 = python;
    }
  );

  guidance = callPackage ./non-by-name/guidance { };

  guidance-stitch = callPackage ./non-by-name/guidance-stitch { };

  guidata = callPackage ./non-by-name/guidata { };

  gumath = callPackage ./non-by-name/gumath { };

  gunicorn = callPackage ./non-by-name/gunicorn { };

  guntamatic = callPackage ./non-by-name/guntamatic { };

  guppy3 = callPackage ./non-by-name/guppy3 { };

  gurobipy = callPackage ./non-by-name/gurobipy { };

  guzzle-sphinx-theme = callPackage ./non-by-name/guzzle-sphinx-theme { };

  gviz-api = callPackage ./non-by-name/gviz-api { };

  gvm-tools = callPackage ./non-by-name/gvm-tools { };

  gwcs = callPackage ./non-by-name/gwcs { };

  gym = callPackage ./non-by-name/gym { };

  gym-notices = callPackage ./non-by-name/gym-notices { };

  gymnasium = callPackage ./non-by-name/gymnasium { };

  gyp = callPackage ./non-by-name/gyp { };

  gz-math = callPackage ./non-by-name/gz-math { };

  h11 = callPackage ./non-by-name/h11 { };

  h2 = callPackage ./non-by-name/h2 { };

  h3 = callPackage ./non-by-name/h3 { h3 = pkgs.h3_4; };

  h5io = callPackage ./non-by-name/h5io { };

  h5netcdf = callPackage ./non-by-name/h5netcdf { };

  h5py = callPackage ./non-by-name/h5py { };

  h5py-mpi = self.h5py.override { hdf5 = pkgs.hdf5-mpi; };

  ha-ffmpeg = callPackage ./non-by-name/ha-ffmpeg { };

  ha-garmin = callPackage ./non-by-name/ha-garmin { };

  ha-iotawattpy = callPackage ./non-by-name/ha-iotawattpy { };

  ha-mcp = callPackage ./non-by-name/ha-mcp { };

  ha-mqtt-discoverable = callPackage ./non-by-name/ha-mqtt-discoverable { };

  ha-philipsjs = callPackage ./non-by-name/ha-philipsjs { };

  ha-silabs-firmware-client = callPackage ./non-by-name/ha-silabs-firmware-client { };

  ha-xthings-cloud = callPackage ./non-by-name/ha-xthings-cloud { };

  habanero = callPackage ./non-by-name/habanero { };

  habiticalib = callPackage ./non-by-name/habiticalib { };

  habitipy = callPackage ./non-by-name/habitipy { };

  habluetooth = callPackage ./non-by-name/habluetooth { };

  hachoir = callPackage ./non-by-name/hachoir { };

  hacking = callPackage ./non-by-name/hacking { };

  haishoku = callPackage ./non-by-name/haishoku { };

  hakuin = callPackage ./non-by-name/hakuin { };

  halide =
    toPythonModule
      (pkgs.halide.override {
        pythonSupport = true;
        python3Packages = self;
      }).lib;

  halo = callPackage ./non-by-name/halo { };

  halohome = callPackage ./non-by-name/halohome { };

  handout = callPackage ./non-by-name/handout { };

  handy-archives = callPackage ./non-by-name/handy-archives { };

  hankel = callPackage ./non-by-name/hankel { };

  hanna-cloud = callPackage ./non-by-name/hanna-cloud { };

  hanzidentifier = callPackage ./non-by-name/hanzidentifier { };

  hap-python = callPackage ./non-by-name/hap-python { };

  harbor-python = callPackage ./non-by-name/harbor-python { };

  harlequin-bigquery = callPackage ./non-by-name/harlequin-bigquery { };

  harlequin-odbc = callPackage ./non-by-name/harlequin-odbc { };

  harlequin-postgres = callPackage ./non-by-name/harlequin-postgres { };

  hass-client = callPackage ./non-by-name/hass-client { };

  hass-nabucasa = callPackage ./non-by-name/hass-nabucasa { };

  hass-splunk = callPackage ./non-by-name/hass-splunk { };

  hassil = callPackage ./non-by-name/hassil { };

  hatasm = callPackage ./non-by-name/hatasm { };

  hatasmota = callPackage ./non-by-name/hatasmota { };

  hatch = callPackage ./non-by-name/hatch/default.nix { };

  hatch-argparse-manpage = callPackage ./non-by-name/hatch-argparse-manpage { };

  hatch-autorun = callPackage ./non-by-name/hatch-autorun { };

  hatch-babel = callPackage ./non-by-name/hatch-babel { };

  hatch-build-scripts = callPackage ./non-by-name/hatch-build-scripts { };

  hatch-deps-selector = callPackage ./non-by-name/hatch-deps-selector { };

  hatch-docstring-description = callPackage ./non-by-name/hatch-docstring-description { };

  hatch-fancy-pypi-readme = callPackage ./non-by-name/hatch-fancy-pypi-readme { };

  hatch-gettext = callPackage ./non-by-name/hatch-gettext { };

  hatch-jupyter-builder = callPackage ./non-by-name/hatch-jupyter-builder { };

  hatch-min-requirements = callPackage ./non-by-name/hatch-min-requirements { };

  hatch-mypyc = callPackage ./non-by-name/hatch-mypyc { };

  hatch-nodejs-version = callPackage ./non-by-name/hatch-nodejs-version { };

  hatch-odoo = callPackage ./non-by-name/hatch-odoo { };

  hatch-regex-commit = callPackage ./non-by-name/hatch-regex-commit { };

  hatch-requirements-txt = callPackage ./non-by-name/hatch-requirements-txt { };

  hatch-rs = callPackage ./non-by-name/hatch-rs { };

  hatch-sphinx = callPackage ./non-by-name/hatch-sphinx { };

  hatch-tryton = callPackage ./non-by-name/hatch-tryton { };

  hatch-vcs = callPackage ./non-by-name/hatch-vcs { };

  hatchling = callPackage ./non-by-name/hatchling { };

  haveniaq = callPackage ./non-by-name/haveniaq { };

  haversine = callPackage ./non-by-name/haversine { };

  hawkauthlib = callPackage ./non-by-name/hawkauthlib { };

  hawkmoth = callPackage ./non-by-name/hawkmoth { };

  haystack-ai = callPackage ./non-by-name/haystack-ai { };

  hcloud = callPackage ./non-by-name/hcloud { };

  hcs-utils = callPackage ./non-by-name/hcs-utils { };

  hdate = callPackage ./non-by-name/hdate { };

  hdbscan = callPackage ./non-by-name/hdbscan { };

  hdf5plugin = callPackage ./non-by-name/hdf5plugin {
    inherit (pkgs) zstd lz4;
  };

  hdfs = callPackage ./non-by-name/hdfs { };

  hdfury = callPackage ./non-by-name/hdfury { };

  hdmedians = callPackage ./non-by-name/hdmedians { };

  headerparser = callPackage ./non-by-name/headerparser { };

  heapdict = callPackage ./non-by-name/heapdict { };

  heatmiserv3 = callPackage ./non-by-name/heatmiserv3 { };

  heatshrink2 = callPackage ./non-by-name/heatshrink2 { };

  heatzypy = callPackage ./non-by-name/heatzypy { };

  hebg = callPackage ./non-by-name/hebg { };

  hebi-py = callPackage ./non-by-name/hebi-py { };

  hegel-ip-client = callPackage ./non-by-name/hegel-ip-client { };

  helion = callPackage ./non-by-name/helion { };

  helium = callPackage ./non-by-name/helium { };

  help2man = callPackage ./non-by-name/help2man { };

  helpdev = callPackage ./non-by-name/helpdev { };

  helper = callPackage ./non-by-name/helper { };

  hepdata-converter = callPackage ./non-by-name/hepdata-converter { };

  hepdata-lib = callPackage ./non-by-name/hepdata-lib { };

  hepdata-validator = callPackage ./non-by-name/hepdata-validator { };

  hepmc3 = toPythonModule (pkgs.hepmc3.override { inherit python; });

  hepunits = callPackage ./non-by-name/hepunits { };

  here-routing = callPackage ./non-by-name/here-routing { };

  here-transit = callPackage ./non-by-name/here-transit { };

  herepy = callPackage ./non-by-name/herepy { };

  heretic-llm = callPackage ./non-by-name/heretic-llm { };

  hetzner = callPackage ./non-by-name/hetzner { };

  heudiconv = callPackage ./non-by-name/heudiconv { };

  hexbytes = callPackage ./non-by-name/hexbytes { };

  hexdump = callPackage ./non-by-name/hexdump { };

  hf-gradio = callPackage ./non-by-name/hf-gradio { };

  hf-transfer = callPackage ./non-by-name/hf-transfer { };

  hf-xet = callPackage ./non-by-name/hf-xet { };

  hfst = callPackage ./non-by-name/hfst { };

  hg-evolve = callPackage ./non-by-name/hg-evolve { };

  hg-git = callPackage ./non-by-name/hg-git { };

  hgvs = callPackage ./non-by-name/hgvs { };

  hibpwned = callPackage ./non-by-name/hibpwned { };

  hickle = callPackage ./non-by-name/hickle { };

  hid = callPackage ./non-by-name/hid { inherit (pkgs) hidapi; };

  hid-parser = callPackage ./non-by-name/hid-parser { };

  hidapi = callPackage ./non-by-name/hidapi { inherit (pkgs) hidapi udev; };

  hier-config = callPackage ./non-by-name/hier-config { };

  hieroglyph = callPackage ./non-by-name/hieroglyph { };

  highctidh = callPackage ./non-by-name/highctidh { };

  highdicom = callPackage ./non-by-name/highdicom { };

  highered = callPackage ./non-by-name/highered { };

  highspy = callPackage ./non-by-name/highspy { };

  hightime = callPackage ./non-by-name/hightime { };

  hijridate = callPackage ./non-by-name/hijridate { };

  hikari = callPackage ./non-by-name/hikari { };

  hikari-crescent = callPackage ./non-by-name/hikari-crescent { };

  hikari-lightbulb = callPackage ./non-by-name/hikari-lightbulb { };

  hikvision = callPackage ./non-by-name/hikvision { };

  hiredis = callPackage ./non-by-name/hiredis { };

  hiro = callPackage ./non-by-name/hiro { };

  hishel = callPackage ./non-by-name/hishel { };

  hist = callPackage ./non-by-name/hist { };

  histoprint = callPackage ./non-by-name/histoprint { };

  hive-metastore-client = callPackage ./non-by-name/hive-metastore-client { };

  hiyapyco = callPackage ./non-by-name/hiyapyco { };

  hjson = callPackage ./non-by-name/hjson { };

  hkavr = callPackage ./non-by-name/hkavr { };

  hko = callPackage ./non-by-name/hko { };

  hledger-utils = callPackage ./non-by-name/hledger-utils { };

  hlk-sw16 = callPackage ./non-by-name/hlk-sw16 { };

  hmmlearn = callPackage ./non-by-name/hmmlearn { };

  hnswlib = callPackage ./non-by-name/hnswlib { inherit (pkgs) hnswlib; };

  hocr-tools = callPackage ./non-by-name/hocr-tools { };

  hole = callPackage ./non-by-name/hole { };

  holidays = callPackage ./non-by-name/holidays { };

  holoviews = callPackage ./non-by-name/holoviews { };

  home-assistant-bluetooth = callPackage ./non-by-name/home-assistant-bluetooth { };

  home-assistant-chip-clusters = callPackage ./non-by-name/home-assistant-chip-clusters { };

  home-assistant-chip-core = callPackage ./non-by-name/home-assistant-chip-core { };

  home-assistant-chip-wheels = toPythonModule (
    callPackage ./non-by-name/home-assistant-chip-wheels { }
  );

  home-assistant-datasets = callPackage ./non-by-name/home-assistant-datasets { };

  home-connect-async = callPackage ./non-by-name/home-connect-async { };

  homeconnect = callPackage ./non-by-name/homeconnect { };

  homekit-audio-proxy = callPackage ./non-by-name/homekit-audio-proxy { };

  homelink-integration-api = callPackage ./non-by-name/homelink-integration-api { };

  homematicip = callPackage ./non-by-name/homematicip { };

  homevolt = callPackage ./non-by-name/homevolt { };

  homf = callPackage ./non-by-name/homf { };

  hoomd-blue = callPackage ./non-by-name/hoomd-blue { };

  hopcroftkarp = callPackage ./non-by-name/hopcroftkarp { };

  hoptorch = callPackage ./non-by-name/hoptorch { };

  horimote = callPackage ./non-by-name/horimote { };

  horizon-eda = callPackage ./non-by-name/horizon-eda { inherit (pkgs) horizon-eda; };

  housekeeping = callPackage ./non-by-name/housekeeping { };

  hpack = callPackage ./non-by-name/hpack { };

  hpccm = callPackage ./non-by-name/hpccm { };

  hs-dbus-signature = callPackage ./non-by-name/hs-dbus-signature { };

  hsaudiotag3k = callPackage ./non-by-name/hsaudiotag3k { };

  hsh = callPackage ./non-by-name/hsh { };

  hsluv = callPackage ./non-by-name/hsluv { };

  hstspreload = callPackage ./non-by-name/hstspreload { };

  html-sanitizer = callPackage ./non-by-name/html-sanitizer { };

  html-table-parser-python3 = callPackage ./non-by-name/html-table-parser-python3 { };

  html-tag-names = callPackage ./non-by-name/html-tag-names { };

  html-text = callPackage ./non-by-name/html-text { };

  html-void-elements = callPackage ./non-by-name/html-void-elements { };

  html2image = callPackage ./non-by-name/html2image { };

  html2pdf4doc = callPackage ./non-by-name/html2pdf4doc { };

  html2text = callPackage ./non-by-name/html2text { };

  html5-parser = callPackage ./non-by-name/html5-parser { };

  html5lib = callPackage ./non-by-name/html5lib { };

  html5tagger = callPackage ./non-by-name/html5tagger { };

  htmldate = callPackage ./non-by-name/htmldate { };

  htmlgen = callPackage ./non-by-name/htmlgen { };

  htmllistparse = callPackage ./non-by-name/htmllistparse { };

  htmlmin = callPackage ./non-by-name/htmlmin { };

  htmltools = callPackage ./non-by-name/htmltools { };

  htseq = callPackage ./non-by-name/htseq { };

  httmock = callPackage ./non-by-name/httmock { };

  http-ece = callPackage ./non-by-name/http-ece { };

  http-message-signatures = callPackage ./non-by-name/http-message-signatures { };

  http-parser = callPackage ./non-by-name/http-parser { };

  http-sf = callPackage ./non-by-name/http-sf { };

  http-sfv = callPackage ./non-by-name/http-sfv { };

  http-snapshot = callPackage ./non-by-name/http-snapshot { };

  http-tools = callPackage ./non-by-name/http-tools { };

  httpagentparser = callPackage ./non-by-name/httpagentparser { };

  httpauth = callPackage ./non-by-name/httpauth { };

  httpbin = callPackage ./non-by-name/httpbin { };

  httpcore = callPackage ./non-by-name/httpcore { };

  httpcore2 = callPackage ./non-by-name/httpcore2 { };

  httpie = callPackage ./non-by-name/httpie { };

  httpie-ntlm = callPackage ./non-by-name/httpie-ntlm { };

  httplib2 = callPackage ./non-by-name/httplib2 { };

  httplib2shim = callPackage ./non-by-name/httplib2shim { };

  httpretty = callPackage ./non-by-name/httpretty { };

  httpserver = callPackage ./non-by-name/httpserver { };

  httpsig = callPackage ./non-by-name/httpsig { };

  httptools = callPackage ./non-by-name/httptools { };

  httpx = callPackage ./non-by-name/httpx { };

  httpx-aiohttp = callPackage ./non-by-name/httpx-aiohttp { };

  httpx-auth = callPackage ./non-by-name/httpx-auth { };

  httpx-curl-cffi = callPackage ./non-by-name/httpx-curl-cffi { };

  httpx-ntlm = callPackage ./non-by-name/httpx-ntlm { };

  httpx-oauth = callPackage ./non-by-name/httpx-oauth { };

  httpx-retries = callPackage ./non-by-name/httpx-retries { };

  httpx-socks = callPackage ./non-by-name/httpx-socks { };

  httpx-sse = callPackage ./non-by-name/httpx-sse { };

  httpx-ws = callPackage ./non-by-name/httpx-ws { };

  httpx2 = callPackage ./non-by-name/httpx2 { };

  httpx2-pytest = callPackage ./non-by-name/httpx2-pytest { };

  httpxthrottlecache = callPackage ./non-by-name/httpxthrottlecache { };

  huawei-lte-api = callPackage ./non-by-name/huawei-lte-api { };

  inherit (callPackage ./non-by-name/huaweicloudsdk { })
    huaweicloudsdkaad
    huaweicloudsdkagentarts
    huaweicloudsdkagentidentity
    huaweicloudsdkantiddos
    huaweicloudsdkaom
    huaweicloudsdkaos
    huaweicloudsdkapig
    huaweicloudsdkapm
    huaweicloudsdkas
    huaweicloudsdkasm
    huaweicloudsdkastrozero
    huaweicloudsdkbcc
    huaweicloudsdkbcs
    huaweicloudsdkbms
    huaweicloudsdkbss
    huaweicloudsdkbssintl
    huaweicloudsdkcae
    huaweicloudsdkcampusgo
    huaweicloudsdkcbh
    huaweicloudsdkcbr
    huaweicloudsdkcbs
    huaweicloudsdkcc
    huaweicloudsdkcce
    huaweicloudsdkccm
    huaweicloudsdkcdm
    huaweicloudsdkcdn
    huaweicloudsdkces
    huaweicloudsdkcfw
    huaweicloudsdkclassroom
    huaweicloudsdkclouddc
    huaweicloudsdkcloudide
    huaweicloudsdkcloudpond
    huaweicloudsdkcloudrtc
    huaweicloudsdkcloudtable
    huaweicloudsdkcloudtest
    huaweicloudsdkcoc
    huaweicloudsdkcodeartsartifact
    huaweicloudsdkcodeartsbuild
    huaweicloudsdkcodeartscheck
    huaweicloudsdkcodeartsdeploy
    huaweicloudsdkcodeartsgovernance
    huaweicloudsdkcodeartside
    huaweicloudsdkcodeartsinspector
    huaweicloudsdkcodeartspipeline
    huaweicloudsdkcodeartsrepo
    huaweicloudsdkcodecraft
    huaweicloudsdkconfig
    huaweicloudsdkcpcs
    huaweicloudsdkcph
    huaweicloudsdkcpts
    huaweicloudsdkcse
    huaweicloudsdkcsms
    huaweicloudsdkcss
    huaweicloudsdkcts
    huaweicloudsdkdas
    huaweicloudsdkdataartsfabric
    huaweicloudsdkdataartsfabricep
    huaweicloudsdkdataartsstudio
    huaweicloudsdkdbss
    huaweicloudsdkdc
    huaweicloudsdkdcc
    huaweicloudsdkdcos
    huaweicloudsdkdcs
    huaweicloudsdkddm
    huaweicloudsdkdds
    huaweicloudsdkdeh
    huaweicloudsdkdevstar
    huaweicloudsdkdgc
    huaweicloudsdkdis
    huaweicloudsdkdlf
    huaweicloudsdkdli
    huaweicloudsdkdns
    huaweicloudsdkdris
    huaweicloudsdkdrs
    huaweicloudsdkdsc
    huaweicloudsdkdwr
    huaweicloudsdkdws
    huaweicloudsdkec
    huaweicloudsdkecs
    huaweicloudsdkedgesec
    huaweicloudsdkeg
    huaweicloudsdkeihealth
    huaweicloudsdkeip
    huaweicloudsdkelb
    huaweicloudsdkeps
    huaweicloudsdker
    huaweicloudsdkesw
    huaweicloudsdkevs
    huaweicloudsdkfrs
    huaweicloudsdkfunctiongraph
    huaweicloudsdkga
    huaweicloudsdkgaussdb
    huaweicloudsdkgaussdbfornosql
    huaweicloudsdkgaussdbforopengauss
    huaweicloudsdkgeip
    huaweicloudsdkges
    huaweicloudsdkgsl
    huaweicloudsdkhilens
    huaweicloudsdkhss
    huaweicloudsdkiam
    huaweicloudsdkiamaccessanalyzer
    huaweicloudsdkidentitycenter
    huaweicloudsdkidentitycenteroidc
    huaweicloudsdkidentitycenterportalapi
    huaweicloudsdkidentitycenterscim
    huaweicloudsdkidentitycenterstore
    huaweicloudsdkidme
    huaweicloudsdkidmeclassicapi
    huaweicloudsdkiec
    huaweicloudsdkief
    huaweicloudsdkimage
    huaweicloudsdkimagesearch
    huaweicloudsdkims
    huaweicloudsdkiotanalytics
    huaweicloudsdkiotda
    huaweicloudsdkiotdm
    huaweicloudsdkiotedge
    huaweicloudsdkivs
    huaweicloudsdkkafka
    huaweicloudsdkkms
    huaweicloudsdkkoomessage
    huaweicloudsdkkps
    huaweicloudsdkkvs
    huaweicloudsdklakeformation
    huaweicloudsdklive
    huaweicloudsdklts
    huaweicloudsdkmapds
    huaweicloudsdkmas
    huaweicloudsdkmastudio
    huaweicloudsdkmeeting
    huaweicloudsdkmetastudio
    huaweicloudsdkmodelarts
    huaweicloudsdkmoderation
    huaweicloudsdkmpc
    huaweicloudsdkmrs
    huaweicloudsdkmsgsms
    huaweicloudsdkmssi
    huaweicloudsdknat
    huaweicloudsdknlp
    huaweicloudsdkobs
    huaweicloudsdkocr
    huaweicloudsdkoctopus
    huaweicloudsdkoms
    huaweicloudsdkoptverse
    huaweicloudsdkorganizations
    huaweicloudsdkorgid
    huaweicloudsdkoroas
    huaweicloudsdkosm
    huaweicloudsdkpangulargemodels
    huaweicloudsdkprojectman
    huaweicloudsdkrabbitmq
    huaweicloudsdkram
    huaweicloudsdkrc
    huaweicloudsdkrds
    huaweicloudsdkres
    huaweicloudsdkrfs
    huaweicloudsdkrgc
    huaweicloudsdkrms
    huaweicloudsdkrocketmq
    huaweicloudsdkroma
    huaweicloudsdksa
    huaweicloudsdkscm
    huaweicloudsdksdrs
    huaweicloudsdksecmaster
    huaweicloudsdkservicestage
    huaweicloudsdksfsturbo
    huaweicloudsdksis
    huaweicloudsdksmn
    huaweicloudsdksmnglobal
    huaweicloudsdksms
    huaweicloudsdksmsapi
    huaweicloudsdksts
    huaweicloudsdkswr
    huaweicloudsdktics
    huaweicloudsdktms
    huaweicloudsdkucs
    huaweicloudsdkugo
    huaweicloudsdkvas
    huaweicloudsdkvcm
    huaweicloudsdkversatile
    huaweicloudsdkvod
    huaweicloudsdkvpc
    huaweicloudsdkvpcep
    huaweicloudsdkvpn
    huaweicloudsdkwaf
    huaweicloudsdkworkspace
    huaweicloudsdkworkspaceapp
    ;

  huaweicloudsdkcore = callPackage ./non-by-name/huaweicloudsdkcore { };

  hueble = callPackage ./non-by-name/hueble { };

  huepy = callPackage ./non-by-name/huepy { };

  huey = callPackage ./non-by-name/huey { };

  huggingface-hub = callPackage ./non-by-name/huggingface-hub { };

  huggingface-hub_0 = callPackage ./non-by-name/huggingface-hub/0.nix { };

  human-readable = callPackage ./non-by-name/human-readable { };

  humanfriendly = callPackage ./non-by-name/humanfriendly { };

  humanize = callPackage ./non-by-name/humanize { };

  humblewx = callPackage ./non-by-name/humblewx { };

  hupper = callPackage ./non-by-name/hupper { };

  hurry-filesize = callPackage ./non-by-name/hurry-filesize { };

  huum = callPackage ./non-by-name/huum { };

  hvac = callPackage ./non-by-name/hvac { };

  hvplot = callPackage ./non-by-name/hvplot { };

  hwdata = callPackage ./non-by-name/hwdata { };

  hwi = callPackage ./non-by-name/hwi { };

  hy = callPackage ./non-by-name/hy { };

  hydra-core = callPackage ./non-by-name/hydra-core { };

  hydra-joblib-launcher = callPackage ./non-by-name/hydra-joblib-launcher { };

  hydrawiser = callPackage ./non-by-name/hydrawiser { };

  hydrogram = callPackage ./non-by-name/hydrogram { };

  hydrus-api = callPackage ./non-by-name/hydrus-api { };

  hypchat = callPackage ./non-by-name/hypchat { };

  hyper-connections = callPackage ./non-by-name/hyper-connections { };

  hypercorn = callPackage ./non-by-name/hypercorn { };

  hyperframe = callPackage ./non-by-name/hyperframe { };

  hyperglot = callPackage ./non-by-name/hyperglot { };

  hyperion-py = callPackage ./non-by-name/hyperion-py { };

  hyperlink = callPackage ./non-by-name/hyperlink { };

  hyperopt = callPackage ./non-by-name/hyperopt { };

  hyperpyyaml = callPackage ./non-by-name/hyperpyyaml { };

  hyperscan = callPackage ./non-by-name/hyperscan { };

  hyponcloud = callPackage ./non-by-name/hyponcloud { };

  hypothesis = callPackage ./non-by-name/hypothesis { };

  hypothesis-auto = callPackage ./non-by-name/hypothesis-auto { };

  hypothesis-jsonschema = callPackage ./non-by-name/hypothesis-jsonschema { };

  hypothesmith = callPackage ./non-by-name/hypothesmith { };

  hyppo = callPackage ./non-by-name/hyppo { };

  hyprland-config = callPackage ./non-by-name/hyprland-config { };

  hyprland-monitors = callPackage ./non-by-name/hyprland-monitors { };

  hyprland-schema = callPackage ./non-by-name/hyprland-schema { };

  hyprland-socket = callPackage ./non-by-name/hyprland-socket { };

  hyprland-state = callPackage ./non-by-name/hyprland-state { };

  hyrule = callPackage ./non-by-name/hyrule { };

  i2c-tools = callPackage ./non-by-name/i2c-tools { inherit (pkgs) i2c-tools; };

  i2csense = callPackage ./non-by-name/i2csense { };

  i3-py = callPackage ./non-by-name/i3-py { };

  i3ipc = callPackage ./non-by-name/i3ipc { };

  iamdata = callPackage ./non-by-name/iamdata { };

  iammeter = callPackage ./non-by-name/iammeter { };

  iapws = callPackage ./non-by-name/iapws { };

  iaqualink = callPackage ./non-by-name/iaqualink { };

  ibeacon-ble = callPackage ./non-by-name/ibeacon-ble { };

  ibind = callPackage ./non-by-name/ibind { };

  ibis = callPackage ./non-by-name/ibis { };

  ibis-framework = callPackage ./non-by-name/ibis-framework { };

  ibm-cloud-sdk-core = callPackage ./non-by-name/ibm-cloud-sdk-core { };

  ibm-watson = callPackage ./non-by-name/ibm-watson { };

  ical = callPackage ./non-by-name/ical { };

  icalendar = callPackage ./non-by-name/icalendar { };

  icalendar-compatibility = callPackage ./non-by-name/icalendar-compatibility { };

  icalendar-searcher = callPackage ./non-by-name/icalendar-searcher { };

  icalevents = callPackage ./non-by-name/icalevents { };

  icdiff = callPackage ./non-by-name/icdiff { };

  icecream = callPackage ./non-by-name/icecream { };

  iceportal = callPackage ./non-by-name/iceportal { };

  icmplib = callPackage ./non-by-name/icmplib { };

  icnsutil = callPackage ./non-by-name/icnsutil { };

  icoextract = toPythonModule (pkgs.icoextract.override { python3Packages = self; });

  icontract = callPackage ./non-by-name/icontract { };

  ics = callPackage ./non-by-name/ics { };

  id = callPackage ./non-by-name/id { };

  ida-domain = callPackage ./non-by-name/ida-domain { };

  ida-hcli = callPackage ./non-by-name/ida-hcli { };

  ida-netnode = callPackage ./non-by-name/ida-netnode { };

  ida-settings = callPackage ./non-by-name/ida-settings { };

  idapro = callPackage ./non-by-name/idapro { };

  idasen = callPackage ./non-by-name/idasen { };

  idasen-ha = callPackage ./non-by-name/idasen-ha { };

  idbutils = callPackage ./non-by-name/idbutils { };

  identify = callPackage ./non-by-name/identify { };

  idna = callPackage ./non-by-name/idna { };

  idrive-e2-client = callPackage ./non-by-name/idrive-e2-client { };

  idstools = callPackage ./non-by-name/idstools { };

  ifaddr = callPackage ./non-by-name/ifaddr { };

  ifconfig-parser = callPackage ./non-by-name/ifconfig-parser { };

  ifcopenshell = callPackage ./non-by-name/ifcopenshell {
    inherit (pkgs) cgal_5 libxml2;
  };

  iglo = callPackage ./non-by-name/iglo { };

  igloohome-api = callPackage ./non-by-name/igloohome-api { };

  ignorant = callPackage ./non-by-name/ignorant { };

  igraph = callPackage ./non-by-name/igraph { inherit (pkgs) igraph; };

  ihcsdk = callPackage ./non-by-name/ihcsdk { };

  ihm = callPackage ./non-by-name/ihm { };

  iisignature = callPackage ./non-by-name/iisignature { };

  ijson = callPackage ./non-by-name/ijson { };

  ilcli = callPackage ./non-by-name/ilcli { };

  ilua = callPackage ./non-by-name/ilua { };

  image = callPackage ./non-by-name/image { };

  image-diff = callPackage ./non-by-name/image-diff { };

  image-go-nord = callPackage ./non-by-name/image-go-nord { };

  imagecodecs = callPackage ./non-by-name/imagecodecs { };

  imagecodecs-lite = callPackage ./non-by-name/imagecodecs-lite { };

  imagecorruptions = callPackage ./non-by-name/imagecorruptions { };

  imagededup = callPackage ./non-by-name/imagededup { };

  imagehash = callPackage ./non-by-name/imagehash { };

  imageio = callPackage ./non-by-name/imageio { };

  imageio-ffmpeg = callPackage ./non-by-name/imageio-ffmpeg { };

  imagesize = callPackage ./non-by-name/imagesize { };

  imantics = callPackage ./non-by-name/imantics { };

  imap-tools = callPackage ./non-by-name/imap-tools { };

  imapclient = callPackage ./non-by-name/imapclient { };

  imaplib2 = callPackage ./non-by-name/imaplib2 { };

  imbalanced-learn = callPackage ./non-by-name/imbalanced-learn { };

  imeon-inverter-api = callPackage ./non-by-name/imeon-inverter-api { };

  img2pdf = callPackage ./non-by-name/img2pdf { };

  imgcat = callPackage ./non-by-name/imgcat { };

  imgdiff = callPackage ./non-by-name/imgdiff { };

  imgsize = callPackage ./non-by-name/imgsize { };

  imgw-pib = callPackage ./non-by-name/imgw-pib { };

  imia = callPackage ./non-by-name/imia { };

  iminuit = callPackage ./non-by-name/iminuit { };

  immutabledict = callPackage ./non-by-name/immutabledict { };

  immutables = callPackage ./non-by-name/immutables { };

  impacket = callPackage ./non-by-name/impacket { };

  import-expression = callPackage ./non-by-name/import-expression { };

  importlab = callPackage ./non-by-name/importlab { };

  importlib-metadata = callPackage ./non-by-name/importlib-metadata { };

  importlib-resources = callPackage ./non-by-name/importlib-resources { };

  importmagic = callPackage ./non-by-name/importmagic { };

  imread = callPackage ./non-by-name/imread {
    inherit (pkgs)
      libjpeg
      libpng
      libtiff
      libwebp
      ;
  };

  imutils = callPackage ./non-by-name/imutils { };

  in-n-out = callPackage ./non-by-name/in-n-out { };

  in-place = callPackage ./non-by-name/in-place { };

  in-toto-attestation = callPackage ./non-by-name/in-toto-attestation { };

  incomfort-client = callPackage ./non-by-name/incomfort-client { };

  incremental = callPackage ./non-by-name/incremental { };

  indevolt-api = callPackage ./non-by-name/indevolt-api { };

  indexed-bzip2 = callPackage ./non-by-name/indexed-bzip2 { };

  indexed-gzip = callPackage ./non-by-name/indexed-gzip { inherit (pkgs) zlib; };

  indexed-zstd = callPackage ./non-by-name/indexed-zstd { inherit (pkgs) zstd; };

  indicio = callPackage ./non-by-name/indicio { };

  inequality = callPackage ./non-by-name/inequality { };

  inference-gym = callPackage ./non-by-name/inference-gym { };

  infinity = callPackage ./non-by-name/infinity { };

  infisicalsdk = callPackage ./non-by-name/infisicalsdk { };

  inflate64 = callPackage ./non-by-name/inflate64 { };

  inflect = callPackage ./non-by-name/inflect { };

  inflection = callPackage ./non-by-name/inflection { };

  influxdb = callPackage ./non-by-name/influxdb { };

  influxdb-client = callPackage ./non-by-name/influxdb-client { };

  influxdb3-python = callPackage ./non-by-name/influxdb3-python { };

  inform = callPackage ./non-by-name/inform { };

  infrared-protocols = callPackage ./non-by-name/infrared-protocols { };

  ingredient-parser-nlp = callPackage ./non-by-name/ingredient-parser-nlp { };

  ini2toml = callPackage ./non-by-name/ini2toml { };

  iniconfig = callPackage ./non-by-name/iniconfig { };

  inifile = callPackage ./non-by-name/inifile { };

  iniparse = callPackage ./non-by-name/iniparse { };

  inject = callPackage ./non-by-name/inject { };

  injector = callPackage ./non-by-name/injector { };

  inkbird-ble = callPackage ./non-by-name/inkbird-ble { };

  inkex = callPackage ./non-by-name/inkex { };

  inky = callPackage ./non-by-name/inky { };

  inline-snapshot = callPackage ./non-by-name/inline-snapshot { };

  inotify = callPackage ./non-by-name/inotify { };

  inotify-simple = callPackage ./non-by-name/inotify-simple { };

  inotifyrecursive = callPackage ./non-by-name/inotifyrecursive { };

  inquirer = callPackage ./non-by-name/inquirer { };

  inquirer3 = callPackage ./non-by-name/inquirer3 { };

  inquirerpy = callPackage ./non-by-name/inquirerpy { };

  inscriptis = callPackage ./non-by-name/inscriptis { };

  insegel = callPackage ./non-by-name/insegel { };

  insightface = callPackage ./non-by-name/insightface { };

  installer = callPackage ./non-by-name/installer { };

  insteon-frontend-home-assistant = callPackage ./non-by-name/insteon-frontend-home-assistant { };

  instructor = callPackage ./non-by-name/instructor { };

  intake = callPackage ./non-by-name/intake { };

  intake-parquet = callPackage ./non-by-name/intake-parquet { };

  intbitset = callPackage ./non-by-name/intbitset { };

  intelhex = callPackage ./non-by-name/intelhex { };

  intellifire4py = callPackage ./non-by-name/intellifire4py { };

  intensity-normalization = callPackage ./non-by-name/intensity-normalization { };

  interegular = callPackage ./non-by-name/interegular { };

  interface-meta = callPackage ./non-by-name/interface-meta { };

  internetarchive = callPackage ./non-by-name/internetarchive { };

  interruptingcow = callPackage ./non-by-name/interruptingcow { };

  intersphinx-registry = callPackage ./non-by-name/intersphinx-registry { };

  intervals = callPackage ./non-by-name/intervals { };

  intervaltree = callPackage ./non-by-name/intervaltree { };

  into-dbus-python = callPackage ./non-by-name/into-dbus-python { };

  inventree = callPackage ./non-by-name/inventree { };

  invisible-watermark = callPackage ./non-by-name/invisible-watermark { };

  invocations = callPackage ./non-by-name/invocations { };

  invoke = callPackage ./non-by-name/invoke { };

  inwx-domrobot = callPackage ./non-by-name/inwx-domrobot { };

  iocapture = callPackage ./non-by-name/iocapture { };

  iocextract = callPackage ./non-by-name/iocextract { };

  iocsearcher = callPackage ./non-by-name/iocsearcher { };

  ioctl-opt = callPackage ./non-by-name/ioctl-opt { };

  iocx = callPackage ./non-by-name/iocx { };

  iodata = callPackage ./non-by-name/iodata { };

  iometer = callPackage ./non-by-name/iometer { };

  ionoscloud = callPackage ./non-by-name/ionoscloud { };

  iopath = callPackage ./non-by-name/iopath { };

  iosbackup = callPackage ./non-by-name/iosbackup { };

  iottycloud = callPackage ./non-by-name/iottycloud { };

  iowait = callPackage ./non-by-name/iowait { };

  ip2location = callPackage ./non-by-name/ip2location { };

  ipaddr = callPackage ./non-by-name/ipaddr { };

  ipadic = callPackage ./non-by-name/ipadic { };

  ipdb = callPackage ./non-by-name/ipdb { };

  iperf3 = callPackage ./non-by-name/iperf3 { };

  ipfshttpclient = callPackage ./non-by-name/ipfshttpclient { };

  ipi = callPackage ./non-by-name/ipi { };

  iplotx = callPackage ./non-by-name/iplotx { };

  ipsw-parser = callPackage ./non-by-name/ipsw-parser { };

  iptools = callPackage ./non-by-name/iptools { };

  ipv8-rust-tunnels = callPackage ./non-by-name/ipv8-rust-tunnels { };

  ipwhl = callPackage ./non-by-name/ipwhl { };

  ipwhois = callPackage ./non-by-name/ipwhois { };

  ipy = callPackage ./non-by-name/ipy { };

  ipycanvas = callPackage ./non-by-name/ipycanvas { };

  ipydatagrid = callPackage ./non-by-name/ipydatagrid { };

  ipydatawidgets = callPackage ./non-by-name/ipydatawidgets { };

  ipykernel = callPackage ./non-by-name/ipykernel { };

  ipylab = callPackage ./non-by-name/ipylab { };

  ipymarkup = callPackage ./non-by-name/ipymarkup { };

  ipympl = callPackage ./non-by-name/ipympl { };

  ipynbname = callPackage ./non-by-name/ipynbname { };

  ipyniivue = callPackage ./non-by-name/ipyniivue { };

  ipyparallel = callPackage ./non-by-name/ipyparallel { };

  ipytablewidgets = callPackage ./non-by-name/ipytablewidgets { };

  ipython = callPackage ./non-by-name/ipython { };

  ipython-genutils = callPackage ./non-by-name/ipython-genutils { };

  ipython-pygments-lexers = callPackage ./non-by-name/ipython-pygments-lexers { };

  ipython-sql = callPackage ./non-by-name/ipython-sql { };

  ipyvue = callPackage ./non-by-name/ipyvue { };

  ipyvuetify = callPackage ./non-by-name/ipyvuetify { };

  ipywidgets = callPackage ./non-by-name/ipywidgets { };

  ipyxact = callPackage ./non-by-name/ipyxact { };

  irc = callPackage ./non-by-name/irc { };

  ircrobots = callPackage ./non-by-name/ircrobots { };

  ircstates = callPackage ./non-by-name/ircstates { };

  irctokens = callPackage ./non-by-name/irctokens { };

  irisclient = callPackage ./non-by-name/irisclient { };

  irm-kmi-api = callPackage ./non-by-name/irm-kmi-api { };

  ironcalc = callPackage ../../by-name/ir/ironcalc/python.nix {
    inherit (pkgs) ironcalc;
  };

  isal = callPackage ./non-by-name/isal { };

  isbnlib = callPackage ./non-by-name/isbnlib { };

  iseo-argo-ble = callPackage ./non-by-name/iseo-argo-ble { };

  islpy = callPackage ./non-by-name/islpy { isl = pkgs.isl_0_27; };

  ismartgate = callPackage ./non-by-name/ismartgate { };

  iso-639 = callPackage ./non-by-name/iso-639 { };

  iso3166 = callPackage ./non-by-name/iso3166 { };

  iso4217 = callPackage ./non-by-name/iso4217 { };

  iso4217parse = callPackage ./non-by-name/iso4217parse { };

  iso639-lang = callPackage ./non-by-name/iso639-lang { };

  iso8601 = callPackage ./non-by-name/iso8601 { };

  isocodes = callPackage ./non-by-name/isocodes { };

  isodate = callPackage ./non-by-name/isodate { };

  isoduration = callPackage ./non-by-name/isoduration { };

  isort = callPackage ./non-by-name/isort { };

  isosurfaces = callPackage ./non-by-name/isosurfaces { };

  isounidecode = callPackage ./non-by-name/isounidecode { };

  isoweek = callPackage ./non-by-name/isoweek { };

  israel-rail-api = callPackage ./non-by-name/israel-rail-api { };

  issubclass = callPackage ./non-by-name/issubclass { };

  itables = callPackage ./non-by-name/itables { };

  itanium-demangler = callPackage ./non-by-name/itanium-demangler { };

  item-synchronizer = callPackage ./non-by-name/item-synchronizer { };

  itemadapter = callPackage ./non-by-name/itemadapter { };

  itemdb = callPackage ./non-by-name/itemdb { };

  itemloaders = callPackage ./non-by-name/itemloaders { };

  iterable-io = callPackage ./non-by-name/iterable-io { };

  iteration-utilities = callPackage ./non-by-name/iteration-utilities { };

  iterative-telemetry = callPackage ./non-by-name/iterative-telemetry { };

  iterfzf = callPackage ./non-by-name/iterfzf { };

  iterm2 = callPackage ./non-by-name/iterm2 { };

  itk = toPythonModule (
    pkgs.itk.override {
      inherit python numpy;
      enablePython = true;
      enableRtk = false;
      stdenv =
        if stdenv.cc.isGNU then pkgs.stdenvAdapters.useLibsFrom stdenv pkgs.gcc13Stdenv else stdenv;
    }
  );

  itkwasm = callPackage ./non-by-name/itkwasm { };

  itkwasm-downsample = callPackage ./non-by-name/itkwasm-downsample { };

  itkwasm-downsample-emscripten = callPackage ./non-by-name/itkwasm-downsample-emscripten { };

  itkwasm-downsample-wasi = callPackage ./non-by-name/itkwasm-downsample-wasi { };

  itkwasm-image-io = callPackage ./non-by-name/itkwasm-image-io { };

  itkwasm-image-io-emscripten = callPackage ./non-by-name/itkwasm-image-io-emscripten { };

  itkwasm-image-io-wasi = callPackage ./non-by-name/itkwasm-image-io-wasi { };

  itsdangerous = callPackage ./non-by-name/itsdangerous { };

  itunespy = callPackage ./non-by-name/itunespy { };

  itypes = callPackage ./non-by-name/itypes { };

  iwlib = callPackage ./non-by-name/iwlib { };

  ixia = callPackage ./non-by-name/ixia { };

  j2lint = callPackage ./non-by-name/j2lint { };

  jack-client = callPackage ./non-by-name/jack-client { };

  jaconv = callPackage ./non-by-name/jaconv { };

  jalali-core = callPackage ./non-by-name/jalali-core { };

  jamo = callPackage ./non-by-name/jamo { };

  janus = callPackage ./non-by-name/janus { };

  jaraco-abode = callPackage ./non-by-name/jaraco-abode { };

  jaraco-classes = callPackage ./non-by-name/jaraco-classes { };

  jaraco-collections = callPackage ./non-by-name/jaraco-collections { };

  jaraco-context = callPackage ./non-by-name/jaraco-context { };

  jaraco-email = callPackage ./non-by-name/jaraco-email { };

  jaraco-envs = callPackage ./non-by-name/jaraco-envs { };

  jaraco-functools = callPackage ./non-by-name/jaraco-functools { };

  jaraco-itertools = callPackage ./non-by-name/jaraco-itertools { };

  jaraco-logging = callPackage ./non-by-name/jaraco-logging { };

  jaraco-net = callPackage ./non-by-name/jaraco-net { };

  jaraco-path = callPackage ./non-by-name/jaraco-path { };

  jaraco-stream = callPackage ./non-by-name/jaraco-stream { };

  jaraco-test = callPackage ./non-by-name/jaraco-test { };

  jaraco-text = callPackage ./non-by-name/jaraco-text { };

  jarowinkler = callPackage ./non-by-name/jarowinkler { };

  javaobj-py3 = callPackage ./non-by-name/javaobj-py3 { };

  javaproperties = callPackage ./non-by-name/javaproperties { };

  jax = callPackage ./non-by-name/jax { };

  jax-cuda12-pjrt = callPackage ./non-by-name/jax-cuda12-pjrt { };

  jax-cuda12-plugin = callPackage ./non-by-name/jax-cuda12-plugin { };

  jax-cuda13-pjrt = callPackage ./non-by-name/jax-cuda13-pjrt { };

  jax-cuda13-plugin = callPackage ./non-by-name/jax-cuda13-plugin { };

  jax-tap = callPackage ./non-by-name/jax-tap { };

  jaxlib = jaxlib-bin;

  jaxlib-bin = callPackage ./non-by-name/jaxlib/bin.nix { };

  jaxlib-build = callPackage ./non-by-name/jaxlib {
    snappy-cpp = pkgs.snappy;
  };

  jaxopt = callPackage ./non-by-name/jaxopt { };

  jaxtyping = callPackage ./non-by-name/jaxtyping { };

  jaydebeapi = callPackage ./non-by-name/jaydebeapi { };

  jc = callPackage ./non-by-name/jc { };

  jdatetime = callPackage ./non-by-name/jdatetime { };

  jdcal = callPackage ./non-by-name/jdcal { };

  jedi = callPackage ./non-by-name/jedi { };

  jedi-language-server = callPackage ./non-by-name/jedi-language-server { };

  jeepney = callPackage ./non-by-name/jeepney { };

  jello = callPackage ./non-by-name/jello { };

  jellyfin-apiclient-python = callPackage ./non-by-name/jellyfin-apiclient-python { };

  jellyfish = callPackage ./non-by-name/jellyfish { };

  jenkins-job-builder = callPackage ./non-by-name/jenkins-job-builder { };

  jenkinsapi = callPackage ./non-by-name/jenkinsapi { };

  jh2 = callPackage ./non-by-name/jh2 { };

  jianpu-ly = callPackage ./non-by-name/jianpu-ly { };

  jieba = callPackage ./non-by-name/jieba { };

  jinja2 = callPackage ./non-by-name/jinja2 { };

  jinja2-ansible-filters = callPackage ./non-by-name/jinja2-ansible-filters { };

  jinja2-git = callPackage ./non-by-name/jinja2-git { };

  jinja2-humanize-extension = callPackage ./non-by-name/jinja2-humanize-extension { };

  jinja2-pluralize = callPackage ./non-by-name/jinja2-pluralize { };

  jinja2-strcase = callPackage ./non-by-name/jinja2-strcase { };

  jinja2-time = callPackage ./non-by-name/jinja2-time { };

  jira = callPackage ./non-by-name/jira { };

  jishaku = callPackage ./non-by-name/jishaku { };

  jiter = callPackage ./non-by-name/jiter { };

  jiwer = callPackage ./non-by-name/jiwer { };

  jmespath = callPackage ./non-by-name/jmespath { };

  jmp = callPackage ./non-by-name/jmp { };

  joblib = callPackage ./non-by-name/joblib { };

  johnnycanencrypt = callPackage ./non-by-name/johnnycanencrypt { };

  josepy = callPackage ./non-by-name/josepy { };

  joserfc = callPackage ./non-by-name/joserfc { };

  jplephem = callPackage ./non-by-name/jplephem { };

  jproperties = callPackage ./non-by-name/jproperties { };

  jpylyzer = callPackage ./non-by-name/jpylyzer { };

  jpype1 = callPackage ./non-by-name/jpype1 { };

  jq = callPackage ./non-by-name/jq { inherit (pkgs) jq; };

  jsbeautifier = callPackage ./non-by-name/jsbeautifier { };

  jschema-to-python = callPackage ./non-by-name/jschema-to-python { };

  jschon = callPackage ./non-by-name/jschon { };

  jsmin = callPackage ./non-by-name/jsmin { };

  json-api-doc = callPackage ./non-by-name/json-api-doc { };

  json-flatten = callPackage ./non-by-name/json-flatten { };

  json-handler-registry = callPackage ./non-by-name/json-handler-registry { };

  json-home-client = callPackage ./non-by-name/json-home-client { };

  json-logging = callPackage ./non-by-name/json-logging { };

  json-merge-patch = callPackage ./non-by-name/json-merge-patch { };

  json-repair = callPackage ./non-by-name/json-repair { };

  json-rpc = callPackage ./non-by-name/json-rpc { };

  json-schema-for-humans = callPackage ./non-by-name/json-schema-for-humans { };

  json-schema-to-pydantic = callPackage ./non-by-name/json-schema-to-pydantic { };

  json-stream = callPackage ./non-by-name/json-stream { };

  json-stream-rs-tokenizer = callPackage ./non-by-name/json-stream-rs-tokenizer { };

  json-timeseries = callPackage ./non-by-name/json-timeseries { };

  json-tricks = callPackage ./non-by-name/json-tricks { };

  json2html = callPackage ./non-by-name/json2html { };

  json5 = callPackage ./non-by-name/json5 { };

  jsonable = callPackage ./non-by-name/jsonable { };

  jsonalias = callPackage ./non-by-name/jsonalias { };

  jsonargparse = callPackage ./non-by-name/jsonargparse { };

  jsonconversion = callPackage ./non-by-name/jsonconversion { };

  jsondate = callPackage ./non-by-name/jsondate { };

  jsondiff = callPackage ./non-by-name/jsondiff { };

  jsonfeed = callPackage ./non-by-name/jsonfeed { };

  jsonformatter = callPackage ./non-by-name/jsonformatter { };

  jsonlines = callPackage ./non-by-name/jsonlines { };

  jsonmerge = callPackage ./non-by-name/jsonmerge { };

  jsonnet = callPackage ./non-by-name/jsonnet { };

  jsonpatch = callPackage ./non-by-name/jsonpatch { };

  jsonpath = callPackage ./non-by-name/jsonpath { };

  jsonpath-ng = callPackage ./non-by-name/jsonpath-ng { };

  jsonpath-python = callPackage ./non-by-name/jsonpath-python { };

  jsonpath-rw = callPackage ./non-by-name/jsonpath-rw { };

  jsonpickle = callPackage ./non-by-name/jsonpickle { };

  jsonpointer = callPackage ./non-by-name/jsonpointer { };

  jsonref = callPackage ./non-by-name/jsonref { };

  jsonrpc-async = callPackage ./non-by-name/jsonrpc-async { };

  jsonrpc-base = callPackage ./non-by-name/jsonrpc-base { };

  jsonrpc-websocket = callPackage ./non-by-name/jsonrpc-websocket { };

  jsonrpclib-pelix = callPackage ./non-by-name/jsonrpclib-pelix { };

  jsons = callPackage ./non-by-name/jsons { };

  jsonschema = callPackage ./non-by-name/jsonschema { };

  jsonschema-path = callPackage ./non-by-name/jsonschema-path { };

  jsonschema-rs = callPackage ./non-by-name/jsonschema-rs { };

  jsonschema-specifications = callPackage ./non-by-name/jsonschema-specifications { };

  jsonslicer = callPackage ./non-by-name/jsonslicer { };

  jsonstreams = callPackage ./non-by-name/jsonstreams { };

  jsonxs = callPackage ./non-by-name/jsonxs { };

  jstyleson = callPackage ./non-by-name/jstyleson { };

  jug = callPackage ./non-by-name/jug { };

  juliandate = callPackage ./non-by-name/juliandate { };

  julius = callPackage ./non-by-name/julius { };

  july = callPackage ./non-by-name/july { };

  june-analytics-python = callPackage ./non-by-name/june-analytics-python { };

  junit-xml = callPackage ./non-by-name/junit-xml { };

  junit2html = callPackage ./non-by-name/junit2html { };

  junitparser = callPackage ./non-by-name/junitparser { };

  junos-eznc = callPackage ./non-by-name/junos-eznc { };

  jupysql = callPackage ./non-by-name/jupysql { };

  jupysql-plugin = callPackage ./non-by-name/jupysql-plugin { };

  jupyter = callPackage ./non-by-name/jupyter { };

  jupyter-book = callPackage ./non-by-name/jupyter-book { };

  jupyter-builder = callPackage ./non-by-name/jupyter-builder { };

  jupyter-c-kernel = callPackage ./non-by-name/jupyter-c-kernel { };

  jupyter-cache = callPackage ./non-by-name/jupyter-cache { };

  jupyter-client = callPackage ./non-by-name/jupyter-client { };

  jupyter-collaboration = callPackage ./non-by-name/jupyter-collaboration { };

  jupyter-collaboration-ui = callPackage ./non-by-name/jupyter-collaboration-ui { };

  jupyter-console = callPackage ./non-by-name/jupyter-console { };

  jupyter-contrib-core = callPackage ./non-by-name/jupyter-contrib-core { };

  jupyter-core = callPackage ./non-by-name/jupyter-core { };

  jupyter-docprovider = callPackage ./non-by-name/jupyter-docprovider { };

  jupyter-events = callPackage ./non-by-name/jupyter-events { };

  jupyter-highlight-selected-word = callPackage ./non-by-name/jupyter-highlight-selected-word { };

  jupyter-lsp = callPackage ./non-by-name/jupyter-lsp { };

  jupyter-nbextensions-configurator = callPackage ./non-by-name/jupyter-nbextensions-configurator { };

  jupyter-packaging = callPackage ./non-by-name/jupyter-packaging { };

  jupyter-repo2docker = callPackage ./non-by-name/jupyter-repo2docker {
    pkgs-docker = pkgs.docker;
  };

  jupyter-server = callPackage ./non-by-name/jupyter-server { };

  jupyter-server-fileid = callPackage ./non-by-name/jupyter-server-fileid { };

  jupyter-server-mathjax = callPackage ./non-by-name/jupyter-server-mathjax { };

  jupyter-server-terminals = callPackage ./non-by-name/jupyter-server-terminals { };

  jupyter-server-ydoc = callPackage ./non-by-name/jupyter-server-ydoc { };

  jupyter-sphinx = callPackage ./non-by-name/jupyter-sphinx { };

  jupyter-telemetry = callPackage ./non-by-name/jupyter-telemetry { };

  jupyter-themes = callPackage ./non-by-name/jupyter-themes { };

  jupyter-ui-poll = callPackage ./non-by-name/jupyter-ui-poll { };

  jupyter-ydoc = callPackage ./non-by-name/jupyter-ydoc { };

  jupyterhub = callPackage ./non-by-name/jupyterhub { };

  jupyterhub-ldapauthenticator = callPackage ./non-by-name/jupyterhub-ldapauthenticator { };

  jupyterhub-systemdspawner = callPackage ./non-by-name/jupyterhub-systemdspawner { };

  jupyterhub-tmpauthenticator = callPackage ./non-by-name/jupyterhub-tmpauthenticator { };

  jupyterlab = callPackage ./non-by-name/jupyterlab { };

  jupyterlab-execute-time = callPackage ./non-by-name/jupyterlab-execute-time { };

  jupyterlab-git = callPackage ./non-by-name/jupyterlab-git { };

  jupyterlab-git-core = callPackage ./non-by-name/jupyterlab-git-core { };

  jupyterlab-lsp = callPackage ./non-by-name/jupyterlab-lsp { };

  jupyterlab-pygments = callPackage ./non-by-name/jupyterlab-pygments { };

  jupyterlab-server = callPackage ./non-by-name/jupyterlab-server { };

  jupyterlab-vim = callPackage ./non-by-name/jupyterlab-vim { };

  jupyterlab-widgets = callPackage ./non-by-name/jupyterlab-widgets { };

  jupyterlite-core = callPackage ./non-by-name/jupyterlite-core { };

  jupyterlite-sphinx = callPackage ./non-by-name/jupyterlite-sphinx { };

  jupytext = callPackage ./non-by-name/jupytext { };

  justbackoff = callPackage ./non-by-name/justbackoff { };

  justbases = callPackage ./non-by-name/justbases { };

  justbytes = callPackage ./non-by-name/justbytes { };

  justext = callPackage ./non-by-name/justext { };

  justnimbus = callPackage ./non-by-name/justnimbus { };

  jwcrypto = callPackage ./non-by-name/jwcrypto { };

  jwt = callPackage ./non-by-name/jwt { };

  jxlpy = callPackage ./non-by-name/jxlpy { };

  jxmlease = callPackage ./non-by-name/jxmlease { };

  k-diffusion = callPackage ./non-by-name/k-diffusion { };

  k5test = callPackage ./non-by-name/k5test {
    inherit (pkgs) findutils;
    krb5-c = pkgs.krb5;
  };

  kaa-base = callPackage ./non-by-name/kaa-base { };

  kaa-metadata = callPackage ./non-by-name/kaa-metadata { };

  kaco-modbus = callPackage ./non-by-name/kaco-modbus { };

  kafka-python = callPackage ./non-by-name/kafka-python { };

  kaggle = callPackage ./non-by-name/kaggle { };

  kagglehub = callPackage ./non-by-name/kagglehub { };

  kagglesdk = callPackage ./non-by-name/kagglesdk { };

  kahip = toPythonModule (
    pkgs.kahip.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  kaitaistruct = callPackage ./non-by-name/kaitaistruct { };

  kaiterra-async-client = callPackage ./non-by-name/kaiterra-async-client { };

  kajiki = callPackage ./non-by-name/kajiki { };

  kaldi-active-grammar = callPackage ./non-by-name/kaldi-active-grammar { };

  kaldi-native-fbank = callPackage ./non-by-name/kaldi-native-fbank { };

  kaleido = callPackage ./non-by-name/kaleido { };

  kalshi-python = callPackage ./non-by-name/kalshi-python { };

  kanalizer = callPackage ./non-by-name/kanalizer { };

  kanidm = callPackage ./non-by-name/kanidm { };

  kanjize = callPackage ./non-by-name/kanjize { };

  kantoku = callPackage ./non-by-name/kantoku { };

  kaptan = callPackage ./non-by-name/kaptan { };

  karton-asciimagic = callPackage ./non-by-name/karton-asciimagic { };

  karton-autoit-ripper = callPackage ./non-by-name/karton-autoit-ripper { };

  karton-classifier = callPackage ./non-by-name/karton-classifier { };

  karton-config-extractor = callPackage ./non-by-name/karton-config-extractor { };

  karton-core = callPackage ./non-by-name/karton-core { };

  karton-dashboard = callPackage ./non-by-name/karton-dashboard { };

  karton-mwdb-reporter = callPackage ./non-by-name/karton-mwdb-reporter { };

  karton-yaramatcher = callPackage ./non-by-name/karton-yaramatcher { };

  kasa-crypt = callPackage ./non-by-name/kasa-crypt { };

  kazoo = callPackage ./non-by-name/kazoo { };

  kbcstorage = callPackage ./non-by-name/kbcstorage { };

  kbnf = callPackage ./non-by-name/kbnf { };

  kconfiglib = callPackage ./non-by-name/kconfiglib { };

  kdl-py = callPackage ./non-by-name/kdl-py { };

  keba-kecontact = callPackage ./non-by-name/keba-kecontact { };

  keep = callPackage ./non-by-name/keep { };

  keepalive = callPackage ./non-by-name/keepalive { };

  keepkey = callPackage ./non-by-name/keepkey { };

  kegtron-ble = callPackage ./non-by-name/kegtron-ble { };

  keke = callPackage ./non-by-name/keke { };

  keras = callPackage ./non-by-name/keras { };

  kerbad = callPackage ./non-by-name/kerbad { };

  kerberos = callPackage ./non-by-name/kerberos { };

  kernels = callPackage ./non-by-name/kernels { };

  kernels-data = callPackage ./non-by-name/kernels-data { };

  kestra = callPackage ./non-by-name/kestra { };

  keyboard = callPackage ./non-by-name/keyboard { };

  keymap-drawer = callPackage ./non-by-name/keymap-drawer { };

  keyring = callPackage ./non-by-name/keyring { };

  keyring-pass = callPackage ./non-by-name/keyring-pass { };

  keyrings-alt = callPackage ./non-by-name/keyrings-alt { };

  keyrings-cryptfile = callPackage ./non-by-name/keyrings-cryptfile { };

  keyrings-google-artifactregistry-auth =
    callPackage ./non-by-name/keyrings-google-artifactregistry-auth
      { };

  keystone-engine = callPackage ./non-by-name/keystone-engine { };

  keystoneauth1 = callPackage ./non-by-name/keystoneauth1 { };

  keyutils = callPackage ./non-by-name/keyutils { inherit (pkgs) keyutils; };

  kfactory = callPackage ./non-by-name/kfactory { };

  kgb = callPackage ./non-by-name/kgb { };

  khanaa = callPackage ./non-by-name/khanaa { };

  kiauto = callPackage ./non-by-name/kiauto {
    kicadPkg = pkgs.kicad;
  };

  kicad = toPythonModule (pkgs.kicad.override { python3 = python; }).src;

  kicad-python = callPackage ./non-by-name/kicad-python { };

  kicadcliwrapper = callPackage ./non-by-name/kicadcliwrapper { };

  kinparse = callPackage ./non-by-name/kinparse { };

  kiosker-python-api = callPackage ./non-by-name/kiosker-python-api { };

  kiss-headers = callPackage ./non-by-name/kiss-headers { };

  kitchen = callPackage ./non-by-name/kitchen { };

  kivy = callPackage ./non-by-name/kivy { };

  kivy-garden = callPackage ./non-by-name/kivy-garden { };

  kiwiki-client = callPackage ./non-by-name/kiwiki-client { };

  kiwisolver = callPackage ./non-by-name/kiwisolver { };

  klaus = callPackage ./non-by-name/klaus { };

  klayout = callPackage ./non-by-name/klayout { inherit (pkgs) klayout; };

  klein = callPackage ./non-by-name/klein { };

  kmapper = callPackage ./non-by-name/kmapper { };

  kml2geojson = callPackage ./non-by-name/kml2geojson { };

  kmock = callPackage ./non-by-name/kmock { };

  kmsxx = toPythonModule (
    pkgs.kmsxx.override {
      withPython = true;
      python3Packages = self;
    }
  );

  knack = callPackage ./non-by-name/knack { };

  kneaddata = callPackage ./non-by-name/kneaddata { };

  kneed = callPackage ./non-by-name/kneed { };

  knocki = callPackage ./non-by-name/knocki { };

  knot-floer-homology = callPackage ./non-by-name/knot-floer-homology { };

  knowit = callPackage ./non-by-name/knowit { };

  knx-frontend = callPackage ./non-by-name/knx-frontend { };

  knx-telegram-store = callPackage ./non-by-name/knx-telegram-store { };

  koji = callPackage ./non-by-name/koji { };

  kokoro = callPackage ./non-by-name/kokoro { };

  kombu = callPackage ./non-by-name/kombu { };

  kopf = callPackage ./non-by-name/kopf { };

  korean-lunar-calendar = callPackage ./non-by-name/korean-lunar-calendar { };

  kornia = callPackage ./non-by-name/kornia { };

  kornia-rs = callPackage ./non-by-name/kornia-rs { };

  kotsu = callPackage ./non-by-name/kotsu { };

  krakenex = callPackage ./non-by-name/krakenex { };

  krb5 = callPackage ./non-by-name/krb5 { krb5-c = pkgs.krb5; };

  krfzf-py = callPackage ./non-by-name/krfzf-py { };

  kserve = callPackage ./non-by-name/kserve { };

  kserve-storage = callPackage ./non-by-name/kserve-storage { };

  kubernetes = callPackage ./non-by-name/kubernetes { };

  kubernetes-asyncio = callPackage ./non-by-name/kubernetes-asyncio { };

  kubernetes-validate = callPackage ../../by-name/ku/kubernetes-validate/unwrapped.nix { };

  kurbopy = callPackage ./non-by-name/kurbopy { };

  kvf = callPackage ./non-by-name/kvf { };

  l18n = callPackage ./non-by-name/l18n { };

  la-panic = callPackage ./non-by-name/la-panic { };

  labelbox = callPackage ./non-by-name/labelbox { };

  labgrid = callPackage ./non-by-name/labgrid { };

  labmath = callPackage ./non-by-name/labmath { };

  laces = callPackage ./non-by-name/laces { };

  lacrosse-view = callPackage ./non-by-name/lacrosse-view { };

  lacuscore = callPackage ./non-by-name/lacuscore { };

  lakeside = callPackage ./non-by-name/lakeside { };

  lammps = callPackage ./non-by-name/lammps { inherit (pkgs) lammps; };

  lance-namespace = callPackage ./non-by-name/lance-namespace { };

  lance-namespace-urllib3-client = callPackage ./non-by-name/lance-namespace-urllib3-client { };

  lancedb = callPackage ./non-by-name/lancedb { inherit (pkgs) protobuf; };

  langchain = callPackage ./non-by-name/langchain { };

  langchain-anthropic = callPackage ./non-by-name/langchain-anthropic { };

  langchain-aws = callPackage ./non-by-name/langchain-aws { };

  langchain-azure-dynamic-sessions = callPackage ./non-by-name/langchain-azure-dynamic-sessions { };

  langchain-chroma = callPackage ./non-by-name/langchain-chroma { };

  langchain-classic = callPackage ./non-by-name/langchain-classic { };

  langchain-community = callPackage ./non-by-name/langchain-community { };

  langchain-core = callPackage ./non-by-name/langchain-core { };

  langchain-deepseek = callPackage ./non-by-name/langchain-deepseek { };

  langchain-fireworks = callPackage ./non-by-name/langchain-fireworks { };

  langchain-google-genai = callPackage ./non-by-name/langchain-google-genai { };

  langchain-groq = callPackage ./non-by-name/langchain-groq { };

  langchain-huggingface = callPackage ./non-by-name/langchain-huggingface { };

  langchain-mistralai = callPackage ./non-by-name/langchain-mistralai { };

  langchain-mongodb = callPackage ./non-by-name/langchain-mongodb { };

  langchain-ollama = callPackage ./non-by-name/langchain-ollama { };

  langchain-openai = callPackage ./non-by-name/langchain-openai { };

  langchain-perplexity = callPackage ./non-by-name/langchain-perplexity { };

  langchain-protocol = callPackage ./non-by-name/langchain-protocol { };

  langchain-sail = callPackage ./non-by-name/langchain-sail { };

  langchain-tests = callPackage ./non-by-name/langchain-tests { };

  langchain-text-splitters = callPackage ./non-by-name/langchain-text-splitters { };

  langchain-xai = callPackage ./non-by-name/langchain-xai { };

  langcodes = callPackage ./non-by-name/langcodes { };

  langdetect = callPackage ./non-by-name/langdetect { };

  langfuse = callPackage ./non-by-name/langfuse { };

  langgraph = callPackage ./non-by-name/langgraph { };

  langgraph-checkpoint = callPackage ./non-by-name/langgraph-checkpoint { };

  langgraph-checkpoint-mongodb = callPackage ./non-by-name/langgraph-checkpoint-mongodb { };

  langgraph-checkpoint-postgres = callPackage ./non-by-name/langgraph-checkpoint-postgres { };

  langgraph-checkpoint-sqlite = callPackage ./non-by-name/langgraph-checkpoint-sqlite { };

  langgraph-cli = callPackage ./non-by-name/langgraph-cli { };

  langgraph-prebuilt = callPackage ./non-by-name/langgraph-prebuilt { };

  langgraph-runtime-inmem = callPackage ./non-by-name/langgraph-runtime-inmem { };

  langgraph-sdk = callPackage ./non-by-name/langgraph-sdk { };

  langgraph-store-mongodb = callPackage ./non-by-name/langgraph-store-mongodb { };

  langid = callPackage ./non-by-name/langid { };

  langsmith = callPackage ./non-by-name/langsmith { };

  language-data = callPackage ./non-by-name/language-data { };

  language-tags = callPackage ./non-by-name/language-tags { };

  language-tool-python = callPackage ./non-by-name/language-tool-python { };

  lanms-neo = callPackage ./non-by-name/lanms-neo { };

  lap = callPackage ./non-by-name/lap { };

  lark = callPackage ./non-by-name/lark { };

  lark-oapi = callPackage ./non-by-name/lark-oapi { };

  laspy = callPackage ./non-by-name/laspy { };

  lastversion = callPackage ./non-by-name/lastversion { };

  laszip = callPackage ./non-by-name/laszip {
    inherit (pkgs) cmake ninja;
    inherit (pkgs.__splicedPackages) laszip;
  };

  latex2mathml = callPackage ./non-by-name/latex2mathml { };

  latex2pydata = callPackage ./non-by-name/latex2pydata { };

  latexcodec = callPackage ./non-by-name/latexcodec { };

  latexify-py = callPackage ./non-by-name/latexify-py { };

  latexrestricted = callPackage ./non-by-name/latexrestricted { };

  launchpadlib = callPackage ./non-by-name/launchpadlib { };

  laundrify-aio = callPackage ./non-by-name/laundrify-aio { };

  layoutparser = callPackage ./non-by-name/layoutparser { };

  lazr-config = callPackage ./non-by-name/lazr-config { };

  lazr-delegates = callPackage ./non-by-name/lazr-delegates { };

  lazr-restfulclient = callPackage ./non-by-name/lazr-restfulclient { };

  lazr-uri = callPackage ./non-by-name/lazr-uri { };

  lazrs = callPackage ./non-by-name/lazrs { };

  lazy = callPackage ./non-by-name/lazy { };

  lazy-imports = callPackage ./non-by-name/lazy-imports { };

  lazy-loader = callPackage ./non-by-name/lazy-loader { };

  lazy-object-proxy = callPackage ./non-by-name/lazy-object-proxy { };

  lb-matching-tools = callPackage ./non-by-name/lb-matching-tools { };

  lbox-clients = callPackage ./non-by-name/lbox-clients { };

  lc7001 = callPackage ./non-by-name/lc7001 { };

  lcd-i2c = callPackage ./non-by-name/lcd-i2c { };

  lcgit = callPackage ./non-by-name/lcgit { };

  lcn-frontend = callPackage ./non-by-name/lcn-frontend { };

  lcov-cobertura = callPackage ./non-by-name/lcov-cobertura { };

  ld2410-ble = callPackage ./non-by-name/ld2410-ble { };

  ldap3 = callPackage ./non-by-name/ldap3 { };

  ldap3-ad-auth = callPackage ./non-by-name/ldap3-ad-auth { };

  ldap3-bleeding-edge = callPackage ./non-by-name/ldap3-bleeding-edge { };

  ldapdomaindump = callPackage ./non-by-name/ldapdomaindump { };

  ldappool = callPackage ./non-by-name/ldappool { };

  ldaptor = callPackage ./non-by-name/ldaptor { };

  ldfparser = callPackage ./non-by-name/ldfparser { };

  leanblueprint = callPackage ./non-by-name/leanblueprint { };

  leanclient = callPackage ./non-by-name/leanclient { };

  leaone-ble = callPackage ./non-by-name/leaone-ble { };

  leather = callPackage ./non-by-name/leather { };

  leb128 = callPackage ./non-by-name/leb128 { };

  led-ble = callPackage ./non-by-name/led-ble { };

  ledger =
    (toPythonModule (
      pkgs.ledger.override {
        usePython = true;
        python3 = python;
      }
    )).py;

  ledger-bitcoin = callPackage ./non-by-name/ledger-bitcoin { };

  ledgerblue = callPackage ./non-by-name/ledgerblue { };

  ledgercomm = callPackage ./non-by-name/ledgercomm { };

  ledgerwallet = callPackage ./non-by-name/ledgerwallet { };

  legacy-api-wrap = callPackage ./non-by-name/legacy-api-wrap { };

  legacy-cgi = if pythonOlder "3.13" then null else callPackage ./non-by-name/legacy-cgi { };

  leidenalg = callPackage ./non-by-name/leidenalg { igraph-c = pkgs.igraph; };

  lektricowifi = callPackage ./non-by-name/lektricowifi { };

  lerobot = callPackage ./non-by-name/lerobot { };

  lesscpy = toPythonModule (pkgs.lesscpy.override { python3Packages = self; });

  letpot = callPackage ./non-by-name/letpot { };

  leveldb = callPackage ./non-by-name/leveldb { };

  levenshtein = callPackage ./non-by-name/levenshtein { };

  lexid = callPackage ./non-by-name/lexid { };

  lexilang = callPackage ./non-by-name/lexilang { };

  lg-rs232-tv = callPackage ./non-by-name/lg-rs232-tv { };

  lgpio = toPythonModule (
    pkgs.lgpio.override {
      inherit buildPythonPackage;
      pyProject = "PY_LGPIO";
      lgpioWithoutPython = pkgs.lgpio;
    }
  );

  lhapdf = toPythonModule (pkgs.lhapdf.override { python3 = python; });

  lhpapi = callPackage ./non-by-name/lhpapi { };

  lib4package = callPackage ./non-by-name/lib4package { };

  lib4sbom = callPackage ./non-by-name/lib4sbom { };

  lib4vex = callPackage ./non-by-name/lib4vex { };

  lib50 = callPackage ./non-by-name/lib50 { };

  libagent = callPackage ./non-by-name/libagent { };

  libais = callPackage ./non-by-name/libais { };

  libapparmor = callPackage (
    {
      python,
      pythonImportsCheckHook,
      setuptools,
    }@python3Packages:
    toPythonModule (
      pkgs.libapparmor.override {
        inherit python3Packages;
      }
    )
  ) { };

  libarchive-c = callPackage ./non-by-name/libarchive-c {
    inherit (pkgs) libarchive;
  };

  libasyncns = callPackage ./non-by-name/libasyncns { inherit (pkgs) libasyncns; };

  libcap_ng = callPackage (
    {
      python,
      pythonImportsCheckHook,
      libcap_ng, # for python3Packages.libcap_ng.tests.python passthru
    }@python3Packages:
    toPythonModule (
      pkgs.libcap_ng.override {
        withPython = true;
        inherit python3Packages;
      }
    )
  ) { };

  libcec =
    (toPythonModule (
      pkgs.libcec.override {
        python3 = python;
        pythonSupport = true;
      }
    )).python;

  libcloud = callPackage ./non-by-name/libcloud { };

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

  libcst = callPackage ./non-by-name/libcst { };

  libdebug = callPackage ./non-by-name/libdebug { inherit (pkgs) zstd; };

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

  libear = callPackage ./non-by-name/libear { };

  liberty-parser = callPackage ./non-by-name/liberty-parser { };

  libevdev = callPackage ./non-by-name/libevdev { };

  libfdt = toPythonModule (
    pkgs.dtc.override {
      inherit python;
      pythonSupport = true;
    }
  );

  libfive = toPythonModule (pkgs.libfive.override { python3 = python; });

  libgravatar = callPackage ./non-by-name/libgravatar { };

  libiio =
    (toPythonModule (
      pkgs.libiio.override {
        pythonSupport = true;
        python3 = python;
      }
    )).python;

  libipld = callPackage ./non-by-name/libipld { };

  libkeepass = callPackage ./non-by-name/libkeepass { };

  libknot = callPackage ./non-by-name/libknot { };

  liblarch = callPackage ./non-by-name/liblarch { };

  liblistenbrainz = callPackage ./non-by-name/liblistenbrainz { };

  libloot = callPackage ./non-by-name/libloot {
    libloot-native = pkgs.libloot;
  };

  liblp = callPackage ./non-by-name/liblp { };

  liblzfse = callPackage ./non-by-name/liblzfse { inherit (pkgs) lzfse; };

  libmambapy = callPackage ./non-by-name/libmambapy { };

  libmobility = callPackage ./non-by-name/libmobility { };

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

  libmr = callPackage ./non-by-name/libmr { };

  libnacl = callPackage ./non-by-name/libnacl { inherit (pkgs) libsodium; };

  libnbd = toPythonModule (
    pkgs.libnbd.override {
      buildPythonBindings = true;
      python3 = python;
    }
  );

  libpass = callPackage ./non-by-name/libpass { };

  libpcap = callPackage ./non-by-name/libpcap {
    pkgsLibpcap = pkgs.libpcap; # Needs the C library
  };

  libpulse = callPackage ./non-by-name/libpulse { };

  libpurecool = callPackage ./non-by-name/libpurecool { };

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

  libpyfoscamcgi = callPackage ./non-by-name/libpyfoscamcgi { };

  libpysal = callPackage ./non-by-name/libpysal { };

  libpyvivotek = callPackage ./non-by-name/libpyvivotek { };

  libredwg = toPythonModule (
    pkgs.libredwg.override {
      enablePython = true;
      inherit (self) python libxml2;
    }
  );

  librehardwaremonitor-api = callPackage ./non-by-name/librehardwaremonitor-api { };

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

  librespot = callPackage ./non-by-name/librespot { };

  libretranslate = callPackage ./non-by-name/libretranslate { };

  librosa = callPackage ./non-by-name/librosa { };

  librouteros = callPackage ./non-by-name/librouteros { };

  librt = callPackage ./non-by-name/librt { };

  libsass = callPackage ./non-by-name/libsass { inherit (pkgs) libsass; };

  libsast = callPackage ./non-by-name/libsast { };

  libsavitar = callPackage ./non-by-name/libsavitar { };

  libsbml = toPythonModule (
    pkgs.libsbml.override {
      withPython = true;
      inherit (self) python;
    }
  );

  libscanbuild = callPackage ./non-by-name/libscanbuild { };

  libselinux = lib.pipe pkgs.libselinux [
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
        python3Packages = self;
      }
    )
    (p: p.py)
  ];

  libsixel = callPackage ./non-by-name/libsixel { inherit (pkgs) libsixel; };

  libsoundtouch = callPackage ./non-by-name/libsoundtouch { };

  libsupermesh = callPackage ./non-by-name/libsupermesh { };

  libtfr = callPackage ./non-by-name/libtfr { };

  libthumbor = callPackage ./non-by-name/libthumbor { };

  libtmux = callPackage ./non-by-name/libtmux { };

  libtorrent-rasterbar =
    (toPythonModule (pkgs.libtorrent-rasterbar.override { python3 = python; })).python;

  libusb-package = callPackage ./non-by-name/libusb-package {
    inherit (pkgs) libusb1;
  };

  libusb1 = callPackage ./non-by-name/libusb1 { inherit (pkgs) libusb1; };

  libusbsio = callPackage ./non-by-name/libusbsio { inherit (pkgs) libusbsio; };

  libuuu = callPackage ./non-by-name/libuuu { };

  libvalkey = callPackage ./non-by-name/libvalkey { };

  libversion = callPackage ./non-by-name/libversion { inherit (pkgs) libversion; };

  libvirt-python = callPackage ./non-by-name/libvirt-python {
    inherit (pkgs) libvirt;
  };

  libxc = callPackage ../../by-name/li/libxc/python.nix {
    libxc = pkgs.libxc_7;
  };

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

  libzfs = callPackage ./non-by-name/libzfs { };

  liccheck = callPackage ./non-by-name/liccheck { };

  license-expression = callPackage ./non-by-name/license-expression { };

  licomp = callPackage ./non-by-name/licomp { };

  licomp-doubleopen = callPackage ./non-by-name/licomp-doubleopen { };

  licomp-dwheeler = callPackage ./non-by-name/licomp-dwheeler { };

  licomp-gnuguide = callPackage ./non-by-name/licomp-gnuguide { };

  licomp-hermione = callPackage ./non-by-name/licomp-hermione { };

  licomp-osadl = callPackage ./non-by-name/licomp-osadl { };

  licomp-oslc-handbook = callPackage ./non-by-name/licomp-oslc-handbook { };

  licomp-proprietary = callPackage ./non-by-name/licomp-proprietary { };

  licomp-reclicense = callPackage ./non-by-name/licomp-reclicense { };

  licomp-toolkit = callPackage ./non-by-name/licomp-toolkit { };

  lida = callPackage ./non-by-name/lida { };

  lief = (toPythonModule (pkgs.lief.override { python3 = python; })).py;

  life360 = callPackage ./non-by-name/life360 { };

  lifelines = callPackage ./non-by-name/lifelines { };

  lifx-async = callPackage ./non-by-name/lifx-async { };

  lifx-emulator-core = callPackage ./non-by-name/lifx-emulator-core { };

  liger-kernel = callPackage ./non-by-name/liger-kernel { };

  lightgbm = callPackage ./non-by-name/lightgbm { };

  lighthouse-ble = callPackage ./non-by-name/lighthouse-ble { };

  lightify = callPackage ./non-by-name/lightify { };

  lightning = callPackage ./non-by-name/lightning { };

  lightning-utilities = callPackage ./non-by-name/lightning-utilities { };

  lightparam = callPackage ./non-by-name/lightparam { };

  lightwave = callPackage ./non-by-name/lightwave { };

  lightwave2 = callPackage ./non-by-name/lightwave2 { };

  lima = callPackage ./non-by-name/lima { };

  lime = callPackage ./non-by-name/lime { };

  limiter = callPackage ./non-by-name/limiter { };

  limitlessled = callPackage ./non-by-name/limitlessled { };

  limits = callPackage ./non-by-name/limits { };

  limnoria = callPackage ./non-by-name/limnoria { };

  line-profiler = callPackage ./non-by-name/line-profiler { };

  linear-operator = callPackage ./non-by-name/linear-operator { };

  linearmodels = callPackage ./non-by-name/linearmodels { };

  lineax = callPackage ./non-by-name/lineax { };

  linecache2 = callPackage ./non-by-name/linecache2 { };

  lineedit = callPackage ./non-by-name/lineedit { };

  linetable = callPackage ./non-by-name/linetable { };

  lingua = callPackage ./non-by-name/lingua { };

  lingva = callPackage ./non-by-name/lingva { };

  linien-client = callPackage ./non-by-name/linien-client { };

  linien-common = callPackage ./non-by-name/linien-common { };

  linkify-it-py = callPackage ./non-by-name/linkify-it-py { };

  linknlink = callPackage ./non-by-name/linknlink { };

  linode = callPackage ./non-by-name/linode { };

  linode-api = callPackage ./non-by-name/linode-api { };

  linode-api4 = callPackage ./non-by-name/linode-api4 { };

  linode-metadata = callPackage ./non-by-name/linode-metadata { };

  linuxdoc = callPackage ./non-by-name/linuxdoc { };

  linuxfd = callPackage ./non-by-name/linuxfd { };

  linuxpy = callPackage ./non-by-name/linuxpy { };

  lion-pytorch = callPackage ./non-by-name/lion-pytorch { };

  liquidctl = callPackage ./non-by-name/liquidctl { };

  lirc = toPythonModule (pkgs.lirc.override { python3 = python; });

  lit = callPackage ./non-by-name/lit { };

  litecli = callPackage ./non-by-name/litecli { };

  litellm = callPackage ./non-by-name/litellm { };

  litellm-proxy-extras = callPackage ./non-by-name/litellm-proxy-extras { };

  litemapy = callPackage ./non-by-name/litemapy { };

  litestar = callPackage ./non-by-name/litestar { };

  litestar-htmx = callPackage ./non-by-name/litestar-htmx { };

  littleutils = callPackage ./non-by-name/littleutils { };

  livekit-api = callPackage ./non-by-name/livekit-api { };

  livekit-protocol = callPackage ./non-by-name/livekit-protocol { };

  livelossplot = callPackage ./non-by-name/livelossplot { };

  livereload = callPackage ./non-by-name/livereload { };

  livisi = callPackage ./non-by-name/livisi { };

  lizard = callPackage ./non-by-name/lizard { };

  llama-cloud = callPackage ./non-by-name/llama-cloud { };

  llama-cpp-python = callPackage ./non-by-name/llama-cpp-python { };

  llama-index = callPackage ./non-by-name/llama-index { };

  llama-index-cli = callPackage ./non-by-name/llama-index-cli { };

  llama-index-core = callPackage ./non-by-name/llama-index-core { };

  llama-index-embeddings-google-genai =
    callPackage ./non-by-name/llama-index-embeddings-google-genai
      { };

  llama-index-embeddings-huggingface =
    callPackage ./non-by-name/llama-index-embeddings-huggingface
      { };

  llama-index-embeddings-ollama = callPackage ./non-by-name/llama-index-embeddings-ollama { };

  llama-index-embeddings-openai = callPackage ./non-by-name/llama-index-embeddings-openai { };

  llama-index-embeddings-openai-like =
    callPackage ./non-by-name/llama-index-embeddings-openai-like
      { };

  llama-index-graph-stores-nebula = callPackage ./non-by-name/llama-index-graph-stores-nebula { };

  llama-index-graph-stores-neo4j = callPackage ./non-by-name/llama-index-graph-stores-neo4j { };

  llama-index-graph-stores-neptune = callPackage ./non-by-name/llama-index-graph-stores-neptune { };

  llama-index-instrumentation = callPackage ./non-by-name/llama-index-instrumentation { };

  llama-index-legacy = callPackage ./non-by-name/llama-index-legacy { };

  llama-index-llms-ollama = callPackage ./non-by-name/llama-index-llms-ollama { };

  llama-index-llms-openai = callPackage ./non-by-name/llama-index-llms-openai { };

  llama-index-llms-openai-like = callPackage ./non-by-name/llama-index-llms-openai-like { };

  llama-index-node-parser-docling = callPackage ./non-by-name/llama-index-node-parser-docling { };

  llama-index-readers-database = callPackage ./non-by-name/llama-index-readers-database { };

  llama-index-readers-docling = callPackage ./non-by-name/llama-index-readers-docling { };

  llama-index-readers-file = callPackage ./non-by-name/llama-index-readers-file { };

  llama-index-readers-json = callPackage ./non-by-name/llama-index-readers-json { };

  llama-index-readers-s3 = callPackage ./non-by-name/llama-index-readers-s3 { };

  llama-index-readers-twitter = callPackage ./non-by-name/llama-index-readers-twitter { };

  llama-index-readers-txtai = callPackage ./non-by-name/llama-index-readers-txtai { };

  llama-index-readers-weather = callPackage ./non-by-name/llama-index-readers-weather { };

  llama-index-vector-stores-chroma = callPackage ./non-by-name/llama-index-vector-stores-chroma { };

  llama-index-vector-stores-faiss = callPackage ./non-by-name/llama-index-vector-stores-faiss { };

  llama-index-vector-stores-google = callPackage ./non-by-name/llama-index-vector-stores-google { };

  llama-index-vector-stores-milvus = callPackage ./non-by-name/llama-index-vector-stores-milvus { };

  llama-index-vector-stores-postgres =
    callPackage ./non-by-name/llama-index-vector-stores-postgres
      { };

  llama-index-vector-stores-qdrant = callPackage ./non-by-name/llama-index-vector-stores-qdrant { };

  llama-index-workflows = callPackage ./non-by-name/llama-index-workflows { };

  llama-stack-client = callPackage ./non-by-name/llama-stack-client { };

  llguidance = callPackage ./non-by-name/llguidance { };

  llm = callPackage ./non-by-name/llm { };

  llm-all-models-async = callPackage ./non-by-name/llm-all-models-async { };

  llm-anthropic = callPackage ./non-by-name/llm-anthropic { };

  llm-cmd = callPackage ./non-by-name/llm-cmd { };

  llm-cmd-comp = callPackage ./non-by-name/llm-cmd-comp { };

  llm-command-r = callPackage ./non-by-name/llm-command-r { };

  llm-deepseek = callPackage ./non-by-name/llm-deepseek { };

  llm-docs = callPackage ./non-by-name/llm-docs { };

  llm-echo = callPackage ./non-by-name/llm-echo { };

  llm-fragments-github = callPackage ./non-by-name/llm-fragments-github { };

  llm-fragments-pdf = callPackage ./non-by-name/llm-fragments-pdf { };

  llm-fragments-pypi = callPackage ./non-by-name/llm-fragments-pypi { };

  llm-fragments-reader = callPackage ./non-by-name/llm-fragments-reader { };

  llm-fragments-site-text = callPackage ./non-by-name/llm-fragments-site-text { };

  llm-fragments-symbex = callPackage ./non-by-name/llm-fragments-symbex { };

  llm-gemini = callPackage ./non-by-name/llm-gemini { };

  llm-gguf = callPackage ./non-by-name/llm-gguf { };

  llm-git = callPackage ./non-by-name/llm-git { };

  llm-github-copilot = callPackage ./non-by-name/llm-github-copilot { };

  llm-grok = callPackage ./non-by-name/llm-grok { };

  llm-groq = callPackage ./non-by-name/llm-groq { };

  llm-hacker-news = callPackage ./non-by-name/llm-hacker-news { };

  llm-jq = callPackage ./non-by-name/llm-jq { };

  llm-keys-ui = callPackage ./non-by-name/llm-keys-ui { };

  llm-llama-server = callPackage ./non-by-name/llm-llama-server { };

  llm-lmstudio = callPackage ./non-by-name/llm-lmstudio { };

  llm-mcp-client = callPackage ./non-by-name/llm-mcp-client { };

  llm-meta-ai = callPackage ./non-by-name/llm-meta-ai { };

  llm-mistral = callPackage ./non-by-name/llm-mistral { };

  llm-ollama = callPackage ./non-by-name/llm-ollama { };

  llm-openai-decisions = callPackage ./non-by-name/llm-openai-decisions { };

  llm-openai-plugin = callPackage ./non-by-name/llm-openai-plugin { };

  llm-openrouter = callPackage ./non-by-name/llm-openrouter { };

  llm-pdf-to-images = callPackage ./non-by-name/llm-pdf-to-images { };

  llm-perplexity = callPackage ./non-by-name/llm-perplexity { };

  llm-public-ai = callPackage ./non-by-name/llm-public-ai { };

  llm-sandbox = callPackage ./non-by-name/llm-sandbox { };

  llm-sentence-transformers = callPackage ./non-by-name/llm-sentence-transformers { };

  llm-templates-fabric = callPackage ./non-by-name/llm-templates-fabric { };

  llm-templates-github = callPackage ./non-by-name/llm-templates-github { };

  llm-tools-datasette = callPackage ./non-by-name/llm-tools-datasette { };

  llm-tools-edit = callPackage ./non-by-name/llm-tools-edit { };

  llm-tools-exa = callPackage ./non-by-name/llm-tools-exa { };

  llm-tools-quickjs = callPackage ./non-by-name/llm-tools-quickjs { };

  llm-tools-rag = callPackage ./non-by-name/llm-tools-rag { };

  llm-tools-simpleeval = callPackage ./non-by-name/llm-tools-simpleeval { };

  llm-tools-sqlite = callPackage ./non-by-name/llm-tools-sqlite { };

  llm-venice = callPackage ./non-by-name/llm-venice { };

  llm-video-frames = callPackage ./non-by-name/llm-video-frames { };

  llmx = callPackage ./non-by-name/llmx { };

  lln-libparse = callPackage ./non-by-name/lln-libparse/package.nix { };

  llvmlite = callPackage ./non-by-name/llvmlite {
    inherit (pkgs) cmake ninja;
  };

  lm-eval = callPackage ./non-by-name/lm-eval { };

  lm-format-enforcer = callPackage ./non-by-name/lm-format-enforcer { };

  lmdb = callPackage ./non-by-name/lmdb { inherit (pkgs) lmdb; };

  lmfit = callPackage ./non-by-name/lmfit { };

  lml = callPackage ./non-by-name/lml { };

  lmnotify = callPackage ./non-by-name/lmnotify { };

  lmstudio = callPackage ./non-by-name/lmstudio { };

  lmtpd = callPackage ./non-by-name/lmtpd { };

  lnkparse3 = callPackage ./non-by-name/lnkparse3 { };

  loca = callPackage ./non-by-name/loca { };

  local-attention = callPackage ./non-by-name/local-attention { };

  localimport = callPackage ./non-by-name/localimport { };

  localstack-client = callPackage ./non-by-name/localstack-client { };

  localstack-ext = callPackage ./non-by-name/localstack-ext { };

  localzone = callPackage ./non-by-name/localzone { };

  locate = callPackage ./non-by-name/locate { };

  locationsharinglib = callPackage ./non-by-name/locationsharinglib { };

  locket = callPackage ./non-by-name/locket { };

  lockfile = callPackage ./non-by-name/lockfile { };

  locust = callPackage ./non-by-name/locust { };

  locust-cloud = callPackage ./non-by-name/locust-cloud { };

  log-symbols = callPackage ./non-by-name/log-symbols { };

  logbook = callPackage ./non-by-name/logbook { };

  logboth = callPackage ./non-by-name/logboth { };

  logfire = callPackage ./non-by-name/logfire { };

  logfire-api = callPackage ./non-by-name/logfire-api { };

  logfury = callPackage ./non-by-name/logfury { };

  logging-journald = callPackage ./non-by-name/logging-journald { };

  logging-tree = callPackage ./non-by-name/logging-tree { };

  logic2-automation = callPackage ./non-by-name/logic2-automation { };

  logica = callPackage ./non-by-name/logica { };

  logical-unification = callPackage ./non-by-name/logical-unification { };

  logilab-common = callPackage ./non-by-name/logilab/common.nix {
    pytestCheckHook = pytest7CheckHook;
  };

  logilab-constraint = callPackage ./non-by-name/logilab/constraint.nix { };

  logistro = callPackage ./non-by-name/logistro { };

  logmatic-python = callPackage ./non-by-name/logmatic-python { };

  logster = callPackage ./non-by-name/logster { };

  logurich = callPackage ./non-by-name/logurich { };

  loguru = callPackage ./non-by-name/loguru { };

  loguru-logging-intercept = callPackage ./non-by-name/loguru-logging-intercept { };

  logutils = callPackage ./non-by-name/logutils { };

  logzero = callPackage ./non-by-name/logzero { };

  lojack-api = callPackage ./non-by-name/lojack-api { };

  loky = callPackage ./non-by-name/loky { };

  lomond = callPackage ./non-by-name/lomond { };

  london-tube-status = callPackage ./non-by-name/london-tube-status { };

  lookup-license = callPackage ./non-by-name/lookup-license { };

  lookyloo-models = callPackage ./non-by-name/lookyloo-models { };

  loompy = callPackage ./non-by-name/loompy { };

  looptime = callPackage ./non-by-name/looptime { };

  loopy = callPackage ./non-by-name/loopy { };

  looseversion = callPackage ./non-by-name/looseversion { };

  loqedapi = callPackage ./non-by-name/loqedapi { };

  lorawan-connection = callPackage ./non-by-name/lorawan-connection { };

  loro = callPackage ./non-by-name/loro { };

  losant-rest = callPackage ./non-by-name/losant-rest { };

  lottie = callPackage ./non-by-name/lottie { };

  low-index = callPackage ./non-by-name/low-index { };

  lox = callPackage ./non-by-name/lox { };

  lpc-checksum = callPackage ./non-by-name/lpc-checksum { };

  lpips = callPackage ./non-by-name/lpips { };

  lrcalc-python = callPackage ./non-by-name/lrcalc-python { };

  lrclibapi = callPackage ./non-by-name/lrclibapi { };

  lru-dict = callPackage ./non-by-name/lru-dict { };

  lsassy = callPackage ./non-by-name/lsassy { };

  lsp-tree-sitter = callPackage ./non-by-name/lsp-tree-sitter { };

  lsprotocol = callPackage ./non-by-name/lsprotocol { };

  lsprotocol_2023 = callPackage ./non-by-name/lsprotocol/2023.nix { };

  ltpycld2 = callPackage ./non-by-name/ltpycld2 { };

  lttng = callPackage ./non-by-name/lttng { };

  luddite = callPackage ./non-by-name/luddite { };

  luftdaten = callPackage ./non-by-name/luftdaten { };

  luhn = callPackage ./non-by-name/luhn { };

  luigi = callPackage ./non-by-name/luigi { };

  luma-core = callPackage ./non-by-name/luma-core { };

  luna-soc = callPackage ./non-by-name/luna-soc { };

  luna-usb = callPackage ./non-by-name/luna-usb { };

  lunarcalendar = callPackage ./non-by-name/lunarcalendar { };

  lunatone-rest-api-client = callPackage ./non-by-name/lunatone-rest-api-client { };

  lupa = callPackage ./non-by-name/lupa { };

  lupupy = callPackage ./non-by-name/lupupy { };

  luqum = callPackage ./non-by-name/luqum { };

  luxtronik = callPackage ./non-by-name/luxtronik { };

  lw12 = callPackage ./non-by-name/lw12 { };

  lxmf = callPackage ./non-by-name/lxmf { };

  lxml = callPackage ./non-by-name/lxml { inherit (pkgs) libxml2 libxslt zlib; };

  lxml-html-clean = callPackage ./non-by-name/lxml-html-clean { };

  lxst = callPackage ./non-by-name/lxst { };

  lyngdorf = callPackage ./non-by-name/lyngdorf { };

  lyricwikia = callPackage ./non-by-name/lyricwikia { };

  lz4 = callPackage ./non-by-name/lz4 { };

  lzallright = callPackage ./non-by-name/lzallright { };

  lzfse = callPackage ./non-by-name/lzfse { };

  m2crypto = callPackage ./non-by-name/m2crypto { };

  m3u8 = callPackage ./non-by-name/m3u8 { };

  mac-alias = callPackage ./non-by-name/mac-alias { };

  mac-vendor-lookup = callPackage ./non-by-name/mac-vendor-lookup { };

  macaddress = callPackage ./non-by-name/macaddress { };

  mace-torch = callPackage ./non-by-name/mace-torch { };

  macfsevents = callPackage ./non-by-name/macfsevents { };

  macholib = callPackage ./non-by-name/macholib { };

  maec = callPackage ./non-by-name/maec { };

  maestral = callPackage ./non-by-name/maestral { };

  magic = callPackage ./non-by-name/magic { };

  magic-filter = callPackage ./non-by-name/magic-filter { };

  magic-wormhole = callPackage ./non-by-name/magic-wormhole { };

  magic-wormhole-mailbox-server = callPackage ./non-by-name/magic-wormhole-mailbox-server { };

  magic-wormhole-transit-relay = callPackage ./non-by-name/magic-wormhole-transit-relay { };

  magicgui = callPackage ./non-by-name/magicgui { };

  magika = callPackage ./non-by-name/magika { };

  mahotas = callPackage ./non-by-name/mahotas { };

  maia3 = callPackage ./non-by-name/maia3 { };

  mail-parser = callPackage ./non-by-name/mail-parser { };

  mailbits = callPackage ./non-by-name/mailbits { };

  mailcap-fix = callPackage ./non-by-name/mailcap-fix { };

  mailchecker = callPackage ./non-by-name/mailchecker { };

  mailchimp = callPackage ./non-by-name/mailchimp { };

  mailmanclient = callPackage ./non-by-name/mailmanclient { };

  mailsuite = callPackage ./non-by-name/mailsuite { };

  maison = callPackage ./non-by-name/maison { };

  makefun = callPackage ./non-by-name/makefun { };

  mako = callPackage ./non-by-name/mako { };

  malduck = callPackage ./non-by-name/malduck { };

  mamba-ssm = callPackage ./non-by-name/mamba-ssm { };

  mammoth = callPackage ./non-by-name/mammoth { };

  managesieve = callPackage ./non-by-name/managesieve { };

  mando = callPackage ./non-by-name/mando { };

  mandown = callPackage ./non-by-name/mandown { };

  manga-ocr = callPackage ./non-by-name/manga-ocr { };

  manhole = callPackage ./non-by-name/manhole { };

  manifest-ml = callPackage ./non-by-name/manifest-ml { };

  manifestoo = callPackage ./non-by-name/manifestoo { };

  manifestoo-core = callPackage ./non-by-name/manifestoo-core { };

  manifestparser = callPackage ./non-by-name/marionette-harness/manifestparser.nix { };

  manifold3d = callPackage ./non-by-name/manifold3d { };

  manim = callPackage ./non-by-name/manim { };

  manim-slides = callPackage ./non-by-name/manim-slides { };

  manimgl = callPackage ./non-by-name/manimgl { };

  manimpango = callPackage ./non-by-name/manimpango { };

  manuel = callPackage ./non-by-name/manuel { };

  manuf = callPackage ./non-by-name/manuf { };

  mapbox-earcut = callPackage ./non-by-name/mapbox-earcut { };

  mapclassify = callPackage ./non-by-name/mapclassify { };

  marantz-rs232 = callPackage ./non-by-name/marantz-rs232 { };

  mariadb = callPackage ./non-by-name/mariadb { };

  marimo = callPackage ./non-by-name/marimo { };

  marisa = callPackage ./non-by-name/marisa { inherit (pkgs) marisa; };

  marisa-trie = callPackage ./non-by-name/marisa-trie {
    marisa-cpp = pkgs.marisa;
  };

  markdown = callPackage ./non-by-name/markdown { };

  markdown-include = callPackage ./non-by-name/markdown-include { };

  markdown-inline-graphviz-extension =
    callPackage ./non-by-name/markdown-inline-graphviz-extension
      { };

  markdown-it-py = callPackage ./non-by-name/markdown-it-py { };

  markdown-macros = callPackage ./non-by-name/markdown-macros { };

  markdown2 = callPackage ./non-by-name/markdown2 { };

  markdownify = callPackage ./non-by-name/markdownify { };

  markitdown = callPackage ./non-by-name/markitdown { };

  marklas = callPackage ./non-by-name/marklas { };

  marko = callPackage ./non-by-name/marko { };

  markovify = callPackage ./non-by-name/markovify { };

  markuppy = callPackage ./non-by-name/markuppy { };

  markups = callPackage ./non-by-name/markups { };

  markupsafe = callPackage ./non-by-name/markupsafe { };

  marqo = callPackage ./non-by-name/marqo { };

  marshmallow = callPackage ./non-by-name/marshmallow { };

  marshmallow-dataclass = callPackage ./non-by-name/marshmallow-dataclass { };

  marshmallow-oneofschema = callPackage ./non-by-name/marshmallow-oneofschema { };

  marshmallow-polyfield = callPackage ./non-by-name/marshmallow-polyfield { };

  marshmallow-sqlalchemy = callPackage ./non-by-name/marshmallow-sqlalchemy { };

  mashumaro = callPackage ./non-by-name/mashumaro { };

  masky = callPackage ./non-by-name/masky { };

  mastodon-py = callPackage ./non-by-name/mastodon-py { };

  mat2 = callPackage ./non-by-name/mat2 { };

  matchpy = callPackage ./non-by-name/matchpy { };

  material-color-utilities = callPackage ./non-by-name/material-color-utilities { };

  materialx = toPythonModule (
    pkgs.materialx.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  materialyoucolor = callPackage ./non-by-name/materialyoucolor { };

  mathutils = callPackage ./non-by-name/mathutils { };

  matplotlib = callPackage ./non-by-name/matplotlib {
    stdenv = if stdenv.hostPlatform.isDarwin then pkgs.clangStdenv else pkgs.stdenv;
  };

  matplotlib-inline = callPackage ./non-by-name/matplotlib-inline { };

  matplotlib-sixel = callPackage ./non-by-name/matplotlib-sixel { };

  matplotlib-venn = callPackage ./non-by-name/matplotlib-venn { };

  matplotx = callPackage ./non-by-name/matplotx { };

  matrix-client = callPackage ./non-by-name/matrix-client { };

  matrix-common = callPackage ./non-by-name/matrix-common { };

  matrix-nio = callPackage ./non-by-name/matrix-nio { };

  matscipy = callPackage ./non-by-name/matscipy { };

  matter-ble-proxy = callPackage ./non-by-name/matter-ble-proxy { };

  matter-python-client = callPackage ./non-by-name/matter-python-client { };

  mattermostdriver = callPackage ./non-by-name/mattermostdriver { };

  mautrix = callPackage ./non-by-name/mautrix { };

  mautrix-appservice = self.mautrix; # alias 2019-12-28

  maxcube-api = callPackage ./non-by-name/maxcube-api { };

  maxminddb = callPackage ./non-by-name/maxminddb { };

  maya = callPackage ./non-by-name/maya { };

  mayavi = callPackage ./non-by-name/mayavi { };

  mayim = callPackage ./non-by-name/mayim { };

  mbddns = callPackage ./non-by-name/mbddns { };

  mbstrdecoder = callPackage ./non-by-name/mbstrdecoder { };

  mccabe = callPackage ./non-by-name/mccabe { };

  mcdreforged = callPackage ./non-by-name/mcdreforged { };

  mcp = callPackage ./non-by-name/mcp { };

  mcp-types = callPackage ./non-by-name/mcp-types { };

  mcp_1 = callPackage ./non-by-name/mcp/1.nix { };

  mcpadapt = callPackage ./non-by-name/mcpadapt { };

  mcstatus = callPackage ./non-by-name/mcstatus { };

  mcuuid = callPackage ./non-by-name/mcuuid { };

  md-toc = callPackage ./non-by-name/md-toc { };

  md2gemini = callPackage ./non-by-name/md2gemini { };

  md2pdf = callPackage ./non-by-name/md2pdf { };

  mdformat = callPackage ./non-by-name/mdformat { };

  mdformat-admon = callPackage ./non-by-name/mdformat-admon { };

  mdformat-beautysh = callPackage ./non-by-name/mdformat-beautysh { };

  mdformat-footnote = callPackage ./non-by-name/mdformat-footnote { };

  mdformat-front-matters = callPackage ./non-by-name/mdformat-front-matters { };

  mdformat-frontmatter = callPackage ./non-by-name/mdformat-frontmatter { };

  mdformat-gfm = callPackage ./non-by-name/mdformat-gfm { };

  mdformat-gfm-alerts = callPackage ./non-by-name/mdformat-gfm-alerts { };

  mdformat-mkdocs = callPackage ./non-by-name/mdformat-mkdocs { };

  mdformat-myst = callPackage ./non-by-name/mdformat-myst { };

  mdformat-nix-alejandra = callPackage ./non-by-name/mdformat-nix-alejandra { };

  mdformat-simple-breaks = callPackage ./non-by-name/mdformat-simple-breaks { };

  mdformat-toc = callPackage ./non-by-name/mdformat-toc { };

  mdformat-wikilink = callPackage ./non-by-name/mdformat-wikilink { };

  mdit-py-plugins = callPackage ./non-by-name/mdit-py-plugins { };

  mdtraj = callPackage ./non-by-name/mdtraj { };

  mdurl = callPackage ./non-by-name/mdurl { };

  mdutils = callPackage ./non-by-name/mdutils { };

  mdx-breakless-lists = callPackage ./non-by-name/mdx-breakless-lists { };

  mdx-truly-sane-lists = callPackage ./non-by-name/mdx-truly-sane-lists { };

  mdx-wikilink-plus = callPackage ./non-by-name/mdx-wikilink-plus { };

  mean-average-precision = callPackage ./non-by-name/mean-average-precision { };

  measurement = callPackage ./non-by-name/measurement { };

  meater-python = callPackage ./non-by-name/meater-python { };

  mecab-python3 = callPackage ./non-by-name/mecab-python3 { };

  mechanicalsoup = callPackage ./non-by-name/mechanicalsoup { };

  mechanize = callPackage ./non-by-name/mechanize { };

  medallion = callPackage ./non-by-name/medallion { };

  medcom-ble = callPackage ./non-by-name/medcom-ble { };

  mediafile = callPackage ./non-by-name/mediafile { };

  mediapy = callPackage ./non-by-name/mediapy { };

  mediawiki-langcodes = callPackage ./non-by-name/mediawiki-langcodes { };

  medpy = callPackage ./non-by-name/medpy { };

  medvol = callPackage ./non-by-name/medvol { };

  meeko = callPackage ./non-by-name/meeko { };

  meep = callPackage ./non-by-name/meep { };

  meilisearch = callPackage ./non-by-name/meilisearch { };

  meinheld = callPackage ./non-by-name/meinheld { };

  melnor-bluetooth = callPackage ./non-by-name/melnor-bluetooth { };

  memestra = callPackage ./non-by-name/memestra { };

  memoization = callPackage ./non-by-name/memoization { };

  memory-allocator = callPackage ./non-by-name/memory-allocator { };

  memory-profiler = callPackage ./non-by-name/memory-profiler { };

  memory-tempfile = callPackage ./non-by-name/memory-tempfile { };

  memray = callPackage ./non-by-name/memray { };

  menshen-client = callPackage ./non-by-name/menshen-client { };

  meraki = callPackage ./non-by-name/meraki { };

  mercadopago = callPackage ./non-by-name/mercadopago { };

  mercantile = callPackage ./non-by-name/mercantile { };

  mercurial = toPythonModule (pkgs.mercurial.override { python3Packages = self; });

  merge3 = callPackage ./non-by-name/merge3 { };

  mergecal = callPackage ./non-by-name/mergecal { };

  mergedb = callPackage ./non-by-name/mergedb { };

  mergedeep = callPackage ./non-by-name/mergedeep { };

  mergedict = callPackage ./non-by-name/mergedict { };

  merkletools = callPackage ./non-by-name/merkletools { };

  mermaid-py = callPackage ./non-by-name/mermaid-py { };

  meross-iot = callPackage ./non-by-name/meross-iot { };

  meshcat = callPackage ./non-by-name/meshcat { };

  meshcore = callPackage ./non-by-name/meshcore { };

  meshcore-cli = callPackage ./non-by-name/meshcore-cli { };

  meshio = callPackage ./non-by-name/meshio { };

  meshlabxml = callPackage ./non-by-name/meshlabxml { };

  meshtastic = callPackage ./non-by-name/meshtastic { };

  meson = toPythonModule (
    (pkgs.meson.override { python3 = python; }).overridePythonAttrs (oldAttrs: {
      # We do not want the setup hook in Python packages because the build is performed differently.
      setupHook = null;
    })
  );

  meson-python = callPackage ./non-by-name/meson-python { inherit (pkgs) ninja; };

  messagebird = callPackage ./non-by-name/messagebird { };

  metaflow = callPackage ./non-by-name/metaflow { };

  metakernel = callPackage ./non-by-name/metakernel { };

  metar = callPackage ./non-by-name/metar { };

  metawear = callPackage ./non-by-name/metawear { };

  meteo-lt-pkg = callPackage ./non-by-name/meteo-lt-pkg { };

  meteoalertapi = callPackage ./non-by-name/meteoalertapi { };

  meteocalc = callPackage ./non-by-name/meteocalc { };

  meteofrance-api = callPackage ./non-by-name/meteofrance-api { };

  meteoswiss-async = callPackage ./non-by-name/meteoswiss-async { };

  methodtools = callPackage ./non-by-name/methodtools { };

  mezzanine = callPackage ./non-by-name/mezzanine { };

  mf2py = callPackage ./non-by-name/mf2py { };

  mficlient = callPackage ./non-by-name/mficlient { };

  mflux = callPackage ./non-by-name/mflux { };

  mfusepy = callPackage ./non-by-name/mfusepy { };

  mhcflurry = callPackage ./non-by-name/mhcflurry { };

  mhcgnomes = callPackage ./non-by-name/mhcgnomes { };

  miasm = callPackage ./non-by-name/miasm { };

  miauth = callPackage ./non-by-name/miauth { };

  micawber = callPackage ./non-by-name/micawber { };

  micloud = callPackage ./non-by-name/micloud { };

  microbeespy = callPackage ./non-by-name/microbeespy { };

  microdata = callPackage ./non-by-name/microdata { };

  microsoft-kiota-abstractions = callPackage ./non-by-name/microsoft-kiota-abstractions { };

  microsoft-kiota-authentication-azure =
    callPackage ./non-by-name/microsoft-kiota-authentication-azure
      { };

  microsoft-kiota-http = callPackage ./non-by-name/microsoft-kiota-http { };

  microsoft-kiota-serialization-form =
    callPackage ./non-by-name/microsoft-kiota-serialization-form
      { };

  microsoft-kiota-serialization-json =
    callPackage ./non-by-name/microsoft-kiota-serialization-json
      { };

  microsoft-kiota-serialization-multipart =
    callPackage ./non-by-name/microsoft-kiota-serialization-multipart
      { };

  microsoft-kiota-serialization-text =
    callPackage ./non-by-name/microsoft-kiota-serialization-text
      { };

  microsoft-security-utilities-secret-masker =
    callPackage ./non-by-name/microsoft-security-utilities-secret-masker
      { };

  midea-beautiful-air = callPackage ./non-by-name/midea-beautiful-air { };

  midea-local = callPackage ./non-by-name/midea-local { };

  midiutil = callPackage ./non-by-name/midiutil { };

  mido = callPackage ./non-by-name/mido { };

  migen = callPackage ./non-by-name/migen { };

  mike = callPackage ./non-by-name/mike { };

  milc = callPackage ./non-by-name/milc { };

  milksnake = callPackage ./non-by-name/milksnake { };

  mill-local = callPackage ./non-by-name/mill-local { };

  millheater = callPackage ./non-by-name/millheater { };

  miltertest = callPackage ./non-by-name/miltertest { };

  mim-solvers = callPackage ./non-by-name/mim-solvers { inherit (pkgs) mim-solvers; };

  minari = callPackage ./non-by-name/minari { };

  minexr = callPackage ./non-by-name/minexr { };

  miniaudio = callPackage ./non-by-name/miniaudio { };

  minichain = callPackage ./non-by-name/minichain { };

  minidb = callPackage ./non-by-name/minidb { };

  minidump = callPackage ./non-by-name/minidump { };

  miniflux = callPackage ./non-by-name/miniflux { };

  miniful = callPackage ./non-by-name/miniful { };

  minify-html = callPackage ./non-by-name/minify-html { };

  minikanren = callPackage ./non-by-name/minikanren { };

  minikerberos = callPackage ./non-by-name/minikerberos { };

  minimal-snowplow-tracker = callPackage ./non-by-name/minimal-snowplow-tracker { };

  minimock = callPackage ./non-by-name/minimock { };

  mininet-python = (toPythonModule (pkgs.mininet.override { python3 = python; })).py;

  minio = callPackage ./non-by-name/minio { };

  minisbd = callPackage ./non-by-name/minisbd { };

  miniupnpc = callPackage ./non-by-name/miniupnpc { };

  mintotp = callPackage ./non-by-name/mintotp { };

  mip = callPackage ./non-by-name/mip { };

  mir-eval = callPackage ./non-by-name/mir-eval { };

  miraie-ac = callPackage ./non-by-name/miraie-ac { };

  mirakuru = callPackage ./non-by-name/mirakuru { };

  misaki = callPackage ./non-by-name/misaki { };

  misoc = callPackage ./non-by-name/misoc { };

  miss-hit = callPackage ./non-by-name/miss-hit { };

  miss-hit-core = callPackage ./non-by-name/miss-hit-core { };

  mistletoe = callPackage ./non-by-name/mistletoe { };

  mistral-common = callPackage ./non-by-name/mistral-common { };

  mistral-inference = callPackage ./non-by-name/mistral-inference { };

  mistralai = callPackage ./non-by-name/mistralai { };

  mistune = callPackage ./non-by-name/mistune { };

  mistune_2 = callPackage ./non-by-name/mistune/2.nix { };

  mitmproxy = callPackage ./non-by-name/mitmproxy { };

  mitmproxy-linux = callPackage ./non-by-name/mitmproxy-linux { };

  mitmproxy-macos = callPackage ./non-by-name/mitmproxy-macos { };

  mitmproxy-rs = callPackage ./non-by-name/mitmproxy-rs { };

  mitogen = callPackage ./non-by-name/mitogen { };

  mitsubishi-comfort = callPackage ./non-by-name/mitsubishi-comfort { };

  mixbox = callPackage ./non-by-name/mixbox { };

  mixins = callPackage ./non-by-name/mixins { };

  mixpanel = callPackage ./non-by-name/mixpanel { };

  mizani = callPackage ./non-by-name/mizani { };

  mjviser = callPackage ./non-by-name/mjviser { };

  mkdocs = callPackage ./non-by-name/mkdocs { };

  mkdocs-autolinks-plugin = callPackage ./non-by-name/mkdocs-autolinks-plugin { };

  mkdocs-autorefs = callPackage ./non-by-name/mkdocs-autorefs { };

  mkdocs-awesome-nav = callPackage ./non-by-name/mkdocs-awesome-nav { };

  mkdocs-backlinks = callPackage ./non-by-name/mkdocs-backlinks { };

  mkdocs-build-plantuml-plugin = callPackage ./non-by-name/mkdocs-build-plantuml-plugin { };

  mkdocs-callouts = callPackage ./non-by-name/mkdocs-callouts { };

  mkdocs-custom-tags-attributes = callPackage ./non-by-name/mkdocs-custom-tags-attributes { };

  mkdocs-drawio-exporter = callPackage ./non-by-name/mkdocs-drawio-exporter { };

  mkdocs-drawio-file = callPackage ./non-by-name/mkdocs-drawio-file { };

  mkdocs-embed-file-plugin = callPackage ./non-by-name/mkdocs-embed-file-plugin { };

  mkdocs-exclude = callPackage ./non-by-name/mkdocs-exclude { };

  mkdocs-gen-files = callPackage ./non-by-name/mkdocs-gen-files { };

  mkdocs-get-deps = callPackage ./non-by-name/mkdocs-get-deps { };

  mkdocs-git-authors-plugin = callPackage ./non-by-name/mkdocs-git-authors-plugin { };

  mkdocs-git-committers-plugin-2 = callPackage ./non-by-name/mkdocs-git-committers-plugin-2 { };

  mkdocs-git-revision-date-localized-plugin =
    callPackage ./non-by-name/mkdocs-git-revision-date-localized-plugin
      { };

  mkdocs-gitlab = callPackage ./non-by-name/mkdocs-gitlab-plugin { };

  mkdocs-glightbox = callPackage ./non-by-name/mkdocs-glightbox { };

  mkdocs-graphviz = callPackage ./non-by-name/mkdocs-graphviz { };

  mkdocs-include-markdown-plugin = callPackage ./non-by-name/mkdocs-include-markdown-plugin { };

  mkdocs-jupyter = callPackage ./non-by-name/mkdocs-jupyter { };

  mkdocs-linkcheck = callPackage ./non-by-name/mkdocs-linkcheck { };

  mkdocs-literate-nav = callPackage ./non-by-name/mkdocs-literate-nav { };

  mkdocs-macros-plugin = callPackage ./non-by-name/mkdocs-macros-plugin { };

  mkdocs-macros-test = callPackage ./non-by-name/mkdocs-macros-test { };

  mkdocs-markmap = callPackage ./non-by-name/mkdocs-markmap { };

  mkdocs-material = callPackage ./non-by-name/mkdocs-material { };

  mkdocs-material-extensions = callPackage ./non-by-name/mkdocs-material-extensions { };

  mkdocs-mermaid2-plugin = callPackage ./non-by-name/mkdocs-mermaid2-plugin { };

  mkdocs-minify-plugin = callPackage ./non-by-name/mkdocs-minify-plugin { };

  mkdocs-obsidian-bridge = callPackage ./non-by-name/mkdocs-obsidian-bridge { };

  mkdocs-puml = callPackage ./non-by-name/mkdocs-puml { };

  mkdocs-redirects = callPackage ./non-by-name/mkdocs-redirects { };

  mkdocs-redoc-tag = callPackage ./non-by-name/mkdocs-redoc-tag { };

  mkdocs-rss-plugin = callPackage ./non-by-name/mkdocs-rss-plugin { };

  mkdocs-section-index = callPackage ./non-by-name/mkdocs-section-index { };

  mkdocs-simple-blog = callPackage ./non-by-name/mkdocs-simple-blog { };

  mkdocs-swagger-ui-tag = callPackage ./non-by-name/mkdocs-swagger-ui-tag { };

  mkdocs-table-reader-plugin = callPackage ./non-by-name/mkdocs-table-reader-plugin { };

  mkdocs-test = callPackage ./non-by-name/mkdocs-test { };

  mkdocstrings = callPackage ./non-by-name/mkdocstrings { };

  mkdocstrings-python = callPackage ./non-by-name/mkdocstrings-python { };

  mkl-service = callPackage ./non-by-name/mkl-service { };

  mktestdocs = callPackage ./non-by-name/mktestdocs { };

  ml-collections = callPackage ./non-by-name/ml-collections { };

  ml-dtypes = callPackage ./non-by-name/ml-dtypes { };

  mlcroissant = callPackage ./non-by-name/mlcroissant { };

  mlflow = callPackage ./non-by-name/mlflow { };

  mlflow-skinny = callPackage ./non-by-name/mlflow-skinny { };

  mlflow-tracing = callPackage ./non-by-name/mlflow-tracing { };

  mlrose = callPackage ./non-by-name/mlrose { };

  mlt = toPythonModule (
    pkgs.mlt.override {
      python3 = python;
      enablePython = true;
    }
  );

  mlx = callPackage ./non-by-name/mlx { };

  mlx-bin = callPackage ./non-by-name/mlx/bin.nix { };

  mlx-lm = callPackage ./non-by-name/mlx-lm { };

  mlx-metal = callPackage ./non-by-name/mlx/metal.nix { };

  mlx-metal-macos15 = self.mlx-metal.override { macosVariant = "15"; };

  mlx-metal-macos26 = self.mlx-metal.override { macosVariant = "26"; };

  mlx-vlm = callPackage ./non-by-name/mlx-vlm { };

  mlxtend = callPackage ./non-by-name/mlxtend { };

  mmcif-pdbx = callPackage ./non-by-name/mmcif-pdbx { };

  mmcv = callPackage ./non-by-name/mmcv { };

  mmengine = callPackage ./non-by-name/mmengine { };

  mmh3 = callPackage ./non-by-name/mmh3 { };

  mmpython = callPackage ./non-by-name/mmpython { };

  mmtf-python = callPackage ./non-by-name/mmtf-python { };

  mne = callPackage ./non-by-name/mne { };

  mnemonic = callPackage ./non-by-name/mnemonic { };

  mnist = callPackage ./non-by-name/mnist { };

  moat-ble = callPackage ./non-by-name/moat-ble { };

  mobi = callPackage ./non-by-name/mobi { };

  mobly = callPackage ./non-by-name/mobly { };

  mock = callPackage ./non-by-name/mock { };

  mock-django = callPackage ./non-by-name/mock-django { };

  mock-open = callPackage ./non-by-name/mock-open { };

  mock-services = callPackage ./non-by-name/mock-services { };

  mock-ssh-server = callPackage ./non-by-name/mock-ssh-server { };

  mocket = callPackage ./non-by-name/mocket { };

  mockfs = callPackage ./non-by-name/mockfs { };

  mockito = callPackage ./non-by-name/mockito { };

  mockupdb = callPackage ./non-by-name/mockupdb { };

  modal = callPackage ./non-by-name/modal { };

  modbus-connection = callPackage ./non-by-name/modbus-connection { };

  modbus-tk = callPackage ./non-by-name/modbus-tk { };

  moddb = callPackage ./non-by-name/moddb { };

  model-bakery = callPackage ./non-by-name/model-bakery { };

  model-checker = callPackage ./non-by-name/model-checker { };

  model-hosting-container-standards = callPackage ./non-by-name/model-hosting-container-standards { };

  model-signing = callPackage ./non-by-name/model-signing { };

  modelcif = callPackage ./non-by-name/modelcif { };

  modelscope = callPackage ./non-by-name/modelscope { };

  modelscope-hub = callPackage ./non-by-name/modelscope-hub { };

  modelsearch = callPackage ./non-by-name/modelsearch { };

  modern-colorthief = callPackage ./non-by-name/modern-colorthief { };

  moderngl = callPackage ./non-by-name/moderngl { };

  moderngl-window = callPackage ./non-by-name/moderngl-window {
    inherit (pkgs) mesa;
  };

  moehlenhoff-alpha2 = callPackage ./non-by-name/moehlenhoff-alpha2 { };

  mohawk = callPackage ./non-by-name/mohawk { };

  molbar = callPackage ./non-by-name/molbar { };

  molecule = callPackage ./non-by-name/molecule { };

  molecule-plugins = callPackage ./non-by-name/molecule/plugins.nix { };

  momepy = callPackage ./non-by-name/momepy { };

  momonga = callPackage ./non-by-name/momonga { };

  monai = callPackage ./non-by-name/monai { };

  monai-deploy = callPackage ./non-by-name/monai-deploy { };

  monarchmoneycommunity = callPackage ./non-by-name/monarchmoneycommunity { };

  mongodict = callPackage ./non-by-name/mongodict { };

  mongoengine = callPackage ./non-by-name/mongoengine { };

  mongomock = callPackage ./non-by-name/mongomock { };

  mongoquery = callPackage ./non-by-name/mongoquery { };

  monitorcontrol = callPackage ./non-by-name/monitorcontrol { };

  monkeyhex = callPackage ./non-by-name/monkeyhex { };

  monosat = callPackage pkgs.monosat.python { };

  monotonic = callPackage ./non-by-name/monotonic { };

  monotonic-alignment-search = callPackage ./non-by-name/monotonic-alignment-search { };

  monty = callPackage ./non-by-name/monty { };

  monzopy = callPackage ./non-by-name/monzopy { };

  moocore = callPackage ./non-by-name/moocore { };

  moonraker-api = callPackage ./non-by-name/moonraker-api { };

  mopeka-iot-ble = callPackage ./non-by-name/mopeka-iot-ble { };

  mopidyapi = callPackage ./non-by-name/mopidyapi { };

  more-itertools = callPackage ./non-by-name/more-itertools { };

  morecantile = callPackage ./non-by-name/morecantile { };

  moreorless = callPackage ./non-by-name/moreorless { };

  morfessor = callPackage ./non-by-name/morfessor { };

  morphys = callPackage ./non-by-name/morphys { };

  mortgage = callPackage ./non-by-name/mortgage { };

  mosek = callPackage ./non-by-name/mosek { };

  motionblinds = callPackage ./non-by-name/motionblinds { };

  motionblindsble = callPackage ./non-by-name/motionblindsble { };

  motioneye-client = callPackage ./non-by-name/motioneye-client { };

  motmetrics = callPackage ./non-by-name/motmetrics { };

  moto = callPackage ./non-by-name/moto { };

  motor = callPackage ./non-by-name/motor { };

  mouseinfo = callPackage ./non-by-name/mouseinfo { };

  mouser = callPackage ./non-by-name/mouser { };

  moviepy = callPackage ./non-by-name/moviepy { };

  moyopy = callPackage ./non-by-name/moyopy { };

  mozart-api = callPackage ./non-by-name/mozart-api { };

  mozilla-django-oidc = callPackage ./non-by-name/mozilla-django-oidc { };

  mozjpeg_lossless_optimization = callPackage ./non-by-name/mozjpeg_lossless_optimization { };

  mpegdash = callPackage ./non-by-name/mpegdash { };

  mpi-pytest = callPackage ./non-by-name/mpi-pytest { };

  mpi4py = callPackage ./non-by-name/mpi4py { };

  mpl-scatter-density = callPackage ./non-by-name/mpl-scatter-density { };

  mpl-typst = callPackage ./non-by-name/mpl-typst {
    inherit (pkgs) typst;
  };

  mplcursors = callPackage ./non-by-name/mplcursors { };

  mpldatacursor = callPackage ./non-by-name/mpldatacursor { };

  mplfinance = callPackage ./non-by-name/mplfinance { };

  mplhep = callPackage ./non-by-name/mplhep { };

  mplhep-data = callPackage ./non-by-name/mplhep-data { };

  mplleaflet = callPackage ./non-by-name/mplleaflet { };

  mpltoolbox = callPackage ./non-by-name/mpltoolbox { };

  mpmath = callPackage ./non-by-name/mpmath { };

  mpris-api = callPackage ./non-by-name/mpris-api { };

  mpris-server = callPackage ./non-by-name/mpris-server { };

  mprisify = callPackage ./non-by-name/mprisify { };

  mpv = callPackage ./non-by-name/mpv { inherit (pkgs) mpv; };

  mpyq = callPackage ./non-by-name/mpyq { };

  mqtt2influxdb = callPackage ./non-by-name/mqtt2influxdb { };

  mrjob = callPackage ./non-by-name/mrjob { };

  mrsqm = callPackage ./non-by-name/mrsqm { };

  ms-active-directory = callPackage ./non-by-name/ms-active-directory { };

  ms-cv = callPackage ./non-by-name/ms-cv { };

  msal = callPackage ./non-by-name/msal { };

  msal-extensions = callPackage ./non-by-name/msal-extensions { };

  mscerts = callPackage ./non-by-name/mscerts { };

  msg-parser = callPackage ./non-by-name/msg-parser { };

  msgpack = callPackage ./non-by-name/msgpack { };

  msgpack-numpy = callPackage ./non-by-name/msgpack-numpy { };

  msgpack-numpy-opentensor = callPackage ./non-by-name/msgpack-numpy-opentensor { };

  msgraph-core = callPackage ./non-by-name/msgraph-core { };

  msgraph-sdk = callPackage ./non-by-name/msgraph-sdk { };

  msgspec = callPackage ./non-by-name/msgspec { };

  msldap = callPackage ./non-by-name/msldap { };

  mslex = callPackage ./non-by-name/mslex { };

  mslk = callPackage ./non-by-name/mslk { };

  msmart-ng = callPackage ./non-by-name/msmart-ng { };

  msoffcrypto-tool = callPackage ./non-by-name/msoffcrypto-tool { };

  msprime = callPackage ./non-by-name/msprime { };

  msrest = callPackage ./non-by-name/msrest { };

  msrestazure = callPackage ./non-by-name/msrestazure { };

  mss = callPackage ./non-by-name/mss { };

  msticpy = callPackage ./non-by-name/msticpy { };

  mt-940 = callPackage ./non-by-name/mt-940 { };

  mtcnn = callPackage ./non-by-name/mtcnn { };

  mtranslate = callPackage ./non-by-name/mtranslate { };

  mujoco = callPackage ./non-by-name/mujoco { };

  mujoco-core = callPackage ./non-by-name/mujoco-core { inherit (pkgs) mujoco; };

  mujoco-mjx = callPackage ./non-by-name/mujoco-mjx { mujoco-main = pkgs.mujoco; };

  mujoco-warp = callPackage ./non-by-name/mujoco-warp { };

  mujson = callPackage ./non-by-name/mujson { };

  mullvad-api = callPackage ./non-by-name/mullvad-api { };

  mulpyplexer = callPackage ./non-by-name/mulpyplexer { };

  multi-demangle = callPackage ./non-by-name/multi-demangle { };

  multi-key-dict = callPackage ./non-by-name/multi-key-dict { };

  multiaddr = callPackage ./non-by-name/multiaddr { };

  multidict = callPackage ./non-by-name/multidict { };

  multimethod = callPackage ./non-by-name/multimethod { };

  multipart = callPackage ./non-by-name/multipart { };

  multipledispatch = callPackage ./non-by-name/multipledispatch { };

  multiprocess = callPackage ./non-by-name/multiprocess { };

  multiregex = callPackage ./non-by-name/multiregex { };

  multiscale-spatial-image = callPackage ./non-by-name/multiscale-spatial-image { };

  multiset = callPackage ./non-by-name/multiset { };

  multitasking = callPackage ./non-by-name/multitasking { };

  multivolumefile = callPackage ./non-by-name/multivolumefile { };

  munch = callPackage ./non-by-name/munch { };

  mung = callPackage ./non-by-name/mung { };

  munkres = callPackage ./non-by-name/munkres { };

  muon-optimizer = callPackage ./non-by-name/muon-optimizer { };

  murmurhash = callPackage ./non-by-name/murmurhash { };

  muscima = callPackage ./non-by-name/muscima { };

  music-assistant-client = callPackage ./non-by-name/music-assistant-client { };

  music-assistant-models = callPackage ./non-by-name/music-assistant-models { };

  music-tag = callPackage ./non-by-name/music-tag { };

  musicbrainzngs = callPackage ./non-by-name/musicbrainzngs { };

  mutagen = callPackage ./non-by-name/mutagen { };

  mutatormath = callPackage ./non-by-name/mutatormath { };

  mutesync = callPackage ./non-by-name/mutesync { };

  mutf8 = callPackage ./non-by-name/mutf8 { };

  mvcrender = callPackage ./non-by-name/mvcrender { };

  mvg = callPackage ./non-by-name/mvg { };

  mwcli = callPackage ./non-by-name/mwcli { };

  mwclient = callPackage ./non-by-name/mwclient { };

  mwdblib = callPackage ./non-by-name/mwdblib { };

  mwoauth = callPackage ./non-by-name/mwoauth { };

  mwparserfromhell = callPackage ./non-by-name/mwparserfromhell { };

  mwtypes = callPackage ./non-by-name/mwtypes { };

  mwxml = callPackage ./non-by-name/mwxml { };

  mxnet = callPackage ./non-by-name/mxnet { };

  my-pv = callPackage ./non-by-name/my-pv { };

  myfitnesspal = callPackage ./non-by-name/myfitnesspal { };

  mygene = callPackage ./non-by-name/mygene { };

  mygpoclient = callPackage ./non-by-name/mygpoclient { };

  myhdl = callPackage ./non-by-name/myhdl { inherit (pkgs) ghdl iverilog; };

  myhome = callPackage ./non-by-name/myhome { };

  myjwt = callPackage ./non-by-name/myjwt { };

  mypy = callPackage ./non-by-name/mypy { };

  inherit (callPackage ./non-by-name/mypy-boto3 { })
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

  mypy-boto3-builder = callPackage ./non-by-name/mypy-boto3-builder { };

  mypy-extensions = callPackage ./non-by-name/mypy/extensions.nix { };

  mypy-protobuf = callPackage ./non-by-name/mypy-protobuf { };

  mypy-protobuf_3_6 = callPackage ./non-by-name/mypy-protobuf_3_6 { };

  mypyllant = callPackage ./non-by-name/mypyllant { };

  mysql-connector-python = callPackage ./non-by-name/mysql-connector-python { };

  mysqlclient = callPackage ./non-by-name/mysqlclient { };

  myst-nb = callPackage ./non-by-name/myst-nb { };

  myst-parser = callPackage ./non-by-name/myst-parser { };

  myuplink = callPackage ./non-by-name/myuplink { };

  nab = callPackage ./non-by-name/nab { };

  nab-index = callPackage ./non-by-name/nab-index { };

  nab-markersets = callPackage ./non-by-name/nab-markersets { };

  nab-project = callPackage ./non-by-name/nab-project { };

  nab-provider = callPackage ./non-by-name/nab-provider { };

  nab-resolver = callPackage ./non-by-name/nab-resolver { };

  nad-receiver = callPackage ./non-by-name/nad-receiver { };

  nagiosplugin = callPackage ./non-by-name/nagiosplugin { };

  naked = callPackage ./non-by-name/naked { };

  name-that-hash = callPackage ./non-by-name/name-that-hash { };

  namedlist = callPackage ./non-by-name/namedlist { };

  nameko = callPackage ./non-by-name/nameko { };

  nameparser = callPackage ./non-by-name/nameparser { };

  names = callPackage ./non-by-name/names { };

  namex = callPackage ./non-by-name/namex { };

  nampa = callPackage ./non-by-name/nampa { };

  nanoarrow = callPackage ./non-by-name/nanoarrow {
    zstd-c = pkgs.zstd;
    nanoarrow-c = pkgs.nanoarrow;
  };

  nanobind = callPackage ./non-by-name/nanobind { };

  nanobind_3 = callPackage ./non-by-name/nanobind_3 { };

  nanoeigenpy = callPackage ./non-by-name/nanoeigenpy { };

  nanoemoji = callPackage ./non-by-name/nanoemoji { };

  nanoid = callPackage ./non-by-name/nanoid { };

  nanoleaf = callPackage ./non-by-name/nanoleaf { };

  nanomsg = callPackage ./non-by-name/nanomsg {
    inherit (pkgs) nanomsg;
  };

  nanotime = callPackage ./non-by-name/nanotime { };

  napalm = callPackage ./non-by-name/napalm { };

  napalm-hp-procurve = callPackage ./non-by-name/napalm/hp-procurve.nix { };

  napalm-ros = callPackage ./non-by-name/napalm/ros.nix { };

  napari = callPackage ./non-by-name/napari { };

  napari-console = callPackage ./non-by-name/napari-console { };

  napari-nifti = callPackage ./non-by-name/napari-nifti { };

  napari-plugin-engine = callPackage ./non-by-name/napari-plugin-engine { };

  napari-svg = callPackage ./non-by-name/napari-svg { };

  narwhals = callPackage ./non-by-name/narwhals { };

  nasdaq-data-link = callPackage ./non-by-name/nasdaq-data-link { };

  natasha = callPackage ./non-by-name/natasha { };

  native-sparse-attention-pytorch = callPackage ./non-by-name/native-sparse-attention-pytorch { };

  nats-py = callPackage ./non-by-name/nats-py { };

  nats-python = callPackage ./non-by-name/nats-python { };

  natsort = callPackage ./non-by-name/natsort { };

  natural = callPackage ./non-by-name/natural { };

  naturalsort = callPackage ./non-by-name/naturalsort { };

  navec = callPackage ./non-by-name/navec { };

  nbclassic = callPackage ./non-by-name/nbclassic { };

  nbclient = callPackage ./non-by-name/nbclient { };

  nbconflux = callPackage ./non-by-name/nbconflux { };

  nbconvert = callPackage ./non-by-name/nbconvert { };

  nbdev = callPackage ./non-by-name/nbdev { };

  nbdime = callPackage ./non-by-name/nbdime { };

  nbexec = callPackage ./non-by-name/nbexec { };

  nbformat = callPackage ./non-by-name/nbformat { };

  nbmake = callPackage ./non-by-name/nbmake { };

  nbsmoke = callPackage ./non-by-name/nbsmoke { };

  nbsphinx = callPackage ./non-by-name/nbsphinx { };

  nbtlib = callPackage ./non-by-name/nbtlib { };

  nbval = callPackage ./non-by-name/nbval { };

  nbxmpp = callPackage ./non-by-name/nbxmpp { };

  nc-dnsapi = callPackage ./non-by-name/nc-dnsapi { };

  nccl4py = callPackage ./non-by-name/nccl4py { };

  ncclient = callPackage ./non-by-name/ncclient { };

  nclib = callPackage ./non-by-name/nclib { };

  ndcurves = callPackage ./non-by-name/ndcurves { inherit (pkgs) ndcurves; };

  ndeflib = callPackage ./non-by-name/ndeflib { };

  ndg-httpsclient = callPackage ./non-by-name/ndg-httpsclient { };

  ndindex = callPackage ./non-by-name/ndindex { };

  ndjson = callPackage ./non-by-name/ndjson { };

  ndms2-client = callPackage ./non-by-name/ndms2-client { };

  ndspy = callPackage ./non-by-name/ndspy { };

  ndtypes = callPackage ./non-by-name/ndtypes { };

  nebula3-python = callPackage ./non-by-name/nebula3-python { };

  nemo-relay = callPackage ./non-by-name/nemo-relay {
    inherit (pkgs) zstd;
  };

  nemosis = callPackage ./non-by-name/nemosis { };

  nengo = callPackage ./non-by-name/nengo { };

  neo = callPackage ./non-by-name/neo { };

  neo4j = callPackage ./non-by-name/neo4j { };

  neopool-modbus = callPackage ./non-by-name/neopool-modbus { };

  neoteroi-mkdocs = callPackage ./non-by-name/neoteroi-mkdocs { };

  nessclient = callPackage ./non-by-name/nessclient { };

  nest = toPythonModule (
    pkgs.nest-mpi.override {
      withPython = true;
      python3 = python;
    }
  );

  nest-asyncio = callPackage ./non-by-name/nest-asyncio { };

  nest-asyncio2 = callPackage ./non-by-name/nest-asyncio2 { };

  nested-lookup = callPackage ./non-by-name/nested-lookup { };

  nested-multipart-parser = callPackage ./non-by-name/nested-multipart-parser { };

  nestedtext = callPackage ./non-by-name/nestedtext { };

  netaddr = callPackage ./non-by-name/netaddr { };

  netapp-lib = callPackage ./non-by-name/netapp-lib { };

  netapp-ontap = callPackage ./non-by-name/netapp-ontap { };

  netcdf4 = callPackage ./non-by-name/netcdf4 { };

  netdata = callPackage ./non-by-name/netdata { };

  netdata-pandas = callPackage ./non-by-name/netdata-pandas { };

  netdisco = callPackage ./non-by-name/netdisco { };

  netgen-mesher = toPythonModule (pkgs.netgen.override { python3Packages = self; });

  nethsm = callPackage ./non-by-name/nethsm { };

  netifaces = callPackage ./non-by-name/netifaces { };

  netifaces-plus = callPackage ./non-by-name/netifaces-plus { };

  netifaces2 = callPackage ./non-by-name/netifaces2 { };

  netio = callPackage ./non-by-name/netio { };

  netmap = callPackage ./non-by-name/netmap { };

  netmiko = callPackage ./non-by-name/netmiko { };

  nettigo-air-monitor = callPackage ./non-by-name/nettigo-air-monitor { };

  netutils = callPackage ./non-by-name/netutils { };

  networkx = callPackage ./non-by-name/networkx { };

  neuralfoil = callPackage ./non-by-name/neuralfoil { };

  neurio = callPackage ./non-by-name/neurio { };

  neurokit2 = callPackage ./non-by-name/neurokit2 { };

  neuron-full = pkgs.neuron-full.override { python3 = python; };

  neuronpy = toPythonModule neuron-full;

  nevow = callPackage ./non-by-name/nevow { };

  newick = callPackage ./non-by-name/newick { };

  newspaper3k = callPackage ./non-by-name/newspaper3k { };

  newversion = callPackage ./non-by-name/newversion { };

  nexblue-api = callPackage ./non-by-name/nexblue-api { };

  nexia = callPackage ./non-by-name/nexia { };

  nextcloudmonitor = callPackage ./non-by-name/nextcloudmonitor { };

  nextcord = callPackage ./non-by-name/nextcord { };

  nextdns = callPackage ./non-by-name/nextdns { };

  nexusformat = callPackage ./non-by-name/nexusformat { };

  nexusrpc = callPackage ./non-by-name/nexusrpc { };

  nfcpy = callPackage ./non-by-name/nfcpy { };

  nftables = callPackage ../../by-name/nf/nftables/python.nix { };

  ngff-zarr = callPackage ./non-by-name/ngff-zarr { };

  nglview = callPackage ./non-by-name/nglview { };

  nh3 = callPackage ./non-by-name/nh3 { };

  nhc = callPackage ./non-by-name/nhc { };

  niaaml = callPackage ./non-by-name/niaaml { };

  niaarm = callPackage ./non-by-name/niaarm { };

  niaclass = callPackage ./non-by-name/niaclass { };

  nianet = callPackage ./non-by-name/nianet { };

  niapy = callPackage ./non-by-name/niapy { };

  nibabel = callPackage ./non-by-name/nibabel { };

  nibe = callPackage ./non-by-name/nibe { };

  nice-go = callPackage ./non-by-name/nice-go { };

  nicegui = callPackage ./non-by-name/nicegui { };

  nicegui-highcharts = callPackage ./non-by-name/nicegui-highcharts { };

  nidaqmx = callPackage ./non-by-name/nidaqmx { };

  nifty8 = callPackage ./non-by-name/nifty8 { };

  nikola = callPackage ./non-by-name/nikola { };

  nilearn = callPackage ./non-by-name/nilearn { };

  niluclient = callPackage ./non-by-name/niluclient { };

  nimfa = callPackage ./non-by-name/nimfa { };

  nine = callPackage ./non-by-name/nine { };

  ninebot-ble = callPackage ./non-by-name/ninebot-ble { };

  ninja = callPackage ./non-by-name/ninja { inherit (pkgs) ninja; };

  nipap = callPackage ./non-by-name/nipap { };

  nipreps-versions = callPackage ./non-by-name/nipreps-versions { };

  nipy = callPackage ./non-by-name/nipy { };

  nipype = callPackage ./non-by-name/nipype { inherit (pkgs) which; };

  niquests = callPackage ./non-by-name/niquests { };

  nitime = callPackage ./non-by-name/nitime { };

  nitransforms = callPackage ./non-by-name/nitransforms { };

  nitrokey = callPackage ./non-by-name/nitrokey { };

  nitypes = callPackage ./non-by-name/nitypes { };

  niworkflows = callPackage ./non-by-name/niworkflows { };

  nix-kernel = callPackage ./non-by-name/nix-kernel { inherit (pkgs) nix; };

  nix-manipulator = callPackage ./non-by-name/nix-manipulator { };

  nix-prefetch-github = callPackage ./non-by-name/nix-prefetch-github { };

  nixl = callPackage ./non-by-name/nixl {
    nixl = pkgs.nixl.override { python3Packages = self; };
  };

  nixpkgs-plugin-update = callPackage ./non-by-name/nixpkgs-plugin-update { };

  nixpkgs-pytools = callPackage ./non-by-name/nixpkgs-pytools { };

  nixpkgs-updaters-library = callPackage ./non-by-name/nixpkgs-updaters-library { };

  nkdfu = callPackage ./non-by-name/nkdfu { };

  nlopt = callPackage ./non-by-name/nlopt { };

  nlpcloud = callPackage ./non-by-name/nlpcloud { };

  nlpo3 = callPackage ./non-by-name/nlpo3 { };

  nltk = callPackage ./non-by-name/nltk { };

  nmapthon2 = callPackage ./non-by-name/nmapthon2 { };

  nmcli = callPackage ./non-by-name/nmcli { };

  nnaudio = callPackage ./non-by-name/nnaudio { };

  nnpdf = toPythonModule (pkgs.nnpdf.override { python3 = python; });

  noaa-coops = callPackage ./non-by-name/noaa-coops { };

  nocasedict = callPackage ./non-by-name/nocasedict { };

  nocaselist = callPackage ./non-by-name/nocaselist { };

  nocturne = callPackage ./non-by-name/nocturne { };

  node-semver = callPackage ./non-by-name/node-semver { };

  nodeenv = callPackage ./non-by-name/nodeenv { };

  nodepy-runtime = callPackage ./non-by-name/nodepy-runtime { };

  nodriver = callPackage ./non-by-name/nodriver { };

  noise = callPackage ./non-by-name/noise { };

  noiseprotocol = callPackage ./non-by-name/noiseprotocol { };

  noisereduce = callPackage ./non-by-name/noisereduce { };

  nomadnet = callPackage ./non-by-name/nomadnet { };

  nominal = callPackage ./non-by-name/nominal { };

  nominal-api = callPackage ./non-by-name/nominal-api { };

  nominal-api-protos = callPackage ./non-by-name/nominal-api-protos { };

  nominatim-api = callPackage ../../by-name/no/nominatim/nominatim-api.nix { };

  noneprompt = callPackage ./non-by-name/noneprompt { };

  nonestorage = callPackage ./non-by-name/nonestorage { };

  norfair = callPackage ./non-by-name/norfair { };

  normality = callPackage ./non-by-name/normality { };

  nose2 = callPackage ./non-by-name/nose2 { };

  nose2pytest = callPackage ./non-by-name/nose2pytest { };

  notebook = callPackage ./non-by-name/notebook { };

  notebook-shim = callPackage ./non-by-name/notebook-shim { };

  notedown = callPackage ./non-by-name/notedown { };

  notifications-android-tv = callPackage ./non-by-name/notifications-android-tv { };

  notifications-python-client = callPackage ./non-by-name/notifications-python-client { };

  notify-events = callPackage ./non-by-name/notify-events { };

  notify-py = callPackage ./non-by-name/notify-py { };

  notify2 = callPackage ./non-by-name/notify2 { };

  notion-client = callPackage ./non-by-name/notion-client { };

  notmuch = callPackage ./non-by-name/notmuch { inherit (pkgs) notmuch; };

  notmuch2 = callPackage ./non-by-name/notmuch2 { inherit (pkgs) notmuch; };

  notobuilder = callPackage ./non-by-name/notobuilder { };

  notus-scanner = callPackage ./non-by-name/notus-scanner { };

  nox = callPackage ./non-by-name/nox { };

  npe2 = callPackage ./non-by-name/npe2 { };

  nplusone = callPackage ./non-by-name/nplusone { };

  npyscreen = callPackage ./non-by-name/npyscreen { };

  nrf-ota = callPackage ./non-by-name/nrf-ota { };

  nrf802154-sniffer = callPackage ./non-by-name/nrf802154-sniffer { };

  nrgkick-api = callPackage ./non-by-name/nrgkick-api { };

  nsapi = callPackage ./non-by-name/nsapi { };

  nskeyedunarchiver = callPackage ./non-by-name/nskeyedunarchiver { };

  nslookup = callPackage ./non-by-name/nslookup { };

  nsw-fuel-api-client = callPackage ./non-by-name/nsw-fuel-api-client { };

  nsz = callPackage ./non-by-name/nsz { };

  ntc-templates = callPackage ./non-by-name/ntc-templates { };

  ntfy-webpush = callPackage ./non-by-name/ntfy-webpush { };

  ntplib = callPackage ./non-by-name/ntplib { };

  nuclear = callPackage ./non-by-name/nuclear { };

  nuheat = callPackage ./non-by-name/nuheat { };

  nuitka = callPackage ./non-by-name/nuitka { };

  nulltype = callPackage ./non-by-name/nulltype { };

  num2words = callPackage ./non-by-name/num2words { };

  numato-gpio = callPackage ./non-by-name/numato-gpio { };

  numba = callPackage ./non-by-name/numba { inherit (pkgs.config) cudaSupport; };

  numba-cuda = callPackage ./non-by-name/numba-cuda { };

  numba-scipy = callPackage ./non-by-name/numba-scipy { };

  numbaWithCuda = self.numba.override { cudaSupport = true; };

  numbagg = callPackage ./non-by-name/numbagg { };

  numcodecs = callPackage ./non-by-name/numcodecs {
    inherit (pkgs) zstd;
  };

  numdifftools = callPackage ./non-by-name/numdifftools { };

  numericalunits = callPackage ./non-by-name/numericalunits { };

  numexpr = callPackage ./non-by-name/numexpr { };

  numkong = callPackage ./non-by-name/numkong { };

  numpy = callPackage ./non-by-name/numpy { };

  numpy-financial = callPackage ./non-by-name/numpy-financial { };

  numpy-groupies = callPackage ./non-by-name/numpy-groupies { };

  numpy-quaternion = callPackage ./non-by-name/numpy-quaternion { };

  numpy-stl = callPackage ./non-by-name/numpy-stl { };

  numpy-typing-compat = callPackage ./non-by-name/numpy-typing-compat { };

  numpydoc = callPackage ./non-by-name/numpydoc { };

  numpyro = callPackage ./non-by-name/numpyro { };

  nunavut = callPackage ./non-by-name/nunavut { };

  nutils = callPackage ./non-by-name/nutils { };

  nutils-poly = callPackage ./non-by-name/nutils-poly { };

  nutpie = callPackage ./non-by-name/nutpie { inherit (pkgs) zstd; };

  nvchecker = callPackage ./non-by-name/nvchecker { };

  nvdlfw-inspect = callPackage ./non-by-name/nvdlfw-inspect { };

  nvdlib = callPackage ./non-by-name/nvdlib { };

  nvidia-cudnn-frontend = callPackage ./non-by-name/nvidia-cudnn-frontend { };

  nvidia-cutlass = callPackage ./non-by-name/nvidia-cutlass { };

  nvidia-cutlass-dsl = callPackage ./non-by-name/nvidia-cutlass-dsl { };

  nvidia-cutlass-dsl-libs-base = callPackage ./non-by-name/nvidia-cutlass-dsl-libs-base { };

  nvidia-cutlass-operators = callPackage ./non-by-name/nvidia-cutlass-operators { };

  nvidia-dali = callPackage ./non-by-name/nvidia-dali { };

  nvidia-dlprof-pytorch-nvtx = callPackage ./non-by-name/nvidia-dlprof-pytorch-nvtx { };

  nvidia-dlprofviewer = callPackage ./non-by-name/nvidia-dlprofviewer { };

  nvidia-matmul-heuristics = callPackage ./non-by-name/nvidia-matmul-heuristics { };

  nvidia-ml-py = callPackage ./non-by-name/nvidia-ml-py { };

  nvidia-modelopt = callPackage ./non-by-name/nvidia-modelopt { };

  nvidia-resiliency-ext = callPackage ./non-by-name/nvidia-resiliency-ext { };

  nvmath-python = callPackage ./non-by-name/nvmath-python { };

  nvtx = callPackage ./non-by-name/nvtx {
    # Only for its source and versions. Every CUDA package set from 12.9 on has the same source
    # build, while earlier ones (possibly the default cudaPackages) use the redistributable.
    inherit (pkgs.cudaPackages) nvtx;
  };

  nwdiag = callPackage ./non-by-name/nwdiag { };

  nxt-python = callPackage ./non-by-name/nxt-python { };

  nyt-games = callPackage ./non-by-name/nyt-games { };

  oasatelematics = callPackage ./non-by-name/oasatelematics { };

  oath = callPackage ./non-by-name/oath { };

  oathtool = callPackage ./non-by-name/oathtool { };

  oauth2-client = callPackage ./non-by-name/oauth2-client { };

  oauth2client = callPackage ./non-by-name/oauth2client { };

  oauthenticator = callPackage ./non-by-name/oauthenticator { };

  oauthlib = callPackage ./non-by-name/oauthlib { };

  obfsproxy = callPackage ./non-by-name/obfsproxy { };

  objexplore = callPackage ./non-by-name/objexplore { };

  objgraph = callPackage ./non-by-name/objgraph {
    # requires both the graphviz package and python package
    graphvizPkgs = pkgs.graphviz;
  };

  objprint = callPackage ./non-by-name/objprint { };

  objsize = callPackage ./non-by-name/objsize { };

  obsidian-callouts = callPackage ./non-by-name/obsidian-callouts { };

  obsidian-media = callPackage ./non-by-name/obsidian-media { };

  obspec = callPackage ./non-by-name/obspec { };

  obspy = callPackage ./non-by-name/obspy { };

  obstore = callPackage ./non-by-name/obstore { };

  obsws-python = callPackage ./non-by-name/obsws-python { };

  oca-port = callPackage ./non-by-name/oca-port { };

  ochre = callPackage ./non-by-name/ochre { };

  oci = callPackage ./non-by-name/oci { };

  oci-lexer-parser = callPackage ./non-by-name/oci-lexer-parser { };

  ocifs = callPackage ./non-by-name/ocifs { };

  ocrmypdf = callPackage ./non-by-name/ocrmypdf { tesseract = pkgs.tesseract5; };

  od = callPackage ./non-by-name/od { };

  odc-geo = callPackage ./non-by-name/odc-geo { };

  odc-loader = callPackage ./non-by-name/odc-loader { };

  odc-stac = callPackage ./non-by-name/odc-stac { };

  oddsprout = callPackage ./non-by-name/oddsprout { };

  odfdo = callPackage ./non-by-name/odfdo { };

  odfpy = callPackage ./non-by-name/odfpy { };

  odl-renderer = callPackage ./non-by-name/odl-renderer { };

  odp-amsterdam = callPackage ./non-by-name/odp-amsterdam { };

  odsgenerator = callPackage ./non-by-name/odsgenerator { };

  odsparsator = callPackage ./non-by-name/odsparsator { };

  oelint-data = callPackage ./non-by-name/oelint-data { };

  oelint-parser = callPackage ./non-by-name/oelint-parser { };

  oemthermostat = callPackage ./non-by-name/oemthermostat { };

  offtrac = callPackage ./non-by-name/offtrac { };

  ofxhome = callPackage ./non-by-name/ofxhome { };

  ofxparse = callPackage ./non-by-name/ofxparse { };

  ofxtools = callPackage ./non-by-name/ofxtools { };

  ogmios = callPackage ./non-by-name/ogmios { };

  ohme = callPackage ./non-by-name/ohme { };

  oic = callPackage ./non-by-name/oic { };

  oinker = callPackage ./non-by-name/oinker { };

  okokscale = callPackage ./non-by-name/okokscale { };

  okonomiyaki = callPackage ./non-by-name/okonomiyaki { };

  okta = callPackage ./non-by-name/okta { };

  oldest-supported-numpy = callPackage ./non-by-name/oldest-supported-numpy { };

  oldmemo = callPackage ./non-by-name/oldmemo { };

  olefile = callPackage ./non-by-name/olefile { };

  oletools = callPackage ./non-by-name/oletools { };

  ollama = callPackage ./non-by-name/ollama { };

  ome-zarr = callPackage ./non-by-name/ome-zarr { };

  ome-zarr-models = callPackage ./non-by-name/ome-zarr-models { };

  omegaconf = callPackage ./non-by-name/omegaconf { };

  omemo = callPackage ./non-by-name/omemo { };

  omemo-dr = callPackage ./non-by-name/omemo-dr { };

  omitempty = callPackage ./non-by-name/omitempty { };

  omnikinverter = callPackage ./non-by-name/omnikinverter { };

  omnilogic = callPackage ./non-by-name/omnilogic { };

  omniorb = toPythonModule (pkgs.omniorb.override { python3 = self.python; });

  omniorbpy = callPackage ./non-by-name/omniorbpy { };

  omorfi = callPackage ./non-by-name/omorfi { };

  omrdatasettools = callPackage ./non-by-name/omrdatasettools { };

  omsdk = callPackage ./non-by-name/omsdk { };

  oncalendar = callPackage ./non-by-name/oncalendar { };

  ondilo = callPackage ./non-by-name/ondilo { };

  onecache = callPackage ./non-by-name/onecache { };

  onedrive-personal-sdk = callPackage ./non-by-name/onedrive-personal-sdk { };

  onepassword-sdk = callPackage ./non-by-name/onepassword-sdk { };

  onetimepad = callPackage ./non-by-name/onetimepad { };

  onetimepass = callPackage ./non-by-name/onetimepass { };

  onigurumacffi = callPackage ./non-by-name/onigurumacffi { };

  onkyo-eiscp = callPackage ./non-by-name/onkyo-eiscp { };

  online-judge-api-client = callPackage ./non-by-name/online-judge-api-client { };

  online-judge-tools = callPackage ./non-by-name/online-judge-tools { };

  onlinepayments-sdk-python3 = callPackage ./non-by-name/onlinepayments-sdk-python3 { };

  onlykey-solo-python = callPackage ./non-by-name/onlykey-solo-python { };

  onnx = callPackage ./non-by-name/onnx {
    onnx = pkgs.onnx.override {
      python3Packages = self;
    };
  };

  onnx-asr = callPackage ./non-by-name/onnx-asr { };

  onnx-graphsurgeon = callPackage ./non-by-name/onnx-graphsurgeon { };

  onnx-ir = callPackage ./non-by-name/onnx-ir { };

  onnxconverter-common = callPackage ./non-by-name/onnxconverter-common { };

  onnxmltools = callPackage ./non-by-name/onnxmltools { };

  onnxruntime = callPackage ./non-by-name/onnxruntime {
    onnxruntime = pkgs.onnxruntime.override {
      python3Packages = self;
      pythonSupport = true;
    };
    inherit (pkgs) openvino;
  };

  onnxruntime-tools = callPackage ./non-by-name/onnxruntime-tools { };

  onnxscript = callPackage ./non-by-name/onnxscript { };

  onnxslim = callPackage ./non-by-name/onnxslim { };

  onvif-parsers = callPackage ./non-by-name/onvif-parsers { };

  onvif-python = callPackage ./non-by-name/onvif-python { };

  onvif-zeep = callPackage ./non-by-name/onvif-zeep { };

  onvif-zeep-async = callPackage ./non-by-name/onvif-zeep-async { };

  oocsi = callPackage ./non-by-name/oocsi { };

  opack2 = callPackage ./non-by-name/opack2 { };

  opaque = callPackage ./non-by-name/opaque { };

  opcua-widgets = callPackage ./non-by-name/opcua-widgets { };

  open-clip-torch = callPackage ./non-by-name/open-clip-torch { };

  open-garage = callPackage ./non-by-name/open-garage { };

  open-hypergraphs = callPackage ./non-by-name/open-hypergraphs { };

  open-meteo = callPackage ./non-by-name/open-meteo { };

  openai = callPackage ./non-by-name/openai { };

  openai-agents = callPackage ./non-by-name/openai-agents { };

  openai-harmony = callPackage ./non-by-name/openai-harmony { };

  openai-whisper = callPackage ./non-by-name/openai-whisper { };

  openaiauth = callPackage ./non-by-name/openaiauth { };

  openant = callPackage ./non-by-name/openant { };

  openapi-core = callPackage ./non-by-name/openapi-core { };

  openapi-pydantic = callPackage ./non-by-name/openapi-pydantic { };

  openapi-schema-validator = callPackage ./non-by-name/openapi-schema-validator { };

  openapi-spec-validator = callPackage ./non-by-name/openapi-spec-validator { };

  openapi3 = callPackage ./non-by-name/openapi3 { };

  openbabel = toPythonModule (pkgs.openbabel.override { python3 = python; });

  opencamlib = callPackage ./non-by-name/opencamlib { };

  opencc = callPackage ./non-by-name/opencc { };

  openccu-data = callPackage ./non-by-name/openccu-data { };

  openccu-loom-client = callPackage ./non-by-name/openccu-loom-client { };

  opencensus = callPackage ./non-by-name/opencensus { };

  opencensus-context = callPackage ./non-by-name/opencensus-context { };

  opencontainers = callPackage ./non-by-name/opencontainers { };

  opencv-contrib-python = callPackage ./non-by-name/opencv-contrib-python { };

  opencv-python = callPackage ./non-by-name/opencv-python { };

  opencv-python-headless = callPackage ./non-by-name/opencv-python-headless { };

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

  opendal = callPackage ./non-by-name/opendal { };

  openerz-api = callPackage ./non-by-name/openerz-api { };

  openevsewifi = callPackage ./non-by-name/openevsewifi { };

  openexr = callPackage ./non-by-name/openexr { };

  openfga-sdk = callPackage ./non-by-name/openfga-sdk { };

  openhomedevice = callPackage ./non-by-name/openhomedevice { };

  openidc-client = callPackage ./non-by-name/openidc-client { };

  openimageio = toPythonModule (
    pkgs.openimageio.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  openinference-instrumentation = callPackage ./non-by-name/openinference-instrumentation { };

  openinference-instrumentation-claude-agent-sdk =
    callPackage ./non-by-name/openinference-instrumentation-claude-agent-sdk
      { };

  openinference-instrumentation-openai =
    callPackage ./non-by-name/openinference-instrumentation-openai
      { };

  openinference-semantic-conventions =
    callPackage ./non-by-name/openinference-semantic-conventions
      { };

  openmm = toPythonModule (
    pkgs.openmm.override {
      python3Packages = self;
      enablePython = true;
    }
  );

  openmm-torch = callPackage ./non-by-name/openmm-torch { };

  openpaperwork-core = callPackage ../../applications/office/paperwork/openpaperwork-core.nix { };

  openpaperwork-gtk = callPackage ../../applications/office/paperwork/openpaperwork-gtk.nix { };

  openplantbook-sdk = callPackage ./non-by-name/openplantbook-sdk { };

  openpyxl = callPackage ./non-by-name/openpyxl { };

  openrazer = callPackage ./non-by-name/openrazer/pylib.nix { };

  openrazer-daemon = callPackage ./non-by-name/openrazer/daemon.nix { };

  openrgb-python = callPackage ./non-by-name/openrgb-python { };

  openrouteservice = callPackage ./non-by-name/openrouteservice { };

  opensearch-py = callPackage ./non-by-name/opensearch-py { };

  opensensemap-api = callPackage ./non-by-name/opensensemap-api { };

  opensfm = callPackage ./non-by-name/opensfm { };

  openshadinglanguage = toPythonModule (
    pkgs.openshadinglanguage.override { python3Packages = self; }
  );

  openshift = callPackage ./non-by-name/openshift { };

  opensimplex = callPackage ./non-by-name/opensimplex { };

  openslide-python = callPackage ./non-by-name/openslide-python {
    inherit (pkgs) openslide;
  };

  openstackdocstheme = callPackage ./non-by-name/openstackdocstheme { };

  openstacksdk = callPackage ./non-by-name/openstacksdk { };

  openstep-parser = callPackage ./non-by-name/openstep-parser { };

  openstep-plist = callPackage ./non-by-name/openstep-plist { };

  opentelemetry-api = callPackage ./non-by-name/opentelemetry-api { };

  opentelemetry-distro = callPackage ./non-by-name/opentelemetry-distro { };

  opentelemetry-exporter-http-transport =
    callPackage ./non-by-name/opentelemetry-exporter-http-transport
      { };

  opentelemetry-exporter-otlp = callPackage ./non-by-name/opentelemetry-exporter-otlp { };

  opentelemetry-exporter-otlp-proto-common =
    callPackage ./non-by-name/opentelemetry-exporter-otlp-proto-common
      { };

  opentelemetry-exporter-otlp-proto-grpc =
    callPackage ./non-by-name/opentelemetry-exporter-otlp-proto-grpc
      { };

  opentelemetry-exporter-otlp-proto-http =
    callPackage ./non-by-name/opentelemetry-exporter-otlp-proto-http
      { };

  opentelemetry-exporter-prometheus = callPackage ./non-by-name/opentelemetry-exporter-prometheus { };

  opentelemetry-instrumentation = callPackage ./non-by-name/opentelemetry-instrumentation { };

  opentelemetry-instrumentation-aiohttp-client =
    callPackage ./non-by-name/opentelemetry-instrumentation-aiohttp-client
      { };

  opentelemetry-instrumentation-asgi =
    callPackage ./non-by-name/opentelemetry-instrumentation-asgi
      { };

  opentelemetry-instrumentation-botocore =
    callPackage ./non-by-name/opentelemetry-instrumentation-botocore
      { };

  opentelemetry-instrumentation-celery =
    callPackage ./non-by-name/opentelemetry-instrumentation-celery
      { };

  opentelemetry-instrumentation-dbapi =
    callPackage ./non-by-name/opentelemetry-instrumentation-dbapi
      { };

  opentelemetry-instrumentation-django =
    callPackage ./non-by-name/opentelemetry-instrumentation-django
      { };

  opentelemetry-instrumentation-fastapi =
    callPackage ./non-by-name/opentelemetry-instrumentation-fastapi
      { };

  opentelemetry-instrumentation-flask =
    callPackage ./non-by-name/opentelemetry-instrumentation-flask
      { };

  opentelemetry-instrumentation-grpc =
    callPackage ./non-by-name/opentelemetry-instrumentation-grpc
      { };

  opentelemetry-instrumentation-httpx =
    callPackage ./non-by-name/opentelemetry-instrumentation-httpx
      { };

  opentelemetry-instrumentation-logging =
    callPackage ./non-by-name/opentelemetry-instrumentation-logging
      { };

  opentelemetry-instrumentation-psycopg =
    callPackage ./non-by-name/opentelemetry-instrumentation-psycopg
      { };

  opentelemetry-instrumentation-psycopg2 =
    callPackage ./non-by-name/opentelemetry-instrumentation-psycopg2
      { };

  opentelemetry-instrumentation-redis =
    callPackage ./non-by-name/opentelemetry-instrumentation-redis
      { };

  opentelemetry-instrumentation-requests =
    callPackage ./non-by-name/opentelemetry-instrumentation-requests
      { };

  opentelemetry-instrumentation-sqlalchemy =
    callPackage ./non-by-name/opentelemetry-instrumentation-sqlalchemy
      { };

  opentelemetry-instrumentation-sqlite3 =
    callPackage ./non-by-name/opentelemetry-instrumentation-sqlite3
      { };

  opentelemetry-instrumentation-system-metrics =
    callPackage ./non-by-name/opentelemetry-instrumentation-system-metrics
      { };

  opentelemetry-instrumentation-threading =
    callPackage ./non-by-name/opentelemetry-instrumentation-threading
      { };

  opentelemetry-instrumentation-urllib3 =
    callPackage ./non-by-name/opentelemetry-instrumentation-urllib3
      { };

  opentelemetry-instrumentation-wsgi =
    callPackage ./non-by-name/opentelemetry-instrumentation-wsgi
      { };

  opentelemetry-propagator-aws-xray = callPackage ./non-by-name/opentelemetry-propagator-aws-xray { };

  opentelemetry-proto = callPackage ./non-by-name/opentelemetry-proto { };

  opentelemetry-resourcedetector-gcp =
    callPackage ./non-by-name/opentelemetry-resourcedetector-gcp
      { };

  opentelemetry-sdk = callPackage ./non-by-name/opentelemetry-sdk { };

  opentelemetry-semantic-conventions =
    callPackage ./non-by-name/opentelemetry-semantic-conventions
      { };

  opentelemetry-semantic-conventions-ai =
    callPackage ./non-by-name/opentelemetry-semantic-conventions-ai
      { };

  opentelemetry-test-utils = callPackage ./non-by-name/opentelemetry-test-utils { };

  opentelemetry-util-http = callPackage ./non-by-name/opentelemetry-util-http { };

  opentimestamps = callPackage ./non-by-name/opentimestamps { };

  opentsne = callPackage ./non-by-name/opentsne { };

  openturns = toPythonModule (
    pkgs.openturns.override {
      python3Packages = self;
      enablePython = true;
    }
  );

  opentype-feature-freezer = callPackage ./non-by-name/opentype-feature-freezer { };

  opentypespec = callPackage ./non-by-name/opentypespec { };

  openusd = callPackage ./non-by-name/openusd { alembic = pkgs.alembic; };

  openvino = callPackage ./non-by-name/openvino {
    openvino-native = pkgs.openvino.override { python3Packages = self; };
  };

  openvino-genai = callPackage ./non-by-name/openvino-genai {
    openvino-genai-native = pkgs.openvino-genai.override { python3Packages = self; };
  };

  openvino-tokenizers = callPackage ./non-by-name/openvino-tokenizers {
    openvino-tokenizers-native = pkgs.openvino-tokenizers;
  };

  openwebifpy = callPackage ./non-by-name/openwebifpy { };

  openwrt-luci-rpc = callPackage ./non-by-name/openwrt-luci-rpc { };

  openwrt-ubus-rpc = callPackage ./non-by-name/openwrt-ubus-rpc { };

  opower = callPackage ./non-by-name/opower { };

  opsdroid-get-image-size = callPackage ./non-by-name/opsdroid-get-image-size { };

  opt-einsum = callPackage ./non-by-name/opt-einsum { };

  opt-einsum-fx = callPackage ./non-by-name/opt-einsum-fx { };

  optax = callPackage ./non-by-name/optax { };

  optiland = callPackage ./non-by-name/optiland { };

  optimistix = callPackage ./non-by-name/optimistix { };

  optimum = callPackage ./non-by-name/optimum { };

  optimum-onnx = callPackage ./non-by-name/optimum-onnx { };

  optree = callPackage ./non-by-name/optree { };

  optuna = callPackage ./non-by-name/optuna { };

  optuna-dashboard = callPackage ./non-by-name/optuna-dashboard { };

  optype = callPackage ./non-by-name/optype { };

  opuslib = callPackage ./non-by-name/opuslib { };

  opuslib-next = callPackage ./non-by-name/opuslib-next { };

  opytimark = callPackage ./non-by-name/opytimark { };

  oracledb = callPackage ./non-by-name/oracledb { };

  oralb-ble = callPackage ./non-by-name/oralb-ble { };

  oras = callPackage ./non-by-name/oras { };

  orbax-checkpoint = callPackage ./non-by-name/orbax-checkpoint { };

  orbax-export = callPackage ./non-by-name/orbax-export { };

  ordered-set = callPackage ./non-by-name/ordered-set { };

  orderedmultidict = callPackage ./non-by-name/orderedmultidict { };

  orderly-set = callPackage ./non-by-name/orderly-set { };

  orgformat = callPackage ./non-by-name/orgformat { };

  orgparse = callPackage ./non-by-name/orgparse { };

  orjson = callPackage ./non-by-name/orjson { };

  ormar = callPackage ./non-by-name/ormar { };

  ormsgpack = callPackage ./non-by-name/ormsgpack { };

  ortools = callPackage ./non-by-name/ortools {
    or-tools = pkgs.or-tools.override { python3 = self.python; };
  };

  oru = callPackage ./non-by-name/oru { };

  orvibo = callPackage ./non-by-name/orvibo { };

  oryx = callPackage ./non-by-name/oryx { };

  os-client-config = callPackage ./non-by-name/os-client-config { };

  os-service-types = callPackage ./non-by-name/os-service-types { };

  osadl-matrix = callPackage ./non-by-name/osadl-matrix/default.nix { };

  osc = callPackage ./non-by-name/osc { };

  osc-diagram = callPackage ./non-by-name/osc-diagram { };

  osc-lib = callPackage ./non-by-name/osc-lib { };

  osc-placement = callPackage ./non-by-name/osc-placement { };

  osc-sdk-python = callPackage ./non-by-name/osc-sdk-python { };

  oschmod = callPackage ./non-by-name/oschmod { };

  oscpy = callPackage ./non-by-name/oscpy { };

  oscrypto = callPackage ./non-by-name/oscrypto { };

  oscscreen = callPackage ./non-by-name/oscscreen { };

  oset = callPackage ./non-by-name/oset { };

  oslex = callPackage ./non-by-name/oslex { };

  oslo-concurrency = callPackage ./non-by-name/oslo-concurrency { };

  oslo-config = callPackage ./non-by-name/oslo-config { };

  oslo-context = callPackage ./non-by-name/oslo-context { };

  oslo-db = callPackage ./non-by-name/oslo-db { };

  oslo-i18n = callPackage ./non-by-name/oslo-i18n { };

  oslo-log = callPackage ./non-by-name/oslo-log { };

  oslo-metrics = callPackage ./non-by-name/oslo-metrics { };

  oslo-serialization = callPackage ./non-by-name/oslo-serialization { };

  oslo-utils = callPackage ./non-by-name/oslo-utils { };

  oslotest = callPackage ./non-by-name/oslotest { };

  osmapi = callPackage ./non-by-name/osmapi { };

  osmium = callPackage ./non-by-name/osmium { inherit (pkgs) lz4; };

  osmnx = callPackage ./non-by-name/osmnx { };

  osmpythontools = callPackage ./non-by-name/osmpythontools { };

  ospd = callPackage ./non-by-name/ospd { };

  osprofiler = callPackage ./non-by-name/osprofiler { };

  osqp = callPackage ./non-by-name/osqp { };

  osrf-pycommon = callPackage ./non-by-name/osrf-pycommon { };

  osrparse = callPackage ./non-by-name/osrparse { };

  oss2 = callPackage ./non-by-name/oss2 { };

  ossapi = callPackage ./non-by-name/ossapi { };

  ossfs = callPackage ./non-by-name/ossfs { };

  osxphotos = callPackage ./non-by-name/osxphotos { };

  otcextensions = callPackage ./non-by-name/otcextensions { };

  otpauth = callPackage ./non-by-name/otpauth { };

  ots-python = callPackage ./non-by-name/ots-python { };

  otter-grader = callPackage ./non-by-name/otter-grader { };

  otxv2 = callPackage ./non-by-name/otxv2 { };

  ouilookup = callPackage ./non-by-name/ouilookup { };

  ouman-eh-800-api = callPackage ./non-by-name/ouman-eh-800-api { };

  ourgroceries = callPackage ./non-by-name/ourgroceries { };

  ouster-sdk = callPackage ./non-by-name/ouster-sdk {
    inherit (pkgs) ouster-sdk;
  };

  outcome = callPackage ./non-by-name/outcome { };

  outdated = callPackage ./non-by-name/outdated { };

  outlines = callPackage ./non-by-name/outlines { };

  outlines-core = callPackage ./non-by-name/outlines-core { };

  outspin = callPackage ./non-by-name/outspin { };

  overly = callPackage ./non-by-name/overly { };

  overpy = callPackage ./non-by-name/overpy { };

  overrides = callPackage ./non-by-name/overrides { };

  ovh = callPackage ./non-by-name/ovh { };

  ovmfvartool = callPackage ./non-by-name/ovmfvartool { };

  ovoenergy = callPackage ./non-by-name/ovoenergy { };

  owlrl = callPackage ./non-by-name/owlrl { };

  owslib = callPackage ./non-by-name/owslib { };

  oyaml = callPackage ./non-by-name/oyaml { };

  p1monitor = callPackage ./non-by-name/p1monitor { };

  pa-ringbuffer = callPackage ./non-by-name/pa-ringbuffer { };

  packageurl-python = callPackage ./non-by-name/packageurl-python { };

  packaging = callPackage ./non-by-name/packaging { };

  packaging-legacy = callPackage ./non-by-name/packaging-legacy { };

  packbits = callPackage ./non-by-name/packbits { };

  packet-python = callPackage ./non-by-name/packet-python { };

  packvers = callPackage ./non-by-name/packvers { };

  pad4pi = callPackage ./non-by-name/pad4pi { };

  paddle-bfloat = callPackage ./non-by-name/paddle-bfloat { };

  paddle2onnx = callPackage ./non-by-name/paddle2onnx { };

  paddleocr = callPackage ./non-by-name/paddleocr { };

  paddlepaddle = callPackage ./non-by-name/paddlepaddle { };

  paddlex = callPackage ./non-by-name/paddlex { };

  padne = callPackage ./non-by-name/padne { };

  pagelabels = callPackage ./non-by-name/pagelabels { };

  paginate = callPackage ./non-by-name/paginate { };

  paho-mqtt = callPackage ./non-by-name/paho-mqtt/default.nix { };

  paintcompiler = callPackage ./non-by-name/paintcompiler { };

  pajgps-api = callPackage ./non-by-name/pajgps-api { };

  palace = callPackage ./non-by-name/palace { };

  palettable = callPackage ./non-by-name/palettable { };

  pallets-sphinx-themes = callPackage ./non-by-name/pallets-sphinx-themes { };

  pamela = callPackage ./non-by-name/pamela { };

  pamqp = callPackage ./non-by-name/pamqp { };

  pan-os-python = callPackage ./non-by-name/pan-os-python { };

  pan-python = callPackage ./non-by-name/pan-python { };

  panacotta = callPackage ./non-by-name/panacotta { };

  panasonic-viera = callPackage ./non-by-name/panasonic-viera { };

  pandantic = callPackage ./non-by-name/pandantic { };

  pandas = callPackage ./non-by-name/pandas { inherit (pkgs.darwin) adv_cmds; };

  pandas-datareader = callPackage ./non-by-name/pandas-datareader { };

  pandas-flavor = callPackage ./non-by-name/pandas-flavor { };

  pandas-stubs = callPackage ./non-by-name/pandas-stubs { };

  pandera = callPackage ./non-by-name/pandera { };

  pandoc-attributes = callPackage ./non-by-name/pandoc-attributes { };

  pandoc-latex-environment = callPackage ./non-by-name/pandoc-latex-environment { };

  pandoc-xnos = callPackage ./non-by-name/pandoc-xnos { };

  pandocfilters = callPackage ./non-by-name/pandocfilters { };

  panel = callPackage ./non-by-name/panel { };

  panel-material-ui = callPackage ./non-by-name/panel-material-ui { };

  panflute = callPackage ./non-by-name/panflute { };

  panphon = callPackage ./non-by-name/panphon { };

  panzi-json-logic = callPackage ./non-by-name/panzi-json-logic { };

  paperbush = callPackage ./non-by-name/paperbush { };

  paperless-ngx-erechnung = callPackage ./non-by-name/paperless-ngx-erechnung {
    inherit (pkgs) fop;
  };

  papermill = callPackage ./non-by-name/papermill { };

  paperwork-backend = callPackage ../../applications/office/paperwork/paperwork-backend.nix { };

  paperwork-shell = callPackage ../../applications/office/paperwork/paperwork-shell.nix { };

  papis = callPackage ./non-by-name/papis { };

  papis-python-rofi = callPackage ./non-by-name/papis-python-rofi { };

  para = callPackage ./non-by-name/para { };

  paradict = callPackage ./non-by-name/paradict { };

  paragraphs = callPackage ./non-by-name/paragraphs { };

  parallel-ssh = callPackage ./non-by-name/parallel-ssh { };

  param = callPackage ./non-by-name/param { };

  paramax = callPackage ./non-by-name/paramax { };

  parameter-decorators = callPackage ./non-by-name/parameter-decorators { };

  parameter-expansion-patched = callPackage ./non-by-name/parameter-expansion-patched { };

  parameterized = callPackage ./non-by-name/parameterized { };

  parametrize-from-file = callPackage ./non-by-name/parametrize-from-file { };

  paramiko = callPackage ./non-by-name/paramiko { };

  parfive = callPackage ./non-by-name/parfive { };

  parquet = callPackage ./non-by-name/parquet { };

  parse = callPackage ./non-by-name/parse { };

  parse-crontab = callPackage ./non-by-name/parse-crontab { };

  parse-type = callPackage ./non-by-name/parse-type { };

  parsedatetime = callPackage ./non-by-name/parsedatetime { };

  parsedmarc = callPackage ./non-by-name/parsedmarc { };

  parsel = callPackage ./non-by-name/parsel { };

  parsimonious = callPackage ./non-by-name/parsimonious { };

  parsley = callPackage ./non-by-name/parsley { };

  parsnip-cif = callPackage ./non-by-name/parsnip-cif { };

  parso = callPackage ./non-by-name/parso { };

  parsy = callPackage ./non-by-name/parsy { };

  partd = callPackage ./non-by-name/partd { };

  partftpy = callPackage ./non-by-name/partftpy { };

  partial-json-parser = callPackage ./non-by-name/partial-json-parser { };

  particle = callPackage ./non-by-name/particle { };

  parts = callPackage ./non-by-name/parts { };

  parver = callPackage ./non-by-name/parver { };

  pasimple = callPackage ./non-by-name/pasimple { };

  passlib = callPackage ./non-by-name/passlib { };

  paste = callPackage ./non-by-name/paste { };

  pastedeploy = callPackage ./non-by-name/pastedeploy { };

  pastel = callPackage ./non-by-name/pastel { };

  pastescript = callPackage ./non-by-name/pastescript { };

  patch = callPackage ./non-by-name/patch { };

  patch-ng = callPackage ./non-by-name/patch-ng { };

  patchpy = callPackage ./non-by-name/patchpy { };

  patchright = callPackage ./non-by-name/patchright { };

  path = callPackage ./non-by-name/path { };

  path-and-address = callPackage ./non-by-name/path-and-address { };

  pathable = callPackage ./non-by-name/pathable { };

  pathlib-abc = callPackage ./non-by-name/pathlib-abc { };

  pathlib2 = callPackage ./non-by-name/pathlib2 { };

  pathos = callPackage ./non-by-name/pathos { };

  pathspec = callPackage ./non-by-name/pathspec { };

  pathtools = callPackage ./non-by-name/pathtools { };

  pathvalidate = callPackage ./non-by-name/pathvalidate { };

  pathy = callPackage ./non-by-name/pathy { };

  patiencediff = callPackage ./non-by-name/patiencediff { };

  patool = callPackage ./non-by-name/patool { };

  patrowl4py = callPackage ./non-by-name/patrowl4py { };

  patsy = callPackage ./non-by-name/patsy { };

  paver = callPackage ./non-by-name/paver { };

  paypal-checkout-serversdk = callPackage ./non-by-name/paypal-checkout-serversdk { };

  paypalhttp = callPackage ./non-by-name/paypalhttp { };

  paypalrestsdk = callPackage ./non-by-name/paypalrestsdk { };

  pbar2 = callPackage ./non-by-name/pbar2 { };

  pbkdf2 = callPackage ./non-by-name/pbkdf2 { };

  pbr = callPackage ./non-by-name/pbr { };

  pbs-installer = callPackage ./non-by-name/pbs-installer { };

  pbxproj = callPackage ./non-by-name/pbxproj { };

  pcapy-ng = callPackage ./non-by-name/pcapy-ng {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  pcffont = callPackage ./non-by-name/pcffont { };

  pcodec = callPackage ./non-by-name/pcodec { };

  pcodedmp = callPackage ./non-by-name/pcodedmp { };

  pcpp = callPackage ./non-by-name/pcpp { };

  pcre2-py = callPackage ./non-by-name/pcre2-py { };

  pdb2pqr = callPackage ./non-by-name/pdb2pqr { };

  pdbfixer = callPackage ./non-by-name/pdbfixer { };

  pdf-oxide = callPackage ./non-by-name/pdf-oxide { };

  pdf2docx = callPackage ./non-by-name/pdf2docx { };

  pdf2image = callPackage ./non-by-name/pdf2image { };

  pdfkit = callPackage ./non-by-name/pdfkit { };

  pdfminer-six = callPackage ./non-by-name/pdfminer-six { };

  pdfplumber = callPackage ./non-by-name/pdfplumber { };

  pdfquery = callPackage ./non-by-name/pdfquery { };

  pdfrw = callPackage ./non-by-name/pdfrw { };

  pdfrw2 = callPackage ./non-by-name/pdfrw2 { };

  pdfservices-sdk = callPackage ./non-by-name/pdfservices-sdk { };

  pdftotext = callPackage ./non-by-name/pdftotext { };

  pdm-backend = callPackage ./non-by-name/pdm-backend { };

  pdm-build-locked = callPackage ./non-by-name/pdm-build-locked { };

  pdm-pep517 = callPackage ./non-by-name/pdm-pep517 { };

  pdoc = callPackage ./non-by-name/pdoc { };

  pdoc-pyo3-sample-library = callPackage ./non-by-name/pdoc-pyo3-sample-library { };

  pdoc3 = callPackage ./non-by-name/pdoc3 { };

  pdunehd = callPackage ./non-by-name/pdunehd { };

  peacasso = callPackage ./non-by-name/peacasso { };

  peakrdl-cheader = callPackage ./non-by-name/peakrdl-cheader { };

  peakrdl-cli = callPackage ./non-by-name/peakrdl-cli { };

  peakrdl-ipxact = callPackage ./non-by-name/peakrdl-ipxact { };

  peakrdl-markdown = callPackage ./non-by-name/peakrdl-markdown { };

  peakrdl-regblock = callPackage ./non-by-name/peakrdl-regblock { };

  peakrdl-rust = callPackage ./non-by-name/peakrdl-rust { };

  peakutils = callPackage ./non-by-name/peakutils { };

  peaqevcore = callPackage ./non-by-name/peaqevcore { };

  pebble = callPackage ./non-by-name/pebble { };

  peblar = callPackage ./non-by-name/peblar { };

  pecan = callPackage ./non-by-name/pecan { };

  peco = callPackage ./non-by-name/peco { };

  peewee = callPackage ./non-by-name/peewee { };

  peewee-migrate = callPackage ./non-by-name/peewee-migrate { };

  peewee-migrate_1 = callPackage ./non-by-name/peewee-migrate/1.nix { };

  peewee_3 = callPackage ./non-by-name/peewee/3.nix { };

  pefile = callPackage ./non-by-name/pefile { };

  peft = callPackage ./non-by-name/peft { };

  pegen = callPackage ./non-by-name/pegen { };

  pelican = callPackage ./non-by-name/pelican { inherit (pkgs) glibcLocales git; };

  pem = callPackage ./non-by-name/pem { };

  pencompy = callPackage ./non-by-name/pencompy { };

  pendulum = callPackage ./non-by-name/pendulum { };

  pentapy = callPackage ./non-by-name/pentapy { };

  pep440 = callPackage ./non-by-name/pep440 { };

  pep517 = callPackage ./non-by-name/pep517 { };

  pep8 = callPackage ./non-by-name/pep8 { };

  pep8-naming = callPackage ./non-by-name/pep8-naming { };

  pepit = callPackage ./non-by-name/pepit { };

  peppercorn = callPackage ./non-by-name/peppercorn { };

  perfplot = callPackage ./non-by-name/perfplot { };

  periodictable = callPackage ./non-by-name/periodictable { };

  periodiq = callPackage ./non-by-name/periodiq { };

  permissionedforms = callPackage ./non-by-name/permissionedforms { };

  perplexityai = callPackage ./non-by-name/perplexityai { };

  persim = callPackage ./non-by-name/persim { };

  persist-queue = callPackage ./non-by-name/persist-queue { };

  persistent = callPackage ./non-by-name/persistent { };

  persisting-theory = callPackage ./non-by-name/persisting-theory { };

  pescea = callPackage ./non-by-name/pescea { };

  pesq = callPackage ./non-by-name/pesq { };

  petl = callPackage ./non-by-name/petl { };

  petsc4py = toPythonModule (
    pkgs.petsc.override {
      python3Packages = self;
      pythonSupport = true;
    }
  );

  petsctools = callPackage ./non-by-name/petsctools { };

  pettingzoo = callPackage ./non-by-name/pettingzoo { };

  pex = callPackage ./non-by-name/pex { };

  pex-entysec = callPackage ./non-by-name/pex-entysec { };

  pexif = callPackage ./non-by-name/pexif { };

  pexpect = callPackage ./non-by-name/pexpect { };

  pfzy = callPackage ./non-by-name/pfzy { };

  pg8000 = callPackage ./non-by-name/pg8000 { };

  pgcli = callPackage ./non-by-name/pgcli { };

  pglast = callPackage ./non-by-name/pglast { };

  pglive = callPackage ./non-by-name/pglive { };

  pgmpy = callPackage ./non-by-name/pgmpy { };

  pgpdump = callPackage ./non-by-name/pgpdump { };

  pgpy = callPackage ./non-by-name/pgpy { };

  pgpy-dtc = callPackage ./non-by-name/pgpy-dtc { };

  pgsanity = callPackage ./non-by-name/pgsanity { };

  pgspecial = callPackage ./non-by-name/pgspecial { };

  pgsrip = callPackage ./non-by-name/pgsrip { };

  pgvector = callPackage ./non-by-name/pgvector { };

  phart = callPackage ./non-by-name/phart { };

  phe = callPackage ./non-by-name/phe { };

  phik = callPackage ./non-by-name/phik { };

  philipstv = callPackage ./non-by-name/philipstv { };

  phone-modem = callPackage ./non-by-name/phone-modem { };

  phonemizer = callPackage ./non-by-name/phonemizer { };

  phonenumbers = callPackage ./non-by-name/phonenumbers { };

  phonenumberslite = callPackage ./non-by-name/phonenumberslite { };

  phonopy = callPackage ./non-by-name/phonopy { };

  phonors = callPackage ./non-by-name/phonors { };

  photutils = callPackage ./non-by-name/photutils { };

  phply = callPackage ./non-by-name/phply { };

  phpserialize = callPackage ./non-by-name/phpserialize { };

  phunspell = callPackage ./non-by-name/phunspell { };

  phx-class-registry = callPackage ./non-by-name/phx-class-registry { };

  pi1wire = callPackage ./non-by-name/pi1wire { };

  piccata = callPackage ./non-by-name/piccata { };

  piccolo = callPackage ./non-by-name/piccolo { };

  piccolo-theme = callPackage ./non-by-name/piccolo-theme { };

  pick = callPackage ./non-by-name/pick { };

  pickleshare = callPackage ./non-by-name/pickleshare { };

  pickpack = callPackage ./non-by-name/pickpack { };

  picobox = callPackage ./non-by-name/picobox { };

  picologging = callPackage ./non-by-name/picologging { };

  picos = callPackage ./non-by-name/picos { };

  picosvg = callPackage ./non-by-name/picosvg { };

  pid = callPackage ./non-by-name/pid { };

  piep = callPackage ./non-by-name/piep { };

  piexif = callPackage ./non-by-name/piexif { };

  pigpio = toPythonModule (
    pkgs.pigpio.override {
      inherit buildPythonPackage;
    }
  );

  pijuice = callPackage ./non-by-name/pijuice { };

  pika = callPackage ./non-by-name/pika { };

  pika-pool = callPackage ./non-by-name/pika-pool { };

  pikepdf = callPackage ./non-by-name/pikepdf { };

  pilkit = callPackage ./non-by-name/pilkit { };

  pillow = callPackage ./non-by-name/pillow {
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
      libxcb
      ;
  };

  pillow-heif = callPackage ./non-by-name/pillow-heif { };

  pillow-jpls = callPackage ./non-by-name/pillow-jpls { };

  pillow-jxl-plugin = callPackage ./non-by-name/pillow-jxl-plugin { };

  pims = callPackage ./non-by-name/pims { };

  pinboard = callPackage ./non-by-name/pinboard { };

  pinecone = callPackage ./non-by-name/pinecone { };

  ping3 = callPackage ./non-by-name/ping3 { };

  pingouin = callPackage ./non-by-name/pingouin { };

  pinocchio = callPackage ./non-by-name/pinocchio { inherit (pkgs) pinocchio; };

  pins = callPackage ./non-by-name/pins { };

  pint = callPackage ./non-by-name/pint { };

  pint-pandas = callPackage ./non-by-name/pint-pandas { };

  pint-xarray = callPackage ./non-by-name/pint-xarray { };

  pip = callPackage ./non-by-name/pip { };

  pip-api = callPackage ./non-by-name/pip-api { };

  pip-chill = callPackage ./non-by-name/pip-chill { };

  pip-install-test = callPackage ./non-by-name/pip-install-test { };

  pip-requirements-parser = callPackage ./non-by-name/pip-requirements-parser { };

  pip-system-certs = callPackage ./non-by-name/pip-system-certs { };

  pip-tools = callPackage ./non-by-name/pip-tools { };

  pipcl = callPackage ./non-by-name/pipcl { };

  pipdate = callPackage ./non-by-name/pipdate { };

  pipdeptree = callPackage ./non-by-name/pipdeptree { };

  pipe = callPackage ./non-by-name/pipe { };

  piper-phonemize = callPackage ./non-by-name/piper-phonemize {
    onnxruntime-native = pkgs.onnxruntime;
    piper-phonemize-native = pkgs.piper-phonemize;
  };

  pipetools = callPackage ./non-by-name/pipetools { };

  pipx = callPackage ./non-by-name/pipx { };

  piqp = callPackage ./non-by-name/piqp { };

  pivy = callPackage ./non-by-name/pivy { };

  pixcat = callPackage ./non-by-name/pixcat { };

  pixel-font-builder = callPackage ./non-by-name/pixel-font-builder { };

  pixel-font-knife = callPackage ./non-by-name/pixel-font-knife { };

  pixel-ring = callPackage ./non-by-name/pixel-ring { };

  pixelmatch = callPackage ./non-by-name/pixelmatch { };

  pjsua2 =
    (toPythonModule (
      pkgs.pjsip.override {
        pythonSupport = true;
        python3 = self.python;
      }
    )).py;

  pkce = callPackage ./non-by-name/pkce { };

  pkg-about = callPackage ./non-by-name/pkg-about { };

  pkg-resources-backport = callPackage ./non-by-name/pkg-resources-backport { };

  pkgconfig = callPackage ./non-by-name/pkgconfig { };

  pkginfo = callPackage ./non-by-name/pkginfo { };

  pkginfo2 = callPackage ./non-by-name/pkginfo2 { };

  pkgutil-resolve-name = callPackage ./non-by-name/pkgutil-resolve-name { };

  plac = callPackage ./non-by-name/plac { };

  plaid-python = callPackage ./non-by-name/plaid-python { };

  planetary-computer = callPackage ./non-by-name/planetary-computer { };

  plantuml = callPackage ./non-by-name/plantuml { };

  plantuml-markdown = callPackage ./non-by-name/plantuml-markdown {
    inherit (pkgs) plantuml;
  };

  plasTeX = callPackage ./non-by-name/plasTeX { };

  plaster = callPackage ./non-by-name/plaster { };

  plaster-pastedeploy = callPackage ./non-by-name/plaster-pastedeploy { };

  plastexdepgraph = callPackage ./non-by-name/plastexdepgraph { };

  plastexshowmore = callPackage ./non-by-name/plastexshowmore { };

  platformdirs = callPackage ./non-by-name/platformdirs { };

  playsound = callPackage ./non-by-name/playsound { };

  playwright = callPackage ./non-by-name/playwright { };

  playwright-stealth = callPackage ./non-by-name/playwright-stealth { };

  playwrightcapture = callPackage ./non-by-name/playwrightcapture { };

  pleroma-bot = callPackage ./non-by-name/pleroma-bot { };

  plexapi = callPackage ./non-by-name/plexapi { };

  plexauth = callPackage ./non-by-name/plexauth { };

  plexwebsocket = callPackage ./non-by-name/plexwebsocket { };

  plfit = toPythonModule (
    pkgs.plfit.override {
      withPython = true;
      inherit (self) python;
    }
  );

  plink = callPackage ./non-by-name/plink { };

  plone-testing = callPackage ./non-by-name/plone-testing { };

  ploomber-core = callPackage ./non-by-name/ploomber-core { };

  plopp = callPackage ./non-by-name/plopp { };

  plotext = callPackage ./non-by-name/plotext { };

  plotille = callPackage ./non-by-name/plotille { };

  plotly = callPackage ./non-by-name/plotly { };

  plotnine = callPackage ./non-by-name/plotnine { };

  plotpy = callPackage ./non-by-name/plotpy { };

  # Use Plover 5 as Plover 4 depends on setuptool's pkg_resources to discover plugins,
  # which the setuptools upstream deprecated at version 81.0.0 and removed at version 82.0.0
  # Plover 5 has addressed this issue by switching to importlib.meta.distributions()
  #
  # NOTE:
  # Plover 5 moves from PyQt5 to PySide6,
  # which is a backward-incompatible change to graphical plugins.
  # List of unsupported plugins:
  # https://github.com/opensteno/plover_plugins_registry/blob/master/unsupported.json
  plover = plover_5;

  plover-combo = callPackage ./non-by-name/plover-combo { };

  plover-dict-commands = callPackage ./non-by-name/plover-dict-commands { };

  plover-lapwing-aio = callPackage ./non-by-name/plover-lapwing-aio { };

  plover-last-translation = callPackage ./non-by-name/plover-last-translation { };

  plover-modal-dictionary = callPackage ./non-by-name/plover-modal-dictionary { };

  plover-python-dictionary = callPackage ./non-by-name/plover-python-dictionary { };

  plover-stitching = callPackage ./non-by-name/plover-stitching { };

  plover-stroke = callPackage ./non-by-name/plover-stroke { };

  plover_4 = callPackage ./non-by-name/plover/4.nix {
    inherit (pkgs.libsForQt5) wrapQtAppsHook;
  };

  plover_5 = callPackage ./non-by-name/plover/5.nix {
    inherit (pkgs.qt6) qtbase wrapQtAppsHook qtsvg;
  };

  pluggy = callPackage ./non-by-name/pluggy { };

  pluginbase = callPackage ./non-by-name/pluginbase { };

  plugincode = callPackage ./non-by-name/plugincode { };

  pluginlib = callPackage ./non-by-name/pluginlib { };

  plugnplay = callPackage ./non-by-name/plugnplay { };

  plugp100 = callPackage ./non-by-name/plugp100 { };

  plugwise = callPackage ./non-by-name/plugwise { };

  plum-dispatch = callPackage ./non-by-name/plum-dispatch { };

  plum-py = callPackage ./non-by-name/plum-py { };

  plumbum = callPackage ./non-by-name/plumbum { };

  plumed = callPackage ./non-by-name/plumed {
    inherit (pkgs) plumed;
  };

  pluralizer = callPackage ./non-by-name/pluralizer { };

  pluthon = callPackage ./non-by-name/pluthon { };

  pluto = callPackage ./non-by-name/pluto { };

  plux = callPackage ./non-by-name/plux { };

  ply = callPackage ./non-by-name/ply { };

  plyara = callPackage ./non-by-name/plyara { };

  plyer = callPackage ./non-by-name/plyer { };

  plyfile = callPackage ./non-by-name/plyfile { };

  plyplus = callPackage ./non-by-name/plyplus { };

  plyvel = callPackage ./non-by-name/plyvel { };

  pmdarima = callPackage ./non-by-name/pmdarima { };

  pmdsky-debug-py = callPackage ./non-by-name/pmdsky-debug-py { };

  pmsensor = callPackage ./non-by-name/pmsensor { };

  pmw = callPackage ./non-by-name/pmw { };

  pnglatex = callPackage ./non-by-name/pnglatex { };

  pocket = callPackage ./non-by-name/pocket { };

  pocket-tts = callPackage ./non-by-name/pocket-tts { };

  pocketsphinx = callPackage ./non-by-name/pocketsphinx {
    inherit (pkgs) pocketsphinx;
  };

  podcastparser = callPackage ./non-by-name/podcastparser { };

  podcats = callPackage ./non-by-name/podcats { };

  podgen = callPackage ./non-by-name/podgen { };

  podman = callPackage ./non-by-name/podman { };

  poetry-core = callPackage ./non-by-name/poetry-core { };

  poetry-dynamic-versioning = callPackage ./non-by-name/poetry-dynamic-versioning { };

  poetry-semver = callPackage ./non-by-name/poetry-semver { };

  polarizationsolver = callPackage ./non-by-name/polarizationsolver { };

  polars = callPackage ./non-by-name/polars { };

  polib = callPackage ./non-by-name/polib { };

  policy-sentry = callPackage ./non-by-name/policy-sentry { };

  policyuniverse = callPackage ./non-by-name/policyuniverse { };

  polling = callPackage ./non-by-name/polling { };

  polyfactory = callPackage ./non-by-name/polyfactory { };

  polygon3 = callPackage ./non-by-name/polygon3 { };

  polygraphy = callPackage ./non-by-name/polygraphy { };

  polyline = callPackage ./non-by-name/polyline { };

  polyswarm-api = callPackage ./non-by-name/polyswarm-api { };

  pomegranate = callPackage ./non-by-name/pomegranate { };

  pontos = callPackage ./non-by-name/pontos { };

  pony = callPackage ./non-by-name/pony { };

  ponywhoosh = callPackage ./non-by-name/ponywhoosh { };

  pooch = callPackage ./non-by-name/pooch { };

  pook = callPackage ./non-by-name/pook { };

  poolsense = callPackage ./non-by-name/poolsense { };

  poppler-qt5 = callPackage ./non-by-name/poppler-qt5 {
    inherit (pkgs.qt5) qtbase qmake;
    inherit (pkgs.libsForQt5) poppler;
  };

  port-for = callPackage ./non-by-name/port-for { };

  portalocker = callPackage ./non-by-name/portalocker { };

  portend = callPackage ./non-by-name/portend { };

  portion = callPackage ./non-by-name/portion { };

  portpicker = callPackage ./non-by-name/portpicker { };

  posix-ipc = callPackage ./non-by-name/posix-ipc { };

  postgrest = callPackage ./non-by-name/postgrest { };

  posthog = callPackage ./non-by-name/posthog { };

  pot = callPackage ./non-by-name/pot { };

  potentials = callPackage ./non-by-name/potentials { };

  potr = callPackage ./non-by-name/potr { };

  power = callPackage ./non-by-name/power { };

  powerapi = callPackage ./non-by-name/powerapi { };

  powerfox = callPackage ./non-by-name/powerfox { };

  powerline = callPackage ./non-by-name/powerline { };

  powerline-mem-segment = callPackage ./non-by-name/powerline-mem-segment { };

  pox = callPackage ./non-by-name/pox { };

  poyo = callPackage ./non-by-name/poyo { };

  ppdeep = callPackage ./non-by-name/ppdeep { };

  ppf-datamatrix = callPackage ./non-by-name/ppf-datamatrix { };

  ppft = callPackage ./non-by-name/ppft { };

  ppk2-api = callPackage ./non-by-name/ppk2-api { };

  pplpy = callPackage ./non-by-name/pplpy { };

  pprintpp = callPackage ./non-by-name/pprintpp { };

  pproxy = callPackage ./non-by-name/pproxy { };

  ppscore = callPackage ./non-by-name/ppscore { };

  pq = callPackage ./non-by-name/pq { };

  pqc-audit = callPackage ./non-by-name/pqc-audit { };

  praat-parselmouth = callPackage ./non-by-name/praat-parselmouth { };

  prana-api-client = callPackage ./non-by-name/prana-api-client { };

  prance = callPackage ./non-by-name/prance { };

  praw = callPackage ./non-by-name/praw { };

  prawcore = callPackage ./non-by-name/prawcore { };

  prayer-times-calculator-offline = callPackage ./non-by-name/prayer-times-calculator-offline { };

  pre-commit-hooks = callPackage ./non-by-name/pre-commit-hooks { };

  pre-commit-po-hooks = callPackage ./non-by-name/pre-commit-po-hooks { };

  precis-i18n = callPackage ./non-by-name/precis-i18n { };

  precisely = callPackage ./non-by-name/precisely { };

  prefect = callPackage ./non-by-name/prefect { };

  prefixed = callPackage ./non-by-name/prefixed { };

  preggy = callPackage ./non-by-name/preggy { };

  premailer = callPackage ./non-by-name/premailer { };

  preprocess-cancellation = callPackage ./non-by-name/preprocess-cancellation { };

  presenterm-export = callPackage ./non-by-name/presenterm-export { };

  preshed = callPackage ./non-by-name/preshed { };

  presto-python-client = callPackage ./non-by-name/presto-python-client { };

  pretend = callPackage ./non-by-name/pretend { };

  pretty-errors = callPackage ./non-by-name/pretty-errors { };

  prettytable = callPackage ./non-by-name/prettytable { };

  price-parser = callPackage ./non-by-name/price-parser { };

  pricehist = callPackage ./non-by-name/pricehist { };

  prime-pydantic-config = callPackage ./non-by-name/prime-pydantic-config { };

  primecountpy = callPackage ./non-by-name/primecountpy { };

  primepy = callPackage ./non-by-name/primepy { };

  primer3-py = callPackage ./non-by-name/primer3-py { };

  primp = callPackage ./non-by-name/primp { zstd-c = pkgs.zstd; };

  print-color = callPackage ./non-by-name/print-color { };

  priority = callPackage ./non-by-name/priority { };

  prisma = callPackage ./non-by-name/prisma { };

  prison = callPackage ./non-by-name/prison { };

  probatio = callPackage ./non-by-name/probatio { };

  probed = callPackage ./non-by-name/probed { };

  process-tests = callPackage ./non-by-name/process-tests { };

  procmon-parser = callPackage ./non-by-name/procmon-parser { };

  prodict = callPackage ./non-by-name/prodict { };

  progettihwsw = callPackage ./non-by-name/progettihwsw { };

  proglog = callPackage ./non-by-name/proglog { };

  progress = callPackage ./non-by-name/progress { };

  progressbar = callPackage ./non-by-name/progressbar { };

  progressbar2 = callPackage ./non-by-name/progressbar2 { };

  progressbar33 = callPackage ./non-by-name/progressbar33 { };

  proliphix = callPackage ./non-by-name/proliphix { };

  prometheus-api-client = callPackage ./non-by-name/prometheus-api-client { };

  prometheus-async = callPackage ./non-by-name/prometheus-async { };

  prometheus-client = callPackage ./non-by-name/prometheus-client { };

  prometheus-fastapi-instrumentator = callPackage ./non-by-name/prometheus-fastapi-instrumentator { };

  prometheus-flask-exporter = callPackage ./non-by-name/prometheus-flask-exporter { };

  prometheus-pandas = callPackage ./non-by-name/prometheus-pandas { };

  prometrix = callPackage ./non-by-name/prometrix { };

  promise = callPackage ./non-by-name/promise { };

  prompt-toolkit = callPackage ./non-by-name/prompt-toolkit { };

  prompthub-py = callPackage ./non-by-name/prompthub-py { };

  propcache = callPackage ./non-by-name/propcache { };

  property-cached = callPackage ./non-by-name/property-cached { };

  property-manager = callPackage ./non-by-name/property-manager { };

  prophet = callPackage ./non-by-name/prophet { };

  propka = callPackage ./non-by-name/propka { };

  prosemirror = callPackage ./non-by-name/prosemirror { };

  protego = callPackage ./non-by-name/protego { };

  proto-plus = callPackage ./non-by-name/proto-plus { };

  # If a protobuf upgrade causes many Python packages to fail, please pin it here to the previous version.
  protobuf = protobuf7;

  protobuf-py = callPackage ./non-by-name/protobuf-py { };

  protobuf-py-ext = callPackage ./non-by-name/protobuf-py-ext { };

  protobuf-py-pure = callPackage ./non-by-name/protobuf-py-pure { };

  protobuf3-to-dict = callPackage ./non-by-name/protobuf3-to-dict { };

  # Protobuf 4.x
  protobuf4 = callPackage ./non-by-name/protobuf/4.nix {
    protobuf = pkgs.protobuf_25;
  };

  # Protobuf 5.x
  protobuf5 = callPackage ./non-by-name/protobuf/5.nix {
    protobuf = pkgs.__splicedPackages.protobuf_29;
  };

  # Protobuf 6.x
  protobuf6 = callPackage ./non-by-name/protobuf/6.nix {
    protobuf = pkgs.__splicedPackages.protobuf_33;
  };

  # Protobuf 7.x
  protobuf7 = callPackage ./non-by-name/protobuf/7.nix {
    inherit (pkgs.__splicedPackages) protobuf;
  };

  protoletariat = callPackage ./non-by-name/protoletariat { };

  proton-core = callPackage ./non-by-name/proton-core { };

  proton-keyring-linux = callPackage ./non-by-name/proton-keyring-linux { };

  proton-vpn-api-core = callPackage ./non-by-name/proton-vpn-api-core { };

  proton-vpn-daemon = callPackage ./non-by-name/proton-vpn-daemon { };

  proton-vpn-local-agent = callPackage ./non-by-name/proton-vpn-local-agent { };

  protonup-ng = callPackage ./non-by-name/protonup-ng { };

  prototext-codec = callPackage ./non-by-name/prototext-codec { };

  prototext-graph = callPackage ./non-by-name/prototext-graph { };

  prov = callPackage ./non-by-name/prov { };

  prowlpy = callPackage ./non-by-name/prowlpy { };

  prox-tv = callPackage ./non-by-name/prox-tv { };

  proxmoxer = callPackage ./non-by-name/proxmoxer { };

  proxsuite = toPythonModule (
    pkgs.proxsuite.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  proxy-db = callPackage ./non-by-name/proxy-db { };

  proxy-py = callPackage ./non-by-name/proxy-py { };

  proxy-tools = callPackage ./non-by-name/proxy-tools { };

  psautohint = callPackage ./non-by-name/psautohint { };

  pscript = callPackage ./non-by-name/pscript { };

  psd-tools = callPackage ./non-by-name/psd-tools { };

  psnawp = callPackage ./non-by-name/psnawp { };

  psptool = callPackage ./non-by-name/psptool { };

  psrpcore = callPackage ./non-by-name/psrpcore { };

  psutil = callPackage ./non-by-name/psutil { };

  psutil-home-assistant = callPackage ./non-by-name/psutil-home-assistant { };

  psychrolib = callPackage ./non-by-name/psychrolib { };

  psycopg = callPackage ./non-by-name/psycopg { };

  psycopg-c = psycopg.c;

  psycopg-pool = psycopg.pool;

  psycopg2 = callPackage ./non-by-name/psycopg2 { };

  psycopg2-binary = callPackage ./non-by-name/psycopg2-binary { };

  psycopg2cffi = callPackage ./non-by-name/psycopg2cffi { };

  psygnal = callPackage ./non-by-name/psygnal { };

  ptest = callPackage ./non-by-name/ptest { };

  ptpython = callPackage ./non-by-name/ptpython { };

  ptyprocess = callPackage ./non-by-name/ptyprocess { };

  publicsuffix2 = callPackage ./non-by-name/publicsuffix2 { };

  publicsuffixlist = callPackage ./non-by-name/publicsuffixlist { };

  pubnub = callPackage ./non-by-name/pubnub { };

  pubnubsub-handler = callPackage ./non-by-name/pubnubsub-handler { };

  pudb = callPackage ./non-by-name/pudb { };

  pueblo = callPackage ./non-by-name/pueblo { };

  pulp = callPackage ./non-by-name/pulp { };

  pulsar-client = callPackage ./non-by-name/pulsar-client { };

  pulsectl = callPackage ./non-by-name/pulsectl { };

  pulsectl-asyncio = callPackage ./non-by-name/pulsectl-asyncio { };

  pulumi = callPackage ./non-by-name/pulumi { };

  pulumi-aws = callPackage ./non-by-name/pulumi-aws { };

  pulumi-aws-native = callPackage pkgs.pulumiPackages.pulumi-aws-native.sdks.python.override { };

  pulumi-azure-native = callPackage pkgs.pulumiPackages.pulumi-azure-native.sdks.python.override { };

  pulumi-command = callPackage pkgs.pulumiPackages.pulumi-command.sdks.python.override { };

  pulumi-hcloud = callPackage pkgs.pulumiPackages.pulumi-hcloud.sdks.python.override { };

  pulumi-kubernetes =
    callPackage
      (pkgs.pulumiPackages.pulumi-kubernetes.override { python3Packages = self; }).sdks.python.override
      { };

  pulumi-linode = callPackage pkgs.pulumiPackages.pulumi-linode.sdks.python.override { };

  pulumi-random = callPackage pkgs.pulumiPackages.pulumi-random.sdks.python.override { };

  pulumiverse-talos = callPackage pkgs.pulumiPackages.pulumiverse-talos.sdks.python.override { };

  puppetparser = callPackage ./non-by-name/puppetparser { };

  pure-cdb = callPackage ./non-by-name/pure-cdb { };

  pure-eval = callPackage ./non-by-name/pure-eval { };

  pure-magic-rs = callPackage ./non-by-name/pure-magic-rs { };

  pure-pcapy3 = callPackage ./non-by-name/pure-pcapy3 { };

  pure-protobuf = callPackage ./non-by-name/pure-protobuf { };

  pure-python-adb = callPackage ./non-by-name/pure-python-adb { };

  pure-python-adb-homeassistant = callPackage ./non-by-name/pure-python-adb-homeassistant { };

  pure-sasl = callPackage ./non-by-name/pure-sasl { };

  puremagic = callPackage ./non-by-name/puremagic { };

  purepng = callPackage ./non-by-name/purepng { };

  purl = callPackage ./non-by-name/purl { };

  pushbullet-py = callPackage ./non-by-name/pushbullet-py { };

  pushover-complete = callPackage ./non-by-name/pushover-complete { };

  pvextractor = callPackage ./non-by-name/pvextractor { };

  pvl = callPackage ./non-by-name/pvl { };

  pvlib = callPackage ./non-by-name/pvlib { };

  pvo = callPackage ./non-by-name/pvo { };

  pwdlib = callPackage ./non-by-name/pwdlib { };

  pweave = callPackage ./non-by-name/pweave { };

  pwinput = callPackage ./non-by-name/pwinput { };

  pwkit = callPackage ./non-by-name/pwkit { };

  pwlf = callPackage ./non-by-name/pwlf { };

  pwntools = callPackage ./non-by-name/pwntools { debugger = pkgs.gdb; };

  py = callPackage ./non-by-name/py { };

  py-air-control = callPackage ./non-by-name/py-air-control { };

  py-air-control-exporter = callPackage ./non-by-name/py-air-control-exporter { };

  py-aosmith = callPackage ./non-by-name/py-aosmith { };

  py-arwen = callPackage ./non-by-name/py-arwen { };

  py-bip39-bindings = callPackage ./non-by-name/py-bip39-bindings { };

  py-build-cmake = callPackage ./non-by-name/py-build-cmake { };

  py-canary = callPackage ./non-by-name/py-canary { };

  py-ccm15 = callPackage ./non-by-name/py-ccm15 { };

  py-cid = callPackage ./non-by-name/py-cid { };

  py-cpuinfo = callPackage ./non-by-name/py-cpuinfo { };

  py-cpuinfo2 = callPackage ./non-by-name/py-cpuinfo2 { };

  py-dactyl = callPackage ./non-by-name/py-dactyl { };

  py-datastruct = callPackage ./non-by-name/py-datastruct { };

  py-desmume = callPackage ./non-by-name/py-desmume {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  py-deviceid = callPackage ./non-by-name/py-deviceid { };

  py-dmidecode = callPackage ./non-by-name/py-dmidecode { };

  py-dormakaba-dkey = callPackage ./non-by-name/py-dormakaba-dkey { };

  py-ecc = callPackage ./non-by-name/py-ecc { };

  py-evm = callPackage ./non-by-name/py-evm { };

  py-expression-eval = callPackage ./non-by-name/py-expression-eval { };

  py-iam-expand = callPackage ./non-by-name/py-iam-expand { };

  py-improv-ble-client = callPackage ./non-by-name/py-improv-ble-client { };

  py-key-value-aio = callPackage ./non-by-name/py-key-value-aio { };

  py-libnuma = callPackage ./non-by-name/py-libnuma { };

  py-lru-cache = callPackage ./non-by-name/py-lru-cache { };

  py-machineid = callPackage ./non-by-name/py-machineid { };

  py-madvr2 = callPackage ./non-by-name/py-madvr2 { };

  py-markdown-table = callPackage ./non-by-name/py-markdown-table { };

  py-melissa-climate = callPackage ./non-by-name/py-melissa-climate { };

  py-moneyed = callPackage ./non-by-name/py-moneyed { };

  py-multibase = callPackage ./non-by-name/py-multibase { };

  py-multicodec = callPackage ./non-by-name/py-multicodec { };

  py-multihash = callPackage ./non-by-name/py-multihash { };

  py-netgear-plus = callPackage ./non-by-name/py-netgear-plus { };

  py-nextbusnext = callPackage ./non-by-name/py-nextbusnext { };

  py-nightscout = callPackage ./non-by-name/py-nightscout { };

  py-notifier = callPackage ./non-by-name/py-notifier { };

  py-nymta = callPackage ./non-by-name/py-nymta { };

  py-ocsf-models = callPackage ./non-by-name/py-ocsf-models { };

  py-opendisplay = callPackage ./non-by-name/py-opendisplay { };

  py-opensonic = callPackage ./non-by-name/py-opensonic { };

  py-partiql-parser = callPackage ./non-by-name/py-partiql-parser { };

  py-pdf-parser = callPackage ./non-by-name/py-pdf-parser { };

  py-radix = callPackage ./non-by-name/py-radix { };

  py-radix-sr = callPackage ./non-by-name/py-radix-sr { };

  py-rust-stemmers = callPackage ./non-by-name/py-rust-stemmers { };

  py-schluter = callPackage ./non-by-name/py-schluter { };

  py-serializable = callPackage ./non-by-name/py-serializable { };

  py-slvs = callPackage ./non-by-name/py-slvs { };

  py-sneakers = callPackage ./non-by-name/py-sneakers { };

  py-sonic = callPackage ./non-by-name/py-sonic { };

  py-sr25519-bindings = callPackage ./non-by-name/py-sr25519-bindings { };

  py-stringmatching = callPackage ./non-by-name/py-stringmatching { };

  py-sucks = callPackage ./non-by-name/py-sucks { };

  py-svg-hush = callPackage ./non-by-name/py-svg-hush { };

  py-synologydsm-api = callPackage ./non-by-name/py-synologydsm-api { };

  py-tes = callPackage ./non-by-name/py-tes { };

  py-ubjson = callPackage ./non-by-name/py-ubjson { };

  py-unifi-access = callPackage ./non-by-name/py-unifi-access { };

  py-vapid = callPackage ./non-by-name/py-vapid { };

  py-zabbix = callPackage ./non-by-name/py-zabbix { };

  py2bit = callPackage ./non-by-name/py2bit { };

  py2vega = callPackage ./non-by-name/py2vega { };

  py3amf = callPackage ./non-by-name/py3amf { };

  py3buddy = callPackage ./non-by-name/py3buddy { };

  py3dns = callPackage ./non-by-name/py3dns { };

  py3dtiles = callPackage ./non-by-name/py3dtiles { };

  py3exiv2 = callPackage ./non-by-name/py3exiv2 { inherit (pkgs) exiv2; };

  py3langid = callPackage ./non-by-name/py3langid { };

  py3nvml = callPackage ./non-by-name/py3nvml { };

  py3rijndael = callPackage ./non-by-name/py3rijndael { };

  py3status = callPackage ./non-by-name/py3status { };

  py4j = callPackage ./non-by-name/py4j { };

  py65 = callPackage ./non-by-name/py65 { };

  py7zr = callPackage ./non-by-name/py7zr { };

  pyaaf2 = callPackage ./non-by-name/pyaaf2 { };

  pyabpoa = toPythonModule (
    pkgs.abpoa.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  pyacoustid = callPackage ./non-by-name/pyacoustid { };

  pyadjoint-ad = callPackage ./non-by-name/pyadjoint-ad { };

  pyads = callPackage ./non-by-name/pyads { };

  pyaehw4a1 = callPackage ./non-by-name/pyaehw4a1 { };

  pyaes = callPackage ./non-by-name/pyaes { };

  pyaftership = callPackage ./non-by-name/pyaftership { };

  pyahocorasick = callPackage ./non-by-name/pyahocorasick { };

  pyairnow = callPackage ./non-by-name/pyairnow { };

  pyairobotrest = callPackage ./non-by-name/pyairobotrest { };

  pyairports = callPackage ./non-by-name/pyairports { };

  pyairtable = callPackage ./non-by-name/pyairtable { };

  pyairvisual = callPackage ./non-by-name/pyairvisual { };

  pyais = callPackage ./non-by-name/pyais { };

  pyalgotrade = callPackage ./non-by-name/pyalgotrade { };

  pyalsaaudio = callPackage ./non-by-name/pyalsaaudio { };

  pyamg = callPackage ./non-by-name/pyamg { };

  pyaml = callPackage ./non-by-name/pyaml { };

  pyaml-env = callPackage ./non-by-name/pyaml-env { };

  pyanglianwater = callPackage ./non-by-name/pyanglianwater { };

  pyannotate = callPackage ./non-by-name/pyannotate { };

  pyannote-audio = callPackage ./non-by-name/pyannote-audio { };

  pyannote-core = callPackage ./non-by-name/pyannote-core { };

  pyannote-database = callPackage ./non-by-name/pyannote-database { };

  pyannote-metrics = callPackage ./non-by-name/pyannote-metrics { };

  pyannote-pipeline = callPackage ./non-by-name/pyannote-pipeline { };

  pyannoteai-sdk = callPackage ./non-by-name/pyannoteai-sdk { };

  pyaprilaire = callPackage ./non-by-name/pyaprilaire { };

  pyaqvify = callPackage ./non-by-name/pyaqvify { };

  pyarlo = callPackage ./non-by-name/pyarlo { };

  pyarr = callPackage ./non-by-name/pyarr { };

  pyarrow = callPackage ./non-by-name/pyarrow { inherit (pkgs) arrow-cpp cmake; };

  pyarrow-hotfix = callPackage ./non-by-name/pyarrow-hotfix { };

  pyaskalono = callPackage ./non-by-name/pyaskalono { inherit (pkgs) zstd; };

  pyasn = callPackage ./non-by-name/pyasn { };

  pyasn1 = callPackage ./non-by-name/pyasn1 { };

  pyasn1-alt-modules = callPackage ./non-by-name/pyasn1-alt-modules { };

  pyasn1-modules = callPackage ./non-by-name/pyasn1-modules { };

  pyasuswrt = callPackage ./non-by-name/pyasuswrt { };

  pyasynchat = callPackage ./non-by-name/pyasynchat { };

  pyasyncore = callPackage ./non-by-name/pyasyncore { };

  pyatag = callPackage ./non-by-name/pyatag { };

  pyatem = callPackage ./non-by-name/pyatem { };

  pyathena = callPackage ./non-by-name/pyathena { };

  pyatmo = callPackage ./non-by-name/pyatmo { };

  pyatome = callPackage ./non-by-name/pyatome { };

  pyatspi = callPackage ./non-by-name/pyatspi { inherit (pkgs.buildPackages) meson; };

  pyatv = callPackage ./non-by-name/pyatv { };

  pyaudio = callPackage ./non-by-name/pyaudio { };

  pyaussiebb = callPackage ./non-by-name/pyaussiebb { };

  pyautogui = callPackage ./non-by-name/pyautogui { };

  pyavm = callPackage ./non-by-name/pyavm { };

  pyaxencoapi = callPackage ./non-by-name/pyaxencoapi { };

  pyaxmlparser = callPackage ./non-by-name/pyaxmlparser { };

  pybalboa = callPackage ./non-by-name/pybalboa { };

  pybars3 = callPackage ./non-by-name/pybars3 { };

  pybase62 = callPackage ./non-by-name/pybase62 { };

  pybase64 = callPackage ./non-by-name/pybase64 { };

  pybase91 = callPackage ./non-by-name/pybase91 { };

  pybbox = callPackage ./non-by-name/pybbox { };

  pybcj = callPackage ./non-by-name/pybcj { };

  pybedtools = callPackage ./non-by-name/pybedtools { };

  pybids = callPackage ./non-by-name/pybids { };

  pybigwig = callPackage ./non-by-name/pybigwig { };

  pybind11 = callPackage ./non-by-name/pybind11 { };

  pybind11-abseil = callPackage ./non-by-name/pybind11-abseil { };

  pybind11-stubgen = callPackage ./non-by-name/pybind11-stubgen { };

  pybind11_3_0 = callPackage ./non-by-name/pybind11/3_0.nix { };

  pybindgen = callPackage ./non-by-name/pybindgen { };

  pyblackbird = callPackage ./non-by-name/pyblackbird { };

  pybloom-live = callPackage ./non-by-name/pybloom-live { };

  pybloomfilter3 = callPackage ./non-by-name/pybloomfilter3 { };

  pyblu = callPackage ./non-by-name/pyblu { };

  pybluez = callPackage ./non-by-name/pybluez { inherit (pkgs) bluez; };

  pybotvac = callPackage ./non-by-name/pybotvac { };

  pybox2d = callPackage ./non-by-name/pybox2d { };

  pybraendstofpriser = callPackage ./non-by-name/pybraendstofpriser { };

  pybravia = callPackage ./non-by-name/pybravia { };

  pybreaker = callPackage ./non-by-name/pybreaker { };

  pybrowserid = callPackage ./non-by-name/pybrowserid { };

  pybrowsers = callPackage ./non-by-name/pybrowsers { };

  pybtex = callPackage ./non-by-name/pybtex { };

  pybtex-docutils = callPackage ./non-by-name/pybtex-docutils { };

  pybuildkite = callPackage ./non-by-name/pybuildkite { };

  pybullet = callPackage ./non-by-name/pybullet { };

  pycairo = callPackage ./non-by-name/pycairo { inherit (pkgs.buildPackages) meson; };

  pycambia = callPackage ./non-by-name/pycambia { };

  pycangjie = callPackage ./non-by-name/pycangjie {
    inherit (pkgs.buildPackages) meson;
  };

  pycapnp = callPackage ./non-by-name/pycapnp { };

  pycaption = callPackage ./non-by-name/pycaption { };

  pycardano = callPackage ./non-by-name/pycardano { };

  pycares = callPackage ./non-by-name/pycares { };

  pycarwings2 = callPackage ./non-by-name/pycarwings2 { };

  pycasbin = callPackage ./non-by-name/pycasbin { };

  pycasperglow = callPackage ./non-by-name/pycasperglow { };

  pycatch22 = callPackage ./non-by-name/pycatch22 { };

  pycayennelpp = callPackage ./non-by-name/pycayennelpp { };

  pycddl = callPackage ./non-by-name/pycddl { };

  pycdio = callPackage ./non-by-name/pycdio { };

  pycdlib = callPackage ./non-by-name/pycdlib { };

  pycec = callPackage ./non-by-name/pycec { };

  pycep-parser = callPackage ./non-by-name/pycep-parser { };

  pycfdns = callPackage ./non-by-name/pycfdns { };

  pycflow2dot = callPackage ./non-by-name/pycflow2dot { inherit (pkgs) graphviz; };

  pycfmodel = callPackage ./non-by-name/pycfmodel { };

  pychannels = callPackage ./non-by-name/pychannels { };

  pychm = callPackage ./non-by-name/pychm { };

  pychromecast = callPackage ./non-by-name/pychromecast { };

  pycifrw = callPackage ./non-by-name/pycifrw { };

  pycketcasts = callPackage ./non-by-name/pycketcasts { };

  pyclibrary = callPackage ./non-by-name/pyclibrary { };

  pyclimacell = callPackage ./non-by-name/pyclimacell { };

  pyclip = callPackage ./non-by-name/pyclip { };

  pyclipper = callPackage ./non-by-name/pyclipper { };

  pycm = callPackage ./non-by-name/pycm { };

  pycmarkgfm = callPackage ./non-by-name/pycmarkgfm { };

  pycmus = callPackage ./non-by-name/pycmus { };

  pycobertura = callPackage ./non-by-name/pycobertura { };

  pycocotools = callPackage ./non-by-name/pycocotools { };

  pycodec2 = callPackage ./non-by-name/pycodec2 { };

  pycodestyle = callPackage ./non-by-name/pycodestyle { };

  pycognito = callPackage ./non-by-name/pycognito { };

  pycoin = callPackage ./non-by-name/pycoin { };

  pycollada = callPackage ./non-by-name/pycollada { };

  pycolorecho = callPackage ./non-by-name/pycolorecho { };

  pycomfoconnect = callPackage ./non-by-name/pycomfoconnect { };

  pycomm3 = callPackage ./non-by-name/pycomm3 { };

  pycompliance = callPackage ./non-by-name/pycompliance { };

  pycomposefile = callPackage ./non-by-name/pycomposefile { };

  pycontrol4 = callPackage ./non-by-name/pycontrol4 { };

  pycookiecheat = callPackage ./non-by-name/pycookiecheat { };

  pycoolmasternet-async = callPackage ./non-by-name/pycoolmasternet-async { };

  pycosat = callPackage ./non-by-name/pycosat { };

  pycotap = callPackage ./non-by-name/pycotap { };

  pycountry = callPackage ./non-by-name/pycountry { };

  pycountry-convert = callPackage ./non-by-name/pycountry-convert { };

  pycparser = callPackage ./non-by-name/pycparser { };

  pycrashreport = callPackage ./non-by-name/pycrashreport { };

  pycrate = callPackage ./non-by-name/pycrate { };

  pycrdt = callPackage ./non-by-name/pycrdt { };

  pycrdt-store = callPackage ./non-by-name/pycrdt-store { };

  pycrdt-websocket = callPackage ./non-by-name/pycrdt-websocket { };

  pycritty = callPackage ./non-by-name/pycritty { };

  pycron = callPackage ./non-by-name/pycron { };

  pycrypto = callPackage ./non-by-name/pycrypto { };

  pycryptodome = callPackage ./non-by-name/pycryptodome { };

  pycryptodomex = callPackage ./non-by-name/pycryptodomex { };

  pycryptotools = callPackage ./non-by-name/pycryptotools { };

  pycsdr = callPackage ./non-by-name/pycsdr { };

  pycsspeechtts = callPackage ./non-by-name/pycsspeechtts { };

  pyct = callPackage ./non-by-name/pyct { };

  pyctr = callPackage ./non-by-name/pyctr { };

  pycuda = callPackage ./non-by-name/pycuda { };

  pycups = callPackage ./non-by-name/pycups { };

  pycurl = callPackage ./non-by-name/pycurl { };

  pycycling = callPackage ./non-by-name/pycycling { };

  pycync = callPackage ./non-by-name/pycync { };

  pycyphal = callPackage ./non-by-name/pycyphal { };

  pydaikin = callPackage ./non-by-name/pydaikin { };

  pydal = callPackage ./non-by-name/pydal { };

  pydanclick = callPackage ./non-by-name/pydanclick { };

  pydanfossair = callPackage ./non-by-name/pydanfossair { };

  pydantic = callPackage ./non-by-name/pydantic { };

  pydantic-ai-harness = callPackage ./non-by-name/pydantic-ai-harness { };

  pydantic-ai-slim = callPackage ./non-by-name/pydantic-ai-slim { };

  pydantic-argparse-extensible = callPackage ./non-by-name/pydantic-argparse-extensible { };

  pydantic-compat = callPackage ./non-by-name/pydantic-compat { };

  pydantic-core = callPackage ./non-by-name/pydantic-core { };

  pydantic-extra-types = callPackage ./non-by-name/pydantic-extra-types { };

  pydantic-graph = callPackage ./non-by-name/pydantic-graph { };

  pydantic-monty = callPackage ./non-by-name/pydantic-monty {
    inherit (pkgs) zstd;
  };

  pydantic-scim = callPackage ./non-by-name/pydantic-scim { };

  pydantic-settings = callPackage ./non-by-name/pydantic-settings { };

  pydantic-xml = callPackage ./non-by-name/pydantic-xml { };

  pydantic-zarr = callPackage ./non-by-name/pydantic-zarr { };

  pydantic_1 = callPackage ./non-by-name/pydantic/1.nix { };

  pydash = callPackage ./non-by-name/pydash { };

  pydata-google-auth = callPackage ./non-by-name/pydata-google-auth { };

  pydata-sphinx-theme = callPackage ./non-by-name/pydata-sphinx-theme { };

  pydateinfer = callPackage ./non-by-name/pydateinfer { };

  pydbus = callPackage ./non-by-name/pydbus { };

  pydeako = callPackage ./non-by-name/pydeako { };

  pydeck = callPackage ./non-by-name/pydeck { };

  pydeconz = callPackage ./non-by-name/pydeconz { };

  pydeep2 = callPackage ./non-by-name/pydeep2 { inherit (pkgs) ssdeep; };

  pydelijn = callPackage ./non-by-name/pydelijn { };

  pydemumble = callPackage ./non-by-name/pydemumble { };

  pydenticon = callPackage ./non-by-name/pydenticon { };

  pydeprecate = callPackage ./non-by-name/pydeprecate { };

  pydeps = callPackage ./non-by-name/pydeps { inherit (pkgs) graphviz; };

  pydes = callPackage ./non-by-name/pydes { };

  pydevccu = callPackage ./non-by-name/pydevccu { };

  pydevd = callPackage ./non-by-name/pydevd { };

  pydevtool = callPackage ./non-by-name/pydevtool { };

  pydexcom = callPackage ./non-by-name/pydexcom { };

  pydicom = callPackage ./non-by-name/pydicom { };

  pydicom-seg = callPackage ./non-by-name/pydicom-seg { };

  pydiffx = callPackage ./non-by-name/pydiffx { };

  pydig = callPackage ./non-by-name/pydig { };

  pydigiham = callPackage ./non-by-name/pydigiham { };

  pydiscourse = callPackage ./non-by-name/pydiscourse { };

  pydiscovergy = callPackage ./non-by-name/pydiscovergy { };

  pydispatcher = callPackage ./non-by-name/pydispatcher { };

  pydivsufsort = callPackage ./non-by-name/pydivsufsort { };

  pydle = callPackage ./non-by-name/pydle { };

  pydmd = callPackage ./non-by-name/pydmd { };

  pydo = callPackage ./non-by-name/pydo { };

  pydocket = callPackage ./non-by-name/pydocket { };

  pydocstyle = callPackage ./non-by-name/pydocstyle { };

  pydocumentdb = callPackage ./non-by-name/pydocumentdb { };

  pydoe = callPackage ./non-by-name/pydoe { };

  pydoods = callPackage ./non-by-name/pydoods { };

  pydot = callPackage ./non-by-name/pydot { inherit (pkgs) graphviz; };

  pydrawise = callPackage ./non-by-name/pydrawise { };

  pydriller = callPackage ./non-by-name/pydriller { };

  pydrive2 = callPackage ./non-by-name/pydrive2 { };

  pydroid-ipcam = callPackage ./non-by-name/pydroid-ipcam { };

  pydroplet = callPackage ./non-by-name/pydroplet { };

  pydruid = callPackage ./non-by-name/pydruid { };

  pydsdl = callPackage ./non-by-name/pydsdl { };

  pydub = callPackage ./non-by-name/pydub { };

  pyduke-energy = callPackage ./non-by-name/pyduke-energy { };

  pyduktape2 = callPackage ./non-by-name/pyduktape2 { };

  pyduotecno = callPackage ./non-by-name/pyduotecno { };

  pydy = callPackage ./non-by-name/pydy { };

  pydyf = callPackage ./non-by-name/pydyf { };

  pyeapi = callPackage ./non-by-name/pyeapi { };

  pyebox = callPackage ./non-by-name/pyebox { };

  pyebus = callPackage ./non-by-name/pyebus { };

  pyecharts = callPackage ./non-by-name/pyecharts { };

  pyeclib = callPackage ./non-by-name/pyeclib { };

  pyecoforest = callPackage ./non-by-name/pyecoforest { };

  pyeconet = callPackage ./non-by-name/pyeconet { };

  pyecotrend-ista = callPackage ./non-by-name/pyecotrend-ista { };

  pyecowitt = callPackage ./non-by-name/pyecowitt { };

  pyedbglib = callPackage ./non-by-name/pyedbglib { };

  pyedflib = callPackage ./non-by-name/pyedflib { };

  pyedimax = callPackage ./non-by-name/pyedimax { };

  pyee = callPackage ./non-by-name/pyee { };

  pyefergy = callPackage ./non-by-name/pyefergy { };

  pyegps = callPackage ./non-by-name/pyegps { };

  pyeight = callPackage ./non-by-name/pyeight { };

  pyelectra = callPackage ./non-by-name/pyelectra { };

  pyelftools = callPackage ./non-by-name/pyelftools { };

  pyemby = callPackage ./non-by-name/pyemby { };

  pyemd = callPackage ./non-by-name/pyemd { };

  pyemoncms = callPackage ./non-by-name/pyemoncms { };

  pyemvue = callPackage ./non-by-name/pyemvue { };

  pyenchant = callPackage ./non-by-name/pyenchant { inherit (pkgs) enchant_2; };

  pyenphase = callPackage ./non-by-name/pyenphase { };

  pyenvertechevt800 = callPackage ./non-by-name/pyenvertechevt800 { };

  pyenvisalink = callPackage ./non-by-name/pyenvisalink { };

  pyephember2 = callPackage ./non-by-name/pyephember2 { };

  pyepsg = callPackage ./non-by-name/pyepsg { };

  pyequihash = callPackage ./non-by-name/pyequihash { };

  pyerfa = callPackage ./non-by-name/pyerfa { };

  pyeverlights = callPackage ./non-by-name/pyeverlights { };

  pyevilgenius = callPackage ./non-by-name/pyevilgenius { };

  pyevmasm = callPackage ./non-by-name/pyevmasm { };

  pyevtk = callPackage ./non-by-name/pyevtk { };

  pyexcel = callPackage ./non-by-name/pyexcel { };

  pyexcel-io = callPackage ./non-by-name/pyexcel-io { };

  pyexcel-ods = callPackage ./non-by-name/pyexcel-ods { };

  pyexcel-xls = callPackage ./non-by-name/pyexcel-xls { };

  pyexiftool = callPackage ./non-by-name/pyexiftool { };

  pyexiv2 = callPackage ./non-by-name/pyexiv2 { };

  pyexpect = callPackage ./non-by-name/pyexpect { };

  pyexploitdb = callPackage ./non-by-name/pyexploitdb { };

  pyezvizapi = callPackage ./non-by-name/pyezvizapi { };

  pyface = callPackage ./non-by-name/pyface { };

  pyfaidx = callPackage ./non-by-name/pyfaidx { };

  pyfakefs = callPackage ./non-by-name/pyfakefs { };

  pyfakewebcam = callPackage ./non-by-name/pyfakewebcam { };

  pyfastnoiselite = callPackage ./non-by-name/pyfastnoiselite { };

  pyfastnoiselite-ledfx = callPackage ./non-by-name/pyfastnoiselite-ledfx { };

  pyfatfs = callPackage ./non-by-name/pyfatfs { };

  pyfaup-rs = callPackage ./non-by-name/pyfaup-rs { };

  pyfcm = callPackage ./non-by-name/pyfcm { };

  pyfdt = callPackage ./non-by-name/pyfdt { };

  pyfibaro = callPackage ./non-by-name/pyfibaro { };

  pyfido = callPackage ./non-by-name/pyfido { };

  pyfiglet = callPackage ./non-by-name/pyfiglet { };

  pyfirefly = callPackage ./non-by-name/pyfirefly { };

  pyfireservicerota = callPackage ./non-by-name/pyfireservicerota { };

  pyflac = callPackage ./non-by-name/pyflac { };

  pyflakes = callPackage ./non-by-name/pyflakes { };

  pyflexit = callPackage ./non-by-name/pyflexit { };

  pyflic = callPackage ./non-by-name/pyflic { };

  pyflic-ble = callPackage ./non-by-name/pyflic-ble { };

  pyflipper = callPackage ./non-by-name/pyflipper { };

  pyfluidsynth = callPackage ./non-by-name/pyfluidsynth { };

  pyflume = callPackage ./non-by-name/pyflume { };

  pyfma = callPackage ./non-by-name/pyfma { };

  pyfnip = callPackage ./non-by-name/pyfnip { };

  pyforeca = callPackage ./non-by-name/pyforeca { };

  pyforked-daapd = callPackage ./non-by-name/pyforked-daapd { };

  pyformlang = callPackage ./non-by-name/pyformlang { };

  pyfreedompro = callPackage ./non-by-name/pyfreedompro { };

  pyfreshr = callPackage ./non-by-name/pyfreshr { };

  pyfritzhome = callPackage ./non-by-name/pyfritzhome { };

  pyftdi = callPackage ./non-by-name/pyftdi { };

  pyftgl = callPackage ./non-by-name/pyftgl { };

  pyftpdlib = callPackage ./non-by-name/pyftpdlib { };

  pyfttt = callPackage ./non-by-name/pyfttt { };

  pyfume = callPackage ./non-by-name/pyfume { };

  pyfunctional = callPackage ./non-by-name/pyfunctional { };

  pyfuse3 = callPackage ./non-by-name/pyfuse3 { };

  pyfwup = callPackage ./non-by-name/pyfwup { inherit (pkgs) libusb1; };

  pyfxa = callPackage ./non-by-name/pyfxa { };

  pyfzf = callPackage ./non-by-name/pyfzf { inherit (pkgs) fzf; };

  pyg-lib = callPackage ./non-by-name/pyg-lib { };

  pygal = callPackage ./non-by-name/pygal { };

  # pygame-ce is better maintained upstream, the breaking point was https://github.com/NixOS/nixpkgs/pull/475917#issuecomment-3706940043
  pygame = if pythonAtLeast "3.14" then pygame-ce else pygame-original;

  pygame-ce = callPackage ./non-by-name/pygame-ce { };

  pygame-gui = callPackage ./non-by-name/pygame-gui { };

  pygame-original = callPackage ./non-by-name/pygame-original { };

  pygame-sdl2 = callPackage ./non-by-name/pygame-sdl2 { };

  pygatt = callPackage ./non-by-name/pygatt { };

  pygbl = callPackage ./non-by-name/pygbl { };

  pygccxml = callPackage ./non-by-name/pygccxml { };

  pygdbmi = callPackage ./non-by-name/pygdbmi { };

  pygelf = callPackage ./non-by-name/pygelf { };

  pygeocodio = callPackage ./non-by-name/pygeocodio { };

  pygeosphere-warnings = callPackage ./non-by-name/pygeosphere-warnings { };

  pygerber = callPackage ./non-by-name/pygerber { };

  pygetwindow = callPackage ./non-by-name/pygetwindow { };

  pyghidra = callPackage ./non-by-name/pyghidra { };

  pyghmi = callPackage ./non-by-name/pyghmi { };

  pygit2 = callPackage ./non-by-name/pygit2 { };

  pygitguardian = callPackage ./non-by-name/pygitguardian { };

  pygithub = callPackage ./non-by-name/pygithub { };

  pyglet = callPackage ./non-by-name/pyglet { };

  pyglm = callPackage ./non-by-name/pyglm { };

  pyglossary = callPackage ./non-by-name/pyglossary { };

  pygls = callPackage ./non-by-name/pygls { };

  pygls_1 = callPackage ./non-by-name/pygls/1.nix { };

  pygltflib = callPackage ./non-by-name/pygltflib { };

  pygmars = callPackage ./non-by-name/pygmars { };

  pygments = callPackage ./non-by-name/pygments { };

  pygments-better-html = callPackage ./non-by-name/pygments-better-html { };

  pygments-markdown-lexer = callPackage ./non-by-name/pygments-markdown-lexer { };

  pygments-style-github = callPackage ./non-by-name/pygments-style-github { };

  pygmo = callPackage ./non-by-name/pygmo { };

  pygmt = callPackage ./non-by-name/pygmt { };

  pygnmi = callPackage ./non-by-name/pygnmi { };

  pygnuutils = callPackage ./non-by-name/pygnuutils { };

  pygobject-stubs = callPackage ./non-by-name/pygobject-stubs { };

  pygobject3 = callPackage ./non-by-name/pygobject/3.nix {
    # inherit (pkgs) meson won't work because it won't be spliced
    inherit (pkgs.buildPackages) meson;
  };

  pygount = callPackage ./non-by-name/pygount { };

  pygraphviz = callPackage ./non-by-name/pygraphviz { inherit (pkgs) graphviz; };

  pygreat = callPackage ./non-by-name/pygreat { };

  pygrib = callPackage ./non-by-name/pygrib { };

  pygrister = callPackage ./non-by-name/pygrister { };

  pygrok = callPackage ./non-by-name/pygrok { };

  pygsl = callPackage ./non-by-name/pygsl { inherit (pkgs) gsl swig; };

  pygtail = callPackage ./non-by-name/pygtail { };

  pygtfs = callPackage ./non-by-name/pygtfs { };

  pygti = callPackage ./non-by-name/pygti { };

  pygtkspellcheck = callPackage ./non-by-name/pygtkspellcheck { };

  pygtrie = callPackage ./non-by-name/pygtrie { };

  pyhacrf-datamade = callPackage ./non-by-name/pyhacrf-datamade { };

  pyhamcrest = callPackage ./non-by-name/pyhamcrest { };

  pyhanko = callPackage ./non-by-name/pyhanko { };

  pyhanko-certvalidator = callPackage ./non-by-name/pyhanko-certvalidator { };

  pyhaseiq = callPackage ./non-by-name/pyhaseiq { };

  pyhaversion = callPackage ./non-by-name/pyhaversion { };

  pyhcl = callPackage ./non-by-name/pyhcl { };

  pyhdfe = callPackage ./non-by-name/pyhdfe { };

  pyheck = callPackage ./non-by-name/pyheck { };

  pyhelty = callPackage ./non-by-name/pyhelty { };

  pyheltycloud = callPackage ./non-by-name/pyheltycloud { };

  pyheos = callPackage ./non-by-name/pyheos { };

  pyhepmc = callPackage ./non-by-name/pyhepmc { };

  pyhibp = callPackage ./non-by-name/pyhibp { };

  pyhik = callPackage ./non-by-name/pyhik { };

  pyhive-integration = callPackage ./non-by-name/pyhive-integration { };

  pyhocon = callPackage ./non-by-name/pyhocon { };

  pyhomee = callPackage ./non-by-name/pyhomee { };

  pyhomematic = callPackage ./non-by-name/pyhomematic { };

  pyhomepilot = callPackage ./non-by-name/pyhomepilot { };

  pyhomeworks = callPackage ./non-by-name/pyhomeworks { };

  pyhumps = callPackage ./non-by-name/pyhumps { };

  pyi2cflash = callPackage ./non-by-name/pyi2cflash { };

  pyiceberg = callPackage ./non-by-name/pyiceberg { };

  pyiceberg-core = callPackage ./non-by-name/pyiceberg-core {
    inherit (pkgs) zstd;
  };

  pyicloud = callPackage ./non-by-name/pyicloud { };

  pyicu = callPackage ./non-by-name/pyicu { };

  pyicumessageformat = callPackage ./non-by-name/pyicumessageformat { };

  pyimg4 = callPackage ./non-by-name/pyimg4 { };

  pyimgbox = callPackage ./non-by-name/pyimgbox { };

  pyimouapi = callPackage ./non-by-name/pyimouapi { };

  pyimpfuzzy = callPackage ./non-by-name/pyimpfuzzy { inherit (pkgs) ssdeep; };

  pyindego = callPackage ./non-by-name/pyindego { };

  pyinfra = callPackage ./non-by-name/pyinfra { };

  pyinfra-testgen = callPackage ./non-by-name/pyinfra-testgen { };

  pyinotify = callPackage ./non-by-name/pyinotify { };

  pyinputevent = callPackage ./non-by-name/pyinputevent { };

  pyinstaller = callPackage ./non-by-name/pyinstaller { };

  pyinstaller-hooks-contrib = callPackage ./non-by-name/pyinstaller-hooks-contrib { };

  pyinstaller-versionfile = callPackage ./non-by-name/pyinstaller-versionfile { };

  pyinsteon = callPackage ./non-by-name/pyinsteon { };

  pyinstrument = callPackage ./non-by-name/pyinstrument { };

  pyintelliclima = callPackage ./non-by-name/pyintelliclima { };

  pyinterp = callPackage ./non-by-name/pyinterp { };

  pyintesishome = callPackage ./non-by-name/pyintesishome { };

  pyipma = callPackage ./non-by-name/pyipma { };

  pyipp = callPackage ./non-by-name/pyipp { };

  pyipv8 = callPackage ./non-by-name/pyipv8 { };

  pyiqvia = callPackage ./non-by-name/pyiqvia { };

  pyirishrail = callPackage ./non-by-name/pyirishrail { };

  pyisbn = callPackage ./non-by-name/pyisbn { };

  pyisemail = callPackage ./non-by-name/pyisemail { };

  pyiskra = callPackage ./non-by-name/pyiskra { };

  pyiss = callPackage ./non-by-name/pyiss { };

  pyisy = callPackage ./non-by-name/pyisy { };

  pyitachip2ir2 = callPackage ./non-by-name/pyitachip2ir2 { };

  pyituran = callPackage ./non-by-name/pyituran { };

  pyixapi = callPackage ./non-by-name/pyixapi { };

  pyjks = callPackage ./non-by-name/pyjks { };

  pyjnius = callPackage ./non-by-name/pyjnius { };

  pyjpegls = callPackage ./non-by-name/pyjpegls { };

  pyjson5 = callPackage ./non-by-name/pyjson5 { };

  pyjsparser = callPackage ./non-by-name/pyjsparser { };

  pyjvcprojector = callPackage ./non-by-name/pyjvcprojector { };

  pyjwkest = callPackage ./non-by-name/pyjwkest { };

  pyjwt = callPackage ./non-by-name/pyjwt { };

  pykakasi = callPackage ./non-by-name/pykakasi { };

  pykaleidescape = callPackage ./non-by-name/pykaleidescape { };

  pykalman = callPackage ./non-by-name/pykalman { };

  pykcs11 = callPackage ./non-by-name/pykcs11 { };

  pykdebugparser = callPackage ./non-by-name/pykdebugparser { };

  pykdl = callPackage ./non-by-name/pykdl { };

  pykdtree = callPackage ./non-by-name/pykdtree {
    inherit (pkgs.llvmPackages) openmp;
  };

  pykeepass = callPackage ./non-by-name/pykeepass { };

  pykerberos = callPackage ./non-by-name/pykerberos { krb5-c = pkgs.krb5; };

  pykeyatome = callPackage ./non-by-name/pykeyatome { };

  pykira = callPackage ./non-by-name/pykira { };

  pykka = callPackage ./non-by-name/pykka { };

  pykmtronic = callPackage ./non-by-name/pykmtronic { };

  pykodi = callPackage ./non-by-name/pykodi { };

  pykoplenti = callPackage ./non-by-name/pykoplenti { };

  pykostalpiko = callPackage ./non-by-name/pykostalpiko { };

  pykrakenapi = callPackage ./non-by-name/pykrakenapi { };

  pykrige = callPackage ./non-by-name/pykrige { };

  pykulersky = callPackage ./non-by-name/pykulersky { };

  pykwalify = callPackage ./non-by-name/pykwalify { };

  pykwb = callPackage ./non-by-name/pykwb { };

  pylacrosse = callPackage ./non-by-name/pylacrosse { };

  pylacus = callPackage ./non-by-name/pylacus { };

  pylama = callPackage ./non-by-name/pylama { };

  pylamarzocco = callPackage ./non-by-name/pylamarzocco { };

  pylance = callPackage ./non-by-name/pylance { };

  pylast = callPackage ./non-by-name/pylast { };

  pylatex = callPackage ./non-by-name/pylatex { };

  pylatexenc = callPackage ./non-by-name/pylatexenc { };

  pylaunches = callPackage ./non-by-name/pylaunches { };

  pylbfgs = callPackage ./non-by-name/pylbfgs { };

  pyld = callPackage ./non-by-name/pyld { };

  pyldapsearch = callPackage ./non-by-name/pyldapsearch { };

  pyldavis = callPackage ./non-by-name/pyldavis { };

  pylddwrap = callPackage ./non-by-name/pylddwrap { };

  pyleri = callPackage ./non-by-name/pyleri { };

  pylette = callPackage ./non-by-name/pylette { };

  pylev = callPackage ./non-by-name/pylev { };

  pylgnetcast = callPackage ./non-by-name/pylgnetcast { };

  pylibacl = callPackage ./non-by-name/pylibacl { };

  pylibconfig2 = callPackage ./non-by-name/pylibconfig2 { };

  pylibdmtx = callPackage ./non-by-name/pylibdmtx { };

  pylibftdi = callPackage ./non-by-name/pylibftdi { inherit (pkgs) libusb1; };

  pylibjpeg = callPackage ./non-by-name/pylibjpeg { };

  pylibjpeg-data = callPackage ./non-by-name/pylibjpeg-data { };

  pylibjpeg-libjpeg = callPackage ./non-by-name/pylibjpeg-libjpeg { };

  pylibjpeg-openjpeg = callPackage ./non-by-name/pylibjpeg-openjpeg { };

  pylibjpeg-rle = callPackage ./non-by-name/pylibjpeg-rle { };

  pyliblo3 = callPackage ./non-by-name/pyliblo3 { };

  pylibmc = callPackage ./non-by-name/pylibmc { };

  pylibrespot-java = callPackage ./non-by-name/pylibrespot-java { };

  pylibsrtp = callPackage ./non-by-name/pylibsrtp { };

  pyliebherrhomeapi = callPackage ./non-by-name/pyliebherrhomeapi { };

  pylightning = callPackage ./non-by-name/pylightning { };

  pylink-square = callPackage ./non-by-name/pylink-square { };

  pylint = callPackage ./non-by-name/pylint { };

  pylint-celery = callPackage ./non-by-name/pylint-celery { };

  pylint-django = callPackage ./non-by-name/pylint-django { };

  pylint-flask = callPackage ./non-by-name/pylint-flask { };

  pylint-odoo = callPackage ./non-by-name/pylint-odoo { };

  pylint-plugin-utils = callPackage ./non-by-name/pylint-plugin-utils { };

  pylint-venv = callPackage ./non-by-name/pylint-venv { };

  pylion = callPackage ./non-by-name/pylion { };

  pylitejet = callPackage ./non-by-name/pylitejet { };

  pylitterbot = callPackage ./non-by-name/pylitterbot { };

  pyln-bolt7 = callPackage ./non-by-name/pyln-bolt7 { };

  pyln-client = callPackage ./non-by-name/pyln-client { };

  pyln-proto = callPackage ./non-by-name/pyln-proto { };

  pylnk3 = callPackage ./non-by-name/pylnk3 { };

  pyloadapi = callPackage ./non-by-name/pyloadapi { };

  pyloggermanager = callPackage ./non-by-name/pyloggermanager { };

  pylondonair = callPackage ./non-by-name/pylondonair { };

  pylookyloo = callPackage ./non-by-name/pylookyloo { };

  pylpsd = callPackage ./non-by-name/pylpsd { };

  pylru = callPackage ./non-by-name/pylru { };

  pyls-flake8 = callPackage ./non-by-name/pyls-flake8 { };

  pyls-isort = callPackage ./non-by-name/pyls-isort { };

  pyls-memestra = callPackage ./non-by-name/pyls-memestra { };

  pyls-spyder = callPackage ./non-by-name/pyls-spyder { };

  pylsl = callPackage ./non-by-name/pylsl { };

  pylsp-mypy = callPackage ./non-by-name/pylsp-mypy { };

  pylsp-rope = callPackage ./non-by-name/pylsp-rope { };

  pylsqpack = callPackage ./non-by-name/pylsqpack { };

  pylutron = callPackage ./non-by-name/pylutron { };

  pylutron-caseta = callPackage ./non-by-name/pylutron-caseta { };

  pyluwen = callPackage ./non-by-name/pyluwen { };

  pylxd = callPackage ./non-by-name/pylxd { };

  pylyrics = callPackage ./non-by-name/pylyrics { };

  pylzma = callPackage ./non-by-name/pylzma { };

  pylzss = callPackage ./non-by-name/pylzss { };

  pym3u8downloader = callPackage ./non-by-name/pym3u8downloader { };

  pymacaroons = callPackage ./non-by-name/pymacaroons { };

  pymailgunner = callPackage ./non-by-name/pymailgunner { };

  pymanopt = callPackage ./non-by-name/pymanopt { };

  pymap3d = callPackage ./non-by-name/pymap3d { };

  pymarshal = callPackage ./non-by-name/pymarshal { };

  pymata-express = callPackage ./non-by-name/pymata-express { };

  pymatgen = callPackage ./non-by-name/pymatgen { };

  pymatreader = callPackage ./non-by-name/pymatreader { };

  pymatting = callPackage ./non-by-name/pymatting { };

  pymaven-patch = callPackage ./non-by-name/pymaven-patch { };

  pymavlink = callPackage ./non-by-name/pymavlink { };

  pymbolic = callPackage ./non-by-name/pymbolic { };

  pymc = callPackage ./non-by-name/pymc { };

  pymcuprog = callPackage ./non-by-name/pymcuprog { };

  pymdown-extensions = callPackage ./non-by-name/pymdown-extensions { };

  pymdstat = callPackage ./non-by-name/pymdstat { };

  pymediainfo = callPackage ./non-by-name/pymediainfo { };

  pymediaroom = callPackage ./non-by-name/pymediaroom { };

  pymee = callPackage ./non-by-name/pymee { };

  pymeeus = callPackage ./non-by-name/pymeeus { };

  pymemcache = callPackage ./non-by-name/pymemcache { };

  pymemoize = callPackage ./non-by-name/pymemoize { };

  pyment = callPackage ./non-by-name/pyment { };

  pymeshlab = callPackage ./non-by-name/pymeshlab { };

  pymeta3 = callPackage ./non-by-name/pymeta3 { };

  pymetar = callPackage ./non-by-name/pymetar { };

  pymetasploit3 = callPackage ./non-by-name/pymetasploit3 { };

  pymeteireann = callPackage ./non-by-name/pymeteireann { };

  pymeteoclimatic = callPackage ./non-by-name/pymeteoclimatic { };

  pymetno = callPackage ./non-by-name/pymetno { };

  pymfy = callPackage ./non-by-name/pymfy { };

  pymicro-vad = callPackage ./non-by-name/pymicro-vad { };

  pymicrobot = callPackage ./non-by-name/pymicrobot { };

  pymiele = callPackage ./non-by-name/pymiele { };

  pymilter = callPackage ./non-by-name/pymilter { };

  pymilvus = callPackage ./non-by-name/pymilvus { };

  pymisp = callPackage ./non-by-name/pymisp { };

  pymitsubishi = callPackage ./non-by-name/pymitsubishi { };

  pymitv = callPackage ./non-by-name/pymitv { };

  pymobiledevice3 = callPackage ./non-by-name/pymobiledevice3 { };

  pymochad = callPackage ./non-by-name/pymochad { };

  pymodbus = callPackage ./non-by-name/pymodbus { };

  pymodbus-repl = callPackage ./non-by-name/pymodbus-repl { };

  pymodes = callPackage ./non-by-name/pymodes { };

  pymonctl = callPackage ./non-by-name/pymonctl { };

  pymongo = callPackage ./non-by-name/pymongo { };

  pymongo-inmemory = callPackage ./non-by-name/pymongo-inmemory { };

  pymongo-search-utils = callPackage ./non-by-name/pymongo-search-utils { };

  pymonoprice = callPackage ./non-by-name/pymonoprice { };

  pymoo = callPackage ./non-by-name/pymoo { };

  pymorphy2 = callPackage ./non-by-name/pymorphy2 { };

  pymorphy2-dicts-ru = callPackage ./non-by-name/pymorphy2-dicts-ru { };

  pymorphy3 = callPackage ./non-by-name/pymorphy3 { };

  pymorphy3-dicts-ru = callPackage ./non-by-name/pymorphy3-dicts-ru { };

  pymorphy3-dicts-uk = callPackage ./non-by-name/pymorphy3-dicts-uk { };

  pymp4 = callPackage ./non-by-name/pymp4 { };

  pympler = callPackage ./non-by-name/pympler { };

  pymsgbox = callPackage ./non-by-name/pymsgbox { };

  pymssql = callPackage ./non-by-name/pymssql { krb5-c = pkgs.krb5; };

  pymumble = callPackage ./non-by-name/pymumble { };

  pymunk = callPackage ./non-by-name/pymunk { };

  pymupdf = callPackage ./non-by-name/pymupdf { };

  pymupdf-fonts = callPackage ./non-by-name/pymupdf-fonts { };

  pymupdf4llm = callPackage ./non-by-name/pymupdf4llm { };

  pymysensors = callPackage ./non-by-name/pymysensors { };

  pymysql = callPackage ./non-by-name/pymysql { };

  pymysqlsa = callPackage ./non-by-name/pymysqlsa { };

  pynac = callPackage ./non-by-name/pynac { };

  pynacl = callPackage ./non-by-name/pynacl { };

  pynamecheap = callPackage ./non-by-name/pynamecheap { };

  pynamodb = callPackage ./non-by-name/pynamodb { };

  pynanoleaf = callPackage ./non-by-name/pynanoleaf { };

  pynauty = callPackage ./non-by-name/pynauty { };

  pync = callPackage ./non-by-name/pync { inherit (pkgs) which; };

  pynecil = callPackage ./non-by-name/pynecil { };

  pynello = callPackage ./non-by-name/pynello { };

  pynentry = callPackage ./non-by-name/pynentry { };

  pynest2d = callPackage ./non-by-name/pynest2d { };

  pynetbox = callPackage ./non-by-name/pynetbox { };

  pynetdicom = callPackage ./non-by-name/pynetdicom { };

  pynetgear = callPackage ./non-by-name/pynetgear { };

  pynetio = callPackage ./non-by-name/pynetio { };

  pynfsclient = callPackage ./non-by-name/pynfsclient { };

  pyngo = callPackage ./non-by-name/pyngo { };

  pyngrok = callPackage ./non-by-name/pyngrok { };

  pynina = callPackage ./non-by-name/pynina { };

  pynintendoauth = callPackage ./non-by-name/pynintendoauth { };

  pynintendoparental = callPackage ./non-by-name/pynintendoparental { };

  pynipap = callPackage ./non-by-name/pynipap { };

  pynisher = callPackage ./non-by-name/pynisher { };

  pynitrokey = callPackage ./non-by-name/pynitrokey { };

  pynmea2 = callPackage ./non-by-name/pynmea2 { };

  pynmeagps = callPackage ./non-by-name/pynmeagps { };

  pynndescent = callPackage ./non-by-name/pynndescent { };

  pynng = callPackage ./non-by-name/pynng { };

  pynobo = callPackage ./non-by-name/pynobo { };

  pynordpool = callPackage ./non-by-name/pynordpool { };

  pynput = callPackage ./non-by-name/pynput { };

  pynputfix = callPackage ./non-by-name/pynputfix { };

  pynrrd = callPackage ./non-by-name/pynrrd { };

  pynuki = callPackage ./non-by-name/pynuki { };

  pynut2 = callPackage ./non-by-name/pynut2 { };

  pynvim = callPackage ./non-by-name/pynvim { };

  pynvim-pp = callPackage ./non-by-name/pynvim-pp { };

  pynvml = callPackage ./non-by-name/pynvml { };

  pynws = callPackage ./non-by-name/pynws { };

  pynx584 = callPackage ./non-by-name/pynx584 { };

  pynzb = callPackage ./non-by-name/pynzb { };

  pynzbgetapi = callPackage ./non-by-name/pynzbgetapi { };

  pyobihai = callPackage ./non-by-name/pyobihai { };

  pyobjc-core = callPackage ./non-by-name/pyobjc-core { };

  pyobjc-framework-AVFoundation = callPackage ./non-by-name/pyobjc-framework-AVFoundation { };

  pyobjc-framework-ApplicationServices =
    callPackage ./non-by-name/pyobjc-framework-ApplicationServices
      { };

  pyobjc-framework-Cocoa = callPackage ./non-by-name/pyobjc-framework-Cocoa { };

  pyobjc-framework-CoreAudio = callPackage ./non-by-name/pyobjc-framework-CoreAudio { };

  pyobjc-framework-CoreBluetooth = callPackage ./non-by-name/pyobjc-framework-CoreBluetooth { };

  pyobjc-framework-CoreMedia = callPackage ./non-by-name/pyobjc-framework-CoreMedia { };

  pyobjc-framework-CoreText = callPackage ./non-by-name/pyobjc-framework-CoreText { };

  pyobjc-framework-MediaPlayer = callPackage ./non-by-name/pyobjc-framework-MediaPlayer { };

  pyobjc-framework-Quartz = callPackage ./non-by-name/pyobjc-framework-Quartz { };

  pyobjc-framework-Security = callPackage ./non-by-name/pyobjc-framework-Security { };

  pyobjc-framework-WebKit = callPackage ./non-by-name/pyobjc-framework-WebKit { };

  pyobjc-framework-libdispatch = callPackage ./non-by-name/pyobjc-framework-libdispatch { };

  pyobjus = callPackage ./non-by-name/pyobjus {
    inherit (pkgs) clang;
  };

  pyocd = callPackage ./non-by-name/pyocd { };

  pyocd-pemicro = callPackage ./non-by-name/pyocd-pemicro { };

  pyocr = callPackage ./non-by-name/pyocr { tesseract = pkgs.tesseract4; };

  pyoctoprintapi = callPackage ./non-by-name/pyoctoprintapi { };

  pyodbc = callPackage ./non-by-name/pyodbc { };

  pyogg = callPackage ./non-by-name/pyogg { };

  pyogrio = callPackage ./non-by-name/pyogrio { };

  pyombi = callPackage ./non-by-name/pyombi { };

  pyomie = callPackage ./non-by-name/pyomie { };

  pyomo = callPackage ./non-by-name/pyomo { };

  pyopen-wakeword = callPackage ./non-by-name/pyopen-wakeword/default.nix { };

  pyopencl = callPackage ./non-by-name/pyopencl { };

  pyopengl = callPackage ./non-by-name/pyopengl {
    inherit (pkgs) mesa;
  };

  pyopengl-accelerate = callPackage ./non-by-name/pyopengl-accelerate { };

  pyopengltk = callPackage ./non-by-name/pyopengltk { };

  pyopenjtalk = callPackage ./non-by-name/pyopenjtalk { };

  pyopenjtalk-plus = callPackage ./non-by-name/pyopenjtalk-plus { };

  pyopensprinkler = callPackage ./non-by-name/pyopensprinkler { };

  pyopenssl = callPackage ./non-by-name/pyopenssl { };

  pyopenuv = callPackage ./non-by-name/pyopenuv { };

  pyopenweathermap = callPackage ./non-by-name/pyopenweathermap { };

  pyopnsense = callPackage ./non-by-name/pyopnsense { };

  pyoppleio = callPackage ./non-by-name/pyoppleio { };

  pyoppleio-legacy = callPackage ./non-by-name/pyoppleio-legacy { };

  pyoprf = callPackage ./non-by-name/pyoprf { };

  pyorc = callPackage ./non-by-name/pyorc { };

  pyorthanc = callPackage ./non-by-name/pyorthanc { };

  pyosf = callPackage ./non-by-name/pyosf { };

  pyosmocom = callPackage ./non-by-name/pyosmocom { };

  pyosoenergyapi = callPackage ./non-by-name/pyosoenergyapi { };

  pyotb = callPackage ./non-by-name/pyotb { };

  pyotgw = callPackage ./non-by-name/pyotgw { };

  pyotp = callPackage ./non-by-name/pyotp { };

  pyoutbreaksnearme = callPackage ./non-by-name/pyoutbreaksnearme { };

  pyoverkiz = callPackage ./non-by-name/pyoverkiz { };

  pyowm = callPackage ./non-by-name/pyowm { };

  pyoxigraph = callPackage ./non-by-name/pyoxigraph { };

  pyoxipng = callPackage ./non-by-name/pyoxipng { };

  pypager = callPackage ./non-by-name/pypager { };

  pypalazzetti = callPackage ./non-by-name/pypalazzetti { };

  pypamtest = toPythonModule (
    pkgs.libpam-wrapper.override {
      enablePython = true;
      inherit python;
    }
  );

  pypandoc = callPackage ./non-by-name/pypandoc { };

  pypaperless = callPackage ./non-by-name/pypaperless { };

  pyparsebluray = callPackage ./non-by-name/pyparsebluray { };

  pyparser = callPackage ./non-by-name/pyparser { };

  pyparsing = callPackage ./non-by-name/pyparsing { };

  pyparted = callPackage ./non-by-name/pyparted { };

  pypass = callPackage ./non-by-name/pypass { };

  pypasser = callPackage ./non-by-name/pypasser { };

  pypblib = callPackage ./non-by-name/pypblib { };

  pypca = callPackage ./non-by-name/pypca { };

  pypck = callPackage ./non-by-name/pypck { };

  pypcode = callPackage ./non-by-name/pypcode { };

  pypdf = callPackage ./non-by-name/pypdf { };

  pypdf2 = callPackage ./non-by-name/pypdf2 { };

  pypdf3 = callPackage ./non-by-name/pypdf3 { };

  pypdfium2 = callPackage ./non-by-name/pypdfium2 { };

  pypeg2 = callPackage ./non-by-name/pypeg2 { };

  pypemicro = callPackage ./non-by-name/pypemicro { };

  pyperclip = callPackage ./non-by-name/pyperclip { };

  pyperclipfix = callPackage ./non-by-name/pyperclipfix { };

  pyperf = callPackage ./non-by-name/pyperf { };

  pyperscan = callPackage ./non-by-name/pyperscan { };

  pypglab = callPackage ./non-by-name/pypglab { };

  pyphen = callPackage ./non-by-name/pyphen { };

  pyphotonfile = callPackage ./non-by-name/pyphotonfile { };

  pypi-simple = callPackage ./non-by-name/pypi-simple { };

  pypika = callPackage ./non-by-name/pypika { };

  pypillowfight = callPackage ./non-by-name/pypillowfight { };

  pypinyin = callPackage ./non-by-name/pypinyin { };

  pypiserver = callPackage ./non-by-name/pypiserver { };

  pypitoken = callPackage ./non-by-name/pypitoken { };

  pypjlink2 = callPackage ./non-by-name/pypjlink2 { };

  pyplaato = callPackage ./non-by-name/pyplaato { };

  pyplatec = callPackage ./non-by-name/pyplatec { };

  pypng = callPackage ./non-by-name/pypng { };

  pypoint = callPackage ./non-by-name/pypoint { };

  pypoolstation = callPackage ./non-by-name/pypoolstation { };

  pyporscheconnectapi = callPackage ./non-by-name/pyporscheconnectapi { };

  pyportainer = callPackage ./non-by-name/pyportainer { };

  pyppeteer = callPackage ./non-by-name/pyppeteer { };

  pyppeteer-ng = callPackage ./non-by-name/pyppeteer-ng { };

  pyppmd = callPackage ./non-by-name/pyppmd { };

  pyprecice = callPackage ./non-by-name/pyprecice {
    precice = pkgs.precice.override {
      python3Packages = self;
    };
  };

  pypresence = callPackage ./non-by-name/pypresence { };

  pyprind = callPackage ./non-by-name/pyprind { };

  pyprobables = callPackage ./non-by-name/pyprobables { };

  pyprobeplus = callPackage ./non-by-name/pyprobeplus { };

  pyprof2calltree = callPackage ./non-by-name/pyprof2calltree { };

  pyproj = callPackage ./non-by-name/pyproj { };

  pyproject-api = callPackage ./non-by-name/pyproject-api { };

  pyproject-hooks = callPackage ./non-by-name/pyproject-hooks { };

  pyproject-metadata = callPackage ./non-by-name/pyproject-metadata { };

  pyproject-parser = callPackage ./non-by-name/pyproject-parser { };

  pyprosegur = callPackage ./non-by-name/pyprosegur { };

  pyprusalink = callPackage ./non-by-name/pyprusalink { };

  pyps4-2ndscreen = callPackage ./non-by-name/pyps4-2ndscreen { };

  pypsrp = callPackage ./non-by-name/pypsrp { };

  pyptlib = callPackage ./non-by-name/pyptlib { };

  pypubsub = callPackage ./non-by-name/pypubsub { };

  pypugjs = callPackage ./non-by-name/pypugjs { };

  pypykatz = callPackage ./non-by-name/pypykatz { };

  pypytools = callPackage ./non-by-name/pypytools { };

  pyqodeng = callPackage ./non-by-name/pyqodeng { };

  pyqrcode = callPackage ./non-by-name/pyqrcode { };

  pyqt-builder = callPackage ./non-by-name/pyqt-builder { };

  pyqt5 = callPackage ./non-by-name/pyqt/5.x.nix { inherit (pkgs) mesa; };

  pyqt5-multimedia = self.pyqt5.override { withMultimedia = true; };

  pyqt5-sip = callPackage ./non-by-name/pyqt/sip.nix {
    inherit (pkgs) mesa;
  };

  pyqt6 = callPackage ./non-by-name/pyqt/6.x.nix {
    inherit (pkgs) mesa;
  };

  pyqt6-charts = callPackage ./non-by-name/pyqt6-charts {
    inherit (pkgs) mesa;
  };

  pyqt6-qscintilla = callPackage ./non-by-name/qscintilla { };

  pyqt6-sip = callPackage ./non-by-name/pyqt/pyqt6-sip.nix {
    inherit (pkgs) mesa;
  };

  pyqt6-webengine = callPackage ./non-by-name/pyqt6-webengine {
    inherit (pkgs) mesa;
  };

  pyqtchart = callPackage ./non-by-name/pyqtchart { };

  pyqtdarktheme = callPackage ./non-by-name/pyqtdarktheme { };

  pyqtdatavisualization = callPackage ./non-by-name/pyqtdatavisualization { };

  pyqtgraph = callPackage ./non-by-name/pyqtgraph { };

  pyquaternion = callPackage ./non-by-name/pyquaternion { };

  pyquery = callPackage ./non-by-name/pyquery { };

  pyquerylist = callPackage ./non-by-name/pyquerylist { };

  pyquil = callPackage ./non-by-name/pyquil { };

  pyqvrpro = callPackage ./non-by-name/pyqvrpro { };

  pyqwest = callPackage ./non-by-name/pyqwest { };

  pyqwikswitch = callPackage ./non-by-name/pyqwikswitch { };

  pyrabbit2 = callPackage ./non-by-name/pyrabbit2 { };

  pyrad = callPackage ./non-by-name/pyrad { };

  pyradiomics = callPackage ./non-by-name/pyradiomics { };

  pyradios = callPackage ./non-by-name/pyradios { };

  pyrail = callPackage ./non-by-name/pyrail { };

  pyrainbird = callPackage ./non-by-name/pyrainbird { };

  pyramid = callPackage ./non-by-name/pyramid { };

  pyramid-beaker = callPackage ./non-by-name/pyramid-beaker { };

  pyramid-chameleon = callPackage ./non-by-name/pyramid-chameleon { };

  pyramid-exclog = callPackage ./non-by-name/pyramid-exclog { };

  pyramid-jinja2 = callPackage ./non-by-name/pyramid-jinja2 { };

  pyramid-mako = callPackage ./non-by-name/pyramid-mako { };

  pyramid-multiauth = callPackage ./non-by-name/pyramid-multiauth { };

  pyrate-limiter = callPackage ./non-by-name/pyrate-limiter { };

  pyrate-limiter_2 = callPackage ./non-by-name/pyrate-limiter_2 { };

  pyrdfa3 = callPackage ./non-by-name/pyrdfa3 { };

  pyre-extensions = callPackage ./non-by-name/pyre-extensions { };

  pyreadstat = callPackage ./non-by-name/pyreadstat { };

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

  pyrecswitch = callPackage ./non-by-name/pyrecswitch { };

  pyrect = callPackage ./non-by-name/pyrect { };

  pyregion = callPackage ./non-by-name/pyregion { };

  pyregrws = callPackage ./non-by-name/pyregrws { };

  pyrejseplan = callPackage ./non-by-name/pyrejseplan { };

  pyrender = callPackage ./non-by-name/pyrender {
    inherit (pkgs) mesa;
  };

  pyrepetierng = callPackage ./non-by-name/pyrepetierng { };

  pyreqwest = callPackage ./non-by-name/pyreqwest { zstd-c = pkgs.zstd; };

  pyrevolve = callPackage ./non-by-name/pyrevolve { };

  pyrfc3339 = callPackage ./non-by-name/pyrfc3339 { };

  pyrfxtrx = callPackage ./non-by-name/pyrfxtrx { };

  pyric = callPackage ./non-by-name/pyric { };

  pyring-buffer = callPackage ./non-by-name/pyring-buffer { };

  pyrisco = callPackage ./non-by-name/pyrisco { };

  pyrmvtransport = callPackage ./non-by-name/pyrmvtransport { };

  pyro-api = callPackage ./non-by-name/pyro-api { };

  pyro-ppl = callPackage ./non-by-name/pyro-ppl { };

  pyro4 = callPackage ./non-by-name/pyro4 { };

  pyro5 = callPackage ./non-by-name/pyro5 { };

  pyroaring = callPackage ./non-by-name/pyroaring { };

  pyroma = callPackage ./non-by-name/pyroma { };

  pyroute2 = callPackage ./non-by-name/pyroute2 { };

  pyrsistent = callPackage ./non-by-name/pyrsistent { };

  pyrss2gen = callPackage ./non-by-name/pyrss2gen { };

  pyrtlsdr = callPackage ./non-by-name/pyrtlsdr { };

  pyrympro = callPackage ./non-by-name/pyrympro { };

  pysabnzbd = callPackage ./non-by-name/pysabnzbd { };

  pysail = callPackage ./non-by-name/pysail {
    protoc = pkgs.protobuf;
    inherit (pkgs) zstd;
  };

  pysam = callPackage ./non-by-name/pysam { };

  pysaml2 = callPackage ./non-by-name/pysaml2 { inherit (pkgs) xmlsec; };

  pysatochip = callPackage ./non-by-name/pysatochip { };

  pysaunum = callPackage ./non-by-name/pysaunum { };

  pysbd = callPackage ./non-by-name/pysbd { };

  pysc2 = callPackage ./non-by-name/pysc2 { };

  pyscaffold = callPackage ./non-by-name/pyscaffold { };

  pyscaffoldext-cookiecutter = callPackage ./non-by-name/pyscaffoldext-cookiecutter { };

  pyscaffoldext-custom-extension = callPackage ./non-by-name/pyscaffoldext-custom-extension { };

  pyscaffoldext-django = callPackage ./non-by-name/pyscaffoldext-django { };

  pyscaffoldext-dsproject = callPackage ./non-by-name/pyscaffoldext-dsproject { };

  pyscaffoldext-markdown = callPackage ./non-by-name/pyscaffoldext-markdown { };

  pyscaffoldext-travis = callPackage ./non-by-name/pyscaffoldext-travis { };

  pyscard = callPackage ./non-by-name/pyscard { };

  pyscf = callPackage ./non-by-name/pyscf {
    inherit (pkgs) libxc;
  };

  pyschedule = callPackage ./non-by-name/pyschedule { };

  pyschemes = callPackage ./non-by-name/pyschemes { };

  pyschlage = callPackage ./non-by-name/pyschlage { };

  pyscorpiontrack = callPackage ./non-by-name/pyscorpiontrack { };

  pyscreenshot = callPackage ./non-by-name/pyscreenshot { };

  pyscreeze = callPackage ./non-by-name/pyscreeze { };

  pyscrypt = callPackage ./non-by-name/pyscrypt { };

  pyscss = callPackage ./non-by-name/pyscss { };

  pysctp = callPackage ./non-by-name/pysctp { };

  pysdcp = callPackage ./non-by-name/pysdcp { };

  pysdl2 = callPackage ./non-by-name/pysdl2 { };

  pysdl3 = callPackage ./non-by-name/pysdl3 { };

  pysearpc = toPythonModule (pkgs.libsearpc.override { python3 = self.python; });

  pysecretsocks = callPackage ./non-by-name/pysecretsocks { };

  pysecuritas = callPackage ./non-by-name/pysecuritas { };

  pysendfile = callPackage ./non-by-name/pysendfile { };

  pysensibo = callPackage ./non-by-name/pysensibo { };

  pysensors = callPackage ./non-by-name/pysensors { };

  pysenz = callPackage ./non-by-name/pysenz { };

  pysequoia = callPackage ./non-by-name/pysequoia { };

  pyserial = callPackage ./non-by-name/pyserial { };

  pyserial-asyncio = callPackage ./non-by-name/pyserial-asyncio { };

  pyserial-asyncio-fast = callPackage ./non-by-name/pyserial-asyncio-fast { };

  pyseries = callPackage ./non-by-name/pyseries { };

  pysesame2 = callPackage ./non-by-name/pysesame2 { };

  pyseventeentrack = callPackage ./non-by-name/pyseventeentrack { };

  pysfcgal = callPackage ./non-by-name/pysfcgal { };

  pysftp = callPackage ./non-by-name/pysftp { };

  pyshacl = callPackage ./non-by-name/pyshacl { };

  pyshark = callPackage ./non-by-name/pyshark { };

  pyshp = callPackage ./non-by-name/pyshp { };

  pysiaalarm = callPackage ./non-by-name/pysiaalarm { };

  pyside2 = toPythonModule (callPackage ./non-by-name/pyside2 { inherit (pkgs) cmake ninja qt5; });

  pyside2-tools = toPythonModule (
    callPackage ./non-by-name/pyside2-tools { inherit (pkgs) cmake qt5; }
  );

  pyside6 = toPythonModule (callPackage ./non-by-name/pyside6 { inherit (pkgs) cmake ninja; });

  pyside6-qtads = callPackage ./non-by-name/pyside6-qtads { };

  pysigma = callPackage ./non-by-name/pysigma { };

  pysigma-backend-crowdstrike = callPackage ./non-by-name/pysigma-backend-crowdstrike { };

  pysigma-backend-elasticsearch = callPackage ./non-by-name/pysigma-backend-elasticsearch { };

  pysigma-backend-insightidr = callPackage ./non-by-name/pysigma-backend-insightidr { };

  pysigma-backend-loki = callPackage ./non-by-name/pysigma-backend-loki { };

  pysigma-backend-opensearch = callPackage ./non-by-name/pysigma-backend-opensearch { };

  pysigma-backend-qradar = callPackage ./non-by-name/pysigma-backend-qradar { };

  pysigma-backend-splunk = callPackage ./non-by-name/pysigma-backend-splunk { };

  pysigma-backend-sqlite = callPackage ./non-by-name/pysigma-backend-sqlite { };

  pysigma-pipeline-sysmon = callPackage ./non-by-name/pysigma-pipeline-sysmon { };

  pysigma-pipeline-windows = callPackage ./non-by-name/pysigma-pipeline-windows { };

  pysignalclirestapi = callPackage ./non-by-name/pysignalclirestapi { };

  pysignalr = callPackage ./non-by-name/pysignalr { };

  pysigset = callPackage ./non-by-name/pysigset { };

  pysilero-vad = callPackage ./non-by-name/pysilero-vad { };

  pysillaprism = callPackage ./non-by-name/pysillaprism { };

  pysim = callPackage ./non-by-name/pysim { };

  pysimplesoap = callPackage ./non-by-name/pysimplesoap { };

  pysindy = callPackage ./non-by-name/pysindy { };

  pysingleton = callPackage ./non-by-name/pysingleton { };

  pyskyqhub = callPackage ./non-by-name/pyskyqhub { };

  pyskyqremote = callPackage ./non-by-name/pyskyqremote { };

  pyslim = callPackage ./non-by-name/pyslim { };

  pyslurm = callPackage ./non-by-name/pyslurm { inherit (pkgs) slurm; };

  pysma = callPackage ./non-by-name/pysma { };

  pysmappee = callPackage ./non-by-name/pysmappee { };

  pysmarlaapi = callPackage ./non-by-name/pysmarlaapi { };

  pysmart = callPackage ./non-by-name/pysmart { };

  pysmartdl = callPackage ./non-by-name/pysmartdl { };

  pysmartthings = callPackage ./non-by-name/pysmartthings { };

  pysmarty2 = callPackage ./non-by-name/pysmarty2 { };

  pysmartyplants = callPackage ./non-by-name/pysmartyplants { };

  pysmb = callPackage ./non-by-name/pysmb { };

  pysmbc = callPackage ./non-by-name/pysmbc { };

  pysmf = callPackage ./non-by-name/pysmf { };

  pysmhi = callPackage ./non-by-name/pysmhi { };

  pysmi = callPackage ./non-by-name/pysmi { };

  pysml = callPackage ./non-by-name/pysml { };

  pysmlight = callPackage ./non-by-name/pysmlight { };

  pysmt = callPackage ./non-by-name/pysmt { };

  pysnmp = callPackage ./non-by-name/pysnmp { };

  pysnmp-pyasn1 = callPackage ./non-by-name/pysnmp-pyasn1 { };

  pysnmp-pysmi = callPackage ./non-by-name/pysnmp-pysmi { };

  pysnmpcrypto = callPackage ./non-by-name/pysnmpcrypto { };

  pysnmplib = callPackage ./non-by-name/pysnmplib { };

  pysnooper = callPackage ./non-by-name/pysnooper { };

  pysnooz = callPackage ./non-by-name/pysnooz { };

  pysnow = callPackage ./non-by-name/pysnow { };

  pysocks = callPackage ./non-by-name/pysocks { };

  pysodium = callPackage ./non-by-name/pysodium { };

  pysol-cards = callPackage ./non-by-name/pysol-cards { };

  pysolarmanv5 = callPackage ./non-by-name/pysolarmanv5 { };

  pysolcast = callPackage ./non-by-name/pysolcast { };

  pysolr = callPackage ./non-by-name/pysolr { };

  pysoma = callPackage ./non-by-name/pysoma { };

  pysomfymylink = callPackage ./non-by-name/pysomfymylink { };

  pysonos = callPackage ./non-by-name/pysonos { };

  pysoundfile = self.soundfile; # Alias added 23-06-2019

  pyspark = callPackage ./non-by-name/pyspark { };

  pyspcwebgw = callPackage ./non-by-name/pyspcwebgw { };

  pyspeex-noise = callPackage ./non-by-name/pyspeex-noise { };

  pyspellchecker = callPackage ./non-by-name/pyspellchecker { };

  pyspelling = callPackage ./non-by-name/pyspelling { };

  pyspf = callPackage ./non-by-name/pyspf { };

  pyspice = callPackage ./non-by-name/pyspice { };

  pyspiflash = callPackage ./non-by-name/pyspiflash { };

  pyspinel = callPackage ./non-by-name/pyspinel { };

  pyspnego = callPackage ./non-by-name/pyspnego { };

  pysptk = callPackage ./non-by-name/pysptk { };

  pyspx = callPackage ./non-by-name/pyspx { };

  pysqlitecipher = callPackage ./non-by-name/pysqlitecipher { };

  pysquashfsimage = callPackage ./non-by-name/pysquashfsimage { };

  pysqueezebox = callPackage ./non-by-name/pysqueezebox { };

  pysrdaligateway = callPackage ./non-by-name/pysrdaligateway { };

  pysrim = callPackage ./non-by-name/pysrim { };

  pysrt = callPackage ./non-by-name/pysrt { };

  pyssim = callPackage ./non-by-name/pyssim { };

  pystac = callPackage ./non-by-name/pystac { };

  pystac-client = callPackage ./non-by-name/pystac-client { };

  pystache = callPackage ./non-by-name/pystache { };

  pystardict = callPackage ./non-by-name/pystardict { };

  pystatgrab = callPackage ./non-by-name/pystatgrab { };

  pystemd = callPackage ./non-by-name/pystemd { inherit (pkgs) systemd; };

  pystemmer = callPackage ./non-by-name/pystemmer { };

  pystiebeleltron = callPackage ./non-by-name/pystiebeleltron { };

  pystitch = callPackage ./non-by-name/pystitch { };

  pystray = callPackage ./non-by-name/pystray { };

  pystrich = callPackage ./non-by-name/pystrich {
    inherit (pkgs) ghostscript;
  };

  pysubs2 = callPackage ./non-by-name/pysubs2 { };

  pysuezv2 = callPackage ./non-by-name/pysuezv2 { };

  pysunspec2 = callPackage ./non-by-name/pysunspec2 { };

  pysvg-py3 = callPackage ./non-by-name/pysvg-py3 { };

  pysvn = callPackage ./non-by-name/pysvn {
    inherit (pkgs)
      bash
      subversion
      apr
      aprutil
      ;
  };

  pyswitchbee = callPackage ./non-by-name/pyswitchbee { };

  pyswitchbot = callPackage ./non-by-name/pyswitchbot { };

  pyswitchmate = callPackage ./non-by-name/pyswitchmate { };

  pysychonaut = callPackage ./non-by-name/pysychonaut { };

  pysyncobj = callPackage ./non-by-name/pysyncobj { };

  pysyncthru = callPackage ./non-by-name/pysyncthru { };

  pytabix = callPackage ./non-by-name/pytabix { };

  pytablewriter = callPackage ./non-by-name/pytablewriter { };

  pytaglib = callPackage ./non-by-name/pytaglib { };

  pytak = callPackage ./non-by-name/pytak { };

  pytango = callPackage ./non-by-name/pytango { };

  pytankerkoenig = callPackage ./non-by-name/pytankerkoenig { };

  pytap2 = callPackage ./non-by-name/pytap2 { };

  pytapo = callPackage ./non-by-name/pytapo { };

  pytask = callPackage ./non-by-name/pytask { };

  pytautulli = callPackage ./non-by-name/pytautulli { };

  pyte = callPackage ./non-by-name/pyte { };

  pytelegrambotapi = callPackage ./non-by-name/pyTelegramBotAPI { };

  pyteleinfo = callPackage ./non-by-name/pyteleinfo { };

  pytenable = callPackage ./non-by-name/pytenable { };

  pytensor = callPackage ./non-by-name/pytensor { };

  pytesseract = callPackage ./non-by-name/pytesseract { };

  pytest = callPackage ./non-by-name/pytest { };

  pytest-aio = callPackage ./non-by-name/pytest-aio { };

  pytest-aiohttp = callPackage ./non-by-name/pytest-aiohttp { };

  pytest-aioresponses = callPackage ./non-by-name/pytest-aioresponses { };

  pytest-annotate = callPackage ./non-by-name/pytest-annotate { };

  pytest-ansible = callPackage ./non-by-name/pytest-ansible { };

  pytest-archon = callPackage ./non-by-name/pytest-archon { };

  pytest-arraydiff = callPackage ./non-by-name/pytest-arraydiff { };

  pytest-assume = callPackage ./non-by-name/pytest-assume { };

  pytest-astropy = callPackage ./non-by-name/pytest-astropy { };

  pytest-astropy-header = callPackage ./non-by-name/pytest-astropy-header { };

  pytest-asyncio = callPackage ./non-by-name/pytest-asyncio { };

  pytest-asyncio-cooperative = callPackage ./non-by-name/pytest-asyncio-cooperative { };

  pytest-asyncio_0 = callPackage ./non-by-name/pytest-asyncio/0.nix { };

  pytest-base-url = callPackage ./non-by-name/pytest-base-url { };

  pytest-bdd = callPackage ./non-by-name/pytest-bdd { };

  pytest-benchmark = callPackage ./non-by-name/pytest-benchmark { };

  pytest-black = callPackage ./non-by-name/pytest-black { };

  pytest-cache = self.pytestcache; # added 2021-01-04

  pytest-cases = callPackage ./non-by-name/pytest-cases { };

  pytest-catchlog = callPackage ./non-by-name/pytest-catchlog { };

  pytest-celery = callPackage ./non-by-name/pytest-celery { };

  pytest-check = callPackage ./non-by-name/pytest-check { };

  pytest-cid = callPackage ./non-by-name/pytest-cid { };

  pytest-click = callPackage ./non-by-name/pytest-click { };

  pytest-codspeed = callPackage ./non-by-name/pytest-codspeed { };

  pytest-console-scripts = callPackage ./non-by-name/pytest-console-scripts { };

  pytest-cov = callPackage ./non-by-name/pytest-cov { };

  pytest-cov-stub = callPackage ./non-by-name/pytest-cov-stub { };

  pytest-datadir = callPackage ./non-by-name/pytest-datadir { };

  pytest-datafiles = callPackage ./non-by-name/pytest-datafiles { };

  pytest-dependency = callPackage ./non-by-name/pytest-dependency { };

  pytest-describe = callPackage ./non-by-name/pytest-describe { };

  pytest-django = callPackage ./non-by-name/pytest-django { };

  pytest-django_4_12 = callPackage ./non-by-name/pytest-django_4_12 { };

  pytest-docker = callPackage ./non-by-name/pytest-docker { };

  pytest-docker-tools = callPackage ./non-by-name/pytest-docker-tools { };

  pytest-doctestplus = callPackage ./non-by-name/pytest-doctestplus { };

  pytest-dotenv = callPackage ./non-by-name/pytest-dotenv { };

  pytest-emoji = callPackage ./non-by-name/pytest-emoji { };

  pytest-env = callPackage ./non-by-name/pytest-env { };

  pytest-error-for-skips = callPackage ./non-by-name/pytest-error-for-skips { };

  pytest-examples = callPackage ./non-by-name/pytest-examples { };

  pytest-expect = callPackage ./non-by-name/pytest-expect { };

  pytest-factoryboy = callPackage ./non-by-name/pytest-factoryboy { };

  pytest-filter-subpackage = callPackage ./non-by-name/pytest-filter-subpackage { };

  pytest-fixture-classes = callPackage ./non-by-name/pytest-fixture-classes { };

  pytest-fixture-config = callPackage ./non-by-name/pytest-fixture-config { };

  pytest-flake8 = callPackage ./non-by-name/pytest-flake8 { };

  pytest-flakes = callPackage ./non-by-name/pytest-flakes { };

  pytest-flask = callPackage ./non-by-name/pytest-flask { };

  pytest-forked = callPackage ./non-by-name/pytest-forked { };

  pytest-freezegun = callPackage ./non-by-name/pytest-freezegun { };

  pytest-freezer = callPackage ./non-by-name/pytest-freezer { };

  pytest-gitconfig = callPackage ./non-by-name/pytest-gitconfig { };

  pytest-golden = callPackage ./non-by-name/pytest-golden { };

  pytest-grpc = callPackage ./non-by-name/pytest-grpc { };

  pytest-harvest = callPackage ./non-by-name/pytest-harvest { };

  pytest-helpers-namespace = callPackage ./non-by-name/pytest-helpers-namespace { };

  pytest-html = callPackage ./non-by-name/pytest-html { };

  pytest-httpbin = callPackage ./non-by-name/pytest-httpbin { };

  pytest-httpserver = callPackage ./non-by-name/pytest-httpserver { };

  pytest-httpx = callPackage ./non-by-name/pytest-httpx { };

  pytest-icdiff = callPackage ./non-by-name/pytest-icdiff { };

  pytest-image-diff = callPackage ./non-by-name/pytest-image-diff { };

  pytest-insta = callPackage ./non-by-name/pytest-insta { };

  pytest-instafail = callPackage ./non-by-name/pytest-instafail { };

  pytest-integration = callPackage ./non-by-name/pytest-integration { };

  pytest-isort = callPackage ./non-by-name/pytest-isort { };

  pytest-json-report = callPackage ./non-by-name/pytest-json-report { };

  pytest-jupyter = callPackage ./non-by-name/pytest-jupyter { };

  pytest-lazy-fixture = callPackage ./non-by-name/pytest-lazy-fixture { };

  pytest-lazy-fixtures = callPackage ./non-by-name/pytest-lazy-fixtures { };

  pytest-localserver = callPackage ./non-by-name/pytest-localserver { };

  pytest-logdog = callPackage ./non-by-name/pytest-logdog { };

  pytest-lsp = callPackage ./non-by-name/pytest-lsp { };

  pytest-markdown-docs = callPackage ./non-by-name/pytest-markdown-docs { };

  pytest-md-report = callPackage ./non-by-name/pytest-md-report { };

  pytest-memray = callPackage ./non-by-name/pytest-memray { };

  pytest-metadata = callPackage ./non-by-name/pytest-metadata { };

  pytest-mh = callPackage ./non-by-name/pytest-mh { };

  pytest-mock = callPackage ./non-by-name/pytest-mock { };

  pytest-mockito = callPackage ./non-by-name/pytest-mockito { };

  pytest-mockservers = callPackage ./non-by-name/pytest-mockservers { };

  pytest-mpi = callPackage ./non-by-name/pytest-mpi { };

  pytest-mpl = callPackage ./non-by-name/pytest-mpl { };

  pytest-mypy = callPackage ./non-by-name/pytest-mypy { };

  pytest-mypy-plugins = callPackage ./non-by-name/pytest-mypy-plugins { };

  pytest-mysql = callPackage ./non-by-name/pytest-mysql { };

  pytest-notebook = callPackage ./non-by-name/pytest-notebook { };

  pytest-order = callPackage ./non-by-name/pytest-order { };

  pytest-parallel = callPackage ./non-by-name/pytest-parallel { };

  pytest-param-files = callPackage ./non-by-name/pytest-param-files { };

  pytest-playwright = callPackage ./non-by-name/pytest-playwright { };

  pytest-plt = callPackage ./non-by-name/pytest-plt { };

  pytest-plus = callPackage ./non-by-name/pytest-plus { };

  pytest-pook = callPackage ./non-by-name/pytest-pook { };

  pytest-postgresql = callPackage ./non-by-name/pytest-postgresql { };

  pytest-pretty = callPackage ./non-by-name/pytest-pretty { };

  pytest-pudb = callPackage ./non-by-name/pytest-pudb { };

  pytest-pycodestyle = callPackage ./non-by-name/pytest-pycodestyle { };

  pytest-pylint = callPackage ./non-by-name/pytest-pylint { };

  pytest-pytestrail = callPackage ./non-by-name/pytest-pytestrail { };

  pytest-qt = callPackage ./non-by-name/pytest-qt { };

  pytest-quickcheck = callPackage ./non-by-name/pytest-quickcheck { };

  pytest-raises = callPackage ./non-by-name/pytest-raises { };

  pytest-raisesregexp = callPackage ./non-by-name/pytest-raisesregexp { };

  pytest-raisin = callPackage ./non-by-name/pytest-raisin { };

  pytest-random-order = callPackage ./non-by-name/pytest-random-order { };

  pytest-randomly = callPackage ./non-by-name/pytest-randomly { };

  pytest-recording = callPackage ./non-by-name/pytest-recording { };

  pytest-regressions = callPackage ./non-by-name/pytest-regressions { };

  pytest-relaxed = callPackage ./non-by-name/pytest-relaxed { };

  pytest-remotedata = callPackage ./non-by-name/pytest-remotedata { };

  pytest-repeat = callPackage ./non-by-name/pytest-repeat { };

  pytest-reraise = callPackage ./non-by-name/pytest-reraise { };

  pytest-rerunfailures = callPackage ./non-by-name/pytest-rerunfailures { };

  pytest-resource-path = callPackage ./non-by-name/pytest-resource-path { };

  pytest-responses = callPackage ./non-by-name/pytest-responses { };

  pytest-retry = callPackage ./non-by-name/pytest-retry { };

  pytest-reverse = callPackage ./non-by-name/pytest-reverse { };

  pytest-ruff = callPackage ./non-by-name/pytest-ruff { };

  pytest-run-parallel = callPackage ./non-by-name/pytest-run-parallel { };

  pytest-scim2-server = callPackage ./non-by-name/pytest-scim2-server { };

  pytest-selenium = callPackage ./non-by-name/pytest-selenium { };

  pytest-server-fixtures = callPackage ./non-by-name/pytest-server-fixtures { };

  pytest-services = callPackage ./non-by-name/pytest-services {
    inherit (pkgs) memcached;
  };

  pytest-shared-session-scope = callPackage ./non-by-name/pytest-shared-session-scope { };

  pytest-shutil = callPackage ./non-by-name/pytest-shutil { };

  pytest-skip-slow = callPackage ./non-by-name/pytest-skip-slow { };

  pytest-smtpd = callPackage ./non-by-name/pytest-smtpd { };

  pytest-snapshot = callPackage ./non-by-name/pytest-snapshot { };

  pytest-socket = callPackage ./non-by-name/pytest-socket { };

  pytest-spec = callPackage ./non-by-name/pytest-spec { };

  pytest-subprocess = callPackage ./non-by-name/pytest-subprocess { };

  pytest-subtesthack = callPackage ./non-by-name/pytest-subtesthack { };

  pytest-subtests = callPackage ./non-by-name/pytest-subtests { };

  pytest-sugar = callPackage ./non-by-name/pytest-sugar { };

  pytest-tap = callPackage ./non-by-name/pytest-tap { };

  pytest-test-utils = callPackage ./non-by-name/pytest-test-utils { };

  pytest-testinfra = callPackage ./non-by-name/pytest-testinfra { };

  pytest-testmon = callPackage ./non-by-name/pytest-testmon { };

  pytest-textual-snapshot = callPackage ./non-by-name/pytest-textual-snapshot { };

  pytest-ticket = callPackage ./non-by-name/pytest-ticket { };

  pytest-timeout = callPackage ./non-by-name/pytest-timeout { };

  pytest-tornado = callPackage ./non-by-name/pytest-tornado { };

  pytest-tornasync = callPackage ./non-by-name/pytest-tornasync { };

  pytest-trio = callPackage ./non-by-name/pytest-trio { };

  pytest-twisted = callPackage ./non-by-name/pytest-twisted { };

  pytest-unmagic = callPackage ./non-by-name/pytest-unmagic { };

  pytest-unordered = callPackage ./non-by-name/pytest-unordered { };

  pytest-variables = callPackage ./non-by-name/pytest-variables { };

  pytest-vcr = callPackage ./non-by-name/pytest-vcr { };

  pytest-virtualenv = callPackage ./non-by-name/pytest-virtualenv { };

  pytest-voluptuous = callPackage ./non-by-name/pytest-voluptuous { };

  pytest-warnings = callPackage ./non-by-name/pytest-warnings { };

  pytest-watch = callPackage ./non-by-name/pytest-watch { };

  pytest-xdist = callPackage ./non-by-name/pytest-xdist { };

  pytest-xprocess = callPackage ./non-by-name/pytest-xprocess { };

  pytest-xvfb = callPackage ./non-by-name/pytest-xvfb { };

  pytest7CheckHook = pytestCheckHook.override { pytest = pytest_7; };

  pytest8_3CheckHook = pytestCheckHook.override { pytest = pytest_8_3; };

  pytest9_0CheckHook = pytestCheckHook.override { pytest = pytest_9_0; };

  pytest_7 = callPackage ./non-by-name/pytest/7.nix { };

  pytest_8_3 = callPackage ./non-by-name/pytest/8_3.nix { };

  pytest_9_0 = callPackage ./non-by-name/pytest/9_0.nix { };

  pytestcache = callPackage ./non-by-name/pytestcache { };

  pythinkingcleaner = callPackage ./non-by-name/pythinkingcleaner { };

  python-aidot = callPackage ./non-by-name/python-aidot { };

  python-apt = callPackage ./non-by-name/python-apt { };

  python-arango = callPackage ./non-by-name/python-arango { };

  python-augeas = callPackage ./non-by-name/python-augeas { inherit (pkgs) augeas; };

  python-avatars = callPackage ./non-by-name/python-avatars { };

  python-awair = callPackage ./non-by-name/python-awair { };

  python-axolotl = callPackage ./non-by-name/python-axolotl { };

  python-axolotl-curve25519 = callPackage ./non-by-name/python-axolotl-curve25519 { };

  python-backoff = callPackage ./non-by-name/python-backoff { };

  python-barbicanclient = callPackage ./non-by-name/python-barbicanclient { };

  python-barcode = callPackage ./non-by-name/python-barcode { };

  python-baseconv = callPackage ./non-by-name/python-baseconv { };

  python-benedict = callPackage ./non-by-name/python-benedict { };

  python-bidi = callPackage ./non-by-name/python-bidi { };

  python-binance = callPackage ./non-by-name/python-binance { };

  python-bitcoinlib = callPackage ./non-by-name/python-bitcoinlib { };

  python-blockchain-api = callPackage ./non-by-name/python-blockchain-api { };

  python-box = callPackage ./non-by-name/python-box { };

  python-bsblan = callPackage ./non-by-name/python-bsblan { };

  python-bugzilla = callPackage ./non-by-name/python-bugzilla { };

  python-calamine = callPackage ./non-by-name/python-calamine { };

  python-can = callPackage ./non-by-name/python-can { };

  python-cinderclient = callPackage ./non-by-name/python-cinderclient { };

  python-citybikes = callPackage ./non-by-name/python-citybikes { };

  python-code-minimap = callPackage ./non-by-name/python-code-minimap { };

  python-codon-tables = callPackage ./non-by-name/python-codon-tables { };

  python-coinmarketcap = callPackage ./non-by-name/python-coinmarketcap { };

  python-constraint2 = callPackage ./non-by-name/python-constraint2 { };

  python-creole = callPackage ./non-by-name/python-creole { };

  python-crfsuite = callPackage ./non-by-name/python-crfsuite { };

  python-crontab = callPackage ./non-by-name/python-crontab { };

  python-csxcad = callPackage ./non-by-name/python-csxcad { };

  python-ctags3 = callPackage ./non-by-name/python-ctags3 { };

  python-daemon = callPackage ./non-by-name/python-daemon { };

  python-dali = callPackage ./non-by-name/python-dali { };

  python-datauri = callPackage ./non-by-name/datauri { };

  python-datemath = callPackage ./non-by-name/python-datemath { };

  python-dateutil = callPackage ./non-by-name/python-dateutil { };

  python-dbusmock = callPackage ./non-by-name/python-dbusmock { };

  python-debian = callPackage ./non-by-name/python-debian { };

  python-decouple = callPackage ./non-by-name/python-decouple { };

  python-designateclient = callPackage ./non-by-name/python-designateclient { };

  python-didl-lite = callPackage ./non-by-name/python-didl-lite { };

  python-digitalocean = callPackage ./non-by-name/python-digitalocean { };

  python-discovery = callPackage ./non-by-name/python-discovery { };

  python-docs-theme = callPackage ./non-by-name/python-docs-theme { };

  python-docx = callPackage ./non-by-name/python-docx { };

  python-doi = callPackage ./non-by-name/python-doi { };

  python-dotenv = callPackage ./non-by-name/python-dotenv { };

  python-dropbox-api = callPackage ./non-by-name/python-dropbox-api { };

  python-duco-client = callPackage ./non-by-name/python-duco-client { };

  python-duco-connectivity = callPackage ./non-by-name/python-duco-connectivity { };

  python-ecobee-api = callPackage ./non-by-name/python-ecobee-api { };

  python-editor = callPackage ./non-by-name/python-editor { };

  python-engineio = callPackage ./non-by-name/python-engineio { };

  python-engineio-v3 = callPackage ./non-by-name/python-engineio-v3 { };

  python-escpos = callPackage ./non-by-name/python-escpos { };

  python-etcd = callPackage ./non-by-name/python-etcd { };

  python-ev3dev2 = callPackage ./non-by-name/python-ev3dev2 { };

  python-family-hub-local = callPackage ./non-by-name/python-family-hub-local { };

  python-fasthtml = callPackage ./non-by-name/python-fasthtml { };

  python-fedora = callPackage ./non-by-name/python-fedora { };

  python-ffmpeg = callPackage ./non-by-name/python-ffmpeg { };

  python-flirt = callPackage ./non-by-name/python-flirt { };

  python-fontconfig = callPackage ./non-by-name/python-fontconfig { };

  python-frontmatter = callPackage ./non-by-name/python-frontmatter { };

  python-fsutil = callPackage ./non-by-name/python-fsutil { };

  python-fullykiosk = callPackage ./non-by-name/python-fullykiosk { };

  python-fx = callPackage ./non-by-name/python-fx { };

  python-gammu = callPackage ./non-by-name/python-gammu { };

  python-gc100 = callPackage ./non-by-name/python-gc100 { };

  python-gitlab = callPackage ./non-by-name/python-gitlab { };

  python-glanceclient = callPackage ./non-by-name/python-glanceclient { };

  python-gnupg = callPackage ./non-by-name/python-gnupg { };

  python-google-drive-api = callPackage ./non-by-name/python-google-drive-api { };

  python-google-maps-routing-api = callPackage ./non-by-name/python-google-maps-routing-api { };

  python-google-nest = callPackage ./non-by-name/python-google-nest { };

  python-google-weather-api = callPackage ./non-by-name/python-google-weather-api { };

  python-gvm = callPackage ./non-by-name/python-gvm { };

  python-hcl2 = callPackage ./non-by-name/python-hcl2 { };

  python-heatclient = callPackage ./non-by-name/python-heatclient { };

  python-hglib = callPackage ./non-by-name/python-hglib { };

  python-hl7 = callPackage ./non-by-name/python-hl7 { };

  python-homeassistant-analytics = callPackage ./non-by-name/python-homeassistant-analytics { };

  python-homewizard-energy = callPackage ./non-by-name/python-homewizard-energy { };

  python-hostlist = callPackage ./non-by-name/python-hostlist { };

  python-hosts = callPackage ./non-by-name/python-hosts { };

  python-hotspring = callPackage ./non-by-name/python-hotspring { };

  python-hpilo = callPackage ./non-by-name/python-hpilo { };

  python-http-client = callPackage ./non-by-name/python-http-client { };

  python-i18n = callPackage ./non-by-name/python-i18n { };

  python-idzip = callPackage ./non-by-name/python-idzip { };

  python-ipmi = callPackage ./non-by-name/python-ipmi { };

  python-ipware = callPackage ./non-by-name/python-ipware { };

  python-ironicclient = callPackage ./non-by-name/python-ironicclient { };

  python-iso639 = callPackage ./non-by-name/python-iso639 { };

  python-izone = callPackage ./non-by-name/python-izone { };

  python-jenkins = callPackage ./non-by-name/python-jenkins { };

  python-jobspy = callPackage ./non-by-name/python-jobspy { };

  python-join-api = callPackage ./non-by-name/python-join-api { };

  python-jose = callPackage ./non-by-name/python-jose { };

  python-json-logger = callPackage ./non-by-name/python-json-logger { };

  python-jsonpath = callPackage ./non-by-name/python-jsonpath { };

  python-juicenet = callPackage ./non-by-name/python-juicenet { };

  python-kadmin-rs = callPackage ./non-by-name/python-kadmin-rs { };

  python-kasa = callPackage ./non-by-name/python-kasa { };

  python-keycloak = callPackage ./non-by-name/python-keycloak { };

  python-keystoneclient = callPackage ./non-by-name/python-keystoneclient { };

  python-ldap = callPackage ./non-by-name/python-ldap {
    inherit (pkgs) openldap cyrus_sasl;
  };

  python-ldap-test = callPackage ./non-by-name/python-ldap-test { };

  python-libnmap = callPackage ./non-by-name/python-libnmap { };

  python-libpcap = callPackage ./non-by-name/python-libpcap {
    inherit (pkgs) libpcap;
  };

  python-linkplay = callPackage ./non-by-name/python-linkplay { };

  python-linux-procfs = callPackage ./non-by-name/python-linux-procfs { };

  python-logging-loki = callPackage ./non-by-name/python-logging-loki { };

  python-logstash = callPackage ./non-by-name/python-logstash { };

  python-lorem = callPackage ./non-by-name/python-lorem { };

  python-louvain = callPackage ./non-by-name/python-louvain { };

  python-lsp-black = callPackage ./non-by-name/python-lsp-black { };

  python-lsp-jsonrpc = callPackage ./non-by-name/python-lsp-jsonrpc { };

  python-lsp-ruff = callPackage ./non-by-name/python-lsp-ruff { };

  python-lsp-server = callPackage ./non-by-name/python-lsp-server { };

  python-ly = callPackage ./non-by-name/python-ly { };

  python-lzf = callPackage ./non-by-name/python-lzf { };

  python-lzo = callPackage ./non-by-name/python-lzo { inherit (pkgs) lzo; };

  python-magic = callPackage ./non-by-name/python-magic { };

  python-magnumclient = callPackage ./non-by-name/python-magnumclient { };

  python-manilaclient = callPackage ./non-by-name/python-manilaclient { };

  python-mapnik = callPackage ./non-by-name/python-mapnik rec {
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

  python-markdown-math = callPackage ./non-by-name/python-markdown-math { };

  python-matter-server = callPackage ./non-by-name/python-matter-server { };

  python-melcloud = callPackage ./non-by-name/python-melcloud { };

  python-memcached = callPackage ./non-by-name/python-memcached {
    inherit (pkgs) memcached;
  };

  python-miio = callPackage ./non-by-name/python-miio { };

  python-mimeparse = callPackage ./non-by-name/python-mimeparse { };

  python-mistralclient = callPackage ./non-by-name/python-mistralclient { };

  python-mnist = callPackage ./non-by-name/python-mnist { };

  python-motionmount = callPackage ./non-by-name/python-motionmount { };

  python-mpd2 = callPackage ./non-by-name/python-mpd2 { };

  python-mpv-jsonipc = callPackage ./non-by-name/python-mpv-jsonipc {
    inherit (pkgs) mpv;
  };

  python-multipart = callPackage ./non-by-name/python-multipart { };

  python-musicpd = callPackage ./non-by-name/python-musicpd { };

  python-mystrom = callPackage ./non-by-name/python-mystrom { };

  python-ndn = callPackage ./non-by-name/python-ndn { };

  python-nest = callPackage ./non-by-name/python-nest { };

  python-neutronclient = callPackage ./non-by-name/python-neutronclient { };

  python-nmap = callPackage ./non-by-name/python-nmap { };

  python-nomad = callPackage ./non-by-name/python-nomad { };

  python-novaclient = callPackage ./non-by-name/python-novaclient { };

  python-nvd3 = callPackage ./non-by-name/python-nvd3 { };

  python-oauth2 = callPackage ./non-by-name/python-oauth2 { };

  python-obfuscator = callPackage ./non-by-name/python-obfuscator { };

  python-octaviaclient = callPackage ./non-by-name/python-octaviaclient { };

  python-olm = callPackage ./non-by-name/python-olm { };

  python-on-whales = callPackage ./non-by-name/python-on-whales { };

  python-open-router = callPackage ./non-by-name/python-open-router { };

  python-opendata-transport = callPackage ./non-by-name/python-opendata-transport { };

  python-openems = callPackage ./non-by-name/python-openems { };

  python-openevse-http = callPackage ./non-by-name/python-openevse-http { };

  python-opensky = callPackage ./non-by-name/python-opensky { };

  python-openstackclient = callPackage ./non-by-name/python-openstackclient { };

  python-osc = callPackage ./non-by-name/python-osc { };

  python-otbr-api = callPackage ./non-by-name/python-otbr-api { };

  python-overseerr = callPackage ./non-by-name/python-overseerr { };

  python-oxmsg = callPackage ./non-by-name/python-oxmsg { };

  python-packer = callPackage ./non-by-name/python-packer { };

  python-pae = callPackage ./non-by-name/python-pae { };

  python-pam = callPackage ./non-by-name/python-pam { inherit (pkgs) pam; };

  python-path = callPackage ./non-by-name/python-path { };

  python-pcapng = callPackage ./non-by-name/python-pcapng { };

  python-periphery = callPackage ./non-by-name/python-periphery { };

  python-picnic-api2 = callPackage ./non-by-name/python-picnic-api2 { };

  python-pidfile = callPackage ./non-by-name/python-pidfile { };

  python-pipedrive = callPackage ./non-by-name/python-pipedrive { };

  python-pkcs11 = callPackage ./non-by-name/python-pkcs11 { };

  python-pooldose = callPackage ./non-by-name/python-pooldose { };

  python-poppler = callPackage ./non-by-name/python-poppler { };

  python-pptx = callPackage ./non-by-name/python-pptx { };

  python-prctl = callPackage ./non-by-name/python-prctl { };

  python-pskc = callPackage ./non-by-name/python-pskc { };

  python-ptrace = callPackage ./non-by-name/python-ptrace { };

  python-qube-heatpump = callPackage ./non-by-name/python-qube-heatpump { };

  python-rabbitair = callPackage ./non-by-name/python-rabbitair { };

  python-rapidjson = callPackage ./non-by-name/python-rapidjson { };

  python-redis-lock = callPackage ./non-by-name/python-redis-lock { };

  python-registry = callPackage ./non-by-name/python-registry { };

  python-resize-image = callPackage ./non-by-name/python-resize-image { };

  python-ripple-api = callPackage ./non-by-name/python-ripple-api { };

  python-roborock = callPackage ./non-by-name/python-roborock { };

  python-rpm-spec = callPackage ./non-by-name/python-rpm-spec { };

  python-rtmidi = callPackage ./non-by-name/python-rtmidi { };

  python-sat = callPackage ./non-by-name/python-sat { };

  python-sbom = callPackage ./non-by-name/python-sbom { inherit (pkgs) cmake; };

  python-secp256k1-cardano = callPackage ./non-by-name/python-secp256k1-cardano { };

  python-slugify = callPackage ./non-by-name/python-slugify { };

  python-smarttub = callPackage ./non-by-name/python-smarttub { };

  python-sn2 = callPackage ./non-by-name/python-sn2 { };

  python-snap7 = callPackage ./non-by-name/python-snap7 { inherit (pkgs) snap7; };

  python-snappy = callPackage ./non-by-name/python-snappy {
    snappy-cpp = pkgs.snappy;
  };

  python-snoo = callPackage ./non-by-name/python-snoo { };

  python-socketio = callPackage ./non-by-name/python-socketio { };

  python-socketio-v4 = callPackage ./non-by-name/python-socketio-v4 { };

  python-socks = callPackage ./non-by-name/python-socks { };

  python-songpal = callPackage ./non-by-name/python-songpal { };

  python-speech-features = callPackage ./non-by-name/python-speech-features { };

  python-sql = callPackage ./non-by-name/python-sql { };

  python-statemachine = callPackage ./non-by-name/python-statemachine {
    inherit (pkgs) graphviz;
  };

  python-status = callPackage ./non-by-name/python-status { };

  python-stdnum = callPackage ./non-by-name/python-stdnum { };

  python-string-utils = callPackage ./non-by-name/python-string-utils { };

  python-subunit = callPackage ./non-by-name/python-subunit {
    inherit (pkgs) subunit cppunit check;
  };

  python-swiftclient = callPackage ./non-by-name/python-swiftclient { };

  python-swisscom-internet-box = callPackage ./non-by-name/python-swisscom-internet-box { };

  python-tado = callPackage ./non-by-name/python-tado { };

  python-tds = callPackage ./non-by-name/python-tds { };

  python-technove = callPackage ./non-by-name/python-technove { };

  python-telegram = callPackage ./non-by-name/python-telegram { };

  python-telegram-bot = callPackage ./non-by-name/python-telegram-bot { };

  python-toolbox = callPackage ./non-by-name/python-toolbox { };

  python-transip = callPackage ./non-by-name/python-transip { };

  python-troveclient = callPackage ./non-by-name/python-troveclient { };

  python-trovo = callPackage ./non-by-name/python-trovo { };

  python-tsp = callPackage ./non-by-name/python-tsp { };

  python-twitch-client = callPackage ./non-by-name/python-twitch-client { };

  python-u2flib-host = callPackage ./non-by-name/python-u2flib-host { };

  python-uinput = callPackage ./non-by-name/python-uinput { };

  python-ulid = callPackage ./non-by-name/python-ulid { };

  python-utils = callPackage ./non-by-name/python-utils { };

  python-vagrant = callPackage ./non-by-name/python-vagrant { };

  python-velbus = callPackage ./non-by-name/python-velbus { };

  python-vipaccess = callPackage ./non-by-name/python-vipaccess { };

  python-vlc = callPackage ./non-by-name/python-vlc { };

  python-watcherclient = callPackage ./non-by-name/python-watcherclient { };

  python-wayland-extra = callPackage ./non-by-name/python-wayland-extra { };

  python-whois = callPackage ./non-by-name/python-whois { };

  python-wink = callPackage ./non-by-name/python-wink { };

  python-xapp = callPackage ./non-by-name/python-xapp {
    inherit (pkgs.buildPackages) meson;
    inherit (pkgs)
      gtk3
      gobject-introspection
      polkit
      xapp
      ;
  };

  python-xbox = callPackage ./non-by-name/python-xbox { };

  python-xlib = callPackage ./non-by-name/python-xlib { };

  python-xmp-toolkit = callPackage ./non-by-name/python-xmp-toolkit { };

  python-xz = callPackage ./non-by-name/python-xz { };

  python-yakh = callPackage ./non-by-name/python-yakh { };

  python-yate = callPackage ./non-by-name/python-yate { };

  python-youtube = callPackage ./non-by-name/python-youtube { };

  python-zaqarclient = callPackage ./non-by-name/python-zaqarclient { };

  python-zunclient = callPackage ./non-by-name/python-zunclient { };

  python3-application = callPackage ./non-by-name/python3-application { };

  python3-eventlib = callPackage ./non-by-name/python3-eventlib { };

  python3-gnutls = callPackage ./non-by-name/python3-gnutls { };

  python3-msrplib = callPackage ./non-by-name/python3-msrplib { };

  python3-nmap = callPackage ./non-by-name/python3-nmap { };

  python3-openid = callPackage ./non-by-name/python3-openid { };

  python3-otr = callPackage ./non-by-name/python3-otr { };

  python3-saml = callPackage ./non-by-name/python3-saml { };

  python3-sipsimple = callPackage ./non-by-name/python3-sipsimple { };

  python3-xcaplib = callPackage ./non-by-name/python3-xcaplib { };

  pythondialog = callPackage ./non-by-name/pythondialog { };

  pythonefl = callPackage ./non-by-name/python-efl { };

  pythonegardia = callPackage ./non-by-name/pythonegardia { };

  pythonfinder = callPackage ./non-by-name/pythonfinder { };

  pythonkuma = callPackage ./non-by-name/pythonkuma { };

  pythonnet = callPackage ./non-by-name/pythonnet { };

  pythonocc-core = toPythonModule (
    callPackage ./non-by-name/pythonocc-core {
      inherit (pkgs)
        fontconfig
        rapidjson
        libx11
        libxi
        libxmu
        libxext
        ;
    }
  );

  pythonqwt = callPackage ./non-by-name/pythonqwt { };

  pythran = callPackage ./non-by-name/pythran { inherit (pkgs.llvmPackages) openmp; };

  pythreejs = callPackage ./non-by-name/pythreejs { };

  pytibber = callPackage ./non-by-name/pytibber { };

  pytikz-allefeld = callPackage ./non-by-name/pytikz-allefeld { };

  pytile = callPackage ./non-by-name/pytile { };

  pytimeparse = callPackage ./non-by-name/pytimeparse { };

  pytimeparse2 = callPackage ./non-by-name/pytimeparse2 { };

  pytinyrenderer = callPackage ./non-by-name/pytinyrenderer { };

  pytlv = callPackage ./non-by-name/pytlv { };

  pytm = callPackage ./non-by-name/pytm { };

  pytmx = callPackage ./non-by-name/pytmx { };

  pytokens = callPackage ./non-by-name/pytokens { };

  pytomlpp = callPackage ./non-by-name/pytomlpp { };

  pytomorrowio = callPackage ./non-by-name/pytomorrowio { };

  pytoolconfig = callPackage ./non-by-name/pytoolconfig { };

  pytools = callPackage ./non-by-name/pytools { };

  pytorch-bench = callPackage ./non-by-name/pytorch-bench { };

  pytorch-ignite = callPackage ./non-by-name/pytorch-ignite { };

  pytorch-lightning = callPackage ./non-by-name/pytorch-lightning { };

  pytorch-memlab = callPackage ./non-by-name/pytorch-memlab { };

  pytorch-metric-learning = callPackage ./non-by-name/pytorch-metric-learning { };

  pytorch-msssim = callPackage ./non-by-name/pytorch-msssim { };

  pytorch-pfn-extras = callPackage ./non-by-name/pytorch-pfn-extras { };

  pytorch-tabnet = callPackage ./non-by-name/pytorch-tabnet { };

  pytorch-tokenizers = callPackage ./non-by-name/pytorch-tokenizers { };

  pytorch3d = callPackage ./non-by-name/pytorch3d { };

  pytorchviz = callPackage ./non-by-name/pytorchviz { };

  pytouchline-extended = callPackage ./non-by-name/pytouchline-extended { };

  pytouchlinesl = callPackage ./non-by-name/pytouchlinesl { };

  pytraccar = callPackage ./non-by-name/pytraccar { };

  pytradfri = callPackage ./non-by-name/pytradfri { };

  pytrafikverket = callPackage ./non-by-name/pytrafikverket { };

  pytransportnsw = callPackage ./non-by-name/pytransportnsw { };

  pytransportnswv2 = callPackage ./non-by-name/pytransportnswv2 { };

  pytricia = callPackage ./non-by-name/pytricia { };

  pytrydan = callPackage ./non-by-name/pytrydan { };

  pyttsx3 = callPackage ./non-by-name/pyttsx3 { };

  pytube = callPackage ./non-by-name/pytube { };

  pytubefix = callPackage ./non-by-name/pytubefix { };

  pytun = callPackage ./non-by-name/pytun { };

  pytun-pmd3 = callPackage ./non-by-name/pytun-pmd3 { };

  pyturbojpeg = callPackage ./non-by-name/pyturbojpeg { };

  pytweening = callPackage ./non-by-name/pytweening { };

  pytz = callPackage ./non-by-name/pytz {
    inherit (pkgs) tzdata;
  };

  pytz-deprecation-shim = callPackage ./non-by-name/pytz-deprecation-shim { };

  pyu2f = callPackage ./non-by-name/pyu2f { };

  pyuca = callPackage ./non-by-name/pyuca { };

  pyudev = callPackage ./non-by-name/pyudev { inherit (pkgs) udev; };

  pyunbound = callPackage ./non-by-name/pyunbound { };

  pyunifi = callPackage ./non-by-name/pyunifi { };

  pyunormalize = callPackage ./non-by-name/pyunormalize { };

  pyunpack = callPackage ./non-by-name/pyunpack { };

  pyupgrade = callPackage ./non-by-name/pyupgrade { };

  pyuptimerobot = callPackage ./non-by-name/pyuptimerobot { };

  pyusb = callPackage ./non-by-name/pyusb { inherit (pkgs) libusb1; };

  pyuseragents = callPackage ./non-by-name/pyuseragents { };

  pyutil = callPackage ./non-by-name/pyutil { };

  pyuv = callPackage ./non-by-name/pyuv { };

  pyvcd = callPackage ./non-by-name/pyvcd { };

  pyvera = callPackage ./non-by-name/pyvera { };

  pyverilog = callPackage ./non-by-name/pyverilog { };

  pyvers = callPackage ./non-by-name/pyvers { };

  pyversasense = callPackage ./non-by-name/pyversasense { };

  pyvesync = callPackage ./non-by-name/pyvesync { };

  pyvex = callPackage ./non-by-name/pyvex { };

  pyvicare = callPackage ./non-by-name/pyvicare { };

  pyvips = callPackage ./non-by-name/pyvips { inherit (pkgs) vips glib; };

  pyvirtualdisplay = callPackage ./non-by-name/pyvirtualdisplay { };

  pyvis = callPackage ./non-by-name/pyvis { };

  pyvisa = callPackage ./non-by-name/pyvisa { };

  pyvisa-py = callPackage ./non-by-name/pyvisa-py { };

  pyvisa-sim = callPackage ./non-by-name/pyvisa-sim { };

  pyvista = callPackage ./non-by-name/pyvista { };

  pyvista-validation = callPackage ./non-by-name/pyvista-validation { };

  pyviz-comms = callPackage ./non-by-name/pyviz-comms { };

  pyvlx = callPackage ./non-by-name/pyvlx { };

  pyvmomi = callPackage ./non-by-name/pyvmomi { };

  pyvo = callPackage ./non-by-name/pyvo { };

  pyvolumio = callPackage ./non-by-name/pyvolumio { };

  pyvows = callPackage ./non-by-name/pyvows { };

  pyw215 = callPackage ./non-by-name/pyw215 { };

  pyw800rf32 = callPackage ./non-by-name/pyw800rf32 { };

  pywal16 = callPackage ./non-by-name/pywal16 { };

  pywatchman = callPackage ./non-by-name/pywatchman { };

  pywaterkotte = callPackage ./non-by-name/pywaterkotte { };

  pywavefront = callPackage ./non-by-name/pywavefront { };

  pywavelets = callPackage ./non-by-name/pywavelets { };

  pywayland = callPackage ./non-by-name/pywayland { };

  pywaze = callPackage ./non-by-name/pywaze { };

  pywbem = callPackage ./non-by-name/pywbem { inherit (pkgs) libxml2; };

  pyweatherflowrest = callPackage ./non-by-name/pyweatherflowrest { };

  pyweatherflowudp = callPackage ./non-by-name/pyweatherflowudp { };

  pywebcopy = callPackage ./non-by-name/pywebcopy { };

  pywebpush = callPackage ./non-by-name/pywebpush { };

  pywebtransport = callPackage ./non-by-name/pywebtransport { };

  pywebview = callPackage ./non-by-name/pywebview { };

  pywemo = callPackage ./non-by-name/pywemo { };

  pywerview = callPackage ./non-by-name/pywerview { };

  pywfa = callPackage ./non-by-name/pywfa { };

  pywidevine = callPackage ./non-by-name/pywidevine {
    protobuf = protobuf6;
  };

  pywiim = callPackage ./non-by-name/pywiim { };

  pywikibot = callPackage ./non-by-name/pywikibot { };

  pywilight = callPackage ./non-by-name/pywilight { };

  pywillow = callPackage ./non-by-name/pywillow { };

  pywinbox = callPackage ./non-by-name/pywinbox { };

  pywinctl = callPackage ./non-by-name/pywinctl { };

  pywinrm = callPackage ./non-by-name/pywinrm { };

  pywizlight = callPackage ./non-by-name/pywizlight { };

  pywmspro = callPackage ./non-by-name/pywmspro { };

  pyworld = callPackage ./non-by-name/pyworld { };

  pyworxcloud = callPackage ./non-by-name/pyworxcloud { };

  pyws66i = callPackage ./non-by-name/pyws66i { };

  pyx = callPackage ./non-by-name/pyx { };

  pyxattr = callPackage ./non-by-name/pyxattr { };

  pyxbe = callPackage ./non-by-name/pyxbe { };

  pyxdg = callPackage ./non-by-name/pyxdg { };

  pyxdia = callPackage ./non-by-name/pyxdia { };

  pyxeoma = callPackage ./non-by-name/pyxeoma { };

  pyxiaomigateway = callPackage ./non-by-name/pyxiaomigateway { };

  pyxl3 = callPackage ./non-by-name/pyxl3 { };

  pyxlsb = callPackage ./non-by-name/pyxlsb { };

  pyxnat = callPackage ./non-by-name/pyxnat { };

  pyyaml = callPackage ./non-by-name/pyyaml { };

  pyyaml-env-tag = callPackage ./non-by-name/pyyaml-env-tag { };

  pyyaml-ft = callPackage ./non-by-name/pyyaml-ft { };

  pyyaml-include = callPackage ./non-by-name/pyyaml-include { };

  pyyardian = callPackage ./non-by-name/pyyardian { };

  pyytlounge = callPackage ./non-by-name/pyytlounge { };

  pyzabbix = callPackage ./non-by-name/pyzabbix { };

  pyzbar = callPackage ./non-by-name/pyzbar { };

  pyzerproc = callPackage ./non-by-name/pyzerproc { };

  pyzfs_2_3 = toPythonModule (
    pkgs.zfs_2_3.override {
      enablePyzfs = true;
      python3Packages = self;
    }
  );

  pyzfs_2_4 = toPythonModule (
    pkgs.zfs_2_4.override {
      enablePyzfs = true;
      python3Packages = self;
    }
  );

  pyzhuyin = callPackage ./non-by-name/pyzhuyin { };

  pyzipper = callPackage ./non-by-name/pyzipper { };

  pyzmq = callPackage ./non-by-name/pyzmq { };

  pyzonneplan = callPackage ./non-by-name/pyzonneplan { };

  pyzotero = callPackage ./non-by-name/pyzotero { };

  pyzstd = callPackage ./non-by-name/pyzstd { zstd-c = pkgs.zstd; };

  pyzx = callPackage ./non-by-name/pyzx { };

  qasync = callPackage ./non-by-name/qasync { };

  qbittorrent-api = callPackage ./non-by-name/qbittorrent-api { };

  qbusmqttapi = callPackage ./non-by-name/qbusmqttapi { };

  qcelemental = callPackage ./non-by-name/qcelemental { };

  qcengine = callPackage ./non-by-name/qcengine { };

  qcodes = callPackage ./non-by-name/qcodes { };

  qcodes-contrib-drivers = callPackage ./non-by-name/qcodes-contrib-drivers { };

  qcs-api-client = callPackage ./non-by-name/qcs-api-client { };

  qcs-api-client-common = callPackage ./non-by-name/qcs-api-client-common { };

  qcs-sdk-python = callPackage ./non-by-name/qcs-sdk-python { };

  qdarkstyle = callPackage ./non-by-name/qdarkstyle { };

  qdldl = callPackage ./non-by-name/qdldl { inherit (pkgs) qdldl; };

  qdrant-client = callPackage ./non-by-name/qdrant-client { };

  qemu = callPackage ./non-by-name/qemu { qemu = pkgs.qemu; };

  qemu-qmp = callPackage ./non-by-name/qemu-qmp { };

  qgrid = callPackage ./non-by-name/qgrid { };

  qh3 = callPackage ./non-by-name/qh3 {
    inherit (pkgs) cmake;
  };

  qiling = callPackage ./non-by-name/qiling { };

  qimage2ndarray = callPackage ./non-by-name/qimage2ndarray { };

  qingping-ble = callPackage ./non-by-name/qingping-ble { };

  qiskit = callPackage ./non-by-name/qiskit { };

  qiskit-aer = callPackage ./non-by-name/qiskit-aer { };

  qiskit-algorithms = callPackage ./non-by-name/qiskit-algorithms { };

  qiskit-finance = callPackage ./non-by-name/qiskit-finance { };

  qiskit-machine-learning = callPackage ./non-by-name/qiskit-machine-learning { };

  qiskit-nature = callPackage ./non-by-name/qiskit-nature { };

  qiskit-optimization = callPackage ./non-by-name/qiskit-optimization { };

  qnapstats = callPackage ./non-by-name/qnapstats { };

  qpageview = callPackage ./non-by-name/qpageview { };

  qpsolvers = callPackage ./non-by-name/qpsolvers { };

  qrcode = callPackage ./non-by-name/qrcode { };

  qrcode-terminal = callPackage ./non-by-name/qrcode-terminal { };

  qrcodegen = callPackage ./non-by-name/qrcodegen { qrcodegen = pkgs.qrcodegen; };

  qreactor = callPackage ./non-by-name/qreactor { };

  qscintilla = callPackage ./non-by-name/qscintilla {
    useQt6 = false;
  };

  qstylizer = callPackage ./non-by-name/qstylizer { };

  qt-material = callPackage ./non-by-name/qt-material { };

  qt5reactor = callPackage ./non-by-name/qt5reactor { };

  qt6 = pkgs.qt6.override { python3 = self.python; };

  qtawesome = callPackage ./non-by-name/qtawesome { };

  qtconsole = callPackage ./non-by-name/qtconsole { };

  qtile = callPackage ./non-by-name/qtile { wlroots = pkgs.wlroots_0_20; };

  qtile-bonsai = callPackage ./non-by-name/qtile-bonsai { };

  qtile-extras = callPackage ./non-by-name/qtile-extras { };

  qtpy = callPackage ./non-by-name/qtpy { };

  quack-kernels = callPackage ./non-by-name/quack-kernels { };

  quadprog = callPackage ./non-by-name/quadprog { };

  qualysclient = callPackage ./non-by-name/qualysclient { };

  quandl = callPackage ./non-by-name/quandl { };

  quango = callPackage ./non-by-name/quango { };

  quantile-forest = callPackage ./non-by-name/quantile-forest { };

  quantile-python = callPackage ./non-by-name/quantile-python { };

  quantiphy = callPackage ./non-by-name/quantiphy { };

  quantiphy-eval = callPackage ./non-by-name/quantiphy-eval { };

  quantities = callPackage ./non-by-name/quantities { };

  quantulum3 = callPackage ./non-by-name/quantulum3 { };

  quantum-gateway = callPackage ./non-by-name/quantum-gateway { };

  quart = callPackage ./non-by-name/quart { };

  quart-cors = callPackage ./non-by-name/quart-cors { };

  quart-schema = callPackage ./non-by-name/quart-schema { };

  quart-trio = callPackage ./non-by-name/quart-trio { };

  qudida = callPackage ./non-by-name/qudida { };

  querystring-parser = callPackage ./non-by-name/querystring-parser { };

  questionary = callPackage ./non-by-name/questionary { };

  questo = callPackage ./non-by-name/questo { };

  queuelib = callPackage ./non-by-name/queuelib { };

  quickjs = callPackage ./non-by-name/quickjs { };

  quil = callPackage ./non-by-name/quil { };

  quixote = callPackage ./non-by-name/quixote { };

  qutip = callPackage ./non-by-name/qutip { };

  r2pipe = callPackage ./non-by-name/r2pipe { };

  rachiopy = callPackage ./non-by-name/rachiopy { };

  radicale-infcloud = callPackage ./non-by-name/radicale-infcloud {
    radicale = pkgs.radicale.override { python3 = python; };
  };

  radio-beam = callPackage ./non-by-name/radio-beam { };

  radios = callPackage ./non-by-name/radios { };

  radiotherm = callPackage ./non-by-name/radiotherm { };

  radish-bdd = callPackage ./non-by-name/radish-bdd { };

  radixtarget = callPackage ./non-by-name/radixtarget { };

  radon = callPackage ./non-by-name/radon { };

  railroad-diagrams = callPackage ./non-by-name/railroad-diagrams { };

  rainbowminer-api-client = callPackage ./non-by-name/rainbowminer-api-client { };

  raincloudy = callPackage ./non-by-name/raincloudy { };

  ramlfications = callPackage ./non-by-name/ramlfications { };

  random2 = callPackage ./non-by-name/random2 { };

  randomfiletree = callPackage ./non-by-name/randomfiletree { };

  range-typed-integers = callPackage ./non-by-name/range-typed-integers { };

  rangehttpserver = callPackage ./non-by-name/rangehttpserver { };

  rangeparser = callPackage ./non-by-name/rangeparser { };

  rank-bm25 = callPackage ./non-by-name/rank-bm25 { };

  rapidfuzz = callPackage ./non-by-name/rapidfuzz { };

  rapidfuzz-capi = callPackage ./non-by-name/rapidfuzz-capi { };

  rapidgzip = callPackage ./non-by-name/rapidgzip { inherit (pkgs) nasm; };

  rapidocr = callPackage ./non-by-name/rapidocr { };

  rapidocr-onnxruntime = callPackage ./non-by-name/rapidocr-onnxruntime { };

  rapidyaml = callPackage ./non-by-name/rapidyaml { };

  rapt-ble = callPackage ./non-by-name/rapt-ble { };

  rarfile = callPackage ./non-by-name/rarfile { inherit (pkgs) libarchive unrar; };

  raspyrfm-client = callPackage ./non-by-name/raspyrfm-client { };

  rasterio = callPackage ./non-by-name/rasterio {
    gdal-cpp = pkgs.gdal;
  };

  ratarmount = callPackage ./non-by-name/ratarmount { };

  ratarmountcore = callPackage ./non-by-name/ratarmountcore { inherit (pkgs) zstd; };

  ratelim = callPackage ./non-by-name/ratelim { };

  ratelimit = callPackage ./non-by-name/ratelimit { };

  raven = callPackage ./non-by-name/raven { };

  rawkit = callPackage ./non-by-name/rawkit { };

  rawpy = callPackage ./non-by-name/rawpy { };

  ray = callPackage ./non-by-name/ray { };

  raygeo = callPackage ./non-by-name/raygeo { };

  raylib = callPackage ./non-by-name/raylib { inherit (pkgs) raylib; };

  razdel = callPackage ./non-by-name/razdel { };

  rbtools = callPackage ./non-by-name/rbtools { };

  rchitect = callPackage ./non-by-name/rchitect { };

  rclone-python = callPackage ./non-by-name/rclone-python { };

  rcon = callPackage ./non-by-name/rcon { };

  rcssmin = callPackage ./non-by-name/rcssmin { };

  rctclient = callPackage ./non-by-name/rctclient { };

  rdbtools = callPackage ./non-by-name/rdbtools { };

  rdflib = callPackage ./non-by-name/rdflib { };

  rdkit = callPackage ./non-by-name/rdkit {
    boost = pkgs.boost.override {
      enablePython = true;
      inherit python;
    };
  };

  rds2py = callPackage ./non-by-name/rds2py { };

  re-assert = callPackage ./non-by-name/re-assert { };

  reactionmenu = callPackage ./non-by-name/reactionmenu { };

  reactivex = callPackage ./non-by-name/reactivex { };

  readabilipy = callPackage ./non-by-name/readabilipy { };

  readability-lxml = callPackage ./non-by-name/readability-lxml { };

  readchar = callPackage ./non-by-name/readchar { };

  readerwriterlock = callPackage ./non-by-name/readerwriterlock { };

  readlike = callPackage ./non-by-name/readlike { };

  readmdict = callPackage ./non-by-name/readmdict { };

  readme = callPackage ./non-by-name/readme { };

  readme-renderer = callPackage ./non-by-name/readme-renderer { };

  real-ladybug = callPackage ./non-by-name/real-ladybug { };

  realtime = callPackage ./non-by-name/realtime { };

  rebiber = callPackage ./non-by-name/rebiber { };

  rebulk = callPackage ./non-by-name/rebulk { };

  recipe-scrapers = callPackage ./non-by-name/recipe-scrapers { };

  recline = callPackage ./non-by-name/recline { };

  recoll = toPythonModule (pkgs.recoll.override { python3Packages = self; });

  recommonmark = callPackage ./non-by-name/recommonmark { };

  reconplogger = callPackage ./non-by-name/reconplogger { };

  recordlinkage = callPackage ./non-by-name/recordlinkage { };

  rectangle-packer = callPackage ./non-by-name/rectangle-packer { };

  rectpack = callPackage ./non-by-name/rectpack { };

  recurring-ical-events = callPackage ./non-by-name/recurring-ical-events { };

  recursive-pth-loader = toPythonModule (callPackage ./non-by-name/recursive-pth-loader { });

  recursivenodes = callPackage ./non-by-name/recursivenodes { };

  red-black-tree-mod = callPackage ./non-by-name/red-black-tree-mod { };

  redbaron = callPackage ./non-by-name/redbaron { };

  redgtech-api = callPackage ./non-by-name/redgtech-api { };

  redis = callPackage ./non-by-name/redis { };

  redis-om = callPackage ./non-by-name/redis-om { };

  redisvl = callPackage ./non-by-name/redisvl { };

  redshift-connector = callPackage ./non-by-name/redshift-connector { };

  reedsolo = callPackage ./non-by-name/reedsolo { };

  referencing = callPackage ./non-by-name/referencing { };

  refery = callPackage ./non-by-name/refery { };

  refgen-detector = callPackage ./non-by-name/refgen-detector { };

  reflex = callPackage ./non-by-name/reflex { };

  reflex-chakra = callPackage ./non-by-name/reflex-chakra { };

  inherit (reflex.subPkgs) reflex-hosting-cli;

  reflink = callPackage ./non-by-name/reflink { };

  reflink-copy = callPackage ./non-by-name/reflink-copy { };

  refoss-ha = callPackage ./non-by-name/refoss-ha { };

  regenmaschine = callPackage ./non-by-name/regenmaschine { };

  regex = callPackage ./non-by-name/regex { };

  regional = callPackage ./non-by-name/regional { };

  regress = callPackage ./non-by-name/regress { };

  reikna = callPackage ./non-by-name/reikna { };

  related = callPackage ./non-by-name/related { };

  relatorio = callPackage ./non-by-name/relatorio { };

  releases = callPackage ./non-by-name/releases { };

  remarshal = callPackage ./non-by-name/remarshal { };

  rembg = callPackage ./non-by-name/rembg { };

  remctl = callPackage ./non-by-name/remctl { remctl-c = pkgs.remctl; };

  remi = callPackage ./non-by-name/remi { };

  remote-pdb = callPackage ./non-by-name/remote-pdb { };

  remotezip = callPackage ./non-by-name/remotezip { };

  remotezip2 = callPackage ./non-by-name/remotezip2 { };

  renault-api = callPackage ./non-by-name/renault-api { };

  rencode = callPackage ./non-by-name/rencode { };

  rendercanvas = callPackage ./non-by-name/rendercanvas { };

  rendercv-fonts = callPackage ./non-by-name/rendercv-fonts { };

  renderers = callPackage ./non-by-name/renderers { };

  reno = callPackage ./non-by-name/reno { };

  renson-endura-delta = callPackage ./non-by-name/renson-endura-delta { };

  reolink = callPackage ./non-by-name/reolink { };

  reolink-aio = callPackage ./non-by-name/reolink-aio { };

  reorder-python-imports = callPackage ./non-by-name/reorder-python-imports { };

  reparser = callPackage ./non-by-name/reparser { };

  repath = callPackage ./non-by-name/repath { };

  repeated-test = callPackage ./non-by-name/repeated-test { };

  repl-python-wakatime = callPackage ./non-by-name/repl-python-wakatime { };

  repl-session = callPackage ./non-by-name/repl-session { };

  replicate = callPackage ./non-by-name/replicate { };

  reportlab = callPackage ./non-by-name/reportlab { };

  reportlab-qrcode = callPackage ./non-by-name/reportlab-qrcode { };

  repoze-lru = callPackage ./non-by-name/repoze-lru { };

  repoze-sphinx-autointerface = callPackage ./non-by-name/repoze-sphinx-autointerface { };

  repoze-who = callPackage ./non-by-name/repoze-who { };

  reprint = callPackage ./non-by-name/reprint { };

  reproject = callPackage ./non-by-name/reproject { };

  reprshed = callPackage ./non-by-name/reprshed { };

  reptor = callPackage ./non-by-name/reptor { };

  reqif = callPackage ./non-by-name/reqif { };

  requests = callPackage ./non-by-name/requests { };

  requests-aws4auth = callPackage ./non-by-name/requests-aws4auth { };

  requests-cache = callPackage ./non-by-name/requests-cache { };

  requests-credssp = callPackage ./non-by-name/requests-credssp { };

  requests-download = callPackage ./non-by-name/requests-download { };

  requests-file = callPackage ./non-by-name/requests-file { };

  requests-futures = callPackage ./non-by-name/requests-futures { };

  requests-gssapi = callPackage ./non-by-name/requests-gssapi { };

  requests-hardened = callPackage ./non-by-name/requests-hardened { };

  requests-hawk = callPackage ./non-by-name/requests-hawk { };

  requests-http-message-signatures = callPackage ./non-by-name/requests-http-message-signatures { };

  requests-http-signature = callPackage ./non-by-name/requests-http-signature { };

  requests-kerberos = callPackage ./non-by-name/requests-kerberos { };

  requests-mock = callPackage ./non-by-name/requests-mock { };

  requests-ntlm = callPackage ./non-by-name/requests-ntlm { };

  requests-oauthlib = callPackage ./non-by-name/requests-oauthlib { };

  requests-pkcs12 = callPackage ./non-by-name/requests-pkcs12 { };

  requests-random-user-agent = callPackage ./non-by-name/requests-random-user-agent { };

  requests-ratelimiter = callPackage ./non-by-name/requests-ratelimiter { };

  requests-sse = callPackage ./non-by-name/requests-sse { };

  requests-toolbelt = callPackage ./non-by-name/requests-toolbelt { };

  requests-unixsocket = callPackage ./non-by-name/requests-unixsocket { };

  requests-unixsocket2 = callPackage ./non-by-name/requests-unixsocket2 { };

  requests-wsgi-adapter = callPackage ./non-by-name/requests-wsgi-adapter { };

  requestsexceptions = callPackage ./non-by-name/requestsexceptions { };

  requirements-detector = callPackage ./non-by-name/requirements-detector { };

  requirements-parser = callPackage ./non-by-name/requirements-parser { };

  reretry = callPackage ./non-by-name/reretry { };

  rerun-notebook = callPackage ./non-by-name/rerun-notebook { };

  rerun-sdk = callPackage ./non-by-name/rerun-sdk { };

  resampy = callPackage ./non-by-name/resampy { };

  resend = callPackage ./non-by-name/resend { };

  resize-image = callPackage ./non-by-name/resize-image { };

  resize-right = callPackage ./non-by-name/resize-right { };

  resolvelib = callPackage ./non-by-name/resolvelib { };

  responses = callPackage ./non-by-name/responses { };

  respx = callPackage ./non-by-name/respx { };

  restfly = callPackage ./non-by-name/restfly { };

  restrictedpython = callPackage ./non-by-name/restrictedpython { };

  restructuredtext-lint = callPackage ./non-by-name/restructuredtext-lint { };

  restview = callPackage ./non-by-name/restview { };

  result = callPackage ./non-by-name/result { };

  resvg-py = callPackage ./non-by-name/resvg-py { };

  rethinkdb = callPackage ./non-by-name/rethinkdb { };

  retina-face = callPackage ./non-by-name/retina-face { };

  retry = callPackage ./non-by-name/retry { };

  retry-decorator = callPackage ./non-by-name/retry-decorator { };

  retry2 = callPackage ./non-by-name/retry2 { };

  retryhttp = callPackage ./non-by-name/retryhttp { };

  retrying = callPackage ./non-by-name/retrying { };

  returns = callPackage ./non-by-name/returns { };

  reusables = callPackage ./non-by-name/reusables { };

  reuse = callPackage ./non-by-name/reuse { };

  reverse-geocode = callPackage ./non-by-name/reverse-geocode { };

  rf-protocols = callPackage ./non-by-name/rf-protocols { };

  rfc3161-client = callPackage ./non-by-name/rfc3161-client { };

  rfc3339 = callPackage ./non-by-name/rfc3339 { };

  rfc3339-validator = callPackage ./non-by-name/rfc3339-validator { };

  rfc3986 = callPackage ./non-by-name/rfc3986 { };

  rfc3986-validator = callPackage ./non-by-name/rfc3986-validator { };

  rfc3987 = callPackage ./non-by-name/rfc3987 { };

  rfc3987-syntax = callPackage ./non-by-name/rfc3987-syntax { };

  rfc6555 = callPackage ./non-by-name/rfc6555 { };

  rfc7464 = callPackage ./non-by-name/rfc7464 { };

  rfc8785 = callPackage ./non-by-name/rfc8785 { };

  rfcat = callPackage ./non-by-name/rfcat { };

  rfk101py = callPackage ./non-by-name/rfk101py { };

  rflink = callPackage ./non-by-name/rflink { };

  rgbxy = callPackage ./non-by-name/rgbxy { };

  rgpio = toPythonModule (
    pkgs.lgpio.override {
      inherit buildPythonPackage;
      pyProject = "PY_RGPIO";
    }
  );

  rich = callPackage ./non-by-name/rich { };

  rich-argparse = callPackage ./non-by-name/rich-argparse { };

  rich-argparse-plus = callPackage ./non-by-name/rich-argparse-plus { };

  rich-click = callPackage ./non-by-name/rich-click { };

  rich-pixels = callPackage ./non-by-name/rich-pixels { };

  rich-rst = callPackage ./non-by-name/rich-rst { };

  rich-tables = callPackage ./non-by-name/rich-tables { };

  rich-theme-manager = callPackage ./non-by-name/rich-theme-manager { };

  rich-toolkit = callPackage ./non-by-name/rich-toolkit { };

  riden = callPackage ./non-by-name/riden { };

  rigour = callPackage ./non-by-name/rigour { };

  ring-doorbell = callPackage ./non-by-name/ring-doorbell { };

  rio-stac = callPackage ./non-by-name/rio-stac { };

  rio-tiler = callPackage ./non-by-name/rio-tiler { };

  rioxarray = callPackage ./non-by-name/rioxarray { };

  ripe-atlas-cousteau = callPackage ./non-by-name/ripe-atlas-cousteau { };

  ripe-atlas-sagan = callPackage ./non-by-name/ripe-atlas-sagan { };

  riprova = callPackage ./non-by-name/riprova { };

  ripser = callPackage ./non-by-name/ripser { };

  riscof = callPackage ./non-by-name/riscof { };

  riscv-config = callPackage ./non-by-name/riscv-config { };

  riscv-isac = callPackage ./non-by-name/riscv-isac { };

  riscv-model = callPackage ./non-by-name/riscv-model { };

  ritassist = callPackage ./non-by-name/ritassist { };

  ritualsgenie = callPackage ./non-by-name/ritualsgenie { };

  rivet = toPythonModule (pkgs.rivet.override { python3 = python; });

  rjpl = callPackage ./non-by-name/rjpl { };

  rjsmin = callPackage ./non-by-name/rjsmin { };

  rkm-codes = callPackage ./non-by-name/rkm-codes { };

  rlax = callPackage ./non-by-name/rlax { };

  rlcard = callPackage ./non-by-name/rlcard { };

  rlp = callPackage ./non-by-name/rlp { };

  rmcl = callPackage ./non-by-name/rmcl { };

  rmrl = callPackage ./non-by-name/rmrl { };

  rmscene = callPackage ./non-by-name/rmscene { };

  rmsd = callPackage ./non-by-name/rmsd { };

  rnc2rng = callPackage ./non-by-name/rnc2rng { };

  rnginline = callPackage ./non-by-name/rnginline { };

  rns = callPackage ./non-by-name/rns { };

  roadlib = callPackage ./non-by-name/roadlib { };

  roadrecon = callPackage ./non-by-name/roadrecon { };

  roadtools = callPackage ./non-by-name/roadtools { };

  roadtx = callPackage ./non-by-name/roadtx { };

  robomachine = callPackage ./non-by-name/robomachine { };

  robot-descriptions = callPackage ./non-by-name/robot-descriptions { };

  robot-detection = callPackage ./non-by-name/robot-detection { };

  robotframework = callPackage ./non-by-name/robotframework { };

  robotframework-assertion-engine = callPackage ./non-by-name/robotframework-assertion-engine { };

  robotframework-databaselibrary = callPackage ./non-by-name/robotframework-databaselibrary { };

  robotframework-excellib = callPackage ./non-by-name/robotframework-excellib { };

  robotframework-pythonlibcore = callPackage ./non-by-name/robotframework-pythonlibcore { };

  robotframework-requests = callPackage ./non-by-name/robotframework-requests { };

  robotframework-selenium2library = callPackage ./non-by-name/robotframework-selenium2library { };

  robotframework-seleniumlibrary = callPackage ./non-by-name/robotframework-seleniumlibrary { };

  robotframework-sshlibrary = callPackage ./non-by-name/robotframework-sshlibrary { };

  robotstatuschecker = callPackage ./non-by-name/robotstatuschecker { };

  robotsuite = callPackage ./non-by-name/robotsuite { };

  rocket-errbot = callPackage ./non-by-name/rocket-errbot { };

  rocketchat-api = callPackage ./non-by-name/rocketchat-api { };

  rocksdict = callPackage ./non-by-name/rocksdict { inherit (pkgs) zstd; };

  roku = callPackage ./non-by-name/roku { };

  rokuecp = callPackage ./non-by-name/rokuecp { };

  rollbar = callPackage ./non-by-name/rollbar { };

  roma = callPackage ./non-by-name/roma { };

  roman = callPackage ./non-by-name/roman { };

  roman-numerals = callPackage ./non-by-name/roman-numerals { };

  romy = callPackage ./non-by-name/romy { };

  roombapy = callPackage ./non-by-name/roombapy { };

  roonapi = callPackage ./non-by-name/roonapi { };

  root = callPackage ./non-by-name/root {
    inherit (pkgs) root;
  };

  rope = callPackage ./non-by-name/rope { };

  ropgadget = callPackage ./non-by-name/ropgadget { };

  ropper = callPackage ./non-by-name/ropper { };

  rosbags = callPackage ./non-by-name/rosbags { };

  rospkg = callPackage ./non-by-name/rospkg { };

  rotary-embedding-torch = callPackage ./non-by-name/rotary-embedding-torch { };

  rouge-score = callPackage ./non-by-name/rouge-score { };

  roundtrip = callPackage ./non-by-name/roundtrip { };

  routeros-api = callPackage ./non-by-name/routeros-api { };

  routes = callPackage ./non-by-name/routes { };

  rova = callPackage ./non-by-name/rova { };

  rowan = callPackage ./non-by-name/rowan { };

  rpatool = callPackage ./non-by-name/rpatool { };

  rpcq = callPackage ./non-by-name/rpcq { };

  rpdb = callPackage ./non-by-name/rpdb { };

  rpds-py = callPackage ./non-by-name/rpds-py { };

  rpi-bad-power = callPackage ./non-by-name/rpi-bad-power { };

  rpi-gpio = callPackage ./non-by-name/rpi-gpio { };

  rpi-lgpio = callPackage ./non-by-name/rpi-lgpio { };

  rpkg = callPackage ./non-by-name/rpkg { };

  rplcd = callPackage ./non-by-name/rplcd { };

  rply = callPackage ./non-by-name/rply { };

  rpm = toPythonModule (pkgs.rpm.override { python3 = self.python; });

  rpmfile = callPackage ./non-by-name/rpmfile { };

  rpmfluff = callPackage ./non-by-name/rpmfluff { };

  rpy2 = callPackage ./non-by-name/rpy2 { };

  rpy2-rinterface = callPackage ./non-by-name/rpy2-rinterface {
    inherit (pkgs) zstd;
  };

  rpy2-robjects = callPackage ./non-by-name/rpy2-robjects { };

  rpyc = callPackage ./non-by-name/rpyc { };

  rq = callPackage ./non-by-name/rq { };

  rq-scheduler = callPackage ./non-by-name/rq-scheduler { };

  rrdtool = callPackage ./non-by-name/rrdtool { };

  rsa = callPackage ./non-by-name/rsa { };

  rsl-rl-lib = callPackage ./non-by-name/rsl-rl-lib { };

  rsskey = callPackage ./non-by-name/rsskey { };

  rst2ansi = callPackage ./non-by-name/rst2ansi { };

  rst2pdf = callPackage ./non-by-name/rst2pdf { };

  rstcheck = callPackage ./non-by-name/rstcheck { };

  rstcheck-core = callPackage ./non-by-name/rstcheck-core { };

  rstr = callPackage ./non-by-name/rstr { };

  rtb-data = callPackage ./non-by-name/rtb-data { };

  rtf-tokenize = callPackage ./non-by-name/rtf-tokenize { };

  rtfde = callPackage ./non-by-name/rtfde { };

  rtfunicode = callPackage ./non-by-name/rtfunicode { };

  rtmapi = callPackage ./non-by-name/rtmapi { };

  rtmidi-python = callPackage ./non-by-name/rtmidi-python { };

  rtmixer = callPackage ./non-by-name/rtmixer { };

  rtoml = callPackage ./non-by-name/rtoml { };

  rtp = callPackage ./non-by-name/rtp { };

  rtree = callPackage ./non-by-name/rtree { inherit (pkgs) libspatialindex; };

  rtslib-fb = callPackage ./non-by-name/rtslib-fb { };

  ruamel-base = callPackage ./non-by-name/ruamel-base { };

  ruamel-yaml = callPackage ./non-by-name/ruamel-yaml { };

  ruamel-yaml-clib = callPackage ./non-by-name/ruamel-yaml-clib { };

  ruamel-yaml-string = callPackage ./non-by-name/ruamel-yaml-string { };

  rubicon-objc = callPackage ./non-by-name/rubicon-objc { };

  rubymarshal = callPackage ./non-by-name/rubymarshal { };

  rucio = callPackage ./non-by-name/rucio { };

  ruff = callPackage ./non-by-name/ruff { inherit (pkgs) ruff; };

  ruff-api = callPackage ./non-by-name/ruff-api { };

  ruff-format = callPackage ./non-by-name/ruff-format { };

  ruida-pa = callPackage ./non-by-name/ruida-pa { };

  rules = callPackage ./non-by-name/rules { };

  rumps = callPackage ./non-by-name/rumps { };

  runs = callPackage ./non-by-name/runs { };

  runstats = callPackage ./non-by-name/runstats { };

  runtype = callPackage ./non-by-name/runtype { };

  russound = callPackage ./non-by-name/russound { };

  rustworkx = callPackage ./non-by-name/rustworkx { };

  ruuvitag-ble = callPackage ./non-by-name/ruuvitag-ble { };

  ruyaml = callPackage ./non-by-name/ruyaml { };

  rx = callPackage ./non-by-name/rx { };

  rxv = callPackage ./non-by-name/rxv { };

  ryd-client = callPackage ./non-by-name/ryd-client { };

  rzpipe = callPackage ./non-by-name/rzpipe { };

  s2clientprotocol = callPackage ./non-by-name/s2clientprotocol { };

  s3-credentials = callPackage ./non-by-name/s3-credentials { };

  s3fs = callPackage ./non-by-name/s3fs { };

  s3torchconnectorclient = callPackage ./non-by-name/s3torchconnectorclient { };

  s3transfer = callPackage ./non-by-name/s3transfer { };

  sabctools = callPackage ./non-by-name/sabctools { };

  sabyenc3 = callPackage ./non-by-name/sabyenc3 { };

  sacn = callPackage ./non-by-name/sacn { };

  sacrebleu = callPackage ./non-by-name/sacrebleu { };

  sacremoses = callPackage ./non-by-name/sacremoses { };

  safe-pysha3 = callPackage ./non-by-name/safe-pysha3 { };

  safehttpx = callPackage ./non-by-name/safehttpx { };

  safeio = callPackage ./non-by-name/safeio { };

  safelz4 = callPackage ./non-by-name/safelz4 { };

  safetensors = callPackage ./non-by-name/safetensors { };

  safety = callPackage ./non-by-name/safety { };

  safety-schemas = callPackage ./non-by-name/safety-schemas { };

  sagemaker = callPackage ./non-by-name/sagemaker { };

  sagemaker-core = callPackage ./non-by-name/sagemaker-core { };

  sagemaker-mlflow = callPackage ./non-by-name/sagemaker-mlflow { };

  saiph = callPackage ./non-by-name/saiph { };

  salib = callPackage ./non-by-name/salib { };

  salmon-mail = callPackage ./non-by-name/salmon-mail { };

  sam2 = callPackage ./non-by-name/sam2 { };

  samarium = callPackage ./non-by-name/samarium { };

  samplerate = callPackage ./non-by-name/samplerate { inherit (pkgs) libsamplerate; };

  samplerate-ledfx = callPackage ./non-by-name/samplerate-ledfx {
    inherit (pkgs) libsamplerate;
  };

  samsung-exlink = callPackage ./non-by-name/samsung-exlink { };

  samsungctl = callPackage ./non-by-name/samsungctl { };

  samsungtvws = callPackage ./non-by-name/samsungtvws { };

  sane = callPackage ./non-by-name/sane { inherit (pkgs) sane-backends; };

  saneyaml = callPackage ./non-by-name/saneyaml { };

  sanic = callPackage ./non-by-name/sanic {
    # Don't pass any `sanic` to avoid dependency loops.  `sanic-testing`
    # has special logic to disable tests when this is the case.
    sanic-testing = self.sanic-testing.override { sanic = null; };
  };

  sanic-auth = callPackage ./non-by-name/sanic-auth { };

  sanic-cors = callPackage ./non-by-name/sanic-cors { };

  sanic-ext = callPackage ./non-by-name/sanic-ext { };

  sanic-routing = callPackage ./non-by-name/sanic-routing { };

  sanic-testing = callPackage ./non-by-name/sanic-testing { };

  sanix = callPackage ./non-by-name/sanix { };

  sansio-multipart = callPackage ./non-by-name/sansio-multipart { };

  sarge = callPackage ./non-by-name/sarge { };

  sarif-om = callPackage ./non-by-name/sarif-om { };

  sarif-tools = callPackage ./non-by-name/sarif-tools { };

  sasdata = callPackage ./non-by-name/sasdata { };

  sasmodels = callPackage ./non-by-name/sasmodels { };

  sat-tmp = callPackage ./non-by-name/sat-tmp { };

  satel-integra = callPackage ./non-by-name/satel-integra { };

  saxonche = callPackage ./non-by-name/saxonche { };

  sbom2dot = callPackage ./non-by-name/sbom2dot { };

  sbom4files = callPackage ./non-by-name/sbom4files { };

  scalar-fastapi = callPackage ./non-by-name/scalar-fastapi { };

  scalecodec = callPackage ./non-by-name/scalecodec { };

  scalene = callPackage ./non-by-name/scalene { };

  scales = callPackage ./non-by-name/scales { };

  scaleway = callPackage ./non-by-name/scaleway { };

  scaleway-core = callPackage ./non-by-name/scaleway-core { };

  scalib = callPackage ./non-by-name/scalib { };

  scancode-toolkit = callPackage ./non-by-name/scancode-toolkit { };

  scanpy = callPackage ./non-by-name/scanpy { };

  scantree = callPackage ./non-by-name/scantree { };

  scapy = callPackage ./non-by-name/scapy {
    inherit (pkgs) libpcap; # Avoid confusion with python package of the same name
  };

  scenedetect = callPackage ./non-by-name/scenedetect { };

  schedula = callPackage ./non-by-name/schedula { };

  schedule = callPackage ./non-by-name/schedule { };

  scheduler = callPackage ./non-by-name/scheduler { };

  schema = callPackage ./non-by-name/schema { };

  schema-salad = callPackage ./non-by-name/schema-salad { };

  schemdraw = callPackage ./non-by-name/schemdraw { };

  schiene = callPackage ./non-by-name/schiene { };

  scholarly = callPackage ./non-by-name/scholarly { };

  schwifty = callPackage ./non-by-name/schwifty { };

  scienceplots = callPackage ./non-by-name/scienceplots { };

  sciform = callPackage ./non-by-name/sciform { };

  scikit-base = callPackage ./non-by-name/scikit-base { };

  scikit-bio = callPackage ./non-by-name/scikit-bio { };

  scikit-build = callPackage ./non-by-name/scikit-build { };

  scikit-build-core = callPackage ./non-by-name/scikit-build-core { };

  scikit-fmm = callPackage ./non-by-name/scikit-fmm { };

  scikit-fuzzy = callPackage ./non-by-name/scikit-fuzzy { };

  scikit-hep-testdata = callPackage ./non-by-name/scikit-hep-testdata { };

  scikit-image = callPackage ./non-by-name/scikit-image { };

  scikit-learn = callPackage ./non-by-name/scikit-learn { };

  scikit-learn-extra = callPackage ./non-by-name/scikit-learn-extra { };

  scikit-misc = callPackage ./non-by-name/scikit-misc { };

  scikit-posthocs = callPackage ./non-by-name/scikit-posthocs { };

  scikit-rf = callPackage ./non-by-name/scikit-rf { };

  scikit-survival = callPackage ./non-by-name/scikit-survival { };

  scikit-tda = callPackage ./non-by-name/scikit-tda { };

  scikits-odes = callPackage ./non-by-name/scikits-odes { };

  scikits-odes-core = callPackage ./non-by-name/scikits-odes-core { };

  scikits-odes-daepack = callPackage ./non-by-name/scikits-odes-daepack { };

  scikits-odes-sundials = callPackage ./non-by-name/scikits-odes-sundials { };

  sciline = callPackage ./non-by-name/sciline { };

  scim2-client = callPackage ./non-by-name/scim2-client { };

  scim2-filter-parser = callPackage ./non-by-name/scim2-filter-parser { };

  scim2-models = callPackage ./non-by-name/scim2-models { };

  scim2-server = callPackage ./non-by-name/scim2-server { };

  scim2-tester = callPackage ./non-by-name/scim2-tester { };

  scipp = callPackage ./non-by-name/scipp { };

  scippneutron = callPackage ./non-by-name/scippneutron { };

  scippnexus = callPackage ./non-by-name/scippnexus { };

  scipy = callPackage ./non-by-name/scipy { };

  scipy-stubs = callPackage ./non-by-name/scipy-stubs { };

  scmrepo = callPackage ./non-by-name/scmrepo { };

  scooby = callPackage ./non-by-name/scooby { };

  scour = callPackage ./non-by-name/scour { };

  scp = callPackage ./non-by-name/scp { };

  scramp = callPackage ./non-by-name/scramp { };

  scrap-engine = callPackage ./non-by-name/scrap-engine { };

  scrapy = callPackage ./non-by-name/scrapy { };

  scrapy-deltafetch = callPackage ./non-by-name/scrapy-deltafetch { };

  scrapy-splash = callPackage ./non-by-name/scrapy-splash { };

  screed = callPackage ./non-by-name/screed { };

  screeninfo = callPackage ./non-by-name/screeninfo { };

  screenlogicpy = callPackage ./non-by-name/screenlogicpy { };

  scripttest = callPackage ./non-by-name/scripttest { };

  scrypt = callPackage ./non-by-name/scrypt { };

  scs = callPackage ./non-by-name/scs { };

  scspell = callPackage ./non-by-name/scspell { };

  scverse-misc = callPackage ./non-by-name/scverse-misc { };

  sdbus = callPackage ./non-by-name/sdbus { };

  sdbus-networkmanager = callPackage ./non-by-name/sdbus-networkmanager { };

  sdds = callPackage ./non-by-name/sdds { };

  sdflit = callPackage ./non-by-name/sdflit { };

  sdjson = callPackage ./non-by-name/sdjson { };

  sdkmanager = callPackage ./non-by-name/sdkmanager { };

  sdnotify = callPackage ./non-by-name/sdnotify { };

  seaborn = callPackage ./non-by-name/seaborn { };

  seabreeze = callPackage ./non-by-name/seabreeze { };

  seasonal = callPackage ./non-by-name/seasonal { };

  seatconnect = callPackage ./non-by-name/seatconnect { };

  sebaubuntu-libs = callPackage ./non-by-name/sebaubuntu-libs { };

  seccomp = callPackage ./non-by-name/seccomp { };

  secp256k1 = callPackage ./non-by-name/secp256k1 { inherit (pkgs) secp256k1; };

  secretstorage = callPackage ./non-by-name/secretstorage { };

  sectools = callPackage ./non-by-name/sectools { };

  sectxt = callPackage ./non-by-name/sectxt { };

  secure = callPackage ./non-by-name/secure { };

  securestring = callPackage ./non-by-name/securestring { };

  securesystemslib = callPackage ./non-by-name/securesystemslib { };

  securetar = callPackage ./non-by-name/securetar { };

  securityreporter = callPackage ./non-by-name/securityreporter { };

  seedir = callPackage ./non-by-name/seedir { };

  seekpath = callPackage ./non-by-name/seekpath { };

  segments = callPackage ./non-by-name/segments { };

  segno = callPackage ./non-by-name/segno { };

  segyio = callPackage ./non-by-name/segyio { inherit (pkgs) cmake ninja; };

  selectolax = callPackage ./non-by-name/selectolax { };

  selenium = callPackage ./non-by-name/selenium { };

  selenium-wire = callPackage ./non-by-name/selenium-wire { };

  selenium-wire-roadtx = callPackage ./non-by-name/selenium-wire-roadtx { };

  selfies = callPackage ./non-by-name/selfies { };

  semantic-version = callPackage ./non-by-name/semantic-version { };

  semaphore-bot = callPackage ./non-by-name/semaphore-bot { };

  semchunk = callPackage ./non-by-name/semchunk { };

  semgrep = callPackage ./non-by-name/semgrep {
    semgrep-core = callPackage ./non-by-name/semgrep/semgrep-core.nix { };
  };

  semver = callPackage ./non-by-name/semver { };

  send2trash = callPackage ./non-by-name/send2trash { };

  sendgrid = callPackage ./non-by-name/sendgrid { };

  sendspin = callPackage ./non-by-name/sendspin { };

  senf = callPackage ./non-by-name/senf { };

  sensai-utils = callPackage ./non-by-name/sensai-utils { };

  sense-energy = callPackage ./non-by-name/sense-energy { };

  sensecap-lorawan = callPackage ./non-by-name/sensecap-lorawan { };

  sensirion-ble = callPackage ./non-by-name/sensirion-ble { };

  sensor-state-data = callPackage ./non-by-name/sensor-state-data { };

  sensorpro-ble = callPackage ./non-by-name/sensorpro-ble { };

  sensorpush-api = callPackage ./non-by-name/sensorpush-api { };

  sensorpush-ble = callPackage ./non-by-name/sensorpush-ble { };

  sensorpush-ha = callPackage ./non-by-name/sensorpush-ha { };

  sensoterra = callPackage ./non-by-name/sensoterra { };

  sentence-splitter = callPackage ./non-by-name/sentence-splitter { };

  sentence-stream = callPackage ./non-by-name/sentence-stream { };

  sentence-transformers = callPackage ./non-by-name/sentence-transformers { };

  sentencepiece = callPackage ./non-by-name/sentencepiece {
    inherit (pkgs) sentencepiece;
  };

  sentinel = callPackage ./non-by-name/sentinel { };

  sentinels = callPackage ./non-by-name/sentinels { };

  sentry-sdk = callPackage ./non-by-name/sentry-sdk/default.nix { };

  sepaxml = callPackage ./non-by-name/sepaxml { };

  seqdiag = callPackage ./non-by-name/seqdiag { };

  seqeval = callPackage ./non-by-name/seqeval { };

  serialio = callPackage ./non-by-name/serialio { };

  serializable = callPackage ./non-by-name/serializable { };

  serialx = callPackage ./non-by-name/serialx { };

  serpent = callPackage ./non-by-name/serpent { };

  serpy = callPackage ./non-by-name/serpy { };

  servefile = callPackage ./non-by-name/servefile { };

  serverfiles = callPackage ./non-by-name/serverfiles { };

  serverlessrepo = callPackage ./non-by-name/serverlessrepo { };

  servestatic = callPackage ./non-by-name/servestatic { };

  service-identity = callPackage ./non-by-name/service-identity { };

  session-info2 = callPackage ./non-by-name/session-info2 { };

  setproctitle = callPackage ./non-by-name/setproctitle { };

  setupmeta = callPackage ./non-by-name/setupmeta { };

  setuptools-changelog-shortener = callPackage ./non-by-name/setuptools-changelog-shortener { };

  setuptools-declarative-requirements =
    callPackage ./non-by-name/setuptools-declarative-requirements
      { };

  setuptools-dso = callPackage ./non-by-name/setuptools-dso { };

  setuptools-generate = callPackage ./non-by-name/setuptools-generate { };

  setuptools-gettext = callPackage ./non-by-name/setuptools-gettext { };

  setuptools-git = callPackage ./non-by-name/setuptools-git { };

  setuptools-git-versioning = callPackage ./non-by-name/setuptools-git-versioning { };

  setuptools-lint = callPackage ./non-by-name/setuptools-lint { };

  setuptools-odoo = callPackage ./non-by-name/setuptools-odoo { };

  setuptools-rust = callPackage ./non-by-name/setuptools-rust { };

  setuptools-scm = callPackage ./non-by-name/setuptools-scm { };

  setuptools-scm-git-archive = callPackage ./non-by-name/setuptools-scm-git-archive { };

  setuptools-trial = callPackage ./non-by-name/setuptools-trial { };

  sev-snp-measure = callPackage ./non-by-name/sev-snp-measure { };

  seventeentrack = callPackage ./non-by-name/seventeentrack { };

  sexpdata = callPackage ./non-by-name/sexpdata { };

  sfepy = callPackage ./non-by-name/sfepy { };

  sfrbox-api = callPackage ./non-by-name/sfrbox-api { };

  sgmllib3k = callPackage ./non-by-name/sgmllib3k { };

  sgp4 = callPackage ./non-by-name/sgp4 { };

  sh = callPackage ./non-by-name/sh { };

  shacl2code = callPackage ./non-by-name/shacl2code { };

  shamir-mnemonic = callPackage ./non-by-name/shamir-mnemonic { };

  shap = callPackage ./non-by-name/shap { };

  shapely = callPackage ./non-by-name/shapely { };

  shaperglot = callPackage ./non-by-name/shaperglot { };

  shared = callPackage ./non-by-name/shared { };

  sharedmem = callPackage ./non-by-name/sharedmem { };

  sharkiq = callPackage ./non-by-name/sharkiq { };

  sharp-aquos-rc = callPackage ./non-by-name/sharp-aquos-rc { };

  shazamio = callPackage ./non-by-name/shazamio { };

  shellescape = callPackage ./non-by-name/shellescape { };

  shellingham = callPackage ./non-by-name/shellingham { };

  shelljob = callPackage ./non-by-name/shelljob { };

  sherpa-onnx = callPackage ./non-by-name/sherpa-onnx {
    sherpa-onnx = pkgs.sherpa-onnx.override {
      python3Packages = self;
      pythonSupport = true;
    };
  };

  shiboken2 = toPythonModule (
    callPackage ./non-by-name/shiboken2 { inherit (pkgs) cmake llvmPackages qt5; }
  );

  shiboken6 = toPythonModule (
    callPackage ./non-by-name/shiboken6 { inherit (pkgs) cmake llvmPackages; }
  );

  shiboken6-generator = toPythonModule (
    callPackage ./non-by-name/shiboken6-generator { inherit (pkgs) cmake llvmPackages; }
  );

  shimmy = callPackage ./non-by-name/shimmy { };

  shiny = callPackage ./non-by-name/shiny { };

  shinychat = callPackage ./non-by-name/shinychat { };

  shippinglabel = callPackage ./non-by-name/shippinglabel { };

  shiv = callPackage ./non-by-name/shiv { };

  shlib = callPackage ./non-by-name/shlib { };

  shodan = callPackage ./non-by-name/shodan { };

  shopify-spy = callPackage ./non-by-name/shopify-spy { };

  shortuuid = callPackage ./non-by-name/shortuuid { };

  should-dsl = callPackage ./non-by-name/should-dsl { };

  show-in-file-manager = callPackage ./non-by-name/show-in-file-manager { };

  shtab = callPackage ./non-by-name/shtab { };

  shutilwhich = callPackage ./non-by-name/shutilwhich { };

  sievelib = callPackage ./non-by-name/sievelib { };

  sigima = callPackage ./non-by-name/sigima { };

  sigimax = callPackage ./non-by-name/sigimax { };

  signalrcore = callPackage ./non-by-name/signalrcore { };

  signalslot = callPackage ./non-by-name/signalslot { };

  signedjson = callPackage ./non-by-name/signedjson { };

  signify = callPackage ./non-by-name/signify { };

  signxml = callPackage ./non-by-name/signxml { };

  sigparse = callPackage ./non-by-name/sigparse { };

  sigrok = callPackage ./non-by-name/sigrok { };

  sigstore = callPackage ./non-by-name/sigstore { };

  sigstore-models = callPackage ./non-by-name/sigstore-models { };

  sigstore-protobuf-specs = callPackage ./non-by-name/sigstore-protobuf-specs { };

  sigstore-rekor-types = callPackage ./non-by-name/sigstore-rekor-types { };

  sigtools = callPackage ./non-by-name/sigtools { };

  silabs-ble-ota = callPackage ./non-by-name/silabs-ble-ota { };

  silero-vad = callPackage ./non-by-name/silero-vad { };

  silver-platter = callPackage ./non-by-name/silver-platter { };

  simanneal = callPackage ./non-by-name/simanneal { };

  simber = callPackage ./non-by-name/simber { };

  simp-sexp = callPackage ./non-by-name/simp-sexp { };

  simpful = callPackage ./non-by-name/simpful { };

  simple-dftd3 = callPackage ../../development/libraries/science/chemistry/simple-dftd3/python.nix {
    inherit (pkgs) simple-dftd3;
  };

  simple-di = callPackage ./non-by-name/simple-di { };

  simple-parsing = callPackage ./non-by-name/simple-parsing { };

  simple-pid = callPackage ./non-by-name/simple-pid { };

  simple-rest-client = callPackage ./non-by-name/simple-rest-client { };

  simple-rlp = callPackage ./non-by-name/simple-rlp { };

  simple-salesforce = callPackage ./non-by-name/simple-salesforce { };

  simple-term-menu = callPackage ./non-by-name/simple-term-menu { };

  simple-websocket = callPackage ./non-by-name/simple-websocket { };

  simple-websocket-server = callPackage ./non-by-name/simple-websocket-server { };

  simpleaudio = callPackage ./non-by-name/simpleaudio { };

  simplebayes = callPackage ./non-by-name/simplebayes { };

  simplecosine = callPackage ./non-by-name/simplecosine { };

  simpleeval = callPackage ./non-by-name/simpleeval { };

  simplefin4py = callPackage ./non-by-name/simplefin4py { };

  simplefix = callPackage ./non-by-name/simplefix { };

  simplegeneric = callPackage ./non-by-name/simplegeneric { };

  simplehound = callPackage ./non-by-name/simplehound { };

  simpleitk = callPackage ./non-by-name/simpleitk { inherit (pkgs) itk simpleitk; };

  simplejson = callPackage ./non-by-name/simplejson { };

  simplekml = callPackage ./non-by-name/simplekml { };

  simplekv = callPackage ./non-by-name/simplekv { };

  simplemma = callPackage ./non-by-name/simplemma { };

  simplenote = callPackage ./non-by-name/simplenote { };

  simplepush = callPackage ./non-by-name/simplepush { };

  simplesat = callPackage ./non-by-name/simplesat { };

  simplesqlite = callPackage ./non-by-name/simplesqlite { };

  simplisafe-python = callPackage ./non-by-name/simplisafe-python { };

  simpy = callPackage ./non-by-name/simpy { };

  simsimd = callPackage ./non-by-name/simsimd { };

  single-source = callPackage ./non-by-name/single-source { };

  single-version = callPackage ./non-by-name/single-version { };

  siobrultech-protocols = callPackage ./non-by-name/siobrultech-protocols { };

  siosocks = callPackage ./non-by-name/siosocks { };

  sip = callPackage ./non-by-name/sip { };

  sip4 = callPackage ./non-by-name/sip/4.x.nix { };

  siphash24 = callPackage ./non-by-name/siphash24 { };

  siphashc = callPackage ./non-by-name/siphashc { };

  sipyco = callPackage ./non-by-name/sipyco { };

  sirius = toPythonModule (
    pkgs.sirius.override {
      enablePython = true;
      pythonPackages = self;
    }
  );

  sismic = callPackage ./non-by-name/sismic { };

  sisyphus-control = callPackage ./non-by-name/sisyphus-control { };

  siuba = callPackage ./non-by-name/siuba { };

  six = callPackage ./non-by-name/six { };

  sixel = callPackage ./non-by-name/sixel { };

  sixelcrop = callPackage ./non-by-name/sixelcrop { };

  sjcl = callPackage ./non-by-name/sjcl { };

  skein = callPackage ./non-by-name/skein { };

  skggm = callPackage ./non-by-name/skggm { };

  skia-pathops = callPackage ./non-by-name/skia-pathops { };

  skidl = callPackage ./non-by-name/skidl { };

  skl2onnx = callPackage ./non-by-name/skl2onnx { };

  sklearn-compat = callPackage ./non-by-name/sklearn-compat { };

  sklearn-deap = callPackage ./non-by-name/sklearn-deap { };

  sklearn2pmml = callPackage ./non-by-name/sklearn2pmml { };

  skoda-public-api = callPackage ./non-by-name/skoda-public-api { };

  skops = callPackage ./non-by-name/skops { };

  skorch = callPackage ./non-by-name/skorch { };

  skrl = callPackage ./non-by-name/skrl { };

  skybellpy = callPackage ./non-by-name/skybellpy { };

  skyboxremote = callPackage ./non-by-name/skyboxremote { };

  skyfield = callPackage ./non-by-name/skyfield { };

  skytemple-dtef = callPackage ./non-by-name/skytemple-dtef { };

  skytemple-eventserver = callPackage ./non-by-name/skytemple-eventserver { };

  skytemple-files = callPackage ./non-by-name/skytemple-files { };

  skytemple-icons = callPackage ./non-by-name/skytemple-icons { };

  skytemple-rust = callPackage ./non-by-name/skytemple-rust { };

  skytemple-ssb-debugger = callPackage ./non-by-name/skytemple-ssb-debugger { };

  skytemple-ssb-emulator = callPackage ./non-by-name/skytemple-ssb-emulator {
    inherit (pkgs) libpcap;
  };

  slack-bolt = callPackage ./non-by-name/slack-bolt { };

  slack-sdk = callPackage ./non-by-name/slack-sdk { };

  slapd = callPackage ./non-by-name/slapd { };

  sleekxmppfs = callPackage ./non-by-name/sleekxmppfs { };

  sleepyq = callPackage ./non-by-name/sleepyq { };

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

  slh-dsa = callPackage ./non-by-name/slh-dsa { };

  slicer = callPackage ./non-by-name/slicer { };

  slicerator = callPackage ./non-by-name/slicerator { };

  slip10 = callPackage ./non-by-name/slip10 { };

  slither-analyzer = callPackage ./non-by-name/slither-analyzer { };

  slixmpp = callPackage ./non-by-name/slixmpp { inherit (pkgs) gnupg; };

  slixmpp-omemo = callPackage ./non-by-name/slixmpp-omemo { };

  slob = callPackage ./non-by-name/slob { };

  slothy = callPackage ./non-by-name/slothy { };

  slovnet = callPackage ./non-by-name/slovnet { };

  slowapi = callPackage ./non-by-name/slowapi { };

  slpp = callPackage ./non-by-name/slpp { };

  sly = callPackage ./non-by-name/sly { };

  smart-meter-texas = callPackage ./non-by-name/smart-meter-texas { };

  smart-open = callPackage ./non-by-name/smart-open { };

  smarthab = callPackage ./non-by-name/smarthab { };

  smartthings-local = callPackage ./non-by-name/smartthings-local { };

  smartypants = callPackage ./non-by-name/smartypants { };

  smbprotocol = callPackage ./non-by-name/smbprotocol { };

  smbus-cffi = callPackage ./non-by-name/smbus-cffi { };

  smbus2 = callPackage ./non-by-name/smbus2 { };

  smdebug-rulesconfig = callPackage ./non-by-name/smdebug-rulesconfig { };

  smg-grpc-proto = callPackage ./non-by-name/smg-grpc-proto { };

  smg-grpc-servicer = callPackage ./non-by-name/smg-grpc-servicer { };

  smhi-pkg = callPackage ./non-by-name/smhi-pkg { };

  smllib = callPackage ./non-by-name/smllib { };

  smmap = callPackage ./non-by-name/smmap { };

  smoke-zephyr = callPackage ./non-by-name/smoke-zephyr { };

  smolagents = callPackage ./non-by-name/smolagents { };

  smp = callPackage ./non-by-name/smp { };

  smpclient = callPackage ./non-by-name/smpclient { };

  smpp-pdu = callPackage ./non-by-name/smpp-pdu { };

  smpp-twisted3 = callPackage ./non-by-name/smpp-twisted3 { };

  smpplib = callPackage ./non-by-name/smpplib { };

  smtpdfix = callPackage ./non-by-name/smtpdfix { };

  snack = toPythonModule (pkgs.newt.override { python3 = self.python; });

  snakebite = callPackage ./non-by-name/snakebite { };

  snakemake = toPythonModule (pkgs.snakemake.override { python3Packages = self; });

  snakemake-executor-plugin-cluster-generic =
    callPackage ./non-by-name/snakemake-executor-plugin-cluster-generic
      { };

  snakemake-interface-common = callPackage ./non-by-name/snakemake-interface-common { };

  snakemake-interface-executor-plugins =
    callPackage ./non-by-name/snakemake-interface-executor-plugins
      { };

  snakemake-interface-logger-plugins =
    callPackage ./non-by-name/snakemake-interface-logger-plugins
      { };

  snakemake-interface-report-plugins =
    callPackage ./non-by-name/snakemake-interface-report-plugins
      { };

  snakemake-interface-scheduler-plugins =
    callPackage ./non-by-name/snakemake-interface-scheduler-plugins
      { };

  snakemake-interface-storage-plugins =
    callPackage ./non-by-name/snakemake-interface-storage-plugins
      { };

  snakemake-logger-plugin-rich = callPackage ./non-by-name/snakemake-logger-plugin-rich { };

  snakemake-storage-plugin-fs = callPackage ./non-by-name/snakemake-storage-plugin-fs { };

  snakemake-storage-plugin-http = callPackage ./non-by-name/snakemake-storage-plugin-http { };

  snakemake-storage-plugin-s3 = callPackage ./non-by-name/snakemake-storage-plugin-s3 { };

  snakemake-storage-plugin-xrootd = callPackage ./non-by-name/snakemake-storage-plugin-xrootd { };

  snakeviz = callPackage ./non-by-name/snakeviz { };

  snapcast = callPackage ./non-by-name/snapcast { };

  snappy = callPackage ./non-by-name/snappy { };

  snappy-15-knots = callPackage ./non-by-name/snappy-15-knots { };

  snappy-manifolds = callPackage ./non-by-name/snappy-manifolds { };

  snapshot-restore-py = callPackage ./non-by-name/snapshot-restore-py { };

  snapshottest = callPackage ./non-by-name/snapshottest { };

  snaptime = callPackage ./non-by-name/snaptime { };

  sniffio = callPackage ./non-by-name/sniffio { };

  snitun = callPackage ./non-by-name/snitun { };

  snorkel = callPackage ./non-by-name/snorkel { };

  snowballstemmer = callPackage ./non-by-name/snowballstemmer { };

  snowflake-connector-python = callPackage ./non-by-name/snowflake-connector-python { };

  snowflake-core = callPackage ./non-by-name/snowflake-core { };

  snowflake-sqlalchemy = callPackage ./non-by-name/snowflake-sqlalchemy { };

  snowplow-tracker = callPackage ./non-by-name/snowplow-tracker { };

  snscrape = callPackage ./non-by-name/snscrape { };

  snuggs = callPackage ./non-by-name/snuggs { };

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

  social-auth-app-django = callPackage ./non-by-name/social-auth-app-django { };

  social-auth-core = callPackage ./non-by-name/social-auth-core { };

  socialscan = callPackage ./non-by-name/socialscan { };

  socid-extractor = callPackage ./non-by-name/socid-extractor { };

  socketio-client = callPackage ./non-by-name/socketio-client { };

  sockio = callPackage ./non-by-name/sockio { };

  sockjs = callPackage ./non-by-name/sockjs { };

  sockjs-tornado = callPackage ./non-by-name/sockjs-tornado { };

  socksio = callPackage ./non-by-name/socksio { };

  socksipy-branch = callPackage ./non-by-name/socksipy-branch { };

  soco = callPackage ./non-by-name/soco { };

  sofar-modbus = callPackage ./non-by-name/sofar-modbus { };

  softlayer = callPackage ./non-by-name/softlayer { };

  solaredge-local = callPackage ./non-by-name/solaredge-local { };

  solaredge-web = callPackage ./non-by-name/solaredge-web { };

  solaredged = callPackage ./non-by-name/solaredged { };

  solarlog-cli = callPackage ./non-by-name/solarlog-cli { };

  solarman-opendata = callPackage ./non-by-name/solarman-opendata { };

  solax = callPackage ./non-by-name/solax { };

  solc-select = callPackage ./non-by-name/solc-select { };

  solders = callPackage ./non-by-name/solders { };

  solidpython2 = callPackage ./non-by-name/solidpython2 { };

  solo-python = callPackage ./non-by-name/solo-python { };

  solyx-energy-api-client = callPackage ./non-by-name/solyx-energy-api-client { };

  somajo = callPackage ./non-by-name/somajo { };

  somfy-mylink-synergy = callPackage ./non-by-name/somfy-mylink-synergy { };

  somweb = callPackage ./non-by-name/somweb { };

  sonos-websocket = callPackage ./non-by-name/sonos-websocket { };

  sopel = callPackage ./non-by-name/sopel { };

  sorl-thumbnail = callPackage ./non-by-name/sorl-thumbnail { };

  sortedcollections = callPackage ./non-by-name/sortedcollections { };

  sortedcontainers = callPackage ./non-by-name/sortedcontainers { };

  sotabenchapi = callPackage ./non-by-name/sotabenchapi { };

  soundcard = callPackage ./non-by-name/soundcard { };

  soundcloud-v2 = callPackage ./non-by-name/soundcloud-v2 { };

  soundcloudpy = callPackage ./non-by-name/soundcloudpy { };

  sounddevice = callPackage ./non-by-name/sounddevice { };

  soundfile = callPackage ./non-by-name/soundfile { };

  soupsieve = callPackage ./non-by-name/soupsieve { };

  sourmash = callPackage ./non-by-name/sourmash { inherit (pkgs) zstd; };

  soxr = callPackage ./non-by-name/soxr { libsoxr = pkgs.soxr; };

  spacy = callPackage ./non-by-name/spacy { };

  spacy-alignments = callPackage ./non-by-name/spacy-alignments { };

  spacy-curated-transformers = callPackage ./non-by-name/spacy-curated-transformers { };

  spacy-legacy = callPackage ./non-by-name/spacy/legacy.nix { };

  spacy-loggers = callPackage ./non-by-name/spacy-loggers { };

  spacy-lookups-data = callPackage ./non-by-name/spacy/lookups-data.nix { };

  spacy-models = callPackage ./non-by-name/spacy/models.nix { inherit (pkgs) jq; };

  spacy-pkuseg = callPackage ./non-by-name/spacy-pkuseg { };

  spacy-transformers = callPackage ./non-by-name/spacy-transformers { };

  spake2 = callPackage ./non-by-name/spake2 { };

  spandrel = callPackage ./non-by-name/spandrel { };

  spark-parser = callPackage ./non-by-name/spark-parser { };

  sparklines = callPackage ./non-by-name/sparklines { };

  sparqlwrapper = callPackage ./non-by-name/sparqlwrapper { };

  sparse = callPackage ./non-by-name/sparse { };

  sparsediffpy = callPackage ./non-by-name/sparsediffpy { };

  spatial-image = callPackage ./non-by-name/spatial-image { };

  spatialmath-python = callPackage ./non-by-name/spatialmath-python { };

  spdx = callPackage ./non-by-name/spdx { };

  spdx-license-list = callPackage ./non-by-name/spdx-license-list { };

  spdx-python-model = callPackage ./non-by-name/spdx-python-model { };

  spdx-tools = callPackage ./non-by-name/spdx-tools { };

  spdx3-validate = callPackage ./non-by-name/spdx3-validate { };

  speak2mary = callPackage ./non-by-name/speak2mary { };

  speaklater = callPackage ./non-by-name/speaklater { };

  speaklater3 = callPackage ./non-by-name/speaklater3 { };

  specfile = callPackage ./non-by-name/specfile { };

  specialized-turbo = callPackage ./non-by-name/specialized-turbo { };

  spectra = callPackage ./non-by-name/spectra { };

  spectral-cube = callPackage ./non-by-name/spectral-cube { };

  spectral-derivatives = callPackage ./non-by-name/spectral-derivatives { };

  speechbrain = callPackage ./non-by-name/speechbrain { };

  speechrecognition = callPackage ./non-by-name/speechrecognition { };

  speedtest-cli = callPackage ./non-by-name/speedtest-cli { };

  speg = callPackage ./non-by-name/speg { };

  spglib = callPackage ./non-by-name/spglib { };

  spherogram = callPackage ./non-by-name/spherogram { };

  sphfile = callPackage ./non-by-name/sphfile { };

  sphinx = callPackage ./non-by-name/sphinx { };

  sphinx-argparse = callPackage ./non-by-name/sphinx-argparse { };

  sphinx-autoapi = callPackage ./non-by-name/sphinx-autoapi { };

  sphinx-autobuild = callPackage ./non-by-name/sphinx-autobuild { };

  sphinx-autodoc-typehints = callPackage ./non-by-name/sphinx-autodoc-typehints { };

  sphinx-autodoc2 = callPackage ./non-by-name/sphinx-autodoc2 { };

  sphinx-automodapi = callPackage ./non-by-name/sphinx-automodapi {
    graphviz = pkgs.graphviz;
  };

  sphinx-basic-ng = callPackage ./non-by-name/sphinx-basic-ng { };

  sphinx-better-theme = callPackage ./non-by-name/sphinx-better-theme { };

  sphinx-book-theme = callPackage ./non-by-name/sphinx-book-theme { };

  sphinx-click = callPackage ./non-by-name/sphinx-click { };

  sphinx-codeautolink = callPackage ./non-by-name/sphinx-codeautolink { };

  sphinx-comments = callPackage ./non-by-name/sphinx-comments { };

  sphinx-copybutton = callPackage ./non-by-name/sphinx-copybutton { };

  sphinx-design = callPackage ./non-by-name/sphinx-design { };

  sphinx-external-toc = callPackage ./non-by-name/sphinx-external-toc { };

  sphinx-favicon = callPackage ./non-by-name/sphinx-favicon { };

  sphinx-fortran = callPackage ./non-by-name/sphinx-fortran { };

  sphinx-gallery = callPackage ./non-by-name/sphinx-gallery { };

  sphinx-inline-tabs = callPackage ./non-by-name/sphinx-inline-tabs { };

  sphinx-intl = callPackage ./non-by-name/sphinx-intl { };

  sphinx-issues = callPackage ./non-by-name/sphinx-issues { };

  sphinx-jinja = callPackage ./non-by-name/sphinx-jinja { };

  sphinx-jinja2-compat = callPackage ./non-by-name/sphinx-jinja2-compat { };

  sphinx-jupyterbook-latex = callPackage ./non-by-name/sphinx-jupyterbook-latex { };

  sphinx-last-updated-by-git = callPackage ./non-by-name/sphinx-last-updated-by-git { };

  sphinx-llm = callPackage ./non-by-name/sphinx-llm { };

  sphinx-llms-txt = callPackage ./non-by-name/sphinx-llms-txt { };

  sphinx-lv2-theme = callPackage ./non-by-name/sphinx-lv2-theme { };

  sphinx-markdown-builder = callPackage ./non-by-name/sphinx-markdown-builder { };

  sphinx-markdown-parser = callPackage ./non-by-name/sphinx-markdown-parser { };

  sphinx-markdown-tables = callPackage ./non-by-name/sphinx-markdown-tables { };

  sphinx-material = callPackage ./non-by-name/sphinx-material { };

  sphinx-mdinclude = callPackage ./non-by-name/sphinx-mdinclude { };

  sphinx-multitoc-numbering = callPackage ./non-by-name/sphinx-multitoc-numbering { };

  sphinx-multiversion = callPackage ./non-by-name/sphinx-multiversion { };

  sphinx-notfound-page = callPackage ./non-by-name/sphinx-notfound-page { };

  sphinx-prompt = callPackage ./non-by-name/sphinx-prompt { };

  sphinx-pytest = callPackage ./non-by-name/sphinx-pytest { };

  sphinx-remove-toctrees = callPackage ./non-by-name/sphinx-remove-toctrees { };

  sphinx-reredirects = callPackage ./non-by-name/sphinx-reredirects { };

  sphinx-rtd-dark-mode = callPackage ./non-by-name/sphinx-rtd-dark-mode { };

  sphinx-rtd-theme = callPackage ./non-by-name/sphinx-rtd-theme { };

  sphinx-serve = callPackage ./non-by-name/sphinx-serve { };

  sphinx-sitemap = callPackage ./non-by-name/sphinx-sitemap { };

  sphinx-tabs = callPackage ./non-by-name/sphinx-tabs { };

  sphinx-testing = callPackage ./non-by-name/sphinx-testing { };

  sphinx-thebe = callPackage ./non-by-name/sphinx-thebe { };

  sphinx-tippy = callPackage ./non-by-name/sphinx-tippy { };

  sphinx-togglebutton = callPackage ./non-by-name/sphinx-togglebutton { };

  sphinx-toolbox = callPackage ./non-by-name/sphinx-toolbox { };

  sphinxawesome-theme = callPackage ./non-by-name/sphinxawesome-theme { };

  sphinxcontrib-actdiag = callPackage ./non-by-name/sphinxcontrib-actdiag { };

  sphinxcontrib-apidoc = callPackage ./non-by-name/sphinxcontrib-apidoc { };

  sphinxcontrib-applehelp = callPackage ./non-by-name/sphinxcontrib-applehelp { };

  sphinxcontrib-asyncio = callPackage ./non-by-name/sphinxcontrib-asyncio { };

  sphinxcontrib-bayesnet = callPackage ./non-by-name/sphinxcontrib-bayesnet { };

  sphinxcontrib-bibtex = callPackage ./non-by-name/sphinxcontrib-bibtex { };

  sphinxcontrib-blockdiag = callPackage ./non-by-name/sphinxcontrib-blockdiag { };

  sphinxcontrib-confluencebuilder = callPackage ./non-by-name/sphinxcontrib-confluencebuilder { };

  sphinxcontrib-devhelp = callPackage ./non-by-name/sphinxcontrib-devhelp { };

  sphinxcontrib-ditaa = callPackage ./non-by-name/sphinxcontrib-ditaa { };

  sphinxcontrib-excel-table = callPackage ./non-by-name/sphinxcontrib-excel-table { };

  sphinxcontrib-fulltoc = callPackage ./non-by-name/sphinxcontrib-fulltoc { };

  sphinxcontrib-htmlhelp = callPackage ./non-by-name/sphinxcontrib-htmlhelp { };

  sphinxcontrib-httpdomain = callPackage ./non-by-name/sphinxcontrib-httpdomain { };

  sphinxcontrib-jinjadomain = callPackage ./non-by-name/sphinxcontrib-jinjadomain { };

  sphinxcontrib-jquery = callPackage ./non-by-name/sphinxcontrib-jquery { };

  sphinxcontrib-jsmath = callPackage ./non-by-name/sphinxcontrib-jsmath { };

  sphinxcontrib-katex = callPackage ./non-by-name/sphinxcontrib-katex { };

  sphinxcontrib-log-cabinet = callPackage ./non-by-name/sphinxcontrib-log-cabinet { };

  sphinxcontrib-mermaid = callPackage ./non-by-name/sphinxcontrib-mermaid { };

  sphinxcontrib-moderncmakedomain = callPackage ./non-by-name/sphinxcontrib-moderncmakedomain { };

  sphinxcontrib-mscgen = callPackage ./non-by-name/sphinxcontrib-mscgen {
    inherit (pkgs) mscgen;
  };

  sphinxcontrib-nwdiag = callPackage ./non-by-name/sphinxcontrib-nwdiag { };

  sphinxcontrib-openapi = callPackage ./non-by-name/sphinxcontrib-openapi { };

  sphinxcontrib-plantuml = callPackage ./non-by-name/sphinxcontrib-plantuml {
    inherit (pkgs) plantuml;
  };

  sphinxcontrib-programoutput = callPackage ./non-by-name/sphinxcontrib-programoutput { };

  sphinxcontrib-qthelp = callPackage ./non-by-name/sphinxcontrib-qthelp { };

  sphinxcontrib-restbuilder = callPackage ./non-by-name/sphinxcontrib-restbuilder { };

  sphinxcontrib-seqdiag = callPackage ./non-by-name/sphinxcontrib-seqdiag { };

  sphinxcontrib-serializinghtml = callPackage ./non-by-name/sphinxcontrib-serializinghtml { };

  sphinxcontrib-spelling = callPackage ./non-by-name/sphinxcontrib-spelling { };

  sphinxcontrib-svg2pdfconverter = callPackage ./non-by-name/sphinxcontrib-svg2pdfconverter { };

  sphinxcontrib-tikz = callPackage ./non-by-name/sphinxcontrib-tikz { };

  sphinxcontrib-wavedrom = callPackage ./non-by-name/sphinxcontrib-wavedrom { };

  sphinxcontrib-websupport = callPackage ./non-by-name/sphinxcontrib-websupport { };

  sphinxcontrib-youtube = callPackage ./non-by-name/sphinxcontrib-youtube { };

  sphinxemoji = callPackage ./non-by-name/sphinxemoji { };

  sphinxext-opengraph = callPackage ./non-by-name/sphinxext-opengraph { };

  sphinxext-rediraffe = callPackage ./non-by-name/sphinxext-rediraffe { };

  sphinxfeed-lsaffre = callPackage ./non-by-name/sphinxfeed-lsaffre { };

  spidev = callPackage ./non-by-name/spidev { };

  spinev-ble = callPackage ./non-by-name/spinev-ble { };

  spinners = callPackage ./non-by-name/spinners { };

  splines = callPackage ./non-by-name/splines { };

  splinter = callPackage ./non-by-name/splinter { };

  splunk-sdk = callPackage ./non-by-name/splunk-sdk { };

  spmd-types = callPackage ./non-by-name/spmd-types { };

  spotapi = callPackage ./non-by-name/spotapi { };

  spotifyaio = callPackage ./non-by-name/spotifyaio { };

  spotipy = callPackage ./non-by-name/spotipy { };

  spotipyfree = callPackage ./non-by-name/spotipyfree { };

  spsdk = callPackage ./non-by-name/spsdk { };

  spsdk-mcu-link = callPackage ./non-by-name/spsdk-mcu-link { };

  spsdk-pyocd = callPackage ./non-by-name/spsdk-pyocd { };

  spur = callPackage ./non-by-name/spur { };

  spyder = callPackage ./non-by-name/spyder { };

  spyder-kernels = callPackage ./non-by-name/spyder-kernels { };

  spylls = callPackage ./non-by-name/spylls { };

  spyse-python = callPackage ./non-by-name/spyse-python { };

  spython = callPackage ./non-by-name/spython { };

  sqids = callPackage ./non-by-name/sqids { };

  sqlalchemy = callPackage ./non-by-name/sqlalchemy { };

  sqlalchemy-adapter = callPackage ./non-by-name/sqlalchemy-adapter { };

  sqlalchemy-citext = callPackage ./non-by-name/sqlalchemy-citext { };

  sqlalchemy-cockroachdb = callPackage ./non-by-name/sqlalchemy-cockroachdb { };

  sqlalchemy-continuum = callPackage ./non-by-name/sqlalchemy-continuum { };

  sqlalchemy-file = callPackage ./non-by-name/sqlalchemy-file { };

  sqlalchemy-i18n = callPackage ./non-by-name/sqlalchemy-i18n { };

  sqlalchemy-json = callPackage ./non-by-name/sqlalchemy-json { };

  sqlalchemy-jsonfield = callPackage ./non-by-name/sqlalchemy-jsonfield { };

  sqlalchemy-mixins = callPackage ./non-by-name/sqlalchemy-mixins { };

  sqlalchemy-utc = callPackage ./non-by-name/sqlalchemy-utc { };

  sqlalchemy-utils = callPackage ./non-by-name/sqlalchemy-utils { };

  sqlalchemy_1_4 = callPackage ./non-by-name/sqlalchemy/1_4.nix { };

  sqlcipher3 = callPackage ./non-by-name/sqlcipher3 { };

  sqlcipher3-binary = callPackage ./non-by-name/sqlcipher3-binary { };

  sqlcipher3-wheels = callPackage ./non-by-name/sqlcipher3-wheels { };

  sqlfmt = callPackage ./non-by-name/sqlfmt { };

  sqlframe = callPackage ./non-by-name/sqlframe { };

  sqlglot = callPackage ./non-by-name/sqlglot { };

  sqlite-anyio = callPackage ./non-by-name/sqlite-anyio { };

  sqlite-fts4 = callPackage ./non-by-name/sqlite-fts4 { };

  sqlite-migrate = callPackage ./non-by-name/sqlite-migrate { };

  sqlite-utils = callPackage ./non-by-name/sqlite-utils { };

  sqlite-vec = callPackage ./non-by-name/sqlite-vec {
    sqlite-vec-c = pkgs.sqlite-vec;
  };

  sqlitedict = callPackage ./non-by-name/sqlitedict { };

  sqliteschema = callPackage ./non-by-name/sqliteschema { };

  sqlmap = callPackage ./non-by-name/sqlmap { };

  sqlmodel = callPackage ./non-by-name/sqlmodel { };

  sqlobject = callPackage ./non-by-name/sqlobject { };

  sqlparams = callPackage ./non-by-name/sqlparams { };

  sqlparse = callPackage ./non-by-name/sqlparse { };

  sqltrie = callPackage ./non-by-name/sqltrie { };

  squarify = callPackage ./non-by-name/squarify { };

  srctools = callPackage ./non-by-name/srctools { };

  sre-yield = callPackage ./non-by-name/sre-yield { };

  srp = callPackage ./non-by-name/srp { };

  srpenergy = callPackage ./non-by-name/srpenergy { };

  srptools = callPackage ./non-by-name/srptools { };

  srsly = callPackage ./non-by-name/srsly { };

  srt = callPackage ./non-by-name/srt { };

  srvlookup = callPackage ./non-by-name/srvlookup { };

  ssdeep = callPackage ./non-by-name/ssdeep { inherit (pkgs) ssdeep; };

  ssdp = callPackage ./non-by-name/ssdp { };

  ssdpy = callPackage ./non-by-name/ssdpy { };

  sse-starlette = callPackage ./non-by-name/sse-starlette { };

  sseclient = callPackage ./non-by-name/sseclient { };

  sseclient-py = callPackage ./non-by-name/sseclient-py { };

  ssg = callPackage ./non-by-name/ssg { };

  ssh-python = callPackage ./non-by-name/ssh-python { };

  ssh2-python = callPackage ./non-by-name/ssh2-python { };

  sshfs = callPackage ./non-by-name/sshfs { };

  sshpubkeys = callPackage ./non-by-name/sshpubkeys { };

  sshtunnel = callPackage ./non-by-name/sshtunnel { };

  sslib = callPackage ./non-by-name/sslib { };

  sslpsk-pmd3 = callPackage ./non-by-name/sslpsk-pmd3 { };

  ssort = callPackage ./non-by-name/ssort { };

  sss = callPackage ./non-by-name/sss { };

  st-pages = callPackage ./non-by-name/st-pages { };

  stable-baselines3 = callPackage ./non-by-name/stable-baselines3 { };

  stac-valid = callPackage ./non-by-name/stac-valid { };

  stack-data = callPackage ./non-by-name/stack-data { };

  stackit-core = callPackage ./non-by-name/stackit-core { };

  stackit-iaas = callPackage ./non-by-name/stackit-iaas { };

  stackit-objectstorage = callPackage ./non-by-name/stackit-objectstorage { };

  stackit-resourcemanager = callPackage ./non-by-name/stackit-resourcemanager { };

  stackit-ske = callPackage ./non-by-name/stackit-ske { };

  stackprinter = callPackage ./non-by-name/stackprinter { };

  stamina = callPackage ./non-by-name/stamina { };

  standard-aifc = if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-aifc { } else null;

  standard-cgi = if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-cgi { } else null;

  standard-chunk =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-chunk { } else null;

  standard-imghdr =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-imghdr { } else null;

  standard-mailcap =
    if pythonOlder "3.13" then null else callPackage ./non-by-name/standard-mailcap { };

  standard-nntplib =
    if pythonOlder "3.13" then null else callPackage ./non-by-name/standard-nntplib { };

  standard-pipes =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-pipes { } else null;

  standard-pkg-resources = callPackage ./non-by-name/standard-pkg-resources { };

  standard-sndhdr =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-sndhdr { } else null;

  standard-sunau =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-sunau { } else null;

  standard-telnetlib =
    if pythonAtLeast "3.13" then callPackage ./non-by-name/standard-telnetlib { } else null;

  standardwebhooks = callPackage ./non-by-name/standardwebhooks { };

  stanio = callPackage ./non-by-name/stanio { };

  stanza = callPackage ./non-by-name/stanza { };

  starfile = callPackage ./non-by-name/starfile { };

  starkbank-ecdsa = callPackage ./non-by-name/starkbank-ecdsa { };

  starlark = callPackage ./non-by-name/starlark { };

  starlette = callPackage ./non-by-name/starlette { };

  starlette-admin = callPackage ./non-by-name/starlette-admin { };

  starlette-compress = callPackage ./non-by-name/starlette-compress { };

  starlette-context = callPackage ./non-by-name/starlette-context { };

  starlette-wtf = callPackage ./non-by-name/starlette-wtf { };

  starline = callPackage ./non-by-name/starline { };

  starlingbank = callPackage ./non-by-name/starlingbank { };

  starlink-grpc-core = callPackage ./non-by-name/starlink-grpc-core { };

  starsessions = callPackage ./non-by-name/starsessions { };

  stashy = callPackage ./non-by-name/stashy { };

  static3 = callPackage ./non-by-name/static3 { };

  staticjinja = callPackage ./non-by-name/staticjinja { };

  staticmap = callPackage ./non-by-name/staticmap { };

  staticmap3 = callPackage ./non-by-name/staticmap3 { };

  staticvectors = callPackage ./non-by-name/staticvectors { };

  statmake = callPackage ./non-by-name/statmake { };

  statsd = callPackage ./non-by-name/statsd { };

  statsmodels = callPackage ./non-by-name/statsmodels { };

  std-uritemplate = callPackage ./non-by-name/std-uritemplate { };

  std2 = callPackage ./non-by-name/std2 { };

  stdiomask = callPackage ./non-by-name/stdiomask { };

  stdlib-list = callPackage ./non-by-name/stdlib-list { };

  stdlibs = callPackage ./non-by-name/stdlibs { };

  steam = callPackage ./non-by-name/steam { };

  steamloop = callPackage ./non-by-name/steamloop { };

  steamodd = callPackage ./non-by-name/steamodd { };

  steampy = callPackage ./non-by-name/steampy { };

  steamworks = callPackage ./non-by-name/steamworks { };

  stem = callPackage ./non-by-name/stem { };

  stemming = callPackage ./non-by-name/stemming { };

  stestr = callPackage ./non-by-name/stestr { };

  stevedore = callPackage ./non-by-name/stevedore { };

  stickytape = callPackage ./non-by-name/stickytape { };

  stim = callPackage ./non-by-name/stim { };

  stix2 = callPackage ./non-by-name/stix2 { };

  stix2-patterns = callPackage ./non-by-name/stix2-patterns { };

  stix2-validator = callPackage ./non-by-name/stix2-validator { };

  stm32loader = callPackage ./non-by-name/stm32loader { };

  stockfish = callPackage ./non-by-name/stockfish { inherit (pkgs) stockfish; };

  stomp-py = callPackage ./non-by-name/stomp-py { };

  stone = callPackage ./non-by-name/stone { };

  stookwijzer = callPackage ./non-by-name/stookwijzer { };

  stop-words = callPackage ./non-by-name/stop-words { };

  storage3 = callPackage ./non-by-name/storage3 { };

  stp = toPythonModule (pkgs.stp.override { python3 = self.python; });

  stransi = callPackage ./non-by-name/stransi { };

  strategies = callPackage ./non-by-name/strategies { };

  stravalib = callPackage ./non-by-name/stravalib { };

  stravaweblib = callPackage ./non-by-name/stravaweblib { };

  strawberry-graphql = callPackage ./non-by-name/strawberry-graphql { };

  strawberry-graphql-django = callPackage ./non-by-name/strawberry-graphql-django { };

  strct = callPackage ./non-by-name/strct { };

  stream-inflate = callPackage ./non-by-name/stream-inflate { };

  stream-unzip = callPackage ./non-by-name/stream-unzip { };

  streamcontroller-plugin-tools = callPackage ./non-by-name/streamcontroller-plugin-tools { };

  streamcontroller-streamdeck = callPackage ./non-by-name/streamcontroller-streamdeck { };

  streamdeck = callPackage ./non-by-name/streamdeck { };

  streaming-form-data = callPackage ./non-by-name/streaming-form-data { };

  streamingjson = callPackage ./non-by-name/streamingjson { };

  streamlabswater = callPackage ./non-by-name/streamlabswater { };

  streamlit = callPackage ./non-by-name/streamlit { };

  streamlit-avatar = callPackage ./non-by-name/streamlit-avatar { };

  streamlit-card = callPackage ./non-by-name/streamlit-card { };

  streamlit-echarts = callPackage ./non-by-name/streamlit-echarts { };

  streamlit-folium = callPackage ./non-by-name/streamlit-folium { };

  streamlit-kpi-card = callPackage ./non-by-name/streamlit-kpi-card { };

  streamlit-notify = callPackage ./non-by-name/streamlit-notify { };

  streamz = callPackage ./non-by-name/streamz { };

  strenum = callPackage ./non-by-name/strenum { };

  strict-rfc3339 = callPackage ./non-by-name/strict-rfc3339 { };

  strictyaml = callPackage ./non-by-name/strictyaml { };

  stringbrewer = callPackage ./non-by-name/stringbrewer { };

  stringcase = callPackage ./non-by-name/stringcase { };

  stringly = callPackage ./non-by-name/stringly { };

  stringparser = callPackage ./non-by-name/stringparser { };

  stringzilla = callPackage ./non-by-name/stringzilla { };

  strip-ansi = callPackage ./non-by-name/strip-ansi { };

  stripe = callPackage ./non-by-name/stripe { };

  striprtf = callPackage ./non-by-name/striprtf { };

  strpdatetime = callPackage ./non-by-name/strpdatetime { };

  strsimpy = callPackage ./non-by-name/strsimpy { };

  structlog = callPackage ./non-by-name/structlog { };

  stubserver = callPackage ./non-by-name/stubserver { };

  stumpy = callPackage ./non-by-name/stumpy { };

  stupidartnet = callPackage ./non-by-name/stupidartnet { };

  stups-cli-support = callPackage ./non-by-name/stups-cli-support { };

  stups-fullstop = callPackage ./non-by-name/stups-fullstop { };

  stups-pierone = callPackage ./non-by-name/stups-pierone { };

  stups-tokens = callPackage ./non-by-name/stups-tokens { };

  stups-zign = callPackage ./non-by-name/stups-zign { };

  stytra = callPackage ./non-by-name/stytra { };

  subarulink = callPackage ./non-by-name/subarulink { };

  subliminal = callPackage ./non-by-name/subliminal { };

  submitit = callPackage ./non-by-name/submitit { };

  subprocess-tee = callPackage ./non-by-name/subprocess-tee { };

  subprocess4 = callPackage ./non-by-name/subprocess4 { };

  subzerod = callPackage ./non-by-name/subzerod { };

  succulent = callPackage ./non-by-name/succulent { };

  sudachidict-core = callPackage ./non-by-name/sudachidict { };

  sudachidict-full = callPackage ./non-by-name/sudachidict {
    sudachidict = pkgs.sudachidict.override { dict-type = "full"; };
  };

  sudachidict-small = callPackage ./non-by-name/sudachidict {
    sudachidict = pkgs.sudachidict.override { dict-type = "small"; };
  };

  sudachipy = callPackage ./non-by-name/sudachipy { };

  suds = callPackage ./non-by-name/suds { };

  suds-community = callPackage ./non-by-name/suds-community { };

  summarytools = callPackage ./non-by-name/summarytools { };

  sumo = callPackage ./non-by-name/sumo { };

  sumtypes = callPackage ./non-by-name/sumtypes { };

  sunpy = callPackage ./non-by-name/sunpy { };

  sunsynk-api-client = callPackage ./non-by-name/sunsynk-api-client { };

  suntime = callPackage ./non-by-name/suntime { };

  sunwatcher = callPackage ./non-by-name/sunwatcher { };

  sunweg = callPackage ./non-by-name/sunweg { };

  supabase = callPackage ./non-by-name/supabase { };

  supabase-auth = callPackage ./non-by-name/supabase-auth { };

  supabase-functions = callPackage ./non-by-name/supabase-functions { };

  super-collections = callPackage ./non-by-name/super-collections { };

  superqt = callPackage ./non-by-name/superqt { };

  supervise-api = callPackage ./non-by-name/supervise-api { };

  supervision = callPackage ./non-by-name/supervision { };

  supervisor = callPackage ./non-by-name/supervisor { };

  sure = callPackage ./non-by-name/sure { };

  surepy = callPackage ./non-by-name/surepy { };

  surt = callPackage ./non-by-name/surt { };

  survey = callPackage ./non-by-name/survey { };

  sv-ttk = callPackage ./non-by-name/sv-ttk { };

  svcs = callPackage ./non-by-name/svcs { };

  svg-path = callPackage ./non-by-name/svg-path { };

  svg-py = callPackage ./non-by-name/svg-py { };

  svg2tikz = callPackage ./non-by-name/svg2tikz { };

  svgdigitizer = callPackage ./non-by-name/svgdigitizer { };

  svgelements = callPackage ./non-by-name/svgelements { };

  svglib = callPackage ./non-by-name/svglib { };

  svgpathtools = callPackage ./non-by-name/svgpathtools { };

  svgutils = callPackage ./non-by-name/svgutils { };

  svgwrite = callPackage ./non-by-name/svgwrite { };

  swagger-spec-validator = callPackage ./non-by-name/swagger-spec-validator { };

  swagger-ui-bundle = callPackage ./non-by-name/swagger-ui-bundle { };

  swagger-ui-py = callPackage ./non-by-name/swagger-ui-py { };

  swcgeom = callPackage ./non-by-name/swcgeom { };

  sweeps = callPackage ./non-by-name/sweeps { };

  swh-auth = callPackage ./non-by-name/swh-auth { };

  swh-core = callPackage ./non-by-name/swh-core { };

  swh-export = callPackage ./non-by-name/swh-export { };

  swh-journal = callPackage ./non-by-name/swh-journal { };

  swh-model = callPackage ./non-by-name/swh-model { };

  swh-mosaic = callPackage ./non-by-name/swh-mosaic { };

  swh-objstorage = callPackage ./non-by-name/swh-objstorage { };

  swh-scanner = callPackage ./non-by-name/swh-scanner { };

  swh-scheduler = callPackage ./non-by-name/swh-scheduler { };

  swh-shard = callPackage ./non-by-name/swh-shard { };

  swh-storage = callPackage ./non-by-name/swh-storage { };

  swh-web-client = callPackage ./non-by-name/swh-web-client { };

  swi-tools = callPackage ./non-by-name/swi-tools { };

  swift = callPackage ./non-by-name/swift { };

  swifter = callPackage ./non-by-name/swifter { };

  swisshydrodata = callPackage ./non-by-name/swisshydrodata { };

  switchbot-api = callPackage ./non-by-name/switchbot-api { };

  swspotify = callPackage ./non-by-name/swspotify { };

  sybil = callPackage ./non-by-name/sybil { };

  symbex = callPackage ./non-by-name/symbex { };

  symbolic = callPackage ./non-by-name/symbolic { inherit (pkgs) zstd; };

  symengine = callPackage ./non-by-name/symengine { inherit (pkgs) symengine; };

  symfc = callPackage ./non-by-name/symfc { };

  sympy = callPackage ./non-by-name/sympy { };

  symspellpy = callPackage ./non-by-name/symspellpy { };

  syncedlyrics = callPackage ./non-by-name/syncedlyrics { };

  syncer = callPackage ./non-by-name/syncer { };

  synchronicity = callPackage ./non-by-name/synchronicity { };

  syndication-domination = toPythonModule (
    pkgs.syndication-domination.override {
      enablePython = true;
      python3Packages = self;
    }
  );

  syne-tune = callPackage ./non-by-name/syne-tune { };

  synergy = callPackage ./non-by-name/synergy { };

  synology-srm = callPackage ./non-by-name/synology-srm { };

  synthetic-home = callPackage ./non-by-name/synthetic-home { };

  syrupy = callPackage ./non-by-name/syrupy { };

  syrupy_5 = callPackage ./non-by-name/syrupy/5.nix { };

  syslog-rfc5424-formatter = callPackage ./non-by-name/syslog-rfc5424-formatter { };

  sysrsync = callPackage ./non-by-name/sysrsync { };

  systembridgeconnector = callPackage ./non-by-name/systembridgeconnector { };

  systemd-python = callPackage ./non-by-name/systemd-python {
    inherit (pkgs) systemd;
  };

  systemdunitparser = callPackage ./non-by-name/systemdunitparser { };

  systemrdl-compiler = callPackage ./non-by-name/systemrdl-compiler { };

  sysv-ipc = callPackage ./non-by-name/sysv-ipc { };

  t61codec = callPackage ./non-by-name/t61codec { };

  tabcmd = callPackage ./non-by-name/tabcmd { };

  tableaudocumentapi = callPackage ./non-by-name/tableaudocumentapi { };

  tableauserverclient = callPackage ./non-by-name/tableauserverclient { };

  tabledata = callPackage ./non-by-name/tabledata { };

  tables = callPackage ./non-by-name/tables { };

  tablib = callPackage ./non-by-name/tablib { };

  tabula-py = callPackage ./non-by-name/tabula-py { };

  tabulate = callPackage ./non-by-name/tabulate { };

  tabview = callPackage ./non-by-name/tabview { };

  taco = toPythonModule (
    pkgs.taco.override {
      enablePython = true;
    }
  );

  tadasets = callPackage ./non-by-name/tadasets { };

  tag-expressions = callPackage ./non-by-name/tag-expressions { };

  tagoio-sdk = callPackage ./non-by-name/tagoio-sdk { };

  tailer = callPackage ./non-by-name/tailer { };

  tailscale = callPackage ./non-by-name/tailscale { };

  takethetime = callPackage ./non-by-name/takethetime { };

  tami4edgeapi = callPackage ./non-by-name/tami4edgeapi { };

  tank-utility = callPackage ./non-by-name/tank-utility { };

  tantivy = callPackage ./non-by-name/tantivy { };

  tappy = callPackage ./non-by-name/tappy { };

  tapsaff = callPackage ./non-by-name/tapsaff { };

  targ = callPackage ./non-by-name/targ { };

  tasklib = callPackage ./non-by-name/tasklib { };

  taskw = callPackage ./non-by-name/taskw { };

  taskw-ng = callPackage ./non-by-name/taskw-ng { };

  tatsu = callPackage ./non-by-name/tatsu { };

  tatsu-lts = callPackage ./non-by-name/tatsu-lts { };

  taxi = callPackage ./non-by-name/taxi { };

  taxii2-client = callPackage ./non-by-name/taxii2-client { };

  tblib = callPackage ./non-by-name/tblib { };

  tblite = callPackage ../../by-name/tb/tblite/python.nix {
    inherit (pkgs)
      tblite
      meson
      simple-dftd3
      dftd4
      ;
  };

  tccbox = callPackage ./non-by-name/tccbox { };

  tcia-utils = callPackage ./non-by-name/tcia-utils { };

  tcolorpy = callPackage ./non-by-name/tcolorpy { };

  tcxfile = callPackage ./non-by-name/tcxfile { };

  tcxparser = callPackage ./non-by-name/tcxparser { };

  tcxreader = callPackage ./non-by-name/tcxreader { };

  tdir = callPackage ./non-by-name/tdir { };

  teamcity-messages = callPackage ./non-by-name/teamcity-messages { };

  telegram-text = callPackage ./non-by-name/telegram-text { };

  telegraph = callPackage ./non-by-name/telegraph { };

  telepath = callPackage ./non-by-name/telepath { };

  telethon = callPackage ./non-by-name/telethon { inherit (pkgs) openssl; };

  telethon-session-sqlalchemy = callPackage ./non-by-name/telethon-session-sqlalchemy { };

  teletype = callPackage ./non-by-name/teletype { };

  telfhash = callPackage ./non-by-name/telfhash { };

  tellcore-net = callPackage ./non-by-name/tellcore-net { };

  tellcore-py = callPackage ./non-by-name/tellcore-py { };

  tellduslive = callPackage ./non-by-name/tellduslive { };

  telnetlib3 = callPackage ./non-by-name/telnetlib3 { };

  teltasync = callPackage ./non-by-name/teltasync { };

  temescal = callPackage ./non-by-name/temescal { };

  temperusb = callPackage ./non-by-name/temperusb { };

  tempest = callPackage ./non-by-name/tempest { };

  templateflow = callPackage ./non-by-name/templateflow { };

  tempman = callPackage ./non-by-name/tempman { };

  tempora = callPackage ./non-by-name/tempora { };

  temporalio = callPackage ./non-by-name/temporalio { inherit (pkgs) zstd; };

  tenacity = callPackage ./non-by-name/tenacity { };

  tenant-schemas-celery = callPackage ./non-by-name/tenant-schemas-celery { };

  tencentcloud-sdk-python = callPackage ./non-by-name/tencentcloud-sdk-python { };

  tendo = callPackage ./non-by-name/tendo { };

  tensorboard = callPackage ./non-by-name/tensorboard { };

  tensorboard-data-server = callPackage ./non-by-name/tensorboard-data-server { };

  tensorboard-plugin-profile = callPackage ./non-by-name/tensorboard-plugin-profile { };

  tensorboard-plugin-wit = callPackage ./non-by-name/tensorboard-plugin-wit { };

  tensorboardx = callPackage ./non-by-name/tensorboardx { };

  tensordict = callPackage ./non-by-name/tensordict { };

  tensorflow = self.tensorflow-bin;

  tensorflow-bin = callPackage ./non-by-name/tensorflow/bin.nix {
    inherit (pkgs.config) cudaSupport;
  };

  tensorflow-datasets = callPackage ./non-by-name/tensorflow-datasets { };

  tensorflow-estimator-bin = callPackage ./non-by-name/tensorflow-estimator/bin.nix { };

  tensorflow-metadata = callPackage ./non-by-name/tensorflow-metadata { };

  tensorflow-probability = callPackage ./non-by-name/tensorflow-probability { };

  tensorflowWithCuda = self.tensorflow.override { cudaSupport = true; };

  tensorflowWithoutCuda = self.tensorflow.override { cudaSupport = false; };

  tensorly = callPackage ./non-by-name/tensorly { };

  tensorrt = callPackage ./non-by-name/tensorrt { };

  tensorstore = callPackage ./non-by-name/tensorstore { };

  term-image = callPackage ./non-by-name/term-image { };

  termcolor = callPackage ./non-by-name/termcolor { };

  termgraph = callPackage ./non-by-name/termgraph { };

  terminado = callPackage ./non-by-name/terminado { };

  terminaltables = callPackage ./non-by-name/terminaltables { };

  terminaltables3 = callPackage ./non-by-name/terminaltables3 { };

  terminaltexteffects = callPackage ./non-by-name/terminaltexteffects { };

  termplotlib = callPackage ./non-by-name/termplotlib { };

  tern = callPackage ./non-by-name/tern { };

  tesla-fleet-api = callPackage ./non-by-name/tesla-fleet-api { };

  tesla-powerwall = callPackage ./non-by-name/tesla-powerwall { };

  tesla-protocol = callPackage ./non-by-name/tesla-protocol { };

  tesla-wall-connector = callPackage ./non-by-name/tesla-wall-connector { };

  teslajsonpy = callPackage ./non-by-name/teslajsonpy { };

  teslemetry-stream = callPackage ./non-by-name/teslemetry-stream { };

  tess = callPackage ./non-by-name/tess { };

  tesserocr = callPackage ./non-by-name/tesserocr { };

  tessie-api = callPackage ./non-by-name/tessie-api { };

  test-results-parser = callPackage ./non-by-name/test-results-parser { };

  test-tube = callPackage ./non-by-name/test-tube { };

  test2ref = callPackage ./non-by-name/test2ref { };

  testbook = callPackage ./non-by-name/testbook { };

  testcontainers = callPackage ./non-by-name/testcontainers { };

  testfixtures = callPackage ./non-by-name/testfixtures { };

  testing-common-database = callPackage ./non-by-name/testing-common-database { };

  testpath = callPackage ./non-by-name/testpath { };

  testrail-api = callPackage ./non-by-name/testrail-api { };

  testrepository = callPackage ./non-by-name/testrepository { };

  testresources = callPackage ./non-by-name/testresources { };

  testscenarios = callPackage ./non-by-name/testscenarios { };

  testtools = callPackage ./non-by-name/testtools { };

  texsoup = callPackage ./non-by-name/texsoup { };

  text-unidecode = callPackage ./non-by-name/text-unidecode { };

  text2digits = callPackage ./non-by-name/text2digits { };

  textacy = callPackage ./non-by-name/textacy { };

  textblob = callPackage ./non-by-name/textblob { };

  textdistance = callPackage ./non-by-name/textdistance { };

  textfsm = callPackage ./non-by-name/textfsm { };

  textile = callPackage ./non-by-name/textile { };

  textnets = callPackage ./non-by-name/textnets {
    en_core_web_sm = spacy-models.en_core_web_sm;
  };

  textparser = callPackage ./non-by-name/textparser { };

  textstat = callPackage ./non-by-name/textstat { };

  texttable = callPackage ./non-by-name/texttable { };

  textual = callPackage ./non-by-name/textual { };

  textual-autocomplete = callPackage ./non-by-name/textual-autocomplete { };

  textual-dev = callPackage ./non-by-name/textual-dev { };

  textual-fastdatatable = callPackage ./non-by-name/textual-fastdatatable { };

  textual-image = callPackage ./non-by-name/textual-image { };

  textual-plotext = callPackage ./non-by-name/textual-plotext { };

  textual-serve = callPackage ./non-by-name/textual-serve { };

  textual-slider = callPackage ./non-by-name/textual-slider { };

  textual-speedups = callPackage ./non-by-name/textual-speedups { };

  textual-textarea = callPackage ./non-by-name/textual-textarea { };

  textual-universal-directorytree = callPackage ./non-by-name/textual-universal-directorytree { };

  textualeffects = callPackage ./non-by-name/textualeffects { };

  textx = callPackage ./non-by-name/textx { };

  tf-keras = callPackage ./non-by-name/tf-keras { };

  tf-playwright-stealth = callPackage ./non-by-name/tf-playwright-stealth { };

  tf2onnx = callPackage ./non-by-name/tf2onnx { };

  tflearn = callPackage ./non-by-name/tflearn { };

  tftpy = callPackage ./non-by-name/tftpy { };

  th1 = callPackage ./non-by-name/th1 { };

  theben-conexa-smgw = callPackage ./non-by-name/theben-conexa-smgw { };

  thefuzz = callPackage ./non-by-name/thefuzz { };

  thelogrus = callPackage ./non-by-name/thelogrus { };

  thermobeacon-ble = callPackage ./non-by-name/thermobeacon-ble { };

  thermopro-ble = callPackage ./non-by-name/thermopro-ble { };

  thespian = callPackage ./non-by-name/thespian { };

  thinc = callPackage ./non-by-name/thinc { };

  thingspeak = callPackage ./non-by-name/thingspeak { };

  thinqconnect = callPackage ./non-by-name/thinqconnect { };

  thorlabspm100 = callPackage ./non-by-name/thorlabspm100 { };

  threadloop = callPackage ./non-by-name/threadloop { };

  threadpoolctl = callPackage ./non-by-name/threadpoolctl { };

  threat9-test-bed = callPackage ./non-by-name/threat9-test-bed { };

  three-merge = callPackage ./non-by-name/three-merge { };

  thrift = callPackage ./non-by-name/thrift { };

  thriftpy2 = callPackage ./non-by-name/thriftpy2 { };

  throttler = callPackage ./non-by-name/throttler { };

  thttp = callPackage ./non-by-name/thttp { };

  tianshou = callPackage ./non-by-name/tianshou { };

  tidalapi = callPackage ./non-by-name/tidalapi { };

  tidyexc = callPackage ./non-by-name/tidyexc { };

  tidylib = callPackage ./non-by-name/pytidylib { };

  tiered-debug = callPackage ./non-by-name/tiered-debug { };

  tifffile = callPackage ./non-by-name/tifffile { };

  tika = callPackage ./non-by-name/tika { };

  tika-client = callPackage ./non-by-name/tika-client { };

  tiktoken = callPackage ./non-by-name/tiktoken { };

  tiledb = callPackage ./non-by-name/tiledb { inherit (pkgs) tiledb; };

  tilelang = callPackage ./non-by-name/tilelang { };

  tilequant = callPackage ./non-by-name/tilequant { };

  tiler = callPackage ./non-by-name/tiler { };

  tilt-ble = callPackage ./non-by-name/tilt-ble { };

  tilt-pi = callPackage ./non-by-name/tilt-pi { };

  time-machine = callPackage ./non-by-name/time-machine { };

  timeago = callPackage ./non-by-name/timeago { };

  timecop = callPackage ./non-by-name/timecop { };

  timelength = callPackage ./non-by-name/timelength { };

  timelib = callPackage ./non-by-name/timelib { };

  timeout-decorator = callPackage ./non-by-name/timeout-decorator { };

  timeslot = callPackage ./non-by-name/timeslot { };

  timetagger = callPackage ./non-by-name/timetagger { };

  timezonefinder = callPackage ./non-by-name/timezonefinder { };

  timg = callPackage ./non-by-name/timg { };

  timing-asgi = callPackage ./non-by-name/timing-asgi { };

  timm = callPackage ./non-by-name/timm { };

  timple = callPackage ./non-by-name/timple { };

  timy = callPackage ./non-by-name/timy { };

  tiny-cuda-nn = toPythonModule (
    pkgs.tiny-cuda-nn.override {
      cudaPackages = self.torch.cudaPackages;
      python3Packages = self;
      pythonSupport = true;
    }
  );

  tiny-proxy = callPackage ./non-by-name/tiny-proxy { };

  tinycss = callPackage ./non-by-name/tinycss { };

  tinycss2 = callPackage ./non-by-name/tinycss2 { };

  tinydb = callPackage ./non-by-name/tinydb { };

  tinygrad = callPackage ./non-by-name/tinygrad { };

  tinyhtml = callPackage ./non-by-name/tinyhtml { };

  tinyhtml5 = callPackage ./non-by-name/tinyhtml5 { };

  tinyio = callPackage ./non-by-name/tinyio { };

  tinyobjloader-py = callPackage ./non-by-name/tinyobjloader-py { };

  tinyrecord = callPackage ./non-by-name/tinyrecord { };

  tinysegmenter = callPackage ./non-by-name/tinysegmenter { };

  tinytag = callPackage ./non-by-name/tinytag { };

  tinytuya = callPackage ./non-by-name/tinytuya { };

  tiptapy = callPackage ./non-by-name/tiptapy { };

  titlecase = callPackage ./non-by-name/titlecase { };

  tivars = callPackage ./non-by-name/tivars { };

  tkinter =
    if isPyPy then
      null
    else
      callPackage ./non-by-name/tkinter {
        # Tcl/Tk 9.0 support in Tkinter is not quite ready yet:
        # - https://github.com/python/cpython/issues/124111
        # - https://github.com/python/cpython/issues/104568
        tcl = if pythonAtLeast "3.14" then pkgs.tcl-9_0 else pkgs.tcl-8_6;
        tk = if pythonAtLeast "3.14" then pkgs.tk-9_0 else pkgs.tk-8_6;
      };

  tkinter-gl = callPackage ./non-by-name/tkinter-gl {
    inherit (pkgs) mesa;
    inherit (pkgs.tclPackages.override { inherit (tkinter) tcl tk; }) tkgl;
  };

  tld = callPackage ./non-by-name/tld { };

  tldextract = callPackage ./non-by-name/tldextract { };

  tlds = callPackage ./non-by-name/tlds { };

  tlmviewer = callPackage ./non-by-name/tlmviewer { };

  tlparse = callPackage ./non-by-name/tlparse { };

  tls-client = callPackage ./non-by-name/tls-client { };

  tls-parser = callPackage ./non-by-name/tls-parser { };

  tlsh = callPackage ./non-by-name/tlsh { };

  tlslite-ng = callPackage ./non-by-name/tlslite-ng { };

  tlv8 = callPackage ./non-by-name/tlv8 { };

  tmb = callPackage ./non-by-name/tmb { };

  tmdbsimple = callPackage ./non-by-name/tmdbsimple { };

  tmodbus = callPackage ./non-by-name/tmodbus { };

  tnefparse = callPackage ./non-by-name/tnefparse { };

  todoist = callPackage ./non-by-name/todoist { };

  todoist-api-python = callPackage ./non-by-name/todoist-api-python { };

  togglcli = callPackage ./non-by-name/togglcli { };

  togrill-bluetooth = callPackage ./non-by-name/togrill-bluetooth { };

  token-bucket = callPackage ./non-by-name/token-bucket { };

  tokenize-rt = callPackage ./non-by-name/tokenize-rt { };

  tokenizers = callPackage ./non-by-name/tokenizers { };

  tokenlib = callPackage ./non-by-name/tokenlib { };

  tokenspeed-mla = callPackage ./non-by-name/tokenspeed-mla { };

  tokenspeed-mla-bin = callPackage ./non-by-name/tokenspeed-mla/bin.nix { };

  tokenspeed-triton = callPackage ./non-by-name/tokenspeed-triton { };

  tokenspeed-triton-bin = callPackage ./non-by-name/tokenspeed-triton/bin.nix { };

  tokentrim = callPackage ./non-by-name/tokentrim { };

  toktok-rs = callPackage ./non-by-name/toktok-rs { };

  tololib = callPackage ./non-by-name/tololib { };

  toml = callPackage ./non-by-name/toml { };

  toml-adapt = callPackage ./non-by-name/toml-adapt { };

  tomli = callPackage ./non-by-name/tomli { };

  tomli-w = callPackage ./non-by-name/tomli-w { };

  tomlkit = callPackage ./non-by-name/tomlkit { };

  tomlrt = callPackage ./non-by-name/tomlrt { };

  tonewinner-rs232 = callPackage ./non-by-name/tonewinner-rs232 { };

  toolz = callPackage ./non-by-name/toolz { };

  toon-format = callPackage ./non-by-name/toon-format { };

  toonapi = callPackage ./non-by-name/toonapi { };

  toposort = callPackage ./non-by-name/toposort { };

  toppra = callPackage ./non-by-name/toppra { };

  toptica-lasersdk = callPackage ./non-by-name/toptica-lasersdk { };

  torch = callPackage ./non-by-name/torch/source { };

  torch-audiomentations = callPackage ./non-by-name/torch-audiomentations { };

  torch-bin = callPackage ./non-by-name/torch/bin { triton = self.triton-bin; };

  torch-c-dlpack-ext = callPackage ./non-by-name/torch-c-dlpack-ext { };

  torch-checkpointing = callPackage ./non-by-name/torch-checkpointing { };

  torch-cluster = callPackage ./non-by-name/torch-cluster { };

  torch-einops-utils = callPackage ./non-by-name/torch-einops-utils { };

  torch-ema = callPackage ./non-by-name/torch-ema { };

  torch-geometric = callPackage ./non-by-name/torch-geometric { };

  torch-memory-saver = callPackage ./non-by-name/torch-memory-saver { };

  # Required to test triton
  torch-no-triton = self.torch.override { tritonSupport = false; };

  torch-pitch-shift = callPackage ./non-by-name/torch-pitch-shift { };

  torch-remat = callPackage ./non-by-name/torch-remat { };

  torch-tb-profiler = callPackage ./non-by-name/torch-tb-profiler/default.nix { };

  torch-tensorrt = callPackage ./non-by-name/torch-tensorrt {
    torch-tensorrt = pkgs.torch-tensorrt.override {
      python3Packages = self;
    };
  };

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

  torchao = callPackage ./non-by-name/torchao { };

  torchaudio = callPackage ./non-by-name/torchaudio { };

  torchaudio-bin = callPackage ./non-by-name/torchaudio/bin.nix { };

  torchbench = callPackage ./non-by-name/torchbench { };

  torchbenchmark = callPackage ./non-by-name/torchbenchmark { };

  torchcodec = callPackage ./non-by-name/torchcodec { };

  torchcrepe = callPackage ./non-by-name/torchcrepe { };

  torchdata = callPackage ./non-by-name/torchdata { };

  torchdiffeq = callPackage ./non-by-name/torchdiffeq { };

  torcheval = callPackage ./non-by-name/torcheval { };

  torchimplicit = callPackage ./non-by-name/torchimplicit { };

  torchinfo = callPackage ./non-by-name/torchinfo { };

  torchio = callPackage ./non-by-name/torchio { };

  torchlensmaker = callPackage ./non-by-name/torchlensmaker { };

  torchlibrosa = callPackage ./non-by-name/torchlibrosa { };

  torchmd-net = callPackage ./non-by-name/torchmd-net { };

  torchmetrics = callPackage ./non-by-name/torchmetrics { };

  torchprofile = callPackage ./non-by-name/torchprofile { };

  torchrl = callPackage ./non-by-name/torchrl { };

  torchrunx = callPackage ./non-by-name/torchrunx { };

  torchsde = callPackage ./non-by-name/torchsde { };

  torchsnapshot = callPackage ./non-by-name/torchsnapshot { };

  torchsummary = callPackage ./non-by-name/torchsummary { };

  torchtitan = callPackage ./non-by-name/torchtitan { };

  torchtnt = callPackage ./non-by-name/torchtnt { };

  torchvision = callPackage ./non-by-name/torchvision { };

  torchvision-bin = callPackage ./non-by-name/torchvision/bin.nix { };

  torf = callPackage ./non-by-name/torf { };

  tornado = callPackage ./non-by-name/tornado { };

  torpy = callPackage ./non-by-name/torpy { };

  torrent-parser = callPackage ./non-by-name/torrent-parser { };

  torrequest = callPackage ./non-by-name/torrequest { };

  total-connect-client = callPackage ./non-by-name/total-connect-client { };

  touying = callPackage ./non-by-name/touying { };

  towncrier = callPackage ./non-by-name/towncrier { inherit (pkgs) git; };

  tox = callPackage ./non-by-name/tox { };

  tplink-omada-client = callPackage ./non-by-name/tplink-omada-client { };

  tpm2-pytss = callPackage ./non-by-name/tpm2-pytss { };

  tqdm = callPackage ./non-by-name/tqdm { };

  traceback2 = callPackage ./non-by-name/traceback2 { };

  tracerite = callPackage ./non-by-name/tracerite { };

  trackers = callPackage ./non-by-name/trackers { };

  trackpy = callPackage ./non-by-name/trackpy { };

  trafilatura = callPackage ./non-by-name/trafilatura { };

  trailbase = callPackage ./non-by-name/trailbase { inherit (pkgs) trailbase; };

  trailrunner = callPackage ./non-by-name/trailrunner { };

  trainer = callPackage ./non-by-name/trainer { };

  traitlets = callPackage ./non-by-name/traitlets { };

  traits = callPackage ./non-by-name/traits { };

  traitsui = callPackage ./non-by-name/traitsui { };

  traittypes = callPackage ./non-by-name/traittypes { };

  trakit = callPackage ./non-by-name/trakit { };

  trampoline = callPackage ./non-by-name/trampoline { };

  transaction = callPackage ./non-by-name/transaction { };

  transformer-engine = callPackage ./non-by-name/transformer-engine { };

  transformer-engine-jax = transformer-engine.override {
    withJax = true;
    withPytorch = false;
  };

  transformer-engine-pytorch = transformer-engine.override {
    withJax = false;
    withPytorch = true;
  };

  transformers = callPackage ./non-by-name/transformers { };

  transformers_4 = callPackage ./non-by-name/transformers/4.nix { };

  transforms3d = callPackage ./non-by-name/transforms3d { };

  transitions = callPackage ./non-by-name/transitions { };

  translate-toolkit = callPackage ./non-by-name/translate-toolkit { };

  translatehtml = callPackage ./non-by-name/translatehtml { };

  translatepy = callPackage ./non-by-name/translatepy { };

  translation-finder = callPackage ./non-by-name/translation-finder { };

  translationstring = callPackage ./non-by-name/translationstring { };

  translitcodec = callPackage ./non-by-name/translitcodec { };

  transmission-rpc = callPackage ./non-by-name/transmission-rpc { };

  travispy = callPackage ./non-by-name/travispy { };

  trayer = callPackage ./non-by-name/trayer { };

  trectools = callPackage ./non-by-name/trectools { };

  tree-sitter = callPackage ./non-by-name/tree-sitter { };

  tree-sitter-bash = callPackage ./non-by-name/tree-sitter-bash { };

  tree-sitter-c-sharp = callPackage ./non-by-name/tree-sitter-c-sharp { };

  tree-sitter-config = callPackage ./non-by-name/tree-sitter-config { };

  tree-sitter-embedded-template = callPackage ./non-by-name/tree-sitter-embedded-template { };

  tree-sitter-grammars = lib.recurseIntoAttrs (
    lib.mapAttrs
      (name: grammarDrv: callPackage ./non-by-name/tree-sitter-grammars { inherit name grammarDrv; })
      (
        # Filtering grammars not compatible with current py-tree-sitter version
        lib.filterAttrs (
          name: value:
          !(builtins.elem name [
            "tree-sitter-go-template"
            "tree-sitter-php-only"
            "tree-sitter-sql"
            "tree-sitter-sshclientconfig"
            "tree-sitter-templ"
          ])
        ) pkgs.tree-sitter-grammars.derivations
      )
  );

  tree-sitter-html = callPackage ./non-by-name/tree-sitter-html { };

  tree-sitter-javascript = callPackage ./non-by-name/tree-sitter-javascript { };

  tree-sitter-json = callPackage ./non-by-name/tree-sitter-json { };

  tree-sitter-language-pack = callPackage ./non-by-name/tree-sitter-language-pack {
    inherit (pkgs) zstd;
  };

  tree-sitter-languages = callPackage ./non-by-name/tree-sitter-languages { };

  tree-sitter-make = callPackage ./non-by-name/tree-sitter-make { };

  tree-sitter-markdown = callPackage ./non-by-name/tree-sitter-markdown { };

  tree-sitter-python = callPackage ./non-by-name/tree-sitter-python { };

  tree-sitter-rust = callPackage ./non-by-name/tree-sitter-rust { };

  tree-sitter-sql = callPackage ./non-by-name/tree-sitter-sql { };

  tree-sitter-textproto = callPackage ./non-by-name/tree-sitter-textproto { };

  tree-sitter-typescript = callPackage ./non-by-name/tree-sitter-typescript { };

  tree-sitter-yaml = callPackage ./non-by-name/tree-sitter-yaml { };

  tree-sitter-zeek = callPackage ./non-by-name/tree-sitter-zeek { };

  treelib = callPackage ./non-by-name/treelib { };

  treelog = callPackage ./non-by-name/treelog { };

  treescope = callPackage ./non-by-name/treescope { };

  treq = callPackage ./non-by-name/treq { };

  trevorproxy = callPackage ./non-by-name/trevorproxy { };

  trezor = callPackage ./non-by-name/trezor { };

  trezor-agent = callPackage ./non-by-name/trezor-agent {
    pinentry = pkgs.pinentry-curses;
  };

  trie = callPackage ./non-by-name/trie { };

  triggercmd = callPackage ./non-by-name/triggercmd { };

  trimesh = callPackage ./non-by-name/trimesh { };

  trino = callPackage ./non-by-name/trino { };

  trio = callPackage ./non-by-name/trio { };

  trio-asyncio = callPackage ./non-by-name/trio-asyncio { };

  trio-typing = callPackage ./non-by-name/trio-typing { };

  trio-websocket = callPackage ./non-by-name/trio-websocket { };

  triton = callPackage ./non-by-name/triton { llvm = pkgs.triton-llvm; };

  triton-bin = callPackage ./non-by-name/triton/bin.nix { };

  triton-cuda = self.triton.override { cudaSupport = true; };

  triton-kernels = callPackage ./non-by-name/triton-kernels { };

  triton-no-cuda = self.triton.override { cudaSupport = false; };

  tritonclient = callPackage ./non-by-name/tritonclient { };

  trl = callPackage ./non-by-name/trl { };

  trlib = toPythonModule (
    pkgs.trlib.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  trmnl = callPackage ./non-by-name/trmnl { };

  troi = callPackage ./non-by-name/troi { };

  troposphere = callPackage ./non-by-name/troposphere { };

  trove-classifiers = callPackage ./non-by-name/trove-classifiers { };

  trsfile = callPackage ./non-by-name/trsfile { };

  trubar = callPackage ./non-by-name/trubar { };

  trueskill = callPackage ./non-by-name/trueskill { };

  truncnorm = callPackage ./non-by-name/truncnorm { };

  trustme = callPackage ./non-by-name/trustme { };

  truststore = callPackage ./non-by-name/truststore { };

  trx-python = callPackage ./non-by-name/trx-python { };

  trytond = callPackage ./non-by-name/trytond { };

  tsfresh = callPackage ./non-by-name/tsfresh { };

  tsid = callPackage ./non-by-name/tsid { inherit (pkgs) tsid; };

  tskit = callPackage ./non-by-name/tskit { };

  tsplib95 = callPackage ./non-by-name/tsplib95 { };

  tstr = callPackage ./non-by-name/tstr { };

  tsv = callPackage ./non-by-name/tsv { };

  tt-flash = callPackage ./non-by-name/tt-flash { };

  tt-perf-report = callPackage ./non-by-name/tt-perf-report { };

  tt-tools-common = callPackage ./non-by-name/tt-tools-common { };

  ttach = callPackage ./non-by-name/ttach { };

  ttconv = callPackage ./non-by-name/ttconv { };

  ttfautohint-py = callPackage ./non-by-name/ttfautohint-py { };

  ttkbootstrap = callPackage ./non-by-name/ttkbootstrap { };

  ttls = callPackage ./non-by-name/ttls { };

  ttn-client = callPackage ./non-by-name/ttn-client { };

  ttnn = callPackage ./non-by-name/ttnn { inherit (pkgs) tt-metal; };

  ttp = callPackage ./non-by-name/ttp { };

  ttp-templates = callPackage ./non-by-name/ttp-templates { };

  ttstokenizer = callPackage ./non-by-name/ttstokenizer { };

  tubes = callPackage ./non-by-name/tubes { };

  tubeup = callPackage ./non-by-name/tubeup { };

  tuf = callPackage ./non-by-name/tuf { };

  tunit = callPackage ./non-by-name/tunit { };

  turbohtml = callPackage ./non-by-name/turbohtml { };

  turnt = callPackage ./non-by-name/turnt { };

  turrishw = callPackage ./non-by-name/turrishw { };

  tuya-device-handlers = callPackage ./non-by-name/tuya-device-handlers { };

  tuya-device-sharing-sdk = callPackage ./non-by-name/tuya-device-sharing-sdk { };

  tuya-iot-py-sdk = callPackage ./non-by-name/tuya-iot-py-sdk { };

  tvdb-api = callPackage ./non-by-name/tvdb-api { };

  tweepy = callPackage ./non-by-name/tweepy { };

  twentemilieu = callPackage ./non-by-name/twentemilieu { };

  twiggy = callPackage ./non-by-name/twiggy { };

  twilio = callPackage ./non-by-name/twilio { };

  twill = callPackage ./non-by-name/twill { };

  twine = callPackage ./non-by-name/twine { };

  twinkly-client = callPackage ./non-by-name/twinkly-client { };

  twisted = callPackage ./non-by-name/twisted { };

  twitch-python = callPackage ./non-by-name/twitch-python { };

  twitchapi = callPackage ./non-by-name/twitchapi { };

  twitterapi = callPackage ./non-by-name/twitterapi { };

  twofish = callPackage ./non-by-name/twofish { };

  twomemo = callPackage ./non-by-name/twomemo { };

  twscrape = callPackage ./non-by-name/twscrape { };

  txaio = callPackage ./non-by-name/txaio { };

  txamqp = callPackage ./non-by-name/txamqp { };

  txdbus = callPackage ./non-by-name/txdbus { };

  txgithub = callPackage ./non-by-name/txgithub { };

  txi2p-tahoe = callPackage ./non-by-name/txi2p-tahoe { };

  txredisapi = callPackage ./non-by-name/txredisapi { };

  txrequests = callPackage ./non-by-name/txrequests { };

  txtai = callPackage ./non-by-name/txtai { sqlite-vec-c = pkgs.sqlite-vec; };

  txtorcon = callPackage ./non-by-name/txtorcon { };

  txzmq = callPackage ./non-by-name/txzmq { };

  ty = callPackage ./non-by-name/ty { inherit (pkgs) ty; };

  typechecks = callPackage ./non-by-name/typechecks { };

  typecode = callPackage ./non-by-name/typecode { };

  typecode-libmagic = callPackage ./non-by-name/typecode/libmagic.nix {
    inherit (pkgs) file zlib;
  };

  typed-argparse = callPackage ./non-by-name/typed-argparse { };

  typed-settings = callPackage ./non-by-name/typed-settings { };

  typedunits = callPackage ./non-by-name/typedunits { };

  typeguard = callPackage ./non-by-name/typeguard { };

  typepy = callPackage ./non-by-name/typepy { };

  typer = callPackage ./non-by-name/typer { };

  typer-config = callPackage ./non-by-name/typer-config { };

  typer-injector = callPackage ./non-by-name/typer-injector { };

  typer-shell = callPackage ./non-by-name/typer-shell { };

  types-aiobotocore = callPackage ./non-by-name/types-aiobotocore { };

  inherit (callPackage ./non-by-name/types-aiobotocore-packages { })
    types-aiobotocore-accessanalyzer
    types-aiobotocore-account
    types-aiobotocore-acm
    types-aiobotocore-acm-pca
    types-aiobotocore-aiops
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
    types-aiobotocore-codeconnections
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
    types-aiobotocore-freetier
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
    types-aiobotocore-networkmonitor
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
    types-aiobotocore-qapps
    types-aiobotocore-qbusiness
    types-aiobotocore-qconnect
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

  types-appdirs = callPackage ./non-by-name/types-appdirs { };

  types-awscrt = callPackage ./non-by-name/types-awscrt { };

  types-beautifulsoup4 = callPackage ./non-by-name/types-beautifulsoup4 { };

  types-certifi = callPackage ./non-by-name/types-certifi { };

  types-click = callPackage ./non-by-name/types-click { };

  types-colorama = callPackage ./non-by-name/types-colorama { };

  types-dataclasses = callPackage ./non-by-name/types-dataclasses { };

  types-decorator = callPackage ./non-by-name/types-decorator { };

  types-deprecated = callPackage ./non-by-name/types-deprecated { };

  types-docopt = callPackage ./non-by-name/types-docopt { };

  types-docutils = callPackage ./non-by-name/types-docutils { };

  types-freezegun = callPackage ./non-by-name/types-freezegun { };

  types-futures = callPackage ./non-by-name/types-futures { };

  types-greenlet = callPackage ./non-by-name/types-greenlet { };

  types-html5lib = callPackage ./non-by-name/types-html5lib { };

  types-ipaddress = callPackage ./non-by-name/types-ipaddress { };

  types-jinja2 = callPackage ./non-by-name/types-jinja2 { };

  types-jsonschema = callPackage ./non-by-name/types-jsonschema { };

  types-lxml = callPackage ./non-by-name/types-lxml { };

  types-markdown = callPackage ./non-by-name/types-markdown { };

  types-markupsafe = callPackage ./non-by-name/types-markupsafe { };

  types-mock = callPackage ./non-by-name/types-mock { };

  types-mysqlclient = callPackage ./non-by-name/types-mysqlclient { };

  types-openpyxl = callPackage ./non-by-name/types-openpyxl { };

  types-paramiko = callPackage ./non-by-name/types-paramiko { };

  types-pillow = callPackage ./non-by-name/types-pillow { };

  types-protobuf = callPackage ./non-by-name/types-protobuf { };

  types-psutil = callPackage ./non-by-name/types-psutil { };

  types-psycopg2 = callPackage ./non-by-name/types-psycopg2 { };

  types-pyasn1 = callPackage ./non-by-name/types-pyasn1 { };

  types-pyopenssl = callPackage ./non-by-name/types-pyopenssl { };

  types-python-dateutil = callPackage ./non-by-name/types-python-dateutil { };

  types-pytz = callPackage ./non-by-name/types-pytz { };

  types-pyyaml = callPackage ./non-by-name/types-pyyaml { };

  types-redis = callPackage ./non-by-name/types-redis { };

  types-regex = callPackage ./non-by-name/types-regex { };

  types-requests = callPackage ./non-by-name/types-requests { };

  types-retry = callPackage ./non-by-name/types-retry { };

  types-s3transfer = callPackage ./non-by-name/types-s3transfer { };

  types-setuptools = callPackage ./non-by-name/types-setuptools { };

  types-six = callPackage ./non-by-name/types-six { };

  types-tabulate = callPackage ./non-by-name/types-tabulate { };

  types-toml = callPackage ./non-by-name/types-toml { };

  types-tqdm = callPackage ./non-by-name/types-tqdm { };

  types-ujson = callPackage ./non-by-name/types-ujson { };

  types-urllib3 = callPackage ./non-by-name/types-urllib3 { };

  types-webencodings = callPackage ./non-by-name/types-webencodings { };

  types-xxhash = callPackage ./non-by-name/types-xxhash { };

  typesense = callPackage ./non-by-name/typesense {
    inherit (pkgs) typesense curl;
  };

  typeshed-client = callPackage ./non-by-name/typeshed-client { };

  typing = null;

  typing-extensions = callPackage ./non-by-name/typing-extensions { };

  typing-inspect = callPackage ./non-by-name/typing-inspect { };

  typing-inspection = callPackage ./non-by-name/typing-inspection { };

  typing-utils = callPackage ./non-by-name/typing-utils { };

  typing-validation = callPackage ./non-by-name/typing-validation { };

  typish = callPackage ./non-by-name/typish { };

  typogrify = callPackage ./non-by-name/typogrify { };

  typst = callPackage ./non-by-name/typst { };

  tyro = callPackage ./non-by-name/tyro { };

  tzdata = callPackage ./non-by-name/tzdata { };

  tzlocal = callPackage ./non-by-name/tzlocal { };

  u-msgpack-python = callPackage ./non-by-name/u-msgpack-python { };

  ua-generator = callPackage ./non-by-name/ua-generator { };

  ua-parser = callPackage ./non-by-name/ua-parser { };

  ua-parser-builtins = callPackage ./non-by-name/ua-parser-builtins { };

  ua-parser-rs = callPackage ./non-by-name/ua-parser-rs { };

  uarray = callPackage ./non-by-name/uarray { };

  uart-devices = callPackage ./non-by-name/uart-devices { };

  uasiren = callPackage ./non-by-name/uasiren { };

  ubelt = callPackage ./non-by-name/ubelt { };

  uc-micro-py = callPackage ./non-by-name/uc-micro-py { };

  ucsmsdk = callPackage ./non-by-name/ucsmsdk { };

  udapi = callPackage ./non-by-name/udapi { };

  udatetime = callPackage ./non-by-name/udatetime { };

  udsoncan = callPackage ./non-by-name/udsoncan { };

  udtools = callPackage ./non-by-name/udtools { };

  ueagle = callPackage ./non-by-name/ueagle { };

  ueberzug = callPackage ./non-by-name/ueberzug {
    inherit (pkgs) libx11 libxext;
  };

  uefi-firmware = callPackage ./non-by-name/uefi-firmware { };

  ufal-chu-liu-edmonds = callPackage ./non-by-name/ufal-chu-liu-edmonds { };

  ufmt = callPackage ./non-by-name/ufmt { };

  ufo-extractor = callPackage ./non-by-name/ufo-extractor { };

  ufo2ft = callPackage ./non-by-name/ufo2ft { };

  ufolib2 = callPackage ./non-by-name/ufolib2 { };

  ufolint = callPackage ./non-by-name/ufolint { };

  ufomerge = callPackage ./non-by-name/ufomerge { };

  ufonormalizer = callPackage ./non-by-name/ufonormalizer { };

  ufoprocessor = callPackage ./non-by-name/ufoprocessor { };

  uharfbuzz = callPackage ./non-by-name/uharfbuzz { };

  uhashring = callPackage ./non-by-name/uhashring { };

  uhi = callPackage ./non-by-name/uhi { };

  uhooapi = callPackage ./non-by-name/uhooapi { };

  uiprotect = callPackage ./non-by-name/uiprotect { };

  ujson = callPackage ./non-by-name/ujson { };

  ukkonen = callPackage ./non-by-name/ukkonen { };

  ukpostcodeparser = callPackage ./non-by-name/ukpostcodeparser { };

  ulid-transform = callPackage ./non-by-name/ulid-transform { };

  ultraheat-api = callPackage ./non-by-name/ultraheat-api { };

  ultralytics = callPackage ./non-by-name/ultralytics { };

  ultralytics-thop = callPackage ./non-by-name/ultralytics-thop { };

  umalqurra = callPackage ./non-by-name/umalqurra { };

  umap-learn = callPackage ./non-by-name/umap-learn { };

  umodbus = callPackage ./non-by-name/umodbus { };

  unasync = callPackage ./non-by-name/unasync { };

  uncalled-for = callPackage ./non-by-name/uncalled-for { };

  uncertainties = callPackage ./non-by-name/uncertainties { };

  unclecode-litellm = callPackage ./non-by-name/unclecode-litellm { };

  uncompresspy = callPackage ./non-by-name/uncompresspy { };

  uncompyle6 = callPackage ./non-by-name/uncompyle6 { };

  undefined = callPackage ./non-by-name/undefined { };

  undetected-chromedriver = callPackage ./non-by-name/undetected-chromedriver { };

  unearth = callPackage ./non-by-name/unearth { };

  uni-curses = callPackage ./non-by-name/uni-curses { };

  unicode-rbnf = callPackage ./non-by-name/unicode-rbnf { };

  unicode-segmentation-rs = callPackage ./non-by-name/unicode-segmentation-rs { };

  unicodecsv = callPackage ./non-by-name/unicodecsv { };

  unicodedata2 = callPackage ./non-by-name/unicodedata2 { };

  unicodeit = callPackage ./non-by-name/unicodeit { };

  unicorn = callPackage ./non-by-name/unicorn { inherit (pkgs) unicorn; };

  unicrypto = callPackage ./non-by-name/unicrypto { };

  unidata-blocks = callPackage ./non-by-name/unidata-blocks { };

  unidecode = callPackage ./non-by-name/unidecode { };

  unidic = callPackage ./non-by-name/unidic { };

  unidic-lite = callPackage ./non-by-name/unidic-lite { };

  unidiff = callPackage ./non-by-name/unidiff { };

  unidns = callPackage ./non-by-name/unidns { };

  unifi-ap = callPackage ./non-by-name/unifi-ap { };

  unifi-discovery = callPackage ./non-by-name/unifi-discovery { };

  unify = callPackage ./non-by-name/unify { };

  unique-log-filter = callPackage ./non-by-name/unique-log-filter { };

  units-llnl = callPackage ./non-by-name/units-llnl {
    inherit (pkgs) units-llnl;
  };

  unittest-xml-reporting = callPackage ./non-by-name/unittest-xml-reporting { };

  univers = callPackage ./non-by-name/univers { };

  universal-pathlib = callPackage ./non-by-name/universal-pathlib { };

  universal-silabs-flasher = callPackage ./non-by-name/universal-silabs-flasher { };

  unix-ar = callPackage ./non-by-name/unix-ar { };

  unpaddedbase64 = callPackage ./non-by-name/unpaddedbase64 { };

  unrar = callPackage ./non-by-name/unrar { inherit (pkgs) unrar; };

  unrardll = callPackage ./non-by-name/unrardll { inherit (pkgs) unrar; };

  unrpa = callPackage ./non-by-name/unrpa { };

  unsloth = callPackage ./non-by-name/unsloth { };

  unsloth-zoo = callPackage ./non-by-name/unsloth-zoo { };

  unstructured = callPackage ./non-by-name/unstructured { };

  unstructured-api-tools = callPackage ./non-by-name/unstructured-api-tools { };

  unstructured-client = callPackage ./non-by-name/unstructured-client { };

  unstructured-inference = callPackage ./non-by-name/unstructured-inference { };

  untangle = callPackage ./non-by-name/untangle { };

  untokenize = callPackage ./non-by-name/untokenize { };

  uonet-request-signer-hebe = callPackage ./non-by-name/uonet-request-signer-hebe { };

  upb-lib = callPackage ./non-by-name/upb-lib { };

  upcloud-api = callPackage ./non-by-name/upcloud-api { };

  update-checker = callPackage ./non-by-name/update-checker { };

  update-copyright = callPackage ./non-by-name/update-copyright { };

  update-dotdee = callPackage ./non-by-name/update-dotdee { };

  uplc = callPackage ./non-by-name/uplc { };

  uplink = callPackage ./non-by-name/uplink { };

  uplink-protobuf = callPackage ./non-by-name/uplink-protobuf { };

  uploadserver = callPackage ./non-by-name/uploadserver { };

  upnpclient = callPackage ./non-by-name/upnpclient { };

  upnpy = callPackage ./non-by-name/upnpy { };

  uproot = callPackage ./non-by-name/uproot { };

  uptime = callPackage ./non-by-name/uptime { };

  uptime-kuma-api = callPackage ./non-by-name/uptime-kuma-api { };

  uptime-kuma-monitor = callPackage ./non-by-name/uptime-kuma-monitor { };

  uqbar = callPackage ./non-by-name/uqbar { };

  uri-template = callPackage ./non-by-name/uri-template { };

  uritemplate = callPackage ./non-by-name/uritemplate { };

  uritools = callPackage ./non-by-name/uritools { };

  url-normalize = callPackage ./non-by-name/url-normalize { };

  urlextract = callPackage ./non-by-name/urlextract { };

  urlgrabber = callPackage ./non-by-name/urlgrabber { };

  urllib3 = callPackage ./non-by-name/urllib3 { };

  urllib3-future = callPackage ./non-by-name/urllib3-future { };

  urlman = callPackage ./non-by-name/urlman { };

  urlmatch = callPackage ./non-by-name/urlmatch { };

  urlobject = callPackage ./non-by-name/urlobject { };

  urlpy = callPackage ./non-by-name/urlpy { };

  urlscan-python = callPackage ./non-by-name/urlscan-python { };

  urwid = callPackage ./non-by-name/urwid { };

  urwid-readline = callPackage ./non-by-name/urwid-readline { };

  urwid-satext = callPackage ./non-by-name/urwid-satext { };

  urwidgets = callPackage ./non-by-name/urwidgets { };

  urwidtrees = callPackage ./non-by-name/urwidtrees { };

  us = callPackage ./non-by-name/us { };

  usb-devices = callPackage ./non-by-name/usb-devices { };

  usb-monitor = callPackage ./non-by-name/usb-monitor { };

  usb-protocol = callPackage ./non-by-name/usb-protocol { };

  usbrelay-py = callPackage ../../os-specific/linux/usbrelay/python.nix { };

  usbtmc = callPackage ./non-by-name/usbtmc { };

  usearch = callPackage ./non-by-name/usearch { };

  useful-types = callPackage ./non-by-name/useful-types { };

  user-agents = callPackage ./non-by-name/user-agents { };

  userpath = callPackage ./non-by-name/userpath { };

  ush = callPackage ./non-by-name/ush { };

  usort = callPackage ./non-by-name/usort { };

  ustreamer = toPythonModule (
    pkgs.ustreamer.override {
      python3Packages = self;
      withPython = true;
    }
  );

  utils = callPackage ./non-by-name/utils { };

  utitools = callPackage ./non-by-name/utitools { };

  uuid-utils = callPackage ./non-by-name/uuid-utils { };

  uuid6 = callPackage ./non-by-name/uuid6 { };

  uv = callPackage ./non-by-name/uv { inherit (pkgs) uv; };

  uv-build = callPackage ./non-by-name/uv-build { };

  uv-dynamic-versioning = callPackage ./non-by-name/uv-dynamic-versioning { };

  uvcclient = callPackage ./non-by-name/uvcclient { };

  uvicorn = callPackage ./non-by-name/uvicorn { };

  uvicorn-worker = callPackage ./non-by-name/uvicorn-worker { };

  uvloop = callPackage ./non-by-name/uvloop { };

  uwsgi-chunked = callPackage ./non-by-name/uwsgi-chunked { };

  uxsim = callPackage ./non-by-name/uxsim { };

  vaa = callPackage ./non-by-name/vaa { };

  vacuum-map-parser-base = callPackage ./non-by-name/vacuum-map-parser-base { };

  vacuum-map-parser-dreame = callPackage ./non-by-name/vacuum-map-parser-dreame { };

  vacuum-map-parser-ijai = callPackage ./non-by-name/vacuum-map-parser-ijai { };

  vacuum-map-parser-roborock = callPackage ./non-by-name/vacuum-map-parser-roborock { };

  vacuum-map-parser-roidmi = callPackage ./non-by-name/vacuum-map-parser-roidmi { };

  vacuum-map-parser-viomi = callPackage ./non-by-name/vacuum-map-parser-viomi { };

  vacuum-map-parser-xiaomi = callPackage ./non-by-name/vacuum-map-parser-xiaomi { };

  valetudo-map-parser = callPackage ./non-by-name/valetudo-map-parser { };

  valhallaapi = callPackage ./non-by-name/valhallaapi { };

  validate-email = callPackage ./non-by-name/validate-email { };

  validate-pyproject = callPackage ./non-by-name/validate-pyproject { };

  validate-pyproject-schema-store = callPackage ./non-by-name/validate-pyproject-schema-store { };

  validator-collection = callPackage ./non-by-name/validator-collection { };

  validators = callPackage ./non-by-name/validators { };

  validobj = callPackage ./non-by-name/validobj { };

  valkey = callPackage ./non-by-name/valkey { };

  vallox-websocket-api = callPackage ./non-by-name/vallox-websocket-api { };

  vapoursynth = callPackage ./non-by-name/vapoursynth { inherit (pkgs) vapoursynth; };

  variants = callPackage ./non-by-name/variants { };

  varint = callPackage ./non-by-name/varint { };

  varlink = callPackage ./non-by-name/varlink { };

  vat-moss = callPackage ./non-by-name/vat-moss { };

  vbuild = callPackage ./non-by-name/vbuild { };

  vcard = callPackage ./non-by-name/vcard { };

  vcrpy = callPackage ./non-by-name/vcrpy { };

  vcs-versioning = callPackage ./non-by-name/vcs-versioning { };

  vcversioner = callPackage ./non-by-name/vcversioner { };

  vdf = callPackage ./non-by-name/vdf { };

  vdirsyncer = callPackage ./non-by-name/vdirsyncer { };

  vector = callPackage ./non-by-name/vector { };

  vega = callPackage ./non-by-name/vega { };

  vega-datasets = callPackage ./non-by-name/vega-datasets { };

  vegafusion = callPackage ./non-by-name/vegafusion { };

  vegehub = callPackage ./non-by-name/vegehub { };

  vehicle = callPackage ./non-by-name/vehicle { };

  velbus-aio = callPackage ./non-by-name/velbus-aio { };

  venstarcolortouch = callPackage ./non-by-name/venstarcolortouch { };

  venusian = callPackage ./non-by-name/venusian { };

  verboselogs = callPackage ./non-by-name/verboselogs { };

  verilogae = callPackage ./non-by-name/verilogae { };

  verlib2 = callPackage ./non-by-name/verlib2 { };

  vermin = callPackage ./non-by-name/vermin { };

  versioneer = callPackage ./non-by-name/versioneer { };

  versionfinder = callPackage ./non-by-name/versionfinder { };

  versioningit = callPackage ./non-by-name/versioningit { };

  versiontag = callPackage ./non-by-name/versiontag { };

  versiontools = callPackage ./non-by-name/versiontools { };

  verspec = callPackage ./non-by-name/verspec { };

  vertica-python = callPackage ./non-by-name/vertica-python { };

  veryprettytable = callPackage ./non-by-name/veryprettytable { };

  vfblib = callPackage ./non-by-name/vfblib { };

  vg = callPackage ./non-by-name/vg { };

  vharfbuzz = callPackage ./non-by-name/vharfbuzz { };

  viaggiatreno-ha = callPackage ./non-by-name/viaggiatreno-ha { };

  victron-ble = callPackage ./non-by-name/victron-ble { };

  victron-ble-ha-parser = callPackage ./non-by-name/victron-ble-ha-parser { };

  victron-mqtt = callPackage ./non-by-name/victron-mqtt { };

  victron-vrm = callPackage ./non-by-name/victron-vrm { };

  videocr = callPackage ./non-by-name/videocr { };

  vidstab = callPackage ./non-by-name/vidstab { };

  viennarna = toPythonModule (pkgs.viennarna.override { python3 = self.python; });

  viewstate = callPackage ./non-by-name/viewstate { };

  vilfo-api-client = callPackage ./non-by-name/vilfo-api-client { };

  vina = callPackage ../../by-name/au/autodock-vina/python-bindings.nix { };

  vincenty = callPackage ./non-by-name/vincenty { };

  vine = callPackage ./non-by-name/vine { };

  virt-firmware = callPackage ./non-by-name/virt-firmware { };

  virtual-glob = callPackage ./non-by-name/virtual-glob { };

  virtualenv = callPackage ./non-by-name/virtualenv { };

  virtualenv-clone = callPackage ./non-by-name/virtualenv-clone { };

  virtualenvwrapper = callPackage ./non-by-name/virtualenvwrapper { };

  viser = callPackage ./non-by-name/viser { };

  visionpluspython = callPackage ./non-by-name/visionpluspython { };

  visions = callPackage ./non-by-name/visions { };

  visitor = callPackage ./non-by-name/visitor { };

  vispy = callPackage ./non-by-name/vispy { };

  viv-utils = callPackage ./non-by-name/viv-utils { };

  vivisect = callPackage ./non-by-name/vivisect {
    inherit (pkgs.libsForQt5) wrapQtAppsHook;
  };

  vizaio = callPackage ./non-by-name/vizaio { };

  vl-convert-python = callPackage ./non-by-name/vl-convert-python {
    inherit (pkgs) protobuf;
  };

  vllm = callPackage ./non-by-name/vllm { inherit (pkgs) zstd; };

  vllm-tt-plugin = callPackage ./non-by-name/vllm-tt-plugin { };

  vmas = callPackage ./non-by-name/vmas { };

  vmprof = callPackage ./non-by-name/vmprof { };

  vncdotool = callPackage ./non-by-name/vncdotool { };

  vnoise = callPackage ./non-by-name/vnoise { };

  vobject = callPackage ./non-by-name/vobject { };

  vodozemac = callPackage ./non-by-name/vodozemac { };

  voip-utils = callPackage ./non-by-name/voip-utils { };

  volatile = callPackage ./non-by-name/volatile { };

  volkszaehler = callPackage ./non-by-name/volkszaehler { };

  voluptuous = callPackage ./non-by-name/voluptuous { };

  voluptuous-openapi = callPackage ./non-by-name/voluptuous-openapi { };

  voluptuous-serialize = callPackage ./non-by-name/voluptuous-serialize { };

  voluptuous-stubs = callPackage ./non-by-name/voluptuous-stubs { };

  volvocarsapi = callPackage ./non-by-name/volvocarsapi { };

  vowpalwabbit = callPackage ./non-by-name/vowpalwabbit { };

  vpk = callPackage ./non-by-name/vpk { };

  vprof = callPackage ./non-by-name/vprof { };

  vsts = callPackage ./non-by-name/vsts { };

  vsts-cd-manager = callPackage ./non-by-name/vsts-cd-manager { };

  vsure = callPackage ./non-by-name/vsure { };

  vt-py = callPackage ./non-by-name/vt-py { };

  vtherm-api = callPackage ./non-by-name/vtherm-api { };

  vtjp = callPackage ./non-by-name/vtjp { };

  vtk = toPythonModule (
    pkgs.vtk.override {
      pythonSupport = true;
      python3Packages = self;
    }
  );

  vtracer = callPackage ./non-by-name/vtracer { };

  vttlib = callPackage ./non-by-name/vttlib { };

  vulkan = callPackage ./non-by-name/vulkan { };

  vulners = callPackage ./non-by-name/vulners { };

  vultr = callPackage ./non-by-name/vultr { };

  vulture = callPackage ./non-by-name/vulture { };

  vyper = callPackage ../../development/compilers/vyper { };

  w1thermsensor = callPackage ./non-by-name/w1thermsensor { };

  w3lib = callPackage ./non-by-name/w3lib { };

  wacz = callPackage ./non-by-name/wacz { };

  wadler-lindig = callPackage ./non-by-name/wadler-lindig { };

  wadllib = callPackage ./non-by-name/wadllib { };

  wagtail = callPackage ./non-by-name/wagtail { };

  wagtail-factories = callPackage ./non-by-name/wagtail-factories { };

  wagtail-localize = callPackage ./non-by-name/wagtail-localize { };

  wagtail-modeladmin = callPackage ./non-by-name/wagtail-modeladmin { };

  waitress = callPackage ./non-by-name/waitress { };

  waitress-django = callPackage ./non-by-name/waitress-django { };

  wakeonlan = callPackage ./non-by-name/wakeonlan { };

  wallbox = callPackage ./non-by-name/wallbox { };

  wallet-py3k = callPackage ./non-by-name/wallet-py3k { };

  walrus = callPackage ./non-by-name/walrus { };

  wand = callPackage ./non-by-name/wand { };

  wandb = callPackage ./non-by-name/wandb { };

  wapiti-arsenic = callPackage ./non-by-name/wapiti-arsenic { };

  wapiti-swagger = callPackage ./non-by-name/wapiti-swagger { };

  waqiasync = callPackage ./non-by-name/waqiasync { };

  warble = callPackage ./non-by-name/warble { };

  warcio = callPackage ./non-by-name/warcio { };

  ward = callPackage ./non-by-name/ward { };

  warlock = callPackage ./non-by-name/warlock { };

  warp-lang = callPackage ./non-by-name/warp-lang {
    # warp targets LLVM 22 in its build-from-source path (build_llvm.py clones llvmorg-22.x)
    stdenv = if stdenv.hostPlatform.isDarwin then pkgs.llvmPackages_22.stdenv else pkgs.stdenv;
    llvmPackages = pkgs.llvmPackages_22;
  };

  warp-nn = callPackage ./non-by-name/warp-nn { };

  warrant = callPackage ./non-by-name/warrant { };

  warrant-lite = callPackage ./non-by-name/warrant-lite { };

  wasabi = callPackage ./non-by-name/wasabi { };

  wasm-tools = callPackage ./non-by-name/wasm-tools { inherit (pkgs) jq; };

  inherit (self.wasmerPackages)
    wasmer
    wasmer-compiler-cranelift
    wasmer-compiler-llvm
    wasmer-compiler-singlepass
    ;

  wasmerPackages = lib.recurseIntoAttrs (callPackage ./non-by-name/wasmer { });

  wasmtime = callPackage ../../by-name/wa/wasmtime/python.nix { };

  wasserstein = callPackage ./non-by-name/wasserstein { };

  wassima = callPackage ./non-by-name/wassima { };

  wat = callPackage ./non-by-name/wat { };

  watchdog = callPackage ./non-by-name/watchdog { };

  watchdog-gevent = callPackage ./non-by-name/watchdog-gevent { };

  watchfiles = callPackage ./non-by-name/watchfiles { };

  watchgod = callPackage ./non-by-name/watchgod { };

  waterfurnace = callPackage ./non-by-name/waterfurnace { };

  watergate-local-api = callPackage ./non-by-name/watergate-local-api { };

  watermark = callPackage ./non-by-name/watermark { };

  wavedrom = callPackage ./non-by-name/wavedrom { };

  wavefile = callPackage ./non-by-name/wavefile { };

  wavinsentio = callPackage ./non-by-name/wavinsentio { };

  waybackpy = callPackage ./non-by-name/waybackpy { };

  waymax = callPackage ./non-by-name/waymax { };

  wazeroutecalculator = callPackage ./non-by-name/wazeroutecalculator { };

  wcag-contrast-ratio = callPackage ./non-by-name/wcag-contrast-ratio { };

  wcmatch = callPackage ./non-by-name/wcmatch { };

  wcwidth = callPackage ./non-by-name/wcwidth { };

  weasel = callPackage ./non-by-name/weasel { };

  weasyprint = callPackage ./non-by-name/weasyprint { };

  weatherflow4py = callPackage ./non-by-name/weatherflow4py { };

  weaviate-client = callPackage ./non-by-name/weaviate-client { };

  web = callPackage ./non-by-name/web { };

  web-cache = callPackage ./non-by-name/web-cache { };

  web3 = callPackage ./non-by-name/web3 { };

  webargs = callPackage ./non-by-name/webargs { };

  webassets = callPackage ./non-by-name/webassets { };

  webauthn = callPackage ./non-by-name/webauthn { };

  webcolors = callPackage ./non-by-name/webcolors { };

  webdataset = callPackage ./non-by-name/webdataset { };

  webdav4 = callPackage ./non-by-name/webdav4 { };

  webdavclient3 = callPackage ./non-by-name/webdavclient3 { };

  webdriver-manager = callPackage ./non-by-name/webdriver-manager { };

  webencodings = callPackage ./non-by-name/webencodings { };

  webexpythonsdk = callPackage ./non-by-name/webexpythonsdk { };

  webexteamssdk = callPackage ./non-by-name/webexteamssdk { };

  webidl = callPackage ./non-by-name/webidl { };

  webio-api = callPackage ./non-by-name/webio-api { };

  weblate-fonts = callPackage ./non-by-name/weblate-fonts { };

  weblate-language-data = callPackage ./non-by-name/weblate-language-data { };

  weblate-schemas = callPackage ./non-by-name/weblate-schemas { };

  webmin-xmlrpc = callPackage ./non-by-name/webmin-xmlrpc { };

  webob = callPackage ./non-by-name/webob { };

  webrtc-models = callPackage ./non-by-name/webrtc-models { };

  webrtc-noise-gain = callPackage ./non-by-name/webrtc-noise-gain { };

  webrtcvad = callPackage ./non-by-name/webrtcvad { };

  websocket-client = callPackage ./non-by-name/websocket-client { };

  websockets = callPackage ./non-by-name/websockets { };

  websockify = callPackage ./non-by-name/websockify { };

  webssh = callPackage ./non-by-name/webssh { };

  webtest = callPackage ./non-by-name/webtest { };

  webtest-aiohttp = callPackage ./non-by-name/webtest-aiohttp { };

  webthing = callPackage ./non-by-name/webthing { };

  webthing-ws = callPackage ./non-by-name/webthing-ws { };

  weconnect = callPackage ./non-by-name/weconnect { };

  weconnect-mqtt = callPackage ./non-by-name/weconnect-mqtt { };

  weheat = callPackage ./non-by-name/weheat { };

  werkzeug = callPackage ./non-by-name/werkzeug { };

  west = callPackage ./non-by-name/west { };

  wfuzz = callPackage ./non-by-name/wfuzz { };

  wget = callPackage ./non-by-name/wget { };

  wgpu = callPackage ./non-by-name/wgpu { };

  whatthepatch = callPackage ./non-by-name/whatthepatch { };

  wheel = callPackage ./non-by-name/wheel { };

  wheel-filename = callPackage ./non-by-name/wheel-filename { };

  wheel-inspect = callPackage ./non-by-name/wheel-inspect { };

  wheezy-captcha = callPackage ./non-by-name/wheezy-captcha { };

  wheezy-template = callPackage ./non-by-name/wheezy-template { };

  whenever = callPackage ./non-by-name/whenever { };

  whey = callPackage ./non-by-name/whey { };

  whey-pth = callPackage ./non-by-name/whey-pth { };

  whichcraft = callPackage ./non-by-name/whichcraft { };

  whirlpool-sixth-sense = callPackage ./non-by-name/whirlpool-sixth-sense { };

  whisper = callPackage ./non-by-name/whisper { };

  whispers = callPackage ./non-by-name/whispers { };

  whisperx = callPackage ./non-by-name/whisperx {
    ffmpeg = pkgs.ffmpeg-headless;
    ctranslate2-cpp = pkgs.ctranslate2;
  };

  whitenoise = callPackage ./non-by-name/whitenoise { };

  whodap = callPackage ./non-by-name/whodap { };

  whois-api = callPackage ./non-by-name/whois-api { };

  whoisdomain = callPackage ./non-by-name/whoisdomain { };

  whool = callPackage ./non-by-name/whool { };

  whoosh = callPackage ./non-by-name/whoosh { };

  whoosh-compat = callPackage ./non-by-name/whoosh-compat { };

  whoosh-reloaded = callPackage ./non-by-name/whoosh-reloaded { };

  widgetsnbextension = callPackage ./non-by-name/widgetsnbextension { };

  widlparser = callPackage ./non-by-name/widlparser { };

  wiffi = callPackage ./non-by-name/wiffi { };

  wifi = callPackage ./non-by-name/wifi { };

  wiim = callPackage ./non-by-name/wiim { };

  wikipedia = callPackage ./non-by-name/wikipedia { };

  wikipedia-api = callPackage ./non-by-name/wikipedia-api { };

  wikipedia2vec = callPackage ./non-by-name/wikipedia2vec { };

  wikitextparser = callPackage ./non-by-name/wikitextparser { };

  wikitextprocessor = callPackage ./non-by-name/wikitextprocessor { };

  wiktextract = callPackage ./non-by-name/wiktextract { };

  willow = callPackage ./non-by-name/willow { };

  winacl = callPackage ./non-by-name/winacl { };

  winsspi = callPackage ./non-by-name/winsspi { };

  wirelesstagpy = callPackage ./non-by-name/wirelesstagpy { };

  wirerope = callPackage ./non-by-name/wirerope { };

  withings-api = callPackage ./non-by-name/withings-api { };

  withings-sync = callPackage ./non-by-name/withings-sync { };

  wktutils = callPackage ./non-by-name/wktutils { };

  wled = callPackage ./non-by-name/wled { };

  wn = callPackage ./non-by-name/wn { };

  wokkel = callPackage ./non-by-name/wokkel { };

  wolf-comm = callPackage ./non-by-name/wolf-comm { };

  woob = callPackage ./non-by-name/woob { };

  woodblock = callPackage ./non-by-name/woodblock { };

  word2number = callPackage ./non-by-name/word2number { };

  wordcloud = callPackage ./non-by-name/wordcloud { };

  wordfreq = callPackage ./non-by-name/wordfreq { };

  wordninja = callPackage ./non-by-name/wordninja { };

  world-bank-data = callPackage ./non-by-name/world-bank-data { };

  wrapcco = callPackage ./non-by-name/wrapcco { };

  wrapio = callPackage ./non-by-name/wrapio { };

  wrapt = callPackage ./non-by-name/wrapt { };

  wrf-python = callPackage ./non-by-name/wrf-python { };

  ws4py = callPackage ./non-by-name/ws4py { };

  wsdiscovery = callPackage ./non-by-name/wsdiscovery { };

  wsdot = callPackage ./non-by-name/wsdot { };

  wsgi-intercept = callPackage ./non-by-name/wsgi-intercept { };

  wsgidav = callPackage ./non-by-name/wsgidav { };

  wsgiprox = callPackage ./non-by-name/wsgiprox { };

  wsgiproxy2 = callPackage ./non-by-name/wsgiproxy2 { };

  wsgitools = callPackage ./non-by-name/wsgitools { };

  wslink = callPackage ./non-by-name/wslink { };

  wsme = callPackage ./non-by-name/wsme { };

  wsproto = callPackage ./non-by-name/wsproto { };

  wtf-peewee = callPackage ./non-by-name/wtf-peewee { };

  wtforms = callPackage ./non-by-name/wtforms { };

  wtforms-bootstrap5 = callPackage ./non-by-name/wtforms-bootstrap5 { };

  wtforms-htmx = callPackage ./non-by-name/wtforms-htmx { };

  wtforms-htmx-components = callPackage ./non-by-name/wtforms-htmx-components { };

  wtforms-sqlalchemy = callPackage ./non-by-name/wtforms-sqlalchemy { };

  wtforms_3_3 = callPackage ./non-by-name/wtforms/3_3.nix { };

  wunsen = callPackage ./non-by-name/wunsen { };

  wurlitzer = callPackage ./non-by-name/wurlitzer { };

  wxpython = callPackage ./non-by-name/wxpython/4.2.nix {
    wxGTK = pkgs.wxwidgets_3_2.override { withWebKit = true; };
  };

  wxpython_4_3 = callPackage ./non-by-name/wxpython/4.3.nix { };

  wyoming = callPackage ./non-by-name/wyoming { };

  x-transformers = callPackage ./non-by-name/x-transformers { };

  x-wr-timezone = callPackage ./non-by-name/x-wr-timezone { };

  x11-hash = callPackage ./non-by-name/x11-hash { };

  x256 = callPackage ./non-by-name/x256 { };

  x3dh = callPackage ./non-by-name/x3dh { };

  x690 = callPackage ./non-by-name/x690 { };

  xapian = callPackage ./non-by-name/xapian { inherit (pkgs) xapian; };

  xarray = callPackage ./non-by-name/xarray { };

  xarray-dataclass = callPackage ./non-by-name/xarray-dataclass { };

  xarray-dataclasses = callPackage ./non-by-name/xarray-dataclasses { };

  xarray-einstats = callPackage ./non-by-name/xarray-einstats { };

  xattr = callPackage ./non-by-name/xattr { };

  xboxapi = callPackage ./non-by-name/xboxapi { };

  xcffib = callPackage ./non-by-name/xcffib { };

  xclim = callPackage ./non-by-name/xclim { };

  xdg = callPackage ./non-by-name/xdg { };

  xdg-base-dirs = callPackage ./non-by-name/xdg-base-dirs { };

  xdis = callPackage ./non-by-name/xdis { };

  xdoctest = callPackage ./non-by-name/xdoctest { };

  xdot = callPackage ./non-by-name/xdot { inherit (pkgs) graphviz; };

  xdxf2html = callPackage ./non-by-name/xdxf2html { };

  xeddsa = toPythonModule (callPackage ./non-by-name/xeddsa { });

  xeger = callPackage ./non-by-name/xeger { };

  xen = toPythonModule (pkgs.xen.override { python3Packages = self; });

  xformers = callPackage ./non-by-name/xformers { };

  xgboost = callPackage ./non-by-name/xgboost { inherit (pkgs) xgboost; };

  xgrammar = callPackage ./non-by-name/xgrammar { };

  xhtml2pdf = callPackage ./non-by-name/xhtml2pdf { };

  xiaomi-ble = callPackage ./non-by-name/xiaomi-ble { };

  xiaomi-weather = callPackage ./non-by-name/xiaomi-weather { };

  xkbcommon = callPackage ./non-by-name/xkbcommon { };

  xkcdpass = callPackage ./non-by-name/xkcdpass { };

  xknx = callPackage ./non-by-name/xknx { };

  xknxproject = callPackage ./non-by-name/xknxproject { };

  xlrd = callPackage ./non-by-name/xlrd { };

  xlsx2csv = callPackage ./non-by-name/xlsx2csv { };

  xlsxwriter = callPackage ./non-by-name/xlsxwriter { };

  xlwt = callPackage ./non-by-name/xlwt { };

  xmind = callPackage ./non-by-name/xmind { };

  xml-marshaller = callPackage ./non-by-name/xml-marshaller { };

  xml2rfc = callPackage ./non-by-name/xml2rfc { };

  xmldiff = callPackage ./non-by-name/xmldiff { };

  xmljson = callPackage ./non-by-name/xmljson { };

  xmlschema = callPackage ./non-by-name/xmlschema { };

  xmlsec = callPackage ./non-by-name/xmlsec {
    inherit (pkgs)
      libxslt
      libxml2
      libtool
      pkg-config
      xmlsec
      ;
  };

  xmltodict = callPackage ./non-by-name/xmltodict { };

  xmltojson = callPackage ./non-by-name/xmltojson { };

  xmod = callPackage ./non-by-name/xmod { };

  xmodem = callPackage ./non-by-name/xmodem { };

  xmpppy = callPackage ./non-by-name/xmpppy { };

  xnat = callPackage ./non-by-name/xnat { };

  xnd = callPackage ./non-by-name/xnd { };

  xonsh = callPackage ../../by-name/xo/xonsh/unwrapped.nix { };

  xpath-expressions = callPackage ./non-by-name/xpath-expressions { };

  xpybutil = callPackage ./non-by-name/xpybutil { };

  xrootd = callPackage ./non-by-name/xrootd { inherit (pkgs) xrootd; };

  xs1-api-client = callPackage ./non-by-name/xs1-api-client { };

  xsdata = callPackage ./non-by-name/xsdata { };

  xsdata-pydantic = callPackage ./non-by-name/xsdata-pydantic { };

  xstatic = callPackage ./non-by-name/xstatic { };

  xstatic-asciinema-player = callPackage ./non-by-name/xstatic-asciinema-player { };

  xstatic-bootbox = callPackage ./non-by-name/xstatic-bootbox { };

  xstatic-bootstrap = callPackage ./non-by-name/xstatic-bootstrap { };

  xstatic-font-awesome = callPackage ./non-by-name/xstatic-font-awesome { };

  xstatic-jquery = callPackage ./non-by-name/xstatic-jquery { };

  xstatic-jquery-file-upload = callPackage ./non-by-name/xstatic-jquery-file-upload { };

  xstatic-jquery-ui = callPackage ./non-by-name/xstatic-jquery-ui { };

  xstatic-pygments = callPackage ./non-by-name/xstatic-pygments { };

  xtensor-python = callPackage ./non-by-name/xtensor-python { };

  xvfbwrapper = callPackage ./non-by-name/xvfbwrapper { };

  xxhash = callPackage ./non-by-name/xxhash { };

  xyzservices = callPackage ./non-by-name/xyzservices { };

  yabadaba = callPackage ./non-by-name/yabadaba { };

  yacs = callPackage ./non-by-name/yacs { };

  yagrc = callPackage ./non-by-name/yagrc { };

  yalesmartalarmclient = callPackage ./non-by-name/yalesmartalarmclient { };

  yalexs = callPackage ./non-by-name/yalexs { };

  yalexs-ble = callPackage ./non-by-name/yalexs-ble { };

  yamale = callPackage ./non-by-name/yamale { };

  yamlcore = callPackage ./non-by-name/yamlcore { };

  yamlfix = callPackage ./non-by-name/yamlfix { };

  yamllint = callPackage ./non-by-name/yamllint { };

  yamlloader = callPackage ./non-by-name/yamlloader { };

  yamlordereddictloader = callPackage ./non-by-name/yamlordereddictloader { };

  yangson = callPackage ./non-by-name/yangson { };

  yapf = callPackage ./non-by-name/yapf { };

  yappi = callPackage ./non-by-name/yappi { };

  yapsy = callPackage ./non-by-name/yapsy { };

  yara-python = callPackage ./non-by-name/yara-python { };

  yara-x = callPackage ./non-by-name/yara-x { };

  yaramod = callPackage ./non-by-name/yaramod { };

  yardstick = callPackage ./non-by-name/yardstick { };

  yarg = callPackage ./non-by-name/yarg { };

  yargy = callPackage ./non-by-name/yargy { };

  yark = callPackage ./non-by-name/yark { };

  yarl = callPackage ./non-by-name/yarl { };

  yaspin = callPackage ./non-by-name/yaspin { };

  yaswfp = callPackage ./non-by-name/yaswfp { };

  yattag = callPackage ./non-by-name/yattag { };

  yaxmldiff = callPackage ./non-by-name/yaxmldiff { };

  ydata-profiling = callPackage ./non-by-name/ydata-profiling { };

  ydiff = callPackage ./non-by-name/ydiff { };

  yeelight = callPackage ./non-by-name/yeelight { };

  yeelightsunflower = callPackage ./non-by-name/yeelightsunflower { };

  yfinance = callPackage ./non-by-name/yfinance { };

  yoda = toPythonModule (pkgs.yoda.override { python3 = python; });

  yolink-api = callPackage ./non-by-name/yolink-api { };

  yosys = toPythonModule (pkgs.yosys.override { python3 = python; });

  yoto-api = callPackage ./non-by-name/yoto-api { };

  youless-api = callPackage ./non-by-name/youless-api { };

  yourdfpy = callPackage ./non-by-name/yourdfpy { };

  youseedee = callPackage ./non-by-name/youseedee { };

  youtokentome = callPackage ./non-by-name/youtokentome { };

  youtube-search = callPackage ./non-by-name/youtube-search { };

  youtube-search-python = callPackage ./non-by-name/youtube-search-python { };

  youtube-transcript-api = callPackage ./non-by-name/youtube-transcript-api { };

  youtubeaio = callPackage ./non-by-name/youtubeaio { };

  yowsup = callPackage ./non-by-name/yowsup { };

  yoyo-migrations = callPackage ./non-by-name/yoyo-migrations { };

  yq = callPackage ./non-by-name/yq { inherit (pkgs) jq; };

  yt-dlp = toPythonModule (pkgs.yt-dlp.override { python3Packages = self; });

  yt-dlp-dearrow = callPackage ./non-by-name/yt-dlp-dearrow { };

  yt-dlp-ejs = callPackage ./non-by-name/yt-dlp-ejs { };

  yt-dlp-light = toPythonModule (pkgs.yt-dlp-light.override { python3Packages = self; });

  yte = callPackage ./non-by-name/yte { };

  ytmusicapi = callPackage ./non-by-name/ytmusicapi { };

  yubico = callPackage ./non-by-name/yubico { };

  yubico-client = callPackage ./non-by-name/yubico-client { };

  z3-solver = (toPythonModule (pkgs.z3.override { python3Packages = self; })).python;

  z3c-checkversions = callPackage ./non-by-name/z3c-checkversions { };

  zabbix-utils = callPackage ./non-by-name/zabbix-utils { };

  zalgolib = callPackage ./non-by-name/zalgolib { };

  zamg = callPackage ./non-by-name/zamg { };

  zammad-py = callPackage ./non-by-name/zammad-py { };

  zapf = callPackage ./non-by-name/zapf { };

  zaproxy = callPackage ./non-by-name/zaproxy { };

  zarr = callPackage ./non-by-name/zarr { };

  zbar = callPackage ./non-by-name/zbar { };

  zc-buildout = callPackage ./non-by-name/zc-buildout { };

  zc-lockfile = callPackage ./non-by-name/zc-lockfile { };

  zcbor = callPackage ./non-by-name/zcbor { };

  zcc-helper = callPackage ./non-by-name/zcc-helper { };

  zconfig = callPackage ./non-by-name/zconfig { };

  zdaemon = callPackage ./non-by-name/zdaemon { };

  zeek = (toPythonModule (pkgs.zeek.broker.override { python3 = python; })).py;

  zeep = callPackage ./non-by-name/zeep { };

  zeitgeist = (toPythonModule (pkgs.zeitgeist.override { python3 = python; })).py;

  zenlog = callPackage ./non-by-name/zenlog { };

  zenoh = callPackage ./non-by-name/zenoh { };

  zensical = callPackage ./non-by-name/zensical { };

  zephyr-python-api = callPackage ./non-by-name/zephyr-python-api { };

  zephyr-test-management = callPackage ./non-by-name/zephyr-test-management { };

  zeroc-ice = callPackage ./non-by-name/zeroc-ice { };

  zeroconf = callPackage ./non-by-name/zeroconf { };

  zerorpc = callPackage ./non-by-name/zerorpc { };

  zeversolar = callPackage ./non-by-name/zeversolar { };

  zfec = callPackage ./non-by-name/zfec { };

  zha = callPackage ./non-by-name/zha { };

  zha-quirks = callPackage ./non-by-name/zha-quirks { };

  zhon = callPackage ./non-by-name/zhon { };

  zhong-hong-hvac = callPackage ./non-by-name/zhong-hong-hvac { };

  ziafont = callPackage ./non-by-name/ziafont { };

  ziamath = callPackage ./non-by-name/ziamath { };

  zict = callPackage ./non-by-name/zict { };

  ziggo-mediabox-xl = callPackage ./non-by-name/ziggo-mediabox-xl { };

  zigpy = callPackage ./non-by-name/zigpy { };

  zigpy-cc = callPackage ./non-by-name/zigpy-cc { };

  zigpy-deconz = callPackage ./non-by-name/zigpy-deconz { };

  zigpy-xbee = callPackage ./non-by-name/zigpy-xbee { };

  zigpy-zboss = callPackage ./non-by-name/zigpy-zboss { };

  zigpy-zigate = callPackage ./non-by-name/zigpy-zigate { };

  zigpy-ziggurat = callPackage ./non-by-name/zigpy-ziggurat { };

  zigpy-znp = callPackage ./non-by-name/zigpy-znp { };

  zimports = callPackage ./non-by-name/zimports { };

  zinvolt = callPackage ./non-by-name/zinvolt { };

  zipfile-inflate64 = callPackage ./non-by-name/zipfile-inflate64 { };

  zipfile2 = callPackage ./non-by-name/zipfile2 { };

  zipp = callPackage ./non-by-name/zipp { };

  zipremove = callPackage ./non-by-name/zipremove { };

  zipstream-ng = callPackage ./non-by-name/zipstream-ng { };

  zlib-ng = callPackage ./non-by-name/zlib-ng { inherit (pkgs) zlib-ng; };

  zm-py = callPackage ./non-by-name/zm-py { };

  zmqtt = callPackage ./non-by-name/zmqtt { };

  zodb = callPackage ./non-by-name/zodb { };

  zodbpickle = callPackage ./non-by-name/zodbpickle { };

  zope-cachedescriptors = callPackage ./non-by-name/zope-cachedescriptors { };

  zope-component = callPackage ./non-by-name/zope-component { };

  zope-configuration = callPackage ./non-by-name/zope-configuration { };

  zope-contenttype = callPackage ./non-by-name/zope-contenttype { };

  zope-copy = callPackage ./non-by-name/zope-copy { };

  zope-deferredimport = callPackage ./non-by-name/zope-deferredimport { };

  zope-deprecation = callPackage ./non-by-name/zope-deprecation { };

  zope-dottedname = callPackage ./non-by-name/zope-dottedname { };

  zope-event = callPackage ./non-by-name/zope-event { };

  zope-exceptions = callPackage ./non-by-name/zope-exceptions { };

  zope-filerepresentation = callPackage ./non-by-name/zope-filerepresentation { };

  zope-hookable = callPackage ./non-by-name/zope-hookable { };

  zope-i18nmessageid = callPackage ./non-by-name/zope-i18nmessageid { };

  zope-index = callPackage ./non-by-name/zope-index { };

  zope-interface = callPackage ./non-by-name/zope-interface { };

  zope-lifecycleevent = callPackage ./non-by-name/zope-lifecycleevent { };

  zope-location = callPackage ./non-by-name/zope-location { };

  zope-proxy = callPackage ./non-by-name/zope-proxy { };

  zope-schema = callPackage ./non-by-name/zope-schema { };

  zope-security = callPackage ./non-by-name/zope-security { };

  zope-size = callPackage ./non-by-name/zope-size { };

  zope-testbrowser = callPackage ./non-by-name/zope-testbrowser { };

  zope-testing = callPackage ./non-by-name/zope-testing { };

  zope-testrunner = callPackage ./non-by-name/zope-testrunner { };

  zopfli = callPackage ./non-by-name/zopfli { inherit (pkgs) zopfli; };

  zpp = callPackage ./non-by-name/zpp { };

  zstandard = callPackage ./non-by-name/zstandard { };

  zstd = callPackage ./non-by-name/zstd { inherit (pkgs) zstd; };

  zulip = callPackage ./non-by-name/zulip { };

  zulip-emoji-mapping = callPackage ./non-by-name/zulip-emoji-mapping { };

  zundler = callPackage ./non-by-name/zundler { };

  zwave-js-server-python = callPackage ./non-by-name/zwave-js-server-python { };

  zwave-me-ws = callPackage ./non-by-name/zwave-me-ws { };

  zxcvbn = callPackage ./non-by-name/zxcvbn { };

  zxcvbn-rs-py = callPackage ./non-by-name/zxcvbn-rs-py { };

  zxing-cpp = callPackage ./non-by-name/zxing-cpp { libzxing-cpp = pkgs.zxing-cpp; };

  # keep-sorted end
}
