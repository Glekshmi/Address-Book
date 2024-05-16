<cfscript>
    poi = createObject("java", "org.apache.poi.xssf.usermodel.XSSFWorkbook");
    fileOutputStream = createObject("java", "java.io.FileOutputStream");

    workbook = poi.init();
    sheet = workbook.createSheet("DataWithImages");

    function addTextToCell(sheet, col, row, text) {
        rowRef = sheet.getRow(row);
        if (isNull(rowRef)) {
            rowRef = sheet.createRow(row);
        }
        cell = rowRef.createCell(col);
        cell.setCellValue(text);
    }

    function addImageToCell(workbook, sheet, imagePath, col, row) {
        if (fileExists(imagePath)) {
           
            fileInputStream = createObject("java", "java.io.FileInputStream").init(imagePath);
            imageByte = createObject("java", "org.apache.commons.io.IOUtils").toByteArray(fileInputStream);

            pictureIndex = workbook.addPicture(imageByte, poi.PICTURE_TYPE_PNG);
            fileInputStream.close();
            drawing = sheet.createDrawingPatriarch();
            helper = workbook.getCreationHelper();
            anchor = helper.createClientAnchor();
            anchor.setCol1(col);
            anchor.setRow1(row);
            anchor.setCol2(col + 1); 
            anchor.setRow2(row + 1); 

            picture = drawing.createPicture(anchor, pictureIndex);
            picture.resize();
        }
    }
    contacts = EntityLoad("ContactsTable")
    addTextToCell(sheet, 0, 0, "FirstName");
    addTextToCell(sheet, 1, 0, "Email");
    addTextToCell(sheet, 2, 0, "Image");

    for (i = 1; i <= arrayLen(contacts); i++) {
        user = contacts[i];
        addTextToCell(sheet, 0, i, user.getFirstName());
        addTextToCell(sheet, 1, i, user.getEmail());
        if (len(trim(user.getPhoto()))) {
            addImageToCell(workbook, sheet, user.getPhoto(), 2, i);
        }
    }

    fileOut = fileOutputStream.init("./contactDetail.xlsx");
    workbook.write(fileOut);
    fileOut.close();
</cfscript>
