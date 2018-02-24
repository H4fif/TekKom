unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ValEdit, ExtDlgs, FileCtrl, DBGrids, DB,
  DBTables, Buttons;

type
  //a = (,d,e,f,g,h,i,j,k);
  TForm1 = class(TForm)
    LbTkList: TLabel;
    LFile: TLabel;
    LLink: TLabel;
    LbProcess: TLabel;
    LbStat: TLabel;
    MTeksInput: TMemo;
    BtOpen: TButton;
    SGToken: TStringGrid;
    MProses: TMemo;
    MStatus: TMemo;
    BtTokenizer: TButton;
    OpenDialog1: TOpenDialog;
    SGIdent: TStringGrid;
    LbIsiFile: TLabel;
    LbIdent: TLabel;
    BtReset: TButton;
    BtParser: TButton;
    procedure BtOpenClick(Sender: TObject);
    procedure BtTokenizerClick(Sender: TObject);
    procedure BtResetClick(Sender: TObject);
//-----------------------------------------------------------------------------
//PARSER
    procedure deklarasi_kamus();
    procedure kamus();
    procedure program_dekl();
    procedure main_program();
    procedure cek_terminal(terminal: string);
//-----------------------------------------------------------------------------
    procedure BtParserClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    s: string;
    myFile : TextFile;
    IdentLists : array [0..100] of string;
    token : string;
    index : integer;
  end;

var
  Form1: TForm1;
  const
    plus = '+';
    minus = '-';
    times = '*';
    andop = '&';
    pangkat = '^';
    persen = '%';
    dollar = '$';
    tagar = '#';
    at = '@';
    tseru = '!';
    ttanya = '?';
    tbackslash = '\';


implementation

{$R *.dfm}



procedure TForm1.BtOpenClick(Sender: TObject);
begin
  //OpenDialog1.Filter := 'Only Text Files|*.txt';
  //OpenDialog1.FilterIndex := 1;
  if (Not (OpenDialog1.Execute)) then
    Abort
  else
  begin
    BtReset.Click;
    LLink.Caption := OpenDialog1.FileName;
    s := ExtractFileName(OpenDialog1.FileName);
    AssignFile(myFile, s);
    Reset(myFile);
    MTeksInput.Lines.LoadFromFile(s);
    CloseFile(myFile);
  end;
end;

//procedure

procedure TForm1.BtTokenizerClick(Sender: TObject);
var
  ch, underscore, space : char;
  bl : boolean;
  st, cmp : string;
  i, hitung, CountIdent, x: integer;
  AlphUpCase : set of char;
  AlphLoCase : set of char;
  Numbers : set of char;
  find_id : integer;
label
  lanjut, lbchar, lanjut2, lbtypestring;

