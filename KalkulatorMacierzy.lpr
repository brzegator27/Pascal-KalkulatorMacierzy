program KalkulatorMacierzy;

uses CRT, ListaPodwojnieWiazana;

//Funkcja wypisujaca liste macierzy
function wypiszListeM(glowa : ElementP) : integer;
var kolejny : ElementP;
begin
  //Zaczynamy od elementu, ktory jest zaraz po elemencie bedacym glowa
  kolejny := glowa^.Nast;

  while kolejny <> NIL do
  begin
    Writeln('Nr: ', kolejny^.Nr, '  Wymiary: ', kolejny^.Dane^.M, ' x ', kolejny^.Dane^.N);
    kolejny := kolejny^.Nast;
    wypiszListeM := 1;
  end;
end;

//Funkcja wypisujaca macierz
//Zmienna 'macierz' wskazuje poczatkowo na element w liscie od ktorego mamy zaczac poszukiwania wlasciwej macierzy
function wypiszM(macierz : ElementP) : integer; overload;
var nr, i, j : integer;
begin
  Write('Podaj nr macierzy, ktora chcesz wypisac: '); Readln(nr);
  //Write('Tutaj0');
  macierz := szukaj(macierz, nr);
  //Write('Tutaj1');
  //Wypisujemy macierz:
  for i := 0 to macierz^.Dane^.M - 1 do
  begin
    for j := 0 to macierz^.Dane^.N - 1 do write(macierz^.Dane^.Macierz[i][j],' ');
    Writeln;
  end;
  Write('Tutaj2');

  wypiszM := 1;
end;

//Funkcja wypisujaca macierz
//Zmienna 'macierz' jest macierza, ktora chcemy wypisac
function wypiszM(macierz : ElementP; informacja : integer) : integer; overload;
var nr, i, j : integer;
begin
  //Wypisujemy macierz:
  for i := 0 to macierz^.Dane^.M - 1 do
  begin
    for j := 0 to macierz^.Dane^.N - 1 do write(macierz^.Dane^.Macierz[i][j],' ');
    Writeln;
  end;

  wypiszM := 1;
end;

//Funkcja dodajaca macierz do listy
function dodajMdoListy(po : ElementP) : ElementP; overload;
var m, n, nr, i, j : integer; nowaMacierz : ElementP;
begin
  //Uzytkownik podaje potrzebne dane macierzy:
  Write('Podaj wymiar m = '); Readln(m);
  Write('Podaj wymiar n = '); Readln(n);
  Write('Podaj nr macierzy: '); Readln(nr);

  //Dodajemy macierz do listy:
  nowaMacierz := dodaj(po, NIL, nr);
  nowaMacierz^.Dane^.M := m;
  nowaMacierz^.Dane^.N := n;


  //Tworzymy tablicę wskaźników:
  SetLength(nowaMacierz^.Dane^.Macierz,m);

  //Tworzymy kolejne tablice wierszy:
  for i := 0 to m - 1 do SetLength(nowaMacierz^.Dane^.Macierz[i],n);

  //Wypelniamy nowo utorzona macierz danymi:
  for i := 0 to m - 1 do
    for j := 0 to n - 1 do nowaMacierz^.Dane^.Macierz[i][j] := (i + j);

  nowaMacierz^.Dane^.CzyZainicjalizowana := 1;

  //Zwracamy wskaznik do elementu listy:
  dodajMdoListy := nowaMacierz;
end;

//Funkcja dodajaca do listy 'macierz', po elemencie 'po':
function dodajMdoListy(po, macierz : ElementP) : ElementP; overload;
var nr : integer;
begin
  //Uzytkownik podaje potrzebne dane macierzy:
  Write('Podaj nr macierzy: '); Readln(nr);

  //Ustawiamy nr dodawanej macierzy:
  macierz^.Nr := nr;

  if po <> NIL then
  begin
    {macierz^.Nast := po^.Nast;
    macierz^.Pop := po;
    po^.Nast := macierz;}

    macierz^.Pop := po;
    macierz^.Nast := po^.Nast;
    if po^.Nast <> NIL then po^.Nast^.Pop := macierz;
    po^.Nast := macierz;
  end;

  //Zwracamy wskaznik do elementu listy:
  dodajMdoListy := macierz;
