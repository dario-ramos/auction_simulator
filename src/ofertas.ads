with Text_IO;
use Text_IO;

package Ofertas is

	package Real_IO is new Float_IO(Float); use Real_IO;

	--Máximo intervalo, en segundos, entre dos ofertas de un mismo oferente.
	MAX_INTERVALO_ENTRE_OFERTAS : constant := 10.0;
	MAX_INCREMENTO_OFERTA : constant := 100.0;
	PROBILIDAD_CONSULTA  : constant := 0.3;

	task type Ofertante is
		entry Empezar(Un_ID : Integer); --TODO: Positive / Natural
		entry Terminar;
	end Ofertante;

end Ofertas;