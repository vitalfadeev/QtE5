// ��������: ��������� � �������� ������ �� ������
// � ����������� � CP1251 ��� Windows
// 1 2 3 4 5 

S" stdlib.f" 1+ INCLUDED // ��������� ����������� ����������

// ��������� �� ������� ����� ������ �������� ������� ������ ���������� RDTC
// ��������� �������� ������ �� mOleg ����������. ��. SPF-Fork
: TIMER@ // ( --> ud )
         [ 137 B, 69 B, 252 B, 15 B, 49 B, 137 B,
           85 B, 248 B, 141 B, 109 B, 248 B, 135 B, 69 B, 0 B, ] ;
: (measure) // ( xt --> dt ) // �������� ������������ ���������� �����, ��������������� ����� xt
    TIMER@ >R >R EXECUTE TIMER@ R> R> DROP SWAP DROP - ;

// �������� Windows
IF=W Lib" CRTDLL.DLL" CrtDll
IF=W Library@ CrtDll 1 CDECL-Call" strlen"  strlen
IF=W Library@ CrtDll 2 CDECL-Call" strcmp"  strcmp
IF=W Library@ CrtDll 1 CDECL-Call" strncmp" strncmp
IF=W Library@ CrtDll 2 CDECL-Call" fputc"   putc
IF=W Library@ CrtDll 1 CDECL-Call" _fputchar"   _fputchar
IF=W Library@ CrtDll 2 CDECL-Call" fputwc"   fputwc
IF=W Library@ CrtDll 2 CDECL-Call" fputs"   fputs
IF=W Library@ CrtDll 2 CDECL-Call" fputwc"   fputwc
IF=W Library@ CrtDll 1 CDECL-Call" fgetwc"   fgetwc
IF=W Library@ CrtDll 2 CDECL-Call" fopen"   fopen
IF=W Library@ CrtDll 1 CDECL-Call" fclose"  fclose
IF=W Library@ CrtDll 0 GADR-Call" _iob"  ms6_iob

// �������� Linux
IF=L Lib" libc.so.6" libcSo
IF=L Library@ libcSo 1 CDECL-Call" strlen"  strlen
IF=L Library@ libcSo 3 CDECL-Call" printf"  printf
IF=L Library@ libcSo 2 CDECL-Call" putc"    putc
IF=L Library@ libcSo 2 CDECL-Call" fopen"   fopen
IF=L Library@ libcSo 2 CDECL-Call" fputs"   fputs
IF=L Library@ libcSo 1 CDECL-Call" fclose"  fclose

IF=W Lib" USER32.DLL" User32
IF=W Library@ User32 4 WINAPI-Call" MessageBoxA"  messagebox

IF=W LibraryLoad CrtDll
IF=W LibraryLoad User32
IF=L LibraryLoad libcSo


// : WW 2 >R S" nbv" 1+ >R S" ABC" 1+ >R 0  >R messagebox CALL_A DROP . ;
: MessageBox // ( hwnd Az_��������� Az_����� n������ -- ����� )
    messagebox
    ;
// �������� ������ ������ MessageBoxA
: testMessageBox // ( -- )
  0     // hwnd - ��� ��� �� �����, �� NULL
  S" ������ �� ForthD ���������� WinApi" 1+ // ����� ��������� 1+ ������ ������� � ������ ������
  S" ��������!" 1+        // ���������. S" ABC" --> 3 65 66 67 0    --> �� ����� ��� ������
  17                      // ��������� ���������� �������� � �������� ...
  messagebox              // ����� ����� ������� (������� ������ � stdlib.f)
  DROP                    // ������� �����, ���� �� ����� ������ ������ ....
  ;
    
// 10 .
// 0 COMMONADR@ .

// 10 COMMONADR@ DUMP
: WW 0 10 COMMONADR@ S" AS" 1+ 2 MessageBox DROP ;
// ������� ������ � VBA
// WW
// : WW 0 S" nbv" 1+ S" ABC" 1+ 2  messagebox  . ;
// 11 .

// ���������� �������� �������� �� �������� ����� 
VAR v_STDOUT        // stdout
VAR v_STDIN         // stdin
VAR v_STDERR        // stderr


IF=L (STDOUT)     v_STDOUT ! // � Linux  stdout == �++ gcc
IF=W ms6_iob 32 + v_STDOUT ! // � Winows stdout �������� ��������������� �� _iob[1];
IF=W ms6_iob      v_STDIN  ! // � Winows stdin �������� �� _iob[0];

// ��������� ������ � �������� ����� ������� ���������� stdc
: EMIT v_STDOUT @ putc DROP ; // ( N -- ) ����� ������� �� ����������� �����

: F_EMIT // ( File N -- ) ������� ������ � ����
    SWAP putc DROP ;
: CR  // ( -- ) ������� ������
IF=W 13 EMIT
     10 EMIT
    ;
: F_CR  // ( File -- ) ������� ������
    >R
IF=W R@ 13 F_EMIT
     R@ 10 F_EMIT RDROP
    ;
: TYPE  // ( Astrz N -- ) ���������� ������
    DUP B@ BEGIN DUP WHILE SWAP 1+ DUP B@ EMIT SWAP 1- REPEAT DROP DROP ;
: F_TYPE // ( File Astrz -- ) ���������� ������ � ����
    SWAP >R DUP B@ BEGIN DUP WHILE SWAP 1+ DUP B@ R@ SWAP F_EMIT SWAP 1- REPEAT
    DROP DROP RDROP ;


\ �������� ������ ����
: ������������ // ( -- )
    S" -----------------------------------------" TYPE CR
    S" Test working forth ---> " TYPE 2 5 + .
    S" -----------------------------------------" TYPE CR
    ;
������������
IF=W testMessageBox

// ������� �������� ������ ���� ����� �� D �� ����� Eval, � ����� CALL ASM
: TestForthWord
    +
    ; LATEST @ 6 COMMONADR!  // �������� ����� � 6 ����� ������ ��� ������ � D


// . . . . .