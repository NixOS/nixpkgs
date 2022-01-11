# Deprecated aliases - for backward compatibility
lib:

final: prev:

let
  # Removing recurseForDerivation prevents derivations of aliased attribute
  # set to appear while listing all the packages available.
  removeRecurseForDerivations = alias: with lib;
    if alias.recurseForDerivations or false then
      removeAttrs alias ["recurseForDerivations"]
    else alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias: with lib;
    if isDerivation alias then
      dontDistribute alias
    else alias;

  # Make sure that we are not shadowing something from
  # all-packages.nix.
  checkInPkgs = n: alias: if builtins.hasAttr n prev
                          then throw "Alias ${n} is still in vim-plugins"
                          else alias;

  mapAliases = aliases:
    lib.mapAttrs (n: alias: removeDistribute
                             (removeRecurseForDerivations
                              (checkInPkgs n alias)))
                     aliases;

  deprecations = lib.mapAttrs (old: info:
    throw "${old} was renamed to ${info.new} on ${info.date}. Please update to ${info.new}."
  ) (lib.importJSON ./deprecated.json);

in
mapAliases (with prev; {
  airline             = vim-airline;
  alternative         = a-vim; # backwards compat, added 2014-10-21
  bats                = bats-vim;
  BufOnly             = BufOnly-vim;
  calendar            = calendar-vim;
  coffee-script       = vim-coffee-script;
  coffeeScript        = vim-coffee-script; # backwards compat, added 2014-10-18
  Solarized           = vim-colors-solarized;
  solarized           = vim-colors-solarized;
  colors-solarized    = vim-colors-solarized;
  caw                 = caw-vim;
  colorsamplerpack    = Colour-Sampler-Pack;
  Colour_Sampler_Pack = Colour-Sampler-Pack;
  command_T           = command-t; # backwards compat, added 2014-10-18
  commentary          = vim-commentary;
  committia           = committia-vim;
  concealedyank       = concealedyank-vim;
  context-filetype    = context_filetype-vim;
  Cosco               = cosco-vim;
  css_color_5056      = vim-css-color;
  CSApprox            = csapprox;
  csv                 = csv-vim;
  ctrlp               = ctrlp-vim;
  cute-python         = vim-cute-python;
  denite              = denite-nvim;
  easy-align          = vim-easy-align;
  easygit             = vim-easygit;
  easymotion          = vim-easymotion;
  echodoc             = echodoc-vim;
  eighties            = vim-eighties;
  extradite           = vim-extradite;
  fugitive            = vim-fugitive;
  ghc-mod-vim         = ghcmod-vim;
  ghcmod              = ghcmod-vim;
  goyo                = goyo-vim;
  Gist                = vim-gist;
  gitgutter           = vim-gitgutter;
  gundo               = gundo-vim;
  Gundo               = gundo-vim; # backwards compat, added 2015-10-03
  haskellConceal      = vim-haskellconceal; # backwards compat, added 2014-10-18
  haskellConcealPlus  = vim-haskellConcealPlus;
  haskellconceal      = vim-haskellconceal;
  hier                = vim-hier;
  hlint-refactor      = hlint-refactor-vim;
  hoogle              = vim-hoogle;
  Hoogle              = vim-hoogle;
  indent-blankline-nvim-lua = indent-blankline-nvim; # backwards compat, added 2021-07-05
  ipython             = vim-ipython;
  latex-live-preview  = vim-latex-live-preview;
  maktaba             = vim-maktaba;
  multiple-cursors    = vim-multiple-cursors;
  necoGhc             = neco-ghc; # backwards compat, added 2014-10-18
  neocomplete         = neocomplete-vim;
  neoinclude          = neoinclude-vim;
  neomru              = neomru-vim;
  neosnippet          = neosnippet-vim;
  The_NERD_Commenter  = nerdcommenter;
  The_NERD_tree       = nerdtree;
  open-browser        = open-browser-vim;
  pathogen            = vim-pathogen;
  polyglot            = vim-polyglot;
  prettyprint         = vim-prettyprint;
  quickrun            = vim-quickrun;
  rainbow_parentheses = rainbow_parentheses-vim;
  repeat              = vim-repeat;
  riv                 = riv-vim;
  rhubarb             = vim-rhubarb;
  sensible            = vim-sensible;
  signature           = vim-signature;
  snipmate            = vim-snipmate;
  sourcemap           = sourcemap-vim;
  "sourcemap.vim"     = sourcemap-vim;
  surround            = vim-surround;
  sleuth              = vim-sleuth;
  solidity            = vim-solidity;
  stylish-haskell     = vim-stylish-haskell;
  stylishHaskell      = vim-stylish-haskell; # backwards compat, added 2014-10-18
  Supertab            = supertab;
  Syntastic           = syntastic;
  SyntaxRange         = vim-SyntaxRange;
  table-mode          = vim-table-mode;
  taglist             = taglist-vim;
  tabpagebuffer       = tabpagebuffer-vim;
  tabpagecd           = vim-tabpagecd;
  Tabular             = tabular;
  Tagbar              = tagbar;
  thumbnail           = thumbnail-vim;
  tlib                = tlib_vim;
  tmux-navigator      = vim-tmux-navigator;
  tmuxNavigator       = vim-tmux-navigator; # backwards compat, added 2014-10-18
  tslime              = tslime-vim;
  unite               = unite-vim;
  UltiSnips           = ultisnips;
  vim-addon-vim2nix   = vim2nix;
  vimproc             = vimproc-vim;
  vimshell            = vimshell-vim;
  vinegar             = vim-vinegar;
  watchdogs           = vim-watchdogs;
  WebAPI              = webapi-vim;
  wombat256           = wombat256-vim; # backwards compat, added 2015-7-8
  yankring            = YankRing-vim;
  Yankring            = YankRing-vim;
  xterm-color-table   = xterm-color-table-vim;
  zeavim              = zeavim-vim;
} // deprecations)