end;

//Funkcja dodajaca PUSTA macierz do listy
function dodajMdoListy(po : ElementP; m, n, nr : integer) : ElementP; overload;
var i, j : integer; nowaMacierz : ElementP;
begin
  //Dodajemy macierz do listy:
  nowaMacierz := dodaj(po, NIL, nr);
  nowaMacierz^.Dane^.M := m;
  nowaMacierz^.Dane^.N := n;


  //Tworzymy tablicę wskaźników:
  SetLength(nowaMacierz^.Dane^.Macierz,m);

  //Tworzymy kolejne tablice wierszy:
  for i := 0 to m - 1 do SetLength(nowaMacierz^.Dane^.Macierz[i],n);

  //Macierzy nie inicjalizujemy wiec 0
  nowaMacierz^.Dane^.CzyZainicjalizowana := 0;

  //Zwracamy wskaznik do elementu listy, z nowa macierza:
  dodajMdoListy := nowaMacierz;
end;

//Funkcja dodajaca dwie macierze:
function dodajM(glowa : ElementP) : ElementP;
var nr, i, j : integer; macierz1, macierz2, macierz3 : ElementP;
begin
  wypiszListeM(glowa);
  Write('Podaj nr pierwszej macierzy, ktora chcesz dodac: '); Readln(nr);
  macierz1 := szukaj(glowa, nr);
  Write('Podaj nr drugiej macierzy, ktora chcesz dodac: '); Readln(nr);
  macierz2 := szukaj(glowa, nr);

  if (macierz1 = NIL) or (macierz2 = NIL) then
  begin
    Writeln('Jedna z macierzy nie istnieje!');
    exit(NIL);
  end;

  if (macierz1^.Dane^.M <> macierz2^.Dane^.M) or (macierz1^.Dane^.N <> macierz2^.Dane^.N) then
  begin
    dodajM := NIL;
    Writeln('Blad! Macierze powinny miec takie same wymiary!');
    dodajM := NIL
  end else
  begin
    //Tworzymy nowa pusta macierz o odpowiednich wymiarach:
    macierz3 := dodajMdoListy(glowa, macierz1^.Dane^.M, macierz1^.Dane^.N, 1001);

    //Dodajemy macierze
    for i := 0 to macierz1^.Dane^.M - 1 do
      for j := 0 to macierz1^.Dane^.N - 1 do macierz3^.Dane^.Macierz[i][j] := macierz1^.Dane^.Macierz[i][j] + macierz2^.Dane^.Macierz[i][j];

    //Wypisujemy powstala macierz:
    wypiszM(macierz3, 1);

    //Pytamy, czy uzytkownik chce zapisac macierz:
    Write('Czy chcesz zapisac macierz 1-TAK 0-NIE: '); Readln(nr);

    if nr <> 0 then
    begin
      dodajM := macierz3;
      //Uzytkownik podaje potrzebne dane macierzy:
      Write('Podaj nr macierzy: '); Readln(nr);

      //Ustawiamy nr dodawanej macierzy:
      macierz3^.Nr := nr;
    end
    else
    begin
      dodajM := NIL;
      usun(macierz3);
    end;
  end;
end;

