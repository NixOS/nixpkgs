# usage: $ nix-shell test-package-build.nix 
let
  pkgs = import ../../.. {};
  # want to avoid needing it at all, but we might find it necessary
  conda  = pkgs.conda.override { extraPkgs = with pkgs; [
    which # some conda packages rely on this
  ]; };
  
  rpkgs = with pkgs.rPackages;
      [ # some packages we care about. edit freely.
        AnnotationDbi
        ballgown
        DESeq2
        EnsDb_Hsapiens_v79
        EnsDb_Hsapiens_v86
        devtools
        dplyr
        genefilter
        ggplot2
        HDF5Array
        hdf5r
        knitr
        pheatmap
        PythonInR
        RColorBrewer
        Rhdf5lib
        readr
        rhdf5
        rmarkdown
        tidygenomics
        tidyr
        tximeta
        tximport
        vsn
        xts

        # some bioconductor workflows -- new!
        rnaseqGene
        simpleSingleCell
        RNAseq123
        annotation
        rnaseqDTU
        maEndToEnd
        #cytofWorkflow # broken

      #   # packagesWithNativeBuildInputs
      #   abn
      #   adimpro
      #   animation
      #   audio
      #   BayesSAE
      #   BayesVarSel
      #   BayesXsrc
      #   #bigGP
      #   bio3d
      #   BiocCheck
      #   Biostrings
      #   bnpmr
      #   cairoDevice
      #   Cairo
      #   Cardinal
      #   chebpol
      #   ChemmineOB
      #   cit
      #   curl
      #   data_table
      #   devEMF
      #   diversitree
      #   EMCluster
      #   fftw
      #   fftwtools
      #   Formula
      #   gdtools
      #   git2r
      #   GLAD 
      #   glpkAPI
      #   gmp
      #   graphscan
      #   gsl 
      #   haven
      #   h5vc
      #   HiCseg
      #   imager
      #   iBMQ
      #   igraph
      #   JavaGD
      #   jpeg
      #   jqr
      #   KFKSDS
      #   kza
      #   magick
      #   ModelMetrics
      #   mvabund
      #   mwaved
      #   ncdf4
      #   nloptr
      #   odbc
      #   outbreaker
      #   pander
      #   pbdMPI
      #   pbdNCDF4
      #   pbdPROF
      #   pbdZMQ
      #   pdftools
      #   phytools
      #   PKI
      #   png
      #   proj4
      #   protolite
      #   qtbase
      #   qtpaint
      #   R2SWF
      #   RAppArmor
      #   rapportools
      #   rapport
      #   readxl
      #   rcdd
      #   RcppCNPy
      #   RcppGSL
      #   RcppZiggurat
      #   reprex
      #   rgdal
      #   rgeos
      #   rggobi
      #   Rglpk
      #   RGtk2
      #   rhdf5
      #   Rhdf5lib
      #   Rhpc
      #   Rhtslib
      #   rjags
      #   rJava
      #   Rlibeemd
      #   rmatio
      #   Rmpfr
      #   Rmpi
      #   RMySQL
      #   RNetCDF
      #   RODBC
      #   #rpanel
      #   rpg
      #   Rpoppler
      #   RPostgreSQL
      #   RProtoBuf
      #   rPython
      #   RSclient
      #   Rsamtools
      #   Rserve
      #   Rssa
      #   rtiff
      #   runjags
      #   RVowpalWabbit
      #   rzmq
      #   SAVE
      #   sdcTable
      #   seewave
      #   seqinr
      #   seqminer
      #   sf
      #   showtext
      #   simplexreg
      #   spate
      #   ssanv
      #   stsm
      #   stringi
      #   survSNP
      #   sysfonts
      #   systemfonts
      #   TAQMNGR
      #   #tesseract
      #   tiff
      #   TKF
      #   tkrplot
      #   topicmodels
      #   udunits2
      #   units
      #   V8
      #   XBRL
      #   xml2
      #   XML
      #   affyPLM
      #   bamsignals
      #   BitSeq
      #   DiffBind
      #   ShortRead
      #   oligo
      #   gmapR
      #   Rsubread
      #   XVector
      #   rtracklayer
      #   affyio
      #   VariantAnnotation
      #   snpStats

      #   # packagesWithBuildinputs
      #   Cairo
      #   KernSmooth
      #   Matrix
      #   R2SWF
      #   RCurl
      #   RGtk2
      #   RMark
      #   RProtoBuf
      #   RPushbullet
      #   RcppEigen
      #   Rpoppler
      #   #Rsymphony
      #   SparseM
      #   XML
      #   adimpro
      #   ape
      #   cairoDevice
      #   chebpol
      #   cluster
      #   expm
      #   fftw
      #   gam
      #   gdtools
      #   glmnet
      #   gridGraphics
      #   igraph
      #   jqr
      #   kza
      #   magick
      #   mgcv
      #   minqa
      #   mnormt
      #   mwaved
      #   mzR
      #   nat
      #   nat_templatebrains
      #   nlme
      #   odbc
      #   openssl
      #   pan
      #   pbdZMQ
      #   pdftools
      #   phangorn
      #   qtbase
      #   quadprog
      #   quantreg
      #   rPython
      #   randomForest
      #   rggobi
      #   rgl
      #   rmutil
      #   robustbase
      #   sf
      #   showtext
      #   spate
      #   stringi
      #   sundialr
      #   svKomodo
      #   sysfonts
      #   systemfonts
      #   tcltk2
      #   #tesseract
      #   tikzDevice
      #   ucminf

      #   # packagesRequiringX
      #   AnalyzeFMRI
      #   ##AnnotLists
      #   AnthropMMD
      #   AtelieR
      #   BAT
      #   BCA
      #   BiodiversityR
      #   CCTpack
      #   CommunityCorrelogram
      #   ConvergenceConcepts
      #   ##DALY
      #   DSpat
      #   Deducer
      #   DeducerPlugInExample
      #   DeducerPlugInScaling
      #   DeducerSpatial
      #   DeducerSurvival
      #   DeducerText
      #   Demerelate
      #   DivMelt
      #   ENiRG
      #   EasyqpcR
      #   FD
      #   FFD
      #   FeedbackTS
      #   FreeSortR
      #   GGEBiplotGUI
      #   GPCSIV
      #   GUniFrac
      #   GrammR
      #   ##GrapheR
      #   ##GroupSeq
      #   HH
      #   HiveR
      #   IsotopeR
      #   JGR
      #   KappaGUI
      #   LS2Wstat
      #   MareyMap
      #   MergeGUI
      #   MetSizeR
      #   Meth27QC
      #   MicroStrategyR
      #   MissingDataGUI
      #   MplusAutomation
      #   OligoSpecificitySystem
      #   OpenRepGrid
      #   PBSadmb
      #   PBSmodelling
      #   PCPS
      #   PKgraph
      #   PopGenReport
      #   PredictABEL
      #   PrevMap
      #   ProbForecastGOP
      #   RHRV
      #   RNCEP
      #   RQDA
      #   RSDA
      #   RSurvey
      #   RandomFields
      #   Rcmdr
      #   RcmdrPlugin_DoE
      #   RcmdrPlugin_EACSPIR
      #   RcmdrPlugin_EBM
      #   RcmdrPlugin_EZR
      #   RcmdrPlugin_EcoVirtual
      #   RcmdrPlugin_FactoMineR
      #   RcmdrPlugin_HH
      #   RcmdrPlugin_IPSUR
      #   RcmdrPlugin_KMggplot2
      #   RcmdrPlugin_MA
      #   RcmdrPlugin_MPAStats
      #   RcmdrPlugin_ROC
      #   RcmdrPlugin_SCDA
      #   RcmdrPlugin_SLC
      #   RcmdrPlugin_TeachingDemos
      #   RcmdrPlugin_UCA
      #   RcmdrPlugin_coin
      #   RcmdrPlugin_depthTools
      #   RcmdrPlugin_lfstat
      #   RcmdrPlugin_mosaic
      #   RcmdrPlugin_orloca
      #   RcmdrPlugin_plotByGroup
      #   RcmdrPlugin_pointG
      #   RcmdrPlugin_qual
      #   RcmdrPlugin_sampling
      #   RcmdrPlugin_sos
      #   RcmdrPlugin_steepness
      #   RcmdrPlugin_survival
      #   RcmdrPlugin_temis
      #   RenextGUI
      #   RunuranGUI
      #   SOLOMON
      #   SRRS
      #   SSDforR
      #   STEPCAM
      #   SYNCSA
      #   Simile
      #   SimpleTable
      #   StatDA
      #   SyNet
      #   TIMP
      #   TTAinterfaceTrendAnalysis
      #   TestScorer
      #   VecStatGraphs3D
      #   WMCapacity
      #   accrual
      #   ade4TkGUI
      #   analogue
      #   analogueExtra
      #   aplpack
      #   asbio
      #   bayesDem
      #   betapart
      #   bio_infer
      #   bipartite
      #   biplotbootGUI
      #   blender
      #   cairoDevice
      #   cncaGUI
      #   cocorresp
      #   confidence
      #   constrainedKriging
      #   cpa
      #   dave
      #   detrendeR
      #   dgmb
      #   dpa
      #   dynBiplotGUI
      #   dynamicGraph
      #   exactLoglinTest
      #   fSRM
      #   fat2Lpoly
      #   fbati
      #   feature
      #   fgui
      #   fisheyeR
      #   fit4NM
      #   forams
      #   forensim
      #   fscaret
      #   gWidgets2RGtk2
      #   gWidgets2tcltk
      #   gWidgetsRGtk2
      #   gWidgetstcltk
      #   gcmr
      #   geoR
      #   geomorph
      #   georob
      #   gnm
      #   gsubfn
      #   iDynoR
      #   ic50
      #   in2extRemes
      #   iplots
      #   isopam
      #   likeLTD
      #   logmult
      #   memgene
      #   metacom
      #   migui
      #   miniGUI
      #   mixsep
      #   mpmcorrelogram
      #   mritc
      #   multgee
      #   multibiplotGUI
      #   onemap
      #   paleoMAS
      #   pbatR
      #   pez
      #   phylotools
      #   picante
      #   plotSEMM
      #   plsRbeta
      #   plsRglm
      #   poppr
      #   powerpkg
      #   prefmod
      #   qtbase
      #   qtpaint
      #   r4ss
      #   rAverage
      #   rareNMtests
      #   recluster
      #   relimp
      #   reshapeGUI
      #   rgl
      #   rich
      #   simba
      #   soundecology
      #   spatsurv
      #   sqldf
      #   statcheck
      #   stosim
      #   strvalidator
      #   stylo
      #   svDialogstcltk
      #   svIDE
      #   svSocket
      #   svWidgets
      #   tcltk2
      #   titan
      #   tkrgl
      #   tkrplot
      #   tmap
      #   tspmeta
      #   twiddler
      #   vcdExtra
      #   vegan
      #   vegan3d
      #   vegclust
      #   #x12GUI
      #   # otherOverrides no duplicates
      #   RcppArmadillo
      #   SamplerCompare
      #   spMC
      #   openssl
      #   websocket
      #   acs
      #   OpenMx
      #   x13binary
      #   geojsonio
      #   rstan
      #   ps
      #   mongolite
      #   rlang
      #   littler
      ];
  
  my_r = pkgs.rWrapper.override { packages = rpkgs; };
  my_rstudio = pkgs.rstudioWrapper.override { packages = rpkgs;};
  
in
  pkgs.mkShell {
    buildInputs = with pkgs;
      [
        # conda # uncomment if you require conda
        my_r       # don't need this if you are only using rstudio
        my_rstudio
        
        # uncomment next two if you are writing docs
        # texlive.combined.scheme-full
        # pandoc

        # add command line tool here 
        samtools 
        hisat2
        bowtie2
      ];
    # saves a step if you are using conda
    # shellHook ="exec conda-shell"; 
  }


