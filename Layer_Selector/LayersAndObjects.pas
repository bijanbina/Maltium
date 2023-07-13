var
   Board               : IPCB_Board;
   TheLayerStack       : IPCB_LayerStack;
   Refresh             : Boolean;
   PanelRefreshControl : Boolean;

   S, VersionStr : String;
   MajorADVersion : Integer;


// Altium Ver Code - Mattias Ericson
{procedure ReadStringFromIniFile read settings from the ini-file.....................}
function ReadStringFromIniFile(Section,Name:String,FilePath:String,IfEmpty:String):String;
var
  IniFile     : TIniFile;
begin
     result := IfEmpty;
     if FileExists(FilePath) then
     begin
          try
             IniFile := TIniFile.Create(FilePath);

             Result := IniFile.ReadString(Section,Name,IfEmpty);

          finally
                 Inifile.Free;
          end;
     end;

end;  {ReadFromIniFile end....................................................}


function Int2LabelCopper(i : Integer) : TLabel;
begin
   case i of
       1 : Result := LabelCopper1;
       2 : Result := LabelCopper2;
       3 : Result := LabelCopper3;
       4 : Result := LabelCopper4;
       5 : Result := LabelCopper5;
       6 : Result := LabelCopper6;
       7 : Result := LabelCopper7;
       8 : Result := LabelCopper8;
       9 : Result := LabelCopper9;
      10 : Result := LabelCopper10;
      11 : Result := LabelCopper11;
      12 : Result := LabelCopper12;
      13 : Result := LabelCopper13;
      14 : Result := LabelCopper14;
      15 : Result := LabelCopper15;
      16 : Result := LabelCopper16;
      17 : Result := LabelCopper17;
      18 : Result := LabelCopper18;
      19 : Result := LabelCopper19;
      20 : Result := LabelCopper20;
      21 : Result := LabelCopper21;
      22 : Result := LabelCopper22;
      23 : Result := LabelCopper23;
      24 : Result := LabelCopper24;
      25 : Result := LabelCopper25;
      26 : Result := LabelCopper26;
      27 : Result := LabelCopper27;
      28 : Result := LabelCopper28;
      29 : Result := LabelCopper29;
      30 : Result := LabelCopper30;
      31 : Result := LabelCopper31;
      32 : Result := LabelCopper32;
      33 : Result := LabelCopper33;
      34 : Result := LabelCopper34;
      35 : Result := LabelCopper35;
      36 : Result := LabelCopper36;
      37 : Result := LabelCopper37;
      38 : Result := LabelCopper38;
      39 : Result := LabelCopper39;
      40 : Result := LabelCopper40;
      41 : Result := LabelCopper41;
      42 : Result := LabelCopper42;
      43 : Result := LabelCopper43;
      44 : Result := LabelCopper44;
      45 : Result := LabelCopper45;
      46 : Result := LabelCopper46;
      47 : Result := LabelCopper47;
      48 : Result := LabelCopper48;
   end;
end;

function Int2ShapeCopper(i : Integer) : TShape;
begin
   case i of
       1 : Result := ShapeCopper1;
       2 : Result := ShapeCopper2;
       3 : Result := ShapeCopper3;
       4 : Result := ShapeCopper4;
       5 : Result := ShapeCopper5;
       6 : Result := ShapeCopper6;
       7 : Result := ShapeCopper7;
       8 : Result := ShapeCopper8;
       9 : Result := ShapeCopper9;
      10 : Result := ShapeCopper10;
      11 : Result := ShapeCopper11;
      12 : Result := ShapeCopper12;
      13 : Result := ShapeCopper13;
      14 : Result := ShapeCopper14;
      15 : Result := ShapeCopper15;
      16 : Result := ShapeCopper16;
      17 : Result := ShapeCopper17;
      18 : Result := ShapeCopper18;
      19 : Result := ShapeCopper19;
      20 : Result := ShapeCopper20;
      21 : Result := ShapeCopper21;
      22 : Result := ShapeCopper22;
      23 : Result := ShapeCopper23;
      24 : Result := ShapeCopper24;
      25 : Result := ShapeCopper25;
      26 : Result := ShapeCopper26;
      27 : Result := ShapeCopper27;
      28 : Result := ShapeCopper28;
      29 : Result := ShapeCopper29;
      30 : Result := ShapeCopper30;
      31 : Result := ShapeCopper31;
      32 : Result := ShapeCopper32;
      33 : Result := ShapeCopper33;
      34 : Result := ShapeCopper34;
      35 : Result := ShapeCopper35;
      36 : Result := ShapeCopper36;
      37 : Result := ShapeCopper37;
      38 : Result := ShapeCopper38;
      39 : Result := ShapeCopper39;
      40 : Result := ShapeCopper40;
      41 : Result := ShapeCopper41;
      42 : Result := ShapeCopper42;
      43 : Result := ShapeCopper43;
      44 : Result := ShapeCopper44;
      45 : Result := ShapeCopper45;
      46 : Result := ShapeCopper46;
      47 : Result := ShapeCopper47;
      48 : Result := ShapeCopper48;
   end;