//Funkcja mnozaca dwie macierze:
function pomnozM(glowa : ElementP) : ElementP;
var nr, i, j, k, pomocnicza : integer; macierz1, macierz2, macierz3 : ElementP;
begin
  wypiszListeM(glowa);
  Write('Podaj nr pierwszej macierzy, ktora chcesz pomnozyc: '); Readln(nr);
  macierz1 := szukaj(glowa, nr);
  Write('Podaj nr drugiej macierzy, ktora chcesz pomnozyc: '); Readln(nr);
  macierz2 := szukaj(glowa, nr);

  if (macierz1 = NIL) or (macierz2 = NIL) then
  begin
    Writeln('Jedna z macierzy nie istnieje!');
    exit(NIL);
  end;

  if macierz1^.Dane^.N <> macierz2^.Dane^.M then
  begin
    pomnozM := NIL;
    Writeln('Blad! Macierze powinny miec odpowiednie wymiary wymiary!');
  end else
  begin
    //Tworzymy nowa pusta macierz o odpowiednich wymiarach:
    macierz3 := dodajMdoListy(glowa, macierz1^.Dane^.M, macierz2^.Dane^.N, 1001);

    //Mnozymy macierze macierze
    for i := 0 to macierz1^.Dane^.M - 1 do
      for j := 0 to macierz2^.Dane^.N - 1 do
      begin
        pomocnicza := 0;
        for k := 0 to macierz1^.Dane^.N - 1 do pomocnicza := pomocnicza + macierz1^.Dane^.Macierz[i][k] * macierz2^.Dane^.Macierz[k][j];
        macierz3^.Dane^.Macierz[i][j] := pomocnicza;
      end;

    //Wypisujemy powstala macierz:
    wypiszM(macierz3, 1);

    //Pytamy, czy uzytkownik chce zapisac macierz:
    Write('Czy chcesz zapisac macierz 1-TAK 0-NIE: '); Readln(nr);

    if nr <> 0 then
    begin
      pomnozM := macierz3;
      //Uzytkownik podaje potrzebne dane macierzy:
      Write('Podaj nr macierzy: '); Readln(nr);

      //Ustawiamy nr dodawanej macierzy:
      macierz3^.Nr := nr;
    end
    else
    begin
      pomnozM := NIL;
      usun(macierz3);
    end;
  end;
end;

//Funkcja mnozaca macierz przez skalar
function skalarM(glowa : ElementP) : ElementP;
var nr, i, j, k, pomocnicza : integer; macierz1, macierz3 : ElementP;
begin
  wypiszListeM(glowa);
  Write('Podaj nr pierwszej macierzy, ktora chcesz pomnozyc przez skalar: '); Readln(nr);
  macierz1 := szukaj(glowa, nr);

  ////////////////////////////////////////////////////////////////
  //Od ponizszej linijski 'nr' jest skalarem, by oszczedzac pamiec
  ///////////////////////////////////////////////////////////////
  Write('Podaj skalar: '); Readln(nr);

  if macierz1 = NIL then
  begin
    Writeln('Podana macierz nie istnieje!');
    exit(NIL);
  end;

  //Tworzymy nowa pusta macierz o odpowiednich wymiarach:
  macierz3 := dodajMdoListy(glowa, macierz1^.Dane^.M, macierz1^.Dane^.N, 1001);

  //Mnozymy macierz przez skalar
  for i := 0 to macierz1^.Dane^.M - 1 do
    for j := 0 to macierz1^.Dane^.N - 1 do macierz3^.Dane^.Macierz[i][j] := nr * macierz1^.Dane^.Macierz[i][j];

  //Wypisujemy powstala macierz:
  wypiszM(macierz3, 1);

  //Pytamy, czy uzytkownik chce zapisac macierz:
  Write('Czy chcesz zapisac macierz 1-TAK 0-NIE: '); Readln(nr);

  if nr <> 0 then
  begin
    skalarM := macierz3;
    //Uzytkownik podaje potrzebne dane macierzy:
    Write('Podaj nr macierzy: '); Readln(nr);

    //Ustawiamy nr dodawanej macierzy:
    macierz3^.Nr := nr;
  end
  else
  begin
    skalarM := NIL;
    usun(macierz3);
  end;

end;

//Funkcja transponujaca macierz
function transponujM(glowa : ElementP) : ElementP;
var nr, i, j, k, pomocnicza : integer; macierz1, macierz3 : ElementP;
begin
  wypiszListeM(glowa);
  Write('Podaj nr pierwszej macierzy, ktora chcesz transponowac: '); Readln(nr);
  macierz1 := szukaj(glowa, nr);

  if macierz1 = NIL then
  begin
    Writeln('Podana macierz nie istnieje!');
    exit(NIL);
  end;

  //Tworzymy nowa pusta macierz o odpowiednich wymiarach:
  macierz3 := dodajMdoListy(glowa, macierz1^.Dane^.N, macierz1^.Dane^.M, 1001);

  //Mnozymy macierz przez skalar
  for i := 0 to macierz1^.Dane^.M - 1 do
    for j := 0 to macierz1^.Dane^.N - 1 do macierz3^.Dane^.Macierz[j][i] := nr * macierz1^.Dane^.Macierz[i][j];

  macierz3^.Dane^.CzyZainicjalizowana := 1;

  //Wypisujemy powstala macierz:
  wypiszM(macierz3, 1);

  //Pytamy, czy uzytkownik chce zapisac macierz:
  Write('Czy chcesz zapisac macierz 1-TAK 0-NIE: '); Readln(nr);

  if nr <> 0 then
  begin
    transponujM := macierz3;
    //Uzytkownik podaje potrzebne dane macierzy:
    Write('Podaj nr macierzy: '); Readln(nr);

    //Ustawiamy nr dodawanej macierzy:
    macierz3^.Nr := nr;
  end
  else
  begin
    transponujM := NIL;
    usun(macierz3);
  end;

