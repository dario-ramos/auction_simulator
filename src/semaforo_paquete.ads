package Semaforo_Paquete is 

	protected type Semaforo is
		entry Wait;
		procedure Signal;
		function Get_Valor return Natural;
	private
		Valor : Natural := 1; --TODO inicializar esde afuera aunque nunca lo usemos
	end Semaforo;	

end Semaforo_Paquete;