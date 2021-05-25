/** First Wollok example */
class Materia {
	const requisitos = #{}
	
	method requisitosAprobados(estudiante) {
		return requisitos.all({requisito => estudiante.aprobada(requisito)})
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
	
	method aprobar(materia, nota) {
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
	
}

class Cursada {
	const property nota
	const property materia
}
