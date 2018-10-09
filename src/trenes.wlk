class VagonPasajeros {
	
	const property largo = 0 //un numero
	const property ancho = 0 //un numero
	
	method pasajerosQuePuedeTransportar(){
		if(self.ancho() <= 2.5){ return self.largo() * 8 }
		else { return self.largo() *10 }
	}	
	method pesoMaximo(){
		return self.pasajerosQuePuedeTransportar() * 80
	}
}

class VagonCarga {
	
	const property cargaMaxima = 0 //Es un número
	
	method pesoMaximo() { 
		return self.cargaMaxima() + 160
	}	
}


class Locomotora {
	const property peso = 0
	const property pesoMaximo = 0 //El peso maximo que puede arrastrar
	const property velocidadMaxima = 0
	
	
	method arrastreUtil() { return pesoMaximo - peso}
	
	
	

}

class Formacion {
	var property vagones = null
	var property locomotoras = null
	
	method vagonesLivianos() {
	// Devuelve la cantidad de vagones con peso inferior a 2500kg
		return vagones.filter{ vagon => vagon.pesoMaximo() < 2500 }
	}
	
	method velocidadMaxima() {
	//Devuelve el mínimo entre las velocidades máximas de las locomotoras.
		return locomotoras.min { locomotora => locomotora.velocidadMaxima() }
	}
	
	method esFormacionEficiente(){
	/* Devuelve un booleano indicando si cada una de las locomotoras arrastra
	 * al menos 5 veces su peso 
	 * */
	 
	 	return locomotoras.all { 
	 		locomotora => locomotora.pesoMaximo() >= locomotora.peso() * 5
	 	}
	}
	
	method puedeMoverse(){
	/* Devuelve un booleano indicando si el arrastre útil total de las locomotoras
	 * es mayor o igual al peso máximo total de los vagones.
	 */
	 
	 	var arrastreTotal = locomotoras.sum{ locomotora => locomotora.arrastreUtil()}
	 	var pesoMaximoVagones = vagones.sum{ vagon => vagon.pesoMaximo()}
	 	return arrastreTotal >= pesoMaximoVagones
	 
	}
	
}










