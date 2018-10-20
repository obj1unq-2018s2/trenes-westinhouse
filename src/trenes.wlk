class Vagon {
	
	method pesoMaximo()

	method esLiviano() = self.pesoMaximo() < 2500
}



class VagonPasajeros inherits Vagon {
	
	const property largo = 0 //un numero
	const property ancho = 0 //un numero
	const property banios = 0 //un numero
	
	method pasajerosQuePuedeTransportar(){
		if(self.ancho() <= 2.5){ return self.largo() * 8 }
		else { return self.largo() *10 }
	}	
	override method pesoMaximo(){
		return self.pasajerosQuePuedeTransportar() * 80
	}
}

class VagonCarga  inherits Vagon {
	
	const property cargaMaxima = 0 //Es un número
	
	override method pesoMaximo() { 
		return self.cargaMaxima() + 160
	}	
	
	method banios() = 0 //Este metodo solo sirve a efectos de mantener el polimorfismo
	
	method pasajerosQuePuedeTransportar() = 0 //Mismo comentario que arriba
}


class Locomotora {
	const property peso = 0
	const property pesoMaximo = 0 //El peso maximo que puede arrastrar
	const property velocidadMaxima = 0
	
	
	method arrastreUtil() { return pesoMaximo - peso}

}


class Deposito {
	var property formaciones = null// Es un conjunto
	var property locomotoras = null// Es un conjunto
	
	method vagonesMasPesados(){
    /* Dado un depósito, devuelve el conjunto formado 
	 * por el vagon mas pesado de cada formación
	 */
	
		return formaciones.map{ formacion => formacion.vagonMasPesado()}.asSet()
	}
	
	method requiereConductorExperimentado(){
		return formaciones.any { formacion => formacion.esFormacionCompleja()}
	}
	
	
	method hayLocomotoraApropiada(formacion){
	//Devuelve True si existe una locomotora en el depósito cuyo arrastre util 
	//sea igual mayor a los kilos de empuje que faltan a "formacion"
	
		return locomotoras.any { 
			locomotora => locomotora.arrastreUtil() >= formacion.kgsDeEmpujeQueFaltan()
		}
	}
	
	method locomotoraApropiada(formacion){
	//Devuelve la locomotora en el depósito cuyo arrastre util 
	//sea igual mayor a los kilos de empuje que faltan a "formacion"
		return locomotoras.find { 
			locomotora => locomotora.arrastreUtil() >= formacion.kgsDeEmpujeQueFaltan()
		}
	}
	
	method agregarLocomotoraFuncional(formacion){
		if(!formacion.puedeMoverse() && self.hayLocomotoraApropiada(formacion)){
			formacion.agregarLocomotora(self.locomotoraApropiada(formacion))
		}
	}	
}



class Formacion {
	var property vagones = null
	var property locomotoras = null
	
	method agregarLocomotora(locomotora){
		locomotoras.add(locomotora)
	}
	
	method agregarVagon(vagon){
		vagones.add(vagon)
	}
	
	method vagonesLivianos() {
	// Devuelve la cantidad de vagones con peso inferior a 2500kg
		return vagones.filter{ vagon => vagon.pesoMaximo() < 2500 }
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
	
	method kgsDeEmpujeQueFaltan(){
	/* Devuelve un numero que indica los kilos de empuje que le falta a una
	 * formación para poder moverse. 
	 */
	 	var arrastreTotal = locomotoras.sum{ locomotora => locomotora.arrastreUtil()}
	 	var pesoMaximoVagones = vagones.sum{ vagon => vagon.pesoMaximo()}
	 	if(self.puedeMoverse()){ return 0 } 
	 	else{ return pesoMaximoVagones - arrastreTotal }
	}

	method vagonMasPesado(){
	//Devuelve el vagon con el pesoMaximo mas alto.
		return vagones.max { vagon => vagon.pesoMaximo()}
	}
	
	method esFormacionCompleja(){
	/* Devuelve True si una formacion tiene más de 20 unidades, (contando las 
	 * locomotora), o si el peso total es de mas de 10000 kg. 
	 */
	 
	 	return self.unidades() > 20 || self.pesoTotal() > 10000
	 
	}
	
	method unidades(){
	// Devuelve la cantidad de unidades que posee una formación, contando las locomotoras.
	 	return vagones.size() + locomotoras.size()
	}
	
	method pesoTotal(){
	// Devuelve el peso total entre locomotoras y vagones.
		return vagones.sum{ vagon => vagon.pesoMaximo()} +
			   locomotoras.sum{ locomotora => locomotora.pesoMaximo()}
	}
	
	method cantidadDeBanios(){
	//Devuelve la cantidad de baños totales de la formacion
	 return vagones.sum{ vagon => vagon.banios() }
	}
	
	method pasajerosTotales(){
	//Devuelve la cantidad de pasajeros totales de la formación
		return vagones.sum{ vagon => vagon.pasajerosQuePuedeTransportar()}
	}
	
	method limiteDeVelocidad()

	method velocidadMaxima() {
		if (locomotoras.min{ 
			locomotora =>
		    locomotora.velocidadMaxima()}.velocidadMaxima() > self.limiteDeVelocidad()) {
			return self.limiteDeVelocidad()} 
		else {
			return locomotoras.min{ locomotora => locomotora.velocidadMaxima() }.velocidadMaxima()
		}
	}
	
	method estaBienArmada(){
	//Devuelve un booleano indicando si la formacion puede moverse.	
		return self.puedeMoverse() 
	}
}



class FormacionDeCortaDistancia inherits Formacion  {
	
	override method limiteDeVelocidad() = 60

	override method estaBienArmada(){
	//Devuelve un booleano indicando si la formacion puede moverse.	
		return super() && !self.esFormacionCompleja()
	}

}



class FormacionDeLargaDistancia inherits Formacion {

	var ciudadesUnidas = 0 // es un numero

	override method limiteDeVelocidad(){
		if(ciudadesUnidas == 2){ return 200 }
		else{ return 150 }
	}
	
	method tieneBaniosSuficientes(){
		return self.cantidadDeBanios() >= self.pasajerosTotales() / 50
	}
	
	override method estaBienArmada(){
	//Devuelve un booleano indicando si la formacion puede moverse.
		return super() && self.tieneBaniosSuficientes()
	}
}



class FormacionDeAltaVelocidad inherits FormacionDeLargaDistancia {
	
	method todosLosVagonesSonLivianos(){ 
		return vagones.all{ vagon => vagon.esLiviano() }
	}
	override method limiteDeVelocidad(){
		return 400
	} 

	override method estaBienArmada(){
	//Devuelve un booleano indicando si la formacion puede moverse.	
		return super() && 
			   self.velocidadMaxima() > 250 && self.todosLosVagonesSonLivianos()
	}

}







