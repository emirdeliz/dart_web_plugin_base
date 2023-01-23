const Methods = {
	getBarcode: 'getBarcode',
	uploadPdf: 'uploadPdf',
};

window.jsInvokeMethod = async (args) => {
	const methodTarget = args.methodTarget;
	const result = {
		methodTarget,
		arguments: '',
	};

	switch (methodTarget) {
		case Methods.getBarcode: {
			result.arguments = '858600000012212203852130540716213509968398132948';
			break;
		}
		case Methods.uploadPdf: {
			result.file = args.file;
			break;
		}
		default: {
			result.arguments = `Unknown dart method: '${methodTarget}'`;
			break;
		}
	}
	return result;
};
