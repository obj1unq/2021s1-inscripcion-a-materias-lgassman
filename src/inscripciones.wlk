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
}

class Cursada {
	const nota
	const property materia
}
