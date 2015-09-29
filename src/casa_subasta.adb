with Direccion_Subasta, Ofertas, Ada.Text_IO, Ada.Command_Line, Ada.Calendar, Ada.Numerics.Float_Random;
use	Direccion_Subasta, Ofertas, Ada.Text_IO, Ada.Command_Line, Ada.Calendar, Ada.Numerics.Float_Random;

procedure Casa_Subasta is
	--Constantes simb�licas
	SEGUNDOS_EN_UN_MINUTO : constant := 60.0; --TODO
	PRECIO_POR_DEFECTO : constant := 0.0;
	DURACION_POR_DEFECTO : constant := 1;
	MAX_CANT_OFERTANTES : constant := 5;
	--Variables locales
	Ofertantes : array (1 .. MAX_CANT_OFERTANTES) of Ofertante;
	Precio : Float;
	Tiempo : Integer;
	Cant_Ofertantes : Natural := 0;
	Hora_Finalizacion : Time;
	G : Generator;
begin
	if Argument_Count < 2 then
		Precio := PRECIO_POR_DEFECTO;
		Tiempo := DURACION_POR_DEFECTO;
	else
		--Argumento 1: Precio Inicial (float, en pesos)
		--Argumento 2: Duraci�n de la subasta (integer, en minutos)
		Precio := Float'Value(Argument(1));
		Tiempo := Integer'Value(Argument(2));
	end if;
	-- La hora de finalizaci�n de la subasta es la actual (Clock) + La duraci�n (en segundos)
	Hora_Finalizacion := Clock + Duration(Float(Tiempo) * SEGUNDOS_EN_UN_MINUTO);
	Martillero_Subasta.Empezar(Precio , Tiempo);
	 --Inicializo la semilla del generador aleatorio (lo voy a usar en en while)
	Reset(G);
	-- Mientras no haya llegado la hora de terminar y no se haya excedido la capacidad m�xima, siguen llegando ofertantes.
	while Clock < Hora_Finalizacion and Cant_Ofertantes < MAX_CANT_OFERTANTES loop
		Cant_Ofertantes := Cant_Ofertantes + 1;
		Ofertantes(Cant_Ofertantes).Empezar(Cant_Ofertantes); --Se asigna ID seg�n orden de llegada
		-- El tiempo m�ximo entre ofertantes es la capacidad m�xima sobre la duraci�n, si es que se desea que se alcance la m�xima capacidad
		delay Duration(Random(G) * Float(MAX_CANT_OFERTANTES)/(Float(Tiempo)*SEGUNDOS_EN_UN_MINUTO));
	end loop;
	--Dejo que el Martillero y los oferentes interactu�n durante la duraci�n de la subasta
	delay Duration(Tiempo * SEGUNDOS_EN_UN_MINUTO);
	Martillero_Subasta.A_Las;
	--Se termin� el tiempo : Aviso a los oferentes que termin� la subasta
	--Primero, a los que no llegaron a tiempo:
	for i in Cant_Ofertantes + 1 .. MAX_CANT_OFERTANTES loop
		Ofertantes(i).Empezar(i);
		Ofertantes(i).Terminar;
	end loop;
	--Luego, a los que s� llegaron a hacer ofertas
	for i in 1 .. MAX_CANT_OFERTANTES loop
		Ofertantes(i).Terminar;
	end loop;
	--Ahora s�, termin� la subasta
	Martillero_Subasta.Terminar;
end Casa_Subasta;