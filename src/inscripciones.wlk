/** First Wollok example */
class Materia {
	const requisitos = #{}
	
	var property cupo = 30
	const property confirmados = []
	const property espera = []
	const property estrategiaEspera = estrategiaCola
	
	method requisitosAprobados(estudiante) {
		return requisitos.all({requisito => estudiante.aprobada(requisito)})
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
				const aConfirmar = estrategiaEspera.proximo(espera)
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

object estrategiaCola {
	
	method proximo(lista) {
		return lista.get(0)
	}
}

object estrategiaElitista {
	
	method proximo(lista) {
		return lista.max({estudiante => estudiante.promedio()})
	}
	
}

object estrategiaAvance {
	
	method proximo(lista) {
		return lista.max({estudiante => estudiante.cantidadMateriasAprobadas()})
	}
	
}



class Carrera {
	const property materias
	
	method contiene(materia) {
		return materias.contains(materia)
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
		const cantidad = self.cantidadMateriasAprobadas()
		return if (cantidad > 0) cursadasAprobadas.sum({cursada => cursada.nota()}) / cantidad else 0
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
	
}

class Cursada {
	const property nota
	const property materia
}
