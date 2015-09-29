with Semaforo_Paquete, Ada.Text_IO;
use Semaforo_Paquete, Ada.Text_IO;

package Direccion_Subasta is

	package Real_IO is new Float_IO(Float); use Real_IO;

	CANT_OFERTAS_A_RECORDAR : constant := 5;
	
	type T_Oferta is record
		Ofertante : Integer;
		Oferta : Float;
	end record;
	type T_Ofertas is array(0..CANT_OFERTAS_A_RECORDAR-1) of T_Oferta; --Ofertante = 0 No válido

	Duracion : Integer; --Minutos que va a durar la subasta
	Ultimas_5_Ofertas : T_Ofertas;
	Indice_Ultima_Oferta : Integer := 0; --Para manejar el array de arriba circularmente

	Sem : Semaforo;

	task type Martillero is
		entry Empezar(Precio : Float; Tiempo : Integer);
		entry A_Las;
		entry Terminar;
		entry Recibir_Oferta(ID : Integer; Oferta : Float; Consultar_Proxima_Vez : in out Boolean);
		entry Consultar_Ultimas_Ofertas(ID : Integer ; U_5_O : out T_Ofertas; Ofertas : in out Boolean);
	end Martillero;

	--Para poder ser accedido por todos los ofertantes
	Martillero_Subasta : Martillero;
	Fin_Subasta : Boolean := False;

end Direccion_Subasta;