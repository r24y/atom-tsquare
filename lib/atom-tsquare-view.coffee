{View} = require 'space-pen'
THREE = require 'three'
OrbitControls = (require 'three-orbit-controls')(THREE)
hasGL = require 'detector-webgl'

module.exports =
class AtomTsquareView extends View
  @camera: null
  @scene: null
  @renderer: null
  @material: null
  @cube: null

  initialize: ({@uri, @cadSource}) ->
    @cadSource ?= ''
    @threeInit()

  threeInit: ->
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000)
    @camera.position.x = 100
    @camera.position.y = 100
    @camera.position.z = 100

    @scene = new THREE.Scene()
    @renderer = if hasGL then new THREE.WebGLRenderer() else new THREE.CanvasRenderer()
    @renderer.setSize(window.innerWidth, window.innerHeight)
    @renderer.setClearColor 0xffffff, 1
    @threeContainer.empty()
    @threeContainer.append @renderer.domElement

    @prepareScene @scene
    @enableControl @camera
    @debug.text @cadSource
    @animate()

  animate: () ->
    requestAnimationFrame () => @animate()
    @renderer.render @scene, @camera

  prepareScene: (scene) ->
    geometry = new THREE.BoxGeometry(30, 30, 30)
    @material = material = new THREE.MeshLambertMaterial(color: 0x1166ff)

    @cube = cube = new THREE.Mesh( geometry, material )
    scene.add cube

    light = new THREE.AmbientLight(0x404040)
    scene.add( light )

    directionalLight = new THREE.DirectionalLight(0xffffff, 0.5)
    directionalLight.position.set(1, 3, 2)
    scene.add directionalLight

    directionalLight = new THREE.DirectionalLight(0xffffff, 0.1)
    directionalLight.position.set(-3, -1, -2)
    scene.add directionalLight

  enableControl: (camera) ->
    @controls = new OrbitControls camera, @renderer.domElement

  onViewResize: () ->
    @renderer.setSize(window.innerWidth, window.innerHeight)

  @content: ->
    @div =>
        @div class: "viewer", outlet: "threeContainer", resize: "onViewResize"
        @pre style: "position: absolute; top: 0; left: 0; background: transparent; color: black; pointer-events: none;", outlet: "debug"

  getURI: -> @uri
  getTitle: -> "3D - #{@uri}"

  # Tear down any state and detach
  destroy: ->
    @element.remove()
