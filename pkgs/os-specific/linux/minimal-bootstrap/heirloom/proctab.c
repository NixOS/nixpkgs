#include <stdio.h>
#include "awk.h"
#include "y.tab.h"

static unsigned char *printname[92] = {
	(unsigned char *) "FIRSTTOKEN",	/* 258 */
	(unsigned char *) "PROGRAM",	/* 259 */
	(unsigned char *) "PASTAT",	/* 260 */
	(unsigned char *) "PASTAT2",	/* 261 */
	(unsigned char *) "XBEGIN",	/* 262 */
	(unsigned char *) "XEND",	/* 263 */
	(unsigned char *) "NL",	/* 264 */
	(unsigned char *) "ARRAY",	/* 265 */
	(unsigned char *) "MATCH",	/* 266 */
	(unsigned char *) "NOTMATCH",	/* 267 */
	(unsigned char *) "MATCHOP",	/* 268 */
	(unsigned char *) "FINAL",	/* 269 */
	(unsigned char *) "DOT",	/* 270 */
	(unsigned char *) "ALL",	/* 271 */
	(unsigned char *) "CCL",	/* 272 */
	(unsigned char *) "NCCL",	/* 273 */
	(unsigned char *) "CHAR",	/* 274 */
	(unsigned char *) "MCHAR",	/* 275 */
	(unsigned char *) "OR",	/* 276 */
	(unsigned char *) "STAR",	/* 277 */
	(unsigned char *) "QUEST",	/* 278 */
	(unsigned char *) "PLUS",	/* 279 */
	(unsigned char *) "AND",	/* 280 */
	(unsigned char *) "BOR",	/* 281 */
	(unsigned char *) "APPEND",	/* 282 */
	(unsigned char *) "EQ",	/* 283 */
	(unsigned char *) "GE",	/* 284 */
	(unsigned char *) "GT",	/* 285 */
	(unsigned char *) "LE",	/* 286 */
	(unsigned char *) "LT",	/* 287 */
	(unsigned char *) "NE",	/* 288 */
	(unsigned char *) "IN",	/* 289 */
	(unsigned char *) "ARG",	/* 290 */
	(unsigned char *) "BLTIN",	/* 291 */
	(unsigned char *) "BREAK",	/* 292 */
	(unsigned char *) "CONTINUE",	/* 293 */
	(unsigned char *) "DELETE",	/* 294 */
	(unsigned char *) "DO",	/* 295 */
	(unsigned char *) "EXIT",	/* 296 */
	(unsigned char *) "FOR",	/* 297 */
	(unsigned char *) "FUNC",	/* 298 */
	(unsigned char *) "SUB",	/* 299 */
	(unsigned char *) "GSUB",	/* 300 */
	(unsigned char *) "IF",	/* 301 */
	(unsigned char *) "INDEX",	/* 302 */
	(unsigned char *) "LSUBSTR",	/* 303 */
	(unsigned char *) "MATCHFCN",	/* 304 */
	(unsigned char *) "NEXT",	/* 305 */
	(unsigned char *) "ADD",	/* 306 */
	(unsigned char *) "MINUS",	/* 307 */
	(unsigned char *) "MULT",	/* 308 */
	(unsigned char *) "DIVIDE",	/* 309 */
	(unsigned char *) "MOD",	/* 310 */
	(unsigned char *) "ASSIGN",	/* 311 */
	(unsigned char *) "ASGNOP",	/* 312 */
	(unsigned char *) "ADDEQ",	/* 313 */
	(unsigned char *) "SUBEQ",	/* 314 */
	(unsigned char *) "MULTEQ",	/* 315 */
	(unsigned char *) "DIVEQ",	/* 316 */
	(unsigned char *) "MODEQ",	/* 317 */
	(unsigned char *) "POWEQ",	/* 318 */
	(unsigned char *) "PRINT",	/* 319 */
	(unsigned char *) "PRINTF",	/* 320 */
	(unsigned char *) "SPRINTF",	/* 321 */
	(unsigned char *) "ELSE",	/* 322 */
	(unsigned char *) "INTEST",	/* 323 */
	(unsigned char *) "CONDEXPR",	/* 324 */
	(unsigned char *) "POSTINCR",	/* 325 */
	(unsigned char *) "PREINCR",	/* 326 */
	(unsigned char *) "POSTDECR",	/* 327 */
	(unsigned char *) "PREDECR",	/* 328 */
	(unsigned char *) "VAR",	/* 329 */
	(unsigned char *) "IVAR",	/* 330 */
	(unsigned char *) "VARNF",	/* 331 */
	(unsigned char *) "CALL",	/* 332 */
	(unsigned char *) "NUMBER",	/* 333 */
	(unsigned char *) "STRING",	/* 334 */
	(unsigned char *) "FIELD",	/* 335 */
	(unsigned char *) "REGEXPR",	/* 336 */
	(unsigned char *) "GETLINE",	/* 337 */
	(unsigned char *) "RETURN",	/* 338 */
	(unsigned char *) "SPLIT",	/* 339 */
	(unsigned char *) "SUBSTR",	/* 340 */
	(unsigned char *) "WHILE",	/* 341 */
	(unsigned char *) "CAT",	/* 342 */
	(unsigned char *) "NOT",	/* 343 */
	(unsigned char *) "UMINUS",	/* 344 */
	(unsigned char *) "POWER",	/* 345 */
	(unsigned char *) "DECR",	/* 346 */
	(unsigned char *) "INCR",	/* 347 */
	(unsigned char *) "INDIRECT",	/* 348 */
	(unsigned char *) "LASTTOKEN",	/* 349 */
};


