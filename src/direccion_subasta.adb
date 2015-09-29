with Ada.Text_IO;
use	Ada.Text_IO;

package body Direccion_Subasta is

	task body Martillero is
		Hay_Ofertas : Boolean := False;
	begin
		accept Empezar(Precio : Float ; Tiempo : Integer) do
			Ultimas_5_Ofertas(Indice_Ultima_Oferta).Oferta := Precio;
			Duracion := Tiempo;
		end Empezar;
		Put_Line("        Martillero: SE INICIA LA SUBASTA");	
		Put("        Martillero: Precio inicial de la subasta: ");
		Put(Ultimas_5_Ofertas(Indice_Ultima_Oferta).Oferta, 5, 3, 0);
		Put_Line(" pesos.");
		 Put_Line("        Martillero: Duracion de la subasta: "& Integer'Image(Duracion) & " minuto/s");
		loop 
			select
				accept A_Las do
					Put_Line("        Martillero: A LA 1, A LAS 2 y A LAS...");
					-- El martillero deja de aceptar ofertas
					Fin_Subasta := True;
				end A_Las;
			or
				accept Terminar;
					exit;
			or
				accept Consultar_Ultimas_Ofertas(ID : Integer; U_5_O : out T_Ofertas; Ofertas : in out Boolean) do
					if not Hay_Ofertas then
						Put_Line("        Martillero (a ofertante " & Integer'Image(ID) & "): Aun no se han hecho ofertas validas");
					else
						Put_Line("        Martillero (a ofertante " & Integer'Image(ID) & "): Ultimas 5 ofertas validas:");
					end if;
					U_5_O := Ultimas_5_Ofertas;
					Ofertas := Hay_Ofertas;
				end Consultar_Ultimas_Ofertas;
			or
				accept Recibir_Oferta(ID : Integer; Oferta:float; Consultar_Proxima_Vez : in out Boolean) do
					--Ignoro ofertas menores a la ultima
					if Ultimas_5_Ofertas(Indice_Ultima_Oferta).Oferta < Oferta and not Fin_Subasta then
						Indice_Ultima_Oferta := (Indice_Ultima_Oferta + 1) mod CANT_OFERTAS_A_RECORDAR;
						Ultimas_5_Ofertas(Indice_Ultima_Oferta).Oferta := Oferta;
						Ultimas_5_Ofertas(Indice_Ultima_Oferta).Ofertante := ID;
						Hay_Ofertas := True;
					else
						if Fin_Subasta then
							Put_Line("        Martillero (a ofertante"&Integer'Image(ID)&") : Ya no se reciben ofertas");
							Consultar_Proxima_Vez := False;
						else
							Put_Line("        Martillero (a ofertante"&Integer'Image(ID)&") : Oferta menor al precio actual; se ignora");
							Consultar_Proxima_Vez := True;
						end if;
					end if;
				end Recibir_Oferta;
			end select;
		end loop;
		Put("3!!!... VENDIDO AL OFERTANTE..." & Integer'Image(Ultimas_5_Ofertas(Indice_Ultima_Oferta).Ofertante) &
		" POR EL VALOR DE ");
		Put(Ultimas_5_Ofertas(Indice_Ultima_Oferta).Oferta, 5, 3, 0);
		Put_Line("!!!");
	end Martillero;

end Direccion_Subasta;