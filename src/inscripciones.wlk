/** First Wollok example */
class Materia {
	
	var property cupo = 30
	const property confirmados = []
	const property espera = []
	const property anio = 1
	const property creditos = 5
	
	method requisitosAprobados(estudiante) {
		return true		
	}
	
	method validarInscripcion(alumno) {
		if(self.enEspera(alumno) || self.confirmado(alumno)) {
			self.error("el alumno ya esta en la materia")
		}
	}
	method inscribir(alumno) {
		self.validarInscripcion(alumno)
		if(cupo > 0) {
			confirmados.add(alumno)
			cupo--
		}
		else {
			espera.add(alumno)
		}
	}
	
	method desinscribir(alumno) {
		if(self.enEspera(alumno)) {
			espera.remove(alumno)
		}
		else {
			confirmados.remove(alumno)
			if(espera.size() > 0) {
				const aConfirmar = espera.get(0)
				confirmados.add(aConfirmar)
				espera.remove(aConfirmar)
			}
			else {
				cupo++
			}
		}
	}
	
	method enEspera(alumno) {
		return espera.contains(alumno)
	}
	
	method confirmado(alumno) {
		return confirmados.contains(alumno)
	}
	
}

 
class MateriaConPrevias inherits Materia{
	const property requisitos = #{}
	
	override method requisitosAprobados(estudiante) {
		return requisitos.all({requisito => estudiante.aprobada(requisito)})
	}
}

class MateriaPorCreditos inherits Materia {
	
	const creditosNecesarios
	override method requisitosAprobados(estudiante) {
			return estudiante.creditos() >= creditosNecesarios
	}	
}

class MateriaPorAnio inherits Materia{
	
	override method requisitosAprobados(estudiante) {
			return estudiante.aproboAnioAnterior(self)
	}	
}



class Carrera {
	const property materias
	
	method contiene(materia) {
		return materias.contains(materia)
	}
	
	method materiasDelAnio(anio) {
		return materias.filter({materia=>materia.anio() == anio})
	}
}

class Estudiante {
	
	const cursadasAprobadas = #{}
	const carreras = #{}
	const materiasInscriptas = #{}
	
	method validarAprobacion(materia) {
		if(self.aprobada(materia)) {
			self.error("la materia ya está aprobada")
		}
	}
	method aprobar(materia, nota) {
		self.validarAprobacion(materia)
		cursadasAprobadas.add(new Cursada(materia=materia, nota=nota))
	}
	
	method aprobada(materia) {
		return cursadasAprobadas.any({cursada => cursada.materia() == materia})
	}
	
	method promedio() {
		return cursadasAprobadas.sum({cursada => cursada.nota()}) / self.cantidadMateriasAprobadas()
	}
	
	method cantidadMateriasAprobadas() {
		return cursadasAprobadas.size()
	}
	
	method todasLasMaterias() {
		return carreras.flatMap({carrera => carrera.materias()})
		// lo de arriba es igual a:
		//return carreras.map({carrera => carrera.materias()}).flatten().asSet()
	}
	
	method puedeInscribirse(materia) {
		return not self.inscripto(materia) and
				not self.aprobada(materia) and
				self.cursaLaCarreraDe(materia) and
				materia.requisitosAprobados(self)
	}
	
	method cursaLaCarreraDe(materia) {
		return carreras.any({carrera => carrera.contiene(materia)})
	}
	
	method inscripto (materia) {
		return materiasInscriptas.contains(materia)
	} 
	
	method validarInscripcion(materia) {
		if( not self.puedeInscribirse(materia)) {
			self.error("no se puede inscribir a esa materia")
		}
	}
	method inscribir(materia) {
		self.validarInscripcion(materia)
		materia.inscribir(self)
		materiasInscriptas.add(materia)
	}
	
	method validarDesincripcion(materia) {
		if (not self.inscripto(materia)) {
			self.error("no se puede desinscribir")
		}
	} 
	
	method desinscribir(materia) {
		self.validarDesincripcion(materia)
		materia.desinscribir(self)
		materiasInscriptas.remove(materia)
	}
	
	method creditos() {
		return cursadasAprobadas.sum({cursada => cursada.credito()})
	}
	
	method aproboAnioAnterior(materia) {
		const carrera = self.carreraDe(materia)
		const materiasAnteriores = carrera.materiasDelAnio(materia.anio() - 1)
		return materiasAnteriores.all({materiaAnterior => self.aprobada(materiaAnterior)})
	}
	
	method carreraDe(materia) {
		return carreras.find({carrera => carrera.contiene(materia)})
	}
}

class Cursada {
	const property nota
	const property materia
	method credito() {
		return materia.creditos()
	}
}
