package body Semaforo_Paquete is 

	protected body Semaforo is
		entry Wait when Valor > 0 is
	begin
		Valor := Valor - 1;
	end Wait;
	
	procedure Signal is
	begin
		if Valor = 0 then
			Valor := Valor + 1;
		end if;
	end Signal;

	function Get_Valor return Natural is
		begin
			return Valor;
		end Get_Valor;
		
	end Semaforo;
	
end Semaforo_Paquete;