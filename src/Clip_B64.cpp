#include "stdafx.h"

#pragma comment(lib, "Crypt32.lib")  
#pragma comment(lib, "Shell32.lib")  

INT WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR pCmdLine, int nCmdShow) {
	DWORD rb=0;
	int nArgs = 0;
	LPTSTR * lp=NULL;
	LPWSTR * args = CommandLineToArgvW(GetCommandLineW(), &nArgs);
	HANDLE h = CreateFile(args[1], GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (h == INVALID_HANDLE_VALUE) return -1;
	LARGE_INTEGER file_size = {}; GetFileSizeEx(h, &file_size);
	HANDLE hMap=CreateFileMappingW(h, NULL, PAGE_READONLY, file_size.HighPart, file_size.LowPart, NULL);
	DWORD rd = file_size.LowPart;
	LPBYTE pb = (LPBYTE)MapViewOfFile(hMap, FILE_MAP_READ, 0, 0, rd);
	CryptBinaryToStringA(pb, rd, CRYPT_STRING_BASE64, NULL, &rb);

	HGLOBAL glob=GlobalAlloc(GMEM_MOVEABLE, rb);
	CryptBinaryToStringA(pb, rd, CRYPT_STRING_BASE64, (LPSTR)GlobalLock(glob), &rb);
	GlobalUnlock(glob);
	UnmapViewOfFile(pb);
	CloseHandle(hMap);
	CloseHandle(h);

	OpenClipboard(0);
	EmptyClipboard();
	SetClipboardData(CF_TEXT, glob);
	CloseClipboard();

	return 0;
}
