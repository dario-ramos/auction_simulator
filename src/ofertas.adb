with Ada.Text_IO, Ada.Numerics.Float_Random, Direccion_Subasta;
use	Ada.Text_IO, Ada.Numerics.Float_Random, Direccion_Subasta;

package body Ofertas is

	task body Ofertante is
		G1,G2,G3 : Generator; --Para Random
		Ultima_Propia : Float := 0.0;
		U_5_O : T_Ofertas; --ultimas 5 ofertas
		Hice_Ultima_Oferta : Boolean := False;
		-- Para averiguar el precio actual luego de una oferta rechazada
		Consultar_Proxima_Vez : Boolean := False;
		-- Para que el martillero responda si se ha hecho al menos una oferta desde el inicio de la subasta
		Ofertas  : Boolean := False;
		Aux : Integer;
		ID : Integer; --ID del ofertante
		-- Para no hacer nada luego de recibir la notificación del fin de la subasta
		Fin_Subasta : Boolean := False;
	begin
		accept Empezar(Un_ID : Integer) do
			ID := Un_ID;
		end Empezar;
		Reset(G1); --se Cambia la semilla del Random para que no tengan todos la misma
		Reset(G2); --genera que tengan secuencias distintas
		Reset(G3);
		loop
			--Si se terminó la subasta, dejar de ofertar
			select
				accept Terminar;
				exit;
			else  if not Fin_Subasta then
					if Random(G3) > PROBILIDAD_CONSULTA or Consultar_Proxima_Vez then
						Put_Line("Ofertante " & Integer'Image(ID) & ": Cuales son las ultimas ofertas?");
						Sem.Wait; --Accedo a las últimas 5 ofertas en exclusión mutua
							Martillero_Subasta.Consultar_Ultimas_Ofertas(ID, U_5_O, Ofertas);
							if Ofertas then
								for i in 0 .. CANT_OFERTAS_A_RECORDAR -1 loop
									Aux := (Indice_Ultima_Oferta-i) mod CANT_OFERTAS_A_RECORDAR;
									if U_5_O(aux).Ofertante /= 0 then --De las 5, sólo muestro las válidas
										Put("                Ofertante "&Integer'Image(U_5_O(aux).Ofertante));
										Put(" oferto $");
										Put(U_5_O(aux).Oferta, 5, 3, 0); New_Line;
									end if;
								end loop;
							end if;
						Sem.Signal;
						Hice_Ultima_Oferta := (U_5_O(Indice_Ultima_Oferta).Ofertante = ID);
						--Mi próxima oferta será mayor o igual a la máxima actual, para eso hice la consulta
						Ultima_Propia := U_5_O(Indice_Ultima_Oferta).Oferta + Random(G1)*MAX_INCREMENTO_OFERTA;
						--La próxima vez, no consulto
						Consultar_Proxima_Vez := False;
					end if;
					if not Hice_Ultima_Oferta  then
						Ultima_Propia := Ultima_Propia + Random(G1)*MAX_INCREMENTO_OFERTA;
						Sem.Wait; --Oferto en exclusión mutua
							Put("Ofertante "&Integer'Image(ID)&": Yo doy ");
							Put(Ultima_Propia, 5, 3, 0); New_Line;
							Martillero_Subasta.Recibir_Oferta(ID, Ultima_Propia, Consultar_Proxima_Vez);
						Sem.Signal;
						delay Duration(Random(G2) * MAX_INTERVALO_ENTRE_OFERTAS);
					end if;
				end if;
			end select;
			Hice_Ultima_Oferta := False; --Para no ofrecer menos cuando no consulta
		end loop;
	end Ofertante;

end Ofertas;