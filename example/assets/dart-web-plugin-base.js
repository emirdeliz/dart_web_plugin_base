const Methods = {
	getBarcode: 'getBarcode',
	uploadPdf: 'uploadPdf',
};

/**
 * This method is used to send data from dart side to Js.
 * @param - args.methodTarget(required): The method will be called on the js side.
 * @param - args.arguments(optional): The generic object with the data to get on the js side.
 * @param - args.file(optional): The file like txt or pdf to get on the js side.
 */
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

// /**
//  * This method is used to send data from js side to dart.
//  * @param - args.methodTarget(required): The method will be called on the dart side.
//  * @param - args.arguments(optional): The generic object with the data to get on the dart side.
//  * @param - args.file(optional): The file like txt or pdf to get on the dart side.
//  */
// window.jsSendMessageToDart({
// 	methodTarget: 'uploadContract',
// 	arguments: { id: 13211 },
// 	file: File([], 'contract.pdf', { type: 'application/pdf' }),
// });