end;

procedure RefreshPanel(dummy : String);
var
   LayerObj         : IPCB_LayerObject;
   i, j             : Integer;
   difheight		: Integer;
   getLabel            : TLabel;
   FoundCurrentLayer: Boolean;
   Shape            : TShape;
begin
   // On Show We have to set up all checkboxes based on current view
   Board := PCBServer.GetCurrentPCBBoard;

   if Board = nil then
   begin
      GroupBoxCopper.Visible  := False;
      GroupBoxCopper.Enabled  := False;

      if FormLayersPanel.Height > 400 then
         FormLayersPanel.Height := 400;
   end
   else
   begin
      GroupBoxCopper.Enabled  := True;

      TheLayerStack := Board.LayerStack;

      //Check AD version for layer stack version
      VersionStr:= ReadStringFromIniFile('Preference Location','Build',SpecialFolder_AltiumSystem+'\PrefFolder.ini','14');
      S := Copy(VersionStr,0,2);
      //ShowMessage(S);
      MajorADVersion := StrToInt(S);

      if MajorADVersion >= 14 then
      TheLayerStack := Board.LayerStack_V7;   // for AD14

      if MajorADVersion < 14 then
         TheLayerStack := Board.LayerStack;   // Older Ver of AD

      GroupBoxCopper.Top := 16;
      GroupBoxCopper.Left := 16;

      FoundCurrentLayer := False;

      // Copper
      LayerObj := TheLayerStack.FirstLayer;
      i := 1;
	  difheight := 0;
      while (LayerObj <> nil) and (i <= 48) do
      begin
		 // skip ground layers
         if (pos('GND', LayerObj.Name)>0) or (pos('Ground', LayerObj.Name)>0) then
		 begin
			Inc(i);
			LayerObj := TheLayerStack.NextLayer(LayerObj);
			continue;
		 end;
		 
		 getLabel := Int2LabelCopper(i);
         getLabel.Caption := LayerObj.Name;
		 getLabel.Visible := True;
		 		 
         Shape := Int2ShapeCopper(i);
         Shape.Visible := True;
         Shape.Enabled := True;
		 
		 // match overlays with copper layers
		 if pos('Bottom', LayerObj.Name)>0 then Board.LayerIsDisplayed[String2Layer('Bottom Overlay')] := LayerObj.IsDisplayed[Board];
		 if pos('Top', LayerObj.Name)>0    then Board.LayerIsDisplayed[String2Layer('Top Overlay')]    := LayerObj.IsDisplayed[Board];
		 
		 // layer box position
		 if difheight mod 40 = 0 then
		 begin
			shape.Left := 16;
			getLabel.Left := shape.Left + 60;
			shape.Top := 8 + 130 * (difheight div 40);
			getLabel.Top := shape.Top + 45;
		 end
		 else
		 begin
			shape.Left := 272;
			getLabel.Left := shape.Left + 60;
			shape.Top := 8 + 130 * (difheight div 40);
			getLabel.Top := shape.Top + 45;
		 end;
		 
		 // layer box and font color
		 if LayerObj.IsDisplayed[Board] then
		 Begin
			Shape.Brush.Color := Board.LayerColor[LayerObj.LayerID];
			getLabel.Font.Color := clBlack;
		 end
         else
		 Begin
			Shape.Brush.Color := clBlack;
			getLabel.Font.Color := Board.LayerColor[LayerObj.LayerID];
		 end;
		 
		 difheight := difheight + 20;
         Inc(i);
         LayerObj := TheLayerStack.NextLayer(LayerObj);
      end;
	  
	  // Now we need to modify size of copper group
	  GroupBoxCopper.Height := shape.Top + shape.Height + 20;

      FormLayersPanel.Width := 3 * GroupBoxCopper.Left + GroupBoxCopper.Width + 2;
      FormLayersPanel.Height:= GroupBoxCopper.Top + GroupBoxCopper.Height + 50;

      GroupBoxCopper.Visible  := True;

      Refresh      := True;
   end;
end;

Procedure WriteToIniFile(AFileName : String);
Var
   IniFile : TIniFile;
Begin
   IniFile := TIniFile.Create(AFileName);

   IniFile.WriteInteger('Window', 'DialogueTop',    FormLayersPanel.Top);
   IniFile.WriteInteger('Window', 'DialogueHeight', FormLayersPanel.Height);
   IniFile.WriteInteger('Window', 'DialogueLeft',   FormLayersPanel.Left);
   IniFile.WriteInteger('Window', 'DialogueWidth',  FormLayersPanel.Width);
   IniFile.Free;
