Program FileManager;
uses CRT, DOS;

Procedure MainMenu(path: string);
var
      DirInfo: SearchRec;
      k, stdWidth, cntStr: integer;

const
      Attrib: array[0..6] of byte = ($04, $05, $06, $07, $24, $25, $26);

BEGIN
      stdWidth:= 15;
      ClrScr;
      TextColor(White);
      writeln('Current path: ' + path);
      writeln('|----|------------------|-------------------|');
      writeln('| No |        Name      |        Size       |');
      writeln('|----|------------------|-------------------|');
      cntStr:= 0;
      FindFirst(path + '*.*', AnyFile, DirInfo);
      while (DosError = 0) AND (cntStr < 19) do
        begin
          write('| ', cntStr+1:2, ' |  ');
          for k:= 0 to 6 do
              if (DirInfo.Attr = Attrib[k]) then
                 TextColor(Green);
          write(DirInfo.Name:stdWidth);
          TextColor(White);
          write(' |   ', DirInfo.Size:10, '  B   |');
          writeln;
          FindNext(DirInfo);
          inc(cntStr);
        end;
      writeln('|-------------------------------------------|');
END;

var
    path, filename, searchWord: string;
    numWord, i, j: integer;
    answer: char;
    start: boolean;
    F: file;
    buf: array[0..4096] of char;
    numRead: word;

BEGIN
    start:= true;
    path:= 'C:\';
    while (start) do
      begin
        MainMenu(path);
        write('Continue execution? [y/n]: ');
        readln(answer);
        if (answer = 'n') then
        begin
          start:= false;
          break;
        end
        else if (answer = 'y') then
          begin
            start:= true;
            write('Enter path: ');
            readln(path);
            MainMenu(path);
            write('Enter filename: ');
            readln(filename);
            Assign(F, path + filename);
            {$I-}
            Reset(F, 1);
            {$I+}
            if (IOResult <> 0) then
            begin
               write('File open error! Application will shutdown...');
               readln;
               break;
            end;
            write('Enter a search word: ');
            readln(searchWord);
            numWord:= 0;
            Repeat
               BlockRead(F, buf, SizeOf(buf), NumRead);
                 j:= 1;
                 for i:= 0 to NumRead do
                     if buf[i] = searchWord[j] then
                     if j < length(searchWord) then
                       inc(j)
                     else
                       begin
                         inc(numWord);
                         j:= 1;
                       end
                     else
                       j:= 1;
            Until NumRead < SizeOf(buf);
            Close(F);
            writeln('Number of search words in the file: ', numWord);
            write('Press any key to continue...');
            readln;
          end;
      end;
END.