begin
  //LECSYCAL ANALYSIS (SCANNER)
  MProses.Lines.Clear;
  AlphUpCase := ['A'..'Z'];
  AlphLoCase := ['a'..'z'];
  Numbers := ['0'..'9'];
  underscore := Char(95);
  space := Char(32);
  
  if (MTeksInput.Text = '') then
    abort
  else
  begin
  AssignFile(myFile, s);
  Reset(myFile);
  i := 1;
  hitung := 0;
  CountIdent := 0;

  //only read pascal operators and symbols
  repeat
    read(myFile,ch);
    lanjut:
    {check if input's character is alphabet}
    if (ch in AlphLoCase) or (ch in AlphUpCase) or (ch = underscore) then
    begin
      st := EmptyStr;
      cmp := EmptyStr;
      st := ch;
      read(myFile,ch);

      while (ch in AlphUpCase) or (ch in AlphLoCase) or (ch in Numbers) or (ch = underscore) do
      begin
        st := st + ch;
        read(myFile,ch);
      end;

      SGToken.Cells[0,i] :=  IntToStr(i);
      cmp := LowerCase(st);

      if (cmp = 'and') then
        SGToken.Cells[2,i] := 'andsy'
      else if (cmp = 'array') then
        SGToken.Cells[2,i] := 'arraysy'
      else if (cmp = 'assign') then
        SGToken.Cells[2,i] := 'assignsy'
      else if (cmp = 'begin') then
        SGToken.Cells[2,i] := 'beginsy'
      else if (cmp = 'case') then
        SGToken.Cells[2,i] := 'casesy'
      else if (cmp = 'char') then
        SGToken.Cells[2,i] := 'charcon'
      else if (cmp = 'const') then
        SGToken.Cells[2,i] := 'constsy'
      else if (cmp = 'div') then
        SGToken.Cells[2,i] := 'idiv'
      else if (cmp = 'do') then
        SGToken.Cells[2,i] := 'dosy'
      else if (cmp = 'downto') then
        SGToken.Cells[2,i] := 'downtosy'
      else if (cmp = 'else') then
        SGToken.Cells[2,i] := 'elsesy'
      else if (cmp = 'end') then
        SGToken.Cells[2,i] := 'endsy'
      else if (cmp = 'eof') then
        SGToken.Cells[2,i] := 'eofsy'
      else if (cmp = 'file') then
        SGToken.Cells[2,i] := 'filesy'
      else if (cmp = 'for') then
        SGToken.Cells[2,i] := 'forsy'
      else if (cmp = 'function') then
        SGToken.Cells[2,i] := 'functionsy'
      else if (cmp = 'if') then
        SGToken.Cells[2,i] := 'ifsy'
      else if (cmp = 'integer') then
        SGToken.Cells[2,i] := 'intcon'
      else if (cmp = 'mod') then
        SGToken.Cells[2,i] := 'imod'
      else if (cmp = 'not') then
        SGToken.Cells[2,i] := 'notsy'
      else if (cmp = 'of') then
        SGToken.Cells[2,i] := 'ofsy'
      else if (cmp = 'or') then
        SGToken.Cells[2,i] := 'orsy'
      else if (cmp = 'procedure') then
        SGToken.Cells[2,i] := 'proceduresy'
      else if (cmp = 'program') then
        SGToken.Cells[2,i] := 'programsy'
      else if (cmp = 'read') then
        SGToken.Cells[2,i] := 'readsy'
      else if (cmp = 'real') then
        SGToken.Cells[2,i] := 'realcon'
      else if (cmp = 'record') then
        SGToken.Cells[2,i] := 'recordsy'
      else if (cmp = 'repeat') then
        SGToken.Cells[2,i] := 'repeatsy'
      else if (cmp = 'reset') then
        SGToken.Cells[2,i] := 'resetsy'
      else if (cmp = 'string') then
        SGToken.Cells[2,i] := 'stringt'
      else if (cmp = 'then') then
        SGToken.Cells[2,i] := 'thensy'
      else if (cmp = 'to') then
        SGToken.Cells[2,i] := 'tosy'
      else if (cmp = 'type') then
        SGToken.Cells[2,i] := 'typesy'
      else if (cmp = 'until') then
        SGToken.Cells[2,i] := 'untilsy'
      else if (cmp = 'var') then
        SGToken.Cells[2,i] := 'varsy'
      else if (cmp = 'while') then
        SGToken.Cells[2,i] := 'whilesy'
      else if (cmp = 'write') then
        SGToken.Cells[2,i] := 'writesy'
      else
      begin
        {if ((CountIdent-1) > 0) then
        begin
          x := 0;
          find_id := -1;

          while {((find_id = -1) and (x <= High(IdentLists)) do
          begin
            if (st = IdentLists[x]) then
            //begin
              //Inc(x);
              break
            //end
            else
              Inc(x);
          end;
        end;

        if (find_id = -1) then
          IdentLists[x] := st;}

        Inc(CountIdent);
        SGToken.Cells[2,i] :=  'Ident';
        SGIdent.Cells[0,CountIdent] :=  IntToStr((CountIdent));
        SGIdent.Cells[1,CountIdent] :=  st;
        if (CountIdent = SGIdent.RowCount)  then
          SGIdent.RowCount := SGIdent.RowCount+1;
      end;
      SGToken.Cells[1,i] := st;
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
      GoTo lanjut;
    end
    else
    //lanjut:
    if (ch in Numbers) then
    begin
      st := EmptyStr;
      st := ch;
      read(myFile,ch);
      while (ch in Numbers) do
      begin
        st := st + ch;
        read(myFile,ch);
      end;
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := st;
      SGToken.Cells[2,i] := 'typeint';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
      GoTo lanjut;
    end
    else if (ch = space) or (ch = Null) or (ch = Char(0)) or (ch = Char(9)) or (ch = Char(10)) or (ch = Char(13)) then
      //do nothing
      //continue
    else
    //lbchar:
    if (ch = Char(39)) then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := Char(39);
      SGToken.Cells[2,i] := 'singlequotesy';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
      read(myFile,ch);

      if (ch in AlphUpCase) or (ch in AlphLoCase) then
      begin
        st := EmptyStr;
        st := ch;
        read(myFile,ch);
        if (ch = Char(39)) then
        begin
          SGToken.Cells[0,i] := IntToStr(i);
          SGToken.Cells[1,i] := st;
          SGToken.Cells[2,i] := 'typechar';
          if (i = SGToken.RowCount)  then
            SGToken.RowCount := SGToken.RowCount+1;
          Inc(i);
          Inc(hitung);
        end
        else
          GoTo lanjut;
      end;
      //else
        GoTo lanjut;
    end
    else
    //lbtypestring:
    if (ch = Char(34)) then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := Char(34);
      SGToken.Cells[2,i] := 'doublequotesy';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);

      read(myFile,ch);
      if (ch in AlphUpCase) or (ch in AlphLoCase) then
      begin
        st := EmptyStr;
        st := ch;
        read(myFile,ch);
        while (ch in AlphUpCase) or (ch in AlphLoCase) or (ch = '.') or (ch = Char(32)) or (ch = '<') or (ch = '=') or (ch = '>') do
        begin
          st := st + ch;
          read(myFile,ch);
        end;
        if (ch = Char(34)) then
        begin
          SGToken.Cells[0,i] := IntToStr(i);
          SGToken.Cells[1,i] := st;
          SGToken.Cells[2,i] := 'typestring';
          if (i = SGToken.RowCount)  then
            SGToken.RowCount := SGToken.RowCount+1;
          Inc(i);
          Inc(hitung);
        end
        else
          GoTo lanjut;
        //GoTo lbtypestring;
      end
      else
        GoTo lanjut;
    end
    else if (ch = '<') then
	  	begin
        read(myFile,ch);
			  if (ch = '=') then                                        
        begin
  				SGToken.Cells[0,i] := IntToStr(i);
          SGToken.Cells[1,i] := '<=';
          SGToken.Cells[2,i] := 'leg';
          if (i = SGToken.RowCount)  then
            SGToken.RowCount := SGToken.RowCount+1;
          Inc(i);
          Inc(hitung);
        end
  			else if (ch = '>') then
        begin
          SGToken.Cells[0,i] := IntToStr(i);
          SGToken.Cells[1,i] := '<>';
          SGToken.Cells[2,i] := 'neg';
          if (i = SGToken.RowCount)  then
            SGToken.RowCount := SGToken.RowCount+1;
          Inc(i);
          Inc(hitung);
        end
  			else
        begin
          SGToken.Cells[0,i] := IntToStr(i);
          SGToken.Cells[1,i] := '<';
          SGToken.Cells[2,i] := 'lss';
          if (i = SGToken.RowCount)  then
            SGToken.RowCount := SGToken.RowCount+1;
          Inc(i);
          Inc(hitung);
          GoTo lanjut;
        end;
      end
      else if (ch = '>') then
      begin
        read(myFile,ch);
        if (ch = '=') then
        begin
          SGToken.Cells[0,i] := IntToStr(i);
          SGToken.Cells[1,i] := '>=';
          SGToken.Cells[2,i] := 'geg';
          if (i = SGToken.RowCount)  then
            SGToken.RowCount := SGToken.RowCount+1;
          Inc(i);
          Inc(hitung);
        end
        else
        begin
          SGToken.Cells[0,i] := IntToStr(i);
          SGToken.Cells[1,i] := '>';
          SGToken.Cells[2,i] := 'gtr';
          if (i = SGToken.RowCount)  then
            SGToken.RowCount := SGToken.RowCount+1;
          Inc(i);
          Inc(hitung);
          GoTo lanjut;
        end;
      end
      else if (ch = ':') then
      begin
        read(myFile,ch);
        if (ch = '=') then
        begin
          SGToken.Cells[0,i] := IntToStr(i);
          SGToken.Cells[1,i] := ':=';
          SGToken.Cells[2,i] := 'becomes';
          if (i = SGToken.RowCount)  then
            SGToken.RowCount := SGToken.RowCount+1;
          Inc(i);
          Inc(hitung);
        end
        else
        begin
          SGToken.Cells[0,i] := IntToStr(i);
          SGToken.Cells[1,i] := ':';
          SGToken.Cells[2,i] := 'colon';
          if (i = SGToken.RowCount)  then
            SGToken.RowCount := SGToken.RowCount+1;
          Inc(i);
          Inc(hitung);
          GoTo lanjut;
        end;
      end
      else if (ch = '=') then
      begin
        SGToken.Cells[0,i] := IntToStr(i);
        SGToken.Cells[1,i] := ch;
        SGToken.Cells[2,i] := 'egl';
        if (i = SGToken.RowCount)  then
          SGToken.RowCount := SGToken.RowCount+1;
        Inc(i);
        Inc(hitung);
    end
    else if (ch = '+') then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := ch;
      SGToken.Cells[2,i] := 'plus';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
    end
    else if (ch = '-') then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := ch;
      SGToken.Cells[2,i] := 'minus';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
    end
    else if (ch = '*') then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := ch;
      SGToken.Cells[2,i] := 'times';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
    end
    else if (ch = '/') then
    begin
      read(myFile,ch);
      if (ch = '/') then
      begin
        SGToken.Cells[0,i] := IntToStr(i);
        SGToken.Cells[1,i] := '//';
        SGToken.Cells[2,i] := 'commentsy';
        if (i = SGToken.RowCount)  then
          SGToken.RowCount := SGToken.RowCount+1;
        Inc(i);
        Inc(hitung);
        st := EmptyStr;
        read(myFile,ch);
        while (ch <> Char(10)) do
        begin
          st := st+ch;
          read(myFile,ch);
        end;
        SGToken.Cells[0,i] := IntToStr(i);
        SGToken.Cells[1,i] := st;
        SGToken.Cells[2,i] := 'comments';
        if (i = SGToken.RowCount)  then
          SGToken.RowCount := SGToken.RowCount+1;
        Inc(i);
        Inc(hitung);
        //GoTo lanjut;
      end
      else
      begin
        SGToken.Cells[0,i] := IntToStr(i);
        SGToken.Cells[1,i] := ch;
        SGToken.Cells[2,i] := 'rdiv';
        if (i = SGToken.RowCount)  then
          SGToken.RowCount := SGToken.RowCount+1;
        Inc(i);
        Inc(hitung);
        GoTo lanjut;
      end;
    end
    else if (ch = '(') then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := ch;
      SGToken.Cells[2,i] := 'lparent';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
    end
    else if (ch = ')') then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := ch;
      SGToken.Cells[2,i] := 'rparent';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
    end
    else if (ch = '[') then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := ch;
      SGToken.Cells[2,i] := 'lbrack';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
    end
    else if (ch = ']') then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := ch;
      SGToken.Cells[2,i] := 'rbrack';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
    end
    else if (ch = ',') then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := ch;
      SGToken.Cells[2,i] := 'comma';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
    end
    else if (ch = '.') then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := ch;
      SGToken.Cells[2,i] := 'period';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
    end
    else if (ch = ';') then
    begin
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := ch;
      SGToken.Cells[2,i] := 'semicolon';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
    end
    else
    begin
      st := EmptyStr;
      st := ch;
      SGToken.Cells[0,i] := IntToStr(i);
      SGToken.Cells[1,i] := st;
      SGToken.Cells[2,i] := 'Unknown';
      if (i = SGToken.RowCount)  then
        SGToken.RowCount := SGToken.RowCount+1;
      Inc(i);
      Inc(hitung);
    end;
  until (Eof(myFile));
  CloseFile(myFile);
  MProses.Lines.Add('Total : '+IntToStr(hitung)+' token(s).');
  end;//endif
end;

procedure TForm1.BtResetClick(Sender: TObject);
var
  i : integer;
begin
  for i := SGToken.RowCount downto 1 do
      SGToken.Rows[i].Clear;
  for i := SGIdent.RowCount downto 1 do
      SGIdent.Rows[i].Clear;
  MTeksInput.Clear;
  MProses.Clear;
  MStatus.Clear;
  LLink.Caption := '';
  for i := Low(IdentLists) to High(IdentLists) do
    IdentLists[i] := EmptyStr;
end;

//-----------------------------------------------------------------------------
//PARSER

procedure TForm1.deklarasi_kamus();
label
  lb1;
begin
  lb1:
  cek_terminal('Ident');
  if token = 'colon' then
    cek_terminal('colon')
  else if token = 'comma' then
  begin
    cek_terminal('comma');
    GoTo lb1;
  end;
  
  if token = 'intcon' then
    cek_terminal('intcon')
  else if token = 'charcon' then
    cek_terminal('charcon')
  else if token = 'realcon' then
    cek_terminal('realcon')
  else if token = 'stringt' then
    cek_terminal('stringt');

  cek_terminal('semicolon');
  if token = 'Ident' then
    deklarasi_kamus();
  MStatus.Lines.Add('>>deklarasi kamus');
end;

procedure TForm1.kamus();
begin
  cek_terminal('varsy');
  deklarasi_kamus();
  MStatus.Lines.Add('>>kamus');
end;

procedure TForm1.program_dekl();
begin
  cek_terminal('programsy');
  cek_terminal('Ident');
  cek_terminal('semicolon');
  MStatus.Lines.Add('>>program declaration');
end;

procedure TForm1.main_program();
begin
  program_dekl();
  kamus();
end;

procedure TForm1.cek_terminal(terminal: string);
begin
  if (terminal = token) then
  begin
    if ('>>kamus' = MStatus.Lines.Strings[MStatus.Lines.Count-1]) then
    begin
      MStatus.Lines.Add('Parsing success.');
      abort;
    end;

    //ShowMessage(MStatus.Text);
    //abort;
    //ShowMessage(MStatus.Lines.Strings[MStatus.Lines.Count-1]);
    //Inc(index);
    //token := SGToken.Cells[2,index];
  end
  else
  begin
    MStatus.Lines.Add('Parsing Error!');
    MStatus.Lines.Add('Token = '+token+' is not a terminal');
    //MStatus.Lines.Add('Parsing aborted.');
    if (SGToken.RowCount-1 = index) then
      abort;
  end;
  Inc(index);
  //index := index + 1;
  token := SGToken.Cells[2,index];
  //MStatus.Lines.Add(IntToStr(index));
end;

procedure TForm1.BtParserClick(Sender: TObject);
begin
  MStatus.Clear;
  index := 1;
  if (SGToken.Cells[2,index] = EmptyStr) then
    abort;
  MStatus.Lines.Add('Parsing start.');
  token := SGToken.Cells[2,index];
  main_program();
  //program_dekl();
  //kamus();
end;
//----------------------------------------------------------------------------
procedure TForm1.FormCreate(Sender: TObject);
begin
  SGToken.Cells[0,0] := 'No';
  SGToken.Cells[1,0] := 'Token';
  SGToken.Cells[2,0] := 'Jenis Token';

  SGIdent.Cells[0,0] := 'No';
  SGIdent.Cells[1,0] := 'Identifier';
end;

end.