end;

//Funkcja obliczajaca wyznacznik macierzy

//Funkcja potegujaca macierz

//Funkcja pobierajaca macierz z pliku
function wczytajM(glowa : ElementP) : ElementP;
var i, j, k, nr, poprawnosc : integer; sciezka, linijka : string; plik : text; macierz3 : ElementP;
begin
  //Scierzka do pliku, w ktorym jest macierz"
  sciezka := 'macierze.txt';

  assign(plik, sciezka);
  reset(plik);

  {ile_r:=1;
  r:=1;
  k:=1;}

  while not eof(plik) do
  begin
  //Na poczatku pobieramy wymiary macierzy, ktore sa w pierwszej lini pliku:
  Readln(plik, i, j);
  Writeln('i: ', i, ' j: ', j);

  //Tworzymy nowa macierz:
  macierz3 := dodajMdoListy(glowa, i, j, 1001);

  //Ktory wiersz:
  j := 0;

  while j < macierz3^.Dane^.M do
  begin
    //Czytamy linie z pliku:
    readln(plik, linijka);

    //Ktora kolumna
    k := 0;

    //Pobieramy kolejne wartosci
    for i:=1 to length(linijka) do
    begin
      if linijka[i] <> ' ' then
      begin
        Writeln('j :', j, ' k: ', k);
        ///////////////////////////////////////////////////////////////////////////////////
        //Sprawdzic poprawnosc konwersji - zmienna 'poprawnosc'
        val(linijka[i], macierz3^.Dane^.Macierz[j][k], poprawnosc);
        k := k + 1;
        //inc(k);
      end;
    end;

    j := j + 1;

  end;

  macierz3^.Dane^.CzyZainicjalizowana := 1;

  wypiszM(macierz3, 1);

  //Pytamy, czy uzytkownik chce zapisac macierz:
  Write('Czy chcesz zapisac macierz 1-TAK 0-NIE: '); Readln(nr);

  if nr <> 0 then
  begin
    wczytajM := macierz3;
    //Uzytkownik podaje potrzebne dane macierzy:
    Write('Podaj nr macierzy: '); Readln(nr);

    //Ustawiamy nr dodawanej macierzy:
    macierz3^.Nr := nr;
  end
  else
  begin
    wczytajM := NIL;
    usun(macierz3);
  end;
  end;
end;

var
  //Zmienna przechowujaca decyzje uzytkownika, o tym, co zrobic:
  coZrobic : integer;
  //Glowa listy:
  glowa : ElementP;

begin
  new(glowa);
  glowa^.Nr := 0;
  glowa^.Pop:= NIL;
  glowa^.Nast := NIL;
  //poczatek := glowa;

  //Poczatkowa inicjalizacja zmiennej coZrobic:
  coZrobic := 1;

  //Glowna petla sterujaca:
  while coZrobic <> 0 do
  begin
    Writeln('Co chcesz zrobic 1-dodaj element; 2-wypisz elementy; 3-dodaj macierze; 4-pomnoz macierze; 5-pomnoz macierz przez skalar; 6-transponuj macierz; 7-wypisz liste; 8-wczytaj macierz z pliku; 0-koniec;');
    Readln(coZrobic);

    case (coZrobic) of
    1: dodajMdoListy(glowa);
    2: wypiszM(glowa);
    3: dodajM(glowa);
    4: pomnozM(glowa);
    5: skalarM(glowa);
    6: transponujM(glowa);
    7: wypiszListeM(glowa);
    8: wczytajM(glowa);
    //4: dodaj(szukaj(poczatek, 0), NIL, 0);}
    end;
    //Write('Tutaj3');
  end;
end.