End;

Procedure ReadFromIniFile(AFileName : String);
Var
   IniFile : TIniFile;
Begin
   IniFile := TIniFile.Create(AFileName);

   FormLayersPanel.Top := 100;
   FormLayersPanel.Left := 100;
   FormLayersPanel.Height     := IniFile.ReadInteger('Window', 'DialogueHeight', FormLayersPanel.Height);
   FormLayersPanel.Width      := IniFile.ReadInteger('Window', 'DialogueWidth',  FormLayersPanel.Width);

   if IniFile.ReadBool('Window', 'CopperShown', True) = False then
   begin
      GroupBoxCopper.Height := 48;
   end;

   FormLayersPanel.Height:= GroupBoxCopper.Top + GroupBoxCopper.Height + 50;
   IniFile.Free;
End;

procedure TFormLayersPanel.FormLayersPanelActivate(Sender: TObject);
begin
//   RefreshPanel('');
end;

procedure TFormLayersPanel.FormLayersPanelShow(Sender: TObject);
begin
   RefreshPanel('');
end;

function disableExtras(dummy : String);
var
   i             : Integer;
   MechLayer     : IPCB_MechanicalLayer;
begin
	// mechanical layers
	for i := 1 to 32 do
	begin
		MechLayer := TheLayerStack.LayerObject_V7[ILayer.MechanicalLayer(i)];
		if MechLayer.MechanicalLayerEnabled then
        begin
			MechLayer.IsDisplayed[Board] := False;
		end;
	end;
	// component layer pairs
	Board.LayerIsDisplayed[String2Layer('Top Solder Mask')] := False;
	Board.LayerIsDisplayed[String2Layer('Bottom Solder Mask')] := False;
	Board.LayerIsDisplayed[String2Layer('Top Paste')] := False;
	Board.LayerIsDisplayed[String2Layer('Bottom Paste')] := False;
	Board.LayerIsDisplayed[String2Layer('Drill Guide')] := False;
	Board.LayerIsDisplayed[String2Layer('Drill Drawing')] := False;
	Board.LayerIsDisplayed[String2Layer('Multi Layer')] := False;
	Board.LayerIsDisplayed[String2Layer('Keep Out Layer')] := False;
end;

Procedure Start;
var
   iniFile : TIniFile;
begin
   Board := PCBServer.GetCurrentPCBBoard;
   if Board = nil then exit;

   TheLayerStack := Board.LayerStack;
   if TheLayerStack = nil then exit;

   FormlayersPanel.Show;

   ReadFromIniFile(ClientAPI_SpecialFolder_AltiumApplicationData + '\LayersPanelScriptData.ini');
   disableExtras('');
   RefreshPanel('');
end;

procedure TFormLayersPanel.FormLayersPanelClose(Sender: TObject; var Action: TCloseAction);
begin
   WriteToIniFile(ClientAPI_SpecialFolder_AltiumApplicationData + '\LayersPanelScriptData.ini');
end;

procedure TFormLayersPanel.FormLayersPanelResize(Sender: TObject);
begin
   if FormLayersPanel.Width < 274 then
      FormLayersPanel.Width := 274
   else
   begin
      GroupBoxCopper.Width  := FormLayersPanel.Width - 50;
   end;
end;

Procedure CopperCurrent(Nr : Integer);
Var
   LayerObj : IPCB_LayerObject;
   i        : Integer;
   Shape	: TShape;
   lb		: TLabel;
begin
   LayerObj := TheLayerStack.FirstLayer;
   i := 1;

   while (LayerObj <> nil) do
   begin
      if i = Nr then
      begin
		 LayerObj.IsDisplayed[Board] := True;
		 Shape := Int2ShapeCopper(Nr);
		 lb	   := Int2LabelCopper(Nr);
         Shape.Brush.Color := Board.LayerColor[LayerObj.LayerID];
		 lb.Font.Color := clBlack;
      end
	  else
	  begin
		 LayerObj.IsDisplayed[Board] := False;
		 Shape := Int2ShapeCopper(i);
		 lb	   := Int2LabelCopper(i);
         Shape.Brush.Color := clBlack;
		 lb.Font.Color := Board.LayerColor[LayerObj.LayerID];
	  end;
	  
	  if pos('Bottom', LayerObj.Name)>0 then Board.LayerIsDisplayed[String2Layer('Bottom Overlay')] := LayerObj.IsDisplayed[Board];
	  if pos('Top', LayerObj.Name)>0    then Board.LayerIsDisplayed[String2Layer('Top Overlay')]    := LayerObj.IsDisplayed[Board];
	  
	  Board.ViewManager_FullUpdate;
	  Board.ViewManager_UpdateLayerTabs;

      Inc(i);
      LayerObj := TheLayerStack.NextLayer(LayerObj);
   end;
