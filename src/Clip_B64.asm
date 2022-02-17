format PE GUI 4.0
entry start

include 'win32w.inc'

CRYPT_STRING_BASE64=1

struc myData
{
.nArgs	rd 1
.fh	rd 1
.file_size rq 1
.hMap	rd 1
.pb	rd 1
.xrb	rd 1
.glob	rd 1
}

virtual at esi
m myData
end virtual

section '.text' code readable executable
start:
	push esi edi ebp
	mov esi,Md
        invoke esi-Md+GetCommandLineW
        invoke esi-Md+CommandLineToArgvW,eax,esi
	invoke esi-Md+CreateFileW, [eax+4], GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE or FILE_SHARE_DELETE, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
	mov 	[m.fh], eax
	inc 	eax
	lea edi,[m.file_size]
	lea ebp,[m.xrb]
	jz go_ret
	invoke esi-Md+GetFileSizeEx,[m.fh],edi
	mov 	eax,dword [edi+4]
	mov 	edi,dword [edi]
	invoke esi-Md+CreateFileMappingW,[m.fh],0,PAGE_READONLY,eax,edi,0
	mov    [m.hMap],eax	
	invoke esi-Md+MapViewOfFile,eax,FILE_MAP_READ,0,0,edi
	mov    [m.pb],eax	
	invoke esi-Md+CryptBinaryToStringA,eax,edi,CRYPT_STRING_BASE64,0,ebp
	invoke esi-Md+GlobalAlloc,GMEM_MOVEABLE,[ebp]
	mov    [m.glob],eax
	invoke esi-Md+GlobalLock,eax	
	invoke esi-Md+CryptBinaryToStringA,[m.pb],edi,CRYPT_STRING_BASE64,eax,ebp
	invoke esi-Md+GlobalUnlock,[m.glob]
	invoke esi-Md+UnmapViewOfFile,[m.pb]
	invoke esi-Md+CloseHandle,[m.hMap]
	invoke esi-Md+CloseHandle,[m.fh]
	sub esi,Md-uh
	invoke esi-uh+OpenClipboard,0
	invoke esi-uh+EmptyClipboard
	invoke esi-uh+SetClipboardData,CF_TEXT,[esi-uh+Md.glob]
	invoke esi-uh+CloseClipboard
go_ret:	pop ebp edi esi
	invoke ExitProcess,0
;	ret

;section '.data' data readable writeable
section '.idata' import data readable writeable
library kernel32,'KERNEL32.DLL',\
	  user32,'USER32.DLL',\
	  shell32,'SHELL32.DLL',\
	  crypt32,'CRYPT32.DLL'

include 'api\user32.inc'
uh:

import shell32,CommandLineToArgvW,'CommandLineToArgvW'
import crypt32,CryptBinaryToStringA,'CryptBinaryToStringA'

Md myData

include 'api\kernel32.inc'
