/** First Wollok example */
class Materia {
	
}

class Carrera {
	const materias
}

class Estudiante {
	const cursadasAprobadas = #{}
	const carreras = #{}
	
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
}

class Cursada {
	const property nota
	const property materia
}