end;

procedure TFormLayersPanel.ShapeCopper1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(1);
end;

procedure TFormLayersPanel.ShapeCopper2MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(2);
end;

procedure TFormLayersPanel.ShapeCopper3MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(3);
end;

procedure TFormLayersPanel.ShapeCopper4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(4);
end;

procedure TFormLayersPanel.ShapeCopper5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(5);
end;

procedure TFormLayersPanel.ShapeCopper6MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(6);
end;

procedure TFormLayersPanel.ShapeCopper7MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(7);
end;

procedure TFormLayersPanel.ShapeCopper8MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(8);
end;

procedure TFormLayersPanel.ShapeCopper9MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(9);
end;

procedure TFormLayersPanel.ShapeCopper10MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(10);
end;

procedure TFormLayersPanel.ShapeCopper11MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(11);
end;

procedure TFormLayersPanel.ShapeCopper12MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(12);
end;

procedure TFormLayersPanel.ShapeCopper13MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(13);
end;

procedure TFormLayersPanel.ShapeCopper14MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(14);
end;

procedure TFormLayersPanel.ShapeCopper15MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(15);
end;

procedure TFormLayersPanel.ShapeCopper16MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(16);
end;

procedure TFormLayersPanel.ShapeCopper17MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(17);
end;

procedure TFormLayersPanel.ShapeCopper18MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(18);
end;

procedure TFormLayersPanel.ShapeCopper19MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(19);
end;

procedure TFormLayersPanel.ShapeCopper20MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(20);
end;

procedure TFormLayersPanel.ShapeCopper21MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(21);
end;

procedure TFormLayersPanel.ShapeCopper22MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(22);
end;

procedure TFormLayersPanel.ShapeCopper23MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(23);
end;

procedure TFormLayersPanel.ShapeCopper24MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(24);
end;

procedure TFormLayersPanel.ShapeCopper25MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(25);
end;

procedure TFormLayersPanel.ShapeCopper26MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(26);
end;

procedure TFormLayersPanel.ShapeCopper27MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(27);
end;

procedure TFormLayersPanel.ShapeCopper28MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(28);
end;

procedure TFormLayersPanel.ShapeCopper29MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(29);
end;

procedure TFormLayersPanel.ShapeCopper30MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(30);
end;

procedure TFormLayersPanel.ShapeCopper31MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(31);
end;

procedure TFormLayersPanel.ShapeCopper32MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(32);
end;

procedure TFormLayersPanel.ShapeCopper33MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(33);
end;

procedure TFormLayersPanel.ShapeCopper34MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(34);
end;

procedure TFormLayersPanel.ShapeCopper35MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(35);
end;

procedure TFormLayersPanel.ShapeCopper36MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(36);
end;

procedure TFormLayersPanel.ShapeCopper37MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(37);
end;

procedure TFormLayersPanel.ShapeCopper38MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(38);
end;

procedure TFormLayersPanel.ShapeCopper39MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(39);
end;

procedure TFormLayersPanel.ShapeCopper40MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(40);
end;

procedure TFormLayersPanel.ShapeCopper41MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(41);
end;

procedure TFormLayersPanel.ShapeCopper42MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(42);
end;

procedure TFormLayersPanel.ShapeCopper43MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(43);
end;

procedure TFormLayersPanel.ShapeCopper44MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(44);
end;

procedure TFormLayersPanel.ShapeCopper45MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(45);
end;

procedure TFormLayersPanel.ShapeCopper46MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(46);
end;

procedure TFormLayersPanel.ShapeCopper47MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(47);
end;

procedure TFormLayersPanel.ShapeCopper48MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   CopperCurrent(48);
end;

procedure TFormLayersPanel.FormLayersPanelMouseEnter(Sender: TObject);
begin
   if PanelRefreshControl or (Board.FileName <> PCBServer.GetCurrentPCBBoard.FileName) then
      RefreshPanel('');

   PanelRefreshControl := False;
   FormLayersPanel.Activate;
end;

procedure TFormLayersPanel.FormLayersPanelDeactivate(Sender: TObject);
begin
   PanelRefreshControl := True;
end;

procedure TFormLayersPanel.FormLayersPanelMouseLeave(Sender: TObject);
begin
   PanelRefreshControl := True;
   FormLayersPanel.Activate;
end;

procedure TFormLayersPanel.GroupBoxCopperMouseEnter(Sender: TObject);
begin
   if PanelRefreshControl or (Board.FileName <> PCBServer.GetCurrentPCBBoard.FileName) then
      RefreshPanel('');

   PanelRefreshControl := False;
   FormLayersPanel.Activate;
end;
