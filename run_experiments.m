function run_experiments()

  setup;

  path_model_vgg_m = 'data/models/imagenet-vgg-m.mat';
  path_model_vgg_vd = 'data/models/imagenet-vgg-verydeep-19.mat';
  path_model_alexnet = 'data/models/imagenet-caffe-alex.mat';

  fix_load_nn(path_model_vgg_m);
  fix_load_nn(path_model_vgg_vd);
  fix_load_nn(path_model_alexnet);

  % RCNN (FC-CNN) flavors
  rcnn.name = 'rcnn' ;
  rcnn.opts = {...
    'type', 'rcnn', ...
    'model', path_model_vgg_m, ...
    'layer', 19} ;

  rcnnalx.name = 'rcnnalx' ;
  rcnnalx.opts = {...
    'type', 'rcnn', ...
    'model', path_model_alexnet, ...
    'layer', 19} ;

  rcnnvd.name = 'rcnnvd' ;
  rcnnvd.opts = {...
    'type', 'rcnn', ...
    'model', path_model_vgg_vd, ...
    'layer', 41} ;

  dcnnalx.name = 'dcnnalxfv' ;
  dcnnalx.opts = {...
    'type', 'dcnn', ...
    'model', path_model_alexnet, ...
    'layer', 13, ...
    'numWords', 64, ...
    'encoderType', 'fv'};

  dcnn.name = 'dcnnfv' ;
  dcnn.opts = {...
    'type', 'dcnn', ...
    'model', path_model_vgg_m, ...
    'layer', 13, ...
    'numWords', 64, ...
    'encoderType', 'fv'};


  dcnnbovw.name = 'dcnnbovw' ;
  dcnnbovw.opts = {...
    'type', 'dcnn', ...
    'model', path_model_vgg_m, ...
    'layer', 13, ...
    'numWords', 4096, ...
    'encoderType', 'bovw'} ;

  dcnnvlad.name = 'dcnnvlad' ;
  dcnnvlad.opts = {...
    'type', 'dcnn', ...
    'model', path_model_vgg_m, ...
    'layer', 13, ...
    'numWords', 64, ...
    'encoderType', 'vlad'} ;

  dcnnvd.name = 'dcnnvdfv' ;
  dcnnvd.opts = {...
    'type', 'dcnn', ...
    'model', path_model_vgg_vd, ...
    'layer', 35, ...
    'numWords', 64, ...
    'encoderType', 'fv'} ;

  dsift.name = 'dsift' ;
  dsift.opts = {...
    'type', 'dsift', ...
    'numWords', 256, ...
    'numPcaDimensions', 80} ;

  % Set of experiments to run
  setupNameList = {'rcnn', 'dcnn', 'dsift', 'rdcnn', 'srdcnn', 'rcnnvd', 'dcnnvd', 'rdcnnvd'} ;
  encoderList = {{rcnn}, {dcnn}, {dsift}, {rcnn dcnn}, {rcnn dcnn dsift}, {rcnnvd}, {dcnnvd}, {rcnnvd dcnnvd}} ;
  datasetList = {{'kth', 4}, {'fmd',14}, {'dtd',10}, {'voc07',1}, {'mit',1}, {'os',1}} ;

  for ii = 1 : numel(datasetList)
    dataset = datasetList{ii} ;

    if iscell(dataset)
      numSplits = dataset{2} ;
      dataset = dataset{1} ;
    else
      numSplits = 1 ;
    end

    for jj = 1 : numSplits
      for ee = 1 : numel(encoderList)
        os_train(...
          'dataset', dataset, ...
          'seed', jj, ...
          'encoders', encoderList{ee}, ...
          'prefix', 'exp02', ...
          'suffix', setupNameList{ee}, ...
          'printDatasetInfo', ee == 1, ...
          'writeResults', true, ...
          'vocDir', 'data/VOC2007', ...
          'useGpu', true, ...
     	  'gpuId', 1);
      end
    end
  end
end
