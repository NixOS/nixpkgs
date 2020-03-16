# This file is generated from generate-r-packages.R. DO NOT EDIT.
# Execute the following command to update the file.
#
# Rscript generate-r-packages.R bioc-workflows >new && mv new bioc-workflows-packages.nix

{ self, derive }:
let derive2 = derive { biocVersion = "3.10"; };
in with self; {
  BgeeCall = derive2 { name="BgeeCall"; version="1.2.1"; sha256="0v9aj4nlgx9yj2n2wpispjwlvg53b8x8mz6fnnnn73fyh0pplzmm"; depends=[biomaRt Biostrings GenomicFeatures jsonlite rhdf5 rtracklayer tximport]; };
  BiocMetaWorkflow = derive2 { name="BiocMetaWorkflow"; version="1.8.1"; sha256="1zdvnf5f5zdxpaxqn4z1dvv6qszrf6p2hr81jcnsmrl5nwbjv2jy"; depends=[]; };
  CAGEWorkflow = derive2 { name="CAGEWorkflow"; version="1.2.0"; sha256="0xbkbp0aw1vvkp7fq41qbh2mgxypj6y41vk7fzjx06hwhbjaqwdv"; depends=[CAGEfightR nanotubes]; };
  EGSEA123 = derive2 { name="EGSEA123"; version="1.10.0"; sha256="1bhpj102ncbkyx04kgmdj06r1fy9fxvc3zzi97mizn0vysvldihc"; depends=[edgeR EGSEA illuminaio limma]; };
  ExpressionNormalizationWorkflow = derive2 { name="ExpressionNormalizationWorkflow"; version="1.12.0"; sha256="0p8d1bcnzjxc1l8sbrs18jpdr8h08gx7mi69z5l3a7fq3wxv4lcy"; depends=[Biobase limma lme4 matrixStats pvca snm sva vsn]; };
  RNAseq123 = derive2 { name="RNAseq123"; version="1.10.0"; sha256="083j9rv39bhfzz4rvmv0ydiq9m9yahmmdk9n9gc733f884p79kin"; depends=[edgeR Glimma gplots limma Mus_musculus RColorBrewer]; };
  RnaSeqGeneEdgeRQL = derive2 { name="RnaSeqGeneEdgeRQL"; version="1.10.0"; sha256="0pj2wrnhsb609cw37x5jqjdk2gsv7njiibnrhw76gz1gasjyq15p"; depends=[edgeR GO_db gplots org_Mm_eg_db]; };
  SingscoreAMLMutations = derive2 { name="SingscoreAMLMutations"; version="1.2.0"; sha256="0ipjf3nia3cjfza81l6xqgb4gpzwd0zcsvp248pd1p9s8sgmrb0y"; depends=[dcanr edgeR ggplot2 gridExtra GSEABase mclust org_Hs_eg_db plyr reshape2 rtracklayer singscore SummarizedExperiment TCGAbiolinks]; };
  TCGAWorkflow = derive2 { name="TCGAWorkflow"; version="1.10.1"; sha256="1kknq2ffqz454g84pbpq7d92bg1namcnj1rznb5j3g7vgd5x7rr8"; depends=[AnnotationHub biomaRt BSgenome_Hsapiens_UCSC_hg19 c3net ChIPseeker circlize clusterProfiler ComplexHeatmap downloader DT ELMER gaia GenomeInfoDb GenomicRanges ggplot2 ggthemes knitr maftools minet motifStack MotIV pander pathview pbapply rGADEM RTCGAToolbox SummarizedExperiment TCGAbiolinks TCGAWorkflowData]; };
  annotation = derive2 { name="annotation"; version="1.10.0"; sha256="0dkbvznymbfsxsh2j5xd49hlz7fgl56wdikppc9518q725dxg650"; depends=[AnnotationHub biomaRt BSgenome BSgenome_Hsapiens_UCSC_hg19 Homo_sapiens org_Hs_eg_db org_Mm_eg_db Organism_dplyr TxDb_Athaliana_BioMart_plantsmart22 TxDb_Hsapiens_UCSC_hg19_knownGene TxDb_Hsapiens_UCSC_hg38_knownGene TxDb_Mmusculus_UCSC_mm10_ensGene VariantAnnotation]; };
  arrays = derive2 { name="arrays"; version="1.12.0"; sha256="1kly63prhqnlf2dx5bhjgcfkx943aj63wrknbdncy9zgllfmlgx8"; depends=[]; };
  chipseqDB = derive2 { name="chipseqDB"; version="1.10.0"; sha256="07gx6mxx2q4l99w9gjh76zbi6vn0a7rvl1ah2ps7bav65x0s7sb3"; depends=[]; };
  csawUsersGuide = derive2 { name="csawUsersGuide"; version="1.2.0"; sha256="011qg7mg7svpr7rsgianb1zd9a8aqmf4dlzx32csd1kbl78dsl21"; depends=[]; };
  cytofWorkflow = derive2 { name="cytofWorkflow"; version="1.10.2"; sha256="1bys33nb3l2jhqw3snkrnzj9dlnyfz143jhzz9p6llzclj64z4d7"; depends=[BiocStyle CATALYST cowplot diffcyt HDCytoData knitr readxl uwot]; };
  eQTL = derive2 { name="eQTL"; version="1.10.0"; sha256="047dq3icd9zqsy4l1kirx2w4022zigwm5pgsn9501d3jx40yp1sn"; depends=[bibtex biglm data_table doParallel foreach GenomeInfoDb GGdata GGtools knitcitations lumi lumiHumanAll_db rmeta S4Vectors scatterplot3d SNPlocs_Hsapiens_dbSNP144_GRCh37 snpStats yri1kgv]; };
  generegulation = derive2 { name="generegulation"; version="1.10.0"; sha256="1izvc9nm7iczxci8ybgdgzgcgi1c5j9c2ws7j80xblnn058nv2sh"; depends=[Biostrings BSgenome_Scerevisiae_UCSC_sacCer3 GenomicFeatures MotifDb motifStack org_Sc_sgd_db S4Vectors seqLogo TxDb_Scerevisiae_UCSC_sacCer3_sgdGene]; };
  highthroughputassays = derive2 { name="highthroughputassays"; version="1.10.0"; sha256="1i5z1f8s1iwll2m49xvkgzgf8bl11v2lpx8sgfbnfilhclxgig78"; depends=[flowCore flowStats flowWorkspace]; };
  liftOver = derive2 { name="liftOver"; version="1.10.0"; sha256="1lnc9q0wpn9xrbxcwvv7h2ihl93qy860vr9xlyx9nb5h0jsv4x66"; depends=[BiocGenerics GenomicRanges gwascat Homo_sapiens rtracklayer]; };
  maEndToEnd = derive2 { name="maEndToEnd"; version="2.6.0"; sha256="1f5nd5b9h71a478b8z57g64lihb3z6nvkzf9z78g9yphzqikmwdh"; depends=[ArrayExpress arrayQualityMetrics Biobase clusterProfiler dplyr genefilter geneplotter ggplot2 gplots hugene10sttranscriptcluster_db limma matrixStats oligo oligoClasses openxlsx pd_hugene_1_0_st_v1 pheatmap RColorBrewer ReactomePA Rgraphviz stringr tidyr topGO]; };
  methylationArrayAnalysis = derive2 { name="methylationArrayAnalysis"; version="1.10.0"; sha256="1ddbgg8q4bhiaypci3z4gllpqwynrvm340s4l7s6n99f3fb94avz"; depends=[BiocStyle DMRcate FlowSorted_Blood_450k Gviz IlluminaHumanMethylation450kanno_ilmn12_hg19 IlluminaHumanMethylation450kmanifest knitr limma matrixStats minfi minfiData missMethyl RColorBrewer rmarkdown stringr]; };
  proteomics = derive2 { name="proteomics"; version="1.10.0"; sha256="1hcl4g3adwyq1sns2nq56zx8rcd55fab7pvj09wkr939yxcn4bnx"; depends=[hpar MLInterfaces MSGFplus MSnbase MSnID mzID mzR pRoloc pRolocdata rols rpx]; };
  recountWorkflow = derive2 { name="recountWorkflow"; version="1.10.0"; sha256="0l4ia2nfiphkxhp3w0ds3mx402nv789b8s64c28fvrha1fak33wj"; depends=[bumphunter clusterProfiler derfinder derfinderPlot DESeq2 edgeR GenomicFeatures GenomicRanges gplots limma org_Hs_eg_db recount regionReport rtracklayer]; };
  rnaseqDTU = derive2 { name="rnaseqDTU"; version="1.6.0"; sha256="12nsgyh53dasczwp1s9yra8h6g2fh1fy61fk64ngjzjjvgrzav3g"; depends=[DESeq2 devtools DEXSeq DRIMSeq edgeR rafalib stageR]; };
  rnaseqGene = derive2 { name="rnaseqGene"; version="1.10.0"; sha256="0jf9rndz16db6i6ps69qnng4i9bkiarkrdcq4n9jc6qcr6jdg6mn"; depends=[airway AnnotationDbi apeglm BiocStyle DESeq2 dplyr fission genefilter ggbeeswarm ggplot2 glmpca Gviz hexbin magrittr org_Hs_eg_db pheatmap PoiClaClu RColorBrewer ReportingTools RUVSeq sva tximeta vsn]; };
  sequencing = derive2 { name="sequencing"; version="1.10.0"; sha256="0p7kz40idfakkpixdkpk9djcsy3a5wgxbjiqbnh8gkv3z6k49wia"; depends=[AnnotationHub BiocParallel Biostrings BSgenome_Hsapiens_UCSC_hg19 GenomicAlignments GenomicRanges RNAseqData_HNRNPC_bam_chr14 Rsamtools rtracklayer ShortRead VariantAnnotation]; };
  simpleSingleCell = derive2 { name="simpleSingleCell"; version="1.10.1"; sha256="0jv6d6fcr0w5kdvc9xgb8bb8lw6a8hja9m25c1gs3vqpnq6pfkv1"; depends=[]; };
  variants = derive2 { name="variants"; version="1.10.0"; sha256="168mkkbbqznyvxibzxhn3n3207936v5qfyrfqj9qik8bcrkc93qf"; depends=[BSgenome_Hsapiens_UCSC_hg19 cgdv17 org_Hs_eg_db PolyPhen_Hsapiens_dbSNP131 TxDb_Hsapiens_UCSC_hg19_knownGene VariantAnnotation]; };
}