Cell *(*proctab[92])(Node **, int) = {
	nullproc,	/* FIRSTTOKEN */
	program,	/* PROGRAM */
	pastat,	/* PASTAT */
	dopa2,	/* PASTAT2 */
	nullproc,	/* XBEGIN */
	nullproc,	/* XEND */
	nullproc,	/* NL */
	array,	/* ARRAY */
	matchop,	/* MATCH */
	matchop,	/* NOTMATCH */
	nullproc,	/* MATCHOP */
	nullproc,	/* FINAL */
	nullproc,	/* DOT */
	nullproc,	/* ALL */
	nullproc,	/* CCL */
	nullproc,	/* NCCL */
	nullproc,	/* CHAR */
	nullproc,	/* MCHAR */
	nullproc,	/* OR */
	nullproc,	/* STAR */
	nullproc,	/* QUEST */
	nullproc,	/* PLUS */
	boolop,	/* AND */
	boolop,	/* BOR */
	nullproc,	/* APPEND */
	relop,	/* EQ */
	relop,	/* GE */
	relop,	/* GT */
	relop,	/* LE */
	relop,	/* LT */
	relop,	/* NE */
	instat,	/* IN */
	arg,	/* ARG */
	bltin,	/* BLTIN */
	jump,	/* BREAK */
	jump,	/* CONTINUE */
	delete,	/* DELETE */
	dostat,	/* DO */
	jump,	/* EXIT */
	forstat,	/* FOR */
	nullproc,	/* FUNC */
	sub,	/* SUB */
	gsub,	/* GSUB */
	ifstat,	/* IF */
	sindex,	/* INDEX */
	nullproc,	/* LSUBSTR */
	matchop,	/* MATCHFCN */
	jump,	/* NEXT */
	arith,	/* ADD */
	arith,	/* MINUS */
	arith,	/* MULT */
	arith,	/* DIVIDE */
	arith,	/* MOD */
	assign,	/* ASSIGN */
	nullproc,	/* ASGNOP */
	assign,	/* ADDEQ */
	assign,	/* SUBEQ */
	assign,	/* MULTEQ */
	assign,	/* DIVEQ */
	assign,	/* MODEQ */
	assign,	/* POWEQ */
	print,	/* PRINT */
	aprintf,	/* PRINTF */
	awsprintf,	/* SPRINTF */
	nullproc,	/* ELSE */
	intest,	/* INTEST */
	condexpr,	/* CONDEXPR */
	incrdecr,	/* POSTINCR */
	incrdecr,	/* PREINCR */
	incrdecr,	/* POSTDECR */
	incrdecr,	/* PREDECR */
	nullproc,	/* VAR */
	nullproc,	/* IVAR */
	getnf,	/* VARNF */
	call,	/* CALL */
	nullproc,	/* NUMBER */
	nullproc,	/* STRING */
	nullproc,	/* FIELD */
	nullproc,	/* REGEXPR */
	getline,	/* GETLINE */
	jump,	/* RETURN */
	split,	/* SPLIT */
	substr,	/* SUBSTR */
	whilestat,	/* WHILE */
	cat,	/* CAT */
	boolop,	/* NOT */
	arith,	/* UMINUS */
	arith,	/* POWER */
	nullproc,	/* DECR */
	nullproc,	/* INCR */
	indirect,	/* INDIRECT */
	nullproc,	/* LASTTOKEN */
};

unsigned char *tokname(int n)
{
	static unsigned char buf[100];

	if (n < FIRSTTOKEN || n > LASTTOKEN) {
		snprintf((char *)buf, sizeof buf, "token %d", n);
		return buf;
	}
	return printname[n-257];
}
