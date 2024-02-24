class_name MeshWorker extends Node

enum ExportState {
	COMPUTE_MESH,
	WRITE_FILE,
	DONE
}

var _progress: ProgressionNotifier
var _thread: Thread
var _overlay: OverlayUI
var _next_export_step: ExportState = ExportState.DONE

var _mesh: BaseMesh
var _file_path: String
var _image: LithoImage

func _init(overlay: OverlayUI):
	_overlay = overlay
	_progress = ProgressionNotifier.new()

func _process(_delta):
	if _thread != null:
		if _progress.is_done:
			_progress.is_done = false
			_thread.wait_to_finish()
			_thread = null
			_next_step()
		else:
			_overlay.set_max_progress(_progress.total_progress)
			_overlay.set_progress(_progress.current_progress)

func _next_step():
	match _next_export_step:
		ExportState.COMPUTE_MESH:
			_next_export_step = ExportState.WRITE_FILE
			_overlay.open_overlay("Export...\n\nComputing Mesh...")
			_overlay.show_progress(true)
			_overlay.set_max_progress(0)
			_overlay.set_progress(0)
			_thread = Thread.new()
			_thread.start(_thread_compute_mesh)
			
		ExportState.WRITE_FILE:
			_next_export_step = ExportState.DONE
			_overlay.open_overlay("Export...\n\nWriting STL file....")
			_overlay.show_progress(true)
			_overlay.set_max_progress(0)
			_overlay.set_progress(0)
			_thread = Thread.new()
			_thread.start(_thread_write_file)
			
		ExportState.DONE:
			_overlay.close_overlay()
			_mesh = null
			_file_path = ""
			_image = null
		
		
func save_as_stl(mesh: BaseMesh, file_path: String, image: LithoImage) -> bool:
	if _thread != null:
		return false
		
	_mesh = mesh
	_file_path = file_path
	_next_export_step = ExportState.COMPUTE_MESH
	_image = image
	_next_step()
	
	return true
	
	
func _thread_compute_mesh():
	print("Computing mesh...")
	_mesh.compute_mesh(_image, _progress)


func _thread_write_file():
	print("Write file '%s'" % _file_path)
	_mesh.to_stl(_file_path, _progress)
