# This file is generated from generate-r-packages.R. DO NOT EDIT.
# Execute the following command to update the file.
#
# Rscript generate-r-packages.R bioc-experiment >new && mv new bioc-experiment-packages.nix

{ self, derive }:
let
  derive2 = derive { biocVersion = "3.18"; };
in
with self;
{
  ALL = derive2 {
    name = "ALL";
    version = "1.44.0";
    sha256 = "1ny5xv338a91gc88a1y5rrd27iawrrlmxhkidvc7xdsbrwd4flkc";
    depends = [ Biobase ];
  };
  ALLMLL = derive2 {
    name = "ALLMLL";
    version = "1.42.0";
    sha256 = "1sq2j4gq78d68lqlqnd6nxi66gngzqyxicsyv85xp7dhcl59fwbm";
    depends = [ affy ];
  };
  ARRmData = derive2 {
    name = "ARRmData";
    version = "1.38.0";
    sha256 = "0hlhc7kvw9n1bnbzingd1475qwivpx64sccnigdij8xdcm1mb4s7";
    depends = [ ];
  };
  ASICSdata = derive2 {
    name = "ASICSdata";
    version = "1.22.0";
    sha256 = "01xm27j9c37vqpqz4d9v3bsji1z6ppgf64jja5dd4rz8i3gx9f68";
    depends = [ ];
  };
  Affyhgu133A2Expr = derive2 {
    name = "Affyhgu133A2Expr";
    version = "1.38.0";
    sha256 = "1rvw1z3i8jz0x4ca2fy4xg2z97ffalh15prsd38sz4chj9cwybxc";
    depends = [ ];
  };
  Affyhgu133Plus2Expr = derive2 {
    name = "Affyhgu133Plus2Expr";
    version = "1.36.0";
    sha256 = "10jilz65xba8a43zdvxksll9jpba9a1nj5w266d7laws056m4bh9";
    depends = [ ];
  };
  Affyhgu133aExpr = derive2 {
    name = "Affyhgu133aExpr";
    version = "1.40.0";
    sha256 = "1kdp39k2s35jb3wp4qqm0lbrz94dxz1s9yygv8frfc70xv4hh7af";
    depends = [ ];
  };
  AffymetrixDataTestFiles = derive2 {
    name = "AffymetrixDataTestFiles";
    version = "0.40.0";
    sha256 = "0h8i38qh3krw02v5x4rybh0pmfriy5l3ji6ahk2j0hgjfgq55z5b";
    depends = [ ];
  };
  Affymoe4302Expr = derive2 {
    name = "Affymoe4302Expr";
    version = "1.40.0";
    sha256 = "01zgyp6yy980iyqan7f9qiv7pqzkr4cjli9q5ncig085afp2j88r";
    depends = [ ];
  };
  AmpAffyExample = derive2 {
    name = "AmpAffyExample";
    version = "1.42.0";
    sha256 = "028473p5k69vmm8nh0qpmq30cyjcjaccclnsc7crr6brg2xjzcb6";
    depends = [ affy ];
  };
  AneuFinderData = derive2 {
    name = "AneuFinderData";
    version = "1.30.0";
    sha256 = "03kp8qkqy2wph7lbzawgnh83qjm31ih1jp986qwphfhkfk125wg0";
    depends = [ ];
  };
  AshkenazimSonChr21 = derive2 {
    name = "AshkenazimSonChr21";
    version = "1.32.0";
    sha256 = "0yin4q6bjhbh6a6xb62ac5w0kjb23y3kslrpkf9prr1cz42kvbjx";
    depends = [ ];
  };
  AssessORFData = derive2 {
    name = "AssessORFData";
    version = "1.20.0";
    sha256 = "0lp80w5msdisic9j827wq7gsi9v6vnrchrlcmr2h5vd26plia98x";
    depends = [ DECIPHER ];
  };
  BeadArrayUseCases = derive2 {
    name = "BeadArrayUseCases";
    version = "1.40.0";
    sha256 = "052r8snjwqzn49gjwv1fv5vhwl14vcmzwjxb4jgsbnb14wyhiliy";
    depends = [
      beadarray
      GEOquery
      limma
    ];
  };
  BeadSorted_Saliva_EPIC = derive2 {
    name = "BeadSorted.Saliva.EPIC";
    version = "1.10.0";
    sha256 = "088c6ikr7cslpx8yx89d3y00zigy6c21qa1m3dlrynghh7z8xi8w";
    depends = [
      ExperimentHub
      minfi
    ];
  };
  BioImageDbs = derive2 {
    name = "BioImageDbs";
    version = "1.10.0";
    sha256 = "1xgm9n01if7rb6lsgj4cg5dbjl8kq6zvkj4324vrwj1c1mdaa9nv";
    depends = [
      animation
      AnnotationHub
      EBImage
      einsum
      ExperimentHub
      filesstrings
      magick
      magrittr
      markdown
      rmarkdown
    ];
  };
  BioPlex = derive2 {
    name = "BioPlex";
    version = "1.8.0";
    sha256 = "0wwsbv4kyi67favswb5jrcgjv6a02s8gvwc23918y0rlcmkx07m7";
    depends = [
      BiocFileCache
      GenomeInfoDb
      GenomicRanges
      GEOquery
      graph
      SummarizedExperiment
    ];
  };
  BloodCancerMultiOmics2017 = derive2 {
    name = "BloodCancerMultiOmics2017";
    version = "1.22.0";
    sha256 = "1ya62fx76ifnbdbws51nw544n12sk4a35qichfc54v0ffbz0n38c";
    depends = [
      beeswarm
      Biobase
      DESeq2
      devtools
      dplyr
      ggdendro
      ggplot2
      glmnet
      gtable
      ipflasso
      RColorBrewer
      reshape2
      scales
      SummarizedExperiment
      survival
      tibble
    ];
  };
  CCl4 = derive2 {
    name = "CCl4";
    version = "1.40.0";
    sha256 = "02fw0c7yy6vch31a726fpn163mi5zj13jvrpczqqshb2wz2qs58c";
    depends = [
      Biobase
      limma
    ];
  };
  CLL = derive2 {
    name = "CLL";
    version = "1.42.0";
    sha256 = "10l2a562l6hx32sxmvy8z59shq87v770rrh2fhddnj06dpx6n6cf";
    depends = [
      affy
      Biobase
    ];
  };
  CLLmethylation = derive2 {
    name = "CLLmethylation";
    version = "1.22.0";
    sha256 = "16k05g98j2zs8n827kvgishzcj0zcx12cwzvgznzjrwp56dl72xs";
    depends = [
      ExperimentHub
      SummarizedExperiment
    ];
  };
  COHCAPanno = derive2 {
    name = "COHCAPanno";
    version = "1.38.0";
    sha256 = "0f85l5alhzb14p30pmk11lv0wn6n4nsx8l9pc545fkwqdm5bsqh3";
    depends = [ ];
  };
  CONFESSdata = derive2 {
    name = "CONFESSdata";
    version = "1.30.0";
    sha256 = "1gjsbrrz06qsa0lwjiil0qprhiajyy7im5wh6xks0ifs8rl9f9y4";
    depends = [ ];
  };
  COPDSexualDimorphism_data = derive2 {
    name = "COPDSexualDimorphism.data";
    version = "1.38.0";
    sha256 = "1mkxf577xa7k1cflrwbdngj6kfhdz2a1dg04x849zm6ahmd3x9vf";
    depends = [ ];
  };
  COSMIC_67 = derive2 {
    name = "COSMIC.67";
    version = "1.38.0";
    sha256 = "0c4nmzdhg2mam134j5p7g5h4g2f08aqj429b03cz83znqy4k25vl";
    depends = [
      GenomicRanges
      SummarizedExperiment
      VariantAnnotation
    ];
  };
  CRCL18 = derive2 {
    name = "CRCL18";
    version = "1.22.0";
    sha256 = "1wa9988sv5maml0v0n893m5vf773z0z530dpp5cjk02cd40npcrn";
    depends = [ Biobase ];
  };
  CardinalWorkflows = derive2 {
    name = "CardinalWorkflows";
    version = "1.34.0";
    sha256 = "0cyzzyki6y2a7m4w7pk7x532a0i539irmpxbba3zs05cjs3213sb";
    depends = [ Cardinal ];
  };
  CellMapperData = derive2 {
    name = "CellMapperData";
    version = "1.28.0";
    sha256 = "12mx1m4lm51y8pazmhrd8ickvvpa2sm9cg2znhs6pzmgc5bj09dx";
    depends = [
      CellMapper
      ExperimentHub
    ];
  };
  ChAMPdata = derive2 {
    name = "ChAMPdata";
    version = "2.34.0";
    sha256 = "175vsg2bh578fdrdchcma5q3jq7cfxa8b7g8954xv6fxrwcj0ffz";
    depends = [
      BiocGenerics
      GenomicRanges
    ];
  };
  ChIC_data = derive2 {
    name = "ChIC.data";
    version = "1.22.0";
    sha256 = "1akqpqw9ydf23whr346psciyyp9c3r0rsas1rkdkf8g5wrcj9vhk";
    depends = [
      caret
      genomeIntervals
      randomForest
    ];
  };
  ChIPXpressData = derive2 {
    name = "ChIPXpressData";
    version = "1.40.0";
    sha256 = "0i96lkgkzssrsa0gnc5l4f9j4x07cvq4s019v3b2fm5s288lvsnj";
    depends = [ bigmemory ];
  };
  ChIPexoQualExample = derive2 {
    name = "ChIPexoQualExample";
    version = "1.26.0";
    sha256 = "1v35xq0a58kf0nabv3v6aiz9cd3gvwv0asmvq27ha0w1ngwd0dzk";
    depends = [ ];
  };
  CluMSIDdata = derive2 {
    name = "CluMSIDdata";
    version = "1.18.0";
    sha256 = "0xahy0l8b8c7xgg6481vhliiis63brh3rszaj5d1f7sjbgzj7ahs";
    depends = [ ];
  };
  CoSIAdata = derive2 {
    name = "CoSIAdata";
    version = "1.2.0";
    sha256 = "07x44vn6r1d0ixfzx9h3rzzn9gjjci59c41xhqn2b3k6f5c7fa9r";
    depends = [ ExperimentHub ];
  };
  ConnectivityMap = derive2 {
    name = "ConnectivityMap";
    version = "1.38.0";
    sha256 = "0ixvmkyps62f10c0s4z0jas2106hnvijknai6abial6i3plffnsc";
    depends = [ ];
  };
  CopyNeutralIMA = derive2 {
    name = "CopyNeutralIMA";
    version = "1.20.0";
    sha256 = "11l994nhi813qs1vmrqjgclw11k5hrsmcrlj5x5wqmqmnjjw1dsy";
    depends = [
      ExperimentHub
      Rdpack
    ];
  };
  CopyhelpeR = derive2 {
    name = "CopyhelpeR";
    version = "1.34.0";
    sha256 = "1zfsxi65lln93fb87l6fgp7vxldb4fvnf95h91dl424xyq6qjp1h";
    depends = [ ];
  };
  DAPARdata = derive2 {
    name = "DAPARdata";
    version = "1.32.1";
    sha256 = "1iwiq5z1jnsrdp3pnhxlb2rvcfg91xp7xp2k0ry7r0gr9hjnnhr7";
    depends = [ MSnbase ];
  };
  DExMAdata = derive2 {
    name = "DExMAdata";
    version = "1.10.0";
    sha256 = "1a2hrvbkhpwmjha0iwd17xv60d1cdl7iswc942bcac80mn6sw305";
    depends = [ Biobase ];
  };
  DLBCL = derive2 {
    name = "DLBCL";
    version = "1.42.2";
    sha256 = "06x4jbyz0m9pzwxjl326rl5zahq5km5rryncbq99cz6mml2asn21";
    depends = [
      Biobase
      graph
    ];
  };
  DMRcatedata = derive2 {
    name = "DMRcatedata";
    version = "2.20.3";
    sha256 = "0fhk71j60s693vh333277ra0vgjys15h6r593v2j1y970650pq0a";
    depends = [
      ExperimentHub
      GenomicFeatures
      Gviz
      IlluminaHumanMethylation450kanno_ilmn12_hg19
      IlluminaHumanMethylationEPICanno_ilm10b4_hg19
      plyr
      readxl
      rtracklayer
    ];
  };
  DNAZooData = derive2 {
    name = "DNAZooData";
    version = "1.2.0";
    sha256 = "0d5466b830s82laamig1rw0p0n6i4npb11iyziv1sfvs4y8pbhl8";
    depends = [
      BiocFileCache
      HiCExperiment
      rjson
      S4Vectors
    ];
  };
  DeSousa2013 = derive2 {
    name = "DeSousa2013";
    version = "1.38.0";
    sha256 = "1xjygkr8rc1m9sv5bwph3wdf9hhcfdw8zji547nw0ayrg5d49689";
    depends = [
      affy
      AnnotationDbi
      Biobase
      cluster
      ConsensusClusterPlus
      frma
      frmaTools
      gplots
      hgu133plus2_db
      hgu133plus2frmavecs
      pamr
      rgl
      ROCR
      siggenes
      survival
      sva
    ];
  };
  DmelSGI = derive2 {
    name = "DmelSGI";
    version = "1.34.0";
    sha256 = "1qsvw7jrn070yfrgrkw9wsdb05g8ai5hmcqmyr78qs5qny0cz919";
    depends = [
      abind
      gplots
      igraph
      knitr
      limma
      rhdf5
      TSP
    ];
  };
  DonaPLLP2013 = derive2 {
    name = "DonaPLLP2013";
    version = "1.40.0";
    sha256 = "0pxxg6rkdgafxj71mvlbm14vzv414hfh2p24rhyby7glrkzh2vq0";
    depends = [ EBImage ];
  };
  DropletTestFiles = derive2 {
    name = "DropletTestFiles";
    version = "1.12.0";
    sha256 = "0a68xd9ks83a13s1cckmhrc50ijp7dw19yjf37v253q50xjp0z03";
    depends = [
      AnnotationHub
      ExperimentHub
      S4Vectors
    ];
  };
  DrugVsDiseasedata = derive2 {
    name = "DrugVsDiseasedata";
    version = "1.38.0";
    sha256 = "03g6syilb9v9cr2snh5w02ng6drff5i86drbmhv24yabwfgp3ndi";
    depends = [ ];
  };
  DuoClustering2018 = derive2 {
    name = "DuoClustering2018";
    version = "1.20.0";
    sha256 = "0248jc4frjwbv5vq0483s2flbrnd70x4bkad7aphfxvrk897sn9v";
    depends = [
      dplyr
      ExperimentHub
      ggplot2
      ggthemes
      magrittr
      mclust
      purrr
      reshape2
      tidyr
      viridis
    ];
  };
  DvDdata = derive2 {
    name = "DvDdata";
    version = "1.38.0";
    sha256 = "16352h34az5sjq0bfgx9qs9njkn3nqws584cm1yydh2v60fclv63";
    depends = [ ];
  };
  EGSEAdata = derive2 {
    name = "EGSEAdata";
    version = "1.30.0";
    sha256 = "0m281qwvz1cdfjf605czammw107x23pjpqh1adx5rvacpzgd8gli";
    depends = [ ];
  };
  ELMER_data = derive2 {
    name = "ELMER.data";
    version = "2.26.0";
    sha256 = "0vwzj98pds0n3wc74y84d8srb1rvvf7kn7mjy4zf4d0qrp92sa94";
    depends = [ GenomicRanges ];
  };
  EatonEtAlChIPseq = derive2 {
    name = "EatonEtAlChIPseq";
    version = "0.40.0";
    sha256 = "06mzals24cc4fl5j2w8mwa1s7q98qm80g7gnr5rz4hj66kmiak94";
    depends = [
      GenomicRanges
      rtracklayer
      ShortRead
    ];
  };
  EpiMix_data = derive2 {
    name = "EpiMix.data";
    version = "1.4.0";
    sha256 = "15qc8jjbv6b4nxszrj8lkj6cmbvvxlvknksp5pl13s3y176gm4d5";
    depends = [ ExperimentHub ];
  };
  FANTOM3and4CAGE = derive2 {
    name = "FANTOM3and4CAGE";
    version = "1.38.0";
    sha256 = "01qz41q2cw4g7yg4nj7dlqsw6p8bh7dvm22a0vgp5dpm2pjagh15";
    depends = [ ];
  };
  FIs = derive2 {
    name = "FIs";
    version = "1.30.0";
    sha256 = "0pnw0p2n9r1r0a7b1g32s7s2abbvdc976igdf48agkmilkhzpbb4";
    depends = [ ];
  };
  FieldEffectCrc = derive2 {
    name = "FieldEffectCrc";
    version = "1.12.0";
    sha256 = "13xzypr95v5b3kynfn45b7rpg7kd0gcqmx3ap377plqs42nc7pa6";
    depends = [
      AnnotationHub
      BiocStyle
      DESeq2
      ExperimentHub
      RUnit
      SummarizedExperiment
    ];
  };
  Fletcher2013a = derive2 {
    name = "Fletcher2013a";
    version = "1.38.0";
    sha256 = "04rvri7hcc5qd29c0xbkvjylh2x9flk7hf8rngd01fbhk9myxsaj";
    depends = [
      Biobase
      gplots
      limma
      VennDiagram
    ];
  };
  Fletcher2013b = derive2 {
    name = "Fletcher2013b";
    version = "1.38.0";
    sha256 = "1zp7wafibklwc7gr827yk1m6630c4r11nvy1i8jjhriqrjd4hnpn";
    depends = [
      Fletcher2013a
      igraph
      RColorBrewer
      RedeR
      RTN
    ];
  };
  FlowSorted_Blood_450k = derive2 {
    name = "FlowSorted.Blood.450k";
    version = "1.40.0";
    sha256 = "08xli4a24kkyy5q1ka0vyrpk11yfkyp0gxbs0k8khycppsq9s9sn";
    depends = [ minfi ];
  };
  FlowSorted_Blood_EPIC = derive2 {
    name = "FlowSorted.Blood.EPIC";
    version = "2.6.0";
    sha256 = "0vfx1kpy02640nkkkpksisznybv0xb6jkvvkwsybsggcr2rdkl89";
    depends = [
      AnnotationHub
      ExperimentHub
      genefilter
      minfi
      nlme
      quadprog
      S4Vectors
      SummarizedExperiment
    ];
  };
  FlowSorted_CordBlood_450k = derive2 {
    name = "FlowSorted.CordBlood.450k";
    version = "1.30.0";
    sha256 = "04fx8mc21lflbxdz7fgz0jl30jk4gd09qqn5a654jlqhllnkg9rj";
    depends = [ minfi ];
  };
  FlowSorted_CordBloodCombined_450k = derive2 {
    name = "FlowSorted.CordBloodCombined.450k";
    version = "1.18.0";
    sha256 = "0gl0dwhabdik17al1f1zq2vhg3bgbirxmsa1lxfv97vq08nqfshl";
    depends = [
      AnnotationHub
      ExperimentHub
      IlluminaHumanMethylation450kanno_ilmn12_hg19
      IlluminaHumanMethylationEPICanno_ilm10b4_hg19
      minfi
      SummarizedExperiment
    ];
  };
  FlowSorted_CordBloodNorway_450k = derive2 {
    name = "FlowSorted.CordBloodNorway.450k";
    version = "1.28.0";
    sha256 = "16hrhakaxhhilfy5gb0yrwijww8ph20i3qnfkrhhz6gjqh0iyri2";
    depends = [ minfi ];
  };
  FlowSorted_DLPFC_450k = derive2 {
    name = "FlowSorted.DLPFC.450k";
    version = "1.38.0";
    sha256 = "0dj0gcz8mfd0ilihhysrbrzbkvfpwy1dx56g4dsizkg0k6aa8nha";
    depends = [ minfi ];
  };
  GIGSEAdata = derive2 {
    name = "GIGSEAdata";
    version = "1.20.0";
    sha256 = "0qisi43rbjg9y2fglkri3bb1wxn4rcylhlidw2ml4bl7d36rfxdz";
    depends = [ ];
  };
  GSBenchMark = derive2 {
    name = "GSBenchMark";
    version = "1.22.0";
    sha256 = "03ccpc69k0i0pffw0x0f49h71saz68chyppa8ncpyb5aj4lxp2gb";
    depends = [ ];
  };
  GSE103322 = derive2 {
    name = "GSE103322";
    version = "1.8.0";
    sha256 = "018k8vkyr0cvycvkihkajf709jsw0y9mhf8yamzc72x5mwazwhym";
    depends = [
      Biobase
      GEOquery
    ];
  };
  GSE13015 = derive2 {
    name = "GSE13015";
    version = "1.10.0";
    sha256 = "1jc40g1gxz7rcxcgx11blx9li3fpa605rzs9k2glaglrp373r7dk";
    depends = [
      Biobase
      GEOquery
      preprocessCore
      SummarizedExperiment
    ];
  };
  GSE159526 = derive2 {
    name = "GSE159526";
    version = "1.8.0";
    sha256 = "0z8aywaihmrzfn0pzm5z7pxkpmkrar4090wavvy4vzkqbzdicv8r";
    depends = [ ];
  };
  GSE62944 = derive2 {
    name = "GSE62944";
    version = "1.30.0";
    sha256 = "03wy4jjg6fh1fckmy0fqs776b3mhvrksk7hgkrjg7hr7p9b9dxwp";
    depends = [
      Biobase
      GEOquery
    ];
  };
  GSVAdata = derive2 {
    name = "GSVAdata";
    version = "1.38.0";
    sha256 = "1a9kspbmsnsrisy5xp5r3s1l7fz34v7riyiqn22hlc87zmnj7y5q";
    depends = [
      Biobase
      GSEABase
      hgu95a_db
    ];
  };
  GWASdata = derive2 {
    name = "GWASdata";
    version = "1.40.0";
    sha256 = "0lprcr2r0qzi7pa9pl6cp21z7vkjpn0d6ynnbbzji9ga82hd2njq";
    depends = [ GWASTools ];
  };
  GenomicDistributionsData = derive2 {
    name = "GenomicDistributionsData";
    version = "1.10.0";
    sha256 = "1c9pqmdnnpm80zzsbl3j66xdwb3kzn7jkisx31sn5jaxzc660jc4";
    depends = [
      AnnotationFilter
      AnnotationHub
      BSgenome
      data_table
      ensembldb
      ExperimentHub
      GenomeInfoDb
      GenomicFeatures
      GenomicRanges
    ];
  };
  GeuvadisTranscriptExpr = derive2 {
    name = "GeuvadisTranscriptExpr";
    version = "1.30.0";
    sha256 = "12253pncfqvq7c1ajkdgfn4f861w2zk3j6p5xyra7c0d0z47a2b6";
    depends = [ ];
  };
  HCAData = derive2 {
    name = "HCAData";
    version = "1.18.0";
    sha256 = "1rd1qra8g7dn9pg2mhh2j40p7p6ny838n4w6mx5ryw4xky95lf41";
    depends = [
      AnnotationHub
      ExperimentHub
      HDF5Array
      SingleCellExperiment
    ];
  };
  HCATonsilData = derive2 {
    name = "HCATonsilData";
    version = "1.0.0";
    sha256 = "1h5hrfslhyiqc855bb23rz9hahnpcy47h2lz1k0dj8glrjldq0jp";
    depends = [
      base64enc
      ExperimentHub
      HDF5Array
      htmltools
      rmarkdown
      S4Vectors
      SingleCellExperiment
      SpatialExperiment
      SummarizedExperiment
    ];
  };
  HD2013SGI = derive2 {
    name = "HD2013SGI";
    version = "1.42.0";
    sha256 = "1xxc85al19qxj17rj1k4q0xp3wgkxr007akmq3an7mqrah0y8hm8";
    depends = [
      EBImage
      geneplotter
      gplots
      limma
      LSD
      RColorBrewer
      splots
      vcd
    ];
  };
  HDCytoData = derive2 {
    name = "HDCytoData";
    version = "1.22.1";
    sha256 = "1048xgypsw257ihy0ysfxy5443dzhzp2rkjjvpivvrhw4dzl25ir";
    depends = [
      ExperimentHub
      flowCore
      SummarizedExperiment
    ];
  };
  HEEBOdata = derive2 {
    name = "HEEBOdata";
    version = "1.40.0";
    sha256 = "1xijrm32p191qydz1gkm8321b8ycb9h6y6m1qvc8shlhbbzw705h";
    depends = [ ];
  };
  HIVcDNAvantWout03 = derive2 {
    name = "HIVcDNAvantWout03";
    version = "1.42.0";
    sha256 = "0kyblhc6fdc5c45qyqcr2qnmp1zrwdrc0j91fml04pw5yxrf6dw0";
    depends = [ ];
  };
  HMP16SData = derive2 {
    name = "HMP16SData";
    version = "1.22.0";
    sha256 = "1ns7yyw0w8rrkw87awrrzxmb44gkkb1cn6j3cbzj8fbrd9whl30d";
    depends = [
      AnnotationHub
      assertthat
      dplyr
      ExperimentHub
      kableExtra
      knitr
      magrittr
      readr
      S4Vectors
      stringr
      SummarizedExperiment
      tibble
    ];
  };
  HMP2Data = derive2 {
    name = "HMP2Data";
    version = "1.16.0";
    sha256 = "1xrvslsybzy1zjvck6imrjxzd0hsiyx4ly71ndirxs7yhh13d1qk";
    depends = [
      AnnotationHub
      assertthat
      data_table
      dplyr
      ExperimentHub
      kableExtra
      knitr
      magrittr
      MultiAssayExperiment
      phyloseq
      readr
      S4Vectors
      SummarizedExperiment
    ];
  };
  HSMMSingleCell = derive2 {
    name = "HSMMSingleCell";
    version = "1.22.0";
    sha256 = "1nf6jsjvy3qacwz0dl5jc9h87xhj9q73b0g49c2yrxvv1dhayq0i";
    depends = [ ];
  };
  HarmanData = derive2 {
    name = "HarmanData";
    version = "1.30.0";
    sha256 = "0mqv76lj2amb18k5533r6lc42g4a0jggcj7h2dh1lk1hl973asqg";
    depends = [ ];
  };
  HarmonizedTCGAData = derive2 {
    name = "HarmonizedTCGAData";
    version = "1.24.0";
    sha256 = "1sfb7kzmwdvv71bf56z6sd81dfrs4v53igmnxphrvjiymdjxrb3b";
    depends = [ ExperimentHub ];
  };
  HelloRangesData = derive2 {
    name = "HelloRangesData";
    version = "1.28.0";
    sha256 = "09jrcwrn5vjsva2fz28193llhrysswhxyq83rczi5dnimr5qqnxc";
    depends = [ ];
  };
  HiBED = derive2 {
    name = "HiBED";
    version = "1.0.0";
    sha256 = "1cacjpghp5zbbcvn0fpfyhg56dx9bfa8d2qwf1dvbmwwcm85l0vw";
    depends = [
      AnnotationHub
      dplyr
      FlowSorted_Blood_EPIC
      FlowSorted_DLPFC_450k
      minfi
      SummarizedExperiment
      tibble
    ];
  };
  HiCDataHumanIMR90 = derive2 {
    name = "HiCDataHumanIMR90";
    version = "1.22.0";
    sha256 = "1jy5hpq8vdki23yy3ivlhqj6k80z1rnby4xrk83wk0rxiz4sdxix";
    depends = [ ];
  };
  HiCDataLymphoblast = derive2 {
    name = "HiCDataLymphoblast";
    version = "1.38.0";
    sha256 = "1a6kf55sqqpqs3gk76np9payqj9i75ggn06iy46cazslnhnvmdvg";
    depends = [ ];
  };
  HiContactsData = derive2 {
    name = "HiContactsData";
    version = "1.4.0";
    sha256 = "07i91rz7bn6g27wbjrwgck3mdmj8lrsdda6pza9k1ghh5zssrx7i";
    depends = [
      AnnotationHub
      BiocFileCache
      ExperimentHub
    ];
  };
  HighlyReplicatedRNASeq = derive2 {
    name = "HighlyReplicatedRNASeq";
    version = "1.14.0";
    sha256 = "1zz6xqn9amlh7v7v8c67i4n94lxc8w46g3gqnhbrlcpi6zid36a9";
    depends = [
      ExperimentHub
      S4Vectors
      SummarizedExperiment
    ];
  };
  Hiiragi2013 = derive2 {
    name = "Hiiragi2013";
    version = "1.38.0";
    sha256 = "04ywn2nw551x082v9pxglxl83kfccsds566lwkpa87098i4wdx85";
    depends = [
      affy
      Biobase
      boot
      clue
      cluster
      genefilter
      geneplotter
      gplots
      gtools
      KEGGREST
      lattice
      latticeExtra
      MASS
      mouse4302_db
      RColorBrewer
      xtable
    ];
  };
  HumanAffyData = derive2 {
    name = "HumanAffyData";
    version = "1.28.0";
    sha256 = "0g24nr0jdw6509xjski83jf2r35iklmnhqikmfr90ki4rn0fqar0";
    depends = [
      Biobase
      ExperimentHub
    ];
  };
  IHWpaper = derive2 {
    name = "IHWpaper";
    version = "1.30.0";
    sha256 = "06qbcnq2i0qjc4xqld3gd8746qpvxy4avqba82vzdk0h95kxirmj";
    depends = [
      Biobase
      BiocGenerics
      BiocParallel
      cowplot
      DESeq2
      dplyr
      fdrtool
      genefilter
      ggplot2
      IHW
      qvalue
      Rcpp
      SummarizedExperiment
    ];
  };
  ITALICSData = derive2 {
    name = "ITALICSData";
    version = "2.40.0";
    sha256 = "0fzx2qqykma2r2ds53wik4kb9a0wvybr63vf34s91731k21mgsqn";
    depends = [ ];
  };
  Illumina450ProbeVariants_db = derive2 {
    name = "Illumina450ProbeVariants.db";
    version = "1.38.0";
    sha256 = "1h0qcdmyd22x5y5iwi1w89ppb1k3nb2awwim1lcxgdinab8km52b";
    depends = [ ];
  };
  IlluminaDataTestFiles = derive2 {
    name = "IlluminaDataTestFiles";
    version = "1.40.0";
    sha256 = "08fb7aywjjka5lrpb46cd322sfnhcch5ilf5aq0a2sdq12m2psyi";
    depends = [ ];
  };
  Iyer517 = derive2 {
    name = "Iyer517";
    version = "1.44.0";
    sha256 = "1zahcx2kjspm3bvgxklfgd34srlrxcq9xcj37qa20b08892llkk7";
    depends = [ Biobase ];
  };
  JASPAR2014 = derive2 {
    name = "JASPAR2014";
    version = "1.38.0";
    sha256 = "1ha5nm4v28bfxxa6jqkag7hy0b7bph15v1qs8xwd9w2wam2znazx";
    depends = [ Biostrings ];
  };
  JASPAR2016 = derive2 {
    name = "JASPAR2016";
    version = "1.30.0";
    sha256 = "0dyx29f7jnyqcj85j2yrl8jcphi2kymx2y2mk7ws25xcahl5zzpy";
    depends = [ ];
  };
  KEGGandMetacoreDzPathwaysGEO = derive2 {
    name = "KEGGandMetacoreDzPathwaysGEO";
    version = "1.22.0";
    sha256 = "1rmn5zx5p4c8is5dd80nppl1r8ciyccwhiir0312bpaaplyc9qks";
    depends = [
      Biobase
      BiocGenerics
    ];
  };
  KEGGdzPathwaysGEO = derive2 {
    name = "KEGGdzPathwaysGEO";
    version = "1.40.0";
    sha256 = "05s6cq27cdw9w9laq5hxjiynjavd873w2idpwa1k4kw0rdsni8cb";
    depends = [
      Biobase
      BiocGenerics
    ];
  };
  KOdata = derive2 {
    name = "KOdata";
    version = "1.28.0";
    sha256 = "1dflsvfz7c2ahs60s4wx8mc9ar8qrz9ax8g9m67jchygcmqs4jla";
    depends = [ ];
  };
  LRcellTypeMarkers = derive2 {
    name = "LRcellTypeMarkers";
    version = "1.10.0";
    sha256 = "1wad78cpgf9pl8hl4issb0k1m0dlrk0bradkdz5b5a5pamlwh82c";
    depends = [ ExperimentHub ];
  };
  LiebermanAidenHiC2009 = derive2 {
    name = "LiebermanAidenHiC2009";
    version = "0.40.0";
    sha256 = "06qifvjaxjz51p2vkfdzxjbj5040772y3gzc0qpzsh5fapprkxv9";
    depends = [
      IRanges
      KernSmooth
    ];
  };
  ListerEtAlBSseq = derive2 {
    name = "ListerEtAlBSseq";
    version = "1.34.0";
    sha256 = "15v80d554pai4584dhy3nzwva38b9r6997br7xqysj7v8x2f4392";
    depends = [ methylPipe ];
  };
  LungCancerACvsSCCGEO = derive2 {
    name = "LungCancerACvsSCCGEO";
    version = "1.38.0";
    sha256 = "1d0zfx6sqwanyh67996v008sjkscskm5z24n9siklc9w416nqa63";
    depends = [ ];
  };
  LungCancerLines = derive2 {
    name = "LungCancerLines";
    version = "0.40.0";
    sha256 = "0yr7l7964nkwlz6s9hsdab2sihrngk9wqakrn4pm5h8m15f8ls46";
    depends = [ Rsamtools ];
  };
  M3DExampleData = derive2 {
    name = "M3DExampleData";
    version = "1.28.0";
    sha256 = "0rp1zp14wvfwy67m0ph8amm41frj76gfylacdbdjyblcpdgzzlnq";
    depends = [ ];
  };
  MACSdata = derive2 {
    name = "MACSdata";
    version = "1.10.0";
    sha256 = "117jy39rn972hzwcckx5wdsrsxfzhwbx4wb6air4l7xcb6qmfrj1";
    depends = [ ];
  };
  MAQCsubset = derive2 {
    name = "MAQCsubset";
    version = "1.40.0";
    sha256 = "1qqn4mf2jrdkn28n1npzag50m24j29nm0adcj276s8fgwdayv434";
    depends = [
      affy
      Biobase
      lumi
    ];
  };
  MAQCsubsetILM = derive2 {
    name = "MAQCsubsetILM";
    version = "1.40.0";
    sha256 = "1bb158bmy7195wnj0wap08g621xbzflvj30pv4l7mwc54lm1vqfx";
    depends = [
      Biobase
      lumi
    ];
  };
  MEDIPSData = derive2 {
    name = "MEDIPSData";
    version = "1.38.0";
    sha256 = "1lrxg5vrfqxrnnpn8m3ypk3ikc6pa7pszxfi08gaa3a4c2glcc4m";
    depends = [ ];
  };
  MEEBOdata = derive2 {
    name = "MEEBOdata";
    version = "1.40.0";
    sha256 = "0ni928njn0hm38njgbnz223pvpq1318si12z5d56h3cczi2f3a37";
    depends = [ ];
  };
  MMAPPR2data = derive2 {
    name = "MMAPPR2data";
    version = "1.16.0";
    sha256 = "16ang08nc4jw8m4faacd0rhv47h5wlp771nd6d8bn1r6d5b9si3w";
    depends = [ Rsamtools ];
  };
  MMDiffBamSubset = derive2 {
    name = "MMDiffBamSubset";
    version = "1.38.0";
    sha256 = "1awhcc4zjmzwqc35xv1l2alybbnv1b16bbxn85xywdq0qyj8zgxp";
    depends = [ ];
  };
  MOFAdata = derive2 {
    name = "MOFAdata";
    version = "1.18.0";
    sha256 = "1pl593dlf87g88bdabqqn2a9b1vkgg4znp1l9wbyk49a35l2rqy1";
    depends = [ ];
  };
  MSMB = derive2 {
    name = "MSMB";
    version = "1.20.0";
    sha256 = "1nq9y7c3y0q1040fzsg5hiavqq4n1778cry420f03db1yg40lns0";
    depends = [ tibble ];
  };
  MUGAExampleData = derive2 {
    name = "MUGAExampleData";
    version = "1.22.0";
    sha256 = "1q8bqqpc14iymmmmv87yqzkpjlzq4r801hjav8kymsw66zlqi0rq";
    depends = [ ];
  };
  MerfishData = derive2 {
    name = "MerfishData";
    version = "1.4.1";
    sha256 = "055wmm0r8wyv8i2kil5f5lh5n2kjw36q4yrpqswf0fvdsvvrpaak";
    depends = [
      AnnotationHub
      BumpyMatrix
      EBImage
      ExperimentHub
      S4Vectors
      SingleCellExperiment
      SpatialExperiment
      SummarizedExperiment
    ];
  };
  MetaGxBreast = derive2 {
    name = "MetaGxBreast";
    version = "1.22.0";
    sha256 = "0b0s7g4ijqlsfbr8wdrs1g54hba9ry6i1af71ly0v6l7ff0j65r1";
    depends = [
      AnnotationHub
      Biobase
      ExperimentHub
      impute
      lattice
      SummarizedExperiment
    ];
  };
  MetaGxOvarian = derive2 {
    name = "MetaGxOvarian";
    version = "1.22.0";
    sha256 = "0k144fi1i9c1rlsif2pfk4lyzk25lkpfp1c4yanqqzbij8z50y6k";
    depends = [
      AnnotationHub
      Biobase
      ExperimentHub
      impute
      lattice
      SummarizedExperiment
    ];
  };
  MetaGxPancreas = derive2 {
    name = "MetaGxPancreas";
    version = "1.22.0";
    sha256 = "0a5daghij0c6ykdh2vvd0gmrinqbvnn2hm8apga768ib04ylhb13";
    depends = [
      AnnotationHub
      ExperimentHub
      impute
      S4Vectors
      SummarizedExperiment
    ];
  };
  MetaScope = derive2 {
    name = "MetaScope";
    version = "1.2.0";
    sha256 = "0wpp2h3zldvcw9r8bjbbpcvkd3hgh11dp8qalcbm36kx4djc2d1a";
    depends = [
      BiocFileCache
      Biostrings
      data_table
      dplyr
      ggplot2
      magrittr
      Matrix
      MultiAssayExperiment
      Rbowtie2
      readr
      rlang
      Rsamtools
      S4Vectors
      stringr
      SummarizedExperiment
      taxize
      tidyr
    ];
  };
  MethylAidData = derive2 {
    name = "MethylAidData";
    version = "1.34.0";
    sha256 = "0kn20wsij54c3i2w3yai97qqmnbawsz0326ai5zrlkalkra4w1r9";
    depends = [ MethylAid ];
  };
  MethylSeqData = derive2 {
    name = "MethylSeqData";
    version = "1.12.0";
    sha256 = "0bw450ada6nnz19d2b9qvx0szyldswrsmy21vsm0dw7idh4xfj6c";
    depends = [
      ExperimentHub
      GenomeInfoDb
      GenomicRanges
      HDF5Array
      IRanges
      rhdf5
      S4Vectors
      SummarizedExperiment
    ];
  };
  MicrobiomeBenchmarkData = derive2 {
    name = "MicrobiomeBenchmarkData";
    version = "1.4.0";
    sha256 = "1546ccbnz86scdslf17rzsvyc7h0pb4mw77b17jicfwr8h4qff25";
    depends = [
      ape
      BiocFileCache
      S4Vectors
      SummarizedExperiment
      TreeSummarizedExperiment
    ];
  };
  MouseGastrulationData = derive2 {
    name = "MouseGastrulationData";
    version = "1.16.0";
    sha256 = "0m03wrqgfhlyc0rmjjcj8b9gcc2rv644hffnff3j1bnkjg5rldi0";
    depends = [
      BiocGenerics
      BumpyMatrix
      ExperimentHub
      S4Vectors
      SingleCellExperiment
      SpatialExperiment
      SummarizedExperiment
    ];
  };
  MouseThymusAgeing = derive2 {
    name = "MouseThymusAgeing";
    version = "1.10.0";
    sha256 = "19p7a0k565yz5201klib85z2gwqss0ywbv66sh0bvk4g5cmd9k0y";
    depends = [
      BiocGenerics
      ExperimentHub
      S4Vectors
      SingleCellExperiment
      SummarizedExperiment
    ];
  };
  NCIgraphData = derive2 {
    name = "NCIgraphData";
    version = "1.38.0";
    sha256 = "1haia26flsmh553z0pn4zh4s9w3smkl5q16hmz4vpfwkgc3f9506";
    depends = [ ];
  };
  NGScopyData = derive2 {
    name = "NGScopyData";
    version = "1.22.0";
    sha256 = "0858c5cqkjlk55whiravwmnia26yfkgw4656zfscpdfz2n9xm50m";
    depends = [ ];
  };
  NanoporeRNASeq = derive2 {
    name = "NanoporeRNASeq";
    version = "1.12.0";
    sha256 = "0jvwl6k12acinwsvs62vx7dpnhjbcvhf8sbdw13gwwknrn96hgh4";
    depends = [ ExperimentHub ];
  };
  NestLink = derive2 {
    name = "NestLink";
    version = "1.18.0";
    sha256 = "1nr7ddlrbd4q963750x3cdnn7y6mf2y5q3v37ilhfplypnynlgy1";
    depends = [
      AnnotationHub
      Biostrings
      ExperimentHub
      gplots
      protViz
      ShortRead
    ];
  };
  NetActivityData = derive2 {
    name = "NetActivityData";
    version = "1.4.0";
    sha256 = "1h3ih2y9jl5d3xk5fydgs9s9bsny3lksn67jxmrksxxrabr5zknl";
    depends = [ ];
  };
  Neve2006 = derive2 {
    name = "Neve2006";
    version = "0.40.0";
    sha256 = "0an77i7z2pqrgizd0z5n4iihg9zp3xbl8rgnfphsh9q3fbvwp185";
    depends = [
      annotate
      Biobase
      hgu133a_db
    ];
  };
  NxtIRFdata = derive2 {
    name = "NxtIRFdata";
    version = "1.8.0";
    sha256 = "0gvx81w5krzdzz4v09qlscr0hklzmxq2pz4slwwy1dflq0rjswk5";
    depends = [
      BiocFileCache
      ExperimentHub
      R_utils
      rtracklayer
    ];
  };
  OMICsPCAdata = derive2 {
    name = "OMICsPCAdata";
    version = "1.20.0";
    sha256 = "1jbdyxqyjp4yn6ywk80gin29wi5szwnz661l9hb8gcfbmhv5m1sv";
    depends = [ MultiAssayExperiment ];
  };
  ObMiTi = derive2 {
    name = "ObMiTi";
    version = "1.10.0";
    sha256 = "1sgl38mbnv99miy6n2gps9r5dzhadf1gvin95nif379kdq6xl0nz";
    depends = [
      ExperimentHub
      SummarizedExperiment
    ];
  };
  OnassisJavaLibs = derive2 {
    name = "OnassisJavaLibs";
    version = "1.24.0";
    sha256 = "0ynb0n4d1ic1xhnwvqxvncr3vm5kwl3y0771rivrz6rrynfchy4c";
    depends = [ rJava ];
  };
  PCHiCdata = derive2 {
    name = "PCHiCdata";
    version = "1.30.0";
    sha256 = "19xzn1agfn34y16prfcgwzbz40bw654zj28lhamiv2mvljxy60jx";
    depends = [ Chicago ];
  };
  PREDAsampledata = derive2 {
    name = "PREDAsampledata";
    version = "0.42.0";
    sha256 = "1ps8m8g0s5vsxhhr80ylxcngnn7xipfc70cyxszwmhcwgy1ghwja";
    depends = [
      affy
      annotate
      Biobase
      PREDA
    ];
  };
  PWMEnrich_Dmelanogaster_background = derive2 {
    name = "PWMEnrich.Dmelanogaster.background";
    version = "4.36.0";
    sha256 = "02aiy2qb62r8qgi5gaj2scra46qgf4wh3lzpqvsxbi7c2glnp7ig";
    depends = [ PWMEnrich ];
  };
  PWMEnrich_Hsapiens_background = derive2 {
    name = "PWMEnrich.Hsapiens.background";
    version = "4.36.0";
    sha256 = "0fr775h5k98xspmjpyf363dav38j7cixnmhapfsy8ijijyl4g8jw";
    depends = [ PWMEnrich ];
  };
  PWMEnrich_Mmusculus_background = derive2 {
    name = "PWMEnrich.Mmusculus.background";
    version = "4.36.0";
    sha256 = "1gwmilyikslgp56xrff2sqqm32lmdq589cya19cm0yi7pa17fqdw";
    depends = [ PWMEnrich ];
  };
  PasillaTranscriptExpr = derive2 {
    name = "PasillaTranscriptExpr";
    version = "1.30.0";
    sha256 = "17482ypqdvgc6p3fvkfdwfcpm3gn4rfd6zjsnlbqc99dpikq13sr";
    depends = [ ];
  };
  PathNetData = derive2 {
    name = "PathNetData";
    version = "1.38.0";
    sha256 = "07wq6526ihrzmyk2rql0zpkr6qkg6rdkk2f03lxkaq7fsbidb03q";
    depends = [ ];
  };
  PepsNMRData = derive2 {
    name = "PepsNMRData";
    version = "1.20.0";
    sha256 = "1xy05yd2nzrl2s0bjsr9y94rwcm68gglbijxplalyy3ppcwwm55c";
    depends = [ ];
  };
  PhyloProfileData = derive2 {
    name = "PhyloProfileData";
    version = "1.16.0";
    sha256 = "1r51zrvm8n7w66ii97wz6ncz0d7s473ppdn8b958mh15w81rk5fr";
    depends = [
      BiocStyle
      Biostrings
      ExperimentHub
    ];
  };
  ProData = derive2 {
    name = "ProData";
    version = "1.40.0";
    sha256 = "099xf8143k2z74nb1hdlswrv1gjmg41255x0njxa4wzdwlpyp5k2";
    depends = [ Biobase ];
  };
  PtH2O2lipids = derive2 {
    name = "PtH2O2lipids";
    version = "1.28.0";
    sha256 = "1rx0sg5nz7i20d74y0cq6nybc1q62h0d9rpi3dk02jfngk3zzb5d";
    depends = [
      CAMERA
      LOBSTAHS
      xcms
    ];
  };
  QDNAseq_hg19 = derive2 {
    name = "QDNAseq.hg19";
    version = "1.32.0";
    sha256 = "01fnbbkyfpim0xh6v0bm553pmrg9n3bnwn4adds0p47lai1n7dr8";
    depends = [ QDNAseq ];
  };
  QDNAseq_mm10 = derive2 {
    name = "QDNAseq.mm10";
    version = "1.32.0";
    sha256 = "0x54ncmxqb1qci41qy7q9gskx7zp1rcpad3wvil023h81l1s5pg6";
    depends = [ QDNAseq ];
  };
  QUBICdata = derive2 {
    name = "QUBICdata";
    version = "1.30.0";
    sha256 = "0apbndslrdrflmwvz456q31x3mr1p7v7kpbl0fp0hajadjb38aha";
    depends = [ ];
  };
  RGMQLlib = derive2 {
    name = "RGMQLlib";
    version = "1.22.0";
    sha256 = "1sys8vji70mkd100zy84ywv6ralr5k7z1044rn03wp75s1h8klwy";
    depends = [ ];
  };
  RITANdata = derive2 {
    name = "RITANdata";
    version = "1.26.0";
    sha256 = "0jkcf4g2h6bpx0v8ybwnrni3qq9hajxxprfq9pszpmf4xb9cmgs2";
    depends = [ ];
  };
  RMassBankData = derive2 {
    name = "RMassBankData";
    version = "1.40.0";
    sha256 = "190q4q8201i1v3bb4snasxy2kbwvnppq9kpqmxa1hg9mlvk643fq";
    depends = [ ];
  };
  RNAinteractMAPK = derive2 {
    name = "RNAinteractMAPK";
    version = "1.40.0";
    sha256 = "0s5bb73ixp2zhzj0ssq3kai6ijrpn9flg23f1n2vsi2vf66wfajj";
    depends = [
      Biobase
      fields
      gdata
      genefilter
      lattice
      MASS
      RNAinteract
      sparseLDA
    ];
  };
  RNAmodR_Data = derive2 {
    name = "RNAmodR.Data";
    version = "1.16.0";
    sha256 = "0p9x1j4ra11banvifh5z07i26b2s59b2knbgj44yx4qi0d3cnn81";
    depends = [
      ExperimentHub
      ExperimentHubData
    ];
  };
  RNAseqData_HNRNPC_bam_chr14 = derive2 {
    name = "RNAseqData.HNRNPC.bam.chr14";
    version = "0.40.0";
    sha256 = "1gdwsbkjnb3927ihq2gbwrksvhm61wm114bwhazypmpnnwcfv27f";
    depends = [ ];
  };
  RRBSdata = derive2 {
    name = "RRBSdata";
    version = "1.22.0";
    sha256 = "1visrkyxljp3d7h7qgf72l71w91vah93qmi733s15zmsm090sf1c";
    depends = [ BiSeq ];
  };
  RTCGA_CNV = derive2 {
    name = "RTCGA.CNV";
    version = "1.30.0";
    sha256 = "0akfifgkkhzrrw21gxm4h2liam5f7rd2ghidyr21c6660wg1444c";
    depends = [ RTCGA ];
  };
  RTCGA_PANCAN12 = derive2 {
    name = "RTCGA.PANCAN12";
    version = "1.30.0";
    sha256 = "1iz72gbpm0msiasrc0xyiw9c3s2a59fgbz7kfrlwskspqvm9pvdl";
    depends = [ RTCGA ];
  };
  RTCGA_RPPA = derive2 {
    name = "RTCGA.RPPA";
    version = "1.30.0";
    sha256 = "1ln4v06pf2skxaa0vcwp9m2vkczm5bc37kfczqg022n0fi7wa084";
    depends = [ RTCGA ];
  };
  RTCGA_clinical = derive2 {
    name = "RTCGA.clinical";
    version = "20151101.32.0";
    sha256 = "0ivfq9z66v9a867v4c6581v7pmbcwy1g6fr5bgs1fp0n7rl6b15g";
    depends = [ RTCGA ];
  };
  RTCGA_mRNA = derive2 {
    name = "RTCGA.mRNA";
    version = "1.30.0";
    sha256 = "1wf5rxxxa3qgihpa9hbcabryz74k3vc1yp2mscs4w0zdym48fw78";
    depends = [ RTCGA ];
  };
  RTCGA_methylation = derive2 {
    name = "RTCGA.methylation";
    version = "1.30.0";
    sha256 = "1g543scp553gya9ax7c7rm93gra1mqhv93y8jj9hvv7sq5mx469j";
    depends = [ RTCGA ];
  };
  RTCGA_miRNASeq = derive2 {
    name = "RTCGA.miRNASeq";
    version = "1.30.0";
    sha256 = "1hvb77c44vbhyqbpqrid5vrashqng3clpqm5svr7fq6xhqaj3v34";
    depends = [ RTCGA ];
  };
  RTCGA_mutations = derive2 {
    name = "RTCGA.mutations";
    version = "20151101.32.0";
    sha256 = "1n265xk9rr491rlcgy98nvvxmnhjf9b4x80qbc9xlb0ks3hpgx13";
    depends = [ RTCGA ];
  };
  RTCGA_rnaseq = derive2 {
    name = "RTCGA.rnaseq";
    version = "20151101.32.0";
    sha256 = "1nmn9dqp6kdsz7536wln8wv1ms8nlgys7xlmc555q1irc1pz4ksc";
    depends = [ RTCGA ];
  };
  RUVnormalizeData = derive2 {
    name = "RUVnormalizeData";
    version = "1.22.0";
    sha256 = "1sqkvkwlvwwspj6xg3xq062s2brr6yjmhw5dlccrjff0qcc9w41p";
    depends = [ Biobase ];
  };
  RcisTarget_hg19_motifDBs_cisbpOnly_500bp = derive2 {
    name = "RcisTarget.hg19.motifDBs.cisbpOnly.500bp";
    version = "1.22.0";
    sha256 = "0yhalgrj0p99ka7wfcnb70adjy4n7zlk9caxd5fk8hhspzkwzkfp";
    depends = [ data_table ];
  };
  ReactomeGSA_data = derive2 {
    name = "ReactomeGSA.data";
    version = "1.16.1";
    sha256 = "18n4shnlbgz6vv63hljzcpz1yd2y4p0gwgj6i37lvr4p7hmg7bi3";
    depends = [
      edgeR
      limma
      ReactomeGSA
      Seurat
    ];
  };
  RegParallel = derive2 {
    name = "RegParallel";
    version = "1.20.0";
    sha256 = "0fxvzj5vgsdq2jm467a5ddya5p6603rzhklh8hmdn9d352yzy01i";
    depends = [
      arm
      data_table
      doParallel
      foreach
      iterators
      stringr
      survival
    ];
  };
  RforProteomics = derive2 {
    name = "RforProteomics";
    version = "1.40.0";
    sha256 = "11cjlhvk04r0flf0wr7n4qmlazaaw4kd5gs589h95mblsmk4andx";
    depends = [
      BiocManager
      biocViews
      MSnbase
      R_utils
    ];
  };
  RnBeads_hg19 = derive2 {
    name = "RnBeads.hg19";
    version = "1.34.0";
    sha256 = "0mv6pqkhwiwdq72dh0m79c7inpkvz8nwy4m8b93sjy1wi76wgci6";
    depends = [ GenomicRanges ];
  };
  RnBeads_hg38 = derive2 {
    name = "RnBeads.hg38";
    version = "1.34.0";
    sha256 = "19l875n3injnn1af01jmlf62a6dgd9mn54ppcsy1x71wrcs1lk25";
    depends = [ GenomicRanges ];
  };
  RnBeads_mm10 = derive2 {
    name = "RnBeads.mm10";
    version = "2.10.0";
    sha256 = "0x1nxgdwad42k39mrfilbi1kkm9avm0cbcrhsrxs67ajng9qmci8";
    depends = [ GenomicRanges ];
  };
  RnBeads_mm9 = derive2 {
    name = "RnBeads.mm9";
    version = "1.34.0";
    sha256 = "1d7lshk5a8zn4wi4f5b8q4d206i379iv6gxxsbzygrlnk74j9kzf";
    depends = [ GenomicRanges ];
  };
  RnBeads_rn5 = derive2 {
    name = "RnBeads.rn5";
    version = "1.34.0";
    sha256 = "182pdfi6dvz4r5v41r62d0rsxkm5vlrl7y6pwx9nx3h1gaiybl8s";
    depends = [ GenomicRanges ];
  };
  RnaSeqSampleSizeData = derive2 {
    name = "RnaSeqSampleSizeData";
    version = "1.34.0";
    sha256 = "0p2q7phn40ax94yh43xg72fmnnljfi6cfiyaad39br1hi2b6hrjf";
    depends = [ edgeR ];
  };
  SBGNview_data = derive2 {
    name = "SBGNview.data";
    version = "1.16.0";
    sha256 = "1nprhg7rkia9jwy8mqx7iqdh1qs81nk9al8fvv1ynq2cc9x77jfr";
    depends = [
      bookdown
      knitr
      rmarkdown
    ];
  };
  SCLCBam = derive2 {
    name = "SCLCBam";
    version = "1.34.0";
    sha256 = "0jnpg8qdbd5b6809glzg68n12bavnpqaaarn2vfv5c6055qg6jgy";
    depends = [ ];
  };
  SFEData = derive2 {
    name = "SFEData";
    version = "1.4.0";
    sha256 = "0wkb27cs4zvvhclgk2slx8n7jx1mx3q87kn86n4rjdcx2074ndqz";
    depends = [
      AnnotationHub
      BiocFileCache
      ExperimentHub
    ];
  };
  SNAData = derive2 {
    name = "SNAData";
    version = "1.48.0";
    sha256 = "0qd48ggg1wjy5h47hzl9iqzy13gsxxn4f7fq4b0ra35vhckmcvyf";
    depends = [ graph ];
  };
  SNAGEEdata = derive2 {
    name = "SNAGEEdata";
    version = "1.38.0";
    sha256 = "17wbf4xsljkryzjpk57kvjbiln0ig8d717j953wy0inz7vzdkpkn";
    depends = [ ];
  };
  SNPhoodData = derive2 {
    name = "SNPhoodData";
    version = "1.32.0";
    sha256 = "0p8361lmlfz496ivw9qaqkg7b3hr4gb9g9r73fxp6amy2xncb00g";
    depends = [ ];
  };
  STexampleData = derive2 {
    name = "STexampleData";
    version = "1.10.1";
    sha256 = "1fr29mnczvglpkwh4vdy6klahv014ikmxwx055x4grkxvygbqm23";
    depends = [
      ExperimentHub
      SpatialExperiment
    ];
  };
  SVM2CRMdata = derive2 {
    name = "SVM2CRMdata";
    version = "1.34.0";
    sha256 = "1k7cjakxcqq86xvx0d0799hb94hi7w05amd9yncd0nf4dcy6zm0f";
    depends = [ ];
  };
  SimBenchData = derive2 {
    name = "SimBenchData";
    version = "1.10.0";
    sha256 = "1g5wff2hx3sra48wcvwh3hs9lpfavq2pqflcm9wfcch9y10m8iqd";
    depends = [
      ExperimentHub
      S4Vectors
    ];
  };
  Single_mTEC_Transcriptomes = derive2 {
    name = "Single.mTEC.Transcriptomes";
    version = "1.30.0";
    sha256 = "1w3f71mfq74sjlsasi87gvqs2mhny41zm22zswz9km5msi8r2wva";
    depends = [ ];
  };
  SingleCellMultiModal = derive2 {
    name = "SingleCellMultiModal";
    version = "1.14.0";
    sha256 = "0kwff2nqv7nf7rqifyzr6klba6k1h29y4332b60k7hv3psjsm015";
    depends = [
      AnnotationHub
      BiocBaseUtils
      BiocFileCache
      ExperimentHub
      HDF5Array
      Matrix
      MultiAssayExperiment
      S4Vectors
      SingleCellExperiment
      SpatialExperiment
      SummarizedExperiment
    ];
  };
  SingleMoleculeFootprintingData = derive2 {
    name = "SingleMoleculeFootprintingData";
    version = "1.10.0";
    sha256 = "1chlik8ycsiw0kvxikiplb5xkj4afi4qniy666csyqlksaflr703";
    depends = [ ExperimentHub ];
  };
  SomatiCAData = derive2 {
    name = "SomatiCAData";
    version = "1.40.0";
    sha256 = "0m92db12a9h7866l3vbvpqnxnvkbik8znh3l6qyl22l438wvd8b2";
    depends = [ ];
  };
  SomaticCancerAlterations = derive2 {
    name = "SomaticCancerAlterations";
    version = "1.38.0";
    sha256 = "140bn20n60dnsb3li0ygnymfb7wwgh523yx8pmc6zvyx6izdg618";
    depends = [
      GenomicRanges
      IRanges
      S4Vectors
    ];
  };
  SpatialDatasets = derive2 {
    name = "SpatialDatasets";
    version = "1.0.0";
    sha256 = "1szsggymx05swr4i5mgxcxk7jbz8qh6xxwpnmmzajns03gmszggy";
    depends = [
      ExperimentHub
      SpatialExperiment
    ];
  };
  SpikeIn = derive2 {
    name = "SpikeIn";
    version = "1.44.0";
    sha256 = "04saqrdzl1irdbvgr9s86sgwsvnlp5l4xbx16wj41476rbzhg2aw";
    depends = [ affy ];
  };
  SpikeInSubset = derive2 {
    name = "SpikeInSubset";
    version = "1.42.0";
    sha256 = "14w4g6n0nn1mg9wifqp2jrxb0hy2sqfcnycwhvir1znfck83fzir";
    depends = [
      affy
      Biobase
    ];
  };
  TBX20BamSubset = derive2 {
    name = "TBX20BamSubset";
    version = "1.38.0";
    sha256 = "1f09l2ihh80cqqg6sw5ypa51c1zsspkq2g06lbfi19zgllcfh80f";
    depends = [
      Rsamtools
      xtable
    ];
  };
  TCGAMethylation450k = derive2 {
    name = "TCGAMethylation450k";
    version = "1.38.0";
    sha256 = "0pz8xmi4zxp1qvpcwhf54sy5lhpaspdlad1dlrhxgjbfm8xl535q";
    depends = [ ];
  };
  TCGAWorkflowData = derive2 {
    name = "TCGAWorkflowData";
    version = "1.26.0";
    sha256 = "03p3ifgr9w737v9dvx1qvj2kdyf1l9a2qnmwii0nmlak9dp1cc52";
    depends = [ SummarizedExperiment ];
  };
  TCGAbiolinksGUI_data = derive2 {
    name = "TCGAbiolinksGUI.data";
    version = "1.22.0";
    sha256 = "04fmnqa95rb2lgflcg3d7kbz9jj990r9hlxwlhhzb79dv9wd1mfa";
    depends = [ ];
  };
  TCGAcrcmRNA = derive2 {
    name = "TCGAcrcmRNA";
    version = "1.22.0";
    sha256 = "0vwd0pi8g4pmz8g61c0mr0njha6qsm5m1z7iyf0lnwrm6y6bv6px";
    depends = [ Biobase ];
  };
  TCGAcrcmiRNA = derive2 {
    name = "TCGAcrcmiRNA";
    version = "1.22.0";
    sha256 = "0qrcj2mb58dwdwfpypnwyb2f7kcjjyqnyz4v42rc43r04xy14l2m";
    depends = [ Biobase ];
  };
  TENxBUSData = derive2 {
    name = "TENxBUSData";
    version = "1.16.0";
    sha256 = "071qbq0avzbs6c64l6lrmrs1hmbrg98bnf91vpz4x7s0p5axx87n";
    depends = [
      AnnotationHub
      BiocGenerics
      ExperimentHub
    ];
  };
  TENxBrainData = derive2 {
    name = "TENxBrainData";
    version = "1.22.0";
    sha256 = "1ia7a6jq7giy130avgv5brffxk5r2yql7rjppxs9nab3a6y472yy";
    depends = [
      AnnotationHub
      ExperimentHub
      HDF5Array
      SingleCellExperiment
    ];
  };
  TENxPBMCData = derive2 {
    name = "TENxPBMCData";
    version = "1.20.0";
    sha256 = "09pgf31x1zqcrnvf2fwdbx4qn7pgsaby8damxcfq5xr3iksqhdwb";
    depends = [
      AnnotationHub
      ExperimentHub
      HDF5Array
      SingleCellExperiment
    ];
  };
  TENxVisiumData = derive2 {
    name = "TENxVisiumData";
    version = "1.10.0";
    sha256 = "0yi7axdam9b0ps0818cgygbmjcdknn032bm2snb6xf3g4i8n45f4";
    depends = [
      ExperimentHub
      SpatialExperiment
    ];
  };
  TMExplorer = derive2 {
    name = "TMExplorer";
    version = "1.12.0";
    sha256 = "0vi99vpbfzwwqpdxgjlhcr835nnbfngwz6fag9kvd7ndicb21zy4";
    depends = [
      BiocFileCache
      Matrix
      SingleCellExperiment
    ];
  };
  TabulaMurisData = derive2 {
    name = "TabulaMurisData";
    version = "1.20.0";
    sha256 = "1p0pyvgwzbnkx1687n2j7gxjzb5s49r1njklsff0di66m8nlis7k";
    depends = [ ExperimentHub ];
  };
  TabulaMurisSenisData = derive2 {
    name = "TabulaMurisSenisData";
    version = "1.8.0";
    sha256 = "0f6gj56rgcv378ry4h1sgm3zhv083yh23qf1pj9rvabwhdfgk8p1";
    depends = [
      AnnotationHub
      ExperimentHub
      gdata
      HDF5Array
      SingleCellExperiment
      SummarizedExperiment
    ];
  };
  TargetScoreData = derive2 {
    name = "TargetScoreData";
    version = "1.38.0";
    sha256 = "19s1jxrh04gfkx7a9h59v6vl063wlf2j71bi6lxq9lm689y23z4k";
    depends = [ ];
  };
  TargetSearchData = derive2 {
    name = "TargetSearchData";
    version = "1.40.0";
    sha256 = "12z820mwi779dlmg5hf1cq5gpvrxg9ijb38s43fbzzgagn25czff";
    depends = [ ];
  };
  TimerQuant = derive2 {
    name = "TimerQuant";
    version = "1.32.0";
    sha256 = "18jl2x9ywfwm4ir2kwa9y4fq0lsz0295lx7f7qz08l4d1yrb1w4v";
    depends = [
      deSolve
      dplyr
      ggplot2
      gridExtra
      locfit
      shiny
    ];
  };
  TumourMethData = derive2 {
    name = "TumourMethData";
    version = "1.0.0";
    sha256 = "100kw4552rc48sqpw9makyf9nwgrs049hkvbrd8zjmrf542cj9md";
    depends = [
      ExperimentHub
      GenomicRanges
      HDF5Array
      R_utils
      rhdf5
      SummarizedExperiment
    ];
  };
  VariantToolsData = derive2 {
    name = "VariantToolsData";
    version = "1.26.0";
    sha256 = "0jj8wp2mp0xgd4hixyb59bykxbbpklncjj39ra5nyw4h4ziwrbfm";
    depends = [
      BiocGenerics
      GenomicRanges
      VariantAnnotation
    ];
  };
  VectraPolarisData = derive2 {
    name = "VectraPolarisData";
    version = "1.6.0";
    sha256 = "0zr94qgyj365sy7cyzjsm9zbxyv6zbd8lwfr1nqz0p6f6hb9b8qw";
    depends = [
      ExperimentHub
      SpatialExperiment
    ];
  };
  WES_1KG_WUGSC = derive2 {
    name = "WES.1KG.WUGSC";
    version = "1.34.0";
    sha256 = "1p8z4p1s5l4hlp78ifiy3gan1n8iljaafbqv88vxwbjh2x9gfnjl";
    depends = [ ];
  };
  WGSmapp = derive2 {
    name = "WGSmapp";
    version = "1.14.0";
    sha256 = "0yv323mkv681f20dzjh1xaz19xbn4j777xxlmq27rvmk3j1vfah9";
    depends = [ GenomicRanges ];
  };
  WeberDivechaLCdata = derive2 {
    name = "WeberDivechaLCdata";
    version = "1.4.1";
    sha256 = "00ws47shsfnwi6c3ah56bm6dvicfhfr50jadll613fddv7cxkfsw";
    depends = [
      ExperimentHub
      SingleCellExperiment
      SpatialExperiment
    ];
  };
  XhybCasneuf = derive2 {
    name = "XhybCasneuf";
    version = "1.40.0";
    sha256 = "1qzbsmqn9y1483108pzh8zkiw1q1xzghincrcmz8cl2a4q10hyxf";
    depends = [
      affy
      ath1121501cdf
      RColorBrewer
      tinesath1cdf
    ];
  };
  adductData = derive2 {
    name = "adductData";
    version = "1.18.0";
    sha256 = "16c79wy55p4ryglxph80dibfm1ni8c5yfk6fnmq064ihw4zwcld5";
    depends = [
      AnnotationHub
      ExperimentHub
    ];
  };
  affycompData = derive2 {
    name = "affycompData";
    version = "1.40.0";
    sha256 = "183wgbc4j7f9d4rwr9smndnmw1i390abak23wp6p02zk340qmvq4";
    depends = [
      affycomp
      Biobase
    ];
  };
  affydata = derive2 {
    name = "affydata";
    version = "1.50.0";
    sha256 = "1p9gqv8xnakwhf4sani09krlrq6qs4gr8yfjmi8g3s1zq4d32h1k";
    depends = [ affy ];
  };
  airway = derive2 {
    name = "airway";
    version = "1.22.0";
    sha256 = "1xs5bw6azvcdwh9325alndzrp82alxxqwpkf60zsk2q7lv43nwbr";
    depends = [ SummarizedExperiment ];
  };
  antiProfilesData = derive2 {
    name = "antiProfilesData";
    version = "1.38.0";
    sha256 = "0nbg37w6ij9vpj0mrbsx35naqv48kg8kkfl3x39ycbl860mrbr0b";
    depends = [ Biobase ];
  };
  aracne_networks = derive2 {
    name = "aracne.networks";
    version = "1.28.0";
    sha256 = "16gy79hgy07kynjf2s1lrh6a86brhz1caylginmkw547hal43nvf";
    depends = [ viper ];
  };
  bcellViper = derive2 {
    name = "bcellViper";
    version = "1.38.0";
    sha256 = "1q9ig5z03flq57nrhwnk6gdz4kamjmpwdfifwvnhac3l3f5z828h";
    depends = [ Biobase ];
  };
  beadarrayExampleData = derive2 {
    name = "beadarrayExampleData";
    version = "1.40.0";
    sha256 = "1mb821p4hf9fmj0f7s0rxwbxv8kb5ln0x2gfnydg4jnyz7k9w5p8";
    depends = [
      beadarray
      Biobase
    ];
  };
  benchmarkfdrData2019 = derive2 {
    name = "benchmarkfdrData2019";
    version = "1.16.0";
    sha256 = "1p441c08bxx81z556n5wrzxkbq5g4lrwkp1wk7jh6zk6qs3jqg96";
    depends = [
      ExperimentHub
      SummarizedExperiment
    ];
  };
  beta7 = derive2 {
    name = "beta7";
    version = "1.40.0";
    sha256 = "1q77pmvjnwyi0hm0dmi45a5fcj1phhz9r2fvz4vnmq5b632zp30v";
    depends = [ marray ];
  };
  biotmleData = derive2 {
    name = "biotmleData";
    version = "1.26.0";
    sha256 = "06lnkwqzsk4v241309w174ia6x8iksh7rvk3z8l0xr6hf31sg5gw";
    depends = [ ];
  };
  biscuiteerData = derive2 {
    name = "biscuiteerData";
    version = "1.16.0";
    sha256 = "1wqdj1499psnf9y816k05m6h38yfsin4rwzqm1209ddxza6jbw1x";
    depends = [
      AnnotationHub
      curl
      ExperimentHub
      GenomicRanges
    ];
  };
  bladderbatch = derive2 {
    name = "bladderbatch";
    version = "1.40.0";
    sha256 = "19dgvdbxsswy1fl68wwf4ifplppm1blzjw1dr06mz0yjq80a7rvl";
    depends = [ Biobase ];
  };
  blimaTestingData = derive2 {
    name = "blimaTestingData";
    version = "1.22.0";
    sha256 = "14rlw5xxgbybsrzmzncqwzkc617gfays5z8x6ifigfdlrp5h1rpl";
    depends = [ ];
  };
  bodymapRat = derive2 {
    name = "bodymapRat";
    version = "1.18.0";
    sha256 = "1sfq6vxkb68l0q5qbnpm3fi53k4q9a890bv2ff9c6clhc42wx3h6";
    depends = [
      ExperimentHub
      SummarizedExperiment
    ];
  };
  breakpointRdata = derive2 {
    name = "breakpointRdata";
    version = "1.20.0";
    sha256 = "13w9vp436akpnywhsr6kz763c2yakrvpyiplggfb6w50wi2xm5xj";
    depends = [ ];
  };
  breastCancerMAINZ = derive2 {
    name = "breastCancerMAINZ";
    version = "1.40.0";
    sha256 = "1nbvacb04ka0p88hailawz0i4472gaagxy0yw9qg83f9da1dzm4l";
    depends = [ ];
  };
  breastCancerNKI = derive2 {
    name = "breastCancerNKI";
    version = "1.40.0";
    sha256 = "0q3lvq447jw3ny2896mz009x0ijdxgy4xgk4y00sv9nsbwic1ais";
    depends = [ ];
  };
  breastCancerTRANSBIG = derive2 {
    name = "breastCancerTRANSBIG";
    version = "1.40.0";
    sha256 = "03q9y9cbipp8a275hcw5yzwx7l5qrc6fqzdy8vy7z5ij825ygnad";
    depends = [ ];
  };
  breastCancerUNT = derive2 {
    name = "breastCancerUNT";
    version = "1.40.0";
    sha256 = "0p11hll0pjzycgqbjhcn06vcah7kfvxbzsrqvbwglajs0b5m6dra";
    depends = [ ];
  };
  breastCancerUPP = derive2 {
    name = "breastCancerUPP";
    version = "1.40.0";
    sha256 = "0mi9dqbx7fyrxmc4l12c0x6i865f5691f94wzw88q2hwzzz80n6p";
    depends = [ ];
  };
  breastCancerVDX = derive2 {
    name = "breastCancerVDX";
    version = "1.40.0";
    sha256 = "12r8zql30ssr0cxy8v1qawwsky54321c737ny19n2yrl7sm08gf0";
    depends = [ ];
  };
  brgedata = derive2 {
    name = "brgedata";
    version = "1.24.0";
    sha256 = "0nplh5km45hdb001mc86fh9yyj56mfvcr2g0zffq0nbjlpvspz0i";
    depends = [
      Biobase
      SummarizedExperiment
    ];
  };
  bronchialIL13 = derive2 {
    name = "bronchialIL13";
    version = "1.40.0";
    sha256 = "110791bhnpzadc2ja8i59bix42ficqxqw3il8hnqb38i7c43w0zw";
    depends = [ affy ];
  };
  bsseqData = derive2 {
    name = "bsseqData";
    version = "0.40.0";
    sha256 = "15fyv6l6bsa4fk4qxpfgxgw5aq1dd3pry84zapklijxm24g6yl6j";
    depends = [ bsseq ];
  };
  cMap2data = derive2 {
    name = "cMap2data";
    version = "1.38.0";
    sha256 = "1d2yv9gq3w1b50f602ajbdqky5vwsh19qqg8a3czlphghrjrlfwd";
    depends = [ ];
  };
  cancerdata = derive2 {
    name = "cancerdata";
    version = "1.40.0";
    sha256 = "1670df52ainxq220vzblrv2jml2bql8vid09b51dzhjhikwzxhs4";
    depends = [ Biobase ];
  };
  ccTutorial = derive2 {
    name = "ccTutorial";
    version = "1.40.0";
    sha256 = "1rqblyk7389xqwzvib2xjyjrc8l3qd2g8z9vj96mrfyr8dpccjjs";
    depends = [
      affy
      Biobase
      Ringo
      topGO
    ];
  };
  ccdata = derive2 {
    name = "ccdata";
    version = "1.28.0";
    sha256 = "1vskwqb0n3qfgmakc8zlvfkag653gkz3l9j8lqnhxbbnnads738j";
    depends = [ ];
  };
  celarefData = derive2 {
    name = "celarefData";
    version = "1.20.0";
    sha256 = "11vx5hmbjsfzyxgb8qzhy3f54krcp33h8ki61irxxl06q2n59928";
    depends = [ ];
  };
  celldex = derive2 {
    name = "celldex";
    version = "1.12.0";
    sha256 = "1ckjdmiw9g1wdswijy3dvamv3kqi11j8b8p9dgr1yv5q2lfjbnwl";
    depends = [
      AnnotationDbi
      AnnotationHub
      DelayedArray
      DelayedMatrixStats
      ExperimentHub
      S4Vectors
      SummarizedExperiment
    ];
  };
  cfToolsData = derive2 {
    name = "cfToolsData";
    version = "1.0.0";
    sha256 = "0icr4llq99ghyvi8nsdfnp5sydh8icr23y8ar7jg0qpwiagdl3l9";
    depends = [ ExperimentHub ];
  };
  chipenrich_data = derive2 {
    name = "chipenrich.data";
    version = "2.26.0";
    sha256 = "0hfisbzbhz501dvcwvx3cnag9643ydw6f0q122w7mrnzsag82013";
    depends = [
      AnnotationDbi
      BiocGenerics
      GenomeInfoDb
      GenomicRanges
      IRanges
      readr
      rtracklayer
      S4Vectors
    ];
  };
  chipseqDBData = derive2 {
    name = "chipseqDBData";
    version = "1.18.0";
    sha256 = "114645f6db8pp263g6h2gb2cwhdgqh8risssq2vfzzdv16qqw640";
    depends = [
      AnnotationHub
      ExperimentHub
      Rsamtools
      S4Vectors
    ];
  };
  chromstaRData = derive2 {
    name = "chromstaRData";
    version = "1.28.0";
    sha256 = "13xrdr9xrfysh714q4p00pgvwr6ryhvd3jinfqr1gb27s7bdvsi6";
    depends = [ ];
  };
  clustifyrdatahub = derive2 {
    name = "clustifyrdatahub";
    version = "1.12.0";
    sha256 = "004g6s917ayxiixlc8zp4h7zai9amcm6bllr9mz5j9sgm8kd8px4";
    depends = [ ExperimentHub ];
  };
  cnvGSAdata = derive2 {
    name = "cnvGSAdata";
    version = "1.38.0";
    sha256 = "1aask6cx972qw62p2p16n1sk0rjmrr9hhqlaaab52rn4lfdiaba2";
    depends = [ cnvGSA ];
  };
  colonCA = derive2 {
    name = "colonCA";
    version = "1.44.0";
    sha256 = "0qkjmbyh5hwfjw657qam7xpjnym4qqbv1292fbqzwdyr0019jpfn";
    depends = [ Biobase ];
  };
  crisprScoreData = derive2 {
    name = "crisprScoreData";
    version = "1.6.0";
    sha256 = "0rrwsfp8m8z389yfr8ls6wkz7faa2iz8pnljl2776qa3zgsfmhni";
    depends = [
      AnnotationHub
      ExperimentHub
    ];
  };
  curatedAdipoArray = derive2 {
    name = "curatedAdipoArray";
    version = "1.14.0";
    sha256 = "06dcb58i86gg4ar3hyh5w8kdqd0rf1ps7l021nfwklzm622b4wzc";
    depends = [ ];
  };
  curatedAdipoChIP = derive2 {
    name = "curatedAdipoChIP";
    version = "1.18.0";
    sha256 = "16g8k2cvi890b9j30yzm7lxnxljl2k4x1yxvd8cg1ba94vzimw6k";
    depends = [
      ExperimentHub
      SummarizedExperiment
    ];
  };
  curatedAdipoRNA = derive2 {
    name = "curatedAdipoRNA";
    version = "1.18.0";
    sha256 = "1dy58ppw1ck89p036y6iml9210hv7f4zvsm0wi5m13b4ij7a749p";
    depends = [ SummarizedExperiment ];
  };
  curatedBladderData = derive2 {
    name = "curatedBladderData";
    version = "1.38.0";
    sha256 = "1i9hbm8gh9f09fzyjga7rjps7hlbsivnnbpk8fgb0838msjq5bl2";
    depends = [ affy ];
  };
  curatedBreastData = derive2 {
    name = "curatedBreastData";
    version = "2.30.0";
    sha256 = "127kjiqb2laz77cx9lr0rs43kgwxyi52rd7ivhfpcxhivsg4hcsr";
    depends = [
      Biobase
      BiocStyle
      ggplot2
      impute
      XML
    ];
  };
  curatedCRCData = derive2 {
    name = "curatedCRCData";
    version = "2.34.0";
    sha256 = "1dqcdpzls41adih54wfpcb36mpysw0za14pz4wsjwisqnjwzpxvn";
    depends = [
      BiocGenerics
      nlme
    ];
  };
  curatedMetagenomicData = derive2 {
    name = "curatedMetagenomicData";
    version = "3.10.0";
    sha256 = "0fgvpxc1878lm8l0bib12zzwrgsap0vw4zn77qpz1mljnz43shcb";
    depends = [
      AnnotationHub
      dplyr
      ExperimentHub
      magrittr
      mia
      purrr
      rlang
      S4Vectors
      stringr
      SummarizedExperiment
      tibble
      tidyr
      tidyselect
      TreeSummarizedExperiment
    ];
  };
  curatedOvarianData = derive2 {
    name = "curatedOvarianData";
    version = "1.40.1";
    sha256 = "18163l0g3g042m2qgz143smxia3lp8v7rddkqmkg4hzns7baxfaa";
    depends = [
      Biobase
      BiocGenerics
    ];
  };
  curatedTBData = derive2 {
    name = "curatedTBData";
    version = "1.8.0";
    sha256 = "116ck61pw6diili326x0x8p7f8d5w624n4w3pd212vhq8555yrqs";
    depends = [
      AnnotationHub
      ExperimentHub
      MultiAssayExperiment
      rlang
    ];
  };
  curatedTCGAData = derive2 {
    name = "curatedTCGAData";
    version = "1.24.1";
    sha256 = "0hr66p8l54nzfsizcxxd2njy44xnia607wvfhrgv46f3f8s95z02";
    depends = [
      AnnotationHub
      ExperimentHub
      HDF5Array
      MultiAssayExperiment
      S4Vectors
      SummarizedExperiment
    ];
  };
  davidTiling = derive2 {
    name = "davidTiling";
    version = "1.42.0";
    sha256 = "1xfkyncwi9zrynk6dqsmacmkxx2qvj1axda3wn55b1vbw2wimpyf";
    depends = [
      Biobase
      GO_db
      tilingArray
    ];
  };
  depmap = derive2 {
    name = "depmap";
    version = "1.16.0";
    sha256 = "1vb3f5ar2jlkjyhp7rv4imlylinm6fi94ki277jgdaxn12v78qxj";
    depends = [
      AnnotationHub
      dplyr
      ExperimentHub
    ];
  };
  derfinderData = derive2 {
    name = "derfinderData";
    version = "2.20.0";
    sha256 = "1h8rl8mnxk2lsl8xa8mihvbd77yw32fpxdbhhn4rv1v8i5j35r7l";
    depends = [ ];
  };
  diffloopdata = derive2 {
    name = "diffloopdata";
    version = "1.30.0";
    sha256 = "1f0gnwpjxkby7kd2bphnz4lv7gx9k297yqz0b954m7adp1sh6aqa";
    depends = [ ];
  };
  diggitdata = derive2 {
    name = "diggitdata";
    version = "1.34.0";
    sha256 = "01r356zdy4pi8z90pbww8q7dfmq09zf148d5sq3w22z1ypsy6zm1";
    depends = [
      Biobase
      viper
    ];
  };
  dorothea = derive2 {
    name = "dorothea";
    version = "1.14.1";
    sha256 = "0bjmnqly57y69axnz5q2rqz7j7dnz1xzbhbzcalv99kybjiyqyb5";
    depends = [
      bcellViper
      decoupleR
      dplyr
      magrittr
    ];
  };
  dressCheck = derive2 {
    name = "dressCheck";
    version = "0.40.0";
    sha256 = "1mb6cmyf61rb7jdwczhzcvadgqijij53w03d87xq7zqsc7jxi9z3";
    depends = [ Biobase ];
  };
  dyebiasexamples = derive2 {
    name = "dyebiasexamples";
    version = "1.42.0";
    sha256 = "06sp4fxsph3w84g960s65sy1vc032p2xj3sf0v94nh78f6myg0mj";
    depends = [
      GEOquery
      marray
    ];
  };
  easierData = derive2 {
    name = "easierData";
    version = "1.8.0";
    sha256 = "138x8i1zd4cvlawg9pa5ia1kmmdaxm0g9lkivzxl077s9vlpjp8d";
    depends = [
      AnnotationHub
      ExperimentHub
      SummarizedExperiment
    ];
  };
  ecoliLeucine = derive2 {
    name = "ecoliLeucine";
    version = "1.42.0";
    sha256 = "02v2hv8qcwdi2z531xqvnfdymzmd5qqp868arg5r0zcrzj5kkiaw";
    depends = [
      affy
      ecolicdf
    ];
  };
  emtdata = derive2 {
    name = "emtdata";
    version = "1.10.0";
    sha256 = "0fjqmg9w7c1lv0b0ldr26rxsly78sw2asj3hw8h8yd623g7bkddw";
    depends = [
      edgeR
      ExperimentHub
      SummarizedExperiment
    ];
  };
  epimutacionsData = derive2 {
    name = "epimutacionsData";
    version = "1.6.0";
    sha256 = "1gbh1ad0kqdmyrnmvrw5lbxlafvq12gqmbw9w3bxi7q1ahclh4yh";
    depends = [ ];
  };
  estrogen = derive2 {
    name = "estrogen";
    version = "1.48.0";
    sha256 = "0nbyg1pj7vqxaxgznkhz2v14cq42gg8jkn5mbkd3nrz86slzkblm";
    depends = [ ];
  };
  etec16s = derive2 {
    name = "etec16s";
    version = "1.30.0";
    sha256 = "1amhmhl74fyfvh4w1a0r0g7ahqm5yq16i87s4mzwvc03vslps143";
    depends = [
      Biobase
      metagenomeSeq
    ];
  };
  ewceData = derive2 {
    name = "ewceData";
    version = "1.10.0";
    sha256 = "1kgh5r0pplvblrrkf1qxg7c92psrwm2bjpbs30dp8mdsnjdahm9v";
    depends = [ ExperimentHub ];
  };
  faahKO = derive2 {
    name = "faahKO";
    version = "1.42.0";
    sha256 = "0m3m9382b463wbl5hrzh04lp8h052gka8b7q69s740hlb91npjx7";
    depends = [ xcms ];
  };
  fabiaData = derive2 {
    name = "fabiaData";
    version = "1.40.0";
    sha256 = "0alh11k7vj6ripj2017j6afa8wjb4xb03zfvrh10svsrr0a7qldv";
    depends = [ Biobase ];
  };
  ffpeExampleData = derive2 {
    name = "ffpeExampleData";
    version = "1.40.0";
    sha256 = "16bxp2x0n77hzlf6m871wgprrhkydcbbnw88jp8nb7d0fl1vhxyr";
    depends = [ lumi ];
  };
  fibroEset = derive2 {
    name = "fibroEset";
    version = "1.44.0";
    sha256 = "17dzp6gjfgsnvwplk3inf7s491brf1pnn1bq1a195s8m0r5kd946";
    depends = [ Biobase ];
  };
  fission = derive2 {
    name = "fission";
    version = "1.22.0";
    sha256 = "0y07zj5iw6fmr397xkxijgfy8mmv1k42mqjfpmv01kb0hzayjj8n";
    depends = [ SummarizedExperiment ];
  };
  flowPloidyData = derive2 {
    name = "flowPloidyData";
    version = "1.28.0";
    sha256 = "1r3w88d20jipmj7gchv0mmw9rbziq0s7vyvi5isc4lp59hc6m9h1";
    depends = [ ];
  };
  flowWorkspaceData = derive2 {
    name = "flowWorkspaceData";
    version = "3.14.0";
    sha256 = "0wm0s1839c14b2y05b8nini2aqp39vl7ycsp1nz1y2amxirdfpyq";
    depends = [ ];
  };
  fourDNData = derive2 {
    name = "fourDNData";
    version = "1.2.0";
    sha256 = "06dzm57f56y396py2mmfzls9yypkxzj032hpba8srq263zqpi9z0";
    depends = [
      BiocFileCache
      GenomicRanges
      HiCExperiment
      IRanges
      S4Vectors
    ];
  };
  frmaExampleData = derive2 {
    name = "frmaExampleData";
    version = "1.38.0";
    sha256 = "0sdh0ijkpni4xk07dyvkckr6k0dha6zbciggxaki61j99fs5nwsv";
    depends = [ ];
  };
  furrowSeg = derive2 {
    name = "furrowSeg";
    version = "1.30.0";
    sha256 = "0vvr9x50yw7h5qcgcva2505cgqk276ci7yfbzvizn3mq4n2r3n3j";
    depends = [
      abind
      dplyr
      EBImage
      locfit
      tiff
    ];
  };
  gDNAinRNAseqData = derive2 {
    name = "gDNAinRNAseqData";
    version = "1.2.0";
    sha256 = "13v14dhwb1mkpxc5z08amqajhkncrkl38k4js48bp36s8lzb0zw8";
    depends = [
      BiocGenerics
      ExperimentHub
      RCurl
      Rsamtools
      XML
    ];
  };
  gDRtestData = derive2 {
    name = "gDRtestData";
    version = "1.0.0";
    sha256 = "0pwrypvc1hvrcd6dckiid5vjpwpcbw3vg61s88mms3kjs8163c0r";
    depends = [ checkmate ];
  };
  gageData = derive2 {
    name = "gageData";
    version = "2.40.0";
    sha256 = "13g8hzkh34c0my75xnxdffa1d67xvn9hn592s25m18400lgsfif0";
    depends = [ ];
  };
  gaschYHS = derive2 {
    name = "gaschYHS";
    version = "1.40.0";
    sha256 = "08dgm24ycsldp6pjqhflpxqm91yqp199n2j1fg9m4wrgbyakypkm";
    depends = [ Biobase ];
  };
  gcspikelite = derive2 {
    name = "gcspikelite";
    version = "1.40.0";
    sha256 = "1yfmp96k1iy6sjyafs2sflflnmnq4czkjba61vzxb4alirra9jf5";
    depends = [ ];
  };
  geneLenDataBase = derive2 {
    name = "geneLenDataBase";
    version = "1.38.0";
    sha256 = "0skycixz0qbm8cs10kgrkl1ab1qh0mz8641mf5194y839m81d060";
    depends = [
      GenomicFeatures
      rtracklayer
    ];
  };
  genomationData = derive2 {
    name = "genomationData";
    version = "1.34.0";
    sha256 = "044q01dbcd34lxgwpg76yk0msvx7gpiibiqxp6fr9jswq6izrzq7";
    depends = [ ];
  };
  golubEsets = derive2 {
    name = "golubEsets";
    version = "1.44.0";
    sha256 = "1rwhb48wz20i06whxdj1cb6qjda545w4050y87c55h3xqcair3ya";
    depends = [ Biobase ];
  };
  gpaExample = derive2 {
    name = "gpaExample";
    version = "1.14.0";
    sha256 = "0danfxw9jqlv9862pcf7sdaxnwxrpgs9gy38xpjzx3q25y4y1589";
    depends = [ ];
  };
  grndata = derive2 {
    name = "grndata";
    version = "1.34.0";
    sha256 = "17g2jp99dl6kypzz4v2pf0h29vx16pwfw6apbhgggv1had9593nm";
    depends = [ ];
  };
  h5vcData = derive2 {
    name = "h5vcData";
    version = "2.22.0";
    sha256 = "0pflrqg6yaiw7w9b8wazf74sdgx1fqgd0iz9cdq0bx4jnra5f0gz";
    depends = [ ];
  };
  hapmap100khind = derive2 {
    name = "hapmap100khind";
    version = "1.44.0";
    sha256 = "1qzvf4g8rd85g3qxx5gckx4w1v258h9jd9dfcxbn39ghamqhy9yb";
    depends = [ ];
  };
  hapmap100kxba = derive2 {
    name = "hapmap100kxba";
    version = "1.44.0";
    sha256 = "0743byawrk3azgrb1wdb16khd2pl887fxf4r7mf6zm08lgjyr3vv";
    depends = [ ];
  };
  hapmap500knsp = derive2 {
    name = "hapmap500knsp";
    version = "1.44.0";
    sha256 = "1kla7h8hv6kyc9v6ra5scg3f1dlmw160wl5c1vqq9b6irqmrah6l";
    depends = [ ];
  };
  hapmap500ksty = derive2 {
    name = "hapmap500ksty";
    version = "1.44.0";
    sha256 = "0g13vk2gnnmpm21fngr7cfhry3sacxmbxsym5wz4sibfv3d72n7r";
    depends = [ ];
  };
  hapmapsnp5 = derive2 {
    name = "hapmapsnp5";
    version = "1.44.0";
    sha256 = "1486k3dlnvadxl8qphzria3qrw91x8j0b3k4di8c8s0fjkrfdh33";
    depends = [ ];
  };
  hapmapsnp6 = derive2 {
    name = "hapmapsnp6";
    version = "1.44.0";
    sha256 = "1dx59dsm4pmca9xf5c2abk5clmczx2wh6j47xx8h064x3n5s611n";
    depends = [ ];
  };
  harbChIP = derive2 {
    name = "harbChIP";
    version = "1.40.0";
    sha256 = "0xb553h6ffnik8c299h5imaabb2ca0fkqk0hrbs1a1acg11xqs32";
    depends = [
      Biobase
      Biostrings
      IRanges
    ];
  };
  healthyControlsPresenceChecker = derive2 {
    name = "healthyControlsPresenceChecker";
    version = "1.6.0";
    sha256 = "127p0wwqf0dx9c8y3rjmsw6nl9rczr72zn8dsqf92mdj13qpxi2m";
    depends = [
      geneExpressionFromGEO
      GEOquery
      magrittr
      xml2
    ];
  };
  healthyFlowData = derive2 {
    name = "healthyFlowData";
    version = "1.40.0";
    sha256 = "1w96g3m8kniz4nil682hz55pxhxgaqfgmfii990mrd0smirnckwx";
    depends = [ flowCore ];
  };
  hgu133abarcodevecs = derive2 {
    name = "hgu133abarcodevecs";
    version = "1.40.0";
    sha256 = "1v8ssmzad3a1wwwh2rw9pkrcwjbbv9m2i5iqjsn0qmi7s9xpdn2z";
    depends = [ ];
  };
  hgu133plus2CellScore = derive2 {
    name = "hgu133plus2CellScore";
    version = "1.22.0";
    sha256 = "08d6p5zmf674hj6qy6sz8n9fg70xr83y21d7ln22i9gzvvgbazpi";
    depends = [ Biobase ];
  };
  hgu133plus2barcodevecs = derive2 {
    name = "hgu133plus2barcodevecs";
    version = "1.40.0";
    sha256 = "1c3432d28n4bj363s7h493izz865i2gfrs8x2fr6n2js9p4bz8bf";
    depends = [ ];
  };
  hgu2beta7 = derive2 {
    name = "hgu2beta7";
    version = "1.42.0";
    sha256 = "1xxwj4d760y6ymw2ag5xqd212yb7wns2yaxgla62v3pcalvdccfp";
    depends = [ ];
  };
  humanStemCell = derive2 {
    name = "humanStemCell";
    version = "0.42.0";
    sha256 = "0bywcagkg17gdcwbbw68fla1481llz96bhr3apbymvk8m4vbhlp0";
    depends = [
      Biobase
      hgu133plus2_db
    ];
  };
  imcdatasets = derive2 {
    name = "imcdatasets";
    version = "1.10.0";
    sha256 = "0yvii8qxgxabf9i2z5pz37dn9s6vw3g6z2k6c5k4rjns8wmvixps";
    depends = [
      cytomapper
      DelayedArray
      ExperimentHub
      HDF5Array
      S4Vectors
      SingleCellExperiment
      SpatialExperiment
    ];
  };
  kidpack = derive2 {
    name = "kidpack";
    version = "1.44.0";
    sha256 = "15c7ahrpjapqp90nanpkjb9hbcv42a84xg939fgpzkpgc7ch0m9k";
    depends = [ Biobase ];
  };
  leeBamViews = derive2 {
    name = "leeBamViews";
    version = "1.38.0";
    sha256 = "0j7q5slcb59z6vf2z123h9ld0gaazsiih7an603id1bqjprkd74b";
    depends = [
      Biobase
      BSgenome
      GenomicAlignments
      GenomicRanges
      IRanges
      Rsamtools
      S4Vectors
    ];
  };
  leukemiasEset = derive2 {
    name = "leukemiasEset";
    version = "1.38.0";
    sha256 = "1srwn3sy929hskka9gfnqpjrh8xy0pz76ihq4amq8wbdawh1zv8b";
    depends = [ Biobase ];
  };
  lumiBarnes = derive2 {
    name = "lumiBarnes";
    version = "1.42.0";
    sha256 = "1c27s7ajkmygfmd2g6dpsamwcm87xlxgr31wyn6g1rb7zw2zdpy2";
    depends = [
      Biobase
      lumi
    ];
  };
  lungExpression = derive2 {
    name = "lungExpression";
    version = "0.40.0";
    sha256 = "1kzf8lsl9sh0ikn9zx5sfj5z7ld94xldhmj7awvgp0bsbqlra2qc";
    depends = [ Biobase ];
  };
  lydata = derive2 {
    name = "lydata";
    version = "1.28.0";
    sha256 = "0gwaiq16q1kfx533hymqnh6zk9nimljdbidvzb23bykj99kmsiqr";
    depends = [ ];
  };
  mAPKLData = derive2 {
    name = "mAPKLData";
    version = "1.34.0";
    sha256 = "0vhysi7wyw7d3vbq4qcq3i3ic953awppg2bix40ywz1459b5p43g";
    depends = [ ];
  };
  mCSEAdata = derive2 {
    name = "mCSEAdata";
    version = "1.22.0";
    sha256 = "0la86384k9f0r8mgh6an023bx1sjklglgm9rwzg33hcc58lb02ki";
    depends = [ GenomicRanges ];
  };
  macrophage = derive2 {
    name = "macrophage";
    version = "1.18.0";
    sha256 = "10d69v34fhxfy4nhw8h50j4q5kblm032cmjnparxm5gm7ksiqwxy";
    depends = [ ];
  };
  mammaPrintData = derive2 {
    name = "mammaPrintData";
    version = "1.38.0";
    sha256 = "0bm1lfdjhav34rqvkvygkllmwibjh0f34p58vml3ljjdhgghawrq";
    depends = [ ];
  };
  maqcExpression4plex = derive2 {
    name = "maqcExpression4plex";
    version = "1.46.0";
    sha256 = "0ihwmzndj3yxs75x3h9w03ydvy08hmi0pzy561mjsyhdrrb8i4dc";
    depends = [ ];
  };
  marinerData = derive2 {
    name = "marinerData";
    version = "1.2.0";
    sha256 = "00m1r6ijhykq96d86h17asngdm8a1ss2213nd6n6lsj4dshr74a0";
    depends = [ ExperimentHub ];
  };
  mcsurvdata = derive2 {
    name = "mcsurvdata";
    version = "1.20.0";
    sha256 = "06k500vivc8anxv1x639acjv55w5r6pc2ghmszkh42h1q7a27r68";
    depends = [
      AnnotationHub
      Biobase
      ExperimentHub
    ];
  };
  metaMSdata = derive2 {
    name = "metaMSdata";
    version = "1.38.0";
    sha256 = "18gixjk80zzvjg39av6rhbl9zpvnx09fd6gcbnsjxag7vmk88d1d";
    depends = [ ];
  };
  methylclockData = derive2 {
    name = "methylclockData";
    version = "1.10.0";
    sha256 = "0q4hiclws0fg03kwvbdwka024gghl1hbmmfficxfghslll78mc3y";
    depends = [
      ExperimentHub
      ExperimentHubData
    ];
  };
  miRNATarget = derive2 {
    name = "miRNATarget";
    version = "1.40.0";
    sha256 = "0qlazpmar9wi0gbh2qpkz8f44vzzg79iia1sgry42xbykx7bzx0y";
    depends = [ Biobase ];
  };
  miRcompData = derive2 {
    name = "miRcompData";
    version = "1.32.0";
    sha256 = "15w8vldxp5wp0vqfy3k7s8imjvmdaibgiw0p2li5sx2j0g6i27g6";
    depends = [ ];
  };
  microRNAome = derive2 {
    name = "microRNAome";
    version = "1.24.0";
    sha256 = "09b0260qxdhx7sax1xmg8nz8mf0nv4yh70ibd8cyxj8fpnzifnhh";
    depends = [ SummarizedExperiment ];
  };
  microbiomeDataSets = derive2 {
    name = "microbiomeDataSets";
    version = "1.10.0";
    sha256 = "1i118r0wfq2y57h3m1l3nzhrixmkq0dsc1dfkbfi83xl29ijhjn9";
    depends = [
      ape
      BiocGenerics
      Biostrings
      ExperimentHub
      MultiAssayExperiment
      SummarizedExperiment
      TreeSummarizedExperiment
    ];
  };
  minfiData = derive2 {
    name = "minfiData";
    version = "0.48.0";
    sha256 = "12lhyv3zb8vps7v61zfm8sz4r18rpgphgy7nvdpj48dj3awdnpw8";
    depends = [
      IlluminaHumanMethylation450kanno_ilmn12_hg19
      IlluminaHumanMethylation450kmanifest
      minfi
    ];
  };
  minfiDataEPIC = derive2 {
    name = "minfiDataEPIC";
    version = "1.28.0";
    sha256 = "1m2wl7x48rjjl3sh8r42wmw761r55821jjvbxjs7lycbmgd162ph";
    depends = [
      IlluminaHumanMethylationEPICanno_ilm10b2_hg19
      IlluminaHumanMethylationEPICmanifest
      minfi
    ];
  };
  minionSummaryData = derive2 {
    name = "minionSummaryData";
    version = "1.32.0";
    sha256 = "1pkg77i5xi96yqn7i3xchwknh5lii35hyms8rjqqzamjr7g16ifs";
    depends = [ ];
  };
  mosaicsExample = derive2 {
    name = "mosaicsExample";
    version = "1.40.0";
    sha256 = "02x97k7s5l3ca1xws4xplmc3x14wjy0rx1kl5jmy59ncc2lwik4r";
    depends = [ ];
  };
  mouse4302barcodevecs = derive2 {
    name = "mouse4302barcodevecs";
    version = "1.40.0";
    sha256 = "1l2blxqsxy27lkrgd08r6a3j8va54hzhl5lx0i9bxpj1i9xiwkr6";
    depends = [ ];
  };
  msPurityData = derive2 {
    name = "msPurityData";
    version = "1.30.0";
    sha256 = "1gf28bcj65vyvghdd2vqj3zsymw2y4jk8dhhkhh6ps18qh149ca0";
    depends = [ ];
  };
  msd16s = derive2 {
    name = "msd16s";
    version = "1.22.0";
    sha256 = "0s7bbcxgly2xr21dkf88hpby5b4lhwy18jyji88dhqqq4jpbc8dk";
    depends = [
      Biobase
      metagenomeSeq
    ];
  };
  msdata = derive2 {
    name = "msdata";
    version = "0.42.0";
    sha256 = "1jm1zjqzkd0vy8ww0k0y1fgs6i9vkg7ir6dyga001n170g11vfzr";
    depends = [ ];
  };
  msigdb = derive2 {
    name = "msigdb";
    version = "1.10.0";
    sha256 = "1fzgq31n059zhlkny3rfwfnriz81q9brk14r5yx2zhizlv8jcais";
    depends = [
      AnnotationDbi
      AnnotationHub
      ExperimentHub
      GSEABase
      org_Hs_eg_db
      org_Mm_eg_db
    ];
  };
  msqc1 = derive2 {
    name = "msqc1";
    version = "1.30.0";
    sha256 = "1s6wfmrss67qz8lsiqbm3bsvw3zm9pczv0w6712dd2bd2mf2lirg";
    depends = [ lattice ];
  };
  mtbls2 = derive2 {
    name = "mtbls2";
    version = "1.32.0";
    sha256 = "1z4n5bykfk02b6gscwygy4r99fjk9cmiv8fzp2996q4mhzr7dh6c";
    depends = [ ];
  };
  muscData = derive2 {
    name = "muscData";
    version = "1.16.0";
    sha256 = "01jmd59zk4fkny984wv9iwd9bq56cq4mnqz1x9wcjkmgk5bnvwxa";
    depends = [
      ExperimentHub
      SingleCellExperiment
    ];
  };
  mvoutData = derive2 {
    name = "mvoutData";
    version = "1.38.0";
    sha256 = "17rbb19wv8dzgkrkhgabm3fgr3l2gzvjl34ichlcfalaa17wci3w";
    depends = [
      affy
      Biobase
      lumi
    ];
  };
  nanotubes = derive2 {
    name = "nanotubes";
    version = "1.18.0";
    sha256 = "0ah7y051mk6pl96y6h9qlxk4gg2a7al8j9ccwk0fjl7v5fa1daya";
    depends = [ ];
  };
  nullrangesData = derive2 {
    name = "nullrangesData";
    version = "1.8.0";
    sha256 = "0dd9d07z2k3n34wi5mynyghc0bsmyn5fhl0510ij7zbd58i520xy";
    depends = [
      ExperimentHub
      GenomicRanges
      InteractionSet
    ];
  };
  oct4 = derive2 {
    name = "oct4";
    version = "1.18.0";
    sha256 = "1kbv532sav3a0s1893hxjw7pf25lhff5kxnraq6h7h7vqqmim93j";
    depends = [ ];
  };
  octad_db = derive2 {
    name = "octad.db";
    version = "1.4.0";
    sha256 = "03dih6cc71aj31l9s982qpdsyy51q83inykyz4a8pk81x3pld2n9";
    depends = [ ExperimentHub ];
  };
  optimalFlowData = derive2 {
    name = "optimalFlowData";
    version = "1.14.0";
    sha256 = "0agaavlhsv1zk3xdwncn4nkz7q80bjnsg32msnnj8x79925hfgwq";
    depends = [ ];
  };
  orthosData = derive2 {
    name = "orthosData";
    version = "1.0.0";
    sha256 = "0n9vkvfxah29cjfwnxjqw0kf5kdgjvx9394kgilnbskys95fh6v3";
    depends = [
      AnnotationHub
      BiocFileCache
      ExperimentHub
      HDF5Array
      stringr
      SummarizedExperiment
    ];
  };
  pRolocdata = derive2 {
    name = "pRolocdata";
    version = "1.40.0";
    sha256 = "0zjys778k9xydd6r1nvklz324mq688472b8i8d1nm8ayb880bi7i";
    depends = [
      Biobase
      MSnbase
    ];
  };
  parathyroidSE = derive2 {
    name = "parathyroidSE";
    version = "1.40.0";
    sha256 = "0lv7wlbdi05a3l4pv8x4cnc6jzqk1gb82rpmj1cv0nsq7gqhqscv";
    depends = [ SummarizedExperiment ];
  };
  pasilla = derive2 {
    name = "pasilla";
    version = "1.30.0";
    sha256 = "0dga4bb7qjigy1m1yp4bs4frwynjqfy3dnnylx4maai9x2zlynd0";
    depends = [ DEXSeq ];
  };
  pasillaBamSubset = derive2 {
    name = "pasillaBamSubset";
    version = "0.40.0";
    sha256 = "1lr7dn9s7i287k602xa1zyx5xs6wa3g58kmpamc3hcsi5nn1iv7x";
    depends = [ ];
  };
  pcxnData = derive2 {
    name = "pcxnData";
    version = "2.24.0";
    sha256 = "0mhqgii84ncx2na49h3qvciqz7jfbbgil12i2cb4snlmxpa66k0j";
    depends = [ ];
  };
  pd_atdschip_tiling = derive2 {
    name = "pd.atdschip.tiling";
    version = "0.40.0";
    sha256 = "03yvz9z4dmnm4cvfwkw3b7srmq7hmwk9y21lpsn5yz01wjp9wf6w";
    depends = [
      Biostrings
      DBI
      IRanges
      oligo
      oligoClasses
      RSQLite
      S4Vectors
    ];
  };
  pepDat = derive2 {
    name = "pepDat";
    version = "1.22.0";
    sha256 = "0ks5lxfwwgxfv0ls42fr5hj0iq2m6ylv13ybp8gq5r24p6hyigq3";
    depends = [ GenomicRanges ];
  };
  plotgardenerData = derive2 {
    name = "plotgardenerData";
    version = "1.8.0";
    sha256 = "1c8004k5kqx1lryc7x57xvlqic7km11r2b723r5ar1x5mghl9lr3";
    depends = [ ];
  };
  prebsdata = derive2 {
    name = "prebsdata";
    version = "1.38.0";
    sha256 = "1jszgh5sq0fls0484zfy41cpxwfg04pky54ma2r8v0x2aksb9fnv";
    depends = [ ];
  };
  preciseTADhub = derive2 {
    name = "preciseTADhub";
    version = "1.10.0";
    sha256 = "006kdb7rv63jyn4xnvrk13s5by1m85jgnfs2594h51af4sgyd2id";
    depends = [ ExperimentHub ];
  };
  prostateCancerCamcap = derive2 {
    name = "prostateCancerCamcap";
    version = "1.30.0";
    sha256 = "1962yhm8j1mb3yvdkvdn8i35dmwj69larlp201vwqr8a25l67isq";
    depends = [ Biobase ];
  };
  prostateCancerGrasso = derive2 {
    name = "prostateCancerGrasso";
    version = "1.30.0";
    sha256 = "0mvlnfps3xa6039ysbp5hc8cy30masw9p1rhhms9f79m1xh3ldqr";
    depends = [ Biobase ];
  };
  prostateCancerStockholm = derive2 {
    name = "prostateCancerStockholm";
    version = "1.30.0";
    sha256 = "19dkx1brrwjcrjyfhajiazfpy853kmqr10npzkarnb1fw3dhn9a9";
    depends = [ Biobase ];
  };
  prostateCancerTaylor = derive2 {
    name = "prostateCancerTaylor";
    version = "1.30.0";
    sha256 = "0mccc3fwrnayjlpjyncizsrnnapgb7mhywvcdwlspp2ma0xzq2kw";
    depends = [ Biobase ];
  };
  prostateCancerVarambally = derive2 {
    name = "prostateCancerVarambally";
    version = "1.30.0";
    sha256 = "10irpxg5gfj10s310irjh1lacg05s6073vfqlv5jmpwgjjz8g84m";
    depends = [ Biobase ];
  };
  ptairData = derive2 {
    name = "ptairData";
    version = "1.10.0";
    sha256 = "11fxa0j4jl19ig21v00acbkapwi0y5d9n36q82pb8kz2krdaa9xc";
    depends = [
      rhdf5
      signal
    ];
  };
  pumadata = derive2 {
    name = "pumadata";
    version = "2.38.0";
    sha256 = "0rc2qda3s3326g1ymychhxa3c1vb16vj7sllfqymridqwm907k0x";
    depends = [
      Biobase
      oligo
      puma
    ];
  };
  qPLEXdata = derive2 {
    name = "qPLEXdata";
    version = "1.20.0";
    sha256 = "0l6agwhqsm5z98j0hm1h7df6lrq7rgwch99a33532f5zmn6bq7xa";
    depends = [
      dplyr
      knitr
      MSnbase
      qPLEXanalyzer
    ];
  };
  rRDPData = derive2 {
    name = "rRDPData";
    version = "1.22.0";
    sha256 = "18k925rd7yslvc6gl9gn9fk7672w57327rsybi5vpphvpyqsqls1";
    depends = [ rRDP ];
  };
  raerdata = derive2 {
    name = "raerdata";
    version = "1.0.0";
    sha256 = "0f8k9a714fc0wkrg2ja1193302q712aw6q4nv79qnvavqx12p0hi";
    depends = [
      BiocGenerics
      ExperimentHub
      Rsamtools
      rtracklayer
      SingleCellExperiment
    ];
  };
  rcellminerData = derive2 {
    name = "rcellminerData";
    version = "2.24.0";
    sha256 = "0fmidhiqaf2vrhz6b5qr7bhisqnr3vff1aczp02qfhj5zyrf2vp6";
    depends = [ Biobase ];
  };
  restfulSEData = derive2 {
    name = "restfulSEData";
    version = "1.24.0";
    sha256 = "1ydi54mbvvsn73j955qjiqgpc2qvgdxfa9gsflx5cc14c0aqyb9h";
    depends = [
      DelayedArray
      ExperimentHub
      HDF5Array
      SummarizedExperiment
    ];
  };
  rheumaticConditionWOLLBOLD = derive2 {
    name = "rheumaticConditionWOLLBOLD";
    version = "1.40.0";
    sha256 = "0qaxxhn31kwny0327ki5yllp4cnljdqbqmrb0arx1qggbysb31gf";
    depends = [ ];
  };
  sampleClassifierData = derive2 {
    name = "sampleClassifierData";
    version = "1.26.0";
    sha256 = "0ir21cvcqq9xh43pidh4lrm1slzknsjm9lad3qhh7dn2x5dg8p7p";
    depends = [ SummarizedExperiment ];
  };
  scATAC_Explorer = derive2 {
    name = "scATAC.Explorer";
    version = "1.8.0";
    sha256 = "1qjacprh3q0g1fyq70akasfr66hxw2g8n1bwn4yhf798vly5ngf8";
    depends = [
      BiocFileCache
      data_table
      Matrix
      S4Vectors
      SingleCellExperiment
    ];
  };
  scMultiome = derive2 {
    name = "scMultiome";
    version = "1.2.0";
    sha256 = "0j9cwlnj0078yyzfjiwsadx34g1ddcrfm5xmzjv59dmk55iy59d7";
    depends = [
      AnnotationHub
      AzureStor
      checkmate
      DelayedArray
      ExperimentHub
      GenomicRanges
      HDF5Array
      MultiAssayExperiment
      rhdf5
      S4Vectors
      SingleCellExperiment
      SummarizedExperiment
    ];
  };
  scRNAseq = derive2 {
    name = "scRNAseq";
    version = "2.16.0";
    sha256 = "0dbh3sqq7lkkdf7vls5qg7fbn6y74c7hsigb4d69pvk934ll88aw";
    depends = [
      AnnotationDbi
      AnnotationHub
      BiocGenerics
      ensembldb
      ExperimentHub
      GenomicFeatures
      GenomicRanges
      S4Vectors
      SingleCellExperiment
      SummarizedExperiment
    ];
  };
  scTHI_data = derive2 {
    name = "scTHI.data";
    version = "1.14.0";
    sha256 = "1y28wldw2xln9bp4hgymjdlgz9fjiyhb56kac6z7aiy1pifavw48";
    depends = [ ];
  };
  scanMiRData = derive2 {
    name = "scanMiRData";
    version = "1.8.0";
    sha256 = "116v4l8rqg2lsadjhhhn40fdgfar6hbx5abri5kdq7bc5fagg957";
    depends = [ scanMiR ];
  };
  scpdata = derive2 {
    name = "scpdata";
    version = "1.10.0";
    sha256 = "0zwwbqss2a6vkzhz517j89gf02z4f5b9kx5wbnyi2g15ihwlvaxr";
    depends = [
      AnnotationHub
      ExperimentHub
      QFeatures
      S4Vectors
      SingleCellExperiment
    ];
  };
  seq2pathway_data = derive2 {
    name = "seq2pathway.data";
    version = "1.34.0";
    sha256 = "0iaz4i5garvhai2bpwxm59h4qasbasv66a2b8mql2rqa4s6wnf0a";
    depends = [ ];
  };
  seqCNA_annot = derive2 {
    name = "seqCNA.annot";
    version = "1.38.0";
    sha256 = "0kzmn5hx8ag02pz8b78cq7dbalw2w60y441cjyyvxjgycwcfvmvj";
    depends = [ ];
  };
  seqc = derive2 {
    name = "seqc";
    version = "1.36.0";
    sha256 = "0zxmh69v45ys1hv9kkr7g6v67npcip6s11r3am502zq1dnk7khg1";
    depends = [ Biobase ];
  };
  serumStimulation = derive2 {
    name = "serumStimulation";
    version = "1.38.0";
    sha256 = "0c6zg119rdmqhgrzi3s10856l9vyrqmd8c858hw20aiagvxn5nik";
    depends = [ ];
  };
  sesameData = derive2 {
    name = "sesameData";
    version = "1.20.0";
    sha256 = "0a5xchdnlw9ixafk8p3ny58yqv74ba9j4z2sdyp990rbaqrx1gjw";
    depends = [
      AnnotationHub
      ExperimentHub
      GenomeInfoDb
      GenomicRanges
      IRanges
      readr
      S4Vectors
      stringr
    ];
  };
  seventyGeneData = derive2 {
    name = "seventyGeneData";
    version = "1.38.2";
    sha256 = "1zpks4fpwjb640pggwd1xldri2lf3fl8pcbvi244c6dgkf8nq93i";
    depends = [ ];
  };
  shinyMethylData = derive2 {
    name = "shinyMethylData";
    version = "1.22.0";
    sha256 = "1i6ffgi79jgpkg6nhil7v7vi23yv2j7czzibj6dxdc0kpb1n0q1h";
    depends = [ ];
  };
  signatureSearchData = derive2 {
    name = "signatureSearchData";
    version = "1.16.0";
    sha256 = "1xn0y7mcpk4s4x9azzabxfq0hxwlx7dvpb4yjrl3x8zcyk394s3z";
    depends = [
      affy
      Biobase
      dplyr
      ExperimentHub
      limma
      magrittr
      R_utils
      rhdf5
    ];
  };
  simpIntLists = derive2 {
    name = "simpIntLists";
    version = "1.38.0";
    sha256 = "1683dsi6bm45v5wk9fgvrmvap15w6gvwnfijg5ayj29shiaa2qif";
    depends = [ ];
  };
  smokingMouse = derive2 {
    name = "smokingMouse";
    version = "1.0.0";
    sha256 = "0xm4a7yp6802xcmh29hwvlz39gqb5s380mzi5rck89fl6wjl4bf6";
    depends = [ ];
  };
  spatialDmelxsim = derive2 {
    name = "spatialDmelxsim";
    version = "1.8.0";
    sha256 = "110anvdbsq8mh3ibfhps9hyfhlk2np4mjs224377s1sasmpzwbbb";
    depends = [
      ExperimentHub
      SummarizedExperiment
    ];
  };
  spatialLIBD = derive2 {
    name = "spatialLIBD";
    version = "1.14.1";
    sha256 = "0zqbnj55d06xai9qlg1hcy2kczjn6zxrhqwwsi18a36511qks5qb";
    depends = [
      AnnotationHub
      benchmarkme
      BiocFileCache
      BiocGenerics
      cowplot
      DT
      edgeR
      ExperimentHub
      fields
      GenomicRanges
      ggplot2
      golem
      IRanges
      jsonlite
      limma
      magick
      Matrix
      paletteer
      plotly
      png
      RColorBrewer
      rtracklayer
      S4Vectors
      scater
      scuttle
      sessioninfo
      shiny
      shinyWidgets
      SingleCellExperiment
      SpatialExperiment
      statmod
      SummarizedExperiment
      tibble
      viridisLite
    ];
  };
  spqnData = derive2 {
    name = "spqnData";
    version = "1.14.0";
    sha256 = "0kvnkz71w1c7yhl4kqdj9j51d1ix2g7q3pqr2678f31hhw7yr1ck";
    depends = [ SummarizedExperiment ];
  };
  stemHypoxia = derive2 {
    name = "stemHypoxia";
    version = "1.38.0";
    sha256 = "1ak78mvgm9dv80ji44b1cb4y8bq0l4k0cpx734m8dy8mr3i8nblw";
    depends = [ ];
  };
  stjudem = derive2 {
    name = "stjudem";
    version = "1.42.0";
    sha256 = "0pcvvvaqalr5jklqy7vzxkp0cd9nj9dk941drgr7ndbqc2navz2c";
    depends = [ ];
  };
  synapterdata = derive2 {
    name = "synapterdata";
    version = "1.40.0";
    sha256 = "1hl3r6smv25vhwxwrxw2c98db4c36392js49zj9kgf7c22qpyaqr";
    depends = [ synapter ];
  };
  systemPipeRdata = derive2 {
    name = "systemPipeRdata";
    version = "2.6.0";
    sha256 = "004sjgvhn9hq14f4mwfakrkkm2mwr2bdcbld25b393in0k26r9hf";
    depends = [
      BiocGenerics
      Biostrings
      jsonlite
      remotes
    ];
  };
  tartare = derive2 {
    name = "tartare";
    version = "1.16.0";
    sha256 = "1w8z756s2c4vcxan8lid5mflyn8n718vhqn72x3mspg1pbb6k0l6";
    depends = [
      AnnotationHub
      ExperimentHub
    ];
  };
  timecoursedata = derive2 {
    name = "timecoursedata";
    version = "1.12.0";
    sha256 = "10i4wcdjqd2qh6rpl65xi5mj2hsam78hi3haqp4xhg0ha4f73nb3";
    depends = [ SummarizedExperiment ];
  };
  tinesath1cdf = derive2 {
    name = "tinesath1cdf";
    version = "1.40.0";
    sha256 = "12db5w6fsmpjx2xgq7f3hp5czm21jp17826mi7jdz1c0217i1h4s";
    depends = [ ];
  };
  tinesath1probe = derive2 {
    name = "tinesath1probe";
    version = "1.40.0";
    sha256 = "1s119zkz03rq0bs3fjx85rwr7f2fxk144ykvglbzz3m6wxwi94r9";
    depends = [ AnnotationDbi ];
  };
  tissueTreg = derive2 {
    name = "tissueTreg";
    version = "1.22.0";
    sha256 = "17hjzwvk9pa1zhvmqrs99dnm428bm2br4xjmydp7d8j2mdsbkfs3";
    depends = [ ];
  };
  tofsimsData = derive2 {
    name = "tofsimsData";
    version = "1.30.0";
    sha256 = "18fn2krbc1mg3phx1sjpshsq9n39jlm75n9s7615h4jdcky9gzld";
    depends = [ ];
  };
  topdownrdata = derive2 {
    name = "topdownrdata";
    version = "1.24.0";
    sha256 = "01wxdwq87yan5a71z60bzs18w1ryjvgscnrrpdksqs56009k5992";
    depends = [ topdownr ];
  };
  tuberculosis = derive2 {
    name = "tuberculosis";
    version = "1.8.0";
    sha256 = "15jmhn7lrdwz19hv076yf0g2wqw7c32vp4pjzj2151f4xzxrl1iz";
    depends = [
      AnnotationHub
      dplyr
      ExperimentHub
      magrittr
      purrr
      rlang
      S4Vectors
      stringr
      SummarizedExperiment
      tibble
      tidyr
    ];
  };
  tweeDEseqCountData = derive2 {
    name = "tweeDEseqCountData";
    version = "1.40.0";
    sha256 = "1s071578qldq564ylrkd9azn5519rdc3g1gdp9v8hj4zh8kza56v";
    depends = [ Biobase ];
  };
  tximportData = derive2 {
    name = "tximportData";
    version = "1.30.0";
    sha256 = "0ksmg3gblkqzz40pzm35y6wghjmszrimdx7bxhq5jv4piqwii0hg";
    depends = [ ];
  };
  vulcandata = derive2 {
    name = "vulcandata";
    version = "1.24.0";
    sha256 = "18wbxwwp7bsmdbn4g6d96x45b672fyrhlh38kbcz3j5dysdg1clr";
    depends = [ ];
  };
  xcoredata = derive2 {
    name = "xcoredata";
    version = "1.6.0";
    sha256 = "1chcjylfdl07q19f924hsml22lbfcjrzndp1appi3q80hzbc3pz6";
    depends = [ ExperimentHub ];
  };
  yeastCC = derive2 {
    name = "yeastCC";
    version = "1.42.0";
    sha256 = "1abl3jlwznzdmfpsqy0bfvrn6xx99yc8wz70s228lalvac4lqrfn";
    depends = [ Biobase ];
  };
  yeastExpData = derive2 {
    name = "yeastExpData";
    version = "0.48.0";
    sha256 = "13hxrcsvxwjdr649xzl07fkl0mzx6j36hkmgmj9zj270gsvlchns";
    depends = [ graph ];
  };
  yeastGSData = derive2 {
    name = "yeastGSData";
    version = "0.40.0";
    sha256 = "0i3fawlbxb6xc9wilxlc5gjr22ikp1x4rc2dich1cmpbjqd2zg1c";
    depends = [ ];
  };
  yeastNagalakshmi = derive2 {
    name = "yeastNagalakshmi";
    version = "1.38.0";
    sha256 = "1d1y7xpggizgiv2qma31mlzri2jidir425q08fdnnm9ymcxx83z0";
    depends = [ ];
  };
  yeastRNASeq = derive2 {
    name = "yeastRNASeq";
    version = "0.40.0";
    sha256 = "1b7bdbyzh6lx4qp4md9b7qxd433l8wpswfq0azxjdn33yryv8spm";
    depends = [ ];
  };
  zebrafishRNASeq = derive2 {
    name = "zebrafishRNASeq";
    version = "1.22.0";
    sha256 = "0fhsg1j40rkzxphnq7gl98zyqijacmfrjf4ffmbvr70mxw3zysgz";
    depends = [ ];
  };
  ABAData = derive2 {
    name = "ABAData";
    version = "1.24.0";
    sha256 = "1wgniq7ibvjj6dx63ixr3i5yclqmg94qpifzfbzzn9yjj3wnikzr";
    depends = [ ];
    broken = true;
  };
  ChimpHumanBrainData = derive2 {
    name = "ChimpHumanBrainData";
    version = "1.38.0";
    sha256 = "1hgc2a7wsbw5ivdjknv82p3pvznq29lm8g4fdxy6dyr781xghs0w";
    depends = [
      affy
      hexbin
      limma
      qvalue
      statmod
    ];
    broken = true;
  };
  DREAM4 = derive2 {
    name = "DREAM4";
    version = "1.31.0";
    sha256 = "11ypc84agvq0q0v7bk0b25cm48awxay5hhhjd95gw9s7jk196i2p";
    depends = [ SummarizedExperiment ];
    broken = true;
  };
  MAQCsubsetAFX = derive2 {
    name = "MAQCsubsetAFX";
    version = "1.30.0";
    sha256 = "14mwg96g7aza81vc3hpmb41scmygl8vnsi6s8p48c8v92106asmb";
    depends = [
      affy
      Biobase
    ];
    broken = true;
  };
  MIGSAdata = derive2 {
    name = "MIGSAdata";
    version = "1.24.0";
    sha256 = "1s7fyf8n86a3znacjjs0zf22amw4rlgnvw2idld0np0yz81ggzs2";
    depends = [ ];
    broken = true;
  };
  MSstatsBioData = derive2 {
    name = "MSstatsBioData";
    version = "1.13.0";
    sha256 = "1jzypgfmd6d0fdj9ycp4jwihjpxyinr5kwi2x2dg2z6hvxx97gb8";
    depends = [ ];
    broken = true;
  };
  RLHub = derive2 {
    name = "RLHub";
    version = "1.6.0";
    sha256 = "1lx4w9m5ddzx3v4ky7yxiq7ydd0dl7xfh9fcmf53apc6fnql13h2";
    depends = [
      AnnotationHub
      ExperimentHub
    ];
    broken = true;
  };
  RNASeqRData = derive2 {
    name = "RNASeqRData";
    version = "1.16.0";
    sha256 = "17c5fvyqxdsg7wl0hy0i28z0kf2lmjg36lfrmsv51kzklsc6ykrp";
    depends = [ ];
    broken = true;
  };
  SCATEData = derive2 {
    name = "SCATEData";
    version = "1.10.0";
    sha256 = "0p0y8mkcg99dpwvp7spxx047kyr7mdflnnlfpb4i232q0yxz2z03";
    depends = [
      ExperimentHub
      GenomicAlignments
      GenomicRanges
    ];
    broken = true;
  };
  alpineData = derive2 {
    name = "alpineData";
    version = "1.26.0";
    sha256 = "1337y1y8q5y8yh2r2bji8fz3nhcxbn5s6pfnnkb8kvg8r0avgmkz";
    depends = [
      AnnotationHub
      ExperimentHub
      GenomicAlignments
    ];
    broken = true;
  };
  brainImageRdata = derive2 {
    name = "brainImageRdata";
    version = "1.12.0";
    sha256 = "072x7yn1ambf6hfpir6qdxl8bybv64blpbi1jdp0bvqlk66zs7zv";
    depends = [ ExperimentHub ];
    broken = true;
  };
  gatingMLData = derive2 {
    name = "gatingMLData";
    version = "2.38.0";
    sha256 = "1dhm48nrh1y0x6p50045cn6f21bg35i0b4z7bjymn9aw0n9r5fyk";
    depends = [ ];
    broken = true;
  };
  plasFIA = derive2 {
    name = "plasFIA";
    version = "1.26.0";
    sha256 = "0vbqjbfc75pb2gk49sl6aihmvcc38ylngyr1bgdvdxr0xh11imv0";
    depends = [ proFIA ];
    broken = true;
  };
  ppiData = derive2 {
    name = "ppiData";
    version = "0.34.0";
    sha256 = "10xbp12wim5kj1h2vkxn9x22fd92s2038w653y81jwbh2hyidybf";
    depends = [
      AnnotationDbi
      graph
    ];
    broken = true;
  };
  pwrEWAS_data = derive2 {
    name = "pwrEWAS.data";
    version = "1.14.0";
    sha256 = "1bldyvjsv5wwzasg9sbsivyi7m2ypc17mqjglsl22fjkykm92h4s";
    depends = [ ExperimentHub ];
    broken = true;
  };
  tcgaWGBSData_hg19 = derive2 {
    name = "tcgaWGBSData.hg19";
    version = "1.12.0";
    sha256 = "1kmh4iyh2h7vc1mlwb3sridn4nwkqdschz5md5dk53mxkn2wxcmi";
    depends = [
      bsseq
      ExperimentHub
      knitr
    ];
    broken = true;
  };
}
