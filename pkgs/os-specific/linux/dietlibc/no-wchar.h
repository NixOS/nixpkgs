diff -rc dietlibc-0.30-orig/include/wchar.h dietlibc-0.30/include/wchar.h
*** dietlibc-0.30-orig/include/wchar.h	2005-09-21 09:33:08.000000000 +0200
--- dietlibc-0.30/include/wchar.h	2006-10-20 15:04:04.000000000 +0200
***************
*** 30,99 ****
    unsigned long sofar;
  } mbstate_t;
  
- wint_t btowc(int);
- wint_t fgetwc(FILE *);
- wchar_t* fgetws(wchar_t *__restrict__, int, FILE *__restrict__);
- wint_t fputwc(wchar_t, FILE *);
- int fputws(const wchar_t *__restrict__, FILE *__restrict__);
- int fwide(FILE *, int);
- int fwprintf(FILE *__restrict__, const wchar_t *__restrict__, ...);
- int fwscanf(FILE *__restrict__, const wchar_t *__restrict__, ...);
- wint_t getwc(FILE *);
- wint_t getwchar(void);
- 
- size_t mbrlen(const char *__restrict__, size_t, mbstate_t *__restrict__);
- size_t mbrtowc(wchar_t *__restrict__, const char *__restrict__, size_t, mbstate_t *__restrict__);
- int mbsinit(const mbstate_t *);
- size_t mbsrtowcs(wchar_t *__restrict__, const char **__restrict__, size_t, mbstate_t *__restrict__);
- wint_t putwc(wchar_t, FILE *);
- wint_t putwchar(wchar_t);
- int swprintf(wchar_t *__restrict__, size_t, const wchar_t *__restrict__, ...);
- int swscanf(const wchar_t *__restrict__, const wchar_t *__restrict__, ...);
- 
- wint_t ungetwc(wint_t, FILE *);
- int vfwprintf(FILE *__restrict__, const wchar_t *__restrict__, va_list);
- int vfwscanf(FILE *__restrict__, const wchar_t *__restrict__, va_list);
- int vwprintf(const wchar_t *__restrict__, va_list);
- int vswprintf(wchar_t *__restrict__, size_t, const wchar_t *__restrict__, va_list);
- int vswscanf(const wchar_t *__restrict__, const wchar_t *__restrict__, va_list);
- int vwscanf(const wchar_t *__restrict__, va_list);
- size_t wcrtomb(char *__restrict__, wchar_t, mbstate_t *__restrict__);
- wchar_t *wcscat(wchar_t *__restrict__, const wchar_t *__restrict__);
- wchar_t *wcschr(const wchar_t *, wchar_t);
- int wcscmp(const wchar_t *, const wchar_t *);
- int wcscoll(const wchar_t *, const wchar_t *);
- wchar_t* wcscpy(wchar_t *__restrict__, const wchar_t *__restrict__);
- size_t wcscspn(const wchar_t *, const wchar_t *);
- size_t wcsftime(wchar_t *__restrict__, size_t, const wchar_t *__restrict__, const struct tm *__restrict__);
- size_t wcslen(const wchar_t *) __pure;
- wchar_t *wcsncat(wchar_t *__restrict__, const wchar_t *__restrict__, size_t);
- int wcsncmp(const wchar_t *, const wchar_t *, size_t);
- wchar_t *wcsncpy(wchar_t *__restrict__, const wchar_t *__restrict__, size_t);
- wchar_t *wcspbrk(const wchar_t *, const wchar_t *);
- wchar_t *wcsrchr(const wchar_t *, wchar_t);
- size_t wcsrtombs(char *__restrict__, const wchar_t **__restrict__, size_t, mbstate_t *__restrict__);
- size_t wcsspn(const wchar_t *, const wchar_t *);
- wchar_t *wcsstr(const wchar_t *__restrict__, const wchar_t *__restrict__);
- double wcstod(const wchar_t *__restrict__, wchar_t **__restrict__);
- float wcstof(const wchar_t *__restrict__, wchar_t **__restrict__);
- wchar_t *wcstok(wchar_t *__restrict__, const wchar_t *__restrict__, wchar_t **__restrict__);
- long wcstol(const wchar_t *__restrict__, wchar_t **__restrict__, int);
- long double wcstold(const wchar_t *__restrict__, wchar_t **__restrict__);
- long long wcstoll(const wchar_t *__restrict__, wchar_t **__restrict__, int);
- unsigned long wcstoul(const wchar_t *__restrict__, wchar_t **__restrict__, int);
- unsigned long long wcstoull(const wchar_t *__restrict__, wchar_t **__restrict__, int);
- 
- size_t wcsxfrm(wchar_t *__restrict__, const wchar_t *__restrict__, size_t);
- int wctob(wint_t);
- 
- wchar_t *wmemchr(const wchar_t *, wchar_t, size_t);
- int wmemcmp(const wchar_t *, const wchar_t *, size_t);
- wchar_t *wmemcpy(wchar_t *__restrict__, const wchar_t *__restrict__, size_t);
- wchar_t *wmemmove(wchar_t *, const wchar_t *, size_t);
- wchar_t *wmemset(wchar_t *, wchar_t, size_t);
- int wprintf(const wchar_t *__restrict__, ...);
- int wscanf(const wchar_t *__restrict__, ...);
- 
  __END_DECLS
  
  #endif
--- 30,35 ----
Only in dietlibc-0.30/include: wchar.h~
