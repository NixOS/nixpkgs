{ pkgs, callPackage, callPackages, buildEnv, lowPrio, recurseIntoAttrs
, nodePackages, perlPackages, pythonPackages }:

rec {

  andagii = callPackage ../data/fonts/andagii { };

  anonymous-pro = callPackage ../data/fonts/anonymous-pro { };

  arkpandora-ttf = callPackage ../data/fonts/arkpandora { };

  aurulent-sans = callPackage ../data/fonts/aurulent-sans { };

  baekmuk-ttf = callPackage ../data/fonts/baekmuk-ttf { };

  bakoma-ttf = callPackage ../data/fonts/bakoma-ttf { };

  cabin = callPackage ../data/fonts/cabin { };

  caladea = callPackage ../data/fonts/caladea {};

  cantarell = callPackage ../data/fonts/cantarell-fonts { };

  carlito = callPackage ../data/fonts/carlito {};

  comfortaa = callPackage ../data/fonts/comfortaa {};

  comic-neue = callPackage ../data/fonts/comic-neue { };

  comic-relief = callPackage ../data/fonts/comic-relief {};

  corefonts = callPackage ../data/fonts/corefonts { };

  culmus = callPackage ../data/fonts/culmus { };

  clearlyU = callPackage ../data/fonts/clearlyU { };

  cm-unicode = callPackage ../data/fonts/cm-unicode {};

  crimson = callPackage ../data/fonts/crimson {};

  dejavu = lowPrio (callPackage ../data/fonts/dejavu-fonts {
    inherit (perlPackages) FontTTF;
  });

  # solve collision for nix-env before https://github.com/NixOS/nix/pull/815
  dejavu_fontsEnv = buildEnv {
    name = "${dejavu.name}";
    paths = [ dejavu.out ];
  };

  dina-font = callPackage ../data/fonts/dina { };

  dina-font-pcf = callPackage ../data/fonts/dina-pcf { };

  dosis = callPackage ../data/fonts/dosis { };

  dosemu = callPackage ../data/fonts/dosemu-fonts { };

  eb-garamond = callPackage ../data/fonts/eb-garamond { };

  emojione = callPackage ../data/fonts/emojione {
    inherit (nodePackages) svgo;
    inherit (pythonPackages) scfbuild;
  };

  encode-sans = callPackage ../data/fonts/encode-sans { };

  fantasque-sans-mono = callPackage ../data/fonts/fantasque-sans-mono {};

  fira = callPackage ../data/fonts/fira { };

  fira-code = callPackage ../data/fonts/fira-code { };

  fira-mono = callPackage ../data/fonts/fira-mono { };

  font-awesome-ttf = callPackage ../data/fonts/font-awesome-ttf { };

  freefont-ttf = callPackage ../data/fonts/freefont-ttf { };

  font-droid = callPackage ../data/fonts/droid { };

  gentium = callPackage ../data/fonts/gentium {};

  gentium-book-basic = callPackage ../data/fonts/gentium-book-basic {};

  gohufont = callPackage ../data/fonts/gohufont { };

  google-fonts = callPackage ../data/fonts/google-fonts { };

  gyre-fonts = callPackage ../data/fonts/gyre {};

  hack-font = callPackage ../data/fonts/hack { };

  hasklig = callPackage ../data/fonts/hasklig {};

  helvetica-neue-lt-std = callPackage ../data/fonts/helvetica-neue-lt-std { };

  hanazono = callPackage ../data/fonts/hanazono { };

  inconsolata = callPackage ../data/fonts/inconsolata {};
  inconsolata-lgc = callPackage ../data/fonts/inconsolata/lgc.nix {};

  iosevka = callPackage ../data/fonts/iosevka { };

  ipafont = callPackage ../data/fonts/ipafont {};
  ipaexfont = callPackage ../data/fonts/ipaexfont {};

  junicode = callPackage ../data/fonts/junicode { };

  kawkab-mono-font = callPackage ../data/fonts/kawkab-mono {};

  kochi-substitute = callPackage ../data/fonts/kochi-substitute {};

  kochi-substitute-naga10 = callPackage ../data/fonts/kochi-substitute-naga10 {};

  lato = callPackage ../data/fonts/lato {};

  league-of-moveable-type = callPackage ../data/fonts/league-of-moveable-type {};

  liberation-ttf-from-source = callPackage ../data/fonts/redhat-liberation-fonts { };
  liberation-ttf-binary = callPackage ../data/fonts/redhat-liberation-fonts/binary.nix {
    inherit liberation-ttf-from-source;
  };
  liberation-ttf = liberation-ttf-binary;

  liberationsansnarrow = callPackage ../data/fonts/liberationsansnarrow { };
  liberationsansnarrow-binary = callPackage ../data/fonts/liberationsansnarrow/binary.nix {
    inherit liberationsansnarrow;
  };

  libertine = callPackage ../data/fonts/libertine { };

  libre-baskerville = callPackage ../data/fonts/libre-baskerville { };

  libre-bodoni = callPackage ../data/fonts/libre-bodoni { };

  libre-caslon = callPackage ../data/fonts/libre-caslon { };

  libre-franklin = callPackage ../data/fonts/libre-franklin { };

  lmmath = callPackage ../data/fonts/lmodern/lmmath.nix {};

  lmodern = callPackage ../data/fonts/lmodern { };

  lobster-two = callPackage ../data/fonts/lobster-two {};

  # lohit-fonts.assamese lohit-fonts.bengali lohit-fonts.devanagari lohit-fonts.gujarati lohit-fonts.gurmukhi
  # lohit-fonts.kannada lohit-fonts.malayalam lohit-fonts.marathi lohit-fonts.nepali lohit-fonts.odia
  # lohit-fonts.tamil-classical lohit-fonts.tamil lohit-fonts.telugu
  # lohit-fonts.kashmiri lohit-fonts.konkani lohit-fonts.maithili lohit-fonts.sindhi
  lohit-fonts = recurseIntoAttrs ( callPackages ../data/fonts/lohit-fonts { } );

  marathi-cursive = callPackage ../data/fonts/marathi-cursive { };

  meslo-lg = callPackage ../data/fonts/meslo-lg {};

  mononoki = callPackage ../data/fonts/mononoki { };

  montserrat = callPackage ../data/fonts/montserrat { };

  mph-2b-damase = callPackage ../data/fonts/mph-2b-damase { };

  mplus-outline-fonts = callPackage ../data/fonts/mplus-outline-fonts { };

  mro-unicode = callPackage ../data/fonts/mro-unicode { };

  nafees = callPackage ../data/fonts/nafees { };

  nerdfonts = callPackage ../data/fonts/nerdfonts { };

  norwester = callPackage ../data/fonts/norwester  {};

  inherit (callPackages ../data/fonts/noto-fonts {}) noto noto-cjk noto-emoji;

  oldstandard = callPackage ../data/fonts/oldstandard { };

  oldsindhi = callPackage ../data/fonts/oldsindhi { };

  open-dyslexic = callPackage ../data/fonts/open-dyslexic { };

  opensans-ttf = callPackage ../data/fonts/opensans-ttf { };

  orbitron = callPackage ../data/fonts/orbitron { };

  oxygenfonts = callPackage ../data/fonts/oxygenfonts { };

  pecita = callPackage ../data/fonts/pecita {};

  paratype-pt-mono = callPackage ../data/fonts/paratype-pt/mono.nix {};
  paratype-pt-sans = callPackage ../data/fonts/paratype-pt/sans.nix {};
  paratype-pt-serif = callPackage ../data/fonts/paratype-pt/serif.nix {};

  poly = callPackage ../data/fonts/poly { };

  powerline-fonts = callPackage ../data/fonts/powerline-fonts { };

  profont = callPackage ../data/fonts/profont { };

  proggyfonts = callPackage ../data/fonts/proggyfonts { };

  sampradaya = callPackage ../data/fonts/sampradaya { };

  signwriting = callPackage ../data/fonts/signwriting { };

  soundfont-fluid = callPackage ../data/soundfonts/fluid { };

  stix-otf = callPackage ../data/fonts/stix-otf { };

  inherit (callPackages ../data/fonts/gdouros { })
    symbola aegyptus akkadian anatolian maya unidings musica analecta;

  quattrocento = callPackage ../data/fonts/quattrocento {};

  quattrocento-sans = callPackage ../data/fonts/quattrocento-sans {};

  roboto = callPackage ../data/fonts/roboto { };

  roboto-mono = callPackage ../data/fonts/roboto-mono { };

  roboto-slab = callPackage ../data/fonts/roboto-slab { };

  source-code-pro = callPackage ../data/fonts/source-code-pro {};

  source-sans-pro = callPackage ../data/fonts/source-sans-pro { };

  source-serif-pro = callPackage ../data/fonts/source-serif-pro { };

  sourceHanSansPackages = callPackage ../data/fonts/source-han-sans { };
  source-han-sans-japanese = sourceHanSansPackages.japanese;
  source-han-sans-korean = sourceHanSansPackages.korean;
  source-han-sans-simplified-chinese = sourceHanSansPackages.simplified-chinese;
  source-han-sans-traditional-chinese = sourceHanSansPackages.traditional-chinese;

  inherit (callPackages ../data/fonts/tai-languages { }) tai-ahom;

  tewi-font = callPackage ../data/fonts/tewi {};

  theano = callPackage ../data/fonts/theano { };

  tempora-lgc = callPackage ../data/fonts/tempora-lgc { };

  terminus = callPackage ../data/fonts/terminus-font { };

  tipa = callPackage ../data/fonts/tipa { };

  ttf-bitstream-vera = callPackage ../data/fonts/ttf-bitstream-vera { };

  ubuntu = callPackage ../data/fonts/ubuntu-font-family { };

  ucs = callPackage ../data/fonts/ucs-fonts { };

  uni-vga = callPackage ../data/fonts/uni-vga { };

  unifont = callPackage ../data/fonts/unifont { };

  unifont-upper = callPackage ../data/fonts/unifont_upper { };

  vistafonts = callPackage ../data/fonts/vista-fonts { };

  wqy-microhei = callPackage ../data/fonts/wqy-microhei { };

  wqy-zenhei = callPackage ../data/fonts/wqy-zenhei { };

  xits-math = callPackage ../data/fonts/xits-math { };

}